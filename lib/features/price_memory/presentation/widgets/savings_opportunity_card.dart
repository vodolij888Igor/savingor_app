import 'package:flutter/material.dart';

import 'package:savingor_app/core/theme/savingor_design_system.dart';
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
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(18),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: _airyBorder.withOpacity(0.6), width: 0.5),
            boxShadow: <BoxShadow>[
              BoxShadow(
                color: Colors.black.withOpacity(0.04),
                blurRadius: 10,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
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
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    decoration: BoxDecoration(
                      color: SavingorColors.lightGreen.withOpacity(0.55),
                      borderRadius: BorderRadius.circular(999),
                    ),
                    child: Text(
                      opportunity.savingsMessage,
                      style: const TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        color: SavingorColors.primaryStroke,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Text(
                'You paid ${PriceMemoryFormatters.formatPrice(opportunity.latestPrice, currency: opportunity.currency)} at ${opportunity.latestStoreName}',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: SavingorColors.darkGreen.withOpacity(0.85),
                  height: 1.35,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                'Best seen: ${PriceMemoryFormatters.formatPrice(opportunity.lowestPrice, currency: opportunity.currency)} at ${opportunity.lowestStoreName}',
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                  color: SavingorColors.textSecondary,
                  height: 1.35,
                ),
              ),
              const SizedBox(height: 8),
              Row(
                children: <Widget>[
                  Text(
                    '${opportunity.recordCount} ${opportunity.recordCount == 1 ? 'record' : 'records'}',
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: SavingorColors.primaryStroke,
                    ),
                  ),
                  const Text(
                    ' · ',
                    style: TextStyle(color: SavingorColors.textSecondary),
                  ),
                  Text(
                    'Last bought ${PriceMemoryFormatters.formatDate(opportunity.latestPurchaseDate)}',
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: SavingorColors.textSecondary,
                    ),
                  ),
                  const Spacer(),
                  const Icon(
                    Icons.chevron_right_rounded,
                    color: SavingorColors.textSecondary,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
