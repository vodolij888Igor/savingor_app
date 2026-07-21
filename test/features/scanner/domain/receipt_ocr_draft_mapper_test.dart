import 'package:flutter_test/flutter_test.dart';
import 'package:savingor_app/features/receipts/domain/models/receipt.dart';
import 'package:savingor_app/features/receipts/domain/models/receipt_item.dart';
import 'package:savingor_app/features/receipts/domain/models/receipt_source.dart';
import 'package:savingor_app/features/scanner/data/receipt_ocr_parser.dart';
import 'package:savingor_app/features/scanner/domain/receipt_ocr_draft_mapper.dart';
import 'package:savingor_app/features/scanner/domain/models/smart_receipt.dart';

import '../data/receipt_ocr_metro_fixture.dart';

void main() {
  final ReceiptOcrParser parser = ReceiptOcrParser();

  group('ReceiptOcrDraftMapper', () {
    test('converts OCR result into editable receipt items with prices', () {
      final ParsedReceiptData parsed = ParsedReceiptData(
        storeName: 'Test Store',
        date: DateTime(2026, 6, 10),
        total: 8.78,
        lineItems: const <ParsedReceiptLineItem>[
          ParsedReceiptLineItem(
            name: 'MILK',
            quantity: 1,
            unitPrice: 5.49,
            lineTotal: 5.49,
          ),
          ParsedReceiptLineItem(name: 'UNKNOWN ITEM'),
        ],
        rawText: 'raw',
      );

      final List<ReceiptItem> items =
          ReceiptOcrDraftMapper.toReceiptItems(parsed);

      expect(items.length, 2);
      expect(items[0].name, 'MILK');
      expect(items[0].totalPrice, 5.49);
      expect(items[0].unitPrice, 5.49);
      expect(items[1].name, 'UNKNOWN ITEM');
      expect(items[1].totalPrice, 0);
    });

    test('round-trips items through router extra maps', () {
      final List<ReceiptItem> original = <ReceiptItem>[
        const ReceiptItem(
          id: 'a',
          name: 'Bread',
          quantity: 2,
          unit: 'loaf',
          unitPrice: 1.5,
          totalPrice: 3,
          category: 'Bakery',
        ),
      ];

      final List<Map<String, dynamic>> extra =
          ReceiptOcrDraftMapper.itemsToExtra(original);
      final List<ReceiptItem> restored =
          ReceiptOcrDraftMapper.itemsFromExtra(extra);

      expect(restored.length, 1);
      expect(restored.single.name, 'Bread');
      expect(restored.single.quantity, 2);
      expect(restored.single.totalPrice, 3);
      expect(restored.single.unit, 'loaf');
      expect(restored.single.unitPrice, 1.5);
      expect(restored.single.category, 'Bakery');
    });

    test('manual corrections are preserved in built receipt items', () {
      final List<ReceiptItem> draftItems = ReceiptOcrDraftMapper.toReceiptItems(
        const ParsedReceiptData(
          lineItems: <ParsedReceiptLineItem>[
            ParsedReceiptLineItem(name: 'MILK', lineTotal: 4.99),
          ],
          rawText: 'raw',
        ),
      );

      final ReceiptItem corrected = draftItems.single.copyWith(
        name: 'Organic Milk 2L',
        totalPrice: 5.49,
        unitPrice: 5.49,
      );

      expect(corrected.name, 'Organic Milk 2L');
      expect(corrected.totalPrice, 5.49);
    });

    test('maps every Smart Receipt field into editable route state', () {
      final Map<String, dynamic> extra =
          ReceiptOcrDraftMapper.buildSmartReceiptExtra(
        SmartReceiptDraft(
          data: SmartReceiptData(
            storeName: 'Market',
            purchaseDate: DateTime(2026, 6, 12),
            currency: 'CAD',
            subtotal: 10,
            tax: 1.30,
            total: 11.30,
            items: const <SmartReceiptItemData>[
              SmartReceiptItemData(
                name: 'Milk',
                quantity: 2,
                unit: 'L',
                unitPrice: 2.25,
                totalPrice: 4.50,
                category: 'Dairy',
              ),
            ],
            warningCodes: const <String>['UNCERTAIN_TAX'],
          ),
          rawOcrText: 'Market\nMilk 4.50',
          source: ReceiptSource.gallery,
          provenance: SmartReceiptProvenance.aiEnhanced,
        ),
      );
      final List<ReceiptItem> restored = ReceiptOcrDraftMapper.itemsFromExtra(
        extra['initialItems'] as List<dynamic>,
      );

      expect(extra['initialStoreName'], 'Market');
      expect(extra['initialDate'], DateTime(2026, 6, 12));
      expect(extra['initialCurrency'], 'CAD');
      expect(extra['initialSubtotal'], 10);
      expect(extra['initialTax'], 1.30);
      expect(extra['initialTotal'], 11.30);
      expect(extra['initialOcrRawText'], 'Market\nMilk 4.50');
      expect(extra['smartReceiptProvenance'], 'aiEnhanced');
      expect(extra['smartReceiptWarningCodes'], <String>['UNCERTAIN_TAX']);
      expect(restored.single.name, 'Milk');
      expect(restored.single.quantity, 2);
      expect(restored.single.unit, 'L');
      expect(restored.single.unitPrice, 2.25);
      expect(restored.single.totalPrice, 4.50);
      expect(restored.single.category, 'Dairy');
    });
    test('valid priced items are eligible for price memory', () {
      final Receipt receipt = Receipt(
        id: 'r1',
        userId: 'user-1',
        storeName: 'Store',
        purchaseDate: DateTime(2026, 6, 10),
        createdAt: DateTime(2026, 6, 10),
        updatedAt: DateTime(2026, 6, 10),
        total: 5.49,
        source: ReceiptSource.scanned,
        items: <ReceiptItem>[
          const ReceiptItem(
            id: 'i1',
            name: 'Milk',
            totalPrice: 5.49,
            unitPrice: 5.49,
          ),
          const ReceiptItem(
            id: 'i2',
            name: 'Unknown',
            totalPrice: 0,
          ),
        ],
      );

      final List<ReceiptItem> eligible = receipt.items
          .where((ReceiptItem item) => item.totalPrice > 0)
          .toList();

      expect(eligible.length, 1);
      expect(eligible.single.name, 'Milk');
    });

    test('preserves Metro parser order and prices', () {
      final ParsedReceiptData parsed =
          parser.parseResult(buildMetroReceiptOcrFixture());
      final List<ReceiptItem> items =
          ReceiptOcrDraftMapper.toReceiptItems(parsed);

      expect(items.length, 10);
      expect(items[4].name, 'Chicken Breast Boneless Skinless');
      expect(items[4].totalPrice, 8.19);
      expect(items[5].name, 'Roma Tomatoes');
      expect(items[5].totalPrice, 1.59);
    });

    test('buildCreateReceiptExtra omits user notes for scanned OCR drafts', () {
      const String rawText = '''
metrO
Store: 00123
Date: 2025-06-13
Banana Cavendish
''';

      final ParsedReceiptData parsed = ParsedReceiptData(
        storeName: 'Metro',
        date: DateTime(2025, 6, 13),
        total: 40,
        rawText: rawText,
      );

      final Map<String, dynamic> extra =
          ReceiptOcrDraftMapper.buildCreateReceiptExtra(
        parsed: parsed,
        receiptSource: ReceiptSource.scanned,
      );

      expect(extra.containsKey('initialNotes'), isFalse);
      expect(extra['initialOcrRawText'], rawText);
      expect(extra['initialStoreName'], 'Metro');
      expect(extra['initialDate'], DateTime(2025, 6, 13));
    });

    test('buildCreateReceiptExtra keeps raw OCR separate from notes field', () {
      final ParsedReceiptData parsed = parser.parseResult(
        buildMetroReceiptOcrFixture(),
      );

      final Map<String, dynamic> extra =
          ReceiptOcrDraftMapper.buildCreateReceiptExtra(
        parsed: parsed,
        receiptSource: ReceiptSource.scanned,
      );

      expect(extra['initialNotes'], isNull);
      expect(extra['initialOcrRawText'], isNotNull);
      expect(
        (extra['initialOcrRawText'] as String).contains('Store: 00123'),
        isTrue,
      );
      expect(
        (extra['initialOcrRawText'] as String).contains('Date: 2025-06-13'),
        isTrue,
      );
    });

    test('Receipt stores ocrRawText separately from user notes', () {
      final Receipt receipt = Receipt(
        id: 'r1',
        userId: 'user-1',
        storeName: 'Metro Supermarket',
        purchaseDate: DateTime(2026, 6, 13),
        createdAt: DateTime(2026, 6, 13),
        updatedAt: DateTime(2026, 6, 13),
        total: 40,
        source: ReceiptSource.scanned,
        notes: 'Weekly groceries',
        ocrRawText: 'metrO\nStore: 00123\nDate: 2025-06-13',
      );

      final Map<String, dynamic> map = receipt.toMap();

      expect(map['notes'], 'Weekly groceries');
      expect(map['ocrRawText'], contains('metrO'));
      expect(map['notes'], isNot(contains('Store: 00123')));

      final Receipt restored = Receipt.fromMap(map, 'r1');
      expect(restored.notes, 'Weekly groceries');
      expect(restored.ocrRawText, contains('Store: 00123'));
    });

    test('Receipt update preserves ocrRawText when notes are edited', () {
      final Receipt existing = Receipt(
        id: 'r1',
        userId: 'user-1',
        storeName: 'Metro Supermarket',
        purchaseDate: DateTime(2026, 6, 13),
        createdAt: DateTime(2026, 6, 13),
        updatedAt: DateTime(2026, 6, 13),
        total: 40,
        source: ReceiptSource.scanned,
        notes: 'My note',
        ocrRawText: 'metrO\nDate: 2025-06-13',
      );

      final Receipt updated = existing.copyWith(
        storeName: 'Metro Supermarket',
        purchaseDate: DateTime(2026, 6, 13),
        notes: 'Updated note',
      );

      expect(updated.notes, 'Updated note');
      expect(updated.ocrRawText, existing.ocrRawText);
      expect(updated.ocrRawText, isNot(contains('Updated note')));
    });
  });
}
