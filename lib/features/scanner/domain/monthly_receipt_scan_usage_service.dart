import 'package:savingor_app/features/receipts/domain/models/receipt.dart';
import 'package:savingor_app/features/receipts/domain/models/receipt_source.dart';
import 'package:savingor_app/features/scanner/domain/models/monthly_receipt_scan_usage.dart';
import 'package:savingor_app/features/subscription/domain/feature_access_service.dart';

/// Derives Free-plan monthly scan usage from saved receipt records.
class MonthlyReceiptScanUsageService {
  const MonthlyReceiptScanUsageService({
    FeatureAccessService? featureAccessService,
  }) : _featureAccessService =
            featureAccessService ?? const FeatureAccessService();

  final FeatureAccessService _featureAccessService;

  int get freeMonthlyLimit => _featureAccessService.freeMonthlyReceiptScanLimit;

  /// Returns inclusive local month start and exclusive next-month start.
  ({DateTime start, DateTime end}) localMonthBounds([DateTime? now]) {
    final DateTime reference = now ?? DateTime.now();
    final DateTime start = DateTime(reference.year, reference.month);
    final DateTime end = reference.month == 12
        ? DateTime(reference.year + 1)
        : DateTime(reference.year, reference.month + 1);
    return (start: start, end: end);
  }

  bool countsTowardMonthlyLimit(Receipt receipt) {
    return receipt.source.isFromImageCapture &&
        isCreatedInCurrentLocalMonth(receipt.createdAt);
  }

  bool isCreatedInCurrentLocalMonth(DateTime createdAt, [DateTime? now]) {
    final ({DateTime start, DateTime end}) bounds = localMonthBounds(now);
    return !createdAt.isBefore(bounds.start) && createdAt.isBefore(bounds.end);
  }

  int countScansInCurrentMonth(
    Iterable<Receipt> receipts, {
    DateTime? now,
    String? userId,
  }) {
    final ({DateTime start, DateTime end}) bounds = localMonthBounds(now);

    return receipts.where((Receipt receipt) {
      if (userId != null &&
          receipt.userId.isNotEmpty &&
          receipt.userId != userId) {
        return false;
      }
      if (!receipt.source.isFromImageCapture) {
        return false;
      }
      return !receipt.createdAt.isBefore(bounds.start) &&
          receipt.createdAt.isBefore(bounds.end);
    }).length;
  }

  MonthlyReceiptScanUsage computeUsage({
    required Iterable<Receipt> receipts,
    required bool isPro,
    DateTime? now,
    String? userId,
  }) {
    final ({DateTime start, DateTime end}) bounds = localMonthBounds(now);

    if (isPro) {
      return MonthlyReceiptScanUsage.pro(
        monthStart: bounds.start,
        monthEnd: bounds.end,
      );
    }

    final int usedCount = countScansInCurrentMonth(
      receipts,
      now: now,
      userId: userId,
    );

    return MonthlyReceiptScanUsage.free(
      usedCount: usedCount,
      monthStart: bounds.start,
      monthEnd: bounds.end,
      limit: freeMonthlyLimit,
    );
  }

  bool canSaveNewScannedReceipt({
    required ReceiptSource source,
    required MonthlyReceiptScanUsage usage,
    required bool isNewReceipt,
  }) {
    if (!isNewReceipt) {
      return true;
    }
    if (!source.isFromImageCapture) {
      return true;
    }
    return usage.canStartNewScan;
  }
}
