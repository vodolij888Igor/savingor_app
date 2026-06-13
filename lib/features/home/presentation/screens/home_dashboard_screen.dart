import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:savingor_app/core/app_state.dart';
import 'package:savingor_app/core/i18n/app_settings_l10n.dart';
import 'package:savingor_app/core/i18n/locale_display.dart';
import 'package:savingor_app/core/theme/savingor_design_system.dart';
import 'package:savingor_app/core/widgets/savingor_interactive.dart';
import 'package:savingor_app/features/expenses/data/expenses_store.dart';
import 'package:savingor_app/features/expenses/domain/models/user_expense.dart';
import 'package:savingor_app/features/home/domain/home_dashboard_summary.dart';
import 'package:savingor_app/features/home/presentation/widgets/dashboard_best_action_card.dart';
import 'package:savingor_app/features/home/presentation/widgets/dashboard_product_feature_cards_row.dart';
import 'package:savingor_app/features/home/presentation/widgets/dashboard_summary_section.dart';
import 'package:savingor_app/features/price_memory/data/price_memory_store.dart';
import 'package:savingor_app/features/scanner/data/receipt_store.dart';
import 'package:savingor_app/features/scanner/domain/models/receipt.dart';
import 'package:savingor_app/features/shopping/data/shopping_lists_store.dart';
import 'package:savingor_app/features/profile/data/user_profile_service.dart';
import 'package:savingor_app/l10n/app_localizations.dart';

/// First-tab Savingor home dashboard at `/deals`.
class HomeDashboardScreen extends StatelessWidget {
  const HomeDashboardScreen({super.key});

  static _DashboardData _computeDashboardData(
    ExpensesStore expensesStore,
    ShoppingListsStore shoppingListsStore,
    ReceiptStore receiptStore,
    AppState appState,
  ) {
    final DisplayAmountConverter convert = appState.toDisplayConverter;

    double expensesTotal = 0;
    for (final UserExpense expense in expensesStore.expenses) {
      expensesTotal += convert(expense.totalAmount, expense.currency);
    }

    double receiptsTotal = 0;
    for (final Receipt receipt in receiptStore.receipts) {
      receiptsTotal += convert(receipt.total, receipt.currency);
    }

    final double totalExpenses = expensesTotal + receiptsTotal;

    double estimatedShoppingTotal = shoppingListsStore.totalEstimatedListValue;

    UserExpense? latestExpense;
    if (expensesStore.expenses.isNotEmpty) {
      final List<UserExpense> sorted = List<UserExpense>.from(
        expensesStore.expenses,
      )..sort(
          (UserExpense a, UserExpense b) =>
              b.purchaseDate.compareTo(a.purchaseDate),
        );
      latestExpense = sorted.first;
    }

    Receipt? latestReceipt;
    if (receiptStore.receipts.isNotEmpty) {
      final List<Receipt> sorted = List<Receipt>.from(receiptStore.receipts)
        ..sort((Receipt a, Receipt b) => b.date.compareTo(a.date));
      latestReceipt = sorted.first;
    }

    final bool hasInsightData = expensesStore.expenses.isNotEmpty ||
        receiptStore.receipts.isNotEmpty ||
        shoppingListsStore.listCount > 0;

    return _DashboardData(
      totalExpenses: totalExpenses,
      expenseCount: expensesStore.expenses.length,
      receiptCount: receiptStore.receipts.length,
      shoppingListCount: shoppingListsStore.listCount,
      estimatedShoppingTotal: estimatedShoppingTotal,
      hasInsightData: hasInsightData,
      latestExpense: latestExpense,
      latestReceipt: latestReceipt,
    );
  }

  static String _languageBadgeLabel(String? code) =>
      LocaleDisplay.languageBadge(code);

