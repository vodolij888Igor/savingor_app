import 'package:savingor_app/features/price_memory/domain/product_name_normalizer.dart';
import 'package:savingor_app/features/receipts/domain/models/receipt_item.dart';
import 'package:savingor_app/features/shopping/domain/models/shopping_list_item.dart';

/// Purchased items grouped by store for multi-receipt finalization.
class ShoppingTripStoreGroup {
  const ShoppingTripStoreGroup({
    required this.storeName,
    required this.items,
  });

  final String storeName;
  final List<ShoppingListItem> items;

  bool get hasStoreName => storeName.trim().isNotEmpty;
}

/// Draft data for finalizing a shopping trip into a receipt.
class ShoppingTripReceiptDraft {
  const ShoppingTripReceiptDraft({
    required this.purchasedItems,
    required this.storeGroups,
    this.suggestedStoreName,
    required this.hasMultipleStores,
  });

  final List<ShoppingListItem> purchasedItems;
  final List<ShoppingTripStoreGroup> storeGroups;
  final String? suggestedStoreName;
  final bool hasMultipleStores;

  bool get isEmpty => purchasedItems.isEmpty;

  int get receiptCount => storeGroups.isEmpty ? 0 : storeGroups.length;

  bool get allGroupsHaveStoreNames =>
      storeGroups.every((ShoppingTripStoreGroup group) => group.hasStoreName);
}

/// Builds receipt payloads from completed shopping list items.
abstract final class ShoppingTripReceiptBuilder {
  static ShoppingTripReceiptDraft buildDraft({
    required List<ShoppingListItem> listItems,
  }) {
    final List<ShoppingListItem> purchasedItems = listItems
        .where((ShoppingListItem item) => item.isCompleted)
        .toList(growable: false);

    final List<ShoppingTripStoreGroup> storeGroups =
        buildStoreGroups(purchasedItems);

    final Set<String> normalizedStoreKeys = <String>{};
    for (final ShoppingTripStoreGroup group in storeGroups) {
      if (group.hasStoreName) {
        normalizedStoreKeys.add(_normalizedStoreKey(group.storeName));
      }
    }

    return ShoppingTripReceiptDraft(
      purchasedItems: purchasedItems,
      storeGroups: storeGroups,
      suggestedStoreName:
          storeGroups.length == 1 && storeGroups.first.hasStoreName
              ? storeGroups.first.storeName
              : null,
      hasMultipleStores: normalizedStoreKeys.length > 1,
    );
  }

  static List<ShoppingTripStoreGroup> buildStoreGroups(
    List<ShoppingListItem> purchasedItems,
  ) {
    if (purchasedItems.isEmpty) {
      return const <ShoppingTripStoreGroup>[];
    }

    final Map<String, _StoreGroupBucket> buckets =
        <String, _StoreGroupBucket>{};

    for (final ShoppingListItem item in purchasedItems) {
      final String storeName = _displayStoreName(item.store);
      final String bucketKey = storeName.isEmpty
          ? '__missing_store__'
          : _normalizedStoreKey(storeName);

      buckets.putIfAbsent(bucketKey, () => _StoreGroupBucket()).add(
            storeName: storeName,
            item: item,
          );
    }

    final List<ShoppingTripStoreGroup> groups = buckets.values
        .map(
          (_StoreGroupBucket bucket) => ShoppingTripStoreGroup(
            storeName: bucket.storeName,
            items: List<ShoppingListItem>.unmodifiable(bucket.items),
          ),
        )
        .toList(growable: false)
      ..sort(
        (ShoppingTripStoreGroup a, ShoppingTripStoreGroup b) =>
            a.storeName.toLowerCase().compareTo(b.storeName.toLowerCase()),
      );

    return groups;
  }

  static String resolveStoreName({
    required ShoppingTripStoreGroup group,
    required String? formStoreName,
  }) {
    if (group.hasStoreName) {
      return group.storeName.trim();
    }

    return formStoreName?.trim() ?? '';
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

  static String finalizeSuccessMessage(int receiptCount) {
    if (receiptCount == 1) {
      return 'Shopping trip finalized. 1 receipt created.';
    }
    return 'Shopping trip finalized. $receiptCount receipts created.';
  }

  static String _displayStoreName(String? store) {
    return store?.trim() ?? '';
  }

  static String _normalizedStoreKey(String storeName) {
    return storeName.trim().toLowerCase();
  }
}

class _StoreGroupBucket {
  String storeName = '';
  final List<ShoppingListItem> items = <ShoppingListItem>[];

  void add({
    required String storeName,
    required ShoppingListItem item,
  }) {
    if (this.storeName.isEmpty && storeName.isNotEmpty) {
      this.storeName = storeName;
    }
    items.add(item);
  }
}
