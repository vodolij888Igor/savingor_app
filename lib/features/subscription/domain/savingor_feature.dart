/// Identifiers for Savingor capabilities governed by the Free / Pro access policy.
///
/// Use [FeatureAccessService] to evaluate access — do not compare plan strings
/// or scatter subscription checks in UI code.
enum SavingorFeature {
  /// AI Savings Assistant tab and related flows.
  aiSavingsAssistant,

  /// Basic receipt scanning (Free tier, subject to monthly scan limits).
  receiptScanning,

  /// Unlimited receipt scanning (Pro tier).
  unlimitedReceiptScanning,

  /// Basket optimizer and multi-store shopping recommendations.
  basketOptimizer,

  /// Savings analytics dashboard and related insights.
  savingsAnalytics,

  /// Basic product price insights from receipt history (Free tier).
  productPriceInsights,

  /// Basic savings opportunities from receipt history (Free tier).
  savingsOpportunities,

  /// Advanced price intelligence (future Pro capability).
  advancedPriceIntelligence,

  /// Personalized savings intelligence (future Pro capability).
  personalizedSavingsIntelligence,

  /// Unlimited savings opportunities discovery (future Pro capability).
  unlimitedSavingsOpportunities,

  /// Price drop alerts (future Pro capability).
  priceDropAlerts,

  /// Smart savings alerts and notifications (future Pro capability).
  smartSavingsAlerts,

  /// Advanced spending reports (future Pro capability).
  advancedSpendingReports,
}
