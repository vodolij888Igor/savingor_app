import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:savingor_app/core/theme/savingor_design_system.dart';
import 'package:savingor_app/core/widgets/app_screen_states.dart';
import 'package:savingor_app/features/analytics/domain/expense_analytics_calculator.dart';
import 'package:savingor_app/features/expenses/data/expenses_store.dart';
import 'package:savingor_app/features/expenses/domain/models/user_expense.dart';

class SavingsAnalyticsScreen extends StatelessWidget {
  const SavingsAnalyticsScreen({super.key});

  static const Color _pageBackground = Colors.white;
  static const Color _nearBlack = Color(0xFF111827);
  static const Color _airyBorder = Color(0xFFF3F4F3);

  static void _goBack(BuildContext context) {
    if (context.canPop()) {
      context.pop();
    } else {
      context.go('/deals');
    }
  }

  static String _formatCurrency(double amount) {
    return '\$${amount.toStringAsFixed(2)}';
  }

  static String _formatDate(DateTime date) {
    const List<String> months = <String>[
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    return '${months[date.month - 1]} ${date.day}, ${date.year}';
  }

  static BoxDecoration _cardDecoration() {
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

        return Scaffold(
          backgroundColor: _pageBackground,
          appBar: AppBar(
            title: const Text(
              'Savings analytics',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w800,
                color: SavingorColors.darkGreen,
              ),
            ),
            elevation: 0,
            scrolledUnderElevation: 0,
            backgroundColor: _pageBackground,
            surfaceTintColor: Colors.transparent,
            leading: BackButton(
              color: SavingorColors.darkGreen,
              onPressed: () => _goBack(context),
            ),
            automaticallyImplyLeading: false,
          ),
          body: _buildBody(context, store, bottomInset),
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
      return const AppLoadingState();
    }

    if (store.loadError != null) {
      return AppErrorState(
        title: 'Could not load analytics',
        message: store.loadError!,
        onRetry: store.retry,
      );
    }

    final ExpenseAnalyticsSummary summary =
        ExpenseAnalyticsCalculator.compute(store.expenses);

    if (summary.isEmpty) {
      return AppEmptyState(
        icon: Icons.insights_outlined,
        title: 'No spending data yet',
        message:
            'Add grocery expenses to see monthly totals, store breakdowns, and trends.',
        actionLabel: 'Add expense',
        onAction: () => context.push('/expenses/create'),
      );
    }

    return ListView(
      padding: EdgeInsets.fromLTRB(20, 8, 20, 24 + bottomInset),
      children: <Widget>[
        _buildSummaryGrid(summary),
        const SizedBox(height: SavingorSpacing.xl),
        _buildSpendingByStore(summary),
        const SizedBox(height: SavingorSpacing.xl),
        _buildRecentExpenses(summary),
      ],
    );
  }

  Widget _buildSignInRequired(BuildContext context) {
    return Scaffold(
      backgroundColor: _pageBackground,
      appBar: AppBar(
        title: const Text(
          'Savings analytics',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w800,
            color: SavingorColors.darkGreen,
          ),
        ),
        backgroundColor: _pageBackground,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        leading: BackButton(
          color: SavingorColors.darkGreen,
          onPressed: () => _goBack(context),
        ),
        automaticallyImplyLeading: false,
      ),
      body: AppEmptyState(
        icon: Icons.lock_outline_rounded,
        title: 'Sign in required',
        message: 'View spending analytics with your Savingor account.',
        actionLabel: 'Sign in',
        onAction: () => context.push('/auth'),
      ),
    );
  }

  Widget _buildSummaryGrid(ExpenseAnalyticsSummary summary) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        const Text(
          'Overview',
          style: TextStyle(
            fontSize: 17,
            fontWeight: FontWeight.w700,
            color: SavingorColors.darkGreen,
          ),
        ),
        const SizedBox(height: SavingorSpacing.md),
        Row(
          children: <Widget>[
            Expanded(
              child: _SummaryCard(
                label: 'This month',
                value: _formatCurrency(summary.totalThisMonth),
                icon: Icons.calendar_today_outlined,
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: _SummaryCard(
                label: 'This year',
                value: _formatCurrency(summary.totalThisYear),
                icon: Icons.date_range_outlined,
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        Row(
          children: <Widget>[
            Expanded(
              child: _SummaryCard(
                label: 'Total expenses',
                value: '${summary.expenseCount}',
                icon: Icons.receipt_long_outlined,
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: _SummaryCard(
                label: 'Average expense',
                value: _formatCurrency(summary.averageExpense),
                icon: Icons.payments_outlined,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildSpendingByStore(ExpenseAnalyticsSummary summary) {
    final double maxStoreTotal = summary.spendingByStore.isEmpty
        ? 0
        : summary.spendingByStore.first.totalAmount;

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: _cardDecoration(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          const Text(
            'Spending by store',
            style: TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.w700,
              color: SavingorColors.darkGreen,
            ),
          ),
          const SizedBox(height: SavingorSpacing.md),
          ...summary.spendingByStore.map(
            (StoreSpendingEntry entry) => Padding(
              padding: const EdgeInsets.only(bottom: 14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      Expanded(
                        child: Text(
                          entry.storeName,
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                            color: _nearBlack,
                          ),
                        ),
                      ),
                      Text(
                        _formatCurrency(entry.totalAmount),
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w800,
                          color: SavingorColors.darkGreen,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${entry.expenseCount} ${entry.expenseCount == 1 ? 'expense' : 'expenses'}',
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: SavingorColors.textSecondary,
                    ),
                  ),
                  if (maxStoreTotal > 0) ...<Widget>[
                    const SizedBox(height: 8),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(999),
                      child: LinearProgressIndicator(
                        value: entry.totalAmount / maxStoreTotal,
                        minHeight: 6,
                        backgroundColor: const Color(0xFFF0F2F1),
                        valueColor: const AlwaysStoppedAnimation<Color>(
                          SavingorColors.primaryGreen,
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRecentExpenses(ExpenseAnalyticsSummary summary) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: _cardDecoration(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          const Text(
            'Recent expenses',
            style: TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.w700,
              color: SavingorColors.darkGreen,
            ),
          ),
          const SizedBox(height: SavingorSpacing.md),
          ...summary.recentExpenses.map(
            (UserExpense expense) => Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Row(
                children: <Widget>[
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: SavingorColors.lightGreen,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(
                      Icons.storefront_outlined,
                      color: SavingorColors.primaryStroke,
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          expense.storeName,
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                            color: _nearBlack,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          _formatDate(expense.purchaseDate),
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            color: SavingorColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Text(
                    _formatCurrency(expense.totalAmount),
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w800,
                      color: SavingorColors.darkGreen,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SummaryCard extends StatelessWidget {
  const _SummaryCard({
    required this.label,
    required this.value,
    required this.icon,
  });

  final String label;
  final String value;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: SavingsAnalyticsScreen._cardDecoration(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Icon(icon, size: 22, color: SavingorColors.primaryStroke),
          const SizedBox(height: 10),
          Text(
            label,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: SavingorColors.textSecondary,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            value,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w800,
              color: SavingsAnalyticsScreen._nearBlack,
              letterSpacing: -0.3,
            ),
          ),
        ],
      ),
    );
  }
}
