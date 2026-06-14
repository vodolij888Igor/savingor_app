/// One recognized OCR text line with optional layout geometry.
class ReceiptOcrLine {
  const ReceiptOcrLine({
    required this.text,
    this.left,
    this.top,
    this.right,
    this.bottom,
    this.blockIndex = 0,
    this.lineIndex = 0,
  });

  final String text;
  final double? left;
  final double? top;
  final double? right;
  final double? bottom;
  final int blockIndex;
  final int lineIndex;

  bool get hasGeometry =>
      left != null && top != null && right != null && bottom != null;

  double get centerX => hasGeometry ? (left! + right!) / 2 : 0;

  double get centerY => hasGeometry ? (top! + bottom!) / 2 : 0;

  double get height => hasGeometry ? (bottom! - top!) : 0;

  /// Sort key: block order then vertical position.
  int get sortKey => blockIndex * 1000000 + centerY.round();

  /// Global visual sort key (Y then X) independent of block traversal order.
  int get visualSortKey => (top! * 10000 + left!.round()).round();
}

/// Structured OCR output preserving line geometry for layout-aware parsing.
class ReceiptOcrResult {
  const ReceiptOcrResult({
    required this.rawText,
    required this.lines,
    this.hasGeometry = false,
  });

  final String rawText;
  final List<ReceiptOcrLine> lines;
  final bool hasGeometry;

  factory ReceiptOcrResult.fromFlatText(String rawText) {
    final List<String> split = rawText
        .split(RegExp(r'\r?\n'))
        .map((String line) => line.trim())
        .where((String line) => line.isNotEmpty)
        .toList(growable: false);

    return ReceiptOcrResult(
      rawText: rawText,
      lines: split
          .map((String text) => ReceiptOcrLine(text: text))
          .toList(growable: false),
      hasGeometry: false,
    );
  }
}
