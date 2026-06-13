import 'package:savingor_app/features/subscription/domain/feature_access_policy.dart';
import 'package:savingor_app/l10n/app_localizations.dart';

/// Availability label used in the Free vs Pro comparison table.
enum PlanComparisonAvailability {
  included,
  locked,
  unlimited,
  threePerMonth,
}

/// One row in the plan comparison table.
class PlanComparisonRow {
  const PlanComparisonRow({
    required this.featureLabel,
    required this.freeAvailability,
    required this.proAvailability,
  });

  final String featureLabel;
  final PlanComparisonAvailability freeAvailability;
  final PlanComparisonAvailability proAvailability;
}

/// Centralized Free / Pro plan copy for the Plans screen.
abstract final class SubscriptionPlanPresentation {
  static String freePriceLabel(AppLocalizations l10n) => l10n.planFreePrice;

  static String proPriceLabel(AppLocalizations l10n) =>
      l10n.planProPricePerMonth;

  static List<String> freeIncludedFeatures(AppLocalizations l10n) {
    return <String>[
      l10n.planFeatureGroceryDashboard,
      l10n.planFeatureNearbyStoreMap,
      l10n.planFeatureShoppingLists,
      l10n.planFeatureManualExpenseTracking,
      l10n.planFeatureThreeReceiptScansPerMonth,
      l10n.planFeatureBasicReceiptExpenseHistory,
      l10n.planFeatureBasicSavingsOpportunities,
      l10n.planFeatureBasicProductPriceInsights,
      l10n.planFeatureAppSettings,
    ];
  }

  static List<String> proActiveFeatures(AppLocalizations l10n) {
    return <String>[
      l10n.planFeatureUnlimitedReceiptScanning,
      l10n.aiSavingsAssistant,
      l10n.planFeatureBasketOptimizer,
      l10n.planFeatureAdvancedSavingsAnalytics,
    ];
  }

  static List<String> proComingSoonFeatures(AppLocalizations l10n) {
    return <String>[
      l10n.planFeatureSmartPriceDropAlerts,
      l10n.planFeatureAdvancedSpendingReports,
    ];
  }

  static List<PlanComparisonRow> comparisonRows(AppLocalizations l10n) {
    return <PlanComparisonRow>[
      PlanComparisonRow(
        featureLabel: l10n.planCompareReceiptScans,
        freeAvailability: PlanComparisonAvailability.threePerMonth,
        proAvailability: PlanComparisonAvailability.unlimited,
      ),
      PlanComparisonRow(
        featureLabel: l10n.aiSavingsAssistant,
        freeAvailability: PlanComparisonAvailability.locked,
        proAvailability: PlanComparisonAvailability.included,
      ),
      PlanComparisonRow(
        featureLabel: l10n.planFeatureBasketOptimizer,
        freeAvailability: PlanComparisonAvailability.locked,
        proAvailability: PlanComparisonAvailability.included,
      ),
      PlanComparisonRow(
        featureLabel: l10n.planFeatureAdvancedSavingsAnalytics,
        freeAvailability: PlanComparisonAvailability.locked,
        proAvailability: PlanComparisonAvailability.included,
      ),
      PlanComparisonRow(
        featureLabel: l10n.planCompareBasicSavingsOpportunities,
        freeAvailability: PlanComparisonAvailability.included,
        proAvailability: PlanComparisonAvailability.included,
      ),
      PlanComparisonRow(
        featureLabel: l10n.planCompareBasicProductPriceInsights,
        freeAvailability: PlanComparisonAvailability.included,
        proAvailability: PlanComparisonAvailability.included,
      ),
    ];
  }

  static String availabilityLabel(
    AppLocalizations l10n,
    PlanComparisonAvailability availability,
  ) {
    return switch (availability) {
      PlanComparisonAvailability.included => l10n.planAvailabilityIncluded,
      PlanComparisonAvailability.locked => l10n.planAvailabilityLocked,
      PlanComparisonAvailability.unlimited => l10n.planAvailabilityUnlimited,
      PlanComparisonAvailability.threePerMonth =>
        l10n.planAvailabilityThreeScansPerMonth,
    };
  }

  static int get freeMonthlyReceiptScanLimit =>
      FeatureAccessPolicy.freeMonthlyReceiptScanLimit;
}
