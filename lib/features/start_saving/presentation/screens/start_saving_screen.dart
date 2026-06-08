import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:savingor_app/core/theme/savingor_design_system.dart';
import 'package:savingor_app/features/start_saving/presentation/widgets/start_saving_action_card.dart';

class StartSavingScreen extends StatelessWidget {
  const StartSavingScreen({super.key});

  static const Color _pageWhite = Color(0xFFFFFEFE);

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
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.w800,
                color: SavingorColors.darkGreen,
                height: 1.1,
                letterSpacing: -0.4,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Choose a saving action to continue.',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: SavingorColors.textSecondary.withOpacity(0.95),
                height: 1.35,
              ),
            ),
            const SizedBox(height: SavingorSpacing.xl),
            StartSavingActionCard(
              icon: Icons.add_shopping_cart_outlined,
              title: 'Add grocery expense',
              subtitle: 'Manually add a purchase or grocery expense.',
              iconColor: const Color(0xFFC4895A),
              onTap: () => context.push('/add-grocery-expense'),
            ),
            const SizedBox(height: 12),
            StartSavingActionCard(
              icon: Icons.checklist_rounded,
              title: 'Create shopping list',
              subtitle: 'Plan what to buy before your next trip.',
              iconColor: const Color(0xFF6B9E78),
              onTap: () => context.push('/shopping/create'),
            ),
            const SizedBox(height: 12),
            StartSavingActionCard(
              icon: Icons.shopping_basket_outlined,
              title: 'Optimize shopping basket',
              subtitle: 'Compare your list with known prices and stores.',
              iconColor: const Color(0xFF5B8FA8),
              onTap: () => context.push('/shopping/basket-optimizer'),
            ),
            const SizedBox(height: 12),
            StartSavingActionCard(
              icon: Icons.task_alt_rounded,
              title: 'Finalize shopping trip',
              subtitle:
                  'Turn purchased items into a receipt and update price history.',
              iconColor: const Color(0xFF8B6BA8),
              onTap: () =>
                  context.push('/start-saving/select-list-to-finalize'),
            ),
            const SizedBox(height: 12),
            StartSavingActionCard(
              icon: Icons.track_changes_rounded,
              title: 'Monthly goal / Budget',
              subtitle: 'Review or adjust your monthly grocery spending goal.',
              iconColor: const Color(0xFF9B7BB8),
              onTap: () => context.push('/start-saving/monthly-goal-budget'),
            ),
            const SizedBox(height: 12),
            StartSavingActionCard(
              icon: Icons.insights_outlined,
              title: 'Savings analytics',
              subtitle:
                  'Spending overview, savings value, and recommended actions.',
              iconColor: SavingorColors.primaryStroke,
              onTap: () => context.push('/analytics'),
            ),
          ],
        ),
      ),
    );
  }
}
