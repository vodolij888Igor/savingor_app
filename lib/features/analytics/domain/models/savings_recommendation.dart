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
  });

  final SavingsRecommendationType type;
  final String title;
  final String reason;
  final String impactText;
  final double priorityScore;
  final String? dataBasisText;
  final String? normalizedProductName;
  final String? storeName;

  bool get isProductAction =>
      normalizedProductName != null && normalizedProductName!.trim().isNotEmpty;
}
