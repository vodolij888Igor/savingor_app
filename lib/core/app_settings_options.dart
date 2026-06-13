/// Supported app-level preference values for Profile and App settings.
abstract final class AppSettingsOptions {
  static const String defaultAppearance = 'light';
  static const String defaultRegionId = 'ca';
  static const String defaultCurrency = 'CAD';

  static const Set<String> appearanceModes = <String>{'light', 'dark'};
  static const Set<String> regionIds = <String>{'ca', 'us'};
  static const Set<String> currencyCodes = <String>{'CAD', 'USD'};

  static const List<AppRegionOption> regions = <AppRegionOption>[
    AppRegionOption(id: 'ca', label: 'Canada'),
    AppRegionOption(id: 'us', label: 'United States'),
  ];

  static const List<String> currencies = <String>['CAD', 'USD'];

  static const Map<String, String> languageNativeNames = <String, String>{
    'en': 'English',
    'uk': 'Українська',
    'ru': 'Русский',
    'fr': 'Français',
    'de': 'Deutsch',
    'es': 'Español',
  };

  static String languageNativeName(String? code) {
    if (code == null) return languageNativeNames['en']!;
    final String normalized = code.trim().toLowerCase();
    if (normalized.isEmpty) return languageNativeNames['en']!;
    return languageNativeNames[normalized] ?? code;
  }

  static String languageDisplayName(String? code) =>
      languageNativeName(code);

  static String appearanceLabel(String mode) {
    return mode == 'dark' ? 'Dark' : 'Light';
  }

  static String regionLabel(String regionId) {
    for (final AppRegionOption option in regions) {
      if (option.id == regionId) return option.label;
    }
    return regions.first.label;
  }

  static String normalizeAppearance(String? raw) {
    final String value = (raw ?? defaultAppearance).toLowerCase().trim();
    return appearanceModes.contains(value) ? value : defaultAppearance;
  }

  static String normalizeRegion(String? raw) {
    final String value = (raw ?? defaultRegionId).toLowerCase().trim();
    return regionIds.contains(value) ? value : defaultRegionId;
  }

  static String normalizeCurrency(String? raw) {
    final String value = (raw ?? defaultCurrency).toUpperCase().trim();
    return currencyCodes.contains(value) ? value : defaultCurrency;
  }
}

class AppRegionOption {
  const AppRegionOption({required this.id, required this.label});

  final String id;
  final String label;
}
