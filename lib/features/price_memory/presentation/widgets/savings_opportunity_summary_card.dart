import 'package:flutter/material.dart';

import 'package:savingor_app/core/theme/savingor_design_system.dart';
import 'package:savingor_app/features/price_memory/domain/models/savings_opportunity.dart';
import 'package:savingor_app/features/price_memory/domain/price_memory_formatters.dart';

/// Highlighted savings summary for product detail opened from opportunities.
class SavingsOpportunitySummaryCard extends StatelessWidget {
  const SavingsOpportunitySummaryCard({
    super.key,
    required this.opportunity,
  });

  final SavingsOpportunity opportunity;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: context.savingor.isDark
          ? SavingorWorkflowTheme.highlightCard(context)
          : BoxDecoration(
              color: SavingorColors.lightGreen.withOpacity(0.35),
              borderRadius: BorderRadius.circular(18),
              border: Border.all(
                color: SavingorColors.primaryStroke.withOpacity(0.35),
              ),
              boxShadow: <BoxShadow>[
                BoxShadow(
                  color: SavingorColors.primaryStroke.withOpacity(0.08),
                  blurRadius: 12,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            'Savings opportunity',
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w700,
              color: SavingorWorkflowTheme.accentText(context),
              letterSpacing: 0.2,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            opportunity.displayName,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w800,
              color: SavingorWorkflowTheme.headingText(context),
            ),
          ),
          const SizedBox(height: 10),
          Text(
            opportunity.savingsMessage,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w800,
              color: SavingorWorkflowTheme.accentText(context),
            ),
          ),
          const SizedBox(height: 14),
          _detailLine(
            context,
            'You paid',
            '${PriceMemoryFormatters.formatPrice(opportunity.latestPrice, currency: opportunity.currency)} at ${opportunity.latestStoreName}',
          ),
          const SizedBox(height: 8),
          _detailLine(
            context,
            'Best seen',
            '${PriceMemoryFormatters.formatPrice(opportunity.lowestPrice, currency: opportunity.currency)} at ${opportunity.lowestStoreName}',
          ),
          const SizedBox(height: 10),
          Text(
            'Difference: ${opportunity.percentageDifference.toStringAsFixed(1)}% lower',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color:
                  SavingorWorkflowTheme.primaryText(context).withOpacity(0.78),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Last bought: ${PriceMemoryFormatters.formatDate(opportunity.latestPurchaseDate)} · ${opportunity.recordCount} ${opportunity.recordCount == 1 ? 'record' : 'records'}',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: context.savingor.textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _detailLine(BuildContext context, String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: context.savingor.textSecondary,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          value,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w700,
            color: SavingorWorkflowTheme.primaryText(context),
            height: 1.35,
          ),
        ),
      ],
    );
  }
}
