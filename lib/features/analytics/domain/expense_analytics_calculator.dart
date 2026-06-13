import 'package:savingor_app/core/app_state.dart';
import 'package:savingor_app/features/expenses/domain/models/user_expense.dart';
import 'package:savingor_app/features/scanner/domain/models/receipt.dart';

/// Aggregated spending analytics from manual expenses and scanned receipts.
class ExpenseAnalyticsSummary {
  const ExpenseAnalyticsSummary({
    required this.totalThisMonth,
    required this.totalThisYear,
    required this.totalAll,
    required this.manualExpenseCount,
    required this.receiptCount,
    required this.totalRecordCount,
    required this.averageRecordAmount,
    required this.averageReceiptAmount,
    required this.highestReceiptAmount,
    required this.topStoreName,
    required this.spendingByStore,
    required this.recentActivity,
  });

  final double totalThisMonth;
  final double totalThisYear;
  final double totalAll;
  final int manualExpenseCount;
  final int receiptCount;
  final int totalRecordCount;
  final double averageRecordAmount;
  final double averageReceiptAmount;
  final double highestReceiptAmount;
  final String? topStoreName;
  final List<StoreSpendingEntry> spendingByStore;
  final List<AnalyticsActivityEntry> recentActivity;

  /// Manual expense count (legacy alias).
  int get expenseCount => manualExpenseCount;

  /// Average across all records (legacy alias).
  double get averageExpense => averageRecordAmount;

  bool get isEmpty => totalRecordCount == 0;
}

class StoreSpendingEntry {
  const StoreSpendingEntry({
    required this.storeName,
    required this.totalAmount,
    required this.recordCount,
  });

  final String storeName;
  final double totalAmount;
  final int recordCount;

  /// Legacy alias.
  int get expenseCount => recordCount;
}

class AnalyticsActivityEntry {
  const AnalyticsActivityEntry({
    required this.title,
    required this.subtitle,
    required this.date,
    required this.amount,
    required this.typeLabel,
    this.receiptSourceValue,
    this.receiptItemCount,
  });

  final String title;
  final String subtitle;
  final DateTime date;
  final double amount;
  final String typeLabel;
  final String? receiptSourceValue;
  final int? receiptItemCount;
}

/// Pure calculator — no Firestore or UI dependencies.
abstract final class ExpenseAnalyticsCalculator {
  static ExpenseAnalyticsSummary compute(
    List<UserExpense> expenses, {
    List<Receipt> receipts = const <Receipt>[],
    DateTime? referenceDate,
    DisplayAmountConverter? convertToDisplay,
  }) {
    double toDisplay(double amount, String originalCurrency) {
      return convertToDisplay?.call(amount, originalCurrency) ?? amount;
    }
    final DateTime now = referenceDate ?? DateTime.now();
    final int currentMonth = now.month;
    final int currentYear = now.year;

    double totalThisMonth = 0;
    double totalThisYear = 0;
    double totalAll = 0;
    double receiptsTotal = 0;
    double highestReceiptAmount = 0;
    final Map<String, _StoreAccumulator> storeTotals =
        <String, _StoreAccumulator>{};
    final List<AnalyticsActivityEntry> activity = <AnalyticsActivityEntry>[];

    void addAmount({
      required String storeName,
      required DateTime date,
      required double amount,
      required String subtitle,
      required String typeLabel,
      String? receiptSourceValue,
      int? receiptItemCount,
    }) {
      totalAll += amount;

      if (date.year == currentYear) {
        totalThisYear += amount;
        if (date.month == currentMonth) {
          totalThisMonth += amount;
        }
      }

      final String storeKey =
          storeName.trim().isEmpty ? 'Unknown store' : storeName.trim();
      final _StoreAccumulator current =
          storeTotals[storeKey] ?? _StoreAccumulator(storeName: storeKey);
      storeTotals[storeKey] = current
        ..totalAmount += amount
        ..recordCount += 1;

      activity.add(
        AnalyticsActivityEntry(
          title: storeKey,
          subtitle: subtitle,
          date: date,
          amount: amount,
          typeLabel: typeLabel,
          receiptSourceValue: receiptSourceValue,
          receiptItemCount: receiptItemCount,
        ),
      );
    }

    for (final UserExpense expense in expenses) {
      final double displayAmount =
          toDisplay(expense.totalAmount, expense.currency);
      addAmount(
        storeName: expense.storeName,
        date: expense.purchaseDate,
        amount: displayAmount,
        subtitle: 'Manual expense',
        typeLabel: 'expense',
      );
    }

    for (final Receipt receipt in receipts) {
      final double displayTotal = toDisplay(receipt.total, receipt.currency);
      receiptsTotal += displayTotal;
      if (displayTotal > highestReceiptAmount) {
        highestReceiptAmount = displayTotal;
      }

      addAmount(
        storeName: receipt.storeName,
        date: receipt.purchaseDate,
        amount: displayTotal,
        subtitle: receipt.source.label,
        typeLabel: 'receipt',
        receiptSourceValue: receipt.source.value,
        receiptItemCount: receipt.hasItems ? receipt.itemCount : null,
      );
    }

    final List<StoreSpendingEntry> byStore = storeTotals.values
        .map(
          (_StoreAccumulator entry) => StoreSpendingEntry(
            storeName: entry.storeName,
            totalAmount: entry.totalAmount,
            recordCount: entry.recordCount,
          ),
        )
        .toList(growable: false)
      ..sort(
        (StoreSpendingEntry a, StoreSpendingEntry b) =>
            b.totalAmount.compareTo(a.totalAmount),
      );

    activity.sort(
      (AnalyticsActivityEntry a, AnalyticsActivityEntry b) =>
          b.date.compareTo(a.date),
    );

    final int manualExpenseCount = expenses.length;
    final int receiptCount = receipts.length;
    final int totalRecordCount = manualExpenseCount + receiptCount;

    return ExpenseAnalyticsSummary(
      totalThisMonth: totalThisMonth,
      totalThisYear: totalThisYear,
      totalAll: totalAll,
      manualExpenseCount: manualExpenseCount,
      receiptCount: receiptCount,
      totalRecordCount: totalRecordCount,
      averageRecordAmount:
          totalRecordCount == 0 ? 0 : totalAll / totalRecordCount,
      averageReceiptAmount:
          receiptCount == 0 ? 0 : receiptsTotal / receiptCount,
      highestReceiptAmount: highestReceiptAmount,
      topStoreName: byStore.isEmpty ? null : byStore.first.storeName,
      spendingByStore: byStore,
      recentActivity: activity.take(5).toList(growable: false),
    );
  }
}

class _StoreAccumulator {
  _StoreAccumulator({required this.storeName});

  final String storeName;
  double totalAmount = 0;
  int recordCount = 0;
}
