import 'package:savingor_app/features/scanner/data/receipt_ocr_parser.dart';
import 'package:savingor_app/features/scanner/domain/models/receipt_ocr_result.dart';

/// Layout-aware receipt parser using OCR line geometry.
class ReceiptOcrLayoutParser {
  static const double _defaultYOverlapTolerance = 18;
  static const double _weightContinuationMaxGap = 56;

  static final RegExp _standalonePrice = RegExp(
    r'^\$?\s*(\d{1,4}(?:,\d{3})*\.\d{2}|\d+\.\d{2})\s*$',
  );

  static final RegExp _packageSize = RegExp(
    r'\b\d+\s*(?:g|kg|ml|l|pk|ct|ea)\b',
    caseSensitive: false,
  );

  static final RegExp _perUnitRate = RegExp(
    r'/\s*(?:kg|g|lb|l)\b',
    caseSensitive: false,
  );

  static final RegExp _weightDetailLine = RegExp(
    r'^\d+\.?\d*\s*kg\s+@',
    caseSensitive: false,
  );

  static final RegExp _leadingQuantity = RegExp(
    r'^(\d+)\s+([A-Za-z].+)$',
  );

  static final RegExp _isoDate = RegExp(
    r'(\d{4})[-/](\d{1,2})[-/](\d{1,2})',
  );

  static final RegExp _usDate = RegExp(
    r'(\d{1,2})[/](\d{1,2})[/](\d{4})',
  );

  static const List<String> _subtotalKeywords = <String>[
    'subtotal',
    'sub total',
    'sub-total',
  ];

  static const List<String> _taxKeywords = <String>[
    'gst',
    'hst',
    'pst',
    'qst',
    'tax',
  ];

  static const List<String> _metadataKeywords = <String>[
    'store:',
    'register:',
    'cashier:',
    'receipt',
    'trans',
    'transaction',
    'debit',
    'change',
    'approved',
    'thank',
    'www.',
    'http',
    'tel',
    'phone',
    'acct',
    'card number',
    'auth',
    'aid',
    'tvr',
    'tsi',
    'terminal',
    'type:',
  ];

  static final RegExp _streetHint = RegExp(
    r'\b(st|street|ave|avenue|rd|road|blvd|boulevard|dr|drive|ln|lane|way|crt|court|ct|hwy|highway)\b',
    caseSensitive: false,
  );

  static final RegExp _timeLabel = RegExp(
    r'^time\s*[:]',
    caseSensitive: false,
  );

  static final RegExp _refLabel = RegExp(
    r'\bref\b',
    caseSensitive: false,
  );

  static final RegExp _embeddedTime = RegExp(
    r'\d{1,2}:\d{2}',
  );

