import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:savingor_app/core/app_state.dart';
import 'package:savingor_app/core/i18n/analytics_activity_l10n.dart';
import 'package:savingor_app/core/i18n/locale_date_format.dart';
import 'package:savingor_app/core/theme/savingor_design_system.dart';
import 'package:savingor_app/core/widgets/savingor_interactive.dart';
import 'package:savingor_app/core/widgets/app_screen_states.dart';
import 'package:savingor_app/features/analytics/domain/expense_analytics_calculator.dart';
import 'package:savingor_app/features/analytics/domain/savings_intelligence_service.dart';
import 'package:savingor_app/features/analytics/domain/savings_recommendation_service.dart';
import 'package:savingor_app/features/analytics/domain/models/savings_recommendation.dart';
import 'package:savingor_app/features/analytics/domain/models/savings_summary.dart';
import 'package:savingor_app/features/analytics/presentation/widgets/recommended_actions_section.dart';
import 'package:savingor_app/features/analytics/presentation/widgets/savings_value_section.dart';
import 'package:savingor_app/features/expenses/data/expenses_store.dart';
import 'package:savingor_app/features/scanner/data/receipt_store.dart';
import 'package:savingor_app/features/price_memory/data/price_memory_store.dart';
import 'package:savingor_app/l10n/app_localizations.dart';

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
    final AppLocalizations l10n = AppLocalizations.of(context);
    final ExpensesStore expensesStore = ExpensesProvider.of(context);
    final ReceiptStore receiptStore = ReceiptProvider.of(context);
    final PriceMemoryStore priceMemoryStore = PriceMemoryProvider.of(context);
    final AppState appState = AppStateProvider.of(context);
    final double bottomInset = MediaQuery.paddingOf(context).bottom;

    return ListenableBuilder(
      listenable: appState,
      builder: (BuildContext context, Widget? _) {
        return AnimatedBuilder(
          animation: expensesStore,
          builder: (BuildContext context, Widget? __) {
            return AnimatedBuilder(
              animation: receiptStore,
              builder: (BuildContext context, Widget? ___) {
                return AnimatedBuilder(
                  animation: priceMemoryStore,
                  builder: (BuildContext context, Widget? ____) {
            if (!expensesStore.isAuthenticated && !receiptStore.isAuthenticated) {
              return _buildSignInRequired(context, l10n);
            }

            return Scaffold(
              backgroundColor: _pageBackground,
              appBar: AppBar(
                title: Text(
                  l10n.savingsAnalytics,
                  style: SavingorAppTextStyles.screenTitle,
                ),
                elevation: 0,
                scrolledUnderElevation: 0,
                backgroundColor: _pageBackground,
                surfaceTintColor: Colors.transparent,
                leading: BackButton(
                  color: SavingorColors.textPrimary,
                  onPressed: () => _goBack(context),
                ),
                automaticallyImplyLeading: false,
              ),
              body: _buildBody(
                context,
                appState,
                expensesStore,
                receiptStore,
                priceMemoryStore,
                bottomInset,
                l10n,
              ),
            );
                  },
                );
              },
            );
          },
        );
      },
    );
  }

  Widget _buildBody(
    BuildContext context,
    AppState appState,
    ExpensesStore expensesStore,
    ReceiptStore receiptStore,
    PriceMemoryStore priceMemoryStore,
    double bottomInset,
    AppLocalizations l10n,
  ) {
    final String Function(double) formatCurrency =
        (double amount) => appState.formatMoney(amount);
    final String Function(double) formatPriceMemory =
        (double amount) =>
            appState.formatMoney(amount, originalCurrency: 'CAD');
    if (expensesStore.isLoading ||
        receiptStore.isLoading ||
        priceMemoryStore.isLoading) {
      return AppLoadingState(message: l10n.loadingAnalytics);
    }

    if (expensesStore.loadError != null) {
      return AppErrorState(
        title: l10n.couldNotLoadAnalytics,
        message: expensesStore.loadError!,
        onRetry: expensesStore.retry,
      );
    }

    if (receiptStore.loadError != null) {
      return AppErrorState(
        title: l10n.couldNotLoadAnalytics,
        message: receiptStore.loadError!,
        onRetry: receiptStore.retry,
      );
    }

    if (priceMemoryStore.loadError != null) {
      return AppErrorState(
        title: l10n.couldNotLoadAnalytics,
        message: priceMemoryStore.loadError!,
        onRetry: priceMemoryStore.retry,
      );
    }

    final SavingsSummary savingsSummary = SavingsIntelligenceService.compute(
      priceMemoryStore.records,
    );
    final List<SavingsRecommendation> recommendations =
        SavingsRecommendationService.compute(priceMemoryStore.records);

    final ExpenseAnalyticsSummary summary = ExpenseAnalyticsCalculator.compute(
      expensesStore.expenses,
      receipts: receiptStore.receipts,
      convertToDisplay: appState.toDisplayConverter,
    );

    if (summary.isEmpty) {
      return ListView(
        padding: EdgeInsets.fromLTRB(20, 8, 20, 24 + bottomInset),
        children: <Widget>[
          _buildOverviewGrid(
            context,
            summary,
            savingsSummary,
            formatCurrency,
            formatPriceMemory,
            l10n,
          ),
          const SizedBox(height: SavingorSpacing.xl),
          SavingsValueSection(
            summary: savingsSummary,
            formatCurrency: formatPriceMemory,
            proPaybackOnly: true,
          ),
          const SizedBox(height: SavingorSpacing.xl),
          RecommendedActionsSection(
            recommendations: recommendations,
            excludeWatchPriceRecommendations: true,
          ),
          const SizedBox(height: SavingorSpacing.xl),
          ..._buildDetailLinks(context, priceMemoryStore, l10n),
          const SizedBox(height: SavingorSpacing.xl),
          AppEmptyState(
            icon: Icons.insights_outlined,
            title: l10n.noSpendingDataYet,
            message: l10n.noSpendingDataMessage,
            actionLabel: l10n.addReceipt,
            prominentAction: true,
            onAction: () => context.push('/scanner/create'),
          ),
        ],
      );
    }

    return ListView(
      padding: EdgeInsets.fromLTRB(20, 8, 20, 24 + bottomInset),
      children: <Widget>[
        _buildOverviewGrid(
          context,
          summary,
          savingsSummary,
          formatCurrency,
          formatPriceMemory,
          l10n,
        ),
        const SizedBox(height: SavingorSpacing.xl),
        SavingsValueSection(
          summary: savingsSummary,
          formatCurrency: formatCurrency,
          proPaybackOnly: true,
        ),
        const SizedBox(height: SavingorSpacing.xl),
        _buildSpendingByStore(context, summary, formatCurrency, l10n),
        const SizedBox(height: SavingorSpacing.xl),
        _buildRecentActivity(context, summary, formatCurrency, l10n),
        const SizedBox(height: SavingorSpacing.xl),
        RecommendedActionsSection(
          recommendations: recommendations,
          excludeWatchPriceRecommendations: true,
        ),
        const SizedBox(height: SavingorSpacing.xl),
        ..._buildDetailLinks(context, priceMemoryStore, l10n),
      ],
    );
  }

  List<Widget> _buildDetailLinks(
    BuildContext context,
    PriceMemoryStore priceMemoryStore,
    AppLocalizations l10n,
  ) {
    return <Widget>[
      Text(
        l10n.exploreDetails,
        style: SavingorAppTextStyles.sectionTitle,
      ),
      const SizedBox(height: SavingorSpacing.md),
      _buildPriceInsightsEntry(context, priceMemoryStore, l10n),
      const SizedBox(height: 12),
      _buildSavingsOpportunitiesEntry(context, priceMemoryStore, l10n),
    ];
  }

  Widget _buildSignInRequired(BuildContext context, AppLocalizations l10n) {
    return Scaffold(
      backgroundColor: _pageBackground,
      appBar: AppBar(
        title: Text(
          l10n.savingsAnalytics,
          style: SavingorAppTextStyles.screenTitle,
        ),
        backgroundColor: _pageBackground,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        leading: BackButton(
          color: SavingorColors.textPrimary,
          onPressed: () => _goBack(context),
        ),
        automaticallyImplyLeading: false,
      ),
      body: AppSignInRequiredState(
        message: l10n.signInForAnalytics,
        onSignIn: () => context.push('/auth'),
      ),
    );
  }

  Widget _buildOverviewGrid(
    BuildContext context,
    ExpenseAnalyticsSummary summary,
    SavingsSummary savingsSummary,
    String Function(double) formatCurrency,
    String Function(double) formatPriceMemory,
    AppLocalizations l10n,
  ) {
    final String estimatedSaved = savingsSummary.hasCalculableData
        ? formatPriceMemory(savingsSummary.estimatedSavedThisMonth)
        : '—';
    final String potentialMissed = savingsSummary.hasCalculableData
        ? formatPriceMemory(savingsSummary.potentialMissedThisMonth)
        : '—';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          l10n.overview,
          style: SavingorAppTextStyles.sectionTitle,
        ),
        const SizedBox(height: SavingorSpacing.md),
        Row(
          children: <Widget>[
            Expanded(
              child: _SummaryCard(
                label: l10n.thisMonth,
                value: formatCurrency(summary.totalThisMonth),
                icon: Icons.calendar_today_outlined,
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: _SummaryCard(
                label: l10n.receipts,
                value: '${summary.receiptCount}',
                icon: Icons.receipt_long_outlined,
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        Row(
          children: <Widget>[
            Expanded(
              child: _SummaryCard(
                label: l10n.estimatedSaved,
                value: estimatedSaved,
                icon: Icons.savings_outlined,
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: _SummaryCard(
                label: l10n.potentialMissed,
                value: potentialMissed,
                icon: Icons.trending_down_outlined,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildPriceInsightsEntry(
    BuildContext context,
    PriceMemoryStore priceMemoryStore,
    AppLocalizations l10n,
  ) {
    final int productCount = priceMemoryStore.insights.length;
    final String subtitle = productCount > 0
        ? l10n.productsInPriceHistoryCount(productCount)
        : l10n.priceInsightsEmptySubtitle;

    return SavingorInteractiveCard(
      onTap: () => context.push('/analytics/product-price-insights'),
      borderRadius: BorderRadius.circular(18),
      accentTint: SavingorAccentColors.priceMemory,
      padding: const EdgeInsets.all(18),
      child: Row(
        children: <Widget>[
          Container(
            width: 46,
            height: 46,
            decoration: SavingorSurfaces.accentIconBlock(
              accent: SavingorAccentColors.priceMemory,
            ),
            child: const Icon(
              Icons.price_change_outlined,
              color: SavingorAccentColors.priceMemory,
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  l10n.productPriceInsights,
                  style: SavingorAppTextStyles.cardTitle,
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                    color: SavingorColors.textSecondary,
                    height: 1.35,
                  ),
                ),
              ],
            ),
          ),
          const Icon(
            Icons.chevron_right_rounded,
            color: SavingorColors.textSecondary,
          ),
        ],
      ),
    );
  }

  Widget _buildSavingsOpportunitiesEntry(
    BuildContext context,
    PriceMemoryStore priceMemoryStore,
    AppLocalizations l10n,
  ) {
    final int opportunityCount = priceMemoryStore.savingsOpportunities.length;
    final String subtitle = opportunityCount > 0
        ? l10n.actionableOpportunitiesCount(opportunityCount)
        : l10n.savingsOpportunitiesEmptySubtitle;

    return SavingorInteractiveCard(
      onTap: () => context.push('/analytics/savings-opportunities'),
      borderRadius: BorderRadius.circular(18),
      accentTint: SavingorAccentColors.savings,
      padding: const EdgeInsets.all(18),
      child: Row(
        children: <Widget>[
          Container(
            width: 46,
            height: 46,
            decoration: SavingorSurfaces.accentIconBlock(
              accent: SavingorAccentColors.savings,
            ),
            child: const Icon(
              Icons.savings_outlined,
              color: SavingorAccentColors.savings,
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  l10n.savingsOpportunities,
                  style: SavingorAppTextStyles.cardTitle,
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                    color: SavingorColors.textSecondary,
                    height: 1.35,
                  ),
                ),
              ],
            ),
          ),
          const Icon(
            Icons.chevron_right_rounded,
            color: SavingorColors.textSecondary,
          ),
        ],
      ),
    );
  }

  Widget _buildSpendingByStore(
    BuildContext context,
    ExpenseAnalyticsSummary summary,
    String Function(double) formatCurrency,
    AppLocalizations l10n,
  ) {
    final double maxStoreTotal = summary.spendingByStore.isEmpty
        ? 0
        : summary.spendingByStore.first.totalAmount;

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: _cardDecoration(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            l10n.spendingByStore,
            style: SavingorAppTextStyles.sectionTitle,
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
                        formatCurrency(entry.totalAmount),
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w800,
                          color: SavingorAccentColors.expenses,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    l10n.priceRecordCount(entry.recordCount),
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

  Widget _buildRecentActivity(
    BuildContext context,
    ExpenseAnalyticsSummary summary,
    String Function(double) formatCurrency,
    AppLocalizations l10n,
  ) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: _cardDecoration(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            l10n.recentActivity,
            style: SavingorAppTextStyles.sectionTitle,
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
                    decoration: SavingorSurfaces.accentIconBlock(
                      accent: entry.typeLabel == 'receipt'
                          ? SavingorAccentColors.expenses
                          : SavingorAccentColors.map,
                    ),
                    child: Icon(
                      entry.typeLabel == 'receipt'
                          ? Icons.receipt_long_outlined
                          : Icons.storefront_outlined,
                      color: entry.typeLabel == 'receipt'
                          ? SavingorAccentColors.expenses
                          : SavingorAccentColors.map,
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
                          '${LocaleDateFormat.formatMediumDate(context, entry.date)} · ${AnalyticsActivityL10n.typeLabel(context, entry)}',
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            color: SavingorColors.textSecondary,
                          ),
                        ),
                        if (AnalyticsActivityL10n.subtitle(context, entry).isNotEmpty) ...<Widget>[
                          const SizedBox(height: 2),
                          Text(
                            AnalyticsActivityL10n.subtitle(context, entry),
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
                    formatCurrency(entry.amount),
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w800,
                      color: SavingorColors.textPrimary,
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
