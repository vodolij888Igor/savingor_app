import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:savingor_app/core/app_state.dart';
import 'package:savingor_app/core/i18n/savings_recommendation_l10n.dart';
import 'package:savingor_app/core/theme/savingor_design_system.dart';
import 'package:savingor_app/core/widgets/savingor_interactive.dart';
import 'package:savingor_app/features/analytics/domain/models/savings_recommendation.dart';
import 'package:savingor_app/l10n/app_localizations.dart';

class RecommendedActionsSection extends StatelessWidget {
  const RecommendedActionsSection({
    super.key,
    required this.recommendations,
    this.maxCount = 3,
    this.excludeWatchPriceRecommendations = false,
  });

  final List<SavingsRecommendation> recommendations;
  final int maxCount;
  final bool excludeWatchPriceRecommendations;

  List<SavingsRecommendation> get _displayRecommendations {
    Iterable<SavingsRecommendation> filtered = recommendations;
    if (excludeWatchPriceRecommendations) {
      filtered = filtered.where(
        (SavingsRecommendation recommendation) =>
            recommendation.type != SavingsRecommendationType.watchPrice,
      );
    }
    return filtered.take(maxCount).toList(growable: false);
  }

  @override
  Widget build(BuildContext context) {
    final AppLocalizations l10n = AppLocalizations.of(context);
    final List<SavingsRecommendation> displayed = _displayRecommendations;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          l10n.recommendedActions,
          style: SavingorAppTextStyles.sectionTitle,
        ),
        const SizedBox(height: SavingorSpacing.md),
        if (displayed.isEmpty)
          _buildEmptyState(l10n)
        else
          ...displayed.map(
            (SavingsRecommendation recommendation) => Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: _RecommendationCard(recommendation: recommendation),
            ),
          ),
      ],
    );
  }

  Widget _buildEmptyState(AppLocalizations l10n) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFFF3F4F3).withOpacity(0.6)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          const Icon(
            Icons.lightbulb_outline_rounded,
            color: SavingorColors.primaryStroke,
            size: 28,
          ),
          const SizedBox(height: 12),
          Text(
            l10n.addMoreReceiptsForSavings,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: SavingorColors.textSecondary,
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }
}

class _RecommendationCard extends StatelessWidget {
  const _RecommendationCard({
    required this.recommendation,
  });

  final SavingsRecommendation recommendation;

  static const Color _airyBorder = Color(0xFFF3F4F3);

  @override
  Widget build(BuildContext context) {
    final AppState appState = AppStateProvider.of(context);
    final bool isTappable = recommendation.isProductAction;
    final String title =
        SavingsRecommendationL10n.title(context, recommendation);
    final String reason =
        SavingsRecommendationL10n.reason(context, recommendation, appState);
    final String impact =
        SavingsRecommendationL10n.impactText(context, recommendation, appState);
    final String? dataBasis =
        SavingsRecommendationL10n.dataBasisText(context, recommendation);
    final Widget content =
        _buildContent(showChevron: isTappable, title: title, reason: reason, impact: impact, dataBasis: dataBasis);

    if (!isTappable) {
      return Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        decoration: _cardDecoration(),
        child: content,
      );
    }

    return SavingorInteractiveCard(
      onTap: () => _openProductDetail(context),
      borderRadius: BorderRadius.circular(18),
      accentTint: SavingorAccentColors.savings,
      borderColor: _airyBorder.withOpacity(0.6),
      padding: const EdgeInsets.all(16),
      child: content,
    );
  }

  void _openProductDetail(BuildContext context) {
    final String? normalizedName = recommendation.normalizedProductName;
    if (normalizedName == null || normalizedName.trim().isEmpty) {
      return;
    }

    context.push(
      '/analytics/product-price-insights/detail',
      extra: normalizedName,
    );
  }

  BoxDecoration _cardDecoration() {
    return BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(18),
      border: Border.all(color: _airyBorder.withOpacity(0.6)),
      boxShadow: <BoxShadow>[
        BoxShadow(
          color: Colors.black.withOpacity(0.04),
          blurRadius: 12,
          offset: const Offset(0, 2),
        ),
      ],
    );
  }

  Widget _buildContent({
    required bool showChevron,
    required String title,
    required String reason,
    required String impact,
    required String? dataBasis,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Icon(
              _iconForType(recommendation.type),
              color: _accentForType(recommendation.type),
              size: 22,
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                title,
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w800,
                  color: SavingorColors.textPrimary,
                  height: 1.3,
                ),
              ),
            ),
            if (showChevron) ...<Widget>[
              const SizedBox(width: 8),
              const Icon(
                Icons.chevron_right_rounded,
                color: SavingorColors.textSecondary,
                size: 22,
              ),
            ],
          ],
        ),
        const SizedBox(height: 10),
        Text(
          reason,
          style: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w500,
            color: SavingorColors.textSecondary,
            height: 1.4,
          ),
        ),
        const SizedBox(height: 10),
        Text(
          impact,
          style: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w700,
            color: SavingorAccentColors.savings,
            height: 1.3,
          ),
        ),
        if (dataBasis != null) ...<Widget>[
          const SizedBox(height: 8),
          Text(
            dataBasis,
            style: const TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w500,
              color: SavingorColors.textSecondary,
            ),
          ),
        ],
      ],
    );
  }

  IconData _iconForType(SavingsRecommendationType type) {
    switch (type) {
      case SavingsRecommendationType.storeSwitch:
        return Icons.storefront_outlined;
      case SavingsRecommendationType.watchPrice:
        return Icons.visibility_outlined;
      case SavingsRecommendationType.bestKnownStore:
        return Icons.place_outlined;
    }
  }

  Color _accentForType(SavingsRecommendationType type) {
    switch (type) {
      case SavingsRecommendationType.storeSwitch:
        return SavingorAccentColors.map;
      case SavingsRecommendationType.watchPrice:
        return SavingorAccentColors.priceMemory;
      case SavingsRecommendationType.bestKnownStore:
        return SavingorAccentColors.savings;
    }
  }
}