  ParsedReceiptData parse(ReceiptOcrResult result) {
    if (!result.hasGeometry ||
        result.lines.every((ReceiptOcrLine l) => !l.hasGeometry)) {
      return ReceiptOcrParser().parse(result.rawText);
    }

    final List<_GeomLine> geomLines = result.lines
        .where((ReceiptOcrLine line) =>
            line.hasGeometry && line.text.trim().isNotEmpty)
        .map(_GeomLine.fromOcrLine)
        .toList(growable: false);

    if (geomLines.isEmpty) {
      return ReceiptOcrParser().parse(result.rawText);
    }

    final double maxRight = geomLines
        .map((_GeomLine line) => line.right)
        .reduce((double a, double b) => a > b ? a : b);
    final double rightColumnThreshold = maxRight * 0.52;

    final List<_GeomLine> priceLines = geomLines
        .where((_GeomLine line) =>
            _isStandalonePriceLine(line, rightColumnThreshold))
        .toList(growable: false);

    final List<_GeomLine> textLines = geomLines
        .where((_GeomLine line) =>
            !_isStandalonePriceLine(line, rightColumnThreshold))
        .toList(growable: false);

    final ({String? name, _GeomLine? sourceLine}) store = _extractStoreName(
      textLines,
      priceLines,
      rightColumnThreshold,
    );
    final String? storeName = store.name;
    final _GeomLine? storeSourceLine = store.sourceLine;
    final DateTime? date = _extractDate(result.rawText);

    final Map<_GeomLine, _GeomLine> weightContinuationMap =
        _buildWeightContinuationMap(textLines, rightColumnThreshold);

    final double productSectionStartY = _findProductSectionStartY(
      textLines,
      priceLines,
      rightColumnThreshold,
      storeSourceLine,
      weightContinuationMap,
    );

    final Set<_GeomLine> usedPrices = <_GeomLine>{};
    final List<ParsedReceiptLineItem> products = <ParsedReceiptLineItem>[];
    ParsedReceiptLineItem? pendingWeightProduct;

    final List<_GeomLine> productCandidates = textLines
        .where((_GeomLine line) => _isProductCandidateLine(
              line,
              storeName: storeName,
              storeSourceLine: storeSourceLine,
              productSectionStartY: productSectionStartY,
            ))
        .toList(growable: false)
      ..sort(
        (_GeomLine a, _GeomLine b) =>
            a.visualSortKey.compareTo(b.visualSortKey),
      );

    for (final _GeomLine productLine in productCandidates) {
      if (_isWeightDetailLine(productLine.text)) {
        _applyWeightDetail(pendingWeightProduct, productLine.text);
        continue;
      }

      final _ProductCluster cluster = _buildCluster(
        productLine,
        weightContinuationMap,
      );

      final double? lineTotal = _pairPriceForCluster(
        cluster,
        priceLines,
        usedPrices,
        rightColumnThreshold,
      );

      final _ParsedNameQuantity parsedName =
          _parseLeadingQuantity(productLine.text);

      final ParsedReceiptLineItem item = ParsedReceiptLineItem(
        name: parsedName.name,
        quantity: parsedName.quantity,
        lineTotal: lineTotal,
        unitPrice: lineTotal != null &&
                parsedName.quantity != null &&
                parsedName.quantity! > 0
            ? lineTotal / parsedName.quantity!
            : lineTotal,
      );

      products.add(item);
      pendingWeightProduct = item;
    }

    final double? subtotal = _extractLabelAmount(
      textLines,
      priceLines,
      usedPrices,
      rightColumnThreshold,
      _subtotalKeywords,
    );
    final double? tax = _extractLabelAmount(
      textLines,
      priceLines,
      usedPrices,
      rightColumnThreshold,
      _taxKeywords,
      excludeSubtotal: true,
    );
    final double? total = _extractTotalAmount(
      textLines,
      priceLines,
      usedPrices,
      rightColumnThreshold,
    );

    final ({double? subtotal, double? tax, double? total}) sequentialTotals =
        _applySequentialTotalsIfNeeded(
      subtotal: subtotal,
      tax: tax,
      total: total,
      priceLines: priceLines,
      usedPrices: usedPrices,
      rightColumnThreshold: rightColumnThreshold,
    );

    return ParsedReceiptData(
      storeName: storeName,
      date: date,
      subtotal: sequentialTotals.subtotal,
      tax: sequentialTotals.tax,
      total: sequentialTotals.total,
      lineItems: products,
      rawText: result.rawText,
    );
  }

  static bool _isStandalonePriceLine(
      _GeomLine line, double rightColumnThreshold) {
    final String trimmed = line.text.trim();
    if (!_standalonePrice.hasMatch(trimmed)) return false;
    if (_packageSize.hasMatch(trimmed) || _perUnitRate.hasMatch(trimmed)) {
      return false;
    }
    return line.centerX >= rightColumnThreshold;
  }

  static bool _isProductCandidateLine(
    _GeomLine line, {
    required String? storeName,
    required _GeomLine? storeSourceLine,
    required double productSectionStartY,
  }) {
    final String trimmed = line.text.trim();
    if (!_isProductCandidate(trimmed)) return false;
    if (line == storeSourceLine) return false;
    if (storeName != null && _isSameMerchant(trimmed, storeName)) return false;
    if (_isFooterMessage(trimmed)) return false;
    if (_isTransactionMetadata(trimmed)) return false;
    if (_isAddressFragment(trimmed)) return false;
    if (line.centerY < productSectionStartY - 4) return false;
    return true;
  }

  static bool _isProductCandidate(String text) {
    final String trimmed = text.trim();
    if (trimmed.isEmpty) return false;
    if (_isWeightDetailLine(trimmed)) return false;
    if (_isLabelLine(trimmed)) return false;
    if (_shouldIgnoreMetadata(trimmed)) return false;
    if (_standalonePrice.hasMatch(trimmed)) return false;
    if (_looksLikeAmountOnly(trimmed)) return false;
    return _hasPlausibleProductName(trimmed);
  }

