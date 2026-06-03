/// Basic fields extracted from raw receipt OCR text.
class ParsedReceiptData {
  const ParsedReceiptData({
    this.storeName,
    this.date,
    this.total,
    this.items = const <String>[],
    required this.rawText,
  });

  final String? storeName;
  final DateTime? date;
  final double? total;
  final List<String> items;
  final String rawText;

  @override
  String toString() {
    return 'ParsedReceiptData('
        'storeName: $storeName, '
        'date: $date, '
        'total: $total, '
        'items: ${items.length}, '
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

  static const List<String> _fallbackTotalKeywords = <String>[
    'amount due',
    'balance due',
    'total due',
  ];

  static const List<String> _itemStopKeywords = <String>[
    'subtotal',
    'gst',
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
  ];

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

    final String? storeName =
        lines.isNotEmpty ? _cleanStoreName(lines.first) : null;
    final DateTime? date = _extractDate(trimmed);
    final double? total = _extractTotal(lines);
    final List<String> items = _extractItems(lines);

    return ParsedReceiptData(
      storeName: storeName,
      date: date,
      total: total,
      items: items,
      rawText: rawText,
    );
  }

  String _cleanLine(String line) {
    return line.trim().replaceAll(RegExp(r'\s+'), ' ');
  }

  String _cleanStoreName(String line) {
    return line.replaceAll(RegExp(r'\s+'), ' ').trim();
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

  double? _extractTotal(List<String> lines) {
    bool foundTotalLabelWithoutInlineAmount = false;

    for (int i = lines.length - 1; i >= 0; i--) {
      if (!_isGrandTotalLine(lines[i])) continue;

      final double? amount = _lastAmountOnLine(lines[i]);
      if (amount != null) return amount;

      foundTotalLabelWithoutInlineAmount = true;
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
      if (amount != null) return amount;
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
      if (value != null) lastAmount = value;
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

  List<String> _extractItems(List<String> lines) {
    if (lines.length <= 1) return const <String>[];

    final int stopIndex = _findItemStopIndex(lines);
    const int startIndex = 1;

    if (startIndex >= stopIndex) return const <String>[];

    final List<String> items = <String>[];

    for (int i = startIndex; i < stopIndex; i++) {
      final String line = lines[i];
      if (_shouldIgnoreItemLine(line)) continue;
      if (_looksLikeAmountOnly(line)) continue;
      if (_extractDate(line) != null) continue;
      if (_timeOnly.hasMatch(line)) continue;

      items.add(line);
    }

    return items;
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
