/// Per-item basket recommendation from price memory.
class BasketPriceRecommendation {
  const BasketPriceRecommendation({
    required this.shoppingItemId,
    required this.shoppingItemName,
    required this.normalizedProductName,
    required this.shoppingQuantity,
    required this.hasPriceData,
    this.bestKnownPrice,
    this.bestStoreName,
    this.latestKnownPrice,
    this.latestStoreName,
    this.potentialSavingPerItem = 0,
    this.currency = 'CAD',
    this.recordCount = 0,
    this.message,
  });

  final String shoppingItemId;
  final String shoppingItemName;
  final String normalizedProductName;
  final int shoppingQuantity;
  final bool hasPriceData;
  final double? bestKnownPrice;
  final String? bestStoreName;
  final double? latestKnownPrice;
  final String? latestStoreName;
  final double potentialSavingPerItem;
  final String currency;
  final int recordCount;
  final String? message;

  double get bestLineTotal {
    if (!hasPriceData || bestKnownPrice == null) return 0;
    return bestKnownPrice! * shoppingQuantity;
  }

  double get latestLineTotal {
    if (!hasPriceData || latestKnownPrice == null) return 0;
    return latestKnownPrice! * shoppingQuantity;
  }

  String get displayMessage =>
      message ??
      (hasPriceData
          ? 'Best known price from your receipt history'
          : 'No price history yet');
}
