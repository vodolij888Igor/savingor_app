/// Result of adding an item to a shopping list from product price detail.
enum ShoppingListAddItemResult {
  added,
  alreadyExists,
  quantityUpdated,
  notAuthenticated,
  failed,
}
