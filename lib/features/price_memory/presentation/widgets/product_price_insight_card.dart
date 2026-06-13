import 'package:flutter/material.dart';

import 'package:savingor_app/core/i18n/product_display_l10n.dart';
import 'package:savingor_app/core/theme/savingor_design_system.dart';
import 'package:savingor_app/core/widgets/savingor_interactive.dart';
import 'package:savingor_app/features/price_memory/domain/models/product_price_insight.dart';
import 'package:savingor_app/features/price_memory/domain/price_memory_formatters.dart';
import 'package:savingor_app/l10n/app_localizations.dart';

class ProductPriceInsightCard extends StatelessWidget {
  const ProductPriceInsightCard({
    super.key,
    required this.insight,
    required this.onTap,
  });

  final ProductPriceInsight insight;
  final VoidCallback onTap;

  static const Color _airyBorder = Color(0xFFF3F4F3);

  String _displayName(BuildContext context) {
    final String localized = ProductDisplayL10n.localizedProductName(
      context,
      insight.normalizedProductName,
    );
    if (localized != insight.normalizedProductName) {
      return localized;
    }
    return insight.displayName;
  }

  @override
  Widget build(BuildContext context) {
    final AppLocalizations l10n = AppLocalizations.of(context);

    return SavingorInteractiveCard(
      onTap: onTap,
      borderRadius: BorderRadius.circular(18),
      accentTint: SavingorAccentColors.priceMemory,
      borderColor: _airyBorder.withOpacity(0.6),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            children: <Widget>[
              Expanded(
                child: Text(
                  _displayName(context),
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
            context,
            '${l10n.latestPriceLabel}: ${l10n.priceAtStore(
              PriceMemoryFormatters.formatPrice(insight.latestPrice, currency: insight.currency),
              insight.latestStoreName,
            )}',
            emphasized: true,
          ),
          const SizedBox(height: 4),
          _historyLine(
            context,
            '${l10n.bestKnownPriceLabel}: ${l10n.priceAtStore(
              PriceMemoryFormatters.formatPrice(insight.lowestPrice, currency: insight.currency),
              insight.lowestStoreName,
            )}',
          ),
          const SizedBox(height: 4),
          _historyLine(
            context,
            '${l10n.highestPriceLabel}: ${PriceMemoryFormatters.formatPrice(insight.highestPrice, currency: insight.currency)}',
          ),
          const SizedBox(height: 4),
          _historyLine(
            context,
            '${l10n.averagePriceLabel}: ${PriceMemoryFormatters.formatPrice(insight.averagePrice, currency: insight.currency)}',
          ),
          const SizedBox(height: 6),
          Text(
            l10n.priceRecordCount(insight.recordCount),
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: SavingorColors.textSecondary.withOpacity(0.95),
            ),
          ),
        ],
      ),
    );
  }

  Widget _historyLine(BuildContext context, String text, {bool emphasized = false}) {
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
