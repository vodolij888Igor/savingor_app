import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:savingor_app/core/theme/savingor_design_system.dart';
import 'package:savingor_app/features/start_saving/presentation/widgets/start_saving_action_card.dart';
import 'package:savingor_app/features/subscription/domain/feature_access_service.dart';
import 'package:savingor_app/features/subscription/domain/savingor_feature.dart';
import 'package:savingor_app/features/subscription/presentation/widgets/effective_subscription_builder.dart';
import 'package:savingor_app/l10n/app_localizations.dart';

class StartSavingScreen extends StatelessWidget {
  const StartSavingScreen({super.key});
  static const FeatureAccessService _accessService = FeatureAccessService();
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
    final AppLocalizations l10n = AppLocalizations.of(context);
    final double bottomInset = MediaQuery.paddingOf(context).bottom;

    return Scaffold(
      backgroundColor: context.savingor.pageBackground,
      appBar: AppBar(
        toolbarHeight: 48,
        elevation: 0,
        scrolledUnderElevation: 0,
        backgroundColor: context.savingor.pageBackground,
        surfaceTintColor: Colors.transparent,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios_new_rounded,
            color: SavingorWorkflowTheme.appBarIcon(context),
            size: 20,
          ),
          onPressed: () => _onBack(context),
        ),
      ),
      body: EffectiveSubscriptionBuilder(
        builder: (
          BuildContext context,
          status,
          bool isLoadingSubscription,
        ) {
          final bool showBasketProBadge = !isLoadingSubscription &&
              !_accessService.canAccessForStatus(
                feature: SavingorFeature.basketOptimizer,
                status: status,
              );
          final bool showAnalyticsProBadge = !isLoadingSubscription &&
              !_accessService.canAccessForStatus(
                feature: SavingorFeature.savingsAnalytics,
                status: status,
              );

          return SingleChildScrollView(
            padding: EdgeInsets.fromLTRB(20, 0, 20, 32 + bottomInset + 88),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  l10n.startSaving,
                  style: SavingorAppTextStyles.pageTitle(context),
                ),
                const SizedBox(height: 8),
                Text(
                  l10n.chooseSavingAction,
                  style: SavingorAppTextStyles.bodySecondary(context,
                      fontSize: 16),
                ),
                const SizedBox(height: SavingorSpacing.xl),
                StartSavingActionCard(
                  icon: Icons.add_shopping_cart_outlined,
                  accentColor: _expenseAccent,
                  title: l10n.addGroceryExpense,
                  subtitle: l10n.addGroceryExpenseSubtitle,
                  onTap: () => context.push('/add-grocery-expense'),
                ),
                const SizedBox(height: 12),
                StartSavingActionCard(
                  icon: Icons.checklist_outlined,
                  accentColor: _listAccent,
                  title: l10n.createShoppingListAction,
                  subtitle: l10n.createShoppingListSubtitle,
                  onTap: () => context.push('/shopping/create'),
                ),
                const SizedBox(height: 12),
                StartSavingActionCard(
                  icon: Icons.shopping_basket_outlined,
                  accentColor: _basketAccent,
                  title: l10n.optimizeShoppingBasket,
                  subtitle: l10n.optimizeShoppingBasketSubtitle,
                  showProBadge: showBasketProBadge,
                  onTap: () => context.push('/shopping/basket-optimizer'),
                ),
                const SizedBox(height: 12),
                StartSavingActionCard(
                  icon: Icons.task_alt_outlined,
                  accentColor: _finalizeAccent,
                  title: l10n.finalizeShoppingTrip,
                  subtitle: l10n.finalizeShoppingTripSubtitle,
                  onTap: () =>
                      context.push('/start-saving/select-list-to-finalize'),
                ),
                const SizedBox(height: 12),
                StartSavingActionCard(
                  icon: Icons.savings_outlined,
                  accentColor: _budgetAccent,
                  title: l10n.monthlyGoalBudget,
                  subtitle: l10n.monthlyGoalBudgetSubtitle,
                  onTap: () =>
                      context.push('/start-saving/monthly-goal-budget'),
                ),
                const SizedBox(height: 12),
                StartSavingActionCard(
                  icon: Icons.insights_outlined,
                  accentColor: _analyticsAccent,
                  title: l10n.savingsAnalytics,
                  subtitle: l10n.savingsAnalyticsSubtitle,
                  showProBadge: showAnalyticsProBadge,
                  onTap: () => context.push('/analytics'),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
