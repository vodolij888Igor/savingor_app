import 'package:savingor_app/core/app_state.dart';
import 'package:savingor_app/features/analytics/domain/expense_analytics_calculator.dart';
import 'package:savingor_app/features/analytics/domain/models/savings_recommendation.dart';
import 'package:savingor_app/features/analytics/domain/savings_intelligence_service.dart';
import 'package:savingor_app/features/analytics/domain/savings_recommendation_service.dart';
import 'package:savingor_app/features/expenses/domain/models/user_expense.dart';
import 'package:savingor_app/features/price_memory/domain/models/product_price_record.dart';
import 'package:savingor_app/features/scanner/domain/models/receipt.dart';

/// Real dashboard metrics for the home savings overview.
class HomeDashboardSummary {
  const HomeDashboardSummary({
    required this.spentThisMonth,
    required this.receiptCount,
    required this.potentialSavingsFound,
    required this.productsTracked,
    this.topRecommendation,
  });

  final double spentThisMonth;
  final int receiptCount;
  final double potentialSavingsFound;
  final int productsTracked;
  final SavingsRecommendation? topRecommendation;
}

abstract final class HomeDashboardSummaryBuilder {
  static HomeDashboardSummary build({
    required List<UserExpense> expenses,
    required List<Receipt> receipts,
    required List<ProductPriceRecord> priceRecords,
    DisplayAmountConverter? convertToDisplay,
  }) {
    final ExpenseAnalyticsSummary analytics = ExpenseAnalyticsCalculator.compute(
      expenses,
      receipts: receipts,
      convertToDisplay: convertToDisplay,
    );
    final savingsSummary = SavingsIntelligenceService.compute(priceRecords);
    final List<SavingsRecommendation> recommendations =
        SavingsRecommendationService.compute(priceRecords);

    return HomeDashboardSummary(
      spentThisMonth: analytics.totalThisMonth,
      receiptCount: analytics.receiptCount,
      potentialSavingsFound: savingsSummary.potentialMissedThisMonth,
      productsTracked: savingsSummary.trackedProductCount,
      topRecommendation: _selectTopRecommendation(recommendations),
    );
  }

  static SavingsRecommendation? _selectTopRecommendation(
    List<SavingsRecommendation> recommendations,
  ) {
    if (recommendations.isEmpty) {
      return null;
    }

    for (final SavingsRecommendation recommendation in recommendations) {
      if (recommendation.type == SavingsRecommendationType.storeSwitch) {
        return recommendation;
      }
    }

    return recommendations.first;
  }
}
