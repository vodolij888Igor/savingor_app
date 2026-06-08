import 'package:flutter/widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppState extends ChangeNotifier {
  AppState(this._prefs);

  final SharedPreferences _prefs;

  static const _kLang = 'savingor_selected_language_code';
  static const _kOnboarding = 'savingor_onboarding_flow_completed';
  static const _kMonthlyGroceryBudget = 'savingor_monthly_grocery_budget';
  static const double defaultMonthlyGroceryBudget = 100;

  String? _language;
  bool _onboardingCompleted = false;
  double _monthlyGroceryBudget = defaultMonthlyGroceryBudget;
  bool _hydrated = false;

  String? get language => _language;

  bool get onboardingCompleted => _onboardingCompleted;

  double get monthlyGroceryBudget => _monthlyGroceryBudget;

  /// Prefs have been read at least once ([hydrateFromDisk] ran).
  bool get isHydrated => _hydrated;

  void hydrateFromDisk() {
    final raw = _prefs.getString(_kLang);
    _language = (raw != null && raw.isNotEmpty) ? raw : null;
    _onboardingCompleted = _prefs.getBool(_kOnboarding) ?? false;
    _monthlyGroceryBudget =
        _prefs.getDouble(_kMonthlyGroceryBudget) ?? defaultMonthlyGroceryBudget;
    _hydrated = true;
    notifyListeners();
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

  void setMonthlyGroceryBudget(double amount) {
    final double normalized = amount.isFinite && amount > 0 ? amount : defaultMonthlyGroceryBudget;
    _monthlyGroceryBudget = normalized;
    _prefs.setDouble(_kMonthlyGroceryBudget, normalized);
    notifyListeners();
  }

  /// Clears saved language and onboarding completion so the cold-start gate runs again.
  ///
  /// TODO(auth): When real authentication exists, clear only auth/session tokens here
  /// (or in a dedicated auth service) and route based on whether the user should revisit
  /// language selection. For now this supports a full “return to start” from Profile.
  void resetStartupFlowToBeginning() {
    _language = null;
    _onboardingCompleted = false;
    _prefs.remove(_kLang);
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
