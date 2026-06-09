import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';

import 'package:savingor_app/core/app_state.dart';
import 'package:savingor_app/core/theme/savingor_design_system.dart';
import 'package:savingor_app/core/widgets/savingor_interactive.dart';
import 'package:savingor_app/features/analytics/domain/expense_analytics_calculator.dart';
import 'package:savingor_app/features/expenses/data/expenses_store.dart';
import 'package:savingor_app/features/scanner/data/receipt_store.dart';

class MonthlyGoalBudgetScreen extends StatefulWidget {
  const MonthlyGoalBudgetScreen({super.key});

  @override
  State<MonthlyGoalBudgetScreen> createState() =>
      _MonthlyGoalBudgetScreenState();
}

class _MonthlyGoalBudgetScreenState extends State<MonthlyGoalBudgetScreen> {
  static const Color _pageWhite = Color(0xFFFFFEFE);
  static const Color _nearBlack = Color(0xFF111827);
  static const Color _airyBorder = Color(0xFFF3F4F3);
  static const Color _overBudgetColor = Color(0xFFEF4444);

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _budgetController = TextEditingController();

  bool _isSaving = false;
  bool _initializedBudgetField = false;

  @override
  void dispose() {
    _budgetController.dispose();
    super.dispose();
  }

  String _formatCurrency(double amount) {
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

  BoxDecoration _cardDecoration() {
    return BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(18),
      border: Border.all(color: _airyBorder.withOpacity(0.6), width: 0.5),
      boxShadow: <BoxShadow>[
        BoxShadow(
          color: Colors.black.withOpacity(0.04),
          blurRadius: 12,
          offset: const Offset(0, 2),
        ),
      ],
    );
  }

  void _syncBudgetField(double budget) {
    if (_initializedBudgetField) {
      return;
    }
    _budgetController.text = budget.toStringAsFixed(2);
    _initializedBudgetField = true;
  }

