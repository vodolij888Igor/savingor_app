import 'package:savingor_app/features/price_memory/domain/product_name_normalizer.dart';
import 'package:savingor_app/features/receipts/domain/models/receipt_item.dart';
import 'package:savingor_app/features/shopping/domain/models/shopping_list_item.dart';

/// Draft data for finalizing a shopping trip into a receipt.
class ShoppingTripReceiptDraft {
  const ShoppingTripReceiptDraft({
    required this.purchasedItems,
    this.suggestedStoreName,
    required this.hasMultipleStores,
  });

  final List<ShoppingListItem> purchasedItems;
  final String? suggestedStoreName;
  final bool hasMultipleStores;

  bool get isEmpty => purchasedItems.isEmpty;
}

/// Builds receipt payloads from completed shopping list items.
abstract final class ShoppingTripReceiptBuilder {
  static ShoppingTripReceiptDraft buildDraft({
    required List<ShoppingListItem> listItems,
  }) {
    final List<ShoppingListItem> purchasedItems = listItems
        .where((ShoppingListItem item) => item.isCompleted)
        .toList(growable: false);

    final Set<String> storeNames = <String>{};
    for (final ShoppingListItem item in purchasedItems) {
      final String? store = item.store?.trim();
      if (store != null && store.isNotEmpty) {
        storeNames.add(store);
      }
    }

    return ShoppingTripReceiptDraft(
      purchasedItems: purchasedItems,
      suggestedStoreName: storeNames.length == 1 ? storeNames.first : null,
      hasMultipleStores: storeNames.length > 1,
    );
  }

  static List<ReceiptItem> buildReceiptItems({
    required List<ShoppingListItem> purchasedItems,
    required Map<String, double> unitPricesByItemId,
  }) {
    final List<ReceiptItem> items = <ReceiptItem>[];

    for (final ShoppingListItem item in purchasedItems) {
      final double? unitPrice = unitPricesByItemId[item.id];
      if (unitPrice == null || unitPrice <= 0) {
        continue;
      }

      final double quantity = item.quantity.toDouble();
      final double lineTotal = unitPrice * quantity;

      items.add(
        ReceiptItem.create(
          name: item.name.trim(),
          normalizedName: ProductNameNormalizer.normalize(item.name),
          category: item.category,
          quantity: quantity,
          unitPrice: unitPrice,
          totalPrice: lineTotal,
        ),
      );
    }

    return items;
  }

  static double computeSubtotal(List<ReceiptItem> items) {
    return items.fold<double>(
      0,
      (double sum, ReceiptItem item) => sum + item.totalPrice,
    );
  }

  static String buildNotes({required String listTitle}) {
    return 'Created from shopping list: $listTitle';
  }
}
