import 'package:flutter/material.dart';

import 'package:savingor_app/core/i18n/product_display_l10n.dart';
import 'package:savingor_app/core/theme/savingor_design_system.dart';
import 'package:savingor_app/features/price_memory/domain/models/basket_optimization_result.dart';
import 'package:savingor_app/features/price_memory/domain/price_memory_formatters.dart';
import 'package:savingor_app/l10n/app_localizations.dart';

class BasketStorePlanSection extends StatelessWidget {
  const BasketStorePlanSection({
    super.key,
    required this.storePlan,
    this.currency = 'CAD',
  });

  final List<BasketStorePlanEntry> storePlan;
  final String currency;

  static const Color _airyBorder = Color(0xFFF3F4F3);

  String _itemDisplayName(BuildContext context, BasketStorePlanItem item) {
    final String localized = ProductDisplayL10n.localizedProductName(
      context,
      item.shoppingItemName,
    );
    if (localized.toLowerCase() != item.shoppingItemName.trim().toLowerCase()) {
      return localized;
    }
    return item.shoppingItemName;
  }

  @override
  Widget build(BuildContext context) {
    final AppLocalizations l10n = AppLocalizations.of(context);

    if (storePlan.isEmpty) {
      return const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          l10n.suggestedStorePlan,
          style: const TextStyle(
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
                    (BasketStorePlanItem item) => Padding(
                      padding: const EdgeInsets.only(bottom: 6),
                      child: Text(
                        l10n.storePlanItemLine(
                          _itemDisplayName(context, item),
                          item.quantity > 1 ? ' ×${item.quantity}' : '',
                          PriceMemoryFormatters.formatPrice(
                            item.unitPrice,
                            currency: entry.currency,
                          ),
                          l10n.perUnit,
                        ),
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
                    l10n.estimatedStoreTotalLabel(
                      PriceMemoryFormatters.formatPrice(
                        entry.estimatedStoreTotal,
                        currency: entry.currency,
                      ),
                    ),
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
