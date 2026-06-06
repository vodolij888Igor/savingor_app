import 'package:savingor_app/features/shopping/domain/models/shopping_list_item.dart';

/// Unchecked shopping items collected from all active lists, with metadata.
class GlobalShoppingItemsSnapshot {
  const GlobalShoppingItemsSnapshot({
    required this.uncheckedItems,
    required this.activeListsIncluded,
  });

  final List<ShoppingListItem> uncheckedItems;
  final int activeListsIncluded;

  bool get isEmpty => uncheckedItems.isEmpty;
}