  static bool _isLabelLine(String text) {
    final String lower = text.trim().toLowerCase();
    if (_subtotalKeywords.any(lower.contains)) return true;
    if (_taxKeywords.any(lower.contains) && !lower.contains('subtotal')) {
      return true;
    }
    if (RegExp(r'\btotal\b').hasMatch(lower) && !lower.contains('subtotal')) {
      return true;
    }
    return false;
  }

  static bool _shouldIgnoreMetadata(String text) {
    final String lower = text.toLowerCase();
    if (_metadataKeywords.any(lower.contains)) return true;
    if (RegExp(r'^store\s*[:#]').hasMatch(lower)) return true;
    if (RegExp(r'^register\s*[:#]').hasMatch(lower)) return true;
    if (RegExp(r'^date\s*[:]').hasMatch(lower) && _extractDate(text) != null) {
      return true;
    }
    if (RegExp(r'^\d{5,}$').hasMatch(text.trim())) return true;
    if (RegExp(r'^\d+\s+[A-Za-z]').hasMatch(text) &&
        _streetHint.hasMatch(lower)) {
      return true;
    }
    if (RegExp(r'^[A-Za-z\s]+,\s*[A-Z]{2}\b').hasMatch(text)) return true;
    if (RegExp(r'\b(nw|ne|sw|se)\b', caseSensitive: false).hasMatch(lower) &&
        RegExp(r'^\d+').hasMatch(text)) {
      return true;
    }
    return false;
  }

  static bool _isWeightDetailLine(String text) {
    return _weightDetailLine.hasMatch(text.trim());
  }

  static void _applyWeightDetail(ParsedReceiptLineItem? product, String text) {
    if (product == null) return;
    final RegExpMatch? rateMatch = RegExp(
      r'@\s*\$?\s*(\d+(?:\.\d+)?)\s*/\s*(?:kg|g|lb|l)',
      caseSensitive: false,
    ).firstMatch(text);
    if (rateMatch == null) return;

    final double? rate = double.tryParse(rateMatch.group(1)!);
    if (rate == null) return;

    final RegExpMatch? weightMatch =
        RegExp(r'^(\d+\.?\d*)\s*kg', caseSensitive: false).firstMatch(text);
    if (weightMatch != null) {
      final double? weight = double.tryParse(weightMatch.group(1)!);
      if (weight != null) {
        // Weight detail enriches the parent product; line total comes from pairing.
      }
    }
  }

  static bool _isAddressFragment(String text) {
    final String lower = text.toLowerCase();
    if (_streetHint.hasMatch(lower)) return true;
    if (RegExp(r'^\d+\s+[A-Za-z]').hasMatch(text) &&
        (_streetHint.hasMatch(lower) ||
            RegExp(r'\b(nw|ne|sw|se)\b', caseSensitive: false)
                .hasMatch(lower))) {
      return true;
    }
    return false;
  }

  static bool _isTransactionMetadata(String text) {
    final String lower = text.toLowerCase().trim();
    if (_timeLabel.hasMatch(lower)) return true;
    if (_refLabel.hasMatch(lower) && RegExp(r'[#:]\s*\d').hasMatch(lower)) {
      return true;
    }
    if (RegExp(r'^receipt\s*[:#]').hasMatch(lower)) return true;
    if (RegExp(r'^\d{10,}$').hasMatch(text.trim())) return true;
    if (_embeddedTime.hasMatch(text) &&
        RegExp(r'^(time|date)\s*[:]', caseSensitive: false).hasMatch(lower)) {
      return true;
    }
    return false;
  }

  static bool _isFooterMessage(String text) {
    final String lower = text.toLowerCase();
    if (RegExp(r'\bmerci\b').hasMatch(lower)) return true;
    if (lower.contains('thank you')) return true;
    if (lower.contains('thanks for')) return true;
    if (lower.contains('shopping with us')) return true;
    if (lower.contains('chez metro') && lower.contains('magasin')) {
      return true;
    }
    return false;
  }

  static bool _isSameMerchant(String text, String storeName) {
    final String normText = _normalizeStoreName(text).toLowerCase();
    final String normStore = storeName.toLowerCase();
    if (normText == normStore) return true;
    if (normStore.startsWith('metro') && normText.startsWith('metro')) {
      return true;
    }
    if (normText.contains('supermarket') && normStore.startsWith('metro')) {
      return true;
    }
    return false;
  }

