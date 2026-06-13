import 'package:savingor_app/features/ai_assistant/domain/ai_assistant_exception.dart';
import 'package:savingor_app/features/ai_assistant/domain/ai_savings_assistant_service.dart';
import 'package:savingor_app/features/ai_assistant/domain/ai_savings_context.dart';
import 'package:savingor_app/features/ai_assistant/domain/models/ai_assistant_request.dart';
import 'package:savingor_app/features/ai_assistant/domain/models/ai_assistant_response.dart';
import 'package:savingor_app/features/ai_assistant/domain/models/savings_insight.dart';

/// Rule-based insights from local Firestore-backed user data.
///
/// Used when no remote AI key is configured. Does not call external APIs.
class LocalAiSavingsAssistantService implements AiSavingsAssistantService {
  const LocalAiSavingsAssistantService();

  @override
  bool get isConfigured => false;

  @override
  Future<AiAssistantResponse> ask(AiAssistantRequest request) async {
    throw AiAssistantException.missingApiKey;
  }

  @override
  Future<List<SavingsInsight>> generateInsights(
    AiSavingsContext context,
  ) async {
    if (!context.isAuthenticated) {
      return <SavingsInsight>[
        const SavingsInsight(
          id: 'sign-in',
          title: 'Sign in to unlock insights',
          message:
              'Connect your Savingor account to get personalized spending guidance.',
          type: InsightType.onboarding,
          severity: InsightSeverity.info,
        ),
      ];
    }

    if (!context.hasData) {
      return <SavingsInsight>[
        const SavingsInsight(
          id: 'get-started',
          title: 'Start tracking to save smarter',
          message: 'Scan a receipt, add an expense, or create a shopping list. '
              'Savingor will surface spending patterns and savings ideas here.',
          type: InsightType.onboarding,
          severity: InsightSeverity.info,
        ),
      ];
    }

    final List<SavingsInsight> insights = <SavingsInsight>[];

    if (context.hasExpenses) {
      insights.add(
        SavingsInsight(
          id: 'spending-overview',
          title: 'Your spending snapshot',
          message: 'Based on your saved receipts and expenses: '
              '${context.receiptCount} '
              '${context.receiptCount == 1 ? 'receipt' : 'receipts'} '
              'and ${context.manualExpenseCount} manual '
              '${context.manualExpenseCount == 1 ? 'entry' : 'entries'}, '
              'totaling ${_formatCurrency(context.totalExpenses)}. '
              'This month: ${_formatCurrency(context.totalThisMonth)}.',
          type: InsightType.spending,
          severity: InsightSeverity.info,
          highlightValue: _formatCurrency(context.totalExpenses),
        ),
      );

      if (context.topSpendingStoreName != null &&
          context.topSpendingStoreAmount != null) {
        insights.add(
          SavingsInsight(
            id: 'top-store',
            title: 'Highest spending store',
            message:
                'Based on your saved receipts, ${context.topSpendingStoreName} '
                'is your top store at '
                '${_formatCurrency(context.topSpendingStoreAmount!)}. '
                'Compare prices before your next trip to cut grocery costs.',
            type: InsightType.spending,
            severity: InsightSeverity.warning,
            highlightValue: context.topSpendingStoreName,
          ),
        );
      }
    }

    if (context.hasShoppingLists) {
      final String estimateNote = context.totalEstimatedShoppingValue > 0
          ? ' Estimated list value: '
              '${_formatCurrency(context.totalEstimatedShoppingValue)}.'
          : '';
      insights.add(
        SavingsInsight(
          id: 'shopping-lists',
          title: 'Shopping lists active',
          message: 'Based on your current shopping lists, you have '
              '${context.shoppingListCount} '
              '${context.shoppingListCount == 1 ? 'list' : 'lists'} '
              'to plan purchases.$estimateNote Check items before checkout.',
          type: InsightType.shopping,
          severity: InsightSeverity.positive,
          highlightValue: '${context.shoppingListCount}',
        ),
      );
    }

    if (context.hasExpenses && context.totalThisMonth > 0) {
      insights.add(
        const SavingsInsight(
          id: 'savings-tip',
          title: 'Savings opportunity',
          message:
              'Review your recent spending and compare unit prices on top items. '
              'Small switches each week can add up to meaningful savings.',
          type: InsightType.savings,
          severity: InsightSeverity.positive,
        ),
      );
    }

    return insights;
  }

  static String _formatCurrency(double amount) {
    final String fixed = amount.abs().toStringAsFixed(2);
    final List<String> parts = fixed.split('.');
    final String intPart = parts[0];
    final String decPart = parts.length > 1 ? parts[1] : '00';
    final StringBuffer grouped = StringBuffer();
    for (int i = 0; i < intPart.length; i++) {
      if (i > 0 && (intPart.length - i) % 3 == 0) {
        grouped.write(',');
      }
      grouped.write(intPart[i]);
    }
    final String sign = amount < 0 ? '-' : '';
    return '$sign\$$grouped.$decPart';
  }
}
