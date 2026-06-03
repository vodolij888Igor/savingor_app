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
  static const Color _pageBackground = Colors.white;
  static const Color _airyBorder = Color(0xFFF3F4F3);

  static const List<String> _suggestedQuestions = <String>[
    'How can I save more money this week?',
    'Which store do I spend the most at?',
    'Analyze my grocery spending.',
    'What should I buy first from my shopping list?',
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

    final bool canAsk = service.isConfigured && !_isAsking;

    return Column(
      children: <Widget>[
        Expanded(
          child: ListView(
            padding: const EdgeInsets.fromLTRB(20, 8, 20, 16),
            children: <Widget>[
              _buildHeaderBanner(),
              if (!service.isConfigured) ...<Widget>[
                const SizedBox(height: SavingorSpacing.lg),
                _buildConfigErrorCard(),
              ],
              const SizedBox(height: SavingorSpacing.lg),
              _buildContextSummary(contextSnapshot),
              const SizedBox(height: SavingorSpacing.xl),
              const Text(
                'Suggested questions',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                  color: SavingorColors.darkGreen,
                ),
              ),
              const SizedBox(height: 10),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: _suggestedQuestions
                    .map(
                      (String question) => _SuggestionChip(
                        label: question,
                        enabled: canAsk,
                        onTap: () => _askQuestion(question),
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
        _buildInputBar(canAsk: canAsk, bottomInset: bottomInset),
      ],
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
              'Ask about your spending, receipts, and shopping lists.',
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

  Widget _buildConfigErrorCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF8F0),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE8C9A0)),
      ),
      child: const Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Icon(
            Icons.key_off_outlined,
            color: Color(0xFFC4895A),
            size: 22,
          ),
          SizedBox(width: 12),
          Expanded(
            child: Text(
              'OpenAI API key is not configured.\n'
              'Run with:\n'
              'flutter run --dart-define=OPENAI_API_KEY=your_key',
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w500,
                color: SavingorColors.darkGreen,
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
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: _airyBorder, width: 0.5),
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          const Text(
            'Your data snapshot',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w700,
              color: SavingorColors.darkGreen,
            ),
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: <Widget>[
              if (contextSnapshot.hasReceipts)
                _SummaryChip(
                  icon: Icons.receipt_long_outlined,
                  label: '${contextSnapshot.receiptCount} receipts',
                ),
              if (contextSnapshot.hasManualExpenses)
                _SummaryChip(
                  icon: Icons.payments_outlined,
                  label: '${contextSnapshot.manualExpenseCount} expenses',
                ),
              if (contextSnapshot.totalSpending > 0)
                _SummaryChip(
                  icon: Icons.account_balance_wallet_outlined,
                  label:
                      '\$${contextSnapshot.totalSpending.toStringAsFixed(0)} total',
                ),
              if (contextSnapshot.hasShoppingLists)
                _SummaryChip(
                  icon: Icons.checklist_rounded,
                  label: '${contextSnapshot.shoppingListCount} lists',
                ),
              if (contextSnapshot.activeListEstimate > 0)
                _SummaryChip(
                  icon: Icons.shopping_cart_outlined,
                  label:
                      '\$${contextSnapshot.activeListEstimate.toStringAsFixed(0)} list est.',
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
                color: SavingorColors.darkGreen,
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
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: SavingorColors.lightGreen.withOpacity(0.6),
          width: 1,
        ),
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: SavingorColors.primaryStroke.withOpacity(0.08),
            blurRadius: 14,
            offset: const Offset(0, 3),
          ),
        ],
      ),
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
              color: SavingorColors.darkGreen,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInputBar({required bool canAsk, required double bottomInset}) {
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
              enabled: canAsk,
              maxLines: 3,
              minLines: 1,
              textInputAction: TextInputAction.send,
              onSubmitted: canAsk ? _askQuestion : null,
              decoration: InputDecoration(
                hintText: canAsk
                    ? 'Ask about your spending or shopping list…'
                    : 'Configure API key to ask questions',
                hintStyle: TextStyle(
                  color: SavingorColors.textSecondary.withOpacity(0.7),
                  fontSize: 14,
                ),
                filled: true,
                fillColor: const Color(0xFFF8FAF8),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
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
                  borderSide: const BorderSide(
                    color: SavingorColors.primaryStroke,
                    width: 1.5,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(width: 10),
          Material(
            color: canAsk
                ? SavingorColors.primaryStroke
                : SavingorColors.textSecondary.withOpacity(0.3),
            borderRadius: BorderRadius.circular(14),
            child: InkWell(
              onTap: canAsk
                  ? () => _askQuestion(_questionController.text)
                  : null,
              borderRadius: BorderRadius.circular(14),
              child: const SizedBox(
                width: 48,
                height: 48,
                child: Icon(Icons.send_rounded, color: Colors.white, size: 22),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SuggestionChip extends StatelessWidget {
  const _SuggestionChip({
    required this.label,
    required this.enabled,
    required this.onTap,
  });

  final String label;
  final bool enabled;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: enabled
          ? SavingorColors.lightGreen.withOpacity(0.35)
          : const Color(0xFFF3F4F3),
      borderRadius: BorderRadius.circular(20),
      child: InkWell(
        onTap: enabled ? onTap : null,
        borderRadius: BorderRadius.circular(20),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
          child: Text(
            label,
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: enabled
                  ? SavingorColors.darkGreen
                  : SavingorColors.textSecondary.withOpacity(0.6),
              height: 1.3,
            ),
          ),
        ),
      ),
    );
  }
}

class _SummaryChip extends StatelessWidget {
  const _SummaryChip({required this.icon, required this.label});

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: SavingorColors.lightGreen.withOpacity(0.25),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Icon(icon, size: 14, color: SavingorColors.primaryStroke),
          const SizedBox(width: 6),
          Text(
            label,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: SavingorColors.darkGreen,
            ),
          ),
        ],
      ),
    );
  }
}
