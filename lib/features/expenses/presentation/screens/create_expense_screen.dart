import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:savingor_app/core/theme/savingor_design_system.dart';
import 'package:savingor_app/features/expenses/data/expenses_store.dart';

class CreateExpenseScreen extends StatefulWidget {
  const CreateExpenseScreen({super.key});

  static const Color _pageBackground = Colors.white;

  @override
  State<CreateExpenseScreen> createState() => _CreateExpenseScreenState();
}

class _CreateExpenseScreenState extends State<CreateExpenseScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _storeController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _amountController = TextEditingController();

  DateTime _selectedDate = DateTime.now();
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    _dateController.text = _formatDate(_selectedDate);
  }

  @override
  void dispose() {
    _storeController.dispose();
    _dateController.dispose();
    _amountController.dispose();
    super.dispose();
  }

  String _formatDate(DateTime date) {
    final String month = date.month.toString().padLeft(2, '0');
    final String day = date.day.toString().padLeft(2, '0');
    return '${date.year}-$month-$day';
  }

  Future<void> _pickDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: SavingorColors.primaryStroke,
              onPrimary: Colors.white,
              surface: Colors.white,
              onSurface: SavingorColors.darkGreen,
            ),
          ),
          child: child ?? const SizedBox.shrink(),
        );
      },
    );

    if (picked == null) return;
    setState(() {
      _selectedDate = picked;
      _dateController.text = _formatDate(picked);
    });
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;

    final double? totalAmount =
        double.tryParse(_amountController.text.trim());
    if (totalAmount == null || totalAmount <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Enter a valid total amount.')),
      );
      return;
    }

    setState(() => _isSaving = true);
    final ExpensesStore store = ExpensesProvider.of(context);

    final String? expenseId = await store.createExpense(
      storeName: _storeController.text.trim(),
      purchaseDate: _selectedDate,
      totalAmount: totalAmount,
    );

    if (!mounted) return;
    setState(() => _isSaving = false);

    if (expenseId != null) {
      context.pop();
      return;
    }

    final String? error = store.mutationError;
    if (error != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(error)),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final double bottomInset = MediaQuery.paddingOf(context).bottom;
    final double keyboardInset = MediaQuery.viewInsetsOf(context).bottom;

    return Scaffold(
      backgroundColor: CreateExpenseScreen._pageBackground,
      appBar: AppBar(
        title: const Text(
          'Add expense',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w800,
            color: SavingorColors.darkGreen,
          ),
        ),
        elevation: 0,
        scrolledUnderElevation: 0,
        backgroundColor: CreateExpenseScreen._pageBackground,
        surfaceTintColor: Colors.transparent,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_new_rounded,
            color: SavingorColors.darkGreen,
            size: 20,
          ),
          onPressed: _isSaving ? null : () => context.pop(),
        ),
      ),
      body: ColoredBox(
        color: CreateExpenseScreen._pageBackground,
        child: Form(
          key: _formKey,
          child: ListView(
            padding: EdgeInsets.fromLTRB(
              20,
              8,
              20,
              24 + bottomInset + keyboardInset,
            ),
            children: <Widget>[
              TextFormField(
                controller: _storeController,
                textInputAction: TextInputAction.next,
                decoration: const InputDecoration(
                  labelText: 'Store Name',
                  border: OutlineInputBorder(),
                ),
                validator: (String? value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Enter a store name';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _dateController,
                readOnly: true,
                onTap: _isSaving ? null : _pickDate,
                decoration: const InputDecoration(
                  labelText: 'Purchase Date',
                  border: OutlineInputBorder(),
                  suffixIcon: Icon(Icons.calendar_today_outlined),
                ),
                validator: (String? value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Select a purchase date';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _amountController,
                keyboardType:
                    const TextInputType.numberWithOptions(decimal: true),
                textInputAction: TextInputAction.done,
                decoration: const InputDecoration(
                  labelText: 'Total Amount',
                  border: OutlineInputBorder(),
                  prefixText: '\$ ',
                ),
                validator: (String? value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Enter the total amount';
                  }
                  final double? amount = double.tryParse(value.trim());
                  if (amount == null || amount <= 0) {
                    return 'Enter a valid amount';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 24),
              FilledButton(
                onPressed: _isSaving ? null : _save,
                style: SavingorButtonStyles.primaryFilled(),
                child: _isSaving
                    ? const SizedBox(
                        width: 22,
                        height: 22,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Text('Save expense'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
