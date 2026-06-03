import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:savingor_app/core/theme/savingor_design_system.dart';
import 'package:savingor_app/core/widgets/app_screen_states.dart';
import 'package:savingor_app/features/analytics/domain/expense_analytics_calculator.dart';
import 'package:savingor_app/features/expenses/data/expenses_store.dart';
import 'package:savingor_app/features/scanner/data/receipt_store.dart';

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
    final ExpensesStore expensesStore = ExpensesProvider.of(context);
    final ReceiptStore receiptStore = ReceiptProvider.of(context);
    final double bottomInset = MediaQuery.paddingOf(context).bottom;

    return AnimatedBuilder(
      animation: expensesStore,
      builder: (BuildContext context, Widget? _) {
        return AnimatedBuilder(
          animation: receiptStore,
          builder: (BuildContext context, Widget? __) {
            if (!expensesStore.isAuthenticated && !receiptStore.isAuthenticated) {
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
              body: _buildBody(
                context,
                expensesStore,
                receiptStore,
                bottomInset,
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildBody(
    BuildContext context,
    ExpensesStore expensesStore,
    ReceiptStore receiptStore,
    double bottomInset,
  ) {
    if (expensesStore.isLoading || receiptStore.isLoading) {
      return const AppLoadingState(message: 'Loading analytics…');
    }

    if (expensesStore.loadError != null) {
      return AppErrorState(
        title: 'Could not load analytics',
        message: expensesStore.loadError!,
        onRetry: expensesStore.retry,
      );
    }

    if (receiptStore.loadError != null) {
      return AppErrorState(
        title: 'Could not load analytics',
        message: receiptStore.loadError!,
        onRetry: receiptStore.retry,
      );
    }

    final ExpenseAnalyticsSummary summary = ExpenseAnalyticsCalculator.compute(
      expensesStore.expenses,
      receipts: receiptStore.receipts,
    );

    if (summary.isEmpty) {
      return AppEmptyState(
        icon: Icons.insights_outlined,
        title: 'No spending data yet',
        message:
            'Add a receipt or expense to see spending totals, store breakdowns, and trends.',
        actionLabel: 'Add receipt',
        prominentAction: true,
        onAction: () => context.push('/scanner/create'),
      );
    }

    return ListView(
      padding: EdgeInsets.fromLTRB(20, 8, 20, 24 + bottomInset),
      children: <Widget>[
        _buildSummaryGrid(summary),
        const SizedBox(height: SavingorSpacing.xl),
        _buildSpendingByStore(summary),
        const SizedBox(height: SavingorSpacing.xl),
        _buildRecentActivity(summary),
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
      body: AppSignInRequiredState(
        message: 'View spending analytics with your Savingor account.',
        onSignIn: () => context.push('/auth'),
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
                label: 'Receipts',
                value: '${summary.receiptCount}',
                icon: Icons.receipt_long_outlined,
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: _SummaryCard(
                label: 'Average receipt',
                value: _formatCurrency(summary.averageReceiptAmount),
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
                    '${entry.recordCount} ${entry.recordCount == 1 ? 'record' : 'records'}',
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

  Widget _buildRecentActivity(ExpenseAnalyticsSummary summary) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: _cardDecoration(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          const Text(
            'Recent activity',
            style: TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.w700,
              color: SavingorColors.darkGreen,
            ),
          ),
          const SizedBox(height: SavingorSpacing.md),
          ...summary.recentActivity.map(
            (AnalyticsActivityEntry entry) => Padding(
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
                    child: Icon(
                      entry.typeLabel == 'receipt'
                          ? Icons.receipt_long_outlined
                          : Icons.storefront_outlined,
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
                          entry.title,
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                            color: _nearBlack,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          '${_formatDate(entry.date)} · ${entry.typeLabel}',
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            color: SavingorColors.textSecondary,
                          ),
                        ),
                        if (entry.subtitle.isNotEmpty) ...<Widget>[
                          const SizedBox(height: 2),
                          Text(
                            entry.subtitle,
                            style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                              color: SavingorColors.textSecondary,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                  Text(
                    _formatCurrency(entry.amount),
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
