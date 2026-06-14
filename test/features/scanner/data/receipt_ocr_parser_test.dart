import 'package:flutter_test/flutter_test.dart';
import 'package:savingor_app/features/scanner/data/receipt_ocr_parser.dart';
import 'package:savingor_app/features/scanner/domain/models/receipt_ocr_result.dart';

import 'receipt_ocr_metro_fixture.dart';

void main() {
  final ReceiptOcrParser parser = ReceiptOcrParser();

  group('ReceiptOcrParser', () {
    test('parseResult uses geometry when available', () {
      const ReceiptOcrResult result = ReceiptOcrResult(
        rawText: 'Store\nAPPLES\n\$3.00',
        lines: <ReceiptOcrLine>[
          ReceiptOcrLine(
            text: 'APPLES',
            left: 50,
            top: 100,
            right: 400,
            bottom: 122,
            blockIndex: 0,
          ),
          ReceiptOcrLine(
            text: '\$3.00',
            left: 800,
            top: 100,
            right: 900,
            bottom: 122,
            blockIndex: 1,
          ),
        ],
        hasGeometry: true,
      );

      final ParsedReceiptData parsed = parser.parseResult(result);
      expect(parsed.lineItems.length, 1);
      expect(parsed.lineItems.single.name, 'APPLES');
      expect(parsed.lineItems.single.lineTotal, 3.00);
    });

    test('parseResult prefers layout parser over flat fallback', () {
      final ReceiptOcrResult fixture = buildMetroReceiptOcrFixture();
      final ParsedReceiptData parsed = parser.parseResult(fixture);

      expect(fixture.hasGeometry, isTrue);
      expect(parsed.lineItems.length, 10);
      expect(parsed.lineItems[4].lineTotal, 8.19);
      expect(parsed.lineItems[5].lineTotal, 1.59);
    });

    test('parses store, date, total, subtotal, tax, and product lines', () {
      const String raw = '''
COSTCO WHOLESALE
123 Main St NW
2026-06-10 14:22

ORGANIC MILK 2L          5.49
WHOLE WHEAT BREAD        3.29
2 @ 1.99                 3.98

Subtotal                12.76
GST                      0.64
TOTAL                   13.40
Thank you
''';

      final ParsedReceiptData parsed = parser.parse(raw);

      expect(parsed.storeName, 'COSTCO WHOLESALE');
      expect(parsed.date, DateTime(2026, 6, 10));
      expect(parsed.subtotal, 12.76);
      expect(parsed.tax, 0.64);
      expect(parsed.total, 13.40);
      expect(parsed.lineItems.length, 2);
      expect(parsed.lineItems[0].name, 'ORGANIC MILK 2L');
      expect(parsed.lineItems[0].lineTotal, 5.49);
      expect(parsed.lineItems[1].name, 'WHOLE WHEAT BREAD');
      expect(parsed.lineItems[1].lineTotal, 3.29);
    });

    test('ignores address, phone, payment, and footer lines', () {
      const String raw = '''
Fresh Market
456 Oak Ave, ON
Tel: 416-555-0100
06/12/2026

BANANAS                  2.49
Receipt #123456

Subtotal                 2.49
TOTAL                    2.49
VISA APPROVED
Thank you for shopping
''';

      final ParsedReceiptData parsed = parser.parse(raw);

      expect(parsed.lineItems.length, 1);
      expect(parsed.lineItems.single.name, 'BANANAS');
      expect(parsed.lineItems.single.lineTotal, 2.49);
      expect(parsed.lineItems.any((ParsedReceiptLineItem item) {
        return item.name.toLowerCase().contains('visa');
      }), isFalse);
    });

    test('does not invent totals or items from empty text', () {
      final ParsedReceiptData parsed = parser.parse('   ');

      expect(parsed.storeName, isNull);
      expect(parsed.total, isNull);
      expect(parsed.lineItems, isEmpty);
    });

    test('includes name-only lines when price is not recognized', () {
      const String raw = '''
Local Grocery
2026-01-15

MYSTERY ITEM

Subtotal                 4.00
TOTAL                    4.00
''';

      final ParsedReceiptData parsed = parser.parse(raw);

      expect(parsed.lineItems.length, 1);
      expect(parsed.lineItems.single.name, 'MYSTERY ITEM');
      expect(parsed.lineItems.single.hasRecognizedPrice, isFalse);
    });

    test('parses quantity lines when product name precedes quantity', () {
      const String raw = '''
Store
2026-06-01
APPLES 2 @ 1.99          3.98
TOTAL                    3.98
''';

      final ParsedReceiptData parsed = parser.parse(raw);

      expect(parsed.lineItems.length, 1);
      expect(parsed.lineItems.single.name, 'APPLES');
      expect(parsed.lineItems.single.quantity, 2);
      expect(parsed.lineItems.single.lineTotal, 3.98);
    });

    test('does not treat subtotal or tax lines as product items', () {
      const String raw = '''
Store
2026-03-01
APPLES                   3.00
Subtotal                 3.00
GST                      0.15
TOTAL                    3.15
''';

      final ParsedReceiptData parsed = parser.parse(raw);

      expect(parsed.lineItems.length, 1);
      expect(parsed.lineItems.single.name, 'APPLES');
    });
  });
}
