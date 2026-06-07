import 'package:savingor_app/features/price_memory/domain/product_name_normalizer.dart';
import 'package:savingor_app/features/shopping/domain/models/shopping_list_item.dart';

/// Groups shopping list items by normalized product name for basket optimization.
abstract final class ShoppingBasketItemGrouper {
  static String normalizedKey(String productName) {
    return ProductNameNormalizer.normalize(productName);
  }

  /// Trim and normalize casing for new shopping list rows when needed.
  static String formatDisplayName(String productName) {
    final String trimmed = productName.trim();
    if (trimmed.isEmpty) {
      return trimmed;
    }
    if (_hasUppercase(trimmed)) {
      return trimmed;
    }

    return trimmed
        .split(RegExp(r'\s+'))
        .where((String part) => part.isNotEmpty)
        .map(
          (String part) =>
              '${part[0].toUpperCase()}${part.substring(1).toLowerCase()}',
        )
        .join(' ');
  }

  static String itemKey(ShoppingListItem item) {
    return normalizedKey(item.name);
  }

  /// Returns one synthetic [ShoppingListItem] per unique active product with summed quantity.
  ///
  /// Excludes checked/completed items.
  static List<ShoppingListItem> groupByProduct(List<ShoppingListItem> items) {
    final Map<String, _ProductBucket> buckets = <String, _ProductBucket>{};

    for (final ShoppingListItem item in items) {
      if (item.isCompleted || item.name.trim().isEmpty) {
        continue;
      }

      final String key = itemKey(item);
      if (key.isEmpty) {
        continue;
      }

      buckets.putIfAbsent(key, () => _ProductBucket()).add(item.name.trim(), item.quantity);
    }

    final DateTime now = DateTime.now();
    return buckets.entries
        .map(
          (MapEntry<String, _ProductBucket> entry) => ShoppingListItem(
            id: 'grouped:${entry.key}',
            name: entry.value.displayName,
            quantity: entry.value.totalQuantity,
            isCompleted: false,
            createdAt: now,
            updatedAt: now,
          ),
        )
        .toList(growable: false);
  }

  /// First active item in [items] matching [normalizedKey], if any.
  static ShoppingListItem? findActiveDuplicate({
    required List<ShoppingListItem> items,
    required String normalizedKey,
  }) {
    if (normalizedKey.isEmpty) {
      return null;
    }

    for (final ShoppingListItem item in items) {
      if (item.isActive && itemKey(item) == normalizedKey) {
        return item;
      }
    }
    return null;
  }

  /// Merges a new item payload into an existing active row.
  static ShoppingListItem mergeItemPayload({
    required ShoppingListItem existing,
    required String newName,
    required int addedQuantity,
    String? addedStore,
    double? addedUnitPrice,
  }) {
    final int combinedQuantity =
        (existing.quantity + addedQuantity).clamp(1, 999);
    final String? trimmedStore = addedStore?.trim();
    final String? resolvedStore =
        trimmedStore != null && trimmedStore.isNotEmpty
            ? trimmedStore
            : (existing.store != null && existing.store!.isNotEmpty
                ? existing.store
                : null);
    final double? resolvedPrice = addedUnitPrice ?? existing.unitPrice;
    final String resolvedName =
        _preferDisplayName(existing.name, formatDisplayName(newName));

    return existing.copyWith(
      name: resolvedName,
      quantity: combinedQuantity,
      store: resolvedStore,
      unitPrice: resolvedPrice,
    );
  }

  static String _preferDisplayName(String existingName, String newName) {
    if (newName.isEmpty) {
      return existingName;
    }
    if (existingName.isEmpty) {
      return newName;
    }
    if (!_hasUppercase(existingName) && _hasUppercase(newName)) {
      return newName;
    }
    return existingName;
  }

  static bool _hasUppercase(String value) => value != value.toLowerCase();
}

class _ProductBucket {
  String displayName = '';
  int totalQuantity = 0;

  void add(String name, int quantity) {
    totalQuantity += quantity;
    if (displayName.isEmpty) {
      displayName = name;
      return;
    }
    if (!ShoppingBasketItemGrouper._hasUppercase(displayName) &&
        ShoppingBasketItemGrouper._hasUppercase(name)) {
      displayName = name;
    }
  }
}
