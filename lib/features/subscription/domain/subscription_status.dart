/// Strongly-typed subscription state for the signed-in user.
///
/// Source of truth strategy:
/// - Real payments: the RevenueCat "pro" entitlement is the source of truth.
/// - Firestore `users/{uid}` only mirrors the state for UI/cache purposes.
/// - Demo fallback (no RevenueCat keys configured): Firestore mirror only,
///   clearly labeled with [SubscriptionProvider.demo].
library;

enum SubscriptionPlan { free, pro }

enum SubscriptionState { inactive, active, activeDemo, cancelled, unknown }

enum SubscriptionProvider { revenuecat, demo, none }

class SubscriptionStatus {
  const SubscriptionStatus({
    required this.plan,
    required this.status,
    required this.provider,
    this.price,
    this.currency = 'CAD',
  });

  final SubscriptionPlan plan;
  final SubscriptionState status;
  final SubscriptionProvider provider;
  final double? price;
  final String currency;

  bool get isPro =>
      plan == SubscriptionPlan.pro &&
      (status == SubscriptionState.active ||
          status == SubscriptionState.activeDemo);

  /// Whether the user has active Pro entitlement (RevenueCat or demo fallback).
  ///
  /// Prefer this name in feature-access code; it delegates to [isPro].
  bool get hasActiveProAccess => isPro;

  bool get isDemo => provider == SubscriptionProvider.demo;
  bool get isRevenueCat => provider == SubscriptionProvider.revenuecat;

  String get planLabel => plan == SubscriptionPlan.pro ? 'Pro' : 'Free';

  String get statusLabel {
    switch (status) {
      case SubscriptionState.active:
        return 'Active';
      case SubscriptionState.activeDemo:
        return 'Active demo';
      case SubscriptionState.cancelled:
        return 'Cancelled';
      case SubscriptionState.inactive:
        return 'Inactive';
      case SubscriptionState.unknown:
        return 'Unknown';
    }
  }

  String get providerLabel {
    switch (provider) {
      case SubscriptionProvider.revenuecat:
        return 'RevenueCat';
      case SubscriptionProvider.demo:
        return 'Demo mode';
      case SubscriptionProvider.none:
        return 'None';
    }
  }

  static const SubscriptionStatus free = SubscriptionStatus(
    plan: SubscriptionPlan.free,
    status: SubscriptionState.inactive,
    provider: SubscriptionProvider.none,
    price: 0,
  );

  factory SubscriptionStatus.fromFirestore(Map<String, dynamic> data) {
    final String plan =
        (data['subscriptionPlan'] as String?)?.trim().toLowerCase() ?? 'free';
    if (plan != 'pro') {
      return free;
    }
    return SubscriptionStatus(
      plan: SubscriptionPlan.pro,
      status: _stateFrom((data['subscriptionStatus'] as String?)?.trim()),
      provider:
          _providerFrom((data['subscriptionProvider'] as String?)?.trim()),
      price: (data['subscriptionPrice'] as num?)?.toDouble(),
      currency: (data['subscriptionCurrency'] as String?)?.trim() ?? 'CAD',
    );
  }

  static SubscriptionState _stateFrom(String? value) {
    switch (value) {
      case 'active':
        return SubscriptionState.active;
      case 'active_demo':
        return SubscriptionState.activeDemo;
      case 'cancelled':
        return SubscriptionState.cancelled;
      case 'inactive':
        return SubscriptionState.inactive;
      default:
        return SubscriptionState.unknown;
    }
  }

  static SubscriptionProvider _providerFrom(String? value) {
    switch (value) {
      case 'revenuecat':
        return SubscriptionProvider.revenuecat;
      case 'demo':
        return SubscriptionProvider.demo;
      default:
        return SubscriptionProvider.none;
    }
  }
}
