import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:savingor_app/core/theme/savingor_design_system.dart';
import 'package:savingor_app/features/analytics/domain/models/savings_recommendation.dart';

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
    final List<SavingsRecommendation> displayed = _displayRecommendations;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        const Text(
          'Recommended actions',
          style: TextStyle(
            fontSize: 17,
            fontWeight: FontWeight.w700,
            color: SavingorColors.darkGreen,
          ),
        ),
        const SizedBox(height: SavingorSpacing.md),
        if (displayed.isEmpty)
          _buildEmptyState()
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

  Widget _buildEmptyState() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFFF3F4F3).withOpacity(0.6)),
      ),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Icon(
            Icons.lightbulb_outline_rounded,
            color: SavingorColors.primaryStroke,
            size: 28,
          ),
          SizedBox(height: 12),
          Text(
            'Add more receipts to unlock personalized savings recommendations.',
            style: TextStyle(
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
    final bool isTappable = recommendation.isProductAction;
    final Widget content = _buildContent(showChevron: isTappable);

    if (!isTappable) {
      return Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        decoration: _cardDecoration(),
        child: content,
      );
    }

    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(18),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () => _openProductDetail(context),
        child: Ink(
          decoration: _cardDecoration(),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: content,
          ),
        ),
      ),
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

  Widget _buildContent({required bool showChevron}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Icon(
              _iconForType(recommendation.type),
              color: SavingorColors.primaryStroke,
              size: 22,
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                recommendation.title,
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFF111827),
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
          recommendation.reason,
          style: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w500,
            color: SavingorColors.textSecondary,
            height: 1.4,
          ),
        ),
        const SizedBox(height: 10),
        Text(
          recommendation.impactText,
          style: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w700,
            color: SavingorColors.darkGreen,
            height: 1.3,
          ),
        ),
        if (recommendation.dataBasisText != null) ...<Widget>[
          const SizedBox(height: 8),
          Text(
            recommendation.dataBasisText!,
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
}
