import 'package:savingor_app/features/scanner/data/receipt_ocr_layout_parser.dart';
import 'package:savingor_app/features/scanner/domain/models/receipt_ocr_result.dart';

/// One product line extracted from receipt OCR text.
class ParsedReceiptLineItem {
  const ParsedReceiptLineItem({
    required this.name,
    this.quantity,
    this.unitPrice,
    this.lineTotal,
  });

  final String name;
  final double? quantity;
  final double? unitPrice;
  final double? lineTotal;

  bool get hasRecognizedPrice =>
      lineTotal != null && lineTotal! > 0 && lineTotal!.isFinite;
}

/// Basic fields extracted from raw receipt OCR text.
class ParsedReceiptData {
  const ParsedReceiptData({
    this.storeName,
    this.date,
    this.subtotal,
    this.tax,
    this.total,
    this.lineItems = const <ParsedReceiptLineItem>[],
    required this.rawText,
  });

  final String? storeName;
  final DateTime? date;
  final double? subtotal;
  final double? tax;
  final double? total;
  final List<ParsedReceiptLineItem> lineItems;
  final String rawText;

  /// Legacy name-only item list for backward compatibility.
  List<String> get items =>
      lineItems.map((ParsedReceiptLineItem item) => item.name).toList();

  bool get hasRecognizedContent =>
      storeName != null ||
      date != null ||
      total != null ||
      subtotal != null ||
      tax != null ||
      lineItems.isNotEmpty;

  @override
  String toString() {
    return 'ParsedReceiptData('
        'storeName: $storeName, '
        'date: $date, '
        'subtotal: $subtotal, '
        'tax: $tax, '
        'total: $total, '
        'lineItems: ${lineItems.length}, '
        'rawTextLength: ${rawText.length}'
        ')';
  }
}

/// Simple heuristic parser for grocery receipt OCR output.
class ReceiptOcrParser {
  static final RegExp _isoDate = RegExp(
    r'(\d{4})[-/](\d{1,2})[-/](\d{1,2})',
  );

  static final RegExp _usDate = RegExp(
    r'(\d{1,2})[/](\d{1,2})[/](\d{4})',
  );

  static final RegExp _grandTotalLine = RegExp(
    r'\btotal\b',
    caseSensitive: false,
  );

  static final RegExp _moneyToken = RegExp(
    r'[\$]?\s*(\d{1,6}(?:,\d{3})*(?:\.\d{2})?|\d+[.,]\d{2})',
  );

  static final RegExp _commaDecimal = RegExp(
    r'[\$]?\s*(\d{1,6}),(\d{2})\b',
  );

  static final RegExp _splitCents = RegExp(
    r'(\d{1,6})\s+(\d{2})\s*$',
  );

  static final RegExp _cityProvince = RegExp(
    r"^[A-Za-z\s'.-]+,\s*[A-Z]{2}\s*$",
  );

  static final RegExp _streetHint = RegExp(
    r'\b(st|street|ave|avenue|rd|road|blvd|dr|drive|ln|lane|way|crt|court)\b',
    caseSensitive: false,
  );

  static final RegExp _directionHint = RegExp(
    r'\b(nw|ne|sw|se)\b',
    caseSensitive: false,
  );

  static final RegExp _leadingStreetNumber = RegExp(
    r'^\d+\s+[A-Za-z]',
  );

  static final RegExp _phonePattern = RegExp(
    r'(\+?\d[\d\s().-]{8,}\d)',
  );

  static final RegExp _standaloneDecimal = RegExp(
    r'^\$?\s*\d+\.\d{2}\s*$',
  );

  static final RegExp _standaloneCommaDecimal = RegExp(
    r'^\$?\s*\d+,\d{2}\s*$',
  );

  static final RegExp _embeddedTime = RegExp(
    r'\d{1,2}:\d{2}',
  );

  static final RegExp _receiptNumberOnly = RegExp(
    r'^\d{5,}$',
  );

