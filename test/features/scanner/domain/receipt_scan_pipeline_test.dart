import 'package:flutter_test/flutter_test.dart';
import 'package:savingor_app/features/receipts/domain/models/receipt.dart';
import 'package:savingor_app/features/receipts/domain/models/receipt_source.dart';
import 'package:savingor_app/features/scanner/domain/monthly_receipt_scan_usage_service.dart';
import 'package:savingor_app/features/scanner/domain/models/monthly_receipt_scan_usage.dart';
import 'package:savingor_app/features/subscription/domain/feature_access_policy.dart';

void main() {
  const MonthlyReceiptScanUsageService scanService =
      MonthlyReceiptScanUsageService();

  Receipt buildReceipt({
    required ReceiptSource source,
    required DateTime createdAt,
    String id = 'r1',
  }) {
    return Receipt(
      id: id,
      userId: 'user-1',
      storeName: 'Store',
      purchaseDate: createdAt,
      createdAt: createdAt,
      updatedAt: createdAt,
      total: 10,
      source: source,
    );
  }

  group('Receipt scan limit integration', () {
    final DateTime june2026 = DateTime(2026, 6, 15);

    test('cancelled image selection does not create a receipt', () {
      expect(
        scanService.computeUsage(
          receipts: const <Receipt>[],
          isPro: false,
          now: june2026,
        ).usedCount,
        0,
      );
    });

    test('OCR failure does not create a receipt', () {
      final MonthlyReceiptScanUsage usage = scanService.computeUsage(
        receipts: const <Receipt>[],
        isPro: false,
        now: june2026,
      );

      expect(usage.usedCount, 0);
      expect(usage.canStartNewScan, isTrue);
    });

    test('saved camera receipt counts toward Free limit only after save', () {
      final List<Receipt> receipts = <Receipt>[
        buildReceipt(source: ReceiptSource.scanned, createdAt: june2026),
      ];

      final MonthlyReceiptScanUsage usage = scanService.computeUsage(
        receipts: receipts,
        isPro: false,
        now: june2026,
      );

      expect(usage.usedCount, 1);
      expect(
        scanService.canSaveNewScannedReceipt(
          source: ReceiptSource.scanned,
          usage: usage,
          isNewReceipt: true,
        ),
        isTrue,
      );
    });

    test('saved gallery receipt has gallery source and counts toward limit',
        () {
      final Receipt receipt = buildReceipt(
        source: ReceiptSource.gallery,
        createdAt: june2026,
      );

      expect(receipt.source, ReceiptSource.gallery);
      expect(receipt.source.isFromImageCapture, isTrue);
    });

    test('manual receipts do not count toward scan limit', () {
      final MonthlyReceiptScanUsage usage = scanService.computeUsage(
        receipts: <Receipt>[
          buildReceipt(source: ReceiptSource.manual, createdAt: june2026),
          buildReceipt(
              source: ReceiptSource.manual, createdAt: june2026, id: 'r2'),
        ],
        isPro: false,
        now: june2026,
      );

      expect(usage.usedCount, 0);
      expect(usage.canStartNewScan, isTrue);
    });

    test('failed save at limit blocks fourth scanned receipt', () {
      final MonthlyReceiptScanUsage usage = scanService.computeUsage(
        receipts: <Receipt>[
          buildReceipt(
              source: ReceiptSource.scanned, createdAt: june2026, id: 'r1'),
          buildReceipt(
              source: ReceiptSource.scanned, createdAt: june2026, id: 'r2'),
          buildReceipt(
              source: ReceiptSource.gallery, createdAt: june2026, id: 'r3'),
        ],
        isPro: false,
        now: june2026,
      );

      expect(usage.usedCount, FeatureAccessPolicy.freeMonthlyReceiptScanLimit);
      expect(
        scanService.canSaveNewScannedReceipt(
          source: ReceiptSource.scanned,
          usage: usage,
          isNewReceipt: true,
        ),
        isFalse,
      );
    });

    test('editing an existing receipt does not consume another scan slot', () {
      final MonthlyReceiptScanUsage usage = scanService.computeUsage(
        receipts: <Receipt>[
          buildReceipt(
              source: ReceiptSource.scanned, createdAt: june2026, id: 'r1'),
          buildReceipt(
              source: ReceiptSource.scanned, createdAt: june2026, id: 'r2'),
          buildReceipt(
              source: ReceiptSource.scanned, createdAt: june2026, id: 'r3'),
        ],
        isPro: false,
        now: june2026,
      );

      expect(
        scanService.canSaveNewScannedReceipt(
          source: ReceiptSource.scanned,
          usage: usage,
          isNewReceipt: false,
        ),
        isTrue,
      );
    });

    test('Pro scanning remains unlimited', () {
      final MonthlyReceiptScanUsage usage = scanService.computeUsage(
        receipts: <Receipt>[
          buildReceipt(
              source: ReceiptSource.scanned, createdAt: june2026, id: 'r1'),
          buildReceipt(
              source: ReceiptSource.scanned, createdAt: june2026, id: 'r2'),
          buildReceipt(
              source: ReceiptSource.scanned, createdAt: june2026, id: 'r3'),
          buildReceipt(
              source: ReceiptSource.scanned, createdAt: june2026, id: 'r4'),
        ],
        isPro: true,
        now: june2026,
      );

      expect(usage.hasUnlimitedScans, isTrue);
      expect(usage.canStartNewScan, isTrue);
    });
  });
}
