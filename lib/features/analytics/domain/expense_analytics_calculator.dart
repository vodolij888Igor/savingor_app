import 'package:savingor_app/features/expenses/domain/models/user_expense.dart';

/// Aggregated expense analytics derived from Firestore-backed [UserExpense] data.
class ExpenseAnalyticsSummary {
  const ExpenseAnalyticsSummary({
    required this.totalThisMonth,
    required this.totalThisYear,
    required this.expenseCount,
    required this.averageExpense,
    required this.spendingByStore,
    required this.recentExpenses,
  });

  final double totalThisMonth;
  final double totalThisYear;
  final int expenseCount;
  final double averageExpense;
  final List<StoreSpendingEntry> spendingByStore;
  final List<UserExpense> recentExpenses;

  bool get isEmpty => expenseCount == 0;
}

class StoreSpendingEntry {
  const StoreSpendingEntry({
    required this.storeName,
    required this.totalAmount,
    required this.expenseCount,
  });

  final String storeName;
  final double totalAmount;
  final int expenseCount;
}

/// Pure calculator — no Firestore or UI dependencies.
abstract final class ExpenseAnalyticsCalculator {
  static ExpenseAnalyticsSummary compute(
    List<UserExpense> expenses, {
    DateTime? referenceDate,
  }) {
    final DateTime now = referenceDate ?? DateTime.now();
    final int currentMonth = now.month;
    final int currentYear = now.year;

    double totalThisMonth = 0;
    double totalThisYear = 0;
    double totalAll = 0;
    final Map<String, _StoreAccumulator> storeTotals =
        <String, _StoreAccumulator>{};

    for (final UserExpense expense in expenses) {
      totalAll += expense.totalAmount;

      if (expense.purchaseDate.year == currentYear) {
        totalThisYear += expense.totalAmount;
        if (expense.purchaseDate.month == currentMonth) {
          totalThisMonth += expense.totalAmount;
        }
      }

      final String storeKey = expense.storeName.trim().isEmpty
          ? 'Unknown store'
          : expense.storeName.trim();
      final _StoreAccumulator current =
          storeTotals[storeKey] ?? _StoreAccumulator(storeName: storeKey);
      storeTotals[storeKey] = current
        ..totalAmount += expense.totalAmount
        ..expenseCount += 1;
    }

    final List<StoreSpendingEntry> byStore = storeTotals.values
        .map(
          (_StoreAccumulator entry) => StoreSpendingEntry(
            storeName: entry.storeName,
            totalAmount: entry.totalAmount,
            expenseCount: entry.expenseCount,
          ),
        )
        .toList(growable: false)
      ..sort(
        (StoreSpendingEntry a, StoreSpendingEntry b) =>
            b.totalAmount.compareTo(a.totalAmount),
      );

    final List<UserExpense> recent = List<UserExpense>.from(expenses)
      ..sort(
        (UserExpense a, UserExpense b) =>
            b.purchaseDate.compareTo(a.purchaseDate),
      );

    final int count = expenses.length;
    return ExpenseAnalyticsSummary(
      totalThisMonth: totalThisMonth,
      totalThisYear: totalThisYear,
      expenseCount: count,
      averageExpense: count == 0 ? 0 : totalAll / count,
      spendingByStore: byStore,
      recentExpenses: recent.take(5).toList(growable: false),
    );
  }
}

class _StoreAccumulator {
  _StoreAccumulator({required this.storeName});

  final String storeName;
  double totalAmount = 0;
  int expenseCount = 0;
}