  static _ProductCluster _buildCluster(
    _GeomLine productLine,
    Map<_GeomLine, _GeomLine> weightContinuationMap,
  ) {
    return _ProductCluster(
      productLine: productLine,
      weightContinuation: weightContinuationMap[productLine],
    );
  }

  /// Maps each weight/rate continuation row to the nearest product row above it.
  static Map<_GeomLine, _GeomLine> _buildWeightContinuationMap(
    List<_GeomLine> textLines,
    double rightColumnThreshold,
  ) {
    final List<_GeomLine> weightLines = textLines
        .where((_GeomLine line) => _isWeightDetailLine(line.text))
        .toList(growable: false)
      ..sort(
        (_GeomLine a, _GeomLine b) =>
            a.visualSortKey.compareTo(b.visualSortKey),
      );

    final List<_GeomLine> leftColumnLines = textLines
        .where(
          (_GeomLine line) =>
              !_isWeightDetailLine(line.text) &&
              line.centerX < rightColumnThreshold,
        )
        .toList(growable: false)
      ..sort(
        (_GeomLine a, _GeomLine b) =>
            a.visualSortKey.compareTo(b.visualSortKey),
      );

    final Map<_GeomLine, _GeomLine> map = <_GeomLine, _GeomLine>{};
    final Set<_GeomLine> assignedWeights = <_GeomLine>{};

    for (final _GeomLine weightLine in weightLines) {
      if (assignedWeights.contains(weightLine)) continue;

      _GeomLine? bestProduct;
      double bestGap = double.infinity;

      for (final _GeomLine productLine in leftColumnLines) {
        if (map.containsKey(productLine)) continue;
        if (productLine.top >= weightLine.top) continue;
        if (productLine.blockIndex != weightLine.blockIndex) continue;

        final double gap = weightLine.top - productLine.bottom;
        if (gap < -6 || gap > _weightContinuationMaxGap) continue;

        if (gap < bestGap) {
          bestGap = gap;
          bestProduct = productLine;
        }
      }

      if (bestProduct != null) {
        map[bestProduct] = weightLine;
        assignedWeights.add(weightLine);
      }
    }

    return map;
  }

  static double _findProductSectionStartY(
    List<_GeomLine> textLines,
    List<_GeomLine> priceLines,
    double rightColumnThreshold,
    _GeomLine? storeSourceLine,
    Map<_GeomLine, _GeomLine> weightContinuationMap,
  ) {
    final List<_GeomLine> sorted = List<_GeomLine>.from(textLines)
      ..sort(
        (_GeomLine a, _GeomLine b) =>
            a.visualSortKey.compareTo(b.visualSortKey),
      );

    for (final _GeomLine line in sorted) {
      if (line == storeSourceLine) continue;
      if (_shouldIgnoreMetadata(line.text)) continue;
      if (_isLabelLine(line.text)) continue;
      if (_isWeightDetailLine(line.text)) continue;
      if (_isFooterMessage(line.text)) continue;
      if (_isTransactionMetadata(line.text)) continue;
      if (_isAddressFragment(line.text)) continue;
      if (!_hasPlausibleProductName(line.text)) continue;

      final _ProductCluster cluster =
          _buildCluster(line, weightContinuationMap);
      final double? paired = _pairPriceForCluster(
        cluster,
        priceLines,
        <_GeomLine>{},
        rightColumnThreshold,
      );
      if (paired != null) return line.top;
    }

    if (storeSourceLine != null) return storeSourceLine.bottom + 1;
    return sorted.isNotEmpty ? sorted.first.top : 0;
  }

  static double _clusterPriceDistance(
    _ProductCluster cluster,
    _GeomLine priceLine,
  ) {
    double best = (cluster.productLine.centerY - priceLine.centerY).abs();
    final _GeomLine? continuation = cluster.weightContinuation;
    if (continuation != null) {
      final double continuationDistance =
          (continuation.centerY - priceLine.centerY).abs();
      if (continuationDistance < best) {
        best = continuationDistance;
      }
    }
    return best;
  }

