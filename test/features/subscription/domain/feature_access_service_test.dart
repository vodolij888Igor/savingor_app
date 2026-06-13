import 'package:flutter_test/flutter_test.dart';
import 'package:savingor_app/features/subscription/domain/feature_access_policy.dart';
import 'package:savingor_app/features/subscription/domain/feature_access_service.dart';
import 'package:savingor_app/features/subscription/domain/savingor_feature.dart';
import 'package:savingor_app/features/subscription/domain/subscription_status.dart';

void main() {
  const FeatureAccessService service = FeatureAccessService();

  group('FeatureAccessService.canAccess', () {
    test('Free user can access receiptScanning', () {
      expect(
        service.canAccess(
          feature: SavingorFeature.receiptScanning,
          isPro: false,
        ),
        isTrue,
      );
    });

    test('Free user cannot access aiSavingsAssistant', () {
      expect(
        service.canAccess(
          feature: SavingorFeature.aiSavingsAssistant,
          isPro: false,
        ),
        isFalse,
      );
    });

    test('Free user cannot access basketOptimizer', () {
      expect(
        service.canAccess(
          feature: SavingorFeature.basketOptimizer,
          isPro: false,
        ),
        isFalse,
      );
    });

    test('Free user cannot access savingsAnalytics', () {
      expect(
        service.canAccess(
          feature: SavingorFeature.savingsAnalytics,
          isPro: false,
        ),
        isFalse,
      );
    });

    test('Free user can access basic productPriceInsights', () {
      expect(
        service.canAccess(
          feature: SavingorFeature.productPriceInsights,
          isPro: false,
        ),
        isTrue,
      );
    });

    test('Free user can access basic savingsOpportunities', () {
      expect(
        service.canAccess(
          feature: SavingorFeature.savingsOpportunities,
          isPro: false,
        ),
        isTrue,
      );
    });

    test('Free user cannot access advancedPriceIntelligence', () {
      expect(
        service.canAccess(
          feature: SavingorFeature.advancedPriceIntelligence,
          isPro: false,
        ),
        isFalse,
      );
    });

    test('Pro user can access premium savings intelligence features', () {
      for (final SavingorFeature feature in <SavingorFeature>[
        SavingorFeature.basketOptimizer,
        SavingorFeature.savingsAnalytics,
        SavingorFeature.advancedPriceIntelligence,
        SavingorFeature.personalizedSavingsIntelligence,
      ]) {
        expect(
          service.canAccess(feature: feature, isPro: true),
          isTrue,
          reason: 'Pro user should access $feature',
        );
      }
    });

    test('Pro user can access every SavingorFeature', () {
      for (final SavingorFeature feature in SavingorFeature.values) {
        expect(
          service.canAccess(feature: feature, isPro: true),
          isTrue,
          reason: 'Pro user should access $feature',
        );
      }
    });
  });

  group('FeatureAccessService.requiresPro', () {
    test('receiptScanning does not require Pro', () {
      expect(service.requiresPro(SavingorFeature.receiptScanning), isFalse);
    });

    test('basic productPriceInsights does not require Pro', () {
      expect(
        service.requiresPro(SavingorFeature.productPriceInsights),
        isFalse,
      );
    });

    test('basic savingsOpportunities does not require Pro', () {
      expect(
        service.requiresPro(SavingorFeature.savingsOpportunities),
        isFalse,
      );
    });

    test('Pro-only features require Pro', () {
      for (final SavingorFeature feature
          in FeatureAccessPolicy.proOnlyFeatures) {
        expect(
          service.requiresPro(feature),
          isTrue,
          reason: '$feature should require Pro',
        );
      }
    });
  });

  group('FeatureAccessService.freeMonthlyReceiptScanLimit', () {
    test('equals 3', () {
      expect(service.freeMonthlyReceiptScanLimit, 3);
      expect(
        FeatureAccessPolicy.freeMonthlyReceiptScanLimit,
        3,
      );
    });
  });

  group('FeatureAccessService.canAccessForStatus', () {
    test('uses SubscriptionStatus.hasActiveProAccess', () {
      expect(
        service.canAccessForStatus(
          feature: SavingorFeature.aiSavingsAssistant,
          status: SubscriptionStatus.free,
        ),
        isFalse,
      );

      const SubscriptionStatus activePro = SubscriptionStatus(
        plan: SubscriptionPlan.pro,
        status: SubscriptionState.active,
        provider: SubscriptionProvider.revenuecat,
        price: 14.99,
      );

      expect(activePro.hasActiveProAccess, isTrue);
      expect(
        service.canAccessForStatus(
          feature: SavingorFeature.aiSavingsAssistant,
          status: activePro,
        ),
        isTrue,
      );
    });
  });
}
