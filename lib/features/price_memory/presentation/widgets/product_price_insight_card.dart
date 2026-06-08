import 'package:flutter/material.dart';

import 'package:savingor_app/core/theme/savingor_design_system.dart';
import 'package:savingor_app/features/price_memory/domain/models/product_price_insight.dart';
import 'package:savingor_app/features/price_memory/domain/price_memory_formatters.dart';

class ProductPriceInsightCard extends StatelessWidget {
  const ProductPriceInsightCard({
    super.key,
    required this.insight,
    required this.onTap,
  });

  final ProductPriceInsight insight;
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
                children: <Widget>[
                  Expanded(
                    child: Text(
                      insight.displayName,
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
              _historyLine(
                'Latest: ${PriceMemoryFormatters.formatPrice(insight.latestPrice, currency: insight.currency)} at ${insight.latestStoreName}',
                emphasized: true,
              ),
              const SizedBox(height: 4),
              _historyLine(
                'Best known: ${PriceMemoryFormatters.formatPrice(insight.lowestPrice, currency: insight.currency)} at ${insight.lowestStoreName}',
              ),
              const SizedBox(height: 4),
              _historyLine(
                'Highest: ${PriceMemoryFormatters.formatPrice(insight.highestPrice, currency: insight.currency)}',
              ),
              const SizedBox(height: 4),
              _historyLine(
                'Average: ${PriceMemoryFormatters.formatPrice(insight.averagePrice, currency: insight.currency)}',
              ),
              const SizedBox(height: 6),
              Text(
                insight.recordCountLabel,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: SavingorColors.textSecondary.withOpacity(0.95),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _historyLine(String text, {bool emphasized = false}) {
    return Text(
      text,
      style: TextStyle(
        fontSize: 13,
        fontWeight: emphasized ? FontWeight.w600 : FontWeight.w500,
        color: emphasized
            ? SavingorColors.darkGreen.withOpacity(0.85)
            : SavingorColors.textSecondary,
        height: 1.35,
      ),
    );
  }
}