  static bool _priceOverlapsCluster(
      _ProductCluster cluster, _GeomLine priceLine) {
    return priceLine.centerY >= cluster.top - 4 &&
        priceLine.centerY <= cluster.bottom + 4;
  }

  static double? _pairPriceForCluster(
    _ProductCluster cluster,
    List<_GeomLine> priceLines,
    Set<_GeomLine> usedPrices,
    double rightColumnThreshold,
  ) {
    final double tolerance = _yToleranceForCluster(cluster, priceLines);

    _GeomLine? best;
    double bestDistance = double.infinity;

    for (final _GeomLine priceLine in priceLines) {
      if (usedPrices.contains(priceLine)) continue;
      if (priceLine.centerX < rightColumnThreshold) continue;

      final double? amount = _parseStandaloneAmount(priceLine.text);
      if (amount == null || !_isPlausibleLinePrice(amount)) continue;

      final bool overlapsCluster = _priceOverlapsCluster(cluster, priceLine);
      final double distance = _clusterPriceDistance(cluster, priceLine);
      if (!overlapsCluster && distance > tolerance) continue;
      if (distance >= bestDistance) continue;

      bestDistance = distance;
      best = priceLine;
    }

    if (best != null) {
      usedPrices.add(best);
      return _parseStandaloneAmount(best.text);
    }

    return null;
  }

  static double _yToleranceForCluster(
    _ProductCluster cluster,
    List<_GeomLine> priceLines,
  ) {
    final double clusterHeight =
        cluster.height > 0 ? cluster.height : _defaultYOverlapTolerance;
    return _yToleranceFor(
          _GeomLine(
            text: cluster.productLine.text,
            left: cluster.productLine.left,
            top: cluster.top,
            right: cluster.productLine.right,
            bottom: cluster.bottom,
            blockIndex: cluster.productLine.blockIndex,
            lineIndex: cluster.productLine.lineIndex,
          ),
          priceLines,
        ) +
        (clusterHeight * 0.35);
  }

  static double? _pairPriceForLine(
    _GeomLine productLine,
    List<_GeomLine> priceLines,
    Set<_GeomLine> usedPrices,
    double rightColumnThreshold,
  ) {
    final double tolerance = _yToleranceFor(productLine, priceLines);

    _GeomLine? best;
    double bestDistance = double.infinity;

    for (final _GeomLine priceLine in priceLines) {
      if (usedPrices.contains(priceLine)) continue;
      if (priceLine.centerX < rightColumnThreshold) continue;

      final double? amount = _parseStandaloneAmount(priceLine.text);
      if (amount == null || !_isPlausibleLinePrice(amount)) continue;

      final double distance = (productLine.centerY - priceLine.centerY).abs();
      if (distance <= tolerance && distance < bestDistance) {
        bestDistance = distance;
        best = priceLine;
      }
    }

    if (best != null) {
      usedPrices.add(best);
      return _parseStandaloneAmount(best.text);
    }

    return null;
  }

  static double _yToleranceFor(_GeomLine line, List<_GeomLine> priceLines) {
    final double lineHeight =
        line.height > 0 ? line.height : _defaultYOverlapTolerance;
    double avgPriceHeight = 0;
    int count = 0;
    for (final _GeomLine price in priceLines) {
      if (price.height > 0) {
        avgPriceHeight += price.height;
        count++;
      }
    }
    if (count > 0) {
      avgPriceHeight /= count;
    }
    final double basis = avgPriceHeight > 0 ? avgPriceHeight : lineHeight;
    return (basis * 0.75) + 8;
  }

  static double? _extractLabelAmount(
    List<_GeomLine> textLines,
    List<_GeomLine> priceLines,
    Set<_GeomLine> usedPrices,
    double rightColumnThreshold,
    List<String> keywords, {
    bool excludeSubtotal = false,
  }) {
    for (final _GeomLine line in textLines) {
      final String lower = line.text.toLowerCase();
      if (excludeSubtotal && lower.contains('subtotal')) continue;
      if (!keywords.any(lower.contains)) continue;
      if (RegExp(r'\btotal\b').hasMatch(lower) && excludeSubtotal) continue;

      final double? inline = _lastInlineAmount(line.text);
      if (inline != null && _isPlausibleLinePrice(inline)) {
        return inline;
      }

      final double? paired = _pairPriceForLine(
        line,
        priceLines,
        usedPrices,
        rightColumnThreshold,
      );
      if (paired != null) return paired;
    }
    return null;
  }

