import 'dart:math' as math;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:savingor_app/core/i18n/ai_assistant_l10n.dart';
import 'package:savingor_app/core/theme/savingor_design_system.dart';
import 'package:savingor_app/core/widgets/app_screen_states.dart';
import 'package:savingor_app/features/ai_assistant/data/ai_context_builder.dart';
import 'package:savingor_app/features/ai_assistant/data/ai_savings_assistant_provider.dart';
import 'package:savingor_app/features/ai_assistant/domain/ai_assistant_exception.dart';
import 'package:savingor_app/features/ai_assistant/domain/ai_savings_assistant_service.dart';
import 'package:savingor_app/features/ai_assistant/domain/ai_savings_context.dart';
import 'package:savingor_app/features/ai_assistant/domain/models/ai_assistant_request.dart';
import 'package:savingor_app/features/ai_assistant/domain/models/ai_assistant_response.dart';
import 'package:savingor_app/features/ai_assistant/presentation/widgets/ai_savings_assistant_locked_preview.dart';
import 'package:savingor_app/features/expenses/data/expenses_store.dart';
import 'package:savingor_app/features/scanner/data/receipt_store.dart';
import 'package:savingor_app/features/shopping/data/shopping_lists_store.dart';
import 'package:savingor_app/features/subscription/data/subscription_service.dart';
import 'package:savingor_app/features/subscription/data/debug_subscription_override_store.dart';
import 'package:savingor_app/features/subscription/domain/feature_access_service.dart';
import 'package:savingor_app/features/subscription/domain/savingor_feature.dart';
import 'package:savingor_app/features/subscription/presentation/widgets/feature_access_gate.dart';
import 'package:savingor_app/l10n/app_localizations.dart';

class AiSavingsAssistantScreen extends StatefulWidget {
  const AiSavingsAssistantScreen({super.key});

  @override
  State<AiSavingsAssistantScreen> createState() =>
      _AiSavingsAssistantScreenState();
}

class _AiSavingsAssistantScreenState extends State<AiSavingsAssistantScreen> {
  // Tasteful accent families for chips and question cards.
  static const Color _accentSavings = Color(0xFF4F9D47);
  static const Color _accentStore = Color(0xFF0F766E);
  static const Color _accentAnalysis = Color(0xFFB45309);
  static const Color _accentList = Color(0xFF7C6B9E);
  static const Color _chipTeal = Color(0xFF0D9488);
  static const Color _chipBlue = Color(0xFF4B6B9E);
  static const Color _chipAmber = Color(0xFFCA8A04);
  static const Color _infoAmber = Color(0xFFD97706);

  static const List<_SuggestionTemplate> _suggestionTemplates =
      <_SuggestionTemplate>[
    _SuggestionTemplate(
      icon: Icons.savings_outlined,
      accent: _accentSavings,
    ),
    _SuggestionTemplate(
      icon: Icons.storefront_outlined,
      accent: _accentStore,
    ),
    _SuggestionTemplate(
      icon: Icons.pie_chart_outline_rounded,
      accent: _accentAnalysis,
    ),
    _SuggestionTemplate(
      icon: Icons.checklist_outlined,
      accent: _accentList,
    ),
  ];

  List<_SuggestionItem> _buildSuggestedQuestions(AppLocalizations l10n) {
    final List<String> questions = <String>[
      l10n.aiSuggestSaveMoreThisWeek,
      l10n.aiSuggestTopStore,
      l10n.aiSuggestAnalyzeSpending,
      l10n.aiSuggestShoppingListPriority,
    ];

    return List<_SuggestionItem>.generate(
      _suggestionTemplates.length,
      (int index) => _SuggestionItem(
        question: questions[index],
        icon: _suggestionTemplates[index].icon,
        accent: _suggestionTemplates[index].accent,
      ),
    );
  }

  final TextEditingController _questionController = TextEditingController();
  final FocusNode _questionFocus = FocusNode();