  static final RegExp _timeOnly = RegExp(
    r'^\d{1,2}:\d{2}(:\d{2})?\s*(am|pm)?$',
    caseSensitive: false,
  );

  static final RegExp _quantityAtPrice = RegExp(
    r'^(\d+(?:\.\d+)?)\s*[@xX*]\s*([\$]?\s*\d+(?:[.,]\d{2})?)\s*(.*)$',
  );

  static final RegExp _namedQuantityAtPrice = RegExp(
    r'^(.+?)\s+(\d+(?:\.\d+)?)\s*[@xX*]\s*([\$]?\s*\d+(?:[.,]\d{2})?)\s*(.*)$',
  );

  static final RegExp _productCodePrefix = RegExp(
    r'^\d{4,}\s+',
  );

  static const List<String> _fallbackTotalKeywords = <String>[
    'amount due',
    'balance due',
    'total due',
  ];

  static const List<String> _itemStopKeywords = <String>[
    'subtotal',
    'gst',
    'hst',
    'pst',
    'qst',
    'tax',
    'payment',
    'amount due',
    'balance due',
    'total due',
  ];

  static const List<String> _itemIgnoreKeywords = <String>[
    'receipt',
    'date',
    'time',
    'cashier',
    'subtotal',
    'gst',
    'hst',
    'pst',
    'qst',
    'tax',
    'total',
    'payment',
    'approved',
    'thank',
    'www',
    'http',
    'tel',
    'phone',
    'visa',
    'mastercard',
    'debit',
    'credit',
    'change',
    'loyalty',
    'member',
    'points',
    'auth',
    'terminal',
    'ref #',
    'trans',
    'invoice',
  ];

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

  static final RegExp _packageSizeToken = RegExp(
    r'\b\d+\s*(?:g|kg|ml|l|pk|ct|ea)\b',
    caseSensitive: false,
  );

  static final RegExp _weightDetailLine = RegExp(
    r'^\d+\.?\d*\s*kg\s+@',
    caseSensitive: false,
  );

  static final RegExp _leadingItemQuantity = RegExp(
    r'^(\d+)\s+([A-Za-z].+)$',
  );

  /// Parses structured OCR output, using geometry when available.
  ParsedReceiptData parseResult(ReceiptOcrResult result) {
    if (result.rawText.trim().isEmpty) {
      return ParsedReceiptData(rawText: result.rawText);
    }

    if (result.hasGeometry &&
        result.lines.any((ReceiptOcrLine line) => line.hasGeometry)) {
      return ReceiptOcrLayoutParser().parse(result);
    }

    return parse(result.rawText);
  }

  ParsedReceiptData parse(String rawText) {
    final String trimmed = rawText.trim();
    if (trimmed.isEmpty) {
      return ParsedReceiptData(rawText: rawText);
    }

    final List<String> lines = trimmed
        .split(RegExp(r'\r?\n'))
        .map(_cleanLine)
        .where((String line) => line.isNotEmpty)
        .toList(growable: false);

    final String? storeName = _extractStoreName(lines);
    final DateTime? date = _extractDate(trimmed);
    final double? subtotal = _extractLabeledAmount(lines, _subtotalKeywords);
    final double? tax = _extractTaxAmount(lines);
    final double? total = _extractTotal(lines);
    final List<ParsedReceiptLineItem> lineItems = _extractLineItems(lines);

    return ParsedReceiptData(
      storeName: storeName,
      date: date,
      subtotal: subtotal,
      tax: tax,
      total: total,
      lineItems: lineItems,
      rawText: rawText,
    );
  }

  String _cleanLine(String line) {
    return line.trim().replaceAll(RegExp(r'\s+'), ' ');
  }

  String _cleanStoreName(String line) {
    return line.replaceAll(RegExp(r'\s+'), ' ').trim();
  }

