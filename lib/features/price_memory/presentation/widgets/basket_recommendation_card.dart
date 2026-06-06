import 'package:flutter/material.dart';

import 'package:savingor_app/core/theme/savingor_design_system.dart';
import 'package:savingor_app/features/price_memory/domain/models/basket_price_recommendation.dart';
import 'package:savingor_app/features/price_memory/domain/price_memory_formatters.dart';

class BasketRecommendationCard extends StatelessWidget {
  const BasketRecommendationCard({
    super.key,
    required this.recommendation,
  });

  final BasketPriceRecommendation recommendation;

  static const Color _airyBorder = Color(0xFFF3F4F3);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
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
                  recommendation.shoppingItemName,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                    color: SavingorColors.darkGreen,
                  ),
                ),
              ),
              if (recommendation.shoppingQuantity > 1)
                Text(
                  '×${recommendation.shoppingQuantity}',
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: SavingorColors.textSecondary,
                  ),
                ),
            ],
          ),
          const SizedBox(height: 10),
          if (recommendation.hasPriceData) ...<Widget>[
            _DetailLine(
              label: 'Best known',
              value:
                  '${PriceMemoryFormatters.formatPrice(recommendation.bestKnownPrice!, currency: recommendation.currency)} at ${recommendation.bestStoreName}',
            ),
            const SizedBox(height: 6),
            _DetailLine(
              label: 'Latest seen',
              value:
                  '${PriceMemoryFormatters.formatPrice(recommendation.latestKnownPrice!, currency: recommendation.currency)} at ${recommendation.latestStoreName}',
            ),
            if (recommendation.potentialSavingPerItem > 0) ...<Widget>[
              const SizedBox(height: 10),
              Text(
                'Save up to ${PriceMemoryFormatters.formatPrice(recommendation.potentialSavingPerItem, currency: recommendation.currency)}'
                '${recommendation.shoppingQuantity > 1 ? ' total' : ''}',
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  color: SavingorColors.primaryStroke,
                ),
              ),
            ],
          ] else ...<Widget>[
            const Text(
              'No price history yet',
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w700,
                color: SavingorColors.darkGreen,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              recommendation.message ??
                  'Add receipts with this item to unlock recommendations.',
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w500,
                color: SavingorColors.textSecondary,
                height: 1.4,
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _DetailLine extends StatelessWidget {
  const _DetailLine({
    required this.label,
    required this.value,
  });

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return RichText(
      text: TextSpan(
        style: const TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w500,
          color: SavingorColors.textSecondary,
          height: 1.35,
        ),
        children: <TextSpan>[
          TextSpan(
            text: '$label: ',
            style: const TextStyle(fontWeight: FontWeight.w700),
          ),
          TextSpan(
            text: value,
            style: TextStyle(
              fontWeight: FontWeight.w600,
              color: SavingorColors.darkGreen.withOpacity(0.9),
            ),
          ),
        ],
      ),
    );
  }
}