  final SubscriptionService _subscriptionService = SubscriptionService();
  static const FeatureAccessService _featureAccessService =
      FeatureAccessService();

  SubscriptionStatus _subscription = SubscriptionStatus.free;
  bool _isLoadingSubscription = true;
  DebugSubscriptionOverrideStore? _debugOverrideStore;

  AiAssistantResponse? _lastResponse;
  String? _lastQuestion;
  bool _isAsking = false;
  String? _askError;

  @override
  void initState() {
    super.initState();
    _loadSubscription();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!kDebugMode) {
      return;
    }
    final DebugSubscriptionOverrideStore? store =
        DebugSubscriptionOverrideProvider.maybeOf(context);
    if (store == _debugOverrideStore) {
      return;
    }
    _debugOverrideStore?.removeListener(_onDebugOverrideChanged);
    _debugOverrideStore = store;
    _debugOverrideStore?.addListener(_onDebugOverrideChanged);
  }

  @override
  void dispose() {
    _debugOverrideStore?.removeListener(_onDebugOverrideChanged);
    _questionController.dispose();
    _questionFocus.unfocus();
    _questionFocus.dispose();
    super.dispose();
  }

  void _goBack() {
    if (context.canPop()) {
      context.pop();
    } else {
      context.go('/deals');
    }
  }

  void _onDebugOverrideChanged() {
    _loadSubscription();
  }

  Future<void> _loadSubscription() async {
    try {
      final SubscriptionStatus status =
          await _subscriptionService.getCurrentSubscription();
      if (!mounted) return;
      setState(() {
        _subscription = status;
        _isLoadingSubscription = false;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() => _isLoadingSubscription = false);
    }
  }

  Future<void> _openPlans() async {
    await context.push('/subscription');
    if (mounted) {
      await _loadSubscription();
    }
  }

  bool _isFirestoreLoading(
    ExpensesStore expensesStore,
    ReceiptStore receiptStore,
    ShoppingListsStore shoppingListsStore,
  ) {
    return expensesStore.isLoading ||
        receiptStore.isLoading ||
        shoppingListsStore.isLoadingLists;
  }

  AiSavingsContext _buildContext() {
    return AiContextBuilder.fromStores(
      expensesStore: ExpensesProvider.of(context),
      receiptStore: ReceiptProvider.of(context),
      shoppingListsStore: ShoppingListsProvider.of(context),
    );
  }

  Future<void> _askQuestion(String question) async {
    final String trimmed = question.trim();
    if (trimmed.isEmpty || _isAsking) return;

    final AiSavingsAssistantService service =
        AiSavingsAssistantProvider.of(context);
    final AiSavingsContext contextSnapshot = _buildContext();

    if (!contextSnapshot.hasData) return;

    if (!service.isConfigured) {
      setState(() {
        _askError = AiAssistantL10n.localizeException(
          context,
          AiAssistantException.missingApiKey,
        );
        _lastResponse = null;
        _lastQuestion = trimmed;
      });
      return;
    }

    setState(() {
      _isAsking = true;
      _askError = null;
      _lastQuestion = trimmed;
      _lastResponse = null;
    });
    _questionController.clear();
    _questionFocus.unfocus();

    try {
      final AiAssistantResponse response = await service.ask(
        AiAssistantRequest(
          question: trimmed,
          context: contextSnapshot,
          responseLanguageCode: Localizations.localeOf(context).languageCode,
        ),
      );

      if (!mounted) return;
      setState(() {
        _lastResponse = response;
        _isAsking = false;
      });
    } on AiAssistantException catch (error) {
      if (!mounted) return;
      setState(() {
        _askError = AiAssistantL10n.localizeException(context, error);
        _isAsking = false;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _askError = AppLocalizations.of(context).aiCouldNotGetAnswer;
        _isAsking = false;
      });
    }
  }

  void _retryStores() {
    final ExpensesStore expensesStore = ExpensesProvider.of(context);
    final ReceiptStore receiptStore = ReceiptProvider.of(context);
    final ShoppingListsStore shoppingListsStore =
        ShoppingListsProvider.of(context);

    if (expensesStore.loadError != null) {
      expensesStore.retry();
    }
    if (receiptStore.loadError != null) {
      receiptStore.retry();
    }
    if (shoppingListsStore.listsError != null) {
      shoppingListsStore.retryLists();
    }
  }

  @override
  Widget build(BuildContext context) {
    final ExpensesStore expensesStore = ExpensesProvider.of(context);
    final AppLocalizations l10n = AppLocalizations.of(context);
    final double bottomInset = MediaQuery.paddingOf(context).bottom;

    return Scaffold(
      backgroundColor: context.savingor.pageBackground,
      appBar: AppBar(
        title: Text(
          l10n.aiSavingsAssistant,
          style: SavingorAppTextStyles.screenTitle(context),
        ),
        elevation: 0,
        scrolledUnderElevation: 0,
        backgroundColor: context.savingor.pageBackground,
        surfaceTintColor: Colors.transparent,
        leading: BackButton(
          color: context.savingor.brandTitle,
          onPressed: _goBack,
        ),
        automaticallyImplyLeading: false,
      ),
      body: _buildScreenBody(
        l10n: l10n,
        expensesStore: expensesStore,
        bottomInset: bottomInset,
      ),
    );
  }

  Widget _buildScreenBody({
    required AppLocalizations l10n,
    required ExpensesStore expensesStore,
    required double bottomInset,
  }) {
    if (!expensesStore.isAuthenticated) {
      return AppSignInRequiredState(
        title: l10n.signInRequired,
        message: l10n.aiSignInPrompt,
        actionLabel: l10n.signIn,
        onSignIn: () => context.push('/auth'),
      );
    }

    if (_isLoadingSubscription) {
      return const Center(
        child: CircularProgressIndicator(
          color: SavingorColors.primaryStroke,
        ),
      );
    }

    return FeatureAccessGate(
      feature: SavingorFeature.aiSavingsAssistant,
      isPro: _subscription.hasActiveProAccess,
      accessService: _featureAccessService,
      lockedBuilder: (BuildContext context) {
        return AiSavingsAssistantLockedPreview(
          bottomInset: bottomInset,
          onOpenPlans: _openPlans,
        );
      },
      child: _buildProAssistantBody(
        l10n: l10n,
        expensesStore: expensesStore,
        bottomInset: bottomInset,
      ),
    );
  }

  Widget _buildProAssistantBody({
    required AppLocalizations l10n,
    required ExpensesStore expensesStore,
    required double bottomInset,
  }) {
    final ReceiptStore receiptStore = ReceiptProvider.of(context);
    final ShoppingListsStore shoppingListsStore =
        ShoppingListsProvider.of(context);
    final AiSavingsAssistantService service =
        AiSavingsAssistantProvider.of(context);

    return ListenableBuilder(
      listenable: Listenable.merge(<Listenable>[
        expensesStore,
        receiptStore,
        shoppingListsStore,
      ]),
      builder: (BuildContext context, Widget? _) {
        return _buildBody(
          l10n: l10n,
          expensesStore: expensesStore,
          receiptStore: receiptStore,
          shoppingListsStore: shoppingListsStore,
          service: service,
          bottomInset: bottomInset,
        );
      },
    );
  }

  Widget _buildBody({
    required AppLocalizations l10n,
    required ExpensesStore expensesStore,
    required ReceiptStore receiptStore,
    required ShoppingListsStore shoppingListsStore,
    required AiSavingsAssistantService service,
    required double bottomInset,
  }) {
    if (!expensesStore.isAuthenticated) {
      return AppSignInRequiredState(
        title: l10n.signInRequired,
        message: l10n.aiSignInPrompt,
        actionLabel: l10n.signIn,
        onSignIn: () => context.push('/auth'),
      );
    }

    if (_isFirestoreLoading(expensesStore, receiptStore, shoppingListsStore)) {
      return AppLoadingState(message: l10n.aiLoadingYourData);
    }

    if (expensesStore.loadError != null ||
        receiptStore.loadError != null ||
        shoppingListsStore.listsError != null) {
      final String message = expensesStore.loadError ??
          receiptStore.loadError ??
          shoppingListsStore.listsError ??
          l10n.somethingWentWrong;
      return AppErrorState(
        title: l10n.aiCouldNotLoadData,
        message: message,
        actionLabel: l10n.tryAgain,
        onRetry: _retryStores,
      );
    }

    final AiSavingsContext contextSnapshot = _buildContext();

    if (!contextSnapshot.hasData) {
      return AppEmptyState(
        icon: Icons.auto_awesome_outlined,
        title: l10n.aiEmptyTitle,
        message: l10n.aiEmptyMessage,
        actionLabel: l10n.scanReceipt,
        onAction: () => context.push('/scanner/create'),
        prominentAction: true,
      );
    }

    final bool canSend = !_isAsking;
    final bool isLive = service.isConfigured;
    final List<_SuggestionItem> suggestedQuestions =
        _buildSuggestedQuestions(l10n);

    return Column(
      children: <Widget>[
        Expanded(
          child: ListView(
            padding: const EdgeInsets.fromLTRB(20, 8, 20, 16),
            children: <Widget>[
              _buildHeaderBanner(l10n: l10n, isLive: isLive),
              if (!service.isConfigured) ...<Widget>[
                const SizedBox(height: SavingorSpacing.lg),
                _buildConfigInfoCard(l10n),
              ],
              const SizedBox(height: SavingorSpacing.lg),
              _buildContextSummary(l10n, contextSnapshot),
              const SizedBox(height: SavingorSpacing.xl),
              Text(
                l10n.aiSuggestedQuestions,
                style: SavingorAppTextStyles.sectionTitle(context),
              ),
              const SizedBox(height: 12),
              Wrap(
                spacing: 10,
                runSpacing: 10,
                children: suggestedQuestions
                    .map(
                      (_SuggestionItem item) => _SuggestionChip(
                        label: item.question,
                        icon: item.icon,
                        accent: item.accent,
                        onTap:
                            canSend ? () => _askQuestion(item.question) : null,
                      ),
                    )
                    .toList(),
              ),
              if (_isAsking) ...<Widget>[
                const SizedBox(height: SavingorSpacing.xl),
                AppLoadingState(message: l10n.aiAnalyzingYourData),
              ],
              if (_askError != null) ...<Widget>[
                const SizedBox(height: SavingorSpacing.xl),
                _buildErrorCard(_askError!),
              ],
              if (_lastResponse != null && !_isAsking) ...<Widget>[
                const SizedBox(height: SavingorSpacing.xl),
                _buildResponseCard(
                  question: _lastQuestion ?? '',
                  response: _lastResponse!,
                ),
              ],
              const SizedBox(height: SavingorSpacing.lg),
              Text(
                l10n.aiInsightsDisclaimer,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: context.savingor.textSecondary.withOpacity(0.9),
                  height: 1.4,
                ),
              ),
            ],
          ),
        ),
        _buildInputBar(
          l10n: l10n,
          canSend: canSend,
          isLive: isLive,
          bottomInset: bottomInset,
        ),
      ],
    );
  }

  Widget _buildHeaderBanner({
    required AppLocalizations l10n,
    required bool isLive,
  }) {
    final SavingorThemeExtension theme = context.savingor;

    return ClipRRect(
      borderRadius: BorderRadius.circular(22),
      child: Stack(
        children: <Widget>[
          Container(
            padding: const EdgeInsets.all(20),
            decoration: theme.isDark
                ? BoxDecoration(
                    color: theme.surfaceStrong,
                    border: Border.all(color: theme.border, width: 0.75),
                    boxShadow: theme.cardShadow,
                  )
                : const BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: <Color>[
                        Color(0xFFF6FBF8),
                        Color(0xFFF0F9F4),
                        Color(0xFFFBF9F4),
                        Color(0xFFFAFAF7),
                      ],
                      stops: <double>[0.0, 0.42, 0.72, 1.0],
                    ),
                    border: Border.fromBorderSide(
                      BorderSide(
                        color: Color(0x244F9D47),
                        width: 0.75,
                      ),
                    ),
                    boxShadow: <BoxShadow>[
                      BoxShadow(
                        color: Color(0x0A4F9D47),
                        blurRadius: 16,
                        offset: Offset(0, 4),
                      ),
                      BoxShadow(
                        color: Color(0x06000000),
                        blurRadius: 8,
                        offset: Offset(0, 2),
                      ),
                    ],
                  ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                SizedBox(
                  width: 58,
                  height: 58,
                  child: Stack(
                    clipBehavior: Clip.none,
                    children: <Widget>[
                      Container(
                        width: 58,
                        height: 58,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: context.savingor.surfacePrimary,
                          border: Border.all(
                            color:
                                SavingorColors.primaryStroke.withOpacity(0.2),
                            width: 1,
                          ),
                          boxShadow: const <BoxShadow>[
                            BoxShadow(
                              color: Color(0x0F4F9D47),
                              blurRadius: 10,
                              offset: Offset(0, 3),
                            ),
                          ],
                        ),
                        child: Icon(
                          Icons.auto_awesome_outlined,
                          color: theme.brandTitle,
                          size: 26,
                        ),
                      ),
                      Positioned(
                        top: 1,
                        right: 1,
                        child: Container(
                          width: 9,
                          height: 9,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: _accentList.withOpacity(0.75),
                            border: Border.all(
                                color: context.savingor.surfacePrimary,
                                width: 1.5),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        l10n.aiHeroTitle,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w800,
                          color: theme.textPrimary,
                          height: 1.2,
                          letterSpacing: -0.2,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        isLive
                            ? l10n.aiHeroSubtitleLive
                            : l10n.aiHeroSubtitlePreview,
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                          color: theme.textSecondary,
                          height: 1.4,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Positioned.fill(
            child: IgnorePointer(
              child: CustomPaint(
                painter: _AiHeroSparklePainter(
                  sparkleColor: SavingorColors.primaryStroke.withOpacity(0.07),
                  dotColor: _chipAmber.withOpacity(0.12),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildConfigInfoCard(AppLocalizations l10n) {
    final SavingorThemeExtension theme = context.savingor;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.warningSurface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: _infoAmber.withOpacity(theme.isDark ? 0.35 : 0.28),
          width: 0.75,
        ),
        boxShadow: theme.cardShadow,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Icon(
            Icons.lightbulb_outline_rounded,
            color: theme.warning,
            size: 22,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              l10n.aiConfigReadyMessage,
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: theme.textPrimary,
                height: 1.45,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContextSummary(
    AppLocalizations l10n,
    AiSavingsContext contextSnapshot,
  ) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: SavingorSurfaces.premiumCard(context, radius: 18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            l10n.aiDataSnapshot,
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w800,
              color: context.savingor.textPrimary,
            ),
          ),
          const SizedBox(height: 14),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: <Widget>[
              if (contextSnapshot.hasReceipts)
                _SummaryChip(
                  icon: Icons.receipt_long_outlined,
                  label: l10n.aiReceiptCount(contextSnapshot.receiptCount),
                  accent: _chipTeal,
                ),
              if (contextSnapshot.hasManualExpenses)
                _SummaryChip(
                  icon: Icons.payments_outlined,
                  label:
                      l10n.aiExpenseCount(contextSnapshot.manualExpenseCount),
                  accent: _chipBlue,
                ),
              if (contextSnapshot.totalSpending > 0)
                _SummaryChip(
                  icon: Icons.account_balance_wallet_outlined,
                  label: l10n.aiTotalSpendingLabel(
                    '\$${contextSnapshot.totalSpending.toStringAsFixed(0)}',
                  ),
                  accent: _accentSavings,
                ),
              if (contextSnapshot.hasShoppingLists)
                _SummaryChip(
                  icon: Icons.checklist_outlined,
                  label: l10n.aiListCount(contextSnapshot.shoppingListCount),
                  accent: _chipAmber,
                ),
              if (contextSnapshot.activeListEstimate > 0)
                _SummaryChip(
                  icon: Icons.shopping_cart_outlined,
                  label: l10n.aiListEstimateLabel(
                    '\$${contextSnapshot.activeListEstimate.toStringAsFixed(0)}',
                  ),
                  accent: _accentStore,
                ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildErrorCard(String message) {
    final SavingorThemeExtension theme = context.savingor;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.errorSurface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: theme.error.withOpacity(0.45)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Icon(Icons.error_outline, color: theme.error, size: 22),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              message,
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w500,
                color: theme.textPrimary,
                height: 1.4,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildResponseCard({
    required String question,
    required AiAssistantResponse response,
  }) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: SavingorSurfaces.premiumCard(context, radius: 18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          if (question.isNotEmpty) ...<Widget>[
            Text(
              question,
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: context.savingor.textSecondary.withOpacity(0.85),
                height: 1.35,
              ),
            ),
            const SizedBox(height: 12),
          ],
          Text(
            response.answer,
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w500,
              color: context.savingor.textPrimary,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInputBar({
    required AppLocalizations l10n,
    required bool canSend,
    required bool isLive,
    required double bottomInset,
  }) {
    return Container(
      padding: EdgeInsets.fromLTRB(16, 12, 16, 12 + bottomInset),
      decoration: BoxDecoration(
        color: context.savingor.surfaceElevated,
        border: Border(
          top: BorderSide(color: context.savingor.border),
        ),
        boxShadow: context.savingor.cardShadow,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: <Widget>[
          Expanded(
            child: TextField(
              controller: _questionController,
              focusNode: _questionFocus,
              enabled: canSend,
              maxLines: 3,
              minLines: 1,
              textInputAction: TextInputAction.send,
              onSubmitted: canSend ? _askQuestion : null,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: context.savingor.textPrimary,
              ),
              decoration: InputDecoration(
                hintText:
                    isLive ? l10n.aiInputHintLive : l10n.aiInputHintPreview,
                hintStyle: TextStyle(
                  color: context.savingor.textMuted,
                  fontSize: 14,
                ),
                filled: true,
                fillColor: context.savingor.inputFill,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 13,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide.none,
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide(color: context.savingor.border),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide(
                    color: context.savingor.accentGreen.withOpacity(0.55),
                    width: 1.25,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(width: 10),
          Semantics(
            button: true,
            label: l10n.aiSend,
            child: Material(
              color: canSend
                  ? context.savingor.accentGreen
                  : context.savingor.accentGreen.withOpacity(0.45),
              borderRadius: BorderRadius.circular(14),
              elevation: 0,
              child: InkWell(
                onTap: canSend
                    ? () => _askQuestion(_questionController.text)
                    : null,
                borderRadius: BorderRadius.circular(14),
                child: Ink(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(
                      color: context.savingor.accentGreen.withOpacity(
                        canSend ? 0.35 : 0.18,
                      ),
                      width: 0.75,
                    ),
                  ),
                  child: SizedBox(
                    width: 48,
                    height: 48,
                    child: Icon(
                      Icons.send_rounded,
                      color: canSend
                          ? context.savingor.buttonLabelOnGreen
                          : context.savingor.buttonLabelOnGreen
                              .withOpacity(0.45),
                      size: 22,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SuggestionTemplate {
  const _SuggestionTemplate({
    required this.icon,
    required this.accent,
  });

  final IconData icon;
  final Color accent;
}

class _SuggestionItem {
  const _SuggestionItem({
    required this.question,
    required this.icon,
    required this.accent,
  });

  final String question;
  final IconData icon;
  final Color accent;
}

class _SuggestionChip extends StatelessWidget {
  const _SuggestionChip({
    required this.label,
    required this.icon,
    required this.accent,
    required this.onTap,
  });

  static const Color _cardBorder = Color(0xFFE5E7EB);

  final String label;
  final IconData icon;
  final Color accent;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final double maxChipWidth = MediaQuery.sizeOf(context).width - 48;

    final SavingorThemeExtension theme = context.savingor;

    return Material(
      color: theme.surfaceElevated,
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        splashColor: accent.withOpacity(0.08),
        highlightColor: accent.withOpacity(0.04),
        child: Ink(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            color: theme.isDark ? theme.surfaceElevated : theme.surfacePrimary,
            border: Border.all(
              color: theme.isDark
                  ? accent.withOpacity(0.35)
                  : _cardBorder.withOpacity(0.9),
              width: 0.75,
            ),
            boxShadow: theme.cardShadow,
          ),
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 13),
          child: SizedBox(
            width: maxChipWidth,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                  width: 4,
                  height: 32,
                  decoration: BoxDecoration(
                    color: accent.withOpacity(0.82),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                const SizedBox(width: 12),
                Padding(
                  padding: const EdgeInsets.only(top: 2),
                  child: Icon(icon, size: 19, color: accent.withOpacity(0.9)),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    label,
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: context.savingor.textPrimary,
                      height: 1.35,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _SummaryChip extends StatelessWidget {
  const _SummaryChip({
    required this.icon,
    required this.label,
    required this.accent,
  });

  final IconData icon;
  final String label;
  final Color accent;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 8),
      decoration: BoxDecoration(
        color: accent.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: accent.withOpacity(0.22),
          width: 0.75,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Icon(icon, size: 15, color: accent.withOpacity(0.92)),
          const SizedBox(width: 6),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w700,
              color: context.savingor.textPrimary,
            ),
          ),
        ],
      ),
    );
  }
}

class _AiHeroSparklePainter extends CustomPainter {
  _AiHeroSparklePainter({
    required this.sparkleColor,
    required this.dotColor,
  });

  final Color sparkleColor;
  final Color dotColor;

  @override
  void paint(Canvas canvas, Size size) {
    final Paint sparklePaint = Paint()..color = sparkleColor;
    final Paint dotPaint = Paint()..color = dotColor;

    final List<Offset> sparkles = <Offset>[
      Offset(size.width * 0.78, size.height * 0.18),
      Offset(size.width * 0.88, size.height * 0.42),
      Offset(size.width * 0.72, size.height * 0.68),
    ];
    for (final Offset point in sparkles) {
      _drawSparkle(canvas, point, 5, sparklePaint);
    }

    final List<Offset> dots = <Offset>[
      Offset(size.width * 0.62, size.height * 0.22),
      Offset(size.width * 0.92, size.height * 0.28),
      Offset(size.width * 0.55, size.height * 0.55),
      Offset(size.width * 0.85, size.height * 0.78),
    ];
    for (final Offset point in dots) {
      canvas.drawCircle(point, 2, dotPaint);
    }
  }

  void _drawSparkle(Canvas canvas, Offset center, double radius, Paint paint) {
    final Path path = Path();
    for (int i = 0; i < 8; i++) {
      final double angle = i * 3.1415926535 / 4;
      final double r = i.isEven ? radius : radius * 0.4;
      final Offset point = Offset(
        center.dx + r * math.cos(angle),
        center.dy + r * math.sin(angle),
      );
      if (i == 0) {
        path.moveTo(point.dx, point.dy);
      } else {
        path.lineTo(point.dx, point.dy);
      }
    }
    path.close();
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant _AiHeroSparklePainter oldDelegate) {
    return oldDelegate.sparkleColor != sparkleColor ||
        oldDelegate.dotColor != dotColor;
  }
}
