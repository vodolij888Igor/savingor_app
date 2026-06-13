import 'package:flutter/material.dart';

import 'package:savingor_app/core/theme/savingor_design_system.dart';
import 'package:savingor_app/core/widgets/savingor_interactive.dart';
import 'package:savingor_app/features/subscription/domain/feature_access_service.dart';
import 'package:savingor_app/features/subscription/domain/savingor_feature.dart';
import 'package:savingor_app/features/subscription/presentation/widgets/effective_subscription_builder.dart';
import 'package:savingor_app/features/subscription/presentation/widgets/pro_feature_badge.dart';

class BasketOptimizerEntryCard extends StatelessWidget {
  const BasketOptimizerEntryCard({
    super.key,
    required this.onTap,
    this.title = 'Optimize my basket',
    this.subtitle = 'Find the best known stores from your receipt history',
    this.showProBadge = false,
  });

  final VoidCallback onTap;
  final String title;
  final String subtitle;
  final bool showProBadge;

  static const Color _airyBorder = Color(0xFFF3F4F3);

  @override
  Widget build(BuildContext context) {
    final Color borderColor = context.savingor.isDark
        ? context.savingor.border.withOpacity(0.85)
        : _airyBorder.withOpacity(0.6);

    return SavingorInteractiveCard(
      onTap: onTap,
      borderRadius: BorderRadius.circular(18),
      accentTint: SavingorColors.primaryStroke,
      borderColor: borderColor,
      padding: const EdgeInsets.all(16),
      child: Row(
        children: <Widget>[
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: context.savingor.isDark
                  ? context.savingor.selectedHighlight
                  : SavingorColors.lightGreen,
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(
              Icons.shopping_basket_outlined,
              color: SavingorWorkflowTheme.accentText(context),
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Expanded(
                      child: Text(
                        title,
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w800,
                          color: SavingorWorkflowTheme.primaryText(context),
                        ),
                      ),
                    ),
                    if (showProBadge) ...<Widget>[
                      const SizedBox(width: 8),
                      const ProFeatureBadge(),
                    ],
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: context.savingor.textSecondary,
                    height: 1.35,
                  ),
                ),
              ],
            ),
          ),
          Icon(
            Icons.chevron_right_rounded,
            color: context.savingor.textSecondary,
          ),
        ],
      ),
    );
  }
}

/// Entry card that shows a Pro badge automatically for Free users.
class BasketOptimizerEntryCardWithProBadge extends StatelessWidget {
  const BasketOptimizerEntryCardWithProBadge({
    super.key,
    required this.onTap,
    required this.title,
    required this.subtitle,
  });

  final VoidCallback onTap;
  final String title;
  final String subtitle;

  static const FeatureAccessService _accessService = FeatureAccessService();

  @override
  Widget build(BuildContext context) {
    return EffectiveSubscriptionBuilder(
      builder: (
        BuildContext context,
        status,
        bool isLoading,
      ) {
        final bool showProBadge = !isLoading &&
            !_accessService.canAccessForStatus(
              feature: SavingorFeature.basketOptimizer,
              status: status,
            );

        return BasketOptimizerEntryCard(
          onTap: onTap,
          title: title,
          subtitle: subtitle,
          showProBadge: showProBadge,
        );
      },
    );
  }
}
