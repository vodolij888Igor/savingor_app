import 'package:flutter/material.dart';

import 'package:savingor_app/core/i18n/product_display_l10n.dart';
import 'package:savingor_app/core/theme/savingor_design_system.dart';
import 'package:savingor_app/features/price_memory/domain/models/basket_price_recommendation.dart';
import 'package:savingor_app/features/price_memory/domain/price_memory_formatters.dart';
import 'package:savingor_app/l10n/app_localizations.dart';

class BasketRecommendationCard extends StatelessWidget {
  const BasketRecommendationCard({
    super.key,
    required this.recommendation,
  });

  final BasketPriceRecommendation recommendation;

  static const Color _airyBorder = Color(0xFFF3F4F3);

  String _itemDisplayName(BuildContext context) {
    final String localized = ProductDisplayL10n.localizedProductName(
      context,
      recommendation.normalizedProductName,
    );
    if (localized != recommendation.normalizedProductName) {
      return localized;
    }
    return recommendation.shoppingItemName;
  }

  @override
  Widget build(BuildContext context) {
    final AppLocalizations l10n = AppLocalizations.of(context);
    final String itemName = _itemDisplayName(context);

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
                  itemName,
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
              label: l10n.bestKnownLabel,
              value: l10n.priceAtStore(
                PriceMemoryFormatters.formatPrice(
                  recommendation.bestKnownPrice!,
                  currency: recommendation.currency,
                ),
                recommendation.bestStoreName ?? '',
              ),
            ),
            const SizedBox(height: 6),
            _DetailLine(
              label: l10n.latestSeen,
              value: l10n.priceAtStore(
                PriceMemoryFormatters.formatPrice(
                  recommendation.latestKnownPrice!,
                  currency: recommendation.currency,
                ),
                recommendation.latestStoreName ?? '',
              ),
            ),
            if (recommendation.potentialSavingPerItem > 0) ...<Widget>[
              const SizedBox(height: 10),
              Text(
                recommendation.shoppingQuantity > 1
                    ? l10n.saveUpToTotal(
                        PriceMemoryFormatters.formatPrice(
                          recommendation.potentialSavingPerItem *
                              recommendation.shoppingQuantity,
                          currency: recommendation.currency,
                        ),
                      )
                    : l10n.saveUpToAmount(
                        PriceMemoryFormatters.formatPrice(
                          recommendation.potentialSavingPerItem,
                          currency: recommendation.currency,
                        ),
                      ),
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  color: SavingorColors.primaryStroke,
                ),
              ),
            ],
          ] else ...<Widget>[
            Text(
              l10n.noPriceHistoryYet,
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w700,
                color: SavingorColors.darkGreen,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              recommendation.message ?? l10n.addReceiptsForItemRecommendations,
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