  Future<void> _saveBudget(AppState appState) async {
    if (_isSaving || !_formKey.currentState!.validate()) {
      return;
    }

    final double? parsed = double.tryParse(_budgetController.text.trim());
    if (parsed == null || parsed <= 0) {
      return;
    }

    setState(() => _isSaving = true);
    appState.setMonthlyGroceryBudget(parsed);
    if (!mounted) {
      return;
    }
    setState(() => _isSaving = false);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Monthly budget updated')),
    );
  }

  @override
  Widget build(BuildContext context) {
    final AppState appState = AppStateProvider.of(context);
    final ExpensesStore expensesStore = ExpensesProvider.of(context);
    final ReceiptStore receiptStore = ReceiptProvider.of(context);
    final double bottomInset = MediaQuery.paddingOf(context).bottom;

    return ListenableBuilder(
      listenable: appState,
      builder: (BuildContext context, Widget? _) {
        _syncBudgetField(appState.monthlyGroceryBudget);

        return AnimatedBuilder(
          animation: expensesStore,
          builder: (BuildContext context, Widget? __) {
            return AnimatedBuilder(
              animation: receiptStore,
              builder: (BuildContext context, Widget? ___) {
                final ExpenseAnalyticsSummary summary =
                    ExpenseAnalyticsCalculator.compute(
                  expensesStore.expenses,
                  receipts: receiptStore.receipts,
                );
                final double budget = appState.monthlyGroceryBudget;
                final double spentThisMonth = summary.totalThisMonth;
                final bool isOverBudget = spentThisMonth > budget;
                final double difference = (budget - spentThisMonth).abs();
                final double progress = budget <= 0
                    ? 0
                    : (spentThisMonth / budget).clamp(0.0, 1.0);
                final int progressPercent = (progress * 100).round();

                return Scaffold(
                  backgroundColor: _pageWhite,
                  appBar: AppBar(
                    title: const Text(
                      'Monthly goal / Budget',
                      style: SavingorAppTextStyles.screenTitle,
                    ),
                    elevation: 0,
                    scrolledUnderElevation: 0,
                    backgroundColor: _pageWhite,
                    surfaceTintColor: Colors.transparent,
                    leading: IconButton(
                      icon: const Icon(
                        Icons.arrow_back_ios_new_rounded,
                        color: SavingorColors.textPrimary,
                        size: 20,
                      ),
                      onPressed: () => context.pop(),
                    ),
                  ),
                  body: SingleChildScrollView(
                    padding: EdgeInsets.fromLTRB(20, 8, 20, 32 + bottomInset + 88),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          'Track your monthly grocery spending against your budget.',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: SavingorColors.textSecondary.withOpacity(0.95),
                            height: 1.4,
                          ),
                        ),
                        const SizedBox(height: SavingorSpacing.xl),
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(18),
                          decoration: _cardDecoration(),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              _summaryRow(
                                label: 'Monthly grocery budget',
                                value: _formatCurrency(budget),
                              ),
                              const SizedBox(height: 14),
                              _summaryRow(
                                label: 'Spent this month',
                                value: _formatCurrency(spentThisMonth),
                              ),
                              const SizedBox(height: 14),
                              _summaryRow(
                                label: isOverBudget
                                    ? 'Over budget'
                                    : 'Remaining',
                                value: _formatCurrency(difference),
                                valueColor: isOverBudget
                                    ? _overBudgetColor
                                    : SavingorColors.primaryStroke,
                              ),
                              const SizedBox(height: 16),
                              Row(
                                children: <Widget>[
                                  Text(
                                    '${_formatCurrency(spentThisMonth)} / ${_formatCurrency(budget)}',
                                    style: const TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w800,
                                      color: _nearBlack,
                                    ),
                                  ),
                                  const Spacer(),
                                  Text(
                                    '$progressPercent%',
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w700,
                                      color: isOverBudget
                                          ? _overBudgetColor
                                          : SavingorColors.primaryStroke,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 10),
                              ClipRRect(
                                borderRadius: BorderRadius.circular(999),
                                child: LinearProgressIndicator(
                                  value: progress,
                                  minHeight: 8,
                                  backgroundColor: const Color(0xFFF0F2F1),
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                    isOverBudget
                                        ? _overBudgetColor
                                        : SavingorColors.primaryGreen,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: SavingorSpacing.xl),
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(18),
                          decoration: _cardDecoration(),
                          child: Form(
                            key: _formKey,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                const Text(
                                  'Update monthly budget',
                                  style: SavingorAppTextStyles.cardTitle,
                                ),
                                const SizedBox(height: 6),
                                Text(
                                  'Set the grocery spending limit you want to track each month.',
                                  style: TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w500,
                                    color: SavingorColors.textSecondary
                                        .withOpacity(0.95),
                                    height: 1.35,
                                  ),
                                ),
                                const SizedBox(height: 16),
                                TextFormField(
                                  controller: _budgetController,
                                  keyboardType:
                                      const TextInputType.numberWithOptions(
                                    decimal: true,
                                  ),
                                  inputFormatters: <TextInputFormatter>[
                                    FilteringTextInputFormatter.allow(
                                      RegExp(r'^\d*\.?\d{0,2}'),
                                    ),
                                  ],
                                  decoration: InputDecoration(
                                    labelText: 'Monthly budget amount',
                                    prefixText: '\$ ',
                                    filled: true,
                                    fillColor: Colors.white,
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(14),
                                      borderSide: BorderSide(
                                        color: _airyBorder.withOpacity(0.85),
                                      ),
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(14),
                                      borderSide: BorderSide(
                                        color: _airyBorder.withOpacity(0.85),
                                      ),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(14),
                                      borderSide: BorderSide(
                                        color: SavingorColors.primaryStroke
                                            .withOpacity(0.55),
                                      ),
                                    ),
                                  ),
                                  validator: (String? value) {
                                    final String trimmed = value?.trim() ?? '';
                                    if (trimmed.isEmpty) {
                                      return 'Enter a budget amount';
                                    }
                                    final double? parsed =
                                        double.tryParse(trimmed);
                                    if (parsed == null || parsed <= 0) {
                                      return 'Enter an amount greater than zero';
                                    }
                                    return null;
                                  },
                                ),
                                const SizedBox(height: 16),
                                SavingorInteractiveFilledButton(
                                  onPressed: _isSaving
                                      ? null
                                      : () => _saveBudget(appState),
                                  width: double.infinity,
                                  minHeight: 48,
                                  borderRadius:
                                      BorderRadius.circular(14),
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 14,
                                  ),
                                  child: _isSaving
                                      ? const SizedBox(
                                          width: 20,
                                          height: 20,
                                          child: CircularProgressIndicator(
                                            strokeWidth: 2,
                                            color: SavingorColors.darkGreen,
                                          ),
                                        )
                                      : const Text(
                                          'Save budget',
                                          style: TextStyle(
                                            fontSize: 15,
                                            fontWeight: FontWeight.w800,
                                          ),
                                        ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          },
        );
      },
    );
  }

  Widget _summaryRow({
    required String label,
    required String value,
    Color? valueColor,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Expanded(
          child: Text(
            label,
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: SavingorColors.textSecondary,
              height: 1.35,
            ),
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w800,
            color: valueColor ?? SavingorColors.textPrimary,
          ),
        ),
      ],
    );
  }
}
