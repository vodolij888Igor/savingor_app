import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:savingor_app/features/subscription/presentation/subscription_plan_presentation.dart';
import 'package:savingor_app/l10n/app_localizations.dart';

void main() {
  late AppLocalizations l10n;

  setUpAll(() async {
    l10n = await AppLocalizations.delegate.load(const Locale('en'));
  });

  group('SubscriptionPlanPresentation', () {
    test('free plan shows 3 receipt scans per month', () {
      final List<String> features =
          SubscriptionPlanPresentation.freeIncludedFeatures(l10n);

      expect(features, contains(l10n.planFeatureThreeReceiptScansPerMonth));
      expect(
        SubscriptionPlanPresentation.freeMonthlyReceiptScanLimit,
        3,
      );
    });

    test('pro plan shows unlimited receipt scanning', () {
      final List<String> features =
          SubscriptionPlanPresentation.proActiveFeatures(l10n);

      expect(features, contains(l10n.planFeatureUnlimitedReceiptScanning));
      expect(
          features, isNot(contains(l10n.planFeatureThreeReceiptScansPerMonth)));
    });

    test('basic savings opportunities are included in free plan card', () {
      final List<String> features =
          SubscriptionPlanPresentation.freeIncludedFeatures(l10n);

      expect(features, contains(l10n.planFeatureBasicSavingsOpportunities));
    });

    test('basic product price insights are included in free plan card', () {
      final List<String> features =
          SubscriptionPlanPresentation.freeIncludedFeatures(l10n);

      expect(features, contains(l10n.planFeatureBasicProductPriceInsights));
    });

    test('free plan does not list pro-only automation features', () {
      final List<String> features =
          SubscriptionPlanPresentation.freeIncludedFeatures(l10n);

      expect(features, isNot(contains(l10n.aiSavingsAssistant)));
      expect(features, isNot(contains(l10n.planFeatureBasketOptimizer)));
      expect(
          features, isNot(contains(l10n.planFeatureAdvancedSavingsAnalytics)));
      expect(
          features, isNot(contains(l10n.planFeatureUnlimitedReceiptScanning)));
    });

    test('pro active features include AI assistant, basket, and analytics', () {
      final List<String> features =
          SubscriptionPlanPresentation.proActiveFeatures(l10n);

      expect(features, contains(l10n.aiSavingsAssistant));
      expect(features, contains(l10n.planFeatureBasketOptimizer));
      expect(features, contains(l10n.planFeatureAdvancedSavingsAnalytics));
    });

    test('future pro features are marked separately from active features', () {
      final List<String> active =
          SubscriptionPlanPresentation.proActiveFeatures(l10n);
      final List<String> comingSoon =
          SubscriptionPlanPresentation.proComingSoonFeatures(l10n);

      expect(comingSoon, contains(l10n.planFeatureSmartPriceDropAlerts));
      expect(comingSoon, contains(l10n.planFeatureAdvancedSpendingReports));
      expect(active, isNot(contains(l10n.planFeatureSmartPriceDropAlerts)));
      expect(active, isNot(contains(l10n.planFeatureAdvancedSpendingReports)));
    });

    group('comparison table', () {
      test('receipt scans show 3 per month for free and unlimited for pro', () {
        final PlanComparisonRow row =
            SubscriptionPlanPresentation.comparisonRows(l10n).first;

        expect(row.featureLabel, l10n.planCompareReceiptScans);
        expect(row.freeAvailability, PlanComparisonAvailability.threePerMonth);
        expect(row.proAvailability, PlanComparisonAvailability.unlimited);
        expect(
          SubscriptionPlanPresentation.availabilityLabel(
            l10n,
            row.freeAvailability,
          ),
          l10n.planAvailabilityThreeScansPerMonth,
        );
        expect(
          SubscriptionPlanPresentation.availabilityLabel(
            l10n,
            row.proAvailability,
          ),
          l10n.planAvailabilityUnlimited,
        );
      });

      test('AI assistant is locked on free and included on pro', () {
        final PlanComparisonRow row =
            SubscriptionPlanPresentation.comparisonRows(
          l10n,
        ).singleWhere(
          (PlanComparisonRow item) =>
              item.featureLabel == l10n.aiSavingsAssistant,
        );

        expect(row.freeAvailability, PlanComparisonAvailability.locked);
        expect(row.proAvailability, PlanComparisonAvailability.included);
      });

      test('basket optimizer is locked on free and included on pro', () {
        final PlanComparisonRow row =
            SubscriptionPlanPresentation.comparisonRows(
          l10n,
        ).singleWhere(
          (PlanComparisonRow item) =>
              item.featureLabel == l10n.planFeatureBasketOptimizer,
        );

        expect(row.freeAvailability, PlanComparisonAvailability.locked);
        expect(row.proAvailability, PlanComparisonAvailability.included);
      });

      test('savings analytics is locked on free and included on pro', () {
        final PlanComparisonRow row =
            SubscriptionPlanPresentation.comparisonRows(
          l10n,
        ).singleWhere(
          (PlanComparisonRow item) =>
              item.featureLabel == l10n.planFeatureAdvancedSavingsAnalytics,
        );

        expect(row.freeAvailability, PlanComparisonAvailability.locked);
        expect(row.proAvailability, PlanComparisonAvailability.included);
      });

      test('basic savings opportunities are included on both plans', () {
        final PlanComparisonRow row =
            SubscriptionPlanPresentation.comparisonRows(
          l10n,
        ).singleWhere(
          (PlanComparisonRow item) =>
              item.featureLabel == l10n.planCompareBasicSavingsOpportunities,
        );

        expect(row.freeAvailability, PlanComparisonAvailability.included);
        expect(row.proAvailability, PlanComparisonAvailability.included);
      });

      test('basic product price insights are included on both plans', () {
        final PlanComparisonRow row =
            SubscriptionPlanPresentation.comparisonRows(
          l10n,
        ).singleWhere(
          (PlanComparisonRow item) =>
              item.featureLabel == l10n.planCompareBasicProductPriceInsights,
        );

        expect(row.freeAvailability, PlanComparisonAvailability.included);
        expect(row.proAvailability, PlanComparisonAvailability.included);
      });
    });
  });
}
