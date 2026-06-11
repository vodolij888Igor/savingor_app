/// RevenueCat configuration for Savingor Pro in-app subscriptions.
///
/// Production architecture:
/// Flutter app → RevenueCat SDK → Apple StoreKit / Google Play Billing →
/// RevenueCat "pro" entitlement → app unlocks Pro features.
///
/// Only PUBLIC RevenueCat SDK keys belong here — never secret server keys.
/// Keys are supplied at build time so local portfolio builds run safely in
/// demo-fallback mode:
///
///   flutter run \
///     --dart-define=REVENUECAT_ANDROID_API_KEY=goog_xxx \
///     --dart-define=REVENUECAT_IOS_API_KEY=appl_xxx
class RevenueCatConfig {
  static const String androidApiKey =
      String.fromEnvironment('REVENUECAT_ANDROID_API_KEY');
  static const String iosApiKey =
      String.fromEnvironment('REVENUECAT_IOS_API_KEY');

  /// Entitlement that unlocks all Pro features (clean future identifier).
  static const String entitlementPro = 'pro';

  /// Actual entitlement identifier currently configured in the RevenueCat
  /// dashboard.
  static const String entitlementSavingorPro = 'Savingor Pro';

  /// All entitlement identifiers that unlock Pro. Pro is active when any of
  /// these entitlements is active on the CustomerInfo.
  static const List<String> proEntitlementIds = <String>[
    entitlementSavingorPro,
    entitlementPro,
  ];

  /// RevenueCat offering containing the Pro packages.
  static const String offeringId = 'default';

  /// Store product id for the monthly Pro subscription ($14.99 / month CAD).
  static const String productProMonthly = 'savingor_pro_monthly';

  /// True when at least one platform key was provided at build time.
  /// When false the app must keep working in demo-fallback mode.
  static bool get isConfigured =>
      androidApiKey.isNotEmpty || iosApiKey.isNotEmpty;
}
