import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:savingor_app/core/theme/savingor_design_system.dart';
import 'package:savingor_app/core/widgets/app_screen_states.dart';
import 'package:savingor_app/features/price_memory/data/price_memory_store.dart';
import 'package:savingor_app/features/price_memory/domain/models/product_price_insight.dart';
import 'package:savingor_app/features/price_memory/presentation/widgets/product_price_insight_card.dart';
import 'package:savingor_app/l10n/app_localizations.dart';

class ProductPriceInsightsScreen extends StatelessWidget {
  const ProductPriceInsightsScreen({super.key});
  @override
  Widget build(BuildContext context) {
    final AppLocalizations l10n = AppLocalizations.of(context);
    final PriceMemoryStore store = PriceMemoryProvider.of(context);
    final double bottomInset = MediaQuery.paddingOf(context).bottom;

    return AnimatedBuilder(
      animation: store,
      builder: (BuildContext context, Widget? _) {
        return Scaffold(
          backgroundColor: context.savingor.pageBackground,
          appBar: AppBar(
            title: Text(
              l10n.productPriceInsights,
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
          body: _buildBody(context, store, bottomInset, l10n),
        );
      },
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
        message: l10n.signInForPriceMemory,
        onSignIn: () => context.push('/auth'),
      );
    }

    if (store.isLoading) {
      return AppLoadingState(message: l10n.loadingPriceMemory);
    }

    if (store.loadError != null) {
      return AppErrorState(
        title: l10n.couldNotLoadPriceMemory,
        message: store.loadError!,
        onRetry: store.retry,
      );
    }

    if (!store.hasRecords) {
      return AppEmptyState(
        icon: Icons.price_change_outlined,
        title: l10n.noPriceMemoryYet,
        message: l10n.noPriceMemoryMessage,
        actionLabel: l10n.addReceipt,
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
            l10n.productsInPriceHistoryFromReceipts(insights.length),
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: context.savingor.textSecondary.withOpacity(0.95),
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
