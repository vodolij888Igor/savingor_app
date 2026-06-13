import 'package:savingor_app/features/subscription/domain/feature_access_policy.dart';

/// Derived monthly scan quota for the current local calendar month.
class MonthlyReceiptScanUsage {
  const MonthlyReceiptScanUsage({
    required this.usedCount,
    required this.limit,
    required this.isPro,
    required this.monthStart,
    required this.monthEnd,
  });

  final int usedCount;
  final int limit;
  final bool isPro;
  final DateTime monthStart;
  final DateTime monthEnd;

  bool get hasUnlimitedScans => isPro;

  int get remainingFreeScans {
    if (isPro) {
      return limit;
    }
    final int remaining = limit - usedCount;
    return remaining < 0 ? 0 : remaining;
  }

  bool get canStartNewScan => isPro || usedCount < limit;

  bool get isLimitReached => !isPro && usedCount >= limit;

  static MonthlyReceiptScanUsage pro({
    required DateTime monthStart,
    required DateTime monthEnd,
  }) {
    return MonthlyReceiptScanUsage(
      usedCount: 0,
      limit: FeatureAccessPolicy.freeMonthlyReceiptScanLimit,
      isPro: true,
      monthStart: monthStart,
      monthEnd: monthEnd,
    );
  }

  static MonthlyReceiptScanUsage free({
    required int usedCount,
    required DateTime monthStart,
    required DateTime monthEnd,
    int? limit,
  }) {
    return MonthlyReceiptScanUsage(
      usedCount: usedCount,
      limit: limit ?? FeatureAccessPolicy.freeMonthlyReceiptScanLimit,
      isPro: false,
      monthStart: monthStart,
      monthEnd: monthEnd,
    );
  }
}
