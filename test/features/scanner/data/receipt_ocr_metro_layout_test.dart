import 'package:flutter_test/flutter_test.dart';
import 'package:savingor_app/features/scanner/data/receipt_ocr_parser.dart';
import 'package:savingor_app/features/scanner/domain/models/receipt_ocr_result.dart';
import 'receipt_ocr_metro_fixture.dart';

void main() {
  final ReceiptOcrParser parser = ReceiptOcrParser();

  group('Metro receipt layout parsing', () {
    late ReceiptOcrResult fixture;
    late ParsedReceiptData parsed;

    setUp(() {
      fixture = buildMetroReceiptOcrFixture();
      parsed = parser.parseResult(fixture);
    });

    test('parses store as Metro or Metro Supermarket', () {
      expect(parsed.storeName, isIn(<String>['Metro', 'Metro Supermarket']));
    });

    test('parses purchase date 2025-06-13', () {
      expect(parsed.date, DateTime(2025, 6, 13));
    });

    test('parses subtotal, tax, and total independently', () {
      expect(parsed.subtotal, 35.40);
      expect(parsed.tax, 4.60);
      expect(parsed.total, 40.00);
    });

    test('parses 10 product rows with correct line totals', () {
      expect(parsed.lineItems.length, 10);

      final List<String> names =
          parsed.lineItems.map((ParsedReceiptLineItem i) => i.name).toList();
      final List<double?> totals = parsed.lineItems
          .map((ParsedReceiptLineItem i) => i.lineTotal)
          .toList();

      expect(names, <String>[
        'Banana Cavendish',
        'Lactantia 2% Milk 4L',
        'Country Harvest Bread 675g',
        'Eggs Large White 12 pk',
        'Chicken Breast Boneless Skinless',
        'Roma Tomatoes',
        'Cucumber English',
        'Spinach Baby 312g',
        'Shreddies Cereal 540g',
        'Pepsi Cola 2L',
      ]);

      expect(totals, <double?>[
        1.59,
        5.49,
        3.49,
        3.29,
        8.19,
        1.59,
        1.29,
        2.99,
        4.49,
        2.49,
      ]);
    });

    test('parses leading quantity prefix on milk line', () {
      final ParsedReceiptLineItem milk = parsed.lineItems[1];
      expect(milk.name, 'Lactantia 2% Milk 4L');
      expect(milk.quantity, 1);
    });

    test('does not create products from metadata or payment lines', () {
      final List<String> names =
          parsed.lineItems.map((ParsedReceiptLineItem i) => i.name).toList();

      expect(
          names.any((String n) => n.toLowerCase().contains('store')), isFalse);
      expect(names.any((String n) => n.contains('King Street')), isFalse);
      expect(
          names.any((String n) => n.toLowerCase().contains('debit')), isFalse);
      expect(names.any((String n) => n.toLowerCase().contains('transaction')),
          isFalse);
      expect(names.any((String n) => n.contains('Metro Supermarket')), isFalse);
      expect(names.any((String n) => n.contains('Maple Leaf Drive')), isFalse);
      expect(
          names.any((String n) => n.toLowerCase().startsWith('time')), isFalse);
      expect(names.any((String n) => n.toUpperCase().contains('REF')), isFalse);
      expect(
        names.any((String n) => n.toLowerCase().contains('merci')),
        isFalse,
      );
    });

    test('pairs weighted-item line totals via product cluster', () {
      final ParsedReceiptLineItem banana = parsed.lineItems[0];
      final ParsedReceiptLineItem chicken = parsed.lineItems[4];
      final ParsedReceiptLineItem roma = parsed.lineItems[5];

      expect(banana.name, 'Banana Cavendish');
      expect(banana.lineTotal, 1.59);
      expect(chicken.name, 'Chicken Breast Boneless Skinless');
      expect(chicken.lineTotal, 8.19);
      expect(roma.name, 'Roma Tomatoes');
      expect(roma.lineTotal, 1.59);
      expect(chicken.lineTotal, isNot(13.21));
      expect(roma.lineTotal, isNot(2.84));
    });

    test('does not treat merchant header as a product', () {
      expect(parsed.storeName, 'Metro');
      expect(
        parsed.lineItems.any(
          (ParsedReceiptLineItem item) =>
              item.name.contains('Metro Supermarket'),
        ),
        isFalse,
      );
    });

    test('does not treat package sizes as monetary prices', () {
      for (final ParsedReceiptLineItem item in parsed.lineItems) {
        expect(item.lineTotal, isNot(675.00));
        expect(item.lineTotal, isNot(312.00));
        expect(item.lineTotal, isNot(540.00));
        expect(item.lineTotal, isNot(12.00));
        expect(item.lineTotal, isNot(123.00));
        expect(item.lineTotal, isNot(4.00));
        expect(item.lineTotal, isNot(2.00));
      }
    });

    test('preserves package sizes in product names', () {
      expect(parsed.lineItems[1].name.contains('4L'), isTrue);
      expect(parsed.lineItems[2].name.contains('675g'), isTrue);
      expect(parsed.lineItems[3].name.contains('12 pk'), isTrue);
      expect(parsed.lineItems[7].name.contains('312g'), isTrue);
      expect(parsed.lineItems[8].name.contains('540g'), isTrue);
      expect(parsed.lineItems[9].name.contains('2L'), isTrue);
    });

    test('does not treat weight detail lines as separate products', () {
      final List<String> names =
          parsed.lineItems.map((ParsedReceiptLineItem i) => i.name).toList();
      expect(names.any((String n) => n.contains('kg @')), isFalse);
    });

    test('flattened OCR order without geometry stays conservative', () {
      final ParsedReceiptData flatParsed = parser.parse(
        buildMetroFlattenedOcrText(),
      );

      expect(flatParsed.total, isNot(0.0));
      expect(
        flatParsed.lineItems.any(
          (ParsedReceiptLineItem item) => item.lineTotal == 675.00,
        ),
        isFalse,
      );
      expect(
        flatParsed.lineItems.any(
          (ParsedReceiptLineItem item) =>
              item.name.toLowerCase().contains('store:'),
        ),
        isFalse,
      );
    });

    test('uses layout parser when geometry exists', () {
      final ParsedReceiptData layoutParsed =
          parser.parseResult(buildMetroReceiptOcrFixture());
      final ParsedReceiptData flatParsed = parser.parse(
        buildMetroFlattenedOcrText(),
      );

      expect(layoutParsed.lineItems.length, 10);
      expect(flatParsed.lineItems.length, isNot(10));
      expect(layoutParsed.lineItems[4].lineTotal, 8.19);
      expect(layoutParsed.lineItems[5].lineTotal, 1.59);
    });

    test('scrambled block traversal order still pairs weighted items', () {
      final ParsedReceiptData parsed =
          parser.parseResult(buildMetroReceiptOcrFixtureScrambledOrder());

      expect(parsed.lineItems.length, 10);
      expect(parsed.lineItems[4].name, 'Chicken Breast Boneless Skinless');
      expect(parsed.lineItems[4].lineTotal, 8.19);
      expect(parsed.lineItems[5].name, 'Roma Tomatoes');
      expect(parsed.lineItems[5].lineTotal, 1.59);

      final Set<double?> usedTotals = parsed.lineItems
          .map((ParsedReceiptLineItem item) => item.lineTotal)
          .where((double? value) => value != null && value > 0)
          .toSet();
      expect(usedTotals.contains(8.19), isTrue);
      expect(usedTotals.contains(1.59), isTrue);
    });
  });
}
