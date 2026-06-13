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
          style: SavingorAppTextStyles.sectionTitle(context),
        ),
        const SizedBox(height: 12),
        ...storePlan.map(
          (BasketStorePlanEntry entry) => Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: SavingorWorkflowTheme.card(context),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    entry.storeName,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w800,
                      color: SavingorWorkflowTheme.headingText(context),
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
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: context.savingor.textSecondary,
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
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w800,
                      color: SavingorWorkflowTheme.accentText(context),
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