  static double? _extractTotalAmount(
    List<_GeomLine> textLines,
    List<_GeomLine> priceLines,
    Set<_GeomLine> usedPrices,
    double rightColumnThreshold,
  ) {
    for (final _GeomLine line in textLines) {
      final String lower = line.text.toLowerCase().trim();
      if (lower.contains('subtotal')) continue;
      if (!RegExp(r'\btotal\b').hasMatch(lower)) continue;
      if (lower.contains('sub total')) continue;

      final double? inline = _lastInlineAmount(line.text);
      if (inline != null && inline > 0 && _isPlausibleLinePrice(inline)) {
        return inline;
      }

      final double? paired = _pairPriceForLine(
        line,
        priceLines,
        usedPrices,
        rightColumnThreshold,
      );
      if (paired != null && paired > 0) return paired;
    }

    // Fallback: highest unused plausible total among remaining right-column prices.
    double? best;
    for (final _GeomLine priceLine in priceLines) {
      if (usedPrices.contains(priceLine)) continue;
      if (priceLine.centerX < rightColumnThreshold) continue;
      final double? amount = _parseStandaloneAmount(priceLine.text);
      if (amount == null || amount <= 0 || !_isPlausibleLinePrice(amount)) {
        continue;
      }
      if (best == null || amount > best) {
        best = amount;
      }
    }
    return best;
  }

  static ({double? subtotal, double? tax, double? total})
      _applySequentialTotalsIfNeeded({
    required double? subtotal,
    required double? tax,
    required double? total,
    required List<_GeomLine> priceLines,
    required Set<_GeomLine> usedPrices,
    required double rightColumnThreshold,
  }) {
    final List<double> unusedAmounts = <double>[];
    final List<_GeomLine> unusedLines = priceLines
        .where((_GeomLine line) => !usedPrices.contains(line))
        .where((_GeomLine line) => line.centerX >= rightColumnThreshold)
        .toList()
      ..sort(
        (_GeomLine a, _GeomLine b) =>
            a.visualSortKey.compareTo(b.visualSortKey),
      );

    for (final _GeomLine line in unusedLines) {
      final double? amount = _parseStandaloneAmount(line.text);
      if (amount != null && amount > 0 && _isPlausibleLinePrice(amount)) {
        unusedAmounts.add(amount);
      }
    }

    double? resolvedSubtotal = subtotal;
    double? resolvedTax = tax;
    double? resolvedTotal = total;

    if (unusedAmounts.length >= 3) {
      resolvedSubtotal ??= unusedAmounts[0];
      resolvedTax ??= unusedAmounts[1];
      resolvedTotal ??= unusedAmounts[2];
    } else if (unusedAmounts.length == 2) {
      resolvedSubtotal ??= unusedAmounts[0];
      resolvedTax ??= unusedAmounts[1];
    } else if (unusedAmounts.length == 1) {
      resolvedSubtotal ??= unusedAmounts[0];
    }

    return (
      subtotal: resolvedSubtotal,
      tax: resolvedTax,
      total: resolvedTotal,
    );
  }

  static ({String? name, _GeomLine? sourceLine}) _extractStoreName(
    List<_GeomLine> textLines,
    List<_GeomLine> priceLines,
    double rightColumnThreshold,
  ) {
    final List<_GeomLine> sorted = List<_GeomLine>.from(textLines)
      ..sort(
        (_GeomLine a, _GeomLine b) =>
            a.visualSortKey.compareTo(b.visualSortKey),
      );

    for (final _GeomLine line in sorted.take(12)) {
      if (_shouldIgnoreMetadata(line.text)) continue;
      if (_isLabelLine(line.text)) continue;
      if (_isWeightDetailLine(line.text)) continue;
      if (_looksLikeAmountOnly(line.text)) continue;
      if (!_hasPlausibleProductName(line.text)) continue;

      final double? pairedPrice = _pairPriceForLine(
        line,
        priceLines,
        <_GeomLine>{},
        rightColumnThreshold,
      );
      if (pairedPrice != null) continue;

      return (
        name: _normalizeStoreName(line.text.trim()),
        sourceLine: line,
      );
    }
    return (name: null, sourceLine: null);
  }

