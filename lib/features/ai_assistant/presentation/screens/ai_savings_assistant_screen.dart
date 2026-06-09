import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:savingor_app/core/theme/savingor_design_system.dart';
import 'package:savingor_app/core/widgets/app_screen_states.dart';
import 'package:savingor_app/features/ai_assistant/data/ai_context_builder.dart';
import 'package:savingor_app/features/ai_assistant/data/ai_savings_assistant_provider.dart';
import 'package:savingor_app/features/ai_assistant/domain/ai_assistant_exception.dart';
import 'package:savingor_app/features/ai_assistant/domain/ai_savings_assistant_service.dart';
import 'package:savingor_app/features/ai_assistant/domain/ai_savings_context.dart';
import 'package:savingor_app/features/ai_assistant/domain/models/ai_assistant_request.dart';
import 'package:savingor_app/features/ai_assistant/domain/models/ai_assistant_response.dart';
import 'package:savingor_app/features/expenses/data/expenses_store.dart';
import 'package:savingor_app/features/scanner/data/receipt_store.dart';
import 'package:savingor_app/features/shopping/data/shopping_lists_store.dart';

class AiSavingsAssistantScreen extends StatefulWidget {
  const AiSavingsAssistantScreen({super.key});

  @override
  State<AiSavingsAssistantScreen> createState() =>
      _AiSavingsAssistantScreenState();
}

class _AiSavingsAssistantScreenState extends State<AiSavingsAssistantScreen> {
  static const Color _pageBackground = Color(0xFFFAFAF7);
  static const Color _airyBorder = Color(0xFFE5E7EB);
  static const Color _titleCharcoal = Color(0xFF1F2937);
  static const Color _mutedText = Color(0xFF6B7280);
  static const Color _deepGreen = Color(0xFF166534);
  static const Color _sendGreen = Color(0xFF7BC96E);
  static const Color _sendGreenStroke = Color(0xFF4F9D47);

  // Tasteful accent families for chips and question cards.
  static const Color _accentSavings = Color(0xFF4F9D47);
  static const Color _accentStore = Color(0xFF0F766E);
  static const Color _accentAnalysis = Color(0xFFB45309);
  static const Color _accentList = Color(0xFF7C6B9E);
  static const Color _chipTeal = Color(0xFF0D9488);
  static const Color _chipBlue = Color(0xFF4B6B9E);
  static const Color _chipAmber = Color(0xFFCA8A04);
  static const Color _infoAmber = Color(0xFFD97706);

  static const List<_SuggestionItem> _suggestedQuestions = <_SuggestionItem>[
    _SuggestionItem(
      question: 'How can I save more money this week?',
      icon: Icons.savings_outlined,
      accent: _accentSavings,
    ),
    _SuggestionItem(
      question: 'Which store do I spend the most at?',
      icon: Icons.storefront_outlined,
      accent: _accentStore,
    ),
    _SuggestionItem(
      question: 'Analyze my grocery spending.',
      icon: Icons.pie_chart_outline_rounded,
      accent: _accentAnalysis,
    ),
    _SuggestionItem(
      question: 'What should I buy first from my shopping list?',
      icon: Icons.checklist_outlined,
      accent: _accentList,
    ),
  ];

  final TextEditingController _questionController = TextEditingController();
  final FocusNode _questionFocus = FocusNode();

  AiAssistantResponse? _lastResponse;
  String? _lastQuestion;
  bool _isAsking = false;
  String? _askError;

  @override
  void dispose() {
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
        _askError = AiAssistantException.missingApiKey.message;
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
        _askError = error.message;
        _isAsking = false;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _askError = 'Could not get an answer. Please try again.';
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
    final ReceiptStore receiptStore = ReceiptProvider.of(context);
    final ShoppingListsStore shoppingListsStore =
        ShoppingListsProvider.of(context);
    final AiSavingsAssistantService service =
        AiSavingsAssistantProvider.of(context);
    final double bottomInset = MediaQuery.paddingOf(context).bottom;

    return ListenableBuilder(
      listenable: Listenable.merge(<Listenable>[
        expensesStore,
        receiptStore,
        shoppingListsStore,
      ]),
      builder: (BuildContext context, Widget? _) {
        return Scaffold(
          backgroundColor: _pageBackground,
          appBar: AppBar(
            title: const Text(
              'AI Savings Assistant',
              style: SavingorAppTextStyles.screenTitle,
            ),
            elevation: 0,
            scrolledUnderElevation: 0,
            backgroundColor: _pageBackground,
            surfaceTintColor: Colors.transparent,
            leading: BackButton(
              color: _deepGreen,
              onPressed: _goBack,
            ),
            automaticallyImplyLeading: false,
          ),
          body: _buildBody(
            expensesStore: expensesStore,
            receiptStore: receiptStore,
            shoppingListsStore: shoppingListsStore,
            service: service,
            bottomInset: bottomInset,
          ),
        );
      },
    );
  }

