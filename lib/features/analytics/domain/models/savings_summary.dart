import 'package:savingor_app/features/analytics/domain/models/product_savings_insight.dart';

/// Aggregated savings intelligence from price memory.
class SavingsSummary {
  const SavingsSummary({
    required this.estimatedSavedThisMonth,
    required this.estimatedSavedThisYear,
    required this.potentialMissedThisMonth,
    required this.potentialMissedThisYear,
    required this.subscriptionPrice,
    required this.monthlyRoiAmount,
    this.monthlyRoiMultiplier,
    required this.trackedProductCount,
    required this.productsWithSavingsCount,
    required this.productsWithMissedSavingsCount,
    required this.topProducts,
    required this.hasCalculableData,
    this.monthlySavingsTarget,
  });

  static const double defaultSubscriptionPrice = 14.99;

  /// Reserved for a future user-configurable monthly savings target.
  /// When wired from profile settings, progress UI can compare
  /// [estimatedSavedThisMonth] against this value.
  final double? monthlySavingsTarget;

  final double estimatedSavedThisMonth;
  final double estimatedSavedThisYear;
  final double potentialMissedThisMonth;
  final double potentialMissedThisYear;
  final double subscriptionPrice;
  final double monthlyRoiAmount;
  final double? monthlyRoiMultiplier;
  final int trackedProductCount;
  final int productsWithSavingsCount;
  final int productsWithMissedSavingsCount;
  final List<ProductSavingsInsight> topProducts;
  final bool hasCalculableData;

  bool get hasSavingsValue => hasCalculableData;

  bool get subscriptionIsPaidFor =>
      estimatedSavedThisMonth >= subscriptionPrice;

  double get subscriptionRemainingAmount {
    final double remaining = subscriptionPrice - estimatedSavedThisMonth;
    return remaining > 0 ? remaining : 0;
  }
}
