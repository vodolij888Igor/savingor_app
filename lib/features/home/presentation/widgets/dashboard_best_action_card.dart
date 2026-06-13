import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:savingor_app/core/app_state.dart';
import 'package:savingor_app/core/i18n/savings_recommendation_l10n.dart';
import 'package:savingor_app/core/theme/savingor_design_system.dart';
import 'package:savingor_app/core/widgets/savingor_interactive.dart';
import 'package:savingor_app/features/analytics/domain/models/savings_recommendation.dart';
import 'package:savingor_app/l10n/app_localizations.dart';

class DashboardBestActionCard extends StatelessWidget {
  const DashboardBestActionCard({
    super.key,
    this.recommendation,
  });

  final SavingsRecommendation? recommendation;

  @override
  Widget build(BuildContext context) {
    final AppLocalizations l10n = AppLocalizations.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          l10n.bestActionNow,
          style: SavingorAppTextStyles.sectionTitle(context),
        ),
        const SizedBox(height: SavingorSpacing.xs),
        if (recommendation == null)
          _EmptyBestActionCard(message: l10n.addMoreReceiptsForSavings)
        else
          _RecommendationCard(recommendation: recommendation!),
      ],
    );
  }
}

class _EmptyBestActionCard extends StatelessWidget {
  const _EmptyBestActionCard({required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: SavingorSurfaces.premiumCard(context, radius: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          const Icon(
            Icons.lightbulb_outline_rounded,
            color: SavingorAccentColors.savings,
            size: 20,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              message,
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: context.savingor.textPrimary,
                height: 1.25,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _RecommendationCard extends StatelessWidget {
  const _RecommendationCard({required this.recommendation});

  final SavingsRecommendation recommendation;

  void _onTap(BuildContext context) {
    if (!recommendation.isProductAction) {
      context.push('/analytics');
      return;
    }

    context.push(
      '/analytics/product-price-insights/detail',
      extra: recommendation.normalizedProductName,
    );
  }

  @override
  Widget build(BuildContext context) {
    final AppLocalizations l10n = AppLocalizations.of(context);
    final AppState appState = AppStateProvider.of(context);
    final bool isTappable = recommendation.isProductAction;
    final String title =
        SavingsRecommendationL10n.title(context, recommendation);
    final String impact =
        SavingsRecommendationL10n.impactText(context, recommendation, appState);

    final Widget content = Padding(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Text(
                  title,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w800,
                    color: context.savingor.textPrimary,
                    height: 1.2,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  impact,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w800,
                    color: context.savingor.brandTitle,
                    height: 1.2,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  l10n.basedOnReceiptHistory,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w500,
                    color: context.savingor.textSecondary,
                    height: 1.15,
                  ),
                ),
              ],
            ),
          ),
          if (isTappable) ...<Widget>[
            const SizedBox(width: 8),
            Icon(
              Icons.chevron_right_rounded,
              color: context.savingor.textSecondary,
              size: 22,
            ),
          ],
        ],
      ),
    );

    if (!isTappable) {
      return Container(
        width: double.infinity,
        decoration: SavingorSurfaces.premiumCard(context, radius: 16),
        child: content,
      );
    }

    return SavingorInteractiveCard(
      onTap: () => _onTap(context),
      borderRadius: BorderRadius.circular(16),
      accentTint: SavingorAccentColors.savings,
      child: content,
    );
  }
}
