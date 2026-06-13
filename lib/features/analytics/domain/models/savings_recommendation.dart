/// Rule-based savings recommendation derived from real price memory.
enum SavingsRecommendationType {
  storeSwitch,
  watchPrice,
  bestKnownStore,
}

class SavingsRecommendation {
  const SavingsRecommendation({
    required this.type,
    required this.title,
    required this.reason,
    required this.impactText,
    required this.priorityScore,
    this.dataBasisText,
    this.normalizedProductName,
    this.storeName,
    this.productDisplayName,
    this.potentialSavingPerItem,
    this.latestPaidPrice,
    this.bestKnownPrice,
    this.latestStoreName,
    this.trackedProductCount,
    this.priceRangeLow,
    this.priceRangeHigh,
    this.priceDifferenceAmount,
    this.priceRecordCount,
  });

  final SavingsRecommendationType type;
  final String title;
  final String reason;
  final String impactText;
  final double priorityScore;
  final String? dataBasisText;
  final String? normalizedProductName;
  final String? storeName;

  /// Localized UI: product label for [SavingsRecommendationType.storeSwitch].
  final String? productDisplayName;

  /// Localized UI: per-item saving amount for store-switch recommendations.
  final double? potentialSavingPerItem;
  final double? latestPaidPrice;
  final double? bestKnownPrice;
  final String? latestStoreName;
  final int? trackedProductCount;
  final double? priceRangeLow;
  final double? priceRangeHigh;
  final double? priceDifferenceAmount;
  final int? priceRecordCount;

  bool get isProductAction =>
      normalizedProductName != null && normalizedProductName!.trim().isNotEmpty;
}