  Widget _buildBody({
    required ExpensesStore expensesStore,
    required ReceiptStore receiptStore,
    required ShoppingListsStore shoppingListsStore,
    required AiSavingsAssistantService service,
    required double bottomInset,
  }) {
    if (!expensesStore.isAuthenticated) {
      return AppSignInRequiredState(
        message:
            'Sign in to ask the AI assistant about your receipts and shopping lists.',
        onSignIn: () => context.push('/auth'),
      );
    }

    if (_isFirestoreLoading(expensesStore, receiptStore, shoppingListsStore)) {
      return const AppLoadingState(message: 'Loading your data…');
    }

    if (expensesStore.loadError != null ||
        receiptStore.loadError != null ||
        shoppingListsStore.listsError != null) {
      final String message = expensesStore.loadError ??
          receiptStore.loadError ??
          shoppingListsStore.listsError ??
          'Something went wrong.';
      return AppErrorState(
        title: 'Could not load your data',
        message: message,
        onRetry: _retryStores,
      );
    }

    final AiSavingsContext contextSnapshot = _buildContext();

    if (!contextSnapshot.hasData) {
      return AppEmptyState(
        icon: Icons.auto_awesome_outlined,
        title: 'Add data to get AI insights',
        message:
            'Scan a receipt, add an expense, or create a shopping list. '
            'The assistant analyzes your saved data — not live store prices.',
        actionLabel: 'Scan a receipt',
        onAction: () => context.push('/scanner/create'),
        prominentAction: true,
      );
    }

    final bool canSend = !_isAsking;
    final bool isLive = service.isConfigured;

    return Column(
      children: <Widget>[
        Expanded(
          child: ListView(
            padding: const EdgeInsets.fromLTRB(20, 8, 20, 16),
            children: <Widget>[
              _buildHeaderBanner(isLive: isLive),
              if (!service.isConfigured) ...<Widget>[
                const SizedBox(height: SavingorSpacing.lg),
                _buildConfigInfoCard(),
              ],
              const SizedBox(height: SavingorSpacing.lg),
              _buildContextSummary(contextSnapshot),
              const SizedBox(height: SavingorSpacing.xl),
              const Text(
                'Suggested questions',
                style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w700,
                  color: _titleCharcoal,
                ),
              ),
              const SizedBox(height: 12),
              Wrap(
                spacing: 10,
                runSpacing: 10,
                children: _suggestedQuestions
                    .map(
                      (_SuggestionItem item) => _SuggestionChip(
                        label: item.question,
                        icon: item.icon,
                        accent: item.accent,
                        onTap: canSend ? () => _askQuestion(item.question) : null,
                      ),
                    )
                    .toList(),
              ),
              if (_isAsking) ...<Widget>[
                const SizedBox(height: SavingorSpacing.xl),
                const AppLoadingState(message: 'Analyzing your data…'),
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
                'Insights are based on your saved receipts, expenses, and '
                'shopping lists in Savingor — not live store prices or deals.',
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
        ),
        _buildInputBar(
          canSend: canSend,
          isLive: isLive,
          bottomInset: bottomInset,
        ),
      ],
    );
  }

  Widget _buildHeaderBanner({required bool isLive}) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(22),
      child: Stack(
        children: <Widget>[
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
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
              border: Border.all(
                color: SavingorColors.primaryStroke.withOpacity(0.14),
                width: 0.75,
              ),
              boxShadow: const <BoxShadow>[
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
                          color: Colors.white,
                          border: Border.all(
                            color: SavingorColors.primaryStroke.withOpacity(0.2),
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
                        child: const Icon(
                          Icons.auto_awesome_outlined,
                          color: SavingorColors.primaryStroke,
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
                            border: Border.all(color: Colors.white, width: 1.5),
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
                      const Text(
                        'Your AI savings coach',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w800,
                          color: _deepGreen,
                          height: 1.2,
                          letterSpacing: -0.2,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        isLive
                            ? 'Ask about spending, receipts, and shopping lists.'
                            : 'Preview insights from your saved data — connect an API key for live answers.',
                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                          color: _mutedText,
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

  Widget _buildConfigInfoCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFFFFAF3),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: _infoAmber.withOpacity(0.28),
          width: 0.75,
        ),
        boxShadow: const <BoxShadow>[
          BoxShadow(
            color: Color(0x08CA8A04),
            blurRadius: 10,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: const Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Icon(
            Icons.lightbulb_outline_rounded,
            color: _infoAmber,
            size: 22,
          ),
          SizedBox(width: 12),
          Expanded(
            child: Text(
              'AI assistant is ready. Connect an API key to enable live answers.',
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: _titleCharcoal,
                height: 1.45,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContextSummary(AiSavingsContext contextSnapshot) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: _airyBorder, width: 0.75),
        boxShadow: const <BoxShadow>[
          BoxShadow(
            color: Color(0x10000000),
            blurRadius: 14,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          const Text(
            'Your data snapshot',
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w800,
              color: _titleCharcoal,
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
                  label: '${contextSnapshot.receiptCount} receipts',
                  accent: _chipTeal,
                ),
              if (contextSnapshot.hasManualExpenses)
                _SummaryChip(
                  icon: Icons.payments_outlined,
                  label: '${contextSnapshot.manualExpenseCount} expenses',
                  accent: _chipBlue,
                ),
              if (contextSnapshot.totalSpending > 0)
                _SummaryChip(
                  icon: Icons.account_balance_wallet_outlined,
                  label:
                      '\$${contextSnapshot.totalSpending.toStringAsFixed(0)} total',
                  accent: _accentSavings,
                ),
              if (contextSnapshot.hasShoppingLists)
                _SummaryChip(
                  icon: Icons.checklist_outlined,
                  label: '${contextSnapshot.shoppingListCount} lists',
                  accent: _chipAmber,
                ),
              if (contextSnapshot.activeListEstimate > 0)
                _SummaryChip(
                  icon: Icons.shopping_cart_outlined,
                  label:
                      '\$${contextSnapshot.activeListEstimate.toStringAsFixed(0)} list est.',
                  accent: _accentStore,
                ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildErrorCard(String message) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF5F5),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE8B4B4)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          const Icon(Icons.error_outline, color: Color(0xFFC45A5A), size: 22),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              message,
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w500,
                color: Color(0xFF991B1B),
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
      decoration: SavingorSurfaces.premiumCard(radius: 18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          if (question.isNotEmpty) ...<Widget>[
            Text(
              question,
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: SavingorColors.textSecondary.withOpacity(0.85),
                height: 1.35,
              ),
            ),
            const SizedBox(height: 12),
          ],
          Text(
            response.answer,
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w500,
              color: SavingorColors.textPrimary,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInputBar({
    required bool canSend,
    required bool isLive,
    required double bottomInset,
  }) {
    return Container(
      padding: EdgeInsets.fromLTRB(16, 12, 16, 12 + bottomInset),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: _airyBorder.withOpacity(0.8))),
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 8,
            offset: const Offset(0, -2),
          ),
        ],
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
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: _titleCharcoal,
                ),
                decoration: InputDecoration(
                  hintText: isLive
                      ? 'Ask about your spending or shopping list…'
                      : 'Type a question — connect an API key for live answers',
                  hintStyle: const TextStyle(
                    color: _mutedText,
                    fontSize: 14,
                  ),
                  filled: true,
                  fillColor: Colors.white,
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
                    borderSide: const BorderSide(color: _airyBorder),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: BorderSide(
                      color: _sendGreenStroke.withOpacity(0.45),
                      width: 1.25,
                    ),
                  ),
                ),
              ),
          ),
          const SizedBox(width: 10),
          Material(
            color: canSend ? _sendGreen : _sendGreen.withOpacity(0.45),
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
                    color: _sendGreenStroke.withOpacity(canSend ? 0.32 : 0.18),
                    width: 0.75,
                  ),
                  boxShadow: canSend
                      ? const <BoxShadow>[
                          BoxShadow(
                            color: Color(0x144F9D47),
                            blurRadius: 8,
                            offset: Offset(0, 2),
                          ),
                        ]
                      : null,
                ),
                child: SizedBox(
                  width: 48,
                  height: 48,
                  child: Icon(
                    Icons.send_rounded,
                    color: canSend
                        ? _deepGreen
                        : _deepGreen.withOpacity(0.45),
                    size: 22,
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

    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        splashColor: accent.withOpacity(0.08),
        highlightColor: accent.withOpacity(0.04),
        child: Ink(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            color: const Color(0xFFFFFEFE),
            border: Border.all(
              color: _cardBorder.withOpacity(0.9),
              width: 0.75,
            ),
            boxShadow: const <BoxShadow>[
              BoxShadow(
                color: Color(0x06000000),
                blurRadius: 6,
                offset: Offset(0, 2),
              ),
            ],
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
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF1F2937),
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
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w700,
              color: Color(0xFF1F2937),
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
