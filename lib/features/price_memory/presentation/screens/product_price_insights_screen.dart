import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:savingor_app/core/theme/savingor_design_system.dart';
import 'package:savingor_app/core/widgets/app_screen_states.dart';
import 'package:savingor_app/features/price_memory/data/price_memory_store.dart';
import 'package:savingor_app/features/price_memory/domain/models/product_price_insight.dart';
import 'package:savingor_app/features/price_memory/presentation/widgets/product_price_insight_card.dart';

class ProductPriceInsightsScreen extends StatelessWidget {
  const ProductPriceInsightsScreen({super.key});

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
              'Product price insights',
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
        message: 'Sign in to view your product price memory.',
        onSignIn: () => context.push('/auth'),
      );
    }

    if (store.isLoading) {
      return const AppLoadingState(message: 'Loading price memory…');
    }

    if (store.loadError != null) {
      return AppErrorState(
        title: 'Could not load price memory',
        message: store.loadError!,
        onRetry: store.retry,
      );
    }

    if (!store.hasRecords) {
      return AppEmptyState(
        icon: Icons.price_change_outlined,
        title: 'No price memory yet',
        message:
            'Add receipts with line items to start building your price memory.',
        actionLabel: 'Add receipt',
        prominentAction: true,
        onAction: () => context.push('/scanner/create'),
      );
    }

    final List<ProductPriceInsight> insights = store.insights;

    return ListView.separated(
      padding: EdgeInsets.fromLTRB(20, 8, 20, 24 + bottomInset),
      itemCount: insights.length + 1,
      separatorBuilder: (_, __) => const SizedBox(height: 12),
      itemBuilder: (BuildContext context, int index) {
        if (index == 0) {
          return Text(
            '${insights.length} ${insights.length == 1 ? 'product' : 'products'} tracked from your receipts',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: SavingorColors.textSecondary.withOpacity(0.95),
              height: 1.4,
            ),
          );
        }

        final ProductPriceInsight insight = insights[index - 1];
        return ProductPriceInsightCard(
          insight: insight,
          onTap: () {
            context.push(
              '/analytics/product-price-insights/detail',
              extra: insight.normalizedProductName,
            );
          },
        );
      },
    );
  }
}
