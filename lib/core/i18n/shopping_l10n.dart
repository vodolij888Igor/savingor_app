import 'package:flutter/widgets.dart';

import 'package:savingor_app/l10n/app_localizations.dart';

/// Localized display labels for shopping list store error messages.
abstract final class ShoppingL10n {
  static String localizeError(BuildContext context, String? error) {
    if (error == null || error.isEmpty) {
      return '';
    }

    final AppLocalizations l10n = AppLocalizations.of(context);
    return switch (error) {
      'Could not load your shopping lists. Please try again.' =>
        l10n.couldNotLoadYourShoppingLists,
      'Could not load list items. Please try again.' =>
        l10n.couldNotLoadListItems,
      'Sign in to create shopping lists.' => l10n.signInToCreateShoppingLists,
      'Could not create the list. Please try again.' =>
        l10n.couldNotCreateList,
      'Could not delete the list. Please try again.' =>
        l10n.couldNotDeleteList,
      'Could not add the item. Please try again.' => l10n.couldNotAddItem,
      'Sign in to add items to your shopping list.' =>
        l10n.signInToAddShoppingItems,
      'Item name is required.' => l10n.itemNameRequired,
      'Could not update the item. Please try again.' =>
        l10n.couldNotUpdateItem,
      'Could not update quantity. Please try again.' =>
        l10n.couldNotUpdateQuantity,
      'Could not remove the item. Please try again.' =>
        l10n.couldNotRemoveItem,
      'Could not update the shopping list. Please try again.' =>
        l10n.couldNotUpdateShoppingList,
      'List title is required.' => l10n.enterListName,
      _ => error,
    };
  }

  static String localizeListsError(BuildContext context, String? error) =>
      localizeError(context, error);

  static String localizeItemsError(BuildContext context, String? error) =>
      localizeError(context, error);

  /// Display-only localization for known default list titles stored in Firestore.
  static String localizedShoppingListName(BuildContext context, String rawName) {
    if (rawName.trim().toLowerCase() == 'weekly groceries') {
      return AppLocalizations.of(context).weeklyGroceriesDefault;
    }
    return rawName;
  }
}
