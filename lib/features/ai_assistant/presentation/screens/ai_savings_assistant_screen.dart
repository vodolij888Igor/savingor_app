import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:savingor_app/core/theme/savingor_design_system.dart';
import 'package:savingor_app/core/widgets/app_screen_states.dart';
import 'package:savingor_app/features/ai_assistant/data/ai_savings_assistant_provider.dart';
import 'package:savingor_app/features/ai_assistant/domain/ai_savings_assistant_service.dart';
import 'package:savingor_app/features/ai_assistant/domain/ai_savings_context.dart';
import 'package:savingor_app/features/ai_assistant/domain/models/savings_insight.dart';
import 'package:savingor_app/features/expenses/data/expenses_store.dart';
import 'package:savingor_app/features/shopping/data/shopping_lists_store.dart';

class AiSavingsAssistantScreen extends StatefulWidget {
  const AiSavingsAssistantScreen({super.key});

  @override
  State<AiSavingsAssistantScreen> createState() =>
      _AiSavingsAssistantScreenState();
}

class _AiSavingsAssistantScreenState extends State<AiSavingsAssistantScreen> {
  static const Color _pageBackground = Colors.white;
  static const Color _airyBorder = Color(0xFFF3F4F3);

  List<SavingsInsight>? _insights;
  bool _isGenerating = false;
  String? _generationError;
  bool _storesReadyHandled = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _onStoresUpdated());
  }

  void _goBack() {
    if (context.canPop()) {
      context.pop();
    } else {
      context.go('/deals');
    }
  }

  bool _isFirestoreLoading(
    ExpensesStore expensesStore,
    ShoppingListsStore shoppingListsStore,
  ) {
    return expensesStore.isLoading || shoppingListsStore.isLoadingLists;
  }

  Future<void> _generateInsights() async {
    if (_isGenerating) return;

    setState(() {
      _isGenerating = true;
      _generationError = null;
    });

    try {
      final ExpensesStore expensesStore = ExpensesProvider.of(context);
      final ShoppingListsStore shoppingListsStore =
          ShoppingListsProvider.of(context);
      final AiSavingsAssistantService service =
          AiSavingsAssistantProvider.of(context);

      final AiSavingsContext contextSnapshot = AiSavingsContext.fromStores(
        expensesStore: expensesStore,
        shoppingListsStore: shoppingListsStore,
      );

      final List<SavingsInsight> insights =
          await service.generateInsights(contextSnapshot);

      if (!mounted) return;
      setState(() {
        _insights = insights;
        _isGenerating = false;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _generationError = 'Could not generate insights. Please try again.';
        _isGenerating = false;
      });
    }
  }

  void _onStoresUpdated() {
    if (!mounted) return;

    final ExpensesStore expensesStore = ExpensesProvider.of(context);
    final ShoppingListsStore shoppingListsStore =
        ShoppingListsProvider.of(context);

    if (_isFirestoreLoading(expensesStore, shoppingListsStore)) {
      return;
    }

    if (!_storesReadyHandled || (_insights == null && !_isGenerating)) {
      _storesReadyHandled = true;
      _generateInsights();
    }
  }

  void _retryAll() {
    _storesReadyHandled = false;
    _insights = null;
    final ExpensesStore expensesStore = ExpensesProvider.of(context);
    final ShoppingListsStore shoppingListsStore =
        ShoppingListsProvider.of(context);

    if (expensesStore.loadError != null) {
      expensesStore.retry();
    }
    if (shoppingListsStore.listsError != null) {
      shoppingListsStore.retryLists();
    }
    if (expensesStore.loadError == null &&
        shoppingListsStore.listsError == null) {
      _generateInsights();
    }
  }

  @override
  Widget build(BuildContext context) {
    final ExpensesStore expensesStore = ExpensesProvider.of(context);
    final ShoppingListsStore shoppingListsStore =
        ShoppingListsProvider.of(context);
    final double bottomInset = MediaQuery.paddingOf(context).bottom;

    return ListenableBuilder(
      listenable: Listenable.merge(<Listenable>[
        expensesStore,
        shoppingListsStore,
      ]),
      builder: (BuildContext context, Widget? _) {
        WidgetsBinding.instance.addPostFrameCallback((_) => _onStoresUpdated());

        return Scaffold(
          backgroundColor: _pageBackground,
          appBar: AppBar(
            title: const Text(
              'AI Savings Assistant',
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
              onPressed: _goBack,
            ),
            automaticallyImplyLeading: false,
          ),
          body: _buildBody(
            expensesStore: expensesStore,
            shoppingListsStore: shoppingListsStore,
            bottomInset: bottomInset,
          ),
        );
      },
    );
  }

  Widget _buildBody({
    required ExpensesStore expensesStore,
    required ShoppingListsStore shoppingListsStore,
    required double bottomInset,
  }) {
    if (!expensesStore.isAuthenticated) {
      return AppSignInRequiredState(
        message:
            'Sign in to receive personalized savings guidance from your data.',
        onSignIn: () => context.push('/auth'),
      );
    }

    if (_isFirestoreLoading(expensesStore, shoppingListsStore)) {
      return const AppLoadingState(message: 'Loading your data…');
    }

    if (expensesStore.loadError != null || shoppingListsStore.listsError != null) {
      final String message = expensesStore.loadError ??
          shoppingListsStore.listsError ??
          'Something went wrong.';
      return AppErrorState(
        title: 'Could not load your data',
        message: message,
        onRetry: _retryAll,
      );
    }

    if (_generationError != null) {
      return AppErrorState(
        title: 'Could not load insights',
        message: _generationError!,
        onRetry: _generateInsights,
      );
    }

    if (_isGenerating || _insights == null) {
      return const AppLoadingState(message: 'Analyzing your data…');
    }

    final List<SavingsInsight> insights = _insights!;

    if (insights.isEmpty) {
      return AppEmptyState(
        icon: Icons.auto_awesome_outlined,
        title: 'No insights yet',
        message:
            'Add expenses or shopping lists to receive personalized tips.',
        actionLabel: 'Refresh',
        onAction: _generateInsights,
      );
    }

    return RefreshIndicator(
      color: SavingorColors.primaryStroke,
      onRefresh: () async {
        _storesReadyHandled = false;
        await _generateInsights();
      },
      child: ListView(
        padding: EdgeInsets.fromLTRB(20, 8, 20, 24 + bottomInset),
        children: <Widget>[
          _buildHeaderBanner(),
          const SizedBox(height: SavingorSpacing.xl),
          ...insights.map(
            (SavingsInsight insight) => Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: _InsightCard(insight: insight),
            ),
          ),
          const SizedBox(height: SavingorSpacing.md),
          Text(
            'Insights are generated from your Savingor data. '
            'A secure cloud assistant will enhance these recommendations in a future update.',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: SavingorColors.textSecondary.withOpacity(0.9),
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeaderBanner() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: <Color>[
            SavingorColors.lightGreen.withOpacity(0.72),
            const Color(0xFFEAF6E8),
            Colors.white.withOpacity(0.9),
          ],
        ),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: _airyBorder.withOpacity(0.45), width: 0.5),
      ),
      child: const Row(
        children: <Widget>[
          Icon(
            Icons.auto_awesome_rounded,
            color: SavingorColors.primaryStroke,
            size: 28,
          ),
          SizedBox(width: 14),
          Expanded(
            child: Text(
              'Personalized guidance based on your expenses and shopping lists.',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: SavingorColors.darkGreen,
                height: 1.35,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _InsightCard extends StatelessWidget {
  const _InsightCard({required this.insight});

  final SavingsInsight insight;

  @override
  Widget build(BuildContext context) {
    final Color accent = _accentForSeverity(insight.severity);
    final IconData icon = _iconForType(insight.type);

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: const Color(0xFFF3F4F3).withOpacity(0.6),
          width: 0.5,
        ),
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 12,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: accent.withOpacity(0.15),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(icon, color: accent, size: 22),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  insight.title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: SavingorColors.darkGreen,
                  ),
                ),
                if (insight.highlightValue != null) ...<Widget>[
                  const SizedBox(height: 6),
                  Text(
                    insight.highlightValue!,
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w800,
                      color: accent,
                      letterSpacing: -0.5,
                    ),
                  ),
                ],
                const SizedBox(height: 6),
                Text(
                  insight.message,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: SavingorColors.textSecondary,
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  static Color _accentForSeverity(InsightSeverity severity) {
    switch (severity) {
      case InsightSeverity.positive:
        return SavingorColors.primaryStroke;
      case InsightSeverity.warning:
        return const Color(0xFFC4895A);
      case InsightSeverity.info:
        return SavingorColors.darkGreen;
    }
  }

  static IconData _iconForType(InsightType type) {
    switch (type) {
      case InsightType.spending:
        return Icons.payments_outlined;
      case InsightType.shopping:
        return Icons.checklist_rounded;
      case InsightType.savings:
        return Icons.savings_outlined;
      case InsightType.receipt:
        return Icons.receipt_long_outlined;
      case InsightType.onboarding:
        return Icons.lightbulb_outline_rounded;
    }
  }
}
