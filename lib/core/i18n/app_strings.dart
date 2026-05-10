import 'package:flutter/widgets.dart';

class AppLocalizations extends InheritedWidget {
  final Map<String, String> strings;

  const AppLocalizations(
      {super.key, required this.strings, required super.child});

  static AppLocalizations of(BuildContext context) {
    final loc = context.dependOnInheritedWidgetOfExactType<AppLocalizations>();
    if (loc == null) throw FlutterError('AppLocalizations not found');
    return loc;
  }

  @override
  bool updateShouldNotify(covariant AppLocalizations oldWidget) =>
      oldWidget.strings != strings;
}

class AppStrings {
  final Map<String, String> _s;

  AppStrings(this._s);

  static AppStrings of(BuildContext context) =>
      AppStrings(AppLocalizations.of(context).strings);

  String get appName => _s['app_name'] ?? 'Savingor';
  String get appSubtitle => _s['app_subtitle'] ?? '';
  String get deals => _s['deals'] ?? 'Deals';
  String get scanner => _s['scanner'] ?? 'Scanner';
  String get shopping => _s['shopping'] ?? 'Shopping';
  String get saved => _s['saved'] ?? 'Saved';
  String get dealsMap => _s['deals_map'] ?? 'Deals Map';
  String get receiptScanner => _s['receipt_scanner'] ?? 'Receipt Scanner';
  String get shoppingList => _s['shopping_list'] ?? 'Shopping List';
  String get mvp => _s['mvp'] ?? 'MVP v0.1';
  String get searchHint => _s['search_hint'] ?? 'Search...';
  String get filter => _s['filter'] ?? 'Filter';
  String get dealsMapSubtitle =>
      _s['deals_map_subtitle'] ?? 'Shows nearby deals';
  String get receiptScannerSubtitle =>
      _s['receipt_scanner_subtitle'] ?? 'Scan receipt';
  String get shoppingListSubtitle =>
      _s['shopping_list_subtitle'] ?? 'Smart list';
  String dealsCount(int count) =>
      (_s['deals_count'] ?? '{count} deals').replaceAll('{count}', '$count');
  String get noDealsFound => _s['no_deals_found'] ?? 'No deals found';
  String get resetFilters => _s['reset_filters'] ?? 'Reset filters';
  String get filtersTitle => _s['filters_title'] ?? 'Filters';
  String get stores => _s['stores'] ?? 'Stores';
  String get maxPrice => _s['max_price'] ?? 'Max price';
  String get sort => _s['sort'] ?? 'Sort';
  String get none => _s['none'] ?? 'None';
  String get priceLowHigh => _s['price_low_high'] ?? 'Price low→high';
  String get priceHighLow => _s['price_high_low'] ?? 'Price high→low';
  String get dealDetails => _s['deal_details'] ?? 'Deal Details';
  String get dealNotFound => _s['deal_not_found'] ?? 'Deal not found';
  String get saveDeal => _s['save_deal'] ?? 'Save deal';
  String get removeSaved => _s['remove_saved'] ?? 'Remove saved';
  String get noSavedDeals => _s['no_saved_deals'] ?? 'No saved deals yet';
  String get savedHint => _s['saved_hint'] ?? 'Saved deals appear here';
}
