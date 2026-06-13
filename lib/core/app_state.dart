import 'package:flutter/widgets.dart';

import 'package:shared_preferences/shared_preferences.dart';



import 'package:savingor_app/core/app_settings_options.dart';

import 'package:savingor_app/core/services/currency_formatter.dart';

import 'package:savingor_app/core/services/exchange_rate_service.dart';



class CurrencyChangeResult {

  const CurrencyChangeResult({

    required this.success,

    this.errorMessage,

    this.successMessage,

    this.rateUpdatedAt,

  });



  final bool success;

  final String? errorMessage;

  final String? successMessage;

  final DateTime? rateUpdatedAt;

}



typedef DisplayAmountConverter = double Function(

  double amount,

  String originalCurrency,

);



class AppState extends ChangeNotifier {

  AppState(this._prefs) : _exchangeRateService = ExchangeRateService(_prefs);



  final SharedPreferences _prefs;

  final ExchangeRateService _exchangeRateService;



  static const _kLang = 'savingor_selected_language_code';

  static const _kOnboarding = 'savingor_onboarding_flow_completed';

  static const _kMonthlyGroceryBudget = 'savingor_monthly_grocery_budget';

  static const _kMonthlyGroceryBudgetCurrency =

      'savingor_monthly_grocery_budget_currency';

  static const _kAppearance = 'savingor_appearance_mode';

  static const _kRegion = 'savingor_region_id';

  static const _kCurrency = 'savingor_currency_code';

  static const double defaultMonthlyGroceryBudget = 100;



  String? _language;

  bool _onboardingCompleted = false;

  double _monthlyGroceryBudget = defaultMonthlyGroceryBudget;

  String _monthlyGroceryBudgetCurrency = AppSettingsOptions.defaultCurrency;

  String _appearance = AppSettingsOptions.defaultAppearance;

  String _region = AppSettingsOptions.defaultRegionId;

  String _currency = AppSettingsOptions.defaultCurrency;

  DateTime? _lastExchangeRateUpdate;

  bool _hydrated = false;



  final Map<String, double> _displayRates = <String, double>{};



  String? get language => _language;



  bool get onboardingCompleted => _onboardingCompleted;



  double get monthlyGroceryBudget => _monthlyGroceryBudget;



  String get monthlyGroceryBudgetCurrency => _monthlyGroceryBudgetCurrency;



  String get appearance => _appearance;



  String get region => _region;



  String get currency => _currency;



  String get appearanceLabel => AppSettingsOptions.appearanceLabel(_appearance);



  String get regionLabel => AppSettingsOptions.regionLabel(_region);



  DateTime? get lastExchangeRateUpdate => _lastExchangeRateUpdate;



  ExchangeRateService get exchangeRateService => _exchangeRateService;



  /// Prefs have been read at least once ([hydrateFromDisk] ran).

  bool get isHydrated => _hydrated;



  void hydrateFromDisk() {

    final raw = _prefs.getString(_kLang);

    _language = (raw != null && raw.isNotEmpty) ? raw : null;

    _onboardingCompleted = _prefs.getBool(_kOnboarding) ?? false;

    _monthlyGroceryBudget =

        _prefs.getDouble(_kMonthlyGroceryBudget) ?? defaultMonthlyGroceryBudget;

    _monthlyGroceryBudgetCurrency = AppSettingsOptions.normalizeCurrency(

      _prefs.getString(_kMonthlyGroceryBudgetCurrency),

    );

    _appearance = AppSettingsOptions.normalizeAppearance(

      _prefs.getString(_kAppearance),

    );

    _region = AppSettingsOptions.normalizeRegion(_prefs.getString(_kRegion));

    _currency = AppSettingsOptions.normalizeCurrency(

      _prefs.getString(_kCurrency),

    );

    _loadCachedDisplayRates();

    _hydrated = true;

    notifyListeners();

  }



  void _loadCachedDisplayRates() {

    _displayRates.clear();

    DateTime? latest;

    for (final String from in AppSettingsOptions.currencyCodes) {

      if (from == _currency) continue;

      final CachedExchangeRate? cached = _exchangeRateService.getCachedRate(

        fromCurrency: from,

        toCurrency: _currency,

      );

      if (cached != null) {

        _displayRates[_rateKey(from, _currency)] = cached.rate;

        if (latest == null || cached.fetchedAt.isAfter(latest)) {

          latest = cached.fetchedAt;

        }

      }

    }

    _lastExchangeRateUpdate = latest;

  }



  static String _rateKey(String from, String to) =>

      '${from.toUpperCase()}_${to.toUpperCase()}';



  double convertToDisplay(double amount, String originalCurrency) {

    final String from = AppSettingsOptions.normalizeCurrency(originalCurrency);

    final String to = _currency;

    if (from == to) return amount;

    final double? rate = _displayRates[_rateKey(from, to)];

    if (rate == null || !rate.isFinite) return amount;

    return amount * rate;

  }



