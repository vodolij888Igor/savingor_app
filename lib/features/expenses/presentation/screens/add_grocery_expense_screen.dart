import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:savingor_app/core/theme/savingor_design_system.dart';
import 'package:savingor_app/features/expenses/data/expense_store.dart';
import 'package:savingor_app/features/expenses/domain/models/expense.dart';

class AddGroceryExpenseScreen extends StatefulWidget {
  const AddGroceryExpenseScreen({super.key});

  @override
  State<AddGroceryExpenseScreen> createState() => _AddGroceryExpenseScreenState();
}

class _AddGroceryExpenseScreenState extends State<AddGroceryExpenseScreen> {
  static const Color _pageWhite = Color(0xFFFFFEFE);
  static const Color _fieldBorder = Color(0xFFF3F4F3);

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _storeController = TextEditingController();
  final TextEditingController _itemController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _categoryController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();

  DateTime _selectedDate = DateTime.now();

  ExpenseStore? _expenseStore;

  @override
  void initState() {
    super.initState();
    _dateController.text = _formatDate(_selectedDate);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _expenseStore ??= ExpenseProvider.of(context);
  }

  @override
  void dispose() {
    _storeController.dispose();
    _itemController.dispose();
    _priceController.dispose();
    _categoryController.dispose();
    _dateController.dispose();
    super.dispose();
  }

