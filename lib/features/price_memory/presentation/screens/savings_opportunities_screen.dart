import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:savingor_app/core/theme/savingor_design_system.dart';
import 'package:savingor_app/core/widgets/app_screen_states.dart';
import 'package:savingor_app/features/price_memory/data/price_memory_store.dart';
import 'package:savingor_app/features/price_memory/domain/models/savings_opportunity.dart';
import 'package:savingor_app/features/price_memory/presentation/widgets/savings_opportunity_card.dart';
import 'package:savingor_app/l10n/app_localizations.dart';

class SavingsOpportunitiesScreen extends StatelessWidget {
  const SavingsOpportunitiesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final AppLocalizations l10n = AppLocalizations.of(context);
    final PriceMemoryStore store = PriceMemoryProvider.of(context);
    final double bottomInset = MediaQuery.paddingOf(context).bottom;

    return Scaffold(
      backgroundColor: context.savingor.pageBackground,
      appBar: AppBar(
        title: Text(
          l10n.savingsOpportunities,
          style: SavingorAppTextStyles.screenTitle(context),
        ),
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
          onPressed: () => context.pop(),
        ),
      ),
      body: AnimatedBuilder(
        animation: store,
        builder: (BuildContext context, Widget? _) {
          return _buildBody(context, store, bottomInset, l10n);
        },
      ),
    );
  }

  Widget _buildBody(
    BuildContext context,
    PriceMemoryStore store,
    double bottomInset,
    AppLocalizations l10n,
  ) {
    if (!store.isAuthenticated) {
      return AppSignInRequiredState(
        message: l10n.signInForSavingsOpportunities,
        onSignIn: () => context.push('/auth'),
      );
    }

    if (store.isLoading) {
      return AppLoadingState(message: l10n.loadingSavingsOpportunities);
    }

    if (store.loadError != null) {
      return AppErrorState(
        title: l10n.couldNotLoadSavingsOpportunities,
        message: store.loadError!,
        onRetry: store.retry,
      );
    }

    final List<SavingsOpportunity> opportunities = store.savingsOpportunities;

    if (opportunities.isEmpty) {
      return AppEmptyState(
        icon: Icons.savings_outlined,
        title: l10n.noSavingsOpportunitiesYet,
        message: l10n.noSavingsOpportunitiesMessage,
        actionLabel: l10n.addReceipt,
        prominentAction: true,
        onAction: () => context.push('/scanner/create'),
      );
    }

    return ListView(
      padding: EdgeInsets.fromLTRB(20, 8, 20, 24 + bottomInset),
      children: <Widget>[
        Text(
          l10n.savingsOpportunitiesPaidMoreCount(opportunities.length),
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: context.savingor.textSecondary,
            height: 1.4,
          ),
        ),
        const SizedBox(height: SavingorSpacing.md),
        ...opportunities.map(
          (SavingsOpportunity opportunity) => Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: SavingsOpportunityCard(
              opportunity: opportunity,
              onTap: () => context.push(
                '/analytics/product-price-insights/detail',
                extra: opportunity.normalizedProductName,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