  double get displayMonthlyBudget =>

      convertToDisplay(_monthlyGroceryBudget, _monthlyGroceryBudgetCurrency);



  String formatMoney(double amount, {String? originalCurrency}) {

    final String from =

        AppSettingsOptions.normalizeCurrency(originalCurrency ?? _currency);

    final double converted = convertToDisplay(amount, from);

    return CurrencyFormatter.format(converted, _currency);

  }



  DisplayAmountConverter get toDisplayConverter => convertToDisplay;



  Future<CurrencyChangeResult> changeDisplayCurrency(String newCurrency) async {

    final String target = AppSettingsOptions.normalizeCurrency(newCurrency);

    if (target == _currency) {

      return CurrencyChangeResult(

        success: true,

        successMessage:

            'Currency updated to $target. Financial values were converted using the latest available exchange rate.',

        rateUpdatedAt: _lastExchangeRateUpdate,

      );

    }



    final Map<String, double> nextRates = <String, double>{};

    DateTime? latestUpdate;



    try {

      for (final String from in AppSettingsOptions.currencyCodes) {

        if (from == target) continue;

        final double rate = await _exchangeRateService.getRate(

          fromCurrency: from,

          toCurrency: target,

        );

        nextRates[_rateKey(from, target)] = rate;

        final CachedExchangeRate? cached = _exchangeRateService.getCachedRate(

          fromCurrency: from,

          toCurrency: target,

        );

        if (cached != null) {

          latestUpdate = latestUpdate == null || cached.fetchedAt.isAfter(latestUpdate)

              ? cached.fetchedAt

              : latestUpdate;

        }

      }



      _displayRates

        ..clear()

        ..addAll(nextRates);

      _currency = target;

      _prefs.setString(_kCurrency, target);

      _lastExchangeRateUpdate = latestUpdate ?? DateTime.now();

      notifyListeners();



      return CurrencyChangeResult(

        success: true,

        successMessage:

            'Currency updated to $target. Financial values were converted using the latest available exchange rate.',

        rateUpdatedAt: _lastExchangeRateUpdate,

      );

    } on ExchangeRateException catch (e) {

      return CurrencyChangeResult(success: false, errorMessage: e.message);

    } catch (_) {

      return const CurrencyChangeResult(

        success: false,

        errorMessage: 'Unable to update exchange rates. Please try again.',

      );

    }

  }



  void setLanguage(String lang) {

    const allowed = {'en', 'uk', 'ru', 'fr', 'de', 'es'};

    final c = lang.toLowerCase().trim();

    final code = allowed.contains(c) ? c : 'en';

    _language = code;

    _prefs.setString(_kLang, code);

    notifyListeners();

  }



  void setOnboardingFlowCompleted([bool value = true]) {

    _onboardingCompleted = value;

    _prefs.setBool(_kOnboarding, value);

    notifyListeners();

  }



  void setMonthlyGroceryBudget(double amount, {String? currency}) {

    final double normalized =

        amount.isFinite && amount > 0 ? amount : defaultMonthlyGroceryBudget;

    _monthlyGroceryBudget = normalized;

    _monthlyGroceryBudgetCurrency = AppSettingsOptions.normalizeCurrency(

      currency ?? _currency,

    );

    _prefs.setDouble(_kMonthlyGroceryBudget, normalized);

    _prefs.setString(

      _kMonthlyGroceryBudgetCurrency,

      _monthlyGroceryBudgetCurrency,

    );

    notifyListeners();

  }



  void setAppearance(String mode) {

    final String normalized = AppSettingsOptions.normalizeAppearance(mode);

    _appearance = normalized;

    _prefs.setString(_kAppearance, normalized);

    notifyListeners();

  }



  void setRegion(String regionId) {

    final String normalized = AppSettingsOptions.normalizeRegion(regionId);

    _region = normalized;

    _prefs.setString(_kRegion, normalized);

    notifyListeners();

  }



  @Deprecated('Use changeDisplayCurrency for real FX conversion.')

  void setCurrency(String code) {

    final String normalized = AppSettingsOptions.normalizeCurrency(code);

    _currency = normalized;

    _prefs.setString(_kCurrency, normalized);

    notifyListeners();

  }



  /// Clears onboarding completion for sign-out while preserving language.
  void resetStartupFlowToBeginning() {
    _onboardingCompleted = false;
    _prefs.setBool(_kOnboarding, false);
    notifyListeners();
  }

}



class AppStateProvider extends InheritedNotifier<AppState> {

  const AppStateProvider(

      {super.key, required AppState notifier, required super.child})

      : super(notifier: notifier);



  static AppState of(BuildContext context) {

    final prov = context.dependOnInheritedWidgetOfExactType<AppStateProvider>();

    if (prov == null) throw FlutterError('AppStateProvider not found');

    return prov.notifier!;

  }

}


