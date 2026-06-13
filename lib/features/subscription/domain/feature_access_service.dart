import 'package:savingor_app/features/subscription/domain/feature_access_policy.dart';
import 'package:savingor_app/features/subscription/domain/savingor_feature.dart';
import 'package:savingor_app/features/subscription/domain/subscription_status.dart';

/// Single source of truth for Savingor Free / Pro feature access.
///
/// Widgets and screens should delegate to this service instead of comparing
/// plan strings or duplicating subscription rules.
class FeatureAccessService {
  const FeatureAccessService();

  /// Returns whether the user may use [feature].
  ///
  /// [isPro] should come from [SubscriptionStatus.hasActiveProAccess] or
  /// [SubscriptionService.isPro] — never from UI labels alone.
  bool canAccess({
    required SavingorFeature feature,
    required bool isPro,
  }) {
    if (!requiresPro(feature)) {
      return true;
    }
    return isPro;
  }

  /// Convenience wrapper that reads Pro access from [SubscriptionStatus].
  bool canAccessForStatus({
    required SavingorFeature feature,
    required SubscriptionStatus status,
  }) {
    return canAccess(feature: feature, isPro: status.hasActiveProAccess);
  }

  /// Returns whether [feature] is restricted to Pro subscribers.
  bool requiresPro(SavingorFeature feature) {
    return FeatureAccessPolicy.requiresPro(feature);
  }

  /// Free-plan monthly receipt scan cap enforced by [MonthlyReceiptScanUsageService].
  int get freeMonthlyReceiptScanLimit {
    return FeatureAccessPolicy.freeMonthlyReceiptScanLimit;
  }
}
