import 'package:flutter/foundation.dart';

import 'package:savingor_app/features/subscription/domain/debug_subscription_override.dart';
import 'package:savingor_app/features/subscription/domain/subscription_status.dart';

/// Resolves the subscription state used for feature access and UI previews.
///
/// Never writes to Firestore or contacts RevenueCat — pure transformation only.
SubscriptionStatus resolveEffectiveSubscription({
  required SubscriptionStatus real,
  required DebugSubscriptionOverride debugOverride,
  bool debugMode = kDebugMode,
}) {
  if (!debugMode || debugOverride == DebugSubscriptionOverride.none) {
    return real;
  }

  if (debugOverride == DebugSubscriptionOverride.free) {
    return SubscriptionStatus.free;
  }

  return const SubscriptionStatus(
    plan: SubscriptionPlan.pro,
    status: SubscriptionState.activeDemo,
    provider: SubscriptionProvider.demo,
    price: 14.99,
    currency: 'CAD',
  );
}
