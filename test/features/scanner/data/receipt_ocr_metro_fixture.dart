import 'package:savingor_app/features/scanner/domain/models/receipt_ocr_result.dart';

/// Structured OCR fixture reproducing Metro receipt ML Kit column/block ordering
/// (second real OCR test: separate merchant header, address fragments, time/REF,
/// footer message, and weighted-item prices aligned to continuation rows).
ReceiptOcrResult buildMetroReceiptOcrFixture() {
  final List<ReceiptOcrLine> lines = <ReceiptOcrLine>[];

  void addLine({
    required String text,
    required double top,
    required int blockIndex,
    double left = 60,
    double right = 420,
  }) {
    lines.add(
      ReceiptOcrLine(
        text: text,
        left: left,
        top: top,
        right: right,
        bottom: top + 22,
        blockIndex: blockIndex,
      ),
    );
  }

  // Block 0: metadata + product descriptions + labels (flattened OCR order).
  addLine(text: 'Metro', top: 18, blockIndex: 0);
  addLine(text: 'Metro Supermarket', top: 40, blockIndex: 0);
  addLine(text: 'Store: 00123', top: 62, blockIndex: 0);
  addLine(text: '123 King Street West', top: 84, blockIndex: 0);
  addLine(text: 'Maple Leaf Drive', top: 106, blockIndex: 0);
  addLine(text: 'Toronto, ON M5H 1A1', top: 128, blockIndex: 0);
  addLine(text: 'Date: 2025-06-13', top: 150, blockIndex: 0);
  addLine(text: 'Time: 10:24 AM', top: 172, blockIndex: 0);
  addLine(text: 'REF #: 001001234567', top: 194, blockIndex: 0);
  addLine(text: 'Register: 004', top: 216, blockIndex: 0);

  addLine(text: 'Banana Cavendish', top: 250, blockIndex: 0);
  addLine(text: '1.234 kg @ \$1.29/kg', top: 272, blockIndex: 0);
  addLine(text: '1 Lactantia 2% Milk 4L', top: 294, blockIndex: 0);
  addLine(text: 'Country Harvest Bread 675g', top: 316, blockIndex: 0);
  addLine(text: 'Eggs Large White 12 pk', top: 338, blockIndex: 0);
  addLine(text: 'Chicken Breast Boneless Skinless', top: 360, blockIndex: 0);
  addLine(text: '0.620 kg @ \$13.21/kg', top: 382, blockIndex: 0);
  addLine(text: 'Roma Tomatoes', top: 404, blockIndex: 0);
  addLine(text: '0.560 kg @ \$2.84/kg', top: 426, blockIndex: 0);
  addLine(text: 'Cucumber English', top: 448, blockIndex: 0);
  addLine(text: 'Spinach Baby 312g', top: 470, blockIndex: 0);
  addLine(text: 'Shreddies Cereal 540g', top: 492, blockIndex: 0);
  addLine(text: 'Pepsi Cola 2L', top: 514, blockIndex: 0);

  addLine(text: 'SUBTOTAL', top: 550, blockIndex: 0);
  addLine(text: 'HST', top: 572, blockIndex: 0);
  addLine(text: 'TOTAL', top: 594, blockIndex: 0);
  addLine(text: 'DEBIT', top: 616, blockIndex: 0);
  addLine(text: 'CHANGE', top: 638, blockIndex: 0);
  addLine(text: 'TRANSACTION RECORD', top: 660, blockIndex: 0);
  addLine(text: 'Merci de magasiner chez Metro!', top: 682, blockIndex: 0);

  // Block 1: right-column prices (separate OCR block, aligned by Y).
  const double priceLeft = 780;
  const double priceRight = 920;

  addLine(
    text: '\$1.59',
    top: 250,
    blockIndex: 1,
    left: priceLeft,
    right: priceRight,
  );
  addLine(
    text: '\$5.49',
    top: 294,
    blockIndex: 1,
    left: priceLeft,
    right: priceRight,
  );
  addLine(
    text: '\$3.49',
    top: 316,
    blockIndex: 1,
    left: priceLeft,
    right: priceRight,
  );
  addLine(
    text: '\$3.29',
    top: 338,
    blockIndex: 1,
    left: priceLeft,
    right: priceRight,
  );
  // Weighted items: line totals align with continuation row Y, not product name row.
  addLine(
    text: '\$8.19',
    top: 382,
    blockIndex: 1,
    left: priceLeft,
    right: priceRight,
  );
  addLine(
    text: '\$1.59',
    top: 426,
    blockIndex: 1,
    left: priceLeft,
    right: priceRight,
  );
  addLine(
    text: '\$1.29',
    top: 448,
    blockIndex: 1,
    left: priceLeft,
    right: priceRight,
  );
  addLine(
    text: '\$2.99',
    top: 470,
    blockIndex: 1,
    left: priceLeft,
    right: priceRight,
  );
  addLine(
    text: '\$4.49',
    top: 492,
    blockIndex: 1,
    left: priceLeft,
    right: priceRight,
  );
  addLine(
    text: '\$2.49',
    top: 514,
    blockIndex: 1,
    left: priceLeft,
    right: priceRight,
  );
  addLine(
    text: '\$35.40',
    top: 550,
    blockIndex: 1,
    left: priceLeft,
    right: priceRight,
  );
  addLine(
    text: '\$4.60',
    top: 572,
    blockIndex: 1,
    left: priceLeft,
    right: priceRight,
  );
  addLine(
    text: '\$40.00',
    top: 594,
    blockIndex: 1,
    left: priceLeft,
    right: priceRight,
  );
  addLine(
    text: '\$40.00',
    top: 616,
    blockIndex: 1,
    left: priceLeft,
    right: priceRight,
  );
  addLine(
    text: '\$0.00',
    top: 638,
    blockIndex: 1,
    left: priceLeft,
    right: priceRight,
  );

  final String rawText =
      lines.map((ReceiptOcrLine line) => line.text).join('\n');

  return ReceiptOcrResult(
    rawText: rawText,
    lines: lines,
    hasGeometry: true,
  );
}

/// Flattened Metro OCR text without geometry (column/block order).
String buildMetroFlattenedOcrText() {
  return buildMetroReceiptOcrFixture().rawText;
}

/// Same Metro receipt geometry, but lines are stored in ML Kit block/insertion
/// order that differs from visual Y order (Roma appears before Chicken weight).
ReceiptOcrResult buildMetroReceiptOcrFixtureScrambledOrder() {
  final ReceiptOcrResult base = buildMetroReceiptOcrFixture();
  final List<ReceiptOcrLine> scrambled = List<ReceiptOcrLine>.from(base.lines);

  int indexOf(String text) =>
      scrambled.indexWhere((ReceiptOcrLine line) => line.text == text);

  void moveBefore(String lineText, String beforeText) {
    final int from = indexOf(lineText);
    final int before = indexOf(beforeText);
    if (from < 0 || before < 0 || from >= before) return;
    final ReceiptOcrLine line = scrambled.removeAt(from);
    scrambled.insert(before > from ? before - 1 : before, line);
  }

  // Simulate column-order traversal: Roma description before Chicken weight row.
  moveBefore('Roma Tomatoes', '0.620 kg @ \$13.21/kg');

  return ReceiptOcrResult(
    rawText: base.rawText,
    lines: scrambled,
    hasGeometry: true,
  );
}
