import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:savingor_app/core/app_state.dart';
import 'package:savingor_app/core/i18n/expense_l10n.dart';
import 'package:savingor_app/core/theme/savingor_design_system.dart';
import 'package:savingor_app/core/widgets/app_screen_states.dart';
import 'package:savingor_app/features/expenses/data/expenses_store.dart';
import 'package:savingor_app/features/expenses/domain/models/user_expense.dart';
import 'package:savingor_app/l10n/app_localizations.dart';

class ExpensesScreen extends StatelessWidget {
  const ExpensesScreen({super.key});
  static void _goBack(BuildContext context) {
    if (context.canPop()) {
      context.pop();
    } else {
      context.go('/deals');
    }
  }

  static AppBar _buildAppBar(BuildContext context, AppLocalizations l10n) {
    return AppBar(
      title: Text(l10n.expenses, style: _titleStyle),
      centerTitle: false,
      elevation: 0,
      scrolledUnderElevation: 0,
      backgroundColor: context.savingor.pageBackground,
      surfaceTintColor: Colors.transparent,
      leading: BackButton(
        color: SavingorColors.darkGreen,
        onPressed: () => _goBack(context),
      ),
      automaticallyImplyLeading: false,
    );
  }

  @override
  Widget build(BuildContext context) {
    final ExpensesStore store = ExpensesProvider.of(context);
    final AppState appState = AppStateProvider.of(context);
    final double bottomInset = MediaQuery.paddingOf(context).bottom;
    final AppLocalizations l10n = AppLocalizations.of(context);

    return ListenableBuilder(
      listenable: appState,
      builder: (BuildContext context, Widget? _) {
        return AnimatedBuilder(
          animation: store,
          builder: (BuildContext context, Widget? child) {
            if (!store.isAuthenticated) {
              return _buildSignInRequired(context, l10n);
            }

            final bool showAddFab = !store.isLoading &&
                store.loadError == null &&
                store.expenses.isNotEmpty;

            return Scaffold(
              backgroundColor: context.savingor.pageBackground,
              appBar: _buildAppBar(context, l10n),
              body: _buildBody(context, store, appState, bottomInset, l10n),
              floatingActionButton: showAddFab
                  ? FloatingActionButton.extended(
                      onPressed: () => context.push('/expenses/create'),
                      backgroundColor: SavingorColors.primaryGreen,
                      foregroundColor: SavingorColors.darkGreen,
                      icon: const Icon(Icons.add_rounded),
                      label: Text(
                        l10n.addExpense,
                        style: const TextStyle(fontWeight: FontWeight.w700),
                      ),
                    )
                  : null,
            );
          },
        );
      },
    );
  }

  Widget _buildBody(
    BuildContext context,
    ExpensesStore store,
    AppState appState,
    double bottomInset,
    AppLocalizations l10n,
  ) {
    if (store.isLoading) {
      return AppLoadingState(message: l10n.loadingExpenses);
    }

    if (store.loadError != null) {
      return AppErrorState(
        title: l10n.couldNotLoadExpenses,
        message: ExpenseL10n.localizeError(context, store.loadError),
        onRetry: store.retry,
        actionLabel: l10n.tryAgain,
      );
    }

    if (store.expenses.isEmpty) {
      return AppEmptyState(
        icon: Icons.receipt_long_outlined,
        title: l10n.noExpensesYet,
        message: l10n.noExpensesYetMessage,
        actionLabel: l10n.addExpense,
        prominentAction: true,
        onAction: () => context.push('/expenses/create'),
      );
    }

    return ListView.separated(
      padding: EdgeInsets.fromLTRB(20, 8, 20, 96 + bottomInset),
      itemCount: store.expenses.length,
      separatorBuilder: (_, __) => const SizedBox(height: 12),
      itemBuilder: (BuildContext context, int index) {
        final UserExpense expense = store.expenses[index];
        return _ExpenseCard(
          expense: expense,
          amountLabel: appState.formatMoney(
            expense.totalAmount,
            originalCurrency: expense.currency,
          ),
          onDelete: () =>
              _confirmDelete(context, store, expense, appState, l10n),
        );
      },
    );
  }

  Widget _buildSignInRequired(BuildContext context, AppLocalizations l10n) {
    return Scaffold(
      backgroundColor: context.savingor.pageBackground,
      appBar: _buildAppBar(context, l10n),
      body: AppSignInRequiredState(
        title: l10n.signInRequired,
        message: l10n.signInToSyncExpenses,
        onSignIn: () => context.push('/auth'),
        actionLabel: l10n.signIn,
      ),
    );
  }

  Future<void> _confirmDelete(
    BuildContext context,
    ExpensesStore store,
    UserExpense expense,
    AppState appState,
    AppLocalizations l10n,
  ) async {
    final String amountLabel = appState.formatMoney(
      expense.totalAmount,
      originalCurrency: expense.currency,
    );
    final bool? confirmed = await showDialog<bool>(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: Text(l10n.deleteExpenseQuestion),
          content: Text(
            l10n.deleteExpenseConfirmMessage(expense.storeName, amountLabel),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(false),
              child: Text(l10n.cancel),
            ),
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(true),
              child: Text(
                l10n.delete,
                style: const TextStyle(color: Color(0xFFB91C1C)),
              ),
            ),
          ],
        );
      },
    );

    if (confirmed != true || !context.mounted) return;
    await store.deleteExpense(expense.id);
    if (!context.mounted) return;
    final String? error = store.mutationError;
    if (error != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(ExpenseL10n.localizeError(context, error))),
      );
    }
  }

  static const TextStyle _titleStyle = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.w800,
    color: SavingorColors.darkGreen,
    letterSpacing: 0.2,
    height: 1.15,
  );
}

class _ExpenseCard extends StatelessWidget {
  const _ExpenseCard({
    required this.expense,
    required this.amountLabel,
    required this.onDelete,
  });

  final UserExpense expense;
  final String amountLabel;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: context.savingor.surfacePrimary,
      borderRadius: BorderRadius.circular(18),
      clipBehavior: Clip.antiAlias,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 16, 8, 16),
        child: Row(
          children: <Widget>[
            Container(
              width: 46,
              height: 46,
              decoration: BoxDecoration(
                color: SavingorColors.lightGreen,
                borderRadius: BorderRadius.circular(14),
              ),
              child: const Icon(
                Icons.receipt_long_outlined,
                color: SavingorColors.primaryStroke,
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    expense.storeName,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: SavingorColors.darkGreen,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    _formatDate(expense.purchaseDate),
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                      color: context.savingor.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    amountLabel,
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: SavingorColors.darkGreen,
                    ),
                  ),
                ],
              ),
            ),
            IconButton(
              icon: const Icon(Icons.delete_outline_rounded),
              color: context.savingor.textSecondary,
              onPressed: onDelete,
            ),
          ],
        ),
      ),
    );
  }

  static String _formatDate(DateTime date) {
    final String month = date.month.toString().padLeft(2, '0');
    final String day = date.day.toString().padLeft(2, '0');
    return '${date.year}-$month-$day';
  }
}
