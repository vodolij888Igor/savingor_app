import 'package:flutter_test/flutter_test.dart';
import 'package:savingor_app/features/receipts/domain/models/receipt.dart';
import 'package:savingor_app/features/receipts/domain/models/receipt_source.dart';
import 'package:savingor_app/features/scanner/domain/models/monthly_receipt_scan_usage.dart';
import 'package:savingor_app/features/scanner/domain/monthly_receipt_scan_usage_service.dart';
import 'package:savingor_app/features/subscription/domain/feature_access_policy.dart';

void main() {
  const MonthlyReceiptScanUsageService service =
      MonthlyReceiptScanUsageService();

  final DateTime june2026 = DateTime(2026, 6, 15, 12);
  final DateTime may2026 = DateTime(2026, 5, 20, 10);

  Receipt scannedReceipt({
    required DateTime createdAt,
    ReceiptSource source = ReceiptSource.scanned,
    String id = 'r1',
  }) {
    return Receipt(
      id: id,
      userId: 'user-1',
      storeName: 'Test Store',
      purchaseDate: createdAt,
      createdAt: createdAt,
      updatedAt: createdAt,
      total: 12.34,
      source: source,
    );
  }

  group('MonthlyReceiptScanUsageService.computeUsage', () {
    test('Free user with 0 saved scans can scan', () {
      final MonthlyReceiptScanUsage usage = service.computeUsage(
        receipts: const <Receipt>[],
        isPro: false,
        now: june2026,
      );

      expect(usage.usedCount, 0);
      expect(usage.canStartNewScan, isTrue);
      expect(usage.isLimitReached, isFalse);
    });

    test('Free user with 2 saved scans can scan', () {
      final MonthlyReceiptScanUsage usage = service.computeUsage(
        receipts: <Receipt>[
          scannedReceipt(createdAt: june2026, id: 'r1'),
          scannedReceipt(
            createdAt: june2026,
            id: 'r2',
            source: ReceiptSource.gallery,
          ),
        ],
        isPro: false,
        now: june2026,
      );

      expect(usage.usedCount, 2);
      expect(usage.remainingFreeScans, 1);
      expect(usage.canStartNewScan, isTrue);
    });

    test('Free user with 3 saved scans cannot scan', () {
      final MonthlyReceiptScanUsage usage = service.computeUsage(
        receipts: <Receipt>[
          scannedReceipt(createdAt: june2026, id: 'r1'),
          scannedReceipt(createdAt: june2026, id: 'r2'),
          scannedReceipt(createdAt: june2026, id: 'r3'),
        ],
        isPro: false,
        now: june2026,
      );

      expect(usage.usedCount, 3);
      expect(usage.canStartNewScan, isFalse);
      expect(usage.isLimitReached, isTrue);
    });

    test('Pro user can scan regardless of monthly count', () {
      final MonthlyReceiptScanUsage usage = service.computeUsage(
        receipts: <Receipt>[
          scannedReceipt(createdAt: june2026, id: 'r1'),
          scannedReceipt(createdAt: june2026, id: 'r2'),
          scannedReceipt(createdAt: june2026, id: 'r3'),
          scannedReceipt(createdAt: june2026, id: 'r4'),
        ],
        isPro: true,
        now: june2026,
      );

      expect(usage.hasUnlimitedScans, isTrue);
      expect(usage.canStartNewScan, isTrue);
    });

    test('manual receipts do not count toward usage', () {
      final MonthlyReceiptScanUsage usage = service.computeUsage(
        receipts: <Receipt>[
          scannedReceipt(
            createdAt: june2026,
            source: ReceiptSource.manual,
            id: 'manual',
          ),
          scannedReceipt(
            createdAt: june2026,
            source: ReceiptSource.shoppingList,
            id: 'trip',
          ),
        ],
        isPro: false,
        now: june2026,
      );

      expect(usage.usedCount, 0);
      expect(usage.canStartNewScan, isTrue);
    });

    test('saved camera receipt counts', () {
      expect(
        service.countScansInCurrentMonth(
          <Receipt>[scannedReceipt(createdAt: june2026)],
          now: june2026,
        ),
        1,
      );
      expect(
        service.countsTowardMonthlyLimit(
          scannedReceipt(createdAt: june2026, source: ReceiptSource.scanned),
          now: june2026,
        ),
        isTrue,
      );
    });

    test('saved gallery receipt counts', () {
      expect(
        service.countScansInCurrentMonth(
          <Receipt>[
            scannedReceipt(
              createdAt: june2026,
              source: ReceiptSource.gallery,
            ),
          ],
          now: june2026,
        ),
        1,
      );
    });

    test('count resets for a new calendar month', () {
      final MonthlyReceiptScanUsage usage = service.computeUsage(
        receipts: <Receipt>[
          scannedReceipt(createdAt: may2026, id: 'old'),
          scannedReceipt(createdAt: june2026, id: 'new'),
        ],
        isPro: false,
        now: june2026,
      );

      expect(usage.usedCount, 1);
      expect(usage.canStartNewScan, isTrue);
    });

    test('uses centralized freeMonthlyReceiptScanLimit', () {
      expect(service.freeMonthlyLimit,
          FeatureAccessPolicy.freeMonthlyReceiptScanLimit);
      expect(service.freeMonthlyLimit, 3);
    });
  });

  group('MonthlyReceiptScanUsageService.canSaveNewScannedReceipt', () {
    test('blocks a fourth Free scan at save time', () {
      final MonthlyReceiptScanUsage usage = MonthlyReceiptScanUsage.free(
        usedCount: 3,
        monthStart: DateTime(2026, 6),
        monthEnd: DateTime(2026, 7),
      );

      expect(
        service.canSaveNewScannedReceipt(
          source: ReceiptSource.scanned,
          usage: usage,
          isNewReceipt: true,
        ),
        isFalse,
      );
    });

    test('allows saving when under the Free limit', () {
      final MonthlyReceiptScanUsage usage = MonthlyReceiptScanUsage.free(
        usedCount: 2,
        monthStart: DateTime(2026, 6),
        monthEnd: DateTime(2026, 7),
      );

      expect(
        service.canSaveNewScannedReceipt(
          source: ReceiptSource.gallery,
          usage: usage,
          isNewReceipt: true,
        ),
        isTrue,
      );
    });

    test('existing receipt edits do not increment usage', () {
      final MonthlyReceiptScanUsage usage = MonthlyReceiptScanUsage.free(
        usedCount: 3,
        monthStart: DateTime(2026, 6),
        monthEnd: DateTime(2026, 7),
      );

      expect(
        service.canSaveNewScannedReceipt(
          source: ReceiptSource.scanned,
          usage: usage,
          isNewReceipt: false,
        ),
        isTrue,
      );
    });

    test('manual receipt creation is not blocked by scan usage', () {
      final MonthlyReceiptScanUsage usage = MonthlyReceiptScanUsage.free(
        usedCount: 3,
        monthStart: DateTime(2026, 6),
        monthEnd: DateTime(2026, 7),
      );

      expect(
        service.canSaveNewScannedReceipt(
          source: ReceiptSource.manual,
          usage: usage,
          isNewReceipt: true,
        ),
        isTrue,
      );
    });

    test('Pro usage bypasses the Free limit at save time', () {
      final MonthlyReceiptScanUsage usage = MonthlyReceiptScanUsage.pro(
        monthStart: DateTime(2026, 6),
        monthEnd: DateTime(2026, 7),
      );

      expect(
        service.canSaveNewScannedReceipt(
          source: ReceiptSource.scanned,
          usage: usage,
          isNewReceipt: true,
        ),
        isTrue,
      );
    });
  });

  group('MonthlyReceiptScanUsageService.localMonthBounds', () {
    test('uses local calendar month boundaries', () {
      final ({DateTime start, DateTime end}) bounds =
          service.localMonthBounds(june2026);

      expect(bounds.start, DateTime(2026, 6));
      expect(bounds.end, DateTime(2026, 7));
      expect(
        service.isCreatedInCurrentLocalMonth(DateTime(2026, 6, 1), june2026),
        isTrue,
      );
      expect(
        service.isCreatedInCurrentLocalMonth(DateTime(2026, 7, 1), june2026),
        isFalse,
      );
    });
  });
}
