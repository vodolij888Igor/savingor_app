import 'package:savingor_app/features/ai_assistant/domain/ai_savings_context.dart';
import 'package:savingor_app/features/analytics/domain/expense_analytics_calculator.dart';
import 'package:savingor_app/features/expenses/data/expenses_store.dart';
import 'package:savingor_app/features/scanner/data/receipt_store.dart';
import 'package:savingor_app/features/scanner/domain/models/receipt.dart';
import 'package:savingor_app/features/shopping/data/shopping_lists_store.dart';
import 'package:savingor_app/features/shopping/domain/models/shopping_list.dart';
import 'package:savingor_app/features/shopping/domain/models/shopping_list_item.dart';

/// Builds compact [AiSavingsContext] from existing app stores.
abstract final class AiContextBuilder {
  static AiSavingsContext fromStores({
    required ExpensesStore expensesStore,
    required ReceiptStore receiptStore,
    required ShoppingListsStore shoppingListsStore,
  }) {
    final ExpenseAnalyticsSummary analytics =
        ExpenseAnalyticsCalculator.compute(
      expensesStore.expenses,
      receipts: receiptStore.receipts,
    );

    final List<Receipt> sortedReceipts =
        List<Receipt>.from(receiptStore.receipts)
          ..sort((Receipt a, Receipt b) => b.date.compareTo(a.date));

    final List<AiRecentReceiptEntry> recentReceipts = sortedReceipts
        .take(5)
        .map(
          (Receipt receipt) => AiRecentReceiptEntry(
            storeName: receipt.storeName,
            dateIso: _formatDate(receipt.date),
            total: receipt.total,
            category: receipt.category,
          ),
        )
        .toList(growable: false);

    final List<AiStoreSpendingEntry> topStores = analytics.spendingByStore
        .take(5)
        .map(
          (StoreSpendingEntry entry) => AiStoreSpendingEntry(
            storeName: entry.storeName,
            totalAmount: entry.totalAmount,
            recordCount: entry.recordCount,
          ),
        )
        .toList(growable: false);

    final List<AiShoppingListSummary> shoppingLists =
        shoppingListsStore.lists
            .map(
              (ShoppingList list) => AiShoppingListSummary(
                title: list.title,
                itemCount: list.itemCount,
                completedCount: list.completedCount,
                estimatedTotal: list.estimatedTotal,
              ),
            )
            .toList(growable: false);

    final List<AiShoppingItemSummary> activeItems = shoppingListsStore.items
        .where((ShoppingListItem item) => item.isActive)
        .take(12)
        .map(
          (ShoppingListItem item) => AiShoppingItemSummary(
            name: item.name,
            quantity: item.quantity,
            isCompleted: item.isCompleted,
            unitPrice: item.unitPrice,
            category: item.category,
          ),
        )
        .toList(growable: false);

    return AiSavingsContext(
      isAuthenticated:
          expensesStore.isAuthenticated || receiptStore.isAuthenticated,
      totalSpending: analytics.totalAll,
      totalThisMonth: analytics.totalThisMonth,
      manualExpenseCount: analytics.manualExpenseCount,
      receiptCount: analytics.receiptCount,
      shoppingListCount: shoppingListsStore.listCount,
      totalEstimatedShoppingValue: shoppingListsStore.totalEstimatedListValue,
      activeListEstimate: shoppingListsStore.activeListEstimate,
      topStores: topStores,
      recentReceipts: recentReceipts,
      shoppingLists: shoppingLists,
      activeShoppingItems: activeItems,
    );
  }

  static String _formatDate(DateTime date) {
    final String month = date.month.toString().padLeft(2, '0');
    final String day = date.day.toString().padLeft(2, '0');
    return '${date.year}-$month-$day';
  }
}
