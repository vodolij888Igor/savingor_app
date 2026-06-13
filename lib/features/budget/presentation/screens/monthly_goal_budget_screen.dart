import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';

import 'package:savingor_app/core/app_state.dart';
import 'package:savingor_app/core/theme/savingor_design_system.dart';
import 'package:savingor_app/core/widgets/savingor_interactive.dart';
import 'package:savingor_app/features/analytics/domain/expense_analytics_calculator.dart';
import 'package:savingor_app/features/expenses/data/expenses_store.dart';
import 'package:savingor_app/features/scanner/data/receipt_store.dart';
import 'package:savingor_app/l10n/app_localizations.dart';

class MonthlyGoalBudgetScreen extends StatefulWidget {
  const MonthlyGoalBudgetScreen({super.key});

  @override
  State<MonthlyGoalBudgetScreen> createState() =>
      _MonthlyGoalBudgetScreenState();
}

class _MonthlyGoalBudgetScreenState extends State<MonthlyGoalBudgetScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _budgetController = TextEditingController();

  bool _isSaving = false;
  bool _initializedBudgetField = false;

  @override
  void dispose() {
    _budgetController.dispose();
    super.dispose();
  }

  String _formatCurrency(AppState appState, double amount) =>
      appState.formatMoney(amount);

  BoxDecoration _cardDecoration(BuildContext context) =>
      SavingorWorkflowTheme.card(context);

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
    appState.setMonthlyGroceryBudget(parsed, currency: appState.currency);
    if (!mounted) {
      return;
    }
    setState(() => _isSaving = false);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(AppLocalizations.of(context).budgetSaved)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final AppState appState = AppStateProvider.of(context);
    final AppLocalizations l10n = AppLocalizations.of(context);
    final ExpensesStore expensesStore = ExpensesProvider.of(context);
    final ReceiptStore receiptStore = ReceiptProvider.of(context);
    final double bottomInset = MediaQuery.paddingOf(context).bottom;

    return ListenableBuilder(
      listenable: appState,
      builder: (BuildContext context, Widget? _) {
        _syncBudgetField(appState.displayMonthlyBudget);

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
                  convertToDisplay: appState.toDisplayConverter,
                );
                final double budget = appState.displayMonthlyBudget;
                final double spentThisMonth = summary.totalThisMonth;
                final bool isOverBudget = spentThisMonth > budget;
                final double difference = (budget - spentThisMonth).abs();
                final double progress =
                    budget <= 0 ? 0 : (spentThisMonth / budget).clamp(0.0, 1.0);
                final int progressPercent = (progress * 100).round();

                return Scaffold(
                  backgroundColor: context.savingor.pageBackground,
                  appBar: AppBar(
                    title: Text(
                      l10n.monthlyGoalBudget,
                      style: SavingorAppTextStyles.screenTitle(context),
                    ),
                    elevation: 0,
                    scrolledUnderElevation: 0,
                    backgroundColor: context.savingor.pageBackground,
                    surfaceTintColor: Colors.transparent,
                    leading: IconButton(
                      icon: Icon(
                        Icons.arrow_back_ios_new_rounded,
                        color: context.savingor.textPrimary,
                        size: 20,
                      ),
                      onPressed: () => context.pop(),
                    ),
                  ),
                  body: SingleChildScrollView(
                    padding:
                        EdgeInsets.fromLTRB(20, 8, 20, 32 + bottomInset + 88),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          l10n.trackMonthlyGrocerySpending,
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: context.savingor.textSecondary
                                .withOpacity(0.95),
                            height: 1.4,
                          ),
                        ),
                        const SizedBox(height: SavingorSpacing.xl),
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(18),
                          decoration: _cardDecoration(context),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              _summaryRow(
                                label: l10n.monthlyGroceryBudget,
                                value: _formatCurrency(appState, budget),
                              ),
                              const SizedBox(height: 14),
                              _summaryRow(
                                label: l10n.spentThisMonth,
                                value:
                                    _formatCurrency(appState, spentThisMonth),
                              ),
                              const SizedBox(height: 14),
                              _summaryRow(
                                label: isOverBudget
                                    ? l10n.overBudget
                                    : l10n.remaining,
                                value: _formatCurrency(appState, difference),
                                valueColor: isOverBudget
                                    ? SavingorWorkflowTheme.overBudget(context)
                                    : SavingorWorkflowTheme.accentText(context),
                              ),
                              const SizedBox(height: 16),
                              Row(
                                children: <Widget>[
                                  Text(
                                    '${_formatCurrency(appState, spentThisMonth)} / ${_formatCurrency(appState, budget)}',
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w800,
                                      color: SavingorWorkflowTheme.primaryText(
                                        context,
                                      ),
                                    ),
                                  ),
                                  const Spacer(),
                                  Text(
                                    '$progressPercent%',
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w700,
                                      color: isOverBudget
                                          ? SavingorWorkflowTheme.overBudget(
                                              context,
                                            )
                                          : SavingorWorkflowTheme.accentText(
                                              context,
                                            ),
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
                                  backgroundColor:
                                      SavingorWorkflowTheme.progressTrack(
                                    context,
                                  ),
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                    SavingorWorkflowTheme.progressValue(
                                      context,
                                      isOver: isOverBudget,
                                    ),
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
                          decoration: _cardDecoration(context),
                          child: Form(
                            key: _formKey,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text(
                                  l10n.updateMonthlyBudget,
                                  style:
                                      SavingorAppTextStyles.cardTitle(context),
                                ),
                                const SizedBox(height: 6),
                                Text(
                                  l10n.setMonthlyBudgetDescription,
                                  style: TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w500,
                                    color: context.savingor.textSecondary
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
                                  decoration:
                                      SavingorWorkflowTheme.fieldDecoration(
                                    context,
                                    label: l10n.monthlyBudgetAmount,
                                    prefixText: '${appState.currency} \$ ',
                                  ),
                                  validator: (String? value) {
                                    final String trimmed = value?.trim() ?? '';
                                    if (trimmed.isEmpty) {
                                      return l10n.enterBudgetAmount;
                                    }
                                    final double? parsed =
                                        double.tryParse(trimmed);
                                    if (parsed == null || parsed <= 0) {
                                      return l10n.enterAmountGreaterThanZero;
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
                                  borderRadius: BorderRadius.circular(14),
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 14,
                                  ),
                                  child: _isSaving
                                      ? SizedBox(
                                          width: 20,
                                          height: 20,
                                          child: CircularProgressIndicator(
                                            strokeWidth: 2,
                                            color: context
                                                .savingor.buttonLabelOnGreen,
                                          ),
                                        )
                                      : Text(
                                          l10n.saveBudget,
                                          style: const TextStyle(
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
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: context.savingor.textSecondary,
              height: 1.35,
            ),
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w800,
            color: valueColor ?? context.savingor.textPrimary,
          ),
        ),
      ],
    );
  }
}
