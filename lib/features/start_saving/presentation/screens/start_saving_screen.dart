import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:savingor_app/core/theme/savingor_design_system.dart';
import 'package:savingor_app/features/start_saving/presentation/widgets/start_saving_action_card.dart';

class StartSavingScreen extends StatelessWidget {
  const StartSavingScreen({super.key});

  static const Color _pageWhite = SavingorColors.pageWhite;

  static const Color _expenseAccent = Color(0xFFC24E3A);
  static const Color _listAccent = Color(0xFF0F766E);
  static const Color _basketAccent = Color(0xFF3B6FA8);
  static const Color _finalizeAccent = Color(0xFF6B4F9E);
  static const Color _budgetAccent = Color(0xFFB8860B);
  static const Color _analyticsAccent = Color(0xFF047857);

  void _onBack(BuildContext context) {
    if (context.canPop()) {
      context.pop();
      return;
    }
    context.go('/deals');
  }

  @override
  Widget build(BuildContext context) {
    final double bottomInset = MediaQuery.paddingOf(context).bottom;

    return Scaffold(
      backgroundColor: _pageWhite,
      appBar: AppBar(
        toolbarHeight: 48,
        elevation: 0,
        scrolledUnderElevation: 0,
        backgroundColor: _pageWhite,
        surfaceTintColor: Colors.transparent,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_new_rounded,
            color: SavingorColors.darkGreen,
            size: 20,
          ),
          onPressed: () => _onBack(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.fromLTRB(20, 0, 20, 32 + bottomInset + 88),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            const Text(
              'Start saving',
              style: SavingorAppTextStyles.pageTitle,
            ),
            const SizedBox(height: 8),
            Text(
              'Choose a saving action to continue.',
              style: SavingorAppTextStyles.bodySecondary(fontSize: 16),
            ),
            const SizedBox(height: SavingorSpacing.xl),
            StartSavingActionCard(
              icon: Icons.add_shopping_cart_outlined,
              accentColor: _expenseAccent,
              title: 'Add grocery expense',
              subtitle: 'Manually add a purchase or grocery expense.',
              onTap: () => context.push('/add-grocery-expense'),
            ),
            const SizedBox(height: 12),
            StartSavingActionCard(
              icon: Icons.checklist_outlined,
              accentColor: _listAccent,
              title: 'Create shopping list',
              subtitle: 'Plan what to buy before your next trip.',
              onTap: () => context.push('/shopping/create'),
            ),
            const SizedBox(height: 12),
            StartSavingActionCard(
              icon: Icons.shopping_basket_outlined,
              accentColor: _basketAccent,
              title: 'Optimize shopping basket',
              subtitle: 'Compare your list with known prices and stores.',
              onTap: () => context.push('/shopping/basket-optimizer'),
            ),
            const SizedBox(height: 12),
            StartSavingActionCard(
              icon: Icons.task_alt_outlined,
              accentColor: _finalizeAccent,
              title: 'Finalize shopping trip',
              subtitle:
                  'Turn purchased items into a receipt and update price history.',
              onTap: () =>
                  context.push('/start-saving/select-list-to-finalize'),
            ),
            const SizedBox(height: 12),
            StartSavingActionCard(
              icon: Icons.savings_outlined,
              accentColor: _budgetAccent,
              title: 'Monthly goal / Budget',
              subtitle: 'Review or adjust your monthly grocery spending goal.',
              onTap: () => context.push('/start-saving/monthly-goal-budget'),
            ),
            const SizedBox(height: 12),
            StartSavingActionCard(
              icon: Icons.insights_outlined,
              accentColor: _analyticsAccent,
              title: 'Savings analytics',
              subtitle:
                  'Spending overview, savings value, and recommended actions.',
              onTap: () => context.push('/analytics'),
            ),
          ],
        ),
      ),
    );
  }
}
