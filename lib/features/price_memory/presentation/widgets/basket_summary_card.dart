import 'package:flutter/material.dart';

import 'package:savingor_app/core/theme/savingor_design_system.dart';
import 'package:savingor_app/features/price_memory/domain/models/basket_optimization_result.dart';
import 'package:savingor_app/features/price_memory/domain/price_memory_formatters.dart';

class BasketSummaryCard extends StatelessWidget {
  const BasketSummaryCard({
    super.key,
    required this.result,
  });

  final BasketOptimizationResult result;

  static const Color _airyBorder = Color(0xFFF3F4F3);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: SavingorColors.lightGreen.withOpacity(0.35),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: _airyBorder.withOpacity(0.6), width: 0.5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          const Text(
            'Basket summary',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w700,
              color: SavingorColors.textSecondary,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: <Widget>[
              Expanded(
                child: _Metric(
                  label: 'Estimated best total',
                  value: PriceMemoryFormatters.formatPrice(
                    result.estimatedBestTotal,
                    currency: result.currency,
                  ),
                ),
              ),
              Expanded(
                child: _Metric(
                  label: 'Potential saving',
                  value: result.totalPotentialSaving > 0
                      ? PriceMemoryFormatters.formatPrice(
                          result.totalPotentialSaving,
                          currency: result.currency,
                        )
                      : '—',
                  highlight: result.totalPotentialSaving > 0,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: <Widget>[
              Expanded(
                child: _Metric(
                  label: 'Items matched',
                  value: '${result.matchedItemsCount}',
                ),
              ),
              Expanded(
                child: _Metric(
                  label: 'No price history',
                  value: '${result.unmatchedItemsCount}',
                ),
              ),
            ],
          ),
          if (result.activeListsIncluded != null) ...<Widget>[
            const SizedBox(height: 12),
            _Metric(
              label: 'Active lists included',
              value: '${result.activeListsIncluded}',
            ),
          ],
        ],
      ),
    );
  }
}

class _Metric extends StatelessWidget {
  const _Metric({
    required this.label,
    required this.value,
    this.highlight = false,
  });

  final String label;
  final String value;
  final bool highlight;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: SavingorColors.textSecondary,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w800,
            color: highlight
                ? SavingorColors.primaryStroke
                : SavingorColors.darkGreen,
          ),
        ),
      ],
    );
  }
}
