import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:savingor_app/core/theme/savingor_design_system.dart';
import 'package:savingor_app/features/expenses/data/expenses_store.dart';
import 'package:savingor_app/features/expenses/domain/models/user_expense.dart';

class ExpensesScreen extends StatelessWidget {
  const ExpensesScreen({super.key});

  static const Color _pageBackground = Colors.white;

  static void _goBack(BuildContext context) {
    if (context.canPop()) {
      context.pop();
    } else {
      context.go('/deals');
    }
  }

  static AppBar _buildAppBar(BuildContext context) {
    return AppBar(
      title: const Text('Expenses', style: _titleStyle),
      centerTitle: false,
      elevation: 0,
      scrolledUnderElevation: 0,
      backgroundColor: _pageBackground,
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
    final double bottomInset = MediaQuery.paddingOf(context).bottom;

    return AnimatedBuilder(
      animation: store,
      builder: (BuildContext context, Widget? child) {
        if (!store.isAuthenticated) {
          return _buildSignInRequired(context);
        }

        final bool showAddFab = !store.isLoading &&
            store.loadError == null &&
            store.expenses.isNotEmpty;

        return Scaffold(
          backgroundColor: _pageBackground,
          appBar: _buildAppBar(context),
          body: _buildBody(context, store, bottomInset),
          floatingActionButton: showAddFab
              ? FloatingActionButton.extended(
                  onPressed: () => context.push('/expenses/create'),
                  backgroundColor: SavingorColors.primaryGreen,
                  foregroundColor: SavingorColors.darkGreen,
                  icon: const Icon(Icons.add_rounded),
                  label: const Text(
                    'Add expense',
                    style: TextStyle(fontWeight: FontWeight.w700),
                  ),
                )
              : null,
        );
      },
    );
  }

  Widget _buildBody(
    BuildContext context,
    ExpensesStore store,
    double bottomInset,
  ) {
    if (store.isLoading) {
      return const Center(
        child: CircularProgressIndicator(color: SavingorColors.primaryStroke),
      );
    }

    if (store.loadError != null) {
      return _StateMessage(
        icon: Icons.cloud_off_outlined,
        title: 'Could not load expenses',
        message: store.loadError!,
        actionLabel: 'Retry',
        onAction: store.retry,
      );
    }

    if (store.expenses.isEmpty) {
      return _StateMessage(
        icon: Icons.receipt_long_outlined,
        title: 'No expenses yet',
        message:
            'Track grocery purchases and receipts to understand your spending.',
        actionLabel: 'Add expense',
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
          onDelete: () => _confirmDelete(context, store, expense),
        );
      },
    );
  }

  Widget _buildSignInRequired(BuildContext context) {
    return Scaffold(
      backgroundColor: _pageBackground,
      appBar: _buildAppBar(context),
      body: _StateMessage(
        icon: Icons.lock_outline_rounded,
        title: 'Sign in required',
        message: 'Save and sync your expenses with your Savingor account.',
        actionLabel: 'Sign in',
        onAction: () => context.push('/auth'),
      ),
    );
  }

  Future<void> _confirmDelete(
    BuildContext context,
    ExpensesStore store,
    UserExpense expense,
  ) async {
    final bool? confirmed = await showDialog<bool>(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: const Text('Delete expense?'),
          content: Text(
            '“${expense.storeName}” (\$${expense.totalAmount.toStringAsFixed(2)}) will be permanently removed.',
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(false),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(true),
              child: const Text(
                'Delete',
                style: TextStyle(color: Color(0xFFB91C1C)),
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
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(error)));
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
    required this.onDelete,
  });

  final UserExpense expense;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
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
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                      color: SavingorColors.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '\$${expense.totalAmount.toStringAsFixed(2)}',
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
              color: SavingorColors.textSecondary,
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

class _StateMessage extends StatelessWidget {
  const _StateMessage({
    required this.icon,
    required this.title,
    required this.message,
    required this.actionLabel,
    required this.onAction,
    this.prominentAction = false,
  });

  final IconData icon;
  final String title;
  final String message;
  final String actionLabel;
  final VoidCallback onAction;
  final bool prominentAction;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(28),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Icon(icon, size: 56, color: SavingorColors.textSecondary),
            const SizedBox(height: 16),
            Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: SavingorColors.darkGreen,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              message,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: SavingorColors.textSecondary,
                height: 1.45,
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: prominentAction ? double.infinity : null,
              child: FilledButton(
                onPressed: onAction,
                style: prominentAction
                    ? SavingorButtonStyles.primaryFilled().copyWith(
                        minimumSize: const WidgetStatePropertyAll<Size>(
                          Size.fromHeight(56),
                        ),
                      )
                    : SavingorButtonStyles.primaryFilled(),
                child: Text(actionLabel),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
