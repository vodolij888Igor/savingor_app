import 'package:flutter/widgets.dart';

import 'package:savingor_app/l10n/app_localizations.dart';

/// Back-compat wrapper around generated [AppLocalizations] for screens
/// not yet migrated to direct l10n access in later phases.
class AppStrings {
  const AppStrings(this._l10n);

  final AppLocalizations _l10n;

  static AppStrings of(BuildContext context) =>
      AppStrings(AppLocalizations.of(context));

  String get appName => _l10n.appName;
  String get appSubtitle => _l10n.appSubtitle;
  String get deals => _l10n.deals;
  String get home => _l10n.home;
  String get receipts => _l10n.receipts;
  String get analytics => _l10n.analytics;
  String get profile => _l10n.profile;
  String get scanner => _l10n.scanner;
  String get shopping => _l10n.shopping;
  String get saved => _l10n.saved;
  String get dealsMap => _l10n.dealsMap;
  String get receiptScanner => _l10n.receiptScanner;
  String get shoppingList => _l10n.shoppingList;
  String get mvp => _l10n.mvp;
  String get searchHint => _l10n.searchHint;
  String get filter => _l10n.filter;
  String get dealsMapSubtitle => _l10n.dealsMapSubtitle;
  String get receiptScannerSubtitle => _l10n.receiptScannerSubtitle;
  String get shoppingListSubtitle => _l10n.shoppingListSubtitle;
  String dealsCount(int count) => _l10n.dealsCount(count);
  String get noDealsFound => _l10n.noDealsFound;
  String get resetFilters => _l10n.resetFilters;
  String get filtersTitle => _l10n.filtersTitle;
  String get aiAssistant => _l10n.aiAssistant;
  String get storesMap => _l10n.storesMap;
  String get stores => _l10n.stores;
  String get maxPrice => _l10n.maxPrice;
  String get sort => _l10n.sort;
  String get none => _l10n.none;
  String get priceLowHigh => _l10n.priceLowHigh;
  String get priceHighLow => _l10n.priceHighLow;
  String get dealDetails => _l10n.dealDetails;
  String get dealNotFound => _l10n.dealNotFound;
  String get saveDeal => _l10n.saveDeal;
  String get removeSaved => _l10n.removeSaved;
  String get noSavedDeals => _l10n.noSavedDeals;
  String get savedHint => _l10n.savedHint;
  String get scanReceipt => _l10n.scanReceipt;
}
