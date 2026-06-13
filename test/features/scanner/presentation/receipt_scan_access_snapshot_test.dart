import 'package:flutter_test/flutter_test.dart';
import 'package:savingor_app/features/receipts/domain/models/receipt_source.dart';
import 'package:savingor_app/features/scanner/domain/models/monthly_receipt_scan_usage.dart';
import 'package:savingor_app/features/scanner/presentation/widgets/receipt_scan_access_builder.dart';
import 'package:savingor_app/features/subscription/domain/subscription_status.dart';

void main() {
  final DateTime monthStart = DateTime(2026, 6);
  final DateTime monthEnd = DateTime(2026, 7);

  group('ReceiptScanAccessSnapshot', () {
    test('Free user at limit cannot start scan', () {
      final ReceiptScanAccessSnapshot snapshot = ReceiptScanAccessSnapshot(
        isLoadingSubscription: false,
        isLoadingReceipts: false,
        receiptsLoadError: null,
        usage: MonthlyReceiptScanUsage(
          usedCount: 3,
          limit: 3,
          isPro: false,
          monthStart: monthStart,
          monthEnd: monthEnd,
        ),
        subscription: SubscriptionStatus.free,
      );

      expect(snapshot.canStartScan, isFalse);
      expect(snapshot.usage.isLimitReached, isTrue);
    });

    test('Pro user can start scan even when many scanned receipts exist', () {
      final ReceiptScanAccessSnapshot snapshot = ReceiptScanAccessSnapshot(
        isLoadingSubscription: false,
        isLoadingReceipts: false,
        receiptsLoadError: null,
        usage: MonthlyReceiptScanUsage(
          usedCount: 0,
          limit: 3,
          isPro: true,
          monthStart: monthStart,
          monthEnd: monthEnd,
        ),
        subscription: const SubscriptionStatus(
          plan: SubscriptionPlan.pro,
          status: SubscriptionState.active,
          provider: SubscriptionProvider.revenuecat,
          price: 14.99,
        ),
      );

      expect(snapshot.canStartScan, isTrue);
      expect(snapshot.usage.hasUnlimitedScans, isTrue);
    });

    test('loading state blocks scan start to avoid flicker', () {
      final ReceiptScanAccessSnapshot snapshot = ReceiptScanAccessSnapshot(
        isLoadingSubscription: true,
        isLoadingReceipts: false,
        receiptsLoadError: null,
        usage: MonthlyReceiptScanUsage(
          usedCount: 0,
          limit: 3,
          isPro: false,
          monthStart: monthStart,
          monthEnd: monthEnd,
        ),
        subscription: SubscriptionStatus.free,
      );

      expect(snapshot.isLoading, isTrue);
      expect(snapshot.canStartScan, isFalse);
    });

    test('receipt load errors block scan start', () {
      final ReceiptScanAccessSnapshot snapshot = ReceiptScanAccessSnapshot(
        isLoadingSubscription: false,
        isLoadingReceipts: false,
        receiptsLoadError: 'Could not load your receipts. Please try again.',
        usage: MonthlyReceiptScanUsage(
          usedCount: 0,
          limit: 3,
          isPro: false,
          monthStart: monthStart,
          monthEnd: monthEnd,
        ),
        subscription: SubscriptionStatus.free,
      );

      expect(snapshot.canStartScan, isFalse);
    });
  });

  test('scanned and gallery sources are image capture sources', () {
    expect(ReceiptSource.scanned.isFromImageCapture, isTrue);
    expect(ReceiptSource.gallery.isFromImageCapture, isTrue);
    expect(ReceiptSource.manual.isFromImageCapture, isFalse);
  });
}
