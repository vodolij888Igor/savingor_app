/// Local developer-only subscription preview mode (debug builds only).
enum DebugSubscriptionOverride {
  /// Use the real RevenueCat / Firestore subscription state.
  none,

  /// Force effective access to the Free plan for local testing.
  free,

  /// Force effective access to the Pro plan for local testing.
  pro,
}

/// SharedPreferences serialization for [DebugSubscriptionOverride].
extension DebugSubscriptionOverrideStorage on DebugSubscriptionOverride {
  static const String preferenceKey = 'savingor_debug_subscription_override';

  String get storageValue => name;

  static DebugSubscriptionOverride fromStorage(String? value) {
    switch (value) {
      case 'free':
        return DebugSubscriptionOverride.free;
      case 'pro':
        return DebugSubscriptionOverride.pro;
      case 'none':
      default:
        return DebugSubscriptionOverride.none;
    }
  }
}
