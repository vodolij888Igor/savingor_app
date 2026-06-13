import 'package:flutter_test/flutter_test.dart';
import 'package:savingor_app/features/subscription/domain/debug_subscription_override.dart';
import 'package:savingor_app/features/subscription/domain/effective_subscription_resolver.dart';
import 'package:savingor_app/features/subscription/domain/subscription_status.dart';

void main() {
  const SubscriptionStatus realPro = SubscriptionStatus(
    plan: SubscriptionPlan.pro,
    status: SubscriptionState.active,
    provider: SubscriptionProvider.revenuecat,
    price: 14.99,
  );

  group('resolveEffectiveSubscription', () {
    test('no override uses the real subscription state', () {
      expect(
        resolveEffectiveSubscription(
          real: realPro,
          debugOverride: DebugSubscriptionOverride.none,
          debugMode: true,
        ),
        same(realPro),
      );
    });

    test('Free override produces effective Free access', () {
      final SubscriptionStatus effective = resolveEffectiveSubscription(
        real: realPro,
        debugOverride: DebugSubscriptionOverride.free,
        debugMode: true,
      );

      expect(effective, SubscriptionStatus.free);
      expect(effective.hasActiveProAccess, isFalse);
    });

    test('Pro override produces effective Pro access', () {
      final SubscriptionStatus effective = resolveEffectiveSubscription(
        real: SubscriptionStatus.free,
        debugOverride: DebugSubscriptionOverride.pro,
        debugMode: true,
      );

      expect(effective.hasActiveProAccess, isTrue);
      expect(effective.plan, SubscriptionPlan.pro);
    });

    test('override is ignored outside debug mode', () {
      expect(
        resolveEffectiveSubscription(
          real: SubscriptionStatus.free,
          debugOverride: DebugSubscriptionOverride.pro,
          debugMode: false,
        ),
        SubscriptionStatus.free,
      );
    });
  });
}