  String? _extractStoreName(List<String> lines) {
    if (lines.isEmpty) return null;

    final int searchLimit = lines.length < 12 ? lines.length : 12;
    for (int i = 0; i < searchLimit; i++) {
      final String line = lines[i];
      if (_shouldIgnoreStoreCandidate(line)) continue;
      return _normalizeStoreName(_cleanStoreName(line));
    }

    return _normalizeStoreName(_cleanStoreName(lines.first));
  }

  String _normalizeStoreName(String raw) {
    final String trimmed = raw.trim();
    final String lower = trimmed.toLowerCase();

    if (lower == 'metro' || lower.startsWith('metro ')) {
      return lower.contains('supermarket') ? 'Metro Supermarket' : 'Metro';
    }
    if (RegExp(r'^metr[oO0]').hasMatch(trimmed)) {
      return lower.contains('supermarket') ? 'Metro Supermarket' : 'Metro';
    }
    return trimmed;
  }

  bool _shouldIgnoreStoreCandidate(String line) {
    if (RegExp(r'^store\s*[:#]', caseSensitive: false).hasMatch(line)) {
      return true;
    }
    if (RegExp(r'^register\s*[:#]', caseSensitive: false).hasMatch(line)) {
      return true;
    }
    if (_isAddressLine(line)) return true;
    if (_cityProvince.hasMatch(line)) return true;
    if (_isPhoneLine(line)) return true;
    if (_isDateOrTimeLine(line)) return true;
    if (_looksLikeAmountOnly(line)) return true;
    if (_receiptNumberOnly.hasMatch(line.trim())) return true;
    if (_isReceiptNumberLine(line.toLowerCase())) return true;

    final int letterCount = RegExp(r'[A-Za-z]').allMatches(line).length;
    if (letterCount < 2) return true;

    return false;
  }

