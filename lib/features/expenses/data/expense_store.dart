import 'package:flutter/widgets.dart';

import 'package:savingor_app/features/expenses/domain/models/expense.dart';

class ExpenseStore extends ChangeNotifier {
  final List<Expense> _expenses = <Expense>[];

  List<Expense> get expenses => List<Expense>.unmodifiable(_expenses);

  void addExpense({
    required String storeName,
    required String itemName,
    required double price,
    required String category,
    required DateTime date,
  }) {
    _expenses.insert(
      0,
      Expense(
        id: DateTime.now().microsecondsSinceEpoch.toString(),
        storeName: storeName.trim(),
        itemName: itemName.trim(),
        price: price,
        category: category.trim(),
        date: date,
      ),
    );
    notifyListeners();
  }
}

class ExpenseProvider extends InheritedNotifier<ExpenseStore> {
  const ExpenseProvider({
    super.key,
    required ExpenseStore notifier,
    required super.child,
  }) : super(notifier: notifier);

  static ExpenseStore of(BuildContext context) {
    final ExpenseProvider? provider =
        context.dependOnInheritedWidgetOfExactType<ExpenseProvider>();
    if (provider == null) {
      throw FlutterError('ExpenseProvider not found');
    }
    return provider.notifier!;
  }
}