  InputDecoration _fieldDecoration(String label) {
    return InputDecoration(
      labelText: label,
      labelStyle: TextStyle(
        color: SavingorColors.textSecondary.withOpacity(0.95),
        fontWeight: FontWeight.w500,
      ),
      filled: true,
      fillColor: Colors.white,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide(color: _fieldBorder.withOpacity(0.9)),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide(color: _fieldBorder.withOpacity(0.9)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: SavingorColors.primaryStroke, width: 1.2),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: Color(0xFFDC2626)),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: Color(0xFFDC2626), width: 1.2),
      ),
    );
  }

  Future<void> _pickDate() async {
    FocusScope.of(context).unfocus();

    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime.now().add(const Duration(days: 1)),
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: SavingorColors.primaryGreen,
              onPrimary: SavingorColors.darkGreen,
              surface: Colors.white,
              onSurface: SavingorColors.textPrimary,
            ),
          ),
          child: child ?? const SizedBox.shrink(),
        );
      },
    );
    if (picked != null) {
      setState(() {
        _selectedDate = picked;
        _dateController.text = _formatDate(picked);
      });
    }
  }

  String _formatDate(DateTime date) {
    final String month = date.month.toString().padLeft(2, '0');
    final String day = date.day.toString().padLeft(2, '0');
    return '${date.year}-$month-$day';
  }

  void _clearForm() {
    _storeController.clear();
    _itemController.clear();
    _priceController.clear();
    _categoryController.clear();
    _selectedDate = DateTime.now();
    _dateController.text = _formatDate(_selectedDate);
  }

  void _saveExpense() {
    if (!(_formKey.currentState?.validate() ?? false)) return;

    final ExpenseStore store = _expenseStore ?? ExpenseProvider.of(context);
    final double price = double.parse(
      _priceController.text.trim().replaceAll('\$', ''),
    );

    store.addExpense(
      storeName: _storeController.text,
      itemName: _itemController.text,
      price: price,
      category: _categoryController.text,
      date: _selectedDate,
    );

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Expense saved.')),
    );

    _clearForm();
  }

  Widget _buildExpenseTile(Expense expense) {
    final String categoryLabel = expense.category.isEmpty
        ? 'Uncategorized'
        : expense.category;

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.fromLTRB(14, 14, 14, 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: _fieldBorder.withOpacity(0.9), width: 0.5),
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  expense.itemName,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: SavingorColors.darkGreen,
                    height: 1.2,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  expense.storeName,
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                    color: SavingorColors.textSecondary.withOpacity(0.95),
                    height: 1.25,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  '$categoryLabel · ${_formatDate(expense.date)}',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: SavingorColors.textSecondary.withOpacity(0.85),
                    height: 1.25,
                  ),
                ),
              ],
            ),
          ),
          Text(
            '\$${expense.price.toStringAsFixed(2)}',
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w800,
              color: SavingorColors.darkGreen,
              height: 1.2,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRecentExpenses(ExpenseStore store) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        const SizedBox(height: SavingorSpacing.xl),
        const Text(
          'Recent expenses',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: SavingorColors.darkGreen,
            height: 1.2,
          ),
        ),
        const SizedBox(height: 12),
        if (store.expenses.isEmpty)
          Text(
            'No expenses added yet.',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: SavingorColors.textSecondary.withOpacity(0.92),
              height: 1.35,
            ),
          )
        else
          Column(
            children: store.expenses.map(_buildExpenseTile).toList(),
          ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final double bottomInset = MediaQuery.paddingOf(context).bottom;
    final ExpenseStore expenseStore = _expenseStore!;

    return Scaffold(
      backgroundColor: _pageWhite,
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        toolbarHeight: 48,
        elevation: 0,
        scrolledUnderElevation: 0,
        backgroundColor: _pageWhite,
        surfaceTintColor: Colors.transparent,
        title: const Text(
          'Add grocery expense',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: SavingorColors.darkGreen,
            letterSpacing: -0.1,
          ),
        ),
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_new_rounded,
            color: SavingorColors.darkGreen,
            size: 20,
          ),
          onPressed: () {
            if (context.canPop()) {
              context.pop();
            } else {
              context.go('/start-saving');
            }
          },
        ),
      ),
      body: SingleChildScrollView(
        keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
        padding: EdgeInsets.fromLTRB(20, 8, 20, 24 + bottomInset),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              TextFormField(
                controller: _storeController,
                enabled: true,
                readOnly: false,
                keyboardType: TextInputType.text,
                textInputAction: TextInputAction.next,
                decoration: _fieldDecoration('Store name'),
                validator: (String? value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please enter a store name.';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 14),
              TextFormField(
                controller: _itemController,
                enabled: true,
                readOnly: false,
                keyboardType: TextInputType.text,
                textInputAction: TextInputAction.next,
                decoration: _fieldDecoration('Item name'),
                validator: (String? value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please enter an item name.';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 14),
              TextFormField(
                controller: _priceController,
                enabled: true,
                readOnly: false,
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                textInputAction: TextInputAction.next,
                decoration: _fieldDecoration('Price'),
                validator: (String? value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please enter a price.';
                  }
                  final double? parsed =
                      double.tryParse(value.trim().replaceAll('\$', ''));
                  if (parsed == null || parsed <= 0) {
                    return 'Please enter a valid price.';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 14),
              TextFormField(
                controller: _categoryController,
                enabled: true,
                readOnly: false,
                keyboardType: TextInputType.text,
                textInputAction: TextInputAction.done,
                decoration: _fieldDecoration('Category'),
              ),
              const SizedBox(height: 14),
              TextFormField(
                controller: _dateController,
                readOnly: true,
                enableInteractiveSelection: false,
                onTap: _pickDate,
                decoration: _fieldDecoration('Date').copyWith(
                  suffixIcon: IconButton(
                    icon: const Icon(
                      Icons.calendar_today_rounded,
                      color: SavingorColors.primaryStroke,
                      size: 20,
                    ),
                    onPressed: _pickDate,
                  ),
                ),
              ),
              const SizedBox(height: 28),
              FilledButton(
                onPressed: _saveExpense,
                style: SavingorButtonStyles.primaryFilled(),
                child: const Text('Save expense'),
              ),
              ListenableBuilder(
                listenable: expenseStore,
                builder: (BuildContext context, Widget? child) {
                  return _buildRecentExpenses(expenseStore);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