  static String _normalizeStoreName(String raw) {
    final String trimmed = raw.trim();
    final String lower = trimmed.toLowerCase();

    if (lower == 'metro' || lower.startsWith('metro ')) {
      if (lower.contains('supermarket')) {
        return 'Metro Supermarket';
      }
      return 'Metro';
    }

    if (RegExp(r'^metr[oO0]').hasMatch(trimmed)) {
      return lower.contains('supermarket') ? 'Metro Supermarket' : 'Metro';
    }

    return trimmed.replaceAll(RegExp(r'\s+'), ' ');
  }

  static DateTime? _extractDate(String text) {
    final Match? iso = _isoDate.firstMatch(text);
    if (iso != null) {
      return _safeDate(
        int.parse(iso.group(1)!),
        int.parse(iso.group(2)!),
        int.parse(iso.group(3)!),
      );
    }

    final Match? us = _usDate.firstMatch(text);
    if (us != null) {
      return _safeDate(
        int.parse(us.group(3)!),
        int.parse(us.group(1)!),
        int.parse(us.group(2)!),
      );
    }
    return null;
  }

  static DateTime? _safeDate(int year, int month, int day) {
    try {
      return DateTime(year, month, day);
    } catch (_) {
      return null;
    }
  }

  static _ParsedNameQuantity _parseLeadingQuantity(String text) {
    final String trimmed = text.trim();
    final Match? match = _leadingQuantity.firstMatch(trimmed);
    if (match == null) {
      return _ParsedNameQuantity(name: trimmed);
    }

    final int? quantity = int.tryParse(match.group(1)!);
    final String name = match.group(2)!.trim();
    if (quantity == null || quantity <= 0 || name.isEmpty) {
      return _ParsedNameQuantity(name: trimmed);
    }

    return _ParsedNameQuantity(name: name, quantity: quantity.toDouble());
  }

  static double? _parseStandaloneAmount(String text) {
    final String trimmed = text.trim().replaceAll('\$', '').replaceAll(',', '');
    return double.tryParse(trimmed);
  }

  static double? _lastInlineAmount(String text) {
    final List<double> amounts = <double>[];
    for (final RegExpMatch match
        in RegExp(r'[\$]?\s*(\d+\.\d{2})').allMatches(text)) {
      final double? value = double.tryParse(match.group(1)!);
      if (value != null) amounts.add(value);
    }
    return amounts.isEmpty ? null : amounts.last;
  }

  static bool _isPlausibleLinePrice(double value) {
    return value >= 0.01 && value <= 9999.99;
  }

  static bool _hasPlausibleProductName(String text) {
    if (text.length < 2) return false;
    final int letters = RegExp(r'[A-Za-z]').allMatches(text).length;
    return letters >= 2;
  }

  static bool _looksLikeAmountOnly(String text) {
    final String stripped = text.replaceAll(RegExp(r'[\$,\s]'), '');
    return RegExp(r'^\d+\.?\d*$').hasMatch(stripped);
  }
}

class _ProductCluster {
  const _ProductCluster({
    required this.productLine,
    this.weightContinuation,
  });

  final _GeomLine productLine;
  final _GeomLine? weightContinuation;

  double get top => productLine.top;
  double get bottom => weightContinuation?.bottom ?? productLine.bottom;
  double get centerY => (top + bottom) / 2;
  double get height => bottom - top;
}

class _GeomLine {
  const _GeomLine({
    required this.text,
    required this.left,
    required this.top,
    required this.right,
    required this.bottom,
    required this.blockIndex,
    required this.lineIndex,
  });

  final String text;
  final double left;
  final double top;
  final double right;
  final double bottom;
  final int blockIndex;
  final int lineIndex;

  double get centerX => (left + right) / 2;
  double get centerY => (top + bottom) / 2;
  double get height => bottom - top;
  int get visualSortKey => (top * 10000 + left.round()).round();
  int get sortKey => blockIndex * 1000000 + centerY.round();

  static _GeomLine fromOcrLine(ReceiptOcrLine line) {
    return _GeomLine(
      text: line.text,
      left: line.left!,
      top: line.top!,
      right: line.right!,
      bottom: line.bottom!,
      blockIndex: line.blockIndex,
      lineIndex: line.lineIndex,
    );
  }
}

class _ParsedNameQuantity {
  const _ParsedNameQuantity({
    required this.name,
    this.quantity,
  });

  final String name;
  final double? quantity;
}
