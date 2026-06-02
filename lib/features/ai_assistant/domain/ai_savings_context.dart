import 'package:savingor_app/features/analytics/domain/expense_analytics_calculator.dart';
import 'package:savingor_app/features/expenses/data/expenses_store.dart';
import 'package:savingor_app/features/shopping/data/shopping_lists_store.dart';

/// Snapshot of user financial data passed into [AiSavingsAssistantService].
///
/// Built from existing Firestore-backed stores — no secrets or API keys.
class AiSavingsContext {
  const AiSavingsContext({
    required this.isAuthenticated,
    required this.totalExpenses,
    required this.expenseCount,
    required this.totalThisMonth,
    required this.shoppingListCount,
    required this.totalEstimatedShoppingValue,
    this.topSpendingStoreName,
    this.topSpendingStoreAmount,
  });

  final bool isAuthenticated;
  final double totalExpenses;
  final int expenseCount;
  final double totalThisMonth;
  final int shoppingListCount;
  final double totalEstimatedShoppingValue;
  final String? topSpendingStoreName;
  final double? topSpendingStoreAmount;

  bool get hasExpenses => expenseCount > 0;

  bool get hasShoppingLists => shoppingListCount > 0;

  /// Builds context from live app stores (expenses + shopping lists).
  static AiSavingsContext fromStores({
    required ExpensesStore expensesStore,
    required ShoppingListsStore shoppingListsStore,
  }) {
    final ExpenseAnalyticsSummary analytics =
        ExpenseAnalyticsCalculator.compute(expensesStore.expenses);

    double totalExpenses = 0;
    for (final expense in expensesStore.expenses) {
      totalExpenses += expense.totalAmount;
    }

    final String? topStoreName = analytics.spendingByStore.isEmpty
        ? null
        : analytics.spendingByStore.first.storeName;
    final double? topStoreAmount = analytics.spendingByStore.isEmpty
        ? null
        : analytics.spendingByStore.first.totalAmount;

    return AiSavingsContext(
      isAuthenticated: expensesStore.isAuthenticated,
      totalExpenses: totalExpenses,
      expenseCount: expensesStore.expenses.length,
      totalThisMonth: analytics.totalThisMonth,
      shoppingListCount: shoppingListsStore.listCount,
      totalEstimatedShoppingValue: shoppingListsStore.totalEstimatedListValue,
      topSpendingStoreName: topStoreName,
      topSpendingStoreAmount: topStoreAmount,
    );
  }
}
