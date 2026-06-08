import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:savingor_app/core/theme/savingor_design_system.dart';
import 'package:savingor_app/features/analytics/domain/models/savings_recommendation.dart';

class DashboardBestActionCard extends StatelessWidget {
  const DashboardBestActionCard({
    super.key,
    this.recommendation,
  });

  final SavingsRecommendation? recommendation;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        const Text(
          'Best action now',
          style: TextStyle(
            fontSize: 17,
            fontWeight: FontWeight.w800,
            color: SavingorColors.darkGreen,
          ),
        ),
        const SizedBox(height: SavingorSpacing.xs),
        if (recommendation == null)
          const _EmptyBestActionCard()
        else
          _RecommendationCard(recommendation: recommendation!),
      ],
    );
  }
}

class _EmptyBestActionCard extends StatelessWidget {
  const _EmptyBestActionCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: SavingorColors.lightGreen.withOpacity(0.35),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: SavingorColors.primaryStroke.withOpacity(0.2),
        ),
      ),
      child: const Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Icon(
            Icons.lightbulb_outline_rounded,
            color: SavingorColors.primaryStroke,
            size: 20,
          ),
          SizedBox(width: 10),
          Expanded(
            child: Text(
              'Add more receipts to unlock personalized savings.',
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w700,
                color: SavingorColors.darkGreen,
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
    final bool isTappable = recommendation.isProductAction;

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
                  recommendation.title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w800,
                    color: SavingorColors.darkGreen,
                    height: 1.2,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  recommendation.impactText,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w800,
                    color: SavingorColors.primaryStroke,
                    height: 1.2,
                  ),
                ),
                const SizedBox(height: 3),
                const Text(
                  'Based on receipt history',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w500,
                    color: SavingorColors.textSecondary,
                    height: 1.15,
                  ),
                ),
              ],
            ),
          ),
          if (isTappable) ...<Widget>[
            const SizedBox(width: 8),
            const Icon(
              Icons.chevron_right_rounded,
              color: SavingorColors.textSecondary,
              size: 22,
            ),
          ],
        ],
      ),
    );

    if (!isTappable) {
      return Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: SavingorColors.lightGreen.withOpacity(0.35),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: SavingorColors.primaryStroke.withOpacity(0.2),
          ),
        ),
        child: content,
      );
    }

    return Material(
      color: SavingorColors.lightGreen.withOpacity(0.35),
      borderRadius: BorderRadius.circular(16),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () => _onTap(context),
        child: Ink(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: SavingorColors.primaryStroke.withOpacity(0.2),
            ),
          ),
          child: content,
        ),
      ),
    );
  }
}
