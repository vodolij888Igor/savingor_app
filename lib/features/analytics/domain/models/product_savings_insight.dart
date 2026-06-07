/// Per-product savings insight from real price history.
class ProductSavingsInsight {
  const ProductSavingsInsight({
    required this.normalizedName,
    required this.displayName,
    required this.estimatedSaved,
    required this.potentialMissed,
    required this.latestPaidPrice,
    required this.bestKnownPrice,
    required this.averageKnownPrice,
    required this.recordCount,
    this.bestStore,
    this.latestStore,
    this.currency = 'CAD',
  });

  final String normalizedName;
  final String displayName;
  final double estimatedSaved;
  final double potentialMissed;
  final double latestPaidPrice;
  final double bestKnownPrice;
  final double averageKnownPrice;
  final int recordCount;
  final String? bestStore;
  final String? latestStore;
  final String currency;

  double get topSavingsScore =>
      estimatedSaved > potentialMissed ? estimatedSaved : potentialMissed;
}
