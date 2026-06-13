import 'package:flutter/material.dart';

import 'package:savingor_app/features/subscription/domain/savingor_feature.dart';
import 'package:savingor_app/l10n/app_localizations.dart';

/// Localized copy and iconography for a Pro-gated feature locked preview.
class ProFeaturePresentation {
  const ProFeaturePresentation({
    required this.icon,
    required this.title,
    required this.description,
    required this.benefits,
  });

  final IconData icon;
  final String title;
  final String description;
  final List<String> benefits;

  static ProFeaturePresentation forFeature(
    SavingorFeature feature,
    AppLocalizations l10n,
  ) {
    switch (feature) {
      case SavingorFeature.basketOptimizer:
        return ProFeaturePresentation(
          icon: Icons.shopping_basket_outlined,
          title: l10n.optimizeShoppingBasket,
          description: l10n.proFeatureBasketOptimizerDescription,
          benefits: <String>[
            l10n.proFeatureBasketBenefitOptimizeAcrossStores,
            l10n.proFeatureBasketBenefitCompareTotals,
            l10n.proFeatureBasketBenefitEconomicalCombination,
            l10n.proFeatureBasketBenefitReduceSpending,
          ],
        );
      case SavingorFeature.savingsAnalytics:
        return ProFeaturePresentation(
          icon: Icons.insights_outlined,
          title: l10n.savingsAnalytics,
          description: l10n.proFeatureSavingsAnalyticsDescription,
          benefits: <String>[
            l10n.proFeatureAnalyticsBenefitDeeperTrends,
            l10n.proFeatureAnalyticsBenefitComparePeriods,
            l10n.proFeatureAnalyticsBenefitTrackSavings,
            l10n.proFeatureAnalyticsBenefitAdvancedRecommendations,
          ],
        );
      case SavingorFeature.advancedPriceIntelligence:
        return ProFeaturePresentation(
          icon: Icons.price_change_outlined,
          title: l10n.productPriceInsights,
          description: l10n.proFeatureProductPriceInsightsDescription,
          benefits: <String>[
            l10n.proFeaturePriceInsightsBenefitHistory,
            l10n.proFeaturePriceInsightsBenefitCompareStores,
            l10n.proFeaturePriceInsightsBenefitBuyingAdvice,
            l10n.proFeaturePriceInsightsBenefitPurchaseTiming,
          ],
        );
      case SavingorFeature.personalizedSavingsIntelligence:
      case SavingorFeature.unlimitedSavingsOpportunities:
        return ProFeaturePresentation(
          icon: Icons.savings_outlined,
          title: l10n.savingsOpportunities,
          description: l10n.proFeatureSavingsOpportunitiesDescription,
          benefits: <String>[
            l10n.proFeatureOpportunitiesBenefitPersonalized,
            l10n.proFeatureOpportunitiesBenefitPrioritize,
            l10n.proFeatureOpportunitiesBenefitReceiptHistory,
            l10n.proFeatureOpportunitiesBenefitBetterChoices,
          ],
        );
      default:
        return ProFeaturePresentation(
          icon: Icons.workspace_premium_outlined,
          title: l10n.pro,
          description: l10n.unlockProFeaturesDescription,
          benefits: const <String>[],
        );
    }
  }
}
