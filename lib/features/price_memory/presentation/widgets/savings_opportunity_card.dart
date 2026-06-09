import 'package:flutter/material.dart';

import 'package:savingor_app/core/theme/savingor_design_system.dart';
import 'package:savingor_app/core/widgets/savingor_interactive.dart';
import 'package:savingor_app/features/price_memory/domain/models/savings_opportunity.dart';
import 'package:savingor_app/features/price_memory/domain/price_memory_formatters.dart';

class SavingsOpportunityCard extends StatelessWidget {
  const SavingsOpportunityCard({
    super.key,
    required this.opportunity,
    required this.onTap,
  });

  final SavingsOpportunity opportunity;
  final VoidCallback onTap;

  static const Color _airyBorder = Color(0xFFF3F4F3);

  @override
  Widget build(BuildContext context) {
    return SavingorInteractiveCard(
      onTap: onTap,
      borderRadius: BorderRadius.circular(18),
      accentTint: SavingorAccentColors.savings,
      borderColor: _airyBorder.withOpacity(0.6),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            children: <Widget>[
              Expanded(
                child: Text(
                  opportunity.displayName,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                    color: SavingorColors.darkGreen,
                  ),
                ),
              ),
              Icon(
                Icons.chevron_right_rounded,
                color: SavingorColors.textSecondary.withOpacity(0.55),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            opportunity.savingsMessage,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w800,
              color: SavingorColors.primaryStroke,
              height: 1.3,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'You paid ${PriceMemoryFormatters.formatPrice(opportunity.latestPrice, currency: opportunity.currency)} at ${opportunity.latestStoreName}',
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: SavingorColors.darkGreen.withOpacity(0.85),
              height: 1.35,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Best known: ${PriceMemoryFormatters.formatPrice(opportunity.lowestPrice, currency: opportunity.currency)} at ${opportunity.lowestStoreName}',
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w500,
              color: SavingorColors.textSecondary,
              height: 1.35,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Recommendation: ${opportunity.recommendation}',
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: SavingorColors.darkGreen.withOpacity(0.78),
              height: 1.35,
            ),
          ),
        ],
      ),
    );
  }
}
