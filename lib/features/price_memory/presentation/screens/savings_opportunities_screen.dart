import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:savingor_app/core/theme/savingor_design_system.dart';
import 'package:savingor_app/core/widgets/app_screen_states.dart';
import 'package:savingor_app/features/price_memory/data/price_memory_store.dart';
import 'package:savingor_app/features/price_memory/domain/models/savings_opportunity.dart';
import 'package:savingor_app/features/price_memory/presentation/widgets/savings_opportunity_card.dart';

class SavingsOpportunitiesScreen extends StatelessWidget {
  const SavingsOpportunitiesScreen({super.key});

  static const Color _pageBackground = Colors.white;

  @override
  Widget build(BuildContext context) {
    final PriceMemoryStore store = PriceMemoryProvider.of(context);
    final double bottomInset = MediaQuery.paddingOf(context).bottom;

    return AnimatedBuilder(
      animation: store,
      builder: (BuildContext context, Widget? _) {
        return Scaffold(
          backgroundColor: _pageBackground,
          appBar: AppBar(
            title: const Text(
              'Savings opportunities',
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
            leading: IconButton(
              icon: const Icon(
                Icons.arrow_back_ios_new_rounded,
                color: SavingorColors.darkGreen,
                size: 20,
              ),
              onPressed: () => context.pop(),
            ),
          ),
          body: _buildBody(context, store, bottomInset),
        );
      },
    );
  }

  Widget _buildBody(
    BuildContext context,
    PriceMemoryStore store,
    double bottomInset,
  ) {
    if (!store.isAuthenticated) {
      return AppSignInRequiredState(
        message: 'Sign in to see savings opportunities from your receipts.',
        onSignIn: () => context.push('/auth'),
      );
    }

    if (store.isLoading) {
      return const AppLoadingState(message: 'Loading savings opportunities…');
    }

    if (store.loadError != null) {
      return AppErrorState(
        title: 'Could not load savings opportunities',
        message: store.loadError!,
        onRetry: store.retry,
      );
    }

    final List<SavingsOpportunity> opportunities = store.savingsOpportunities;

    if (opportunities.isEmpty) {
      return AppEmptyState(
        icon: Icons.savings_outlined,
        title: 'No savings opportunities yet',
        message:
            'Add more receipts with line items so Savingor can compare prices across stores.',
        actionLabel: 'Add receipt',
        prominentAction: true,
        onAction: () => context.push('/scanner/create'),
      );
    }

    return ListView.separated(
      padding: EdgeInsets.fromLTRB(20, 8, 20, 24 + bottomInset),
      itemCount: opportunities.length + 1,
      separatorBuilder: (_, __) => const SizedBox(height: 12),
      itemBuilder: (BuildContext context, int index) {
        if (index == 0) {
          return Text(
            '${opportunities.length} actionable ${opportunities.length == 1 ? 'opportunity' : 'opportunities'} where you paid more than the best known price',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: SavingorColors.textSecondary.withOpacity(0.95),
              height: 1.4,
            ),
          );
        }

        final SavingsOpportunity opportunity = opportunities[index - 1];
        return SavingsOpportunityCard(
          opportunity: opportunity,
          onTap: () {
            context.push(
              '/analytics/product-price-insights/detail',
              extra: opportunity,
            );
          },
        );
      },
    );
  }
}
