import 'package:savingor_app/features/price_memory/domain/models/basket_price_recommendation.dart';

/// Store-centric grouping for a suggested basket plan.
class BasketStorePlanEntry {
  const BasketStorePlanEntry({
    required this.storeName,
    required this.items,
    required this.estimatedStoreTotal,
    this.currency = 'CAD',
  });

  final String storeName;
  final List<BasketStorePlanItem> items;
  final double estimatedStoreTotal;
  final String currency;
}

class BasketStorePlanItem {
  const BasketStorePlanItem({
    required this.shoppingItemName,
    required this.unitPrice,
    required this.quantity,
  });

  final String shoppingItemName;
  final double unitPrice;
  final int quantity;

  double get lineTotal => unitPrice * quantity;
}

/// Full basket optimization output.
class BasketOptimizationResult {
  const BasketOptimizationResult({
    required this.recommendations,
    required this.storePlan,
    required this.estimatedBestTotal,
    required this.estimatedLatestTotal,
    required this.totalPotentialSaving,
    required this.matchedItemsCount,
    required this.unmatchedItemsCount,
    this.currency = 'CAD',
    this.activeListsIncluded,
  });

  final List<BasketPriceRecommendation> recommendations;
  final List<BasketStorePlanEntry> storePlan;
  final double estimatedBestTotal;
  final double estimatedLatestTotal;
  final double totalPotentialSaving;
  final int matchedItemsCount;
  final int unmatchedItemsCount;
  final String currency;
  final int? activeListsIncluded;

  bool get hasShoppingItems => recommendations.isNotEmpty;
  bool get hasAnyPriceData => matchedItemsCount > 0;
  bool get isEmpty => !hasShoppingItems;
}
