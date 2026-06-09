import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:savingor_app/core/app_state.dart';
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

/// First-tab Savingor home dashboard at `/deals`.
class HomeDashboardScreen extends StatelessWidget {
  const HomeDashboardScreen({super.key});

  static const Color _pageWhite = SavingorColors.pageWhite;
  static const Color _nearBlack = Color(0xFF111827);
  static const Color _airyBorder = Color(0xFFF3F4F3);

  static String _formatCurrency(double amount) {
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

  static _DashboardData _computeDashboardData(
    ExpensesStore expensesStore,
    ShoppingListsStore shoppingListsStore,
    ReceiptStore receiptStore,
  ) {
    double expensesTotal = 0;
    for (final UserExpense expense in expensesStore.expenses) {
      expensesTotal += expense.totalAmount;
    }

    double receiptsTotal = 0;
    for (final Receipt receipt in receiptStore.receipts) {
      receiptsTotal += receipt.total;
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

  static String _languageBadgeLabel(String? code) {
    final String normalized = (code ?? 'en').trim().toLowerCase();
    if (normalized.isEmpty) {
      return 'EN';
    }
    return normalized.toUpperCase();
  }

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

  BoxDecoration _airyCardDecoration({double radius = 18}) {
    return BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(radius),
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

  Widget _heroSparkle({double size = 4}) {
    return Icon(
      Icons.circle,
      size: size,
      color: SavingorColors.primaryStroke.withOpacity(0.28),
    );
  }

  Widget _metricCard({
    required IconData icon,
    required String title,
    required String value,
    required String suffix,
    required Color iconAccent,
  }) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 12),
        decoration: _airyCardDecoration(radius: 14),
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
                color: SavingorColors.textSecondary.withOpacity(0.78),
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
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w800,
                      color: _nearBlack,
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
                color: SavingorColors.textSecondary.withOpacity(0.72),
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

  Widget _statusPill({required Widget child}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(SavingorRadius.pill),
        border: Border.all(color: _airyBorder.withOpacity(0.5), width: 0.5),
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
    final double monthlyBudget = appState.monthlyGroceryBudget;
    final double bottomInset = MediaQuery.paddingOf(context).bottom;

    return ListenableBuilder(
      listenable: expensesStore,
      builder: (BuildContext context, Widget? _) {
        return ListenableBuilder(
          listenable: shoppingListsStore,
          builder: (BuildContext context, Widget? __) {
            return ListenableBuilder(
              listenable: receiptStore,
              builder: (BuildContext context, Widget? ___) {
                return ListenableBuilder(
                  listenable: priceMemoryStore,
                  builder: (BuildContext context, Widget? ____) {
                    final _DashboardData data = _computeDashboardData(
                      expensesStore,
                      shoppingListsStore,
                      receiptStore,
                    );
                    final HomeDashboardSummary summary =
                        HomeDashboardSummaryBuilder.build(
                      expenses: expensesStore.expenses,
                      receipts: receiptStore.receipts,
                      priceRecords: priceMemoryStore.records,
                    );
                    final double heroRingProgress = monthlyBudget <= 0
                        ? 0
                        : (data.totalExpenses / monthlyBudget).clamp(0.0, 1.0);
                    final double monthlyGoalProgress = monthlyBudget <= 0
                        ? 0
                        : (summary.spentThisMonth / monthlyBudget)
                            .clamp(0.0, 1.0);

                    return Scaffold(
                      backgroundColor: _pageWhite,
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
                                languageCode: languageCode,
                              ),
                              const SizedBox(height: SavingorSpacing.lg + SavingorSpacing.sm),
                              _buildGreeting(),
                              const SizedBox(
                                height:
                                    SavingorSpacing.lg + SavingorSpacing.md,
                              ),
                              _buildMetricsRow(
                                data,
                                spentThisMonth: summary.spentThisMonth,
                              ),
                              const SizedBox(height: SavingorSpacing.lg + SavingorSpacing.sm),
                              _buildSavingsHero(
                                data.totalExpenses,
                                heroRingProgress,
                                data.expenseCount,
                              ),
                              const SizedBox(height: SavingorSpacing.lg + SavingorSpacing.sm),
                              _buildStartSavingButton(context),
                              const SizedBox(height: SavingorSpacing.lg + SavingorSpacing.sm),
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
                                formatCurrency: _formatCurrency,
                              ),
                              const SizedBox(height: SavingorSpacing.lg),
                              _buildRecentActivity(data),
                              const SizedBox(height: SavingorSpacing.lg),
                              _buildMonthlyGoal(
                                summary.spentThisMonth,
                                monthlyGoalProgress,
                                monthlyBudget,
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
  }

  Widget _buildStatusRow(
    BuildContext context, {
    required String? languageCode,
  }) {
    return Padding(
      padding: const EdgeInsets.only(top: 14),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          _statusPill(
            child: const Row(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Text(
                  '🇨🇦',
                  style: TextStyle(fontSize: 14, height: 1.1),
                ),
                SizedBox(width: 6),
                Text(
                  'Canada · CAD',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: SavingorColors.textPrimary,
                    height: 1.1,
                  ),
                ),
              ],
            ),
          ),
          const Spacer(),
          _statusPill(
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
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: SavingorColors.textPrimary,
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
    double totalExpenses,
    double ringProgress,
    int expenseCount,
  ) {
    const double ringSize = 220;

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
                    backgroundColor: const Color(0xFFF3F5F4),
                    valueColor: const AlwaysStoppedAnimation<Color>(
                      SavingorColors.primaryGreen,
                    ),
                  ),
                ),
                Container(
                  width: ringSize - 40,
                  height: ringSize - 40,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white,
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
                              _formatCurrency(totalExpenses),
                              maxLines: 1,
                              softWrap: false,
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                fontSize: 42,
                                fontWeight: FontWeight.w800,
                                color: _nearBlack,
                                height: 1,
                                letterSpacing: -1.5,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 4),
                        const Text(
                          'Total expenses',
                          textAlign: TextAlign.center,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: SavingorColors.textSecondary,
                          ),
                        ),
                        const SizedBox(height: 6),
                        const Text(
                          'Tracked in Savingor',
                          textAlign: TextAlign.center,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                            color: SavingorColors.primaryStroke,
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
            '$expenseCount ${expenseCount == 1 ? 'expense' : 'expenses'} tracked',
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w700,
              color: SavingorColors.primaryStroke,
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildStartSavingButton(BuildContext context) {
    return SavingorInteractivePressable(
      onTap: () => _onStartSaving(context),
      borderRadius: BorderRadius.circular(28),
      semanticLabel: 'Start saving',
      builder: (BuildContext context, SavingorInteractionState state) {
        final bool active = state.isInteractive && state.hovered;

        return AnimatedContainer(
          duration: SavingorInteraction.duration,
          curve: SavingorInteraction.curve,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(28),
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: active
                  ? const <Color>[
                      Color(0xFFA3D99C),
                      Color(0xFF88D07E),
                      Color(0xFF7BC96E),
                    ]
                  : const <Color>[
                      Color(0xFF96CF8F),
                      Color(0xFF7BC96E),
                      Color(0xFF72C067),
                    ],
              stops: const <double>[0.0, 0.45, 1.0],
            ),
            boxShadow: <BoxShadow>[
              BoxShadow(
                color: SavingorColors.primaryStroke
                    .withOpacity(active ? 0.28 : 0.22),
                blurRadius: active ? 18 : 14,
                offset: Offset(0, active ? 7 : 5),
              ),
            ],
          ),
          child: const Padding(
            padding: EdgeInsets.symmetric(horizontal: 24, vertical: 23),
            child: Center(
              child: Row(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Text(
                    '✨ START SAVING',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w800,
                      color: SavingorColors.darkGreen,
                      height: 1.0,
                      letterSpacing: 0.4,
                    ),
                  ),
                  SizedBox(width: 16),
                  Icon(
                    Icons.arrow_forward_rounded,
                    size: 20,
                    color: SavingorColors.darkGreen,
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
    _DashboardData data, {
    required double spentThisMonth,
  }) {
    return SizedBox(
      height: 118,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          _metricCard(
            icon: Icons.trending_up_rounded,
            title: 'This month',
            value: _formatCurrency(spentThisMonth),
            suffix: 'spent',
            iconAccent: const Color(0xFFEF4444),
          ),
          const SizedBox(width: 7),
          _metricCard(
            icon: Icons.receipt_long_rounded,
            title: 'Receipts',
            value: '${data.receiptCount}',
            suffix: 'recorded',
            iconAccent: const Color(0xFF64748B),
          ),
          const SizedBox(width: 7),
          _metricCard(
            icon: Icons.checklist_rounded,
            title: 'Shopping list',
            value: '${data.shoppingListCount}',
            suffix: 'lists',
            iconAccent: const Color(0xFFF97316),
          ),
          const SizedBox(width: 7),
          _metricCard(
            icon: Icons.sell_rounded,
            title: 'Active deals',
            value: _formatCurrency(data.estimatedShoppingTotal),
            suffix: 'estimated',
            iconAccent: const Color(0xFF9333EA),
          ),
        ],
      ),
    );
  }

  Widget _buildMonthlyGoal(
    double spentThisMonth,
    double progress,
    double monthlyBudget,
  ) {
    final int progressPercent = (progress * 100).round();

    return Container(
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 14),
      decoration: _airyCardDecoration(radius: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          const Text(
            'Monthly goal',
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w700,
              color: SavingorColors.textPrimary,
            ),
          ),
          const SizedBox(height: 10),
          Row(
            children: <Widget>[
              Text(
                '${_formatCurrency(spentThisMonth)} / ${_formatCurrency(monthlyBudget)}',
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w800,
                  color: _nearBlack,
                ),
              ),
              const Spacer(),
              Text(
                '$progressPercent%',
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: SavingorColors.primaryStroke,
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
              backgroundColor: const Color(0xFFF0F2F1),
              valueColor: const AlwaysStoppedAnimation<Color>(
                SavingorColors.primaryGreen,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRecentActivity(_DashboardData data) {
    final UserExpense? latest = data.latestExpense;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 18),
      decoration: _airyCardDecoration(radius: 18),
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
                  latest == null ? 'No recent activity' : 'Expense added',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: SavingorColors.textPrimary,
                    height: 1.2,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  latest == null
                      ? 'Add an expense to see it here'
                      : '${latest.storeName} • ${_formatActivityDate(latest.purchaseDate)}',
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                    color: SavingorColors.textSecondary,
                    height: 1.3,
                  ),
                ),
              ],
            ),
          ),
          Text(
            latest == null
                ? _formatCurrency(0)
                : _formatCurrency(latest.totalAmount),
            style: const TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.w800,
              color: _nearBlack,
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

  String get _greetingLine {
    final String? firstName = _firstName?.trim();
    if (firstName != null && firstName.isNotEmpty) {
      return 'Welcome back, $firstName! 👋';
    }
    return 'Welcome back! 👋';
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          _greetingLine,
          style: SavingorAppTextStyles.greetingTitle,
        ),
        const SizedBox(height: 6),
        Text(
          'Ready to save smarter today?',
          style: SavingorAppTextStyles.bodySecondary(fontSize: 16),
        ),
      ],
    );
  }
}
