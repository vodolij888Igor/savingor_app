/// Compact store spending row for AI context.
class AiStoreSpendingEntry {
  const AiStoreSpendingEntry({
    required this.storeName,
    required this.totalAmount,
    required this.recordCount,
  });

  final String storeName;
  final double totalAmount;
  final int recordCount;
}

/// Compact recent receipt row for AI context.
class AiRecentReceiptEntry {
  const AiRecentReceiptEntry({
    required this.storeName,
    required this.dateIso,
    required this.total,
    required this.category,
  });

  final String storeName;
  final String dateIso;
  final double total;
  final String category;
}

/// Shopping list summary for AI context.
class AiShoppingListSummary {
  const AiShoppingListSummary({
    required this.title,
    required this.itemCount,
    required this.completedCount,
    this.estimatedTotal,
  });

  final String title;
  final int itemCount;
  final int completedCount;
  final double? estimatedTotal;
}

/// Active shopping list item for AI context.
class AiShoppingItemSummary {
  const AiShoppingItemSummary({
    required this.name,
    required this.quantity,
    required this.isCompleted,
    this.unitPrice,
    this.category,
  });

  final String name;
  final int quantity;
  final bool isCompleted;
  final double? unitPrice;
  final String? category;
}

/// Snapshot of user financial and shopping data for the AI assistant.
class AiSavingsContext {
  const AiSavingsContext({
    required this.isAuthenticated,
    required this.totalSpending,
    required this.totalThisMonth,
    required this.manualExpenseCount,
    required this.receiptCount,
    required this.shoppingListCount,
    required this.totalEstimatedShoppingValue,
    required this.activeListEstimate,
    required this.topStores,
    required this.recentReceipts,
    required this.shoppingLists,
    required this.activeShoppingItems,
  });

  final bool isAuthenticated;
  final double totalSpending;
  final double totalThisMonth;
  final int manualExpenseCount;
  final int receiptCount;
  final int shoppingListCount;
  final double totalEstimatedShoppingValue;
  final double activeListEstimate;
  final List<AiStoreSpendingEntry> topStores;
  final List<AiRecentReceiptEntry> recentReceipts;
  final List<AiShoppingListSummary> shoppingLists;
  final List<AiShoppingItemSummary> activeShoppingItems;

  /// Legacy alias used by local insight rules.
  double get totalExpenses => totalSpending;

  /// Legacy alias.
  int get expenseCount => manualExpenseCount + receiptCount;

  bool get hasManualExpenses => manualExpenseCount > 0;

  bool get hasReceipts => receiptCount > 0;

  bool get hasExpenses => hasManualExpenses || hasReceipts;

  bool get hasShoppingLists => shoppingListCount > 0;

  bool get hasData => hasExpenses || hasShoppingLists;

  String? get topSpendingStoreName =>
      topStores.isEmpty ? null : topStores.first.storeName;

  double? get topSpendingStoreAmount =>
      topStores.isEmpty ? null : topStores.first.totalAmount;

  /// Compact JSON-friendly map for LLM prompts (no raw OCR dumps).
  Map<String, dynamic> toPromptMap() {
    return <String, dynamic>{
      'totalSpending': _round(totalSpending),
      'totalThisMonth': _round(totalThisMonth),
      'manualExpenseCount': manualExpenseCount,
      'receiptCount': receiptCount,
      'shoppingListCount': shoppingListCount,
      'totalEstimatedShoppingValue': _round(totalEstimatedShoppingValue),
      'activeListEstimate': _round(activeListEstimate),
      'topStores': topStores
          .map(
            (AiStoreSpendingEntry entry) => <String, dynamic>{
              'storeName': entry.storeName,
              'totalAmount': _round(entry.totalAmount),
              'recordCount': entry.recordCount,
            },
          )
          .toList(),
      'recentReceipts': recentReceipts
          .map(
            (AiRecentReceiptEntry entry) => <String, dynamic>{
              'storeName': entry.storeName,
              'date': entry.dateIso,
              'total': _round(entry.total),
              'category': entry.category,
            },
          )
          .toList(),
      'shoppingLists': shoppingLists
          .map(
            (AiShoppingListSummary list) => <String, dynamic>{
              'title': list.title,
              'itemCount': list.itemCount,
              'completedCount': list.completedCount,
              if (list.estimatedTotal != null)
                'estimatedTotal': _round(list.estimatedTotal!),
            },
          )
          .toList(),
      'activeShoppingItems': activeShoppingItems
          .map(
            (AiShoppingItemSummary item) => <String, dynamic>{
              'name': item.name,
              'quantity': item.quantity,
              'isCompleted': item.isCompleted,
              if (item.unitPrice != null)
                'unitPrice': _round(item.unitPrice!),
              if (item.category != null) 'category': item.category,
            },
          )
          .toList(),
    };
  }

  static double _round(double value) =>
      double.parse(value.toStringAsFixed(2));
}