  DateTime? _extractDate(String text) {
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

  DateTime? _safeDate(int year, int month, int day) {
    try {
      return DateTime(year, month, day);
    } catch (_) {
      return null;
    }
  }

  double? _extractLabeledAmount(
    List<String> lines,
    List<String> keywords,
  ) {
    for (final String line in lines) {
      final String lower = line.toLowerCase();
      if (!keywords.any(lower.contains)) continue;
      if (_isGrandTotalLine(line)) continue;

      final double? amount = _lastAmountOnLine(line);
      if (amount != null && _isPlausibleProductPrice(amount)) {
        return amount;
      }
    }
    return null;
  }

  double? _extractTaxAmount(List<String> lines) {
    for (final String line in lines) {
      final String lower = line.toLowerCase();
      if (!_taxKeywords.any(lower.contains)) continue;
      if (lower.contains('subtotal')) continue;
      if (_isGrandTotalLine(line)) continue;

      final double? amount = _lastAmountOnLine(line);
      if (amount != null && _isPlausibleProductPrice(amount)) {
        return amount;
      }
    }
    return null;
  }

  double? _extractTotal(List<String> lines) {
    bool foundTotalLabelWithoutInlineAmount = false;

    for (int i = lines.length - 1; i >= 0; i--) {
      if (!_isGrandTotalLine(lines[i])) continue;

      final double? amount = _lastAmountOnLine(lines[i]);
      if (amount != null && amount > 0) return amount;

      foundTotalLabelWithoutInlineAmount = true;
      for (int j = i + 1; j < lines.length && j <= i + 8; j++) {
        if (_shouldIgnoreStandaloneAmountLine(lines[j])) continue;
        final double? nearby = _standaloneDecimalAmount(lines[j]);
        if (nearby != null && nearby > 0 && _isPlausibleProductPrice(nearby)) {
          return nearby;
        }
      }
      break;
    }

    if (foundTotalLabelWithoutInlineAmount) {
      final double? lastAmount = _lastStandaloneDecimalAmount(lines);
      if (lastAmount != null) return lastAmount;
    }

    for (int i = lines.length - 1; i >= 0; i--) {
      final String lower = lines[i].toLowerCase();
      final bool isFallback = _fallbackTotalKeywords.any(lower.contains);
      if (!isFallback) continue;

      final double? amount = _lastAmountOnLine(lines[i]);
      if (amount != null && amount > 0) return amount;
    }

    return null;
  }

  bool _isGrandTotalLine(String line) {
    final String lower = line.toLowerCase();
    if (lower.contains('subtotal')) return false;
    return _grandTotalLine.hasMatch(line);
  }

  double? _lastAmountOnLine(String line) {
    final List<double> amounts = _allAmountsOnLine(line);
    if (amounts.isNotEmpty) return amounts.last;

    final Match? split = _splitCents.firstMatch(line);
    if (split != null) {
      return double.tryParse('${split.group(1)}.${split.group(2)}');
    }

    return null;
  }

  List<double> _allAmountsOnLine(String line) {
    final List<double> amounts = <double>[];

    for (final RegExpMatch match in _moneyToken.allMatches(line)) {
      final double? value = _parseMoneyToken(match.group(0)!);
      if (value != null) amounts.add(value);
    }

    for (final RegExpMatch match in _commaDecimal.allMatches(line)) {
      final double? value =
          double.tryParse('${match.group(1)}.${match.group(2)}');
      if (value != null) amounts.add(value);
    }

    return amounts;
  }

  double? _parseMoneyToken(String token) {
    String normalized = token.replaceAll('\$', '').trim();

    if (RegExp(r'^\d+,\d{2}$').hasMatch(normalized)) {
      normalized = normalized.replaceAll(',', '.');
    } else {
      normalized = normalized.replaceAll(',', '');
    }

    return double.tryParse(normalized);
  }

  double? _lastStandaloneDecimalAmount(List<String> lines) {
    double? lastAmount;

    for (final String line in lines) {
      if (_shouldIgnoreStandaloneAmountLine(line)) continue;

      final double? value = _standaloneDecimalAmount(line);
      if (value != null && value > 0) lastAmount = value;
    }

    return lastAmount;
  }

  bool _shouldIgnoreStandaloneAmountLine(String line) {
    if (_timeOnly.hasMatch(line)) return true;
    if (_embeddedTime.hasMatch(line)) return true;
    if (_receiptNumberOnly.hasMatch(line.trim())) return true;
    if (_isReceiptNumberLine(line.toLowerCase())) return true;
    return false;
  }

  double? _standaloneDecimalAmount(String line) {
    final String trimmed = line.trim();

    if (_standaloneDecimal.hasMatch(trimmed)) {
      return _parseMoneyToken(trimmed);
    }

    if (_standaloneCommaDecimal.hasMatch(trimmed)) {
      return _parseMoneyToken(trimmed);
    }

    return null;
  }

  List<ParsedReceiptLineItem> _extractLineItems(List<String> lines) {
    if (lines.length <= 1) return const <ParsedReceiptLineItem>[];

    final int stopIndex = _findItemStopIndex(lines);
    const int startIndex = 1;

    if (startIndex >= stopIndex) return const <ParsedReceiptLineItem>[];

    final List<ParsedReceiptLineItem> items = <ParsedReceiptLineItem>[];

    for (int i = startIndex; i < stopIndex; i++) {
      final String line = lines[i];
      if (_isWeightDetailLine(line)) continue;

      final ParsedReceiptLineItem? parsed = _parseProductLine(lines[i]);
      if (parsed != null) {
        items.add(parsed);
      }
    }

    return items;
  }

  ParsedReceiptLineItem? _parseProductLine(String line) {
    if (_shouldIgnoreItemLine(line)) return null;
    if (_isWeightDetailLine(line)) return null;
    if (_looksLikeAmountOnly(line)) return null;
    if (_extractDate(line) != null) return null;
    if (_timeOnly.hasMatch(line)) return null;

    final Match? namedQtyMatch = _namedQuantityAtPrice.firstMatch(line);
    if (namedQtyMatch != null) {
      final String rawName = namedQtyMatch.group(1)!.trim();
      final double? quantity = double.tryParse(namedQtyMatch.group(2)!);
      final double? unitPrice = _parseMoneyToken(namedQtyMatch.group(3)!);
      final String remainder = namedQtyMatch.group(4)!.trim();

      if (quantity != null &&
          quantity > 0 &&
          unitPrice != null &&
          _isPlausibleProductPrice(unitPrice)) {
        final String cleanedName = _cleanProductName(rawName);
        if (!_isPlausibleProductName(cleanedName)) return null;

        final double? trailingTotal = remainder.isEmpty
            ? quantity * unitPrice
            : _lastAmountOnLine(remainder);
        final double lineTotal =
            trailingTotal != null && _isPlausibleProductPrice(trailingTotal)
                ? trailingTotal
                : quantity * unitPrice;

        return ParsedReceiptLineItem(
          name: cleanedName,
          quantity: quantity,
          unitPrice: unitPrice,
          lineTotal: lineTotal,
        );
      }
    }

    final Match? qtyMatch = _quantityAtPrice.firstMatch(line);
    if (qtyMatch != null) {
      final double? quantity = double.tryParse(qtyMatch.group(1)!);
      final double? unitPrice = _parseMoneyToken(qtyMatch.group(2)!);
      final String remainder = qtyMatch.group(3)!.trim();

      if (quantity != null &&
          quantity > 0 &&
          unitPrice != null &&
          _isPlausibleProductPrice(unitPrice)) {
        final double? trailingTotal = remainder.isEmpty
            ? quantity * unitPrice
            : _lastAmountOnLine(remainder);
        final String name = remainder.isEmpty
            ? line.split('@').first.trim()
            : remainder.replaceAll(_moneyToken, '').trim();

        final String cleanedName = _cleanProductName(name);
        if (!_isPlausibleProductName(cleanedName)) return null;

        final double lineTotal =
            trailingTotal != null && _isPlausibleProductPrice(trailingTotal)
                ? trailingTotal
                : quantity * unitPrice;

        return ParsedReceiptLineItem(
          name: cleanedName,
          quantity: quantity,
          unitPrice: unitPrice,
          lineTotal: lineTotal,
        );
      }
    }

    final double? lineTotal = _lastCurrencyAmountOnLine(line);
    if (lineTotal != null && _isPlausibleProductPrice(lineTotal)) {
      final String namePart = _stripTrailingAmount(line);
      final _ParsedNameQuantity parsedName = _parseLeadingQuantity(namePart);
      if (!_isPlausibleProductName(parsedName.name)) return null;

      return ParsedReceiptLineItem(
        name: _cleanProductName(parsedName.name),
        quantity: parsedName.quantity ?? 1,
        unitPrice: lineTotal,
        lineTotal: lineTotal,
      );
    }

    final _ParsedNameQuantity parsedNameOnly = _parseLeadingQuantity(line);
    if (!_isPlausibleProductName(parsedNameOnly.name)) return null;

    return ParsedReceiptLineItem(
      name: _cleanProductName(parsedNameOnly.name),
      quantity: parsedNameOnly.quantity,
    );
  }

  bool _isWeightDetailLine(String line) {
    return _weightDetailLine.hasMatch(line.trim());
  }

  _ParsedNameQuantity _parseLeadingQuantity(String text) {
    final String trimmed = text.trim();
    final Match? match = _leadingItemQuantity.firstMatch(trimmed);
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

  double? _lastCurrencyAmountOnLine(String line) {
    final Match? trailingDecimal =
        RegExp(r'(\d+\.\d{2})\s*$').firstMatch(line.trim());
    if (trailingDecimal != null) {
      final double? value = double.tryParse(trailingDecimal.group(1)!);
      if (value != null && _isPlausibleProductPrice(value)) {
        return value;
      }
    }

    if (_packageSizeToken.hasMatch(line) &&
        !RegExp(r'\$\s*\d+\.\d{2}').hasMatch(line)) {
      final Match? currencyAtEnd =
          RegExp(r'\$\s*(\d+\.\d{2})\s*$').firstMatch(line.trim());
      if (currencyAtEnd != null) {
        return double.tryParse(currencyAtEnd.group(1)!);
      }
      return null;
    }
    return _lastAmountOnLine(line);
  }

  String _stripTrailingAmount(String line) {
    String result = line;
    final List<RegExpMatch> matches = _moneyToken.allMatches(line).toList();
    if (matches.isNotEmpty) {
      result = line.substring(0, matches.last.start).trim();
    }
    return result;
  }

  String _cleanProductName(String name) {
    String cleaned = name.replaceAll(_productCodePrefix, '').trim();
    cleaned = cleaned.replaceAll(RegExp(r'\s+'), ' ');
    return cleaned;
  }

  bool _isPlausibleProductName(String name) {
    if (name.length < 2) return false;
    final int letterCount = RegExp(r'[A-Za-z]').allMatches(name).length;
    return letterCount >= 2;
  }

  bool _isPlausibleProductPrice(double value) {
    return value >= 0.01 && value <= 9999.99;
  }

  int _findItemStopIndex(List<String> lines) {
    for (int i = 1; i < lines.length; i++) {
      final String lower = lines[i].toLowerCase();
      if (lower.contains('subtotal')) return i;
      if (_itemStopKeywords.any(lower.contains)) return i;
      if (_isGrandTotalLine(lines[i])) return i;
    }
    return lines.length;
  }

  bool _shouldIgnoreItemLine(String line) {
    final String lower = line.toLowerCase();

    if (RegExp(r'^store\s*[:#]').hasMatch(lower)) return true;
    if (RegExp(r'^register\s*[:#]').hasMatch(lower)) return true;
    if (_itemIgnoreKeywords.any(lower.contains)) return true;
    if (_isAddressLine(line)) return true;
    if (_cityProvince.hasMatch(line)) return true;
    if (_isPhoneLine(line)) return true;
    if (_isReceiptNumberLine(lower)) return true;
    if (_isDateOrTimeLine(line)) return true;

    return false;
  }

  bool _isAddressLine(String line) {
    final String lower = line.toLowerCase();

    if (_streetHint.hasMatch(lower)) return true;
    if (_directionHint.hasMatch(lower) && _leadingStreetNumber.hasMatch(line)) {
      return true;
    }
    if (_leadingStreetNumber.hasMatch(line) &&
        (_streetHint.hasMatch(lower) || _directionHint.hasMatch(lower))) {
      return true;
    }

    return false;
  }

  bool _isPhoneLine(String line) {
    final String lower = line.toLowerCase();
    if (lower.contains('tel') || lower.contains('phone')) return true;
    return _phonePattern.hasMatch(line);
  }

  bool _isReceiptNumberLine(String lower) {
    return lower.contains('receipt #') ||
        lower.contains('receipt no') ||
        RegExp(r'receipt\s*[#:]?\s*\d').hasMatch(lower) ||
        RegExp(r'trans\s*[#:]?\s*\d').hasMatch(lower);
  }

  bool _isDateOrTimeLine(String line) {
    if (_extractDate(line) != null) return true;
    if (_timeOnly.hasMatch(line)) return true;
    if (_isoDate.hasMatch(line) && line.length < 20) return true;
    if (_usDate.hasMatch(line) && line.length < 20) return true;
    return false;
  }

  bool _looksLikeAmountOnly(String line) {
    final String stripped = line.replaceAll(RegExp(r'[\$,\s]'), '');
    return RegExp(r'^\d+\.?\d*$').hasMatch(stripped);
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