  static String _formatActivityDate(DateTime date) {
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

  BoxDecoration _airyCardDecoration(BuildContext context,
      {double radius = 18}) {
    final SavingorThemeExtension t = context.savingor;
    return BoxDecoration(
      color: t.isDark ? t.surfaceElevated : t.surfacePrimary,
      borderRadius: BorderRadius.circular(radius),
      border: Border.all(
        color: t.border.withOpacity(t.isDark ? 0.95 : 0.6),
        width: 0.5,
      ),
      boxShadow: t.cardShadow,
    );
  }

  Widget _heroSparkle({double size = 4}) {
    return Icon(
      Icons.circle,
      size: size,
      color: SavingorColors.primaryStroke.withOpacity(0.28),
    );
  }

  Widget _metricCard(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String value,
    required String suffix,
    required Color iconAccent,
  }) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 12),
        decoration: _airyCardDecoration(context, radius: 14),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Center(
              child: Icon(
                icon,
                size: 32,
                color: iconAccent,
                fill: 1.0,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              title,
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 9,
                fontWeight: FontWeight.w500,
                color: context.savingor.textSecondary.withOpacity(0.78),
                height: 1.1,
              ),
            ),
            const SizedBox(height: 4),
            Flexible(
              child: Align(
                alignment: Alignment.center,
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  alignment: Alignment.center,
                  child: Text(
                    value,
                    textAlign: TextAlign.center,
                    maxLines: 1,
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w800,
                      color: context.savingor.textPrimary,
                      height: 1.05,
                      letterSpacing: -0.3,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 2),
            Text(
              suffix,
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 9,
                fontWeight: FontWeight.w500,
                color: context.savingor.textSecondary.withOpacity(0.72),
                height: 1.1,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _onStartSaving(BuildContext context) {
    context.push('/start-saving');
  }

  Widget _statusPill(BuildContext context, {required Widget child}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 8),
      decoration: BoxDecoration(
        color: context.savingor.surfacePrimary,
        borderRadius: BorderRadius.circular(SavingorRadius.pill),
        border: Border.all(
          color: context.savingor.border.withOpacity(
            context.savingor.isDark ? 0.85 : 0.5,
          ),
          width: 0.5,
        ),
      ),
      child: child,
    );
  }

  @override
  Widget build(BuildContext context) {
    final ExpensesStore expensesStore = ExpensesProvider.of(context);
    final ShoppingListsStore shoppingListsStore =
        ShoppingListsProvider.of(context);
    final ReceiptStore receiptStore = ReceiptProvider.of(context);
    final PriceMemoryStore priceMemoryStore = PriceMemoryProvider.of(context);
    final AppState appState = AppStateProvider.of(context);
    final String? languageCode = appState.language;
    final double bottomInset = MediaQuery.paddingOf(context).bottom;

    return ListenableBuilder(
      listenable: appState,
      builder: (BuildContext context, Widget? _) {
        final double monthlyBudget = appState.displayMonthlyBudget;
        formatMoney(double amount) => appState.formatMoney(amount);

        return ListenableBuilder(
          listenable: expensesStore,
          builder: (BuildContext context, Widget? __) {
            return ListenableBuilder(
              listenable: shoppingListsStore,
              builder: (BuildContext context, Widget? ___) {
                return ListenableBuilder(
                  listenable: receiptStore,
                  builder: (BuildContext context, Widget? ____) {
                    return ListenableBuilder(
                      listenable: priceMemoryStore,
                      builder: (BuildContext context, Widget? _____) {
                        final _DashboardData data = _computeDashboardData(
                          expensesStore,
                          shoppingListsStore,
                          receiptStore,
                          appState,
                        );
                        final HomeDashboardSummary summary =
                            HomeDashboardSummaryBuilder.build(
                          expenses: expensesStore.expenses,
                          receipts: receiptStore.receipts,
                          priceRecords: priceMemoryStore.records,
                          convertToDisplay: appState.toDisplayConverter,
                        );
                        final double heroRingProgress = monthlyBudget <= 0
                            ? 0
                            : (data.totalExpenses / monthlyBudget)
                                .clamp(0.0, 1.0);
                        final double monthlyGoalProgress = monthlyBudget <= 0
                            ? 0
                            : (summary.spentThisMonth / monthlyBudget)
                                .clamp(0.0, 1.0);
                        final AppLocalizations l10n =
                            AppLocalizations.of(context);

                        return Scaffold(
                          backgroundColor: context.savingor.pageBackground,
                          body: SafeArea(
                            child: SingleChildScrollView(
                              padding: EdgeInsets.fromLTRB(
                                20,
                                0,
                                20,
                                32 + bottomInset + 72,
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: <Widget>[
                                  _buildStatusRow(
                                    context,
                                    appState: appState,
                                    languageCode: languageCode,
                                  ),
                                  const SizedBox(
                                      height: SavingorSpacing.lg +
                                          SavingorSpacing.sm),
                                  _buildGreeting(),
                                  const SizedBox(
                                    height:
                                        SavingorSpacing.lg + SavingorSpacing.md,
                                  ),
                                  _buildMetricsRow(
                                    context,
                                    data,
                                    l10n: l10n,
                                    spentThisMonth: summary.spentThisMonth,
                                    formatMoney: formatMoney,
                                  ),
                                  const SizedBox(
                                      height: SavingorSpacing.lg +
                                          SavingorSpacing.sm),
                                  _buildSavingsHero(
                                    context,
                                    data.totalExpenses,
                                    heroRingProgress,
                                    data.expenseCount,
                                    l10n: l10n,
                                    formatMoney: formatMoney,
                                  ),
                                  const SizedBox(
                                      height: SavingorSpacing.lg +
                                          SavingorSpacing.sm),
                                  _buildStartSavingButton(context, l10n),
                                  const SizedBox(
                                      height: SavingorSpacing.lg +
                                          SavingorSpacing.sm),
                                  DashboardBestActionCard(
                                    recommendation: summary.topRecommendation,
                                  ),
                                  const SizedBox(height: SavingorSpacing.lg),
                                  DashboardProductFeatureCardsRow(
                                    records: priceMemoryStore.records,
                                  ),
                                  const SizedBox(height: SavingorSpacing.lg),
                                  DashboardSummarySection(
                                    summary: summary,
                                    formatCurrency: formatMoney,
                                  ),
                                  const SizedBox(height: SavingorSpacing.lg),
                                  _buildRecentActivity(
                                    context,
                                    data,
                                    l10n: l10n,
                                    appState: appState,
                                    formatMoney: formatMoney,
                                  ),
                                  const SizedBox(height: SavingorSpacing.lg),
                                  _buildMonthlyGoal(
                                    context,
                                    summary.spentThisMonth,
                                    monthlyGoalProgress,
                                    monthlyBudget,
                                    l10n: l10n,
                                    formatMoney: formatMoney,
                                  ),
                                ],
                              ),
                            ),
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
      },
    );
  }

  static String _regionFlagEmoji(String regionId) {
    return regionId == 'us' ? '🇺🇸' : '🇨🇦';
  }

  Widget _buildStatusRow(
    BuildContext context, {
    required AppState appState,
    required String? languageCode,
  }) {
    return Padding(
      padding: const EdgeInsets.only(top: 14),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          _statusPill(
            context,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Text(
                  _regionFlagEmoji(appState.region),
                  style: const TextStyle(fontSize: 14, height: 1.1),
                ),
                const SizedBox(width: 6),
                Text(
                  '${AppSettingsL10n.regionLabel(context, appState.region)} · ${appState.currency}',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: context.savingor.textPrimary,
                    height: 1.1,
                  ),
                ),
              ],
            ),
          ),
          const Spacer(),
          _statusPill(
            context,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                const Text(
                  '🌐',
                  style: TextStyle(fontSize: 14, height: 1.1),
                ),
                const SizedBox(width: 6),
                Text(
                  _languageBadgeLabel(languageCode),
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: context.savingor.textPrimary,
                    height: 1.1,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGreeting() {
    return const _DashboardGreeting();
  }

  Widget _buildSavingsHero(
    BuildContext context,
    double totalExpenses,
    double ringProgress,
    int expenseCount, {
    required AppLocalizations l10n,
    required String Function(double) formatMoney,
  }) {
    const double ringSize = 220;
    final SavingorThemeExtension theme = context.savingor;

    return Column(
      children: <Widget>[
        Center(
          child: SizedBox(
            width: ringSize,
            height: ringSize,
            child: Stack(
              clipBehavior: Clip.none,
              alignment: Alignment.center,
              children: <Widget>[
                SizedBox(
                  width: ringSize,
                  height: ringSize,
                  child: CircularProgressIndicator(
                    value: ringProgress,
                    strokeWidth: 10,
                    strokeCap: StrokeCap.round,
                    backgroundColor: theme.ringTrack,
                    valueColor:
                        AlwaysStoppedAnimation<Color>(theme.accentGreen),
                  ),
                ),
                Container(
                  width: ringSize - 40,
                  height: ringSize - 40,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: theme.surfaceStrong,
                  ),
                  alignment: Alignment.center,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        SizedBox(
                          width: ringSize - 60,
                          child: FittedBox(
                            fit: BoxFit.scaleDown,
                            alignment: Alignment.center,
                            child: Text(
                              formatMoney(totalExpenses),
                              maxLines: 1,
                              softWrap: false,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 42,
                                fontWeight: FontWeight.w800,
                                color: theme.textPrimary,
                                height: 1,
                                letterSpacing: -1.5,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          l10n.totalExpenses,
                          textAlign: TextAlign.center,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: context.savingor.textSecondary,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          l10n.trackedInSavingor,
                          textAlign: TextAlign.center,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                            color: theme.brandTitle,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Positioned(top: 6, right: 2, child: _heroSparkle(size: 5)),
                Positioned(top: 36, left: -2, child: _heroSparkle(size: 3.5)),
                Positioned(bottom: 22, right: -4, child: _heroSparkle(size: 4)),
              ],
            ),
          ),
        ),
        if (expenseCount > 0) ...<Widget>[
          const SizedBox(height: SavingorSpacing.md),
          Text(
            l10n.expensesTracked(expenseCount),
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w700,
              color: theme.brandTitle,
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildStartSavingButton(BuildContext context, AppLocalizations l10n) {
    final SavingorThemeExtension theme = context.savingor;

    return SavingorInteractivePressable(
      onTap: () => _onStartSaving(context),
      borderRadius: BorderRadius.circular(28),
      semanticLabel: l10n.startSaving,
      builder: (BuildContext context, SavingorInteractionState state) {
        final bool active = state.isInteractive && state.hovered;

        return AnimatedContainer(
          duration: SavingorInteraction.duration,
          curve: SavingorInteraction.curve,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(28),
            color: theme.accentGreen,
            border: Border.all(
              color: theme.accentGreen.withOpacity(theme.isDark ? 0.35 : 0.5),
            ),
            boxShadow: theme.isDark
                ? <BoxShadow>[
                    BoxShadow(
                      color:
                          theme.accentGreen.withOpacity(active ? 0.18 : 0.12),
                      blurRadius: active ? 12 : 8,
                      offset: Offset(0, active ? 4 : 3),
                    ),
                  ]
                : <BoxShadow>[
                    BoxShadow(
                      color: SavingorColors.primaryStroke
                          .withOpacity(active ? 0.28 : 0.22),
                      blurRadius: active ? 18 : 14,
                      offset: Offset(0, active ? 7 : 5),
                    ),
                  ],
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 23),
            child: Center(
              child: Row(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Flexible(
                    child: Text(
                      l10n.startSavingHero,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w800,
                        color: theme.buttonLabelOnGreen,
                        height: 1.0,
                        letterSpacing: 0.4,
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Icon(
                    Icons.arrow_forward_rounded,
                    size: 20,
                    color: theme.buttonLabelOnGreen,
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildMetricsRow(
    BuildContext context,
    _DashboardData data, {
    required AppLocalizations l10n,
    required double spentThisMonth,
    required String Function(double) formatMoney,
  }) {
    return SizedBox(
      height: 118,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          _metricCard(
            context,
            icon: Icons.trending_up_rounded,
            title: l10n.thisMonth,
            value: formatMoney(spentThisMonth),
            suffix: l10n.spent,
            iconAccent: const Color(0xFFEF4444),
          ),
          const SizedBox(width: 7),
          _metricCard(
            context,
            icon: Icons.receipt_long_rounded,
            title: l10n.receipts,
            value: '${data.receiptCount}',
            suffix: l10n.recorded,
            iconAccent: const Color(0xFF64748B),
          ),
          const SizedBox(width: 7),
          _metricCard(
            context,
            icon: Icons.checklist_rounded,
            title: l10n.shoppingList,
            value: '${data.shoppingListCount}',
            suffix: l10n.lists,
            iconAccent: const Color(0xFFF97316),
          ),
          const SizedBox(width: 7),
          _metricCard(
            context,
            icon: Icons.sell_rounded,
            title: l10n.activeDeals,
            value: formatMoney(data.estimatedShoppingTotal),
            suffix: l10n.estimated,
            iconAccent: const Color(0xFF9333EA),
          ),
        ],
      ),
    );
  }

  Widget _buildMonthlyGoal(
    BuildContext context,
    double spentThisMonth,
    double progress,
    double monthlyBudget, {
    required AppLocalizations l10n,
    required String Function(double) formatMoney,
  }) {
    final int progressPercent = (progress * 100).round();

    return Container(
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 14),
      decoration: _airyCardDecoration(context, radius: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            l10n.monthlyGoal,
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w700,
              color: context.savingor.textPrimary,
            ),
          ),
          const SizedBox(height: 10),
          Row(
            children: <Widget>[
              Text(
                '${formatMoney(spentThisMonth)} / ${formatMoney(monthlyBudget)}',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w800,
                  color: context.savingor.textPrimary,
                ),
              ),
              const Spacer(),
              Text(
                '$progressPercent%',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: context.savingor.brandTitle,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          ClipRRect(
            borderRadius: BorderRadius.circular(999),
            child: LinearProgressIndicator(
              value: progress,
              minHeight: 7,
              backgroundColor: context.savingor.ringTrack,
              valueColor: AlwaysStoppedAnimation<Color>(
                context.savingor.accentGreen,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRecentActivity(
    BuildContext context,
    _DashboardData data, {
    required AppLocalizations l10n,
    required AppState appState,
    required String Function(double) formatMoney,
  }) {
    final UserExpense? latest = data.latestExpense;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 18),
      decoration: _airyCardDecoration(context, radius: 18),
      child: Row(
        children: <Widget>[
          Container(
            width: 44,
            height: 44,
            decoration: SavingorSurfaces.accentIconBlock(
              accent: SavingorAccentColors.expenses,
              radius: 14,
            ),
            child: const Icon(
              Icons.receipt_long_rounded,
              color: SavingorAccentColors.expenses,
              size: 22,
            ),
          ),
          const SizedBox(width: SavingorSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  latest == null ? l10n.noRecentActivity : l10n.expenseAdded,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: context.savingor.textPrimary,
                    height: 1.2,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  latest == null
                      ? l10n.addExpenseToSeeHere
                      : '${latest.storeName} • ${_formatActivityDate(latest.purchaseDate)}',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                    color: context.savingor.textSecondary,
                    height: 1.3,
                  ),
                ),
              ],
            ),
          ),
          Text(
            latest == null
                ? formatMoney(0)
                : appState.formatMoney(
                    latest.totalAmount,
                    originalCurrency: latest.currency,
                  ),
            style: TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.w800,
              color: context.savingor.textPrimary,
              letterSpacing: -0.2,
            ),
          ),
        ],
      ),
    );
  }
}

class _DashboardData {
  const _DashboardData({
    required this.totalExpenses,
    required this.expenseCount,
    required this.receiptCount,
    required this.shoppingListCount,
    required this.estimatedShoppingTotal,
    required this.hasInsightData,
    required this.latestExpense,
    required this.latestReceipt,
  });

  final double totalExpenses;
  final int expenseCount;
  final int receiptCount;
  final int shoppingListCount;
  final double estimatedShoppingTotal;
  final bool hasInsightData;
  final UserExpense? latestExpense;
  final Receipt? latestReceipt;
}

class _DashboardGreeting extends StatefulWidget {
  const _DashboardGreeting();

  @override
  State<_DashboardGreeting> createState() => _DashboardGreetingState();
}

class _DashboardGreetingState extends State<_DashboardGreeting> {
  final UserProfileService _userProfileService = UserProfileService();
  String? _firstName;

  @override
  void initState() {
    super.initState();
    _loadGreetingName();
  }

  Future<void> _loadGreetingName() async {
    try {
      final String? firstName =
          await _userProfileService.resolveGreetingFirstName();
      if (!mounted) {
        return;
      }
      setState(() => _firstName = firstName);
    } catch (_) {
      // Keep generic greeting on failure.
    }
  }

  String _greetingLine(AppLocalizations l10n) {
    final String? firstName = _firstName?.trim();
    if (firstName != null && firstName.isNotEmpty) {
      return l10n.welcomeBackName(firstName);
    }
    return l10n.welcomeBack;
  }

  @override
  Widget build(BuildContext context) {
    final AppLocalizations l10n = AppLocalizations.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          _greetingLine(l10n),
          style: SavingorAppTextStyles.greetingTitle(context),
        ),
        const SizedBox(height: 6),
        Text(
          l10n.readyToSaveSmarterToday,
          style: SavingorAppTextStyles.bodySecondary(context, fontSize: 16),
        ),
      ],
    );
  }
}
