import 'package:flutter/material.dart';

import 'package:savingor_app/core/theme/savingor_design_system.dart';
import 'package:savingor_app/features/price_memory/domain/models/basket_optimization_result.dart';
import 'package:savingor_app/features/price_memory/domain/price_memory_formatters.dart';

class BasketStorePlanSection extends StatelessWidget {
  const BasketStorePlanSection({
    super.key,
    required this.storePlan,
    this.currency = 'CAD',
  });

  final List<BasketStorePlanEntry> storePlan;
  final String currency;

  static const Color _airyBorder = Color(0xFFF3F4F3);

  @override
  Widget build(BuildContext context) {
    if (storePlan.isEmpty) {
      return const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        const Text(
          'Suggested store plan',
          style: TextStyle(
            fontSize: 17,
            fontWeight: FontWeight.w700,
            color: SavingorColors.darkGreen,
          ),
        ),
        const SizedBox(height: 12),
        ...storePlan.map(
          (BasketStorePlanEntry entry) => Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: Container(
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
                  Text(
                    entry.storeName,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w800,
                      color: SavingorColors.darkGreen,
                    ),
                  ),
                  const SizedBox(height: 10),
                  ...entry.items.map(
                    (item) => Padding(
                      padding: const EdgeInsets.only(bottom: 6),
                      child: Text(
                        '• ${item.shoppingItemName}'
                        '${item.quantity > 1 ? ' ×${item.quantity}' : ''}'
                        ' — ${PriceMemoryFormatters.formatPrice(item.unitPrice, currency: entry.currency)} each',
                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: SavingorColors.textSecondary,
                          height: 1.35,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'Estimated store total: ${PriceMemoryFormatters.formatPrice(entry.estimatedStoreTotal, currency: entry.currency)}',
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w800,
                      color: SavingorColors.primaryStroke,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
