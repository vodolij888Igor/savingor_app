import 'package:savingor_app/features/subscription/domain/savingor_feature.dart';

/// Central Free / Pro feature-access rules for Savingor.
///
/// Free users can access:
/// - Home dashboard, store map, shopping lists, manual grocery expenses
/// - Basic receipt scanning (capped by [freeMonthlyReceiptScanLimit] per month)
/// - Basic expense and receipt history
/// - Basic savings opportunities and product price insights from receipt history
/// - Language, appearance, region, and currency settings
///
/// Pro users unlock advanced savings intelligence, unlimited receipt scanning,
/// and future Pro-only capabilities defined in [proOnlyFeatures].
abstract final class FeatureAccessPolicy {
  /// Maximum receipt scans per calendar month on the Free plan.
  static const int freeMonthlyReceiptScanLimit = 3;

  /// Features that require an active Pro subscription.
  static const Set<SavingorFeature> proOnlyFeatures = <SavingorFeature>{
    SavingorFeature.aiSavingsAssistant,
    SavingorFeature.unlimitedReceiptScanning,
    SavingorFeature.basketOptimizer,
    SavingorFeature.savingsAnalytics,
    SavingorFeature.advancedPriceIntelligence,
    SavingorFeature.personalizedSavingsIntelligence,
    SavingorFeature.unlimitedSavingsOpportunities,
    SavingorFeature.priceDropAlerts,
    SavingorFeature.smartSavingsAlerts,
    SavingorFeature.advancedSpendingReports,
  };

  /// Returns whether [feature] requires an active Pro subscription.
  static bool requiresPro(SavingorFeature feature) {
    return proOnlyFeatures.contains(feature);
  }
}
