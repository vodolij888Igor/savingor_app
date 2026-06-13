import 'package:flutter/material.dart';

import 'package:savingor_app/core/i18n/product_display_l10n.dart';
import 'package:savingor_app/core/theme/savingor_design_system.dart';
import 'package:savingor_app/core/widgets/savingor_interactive.dart';
import 'package:savingor_app/features/price_memory/domain/models/savings_opportunity.dart';
import 'package:savingor_app/features/price_memory/domain/price_memory_formatters.dart';
import 'package:savingor_app/l10n/app_localizations.dart';

class SavingsOpportunityCard extends StatelessWidget {
  const SavingsOpportunityCard({
    super.key,
    required this.opportunity,
    required this.onTap,
  });

  final SavingsOpportunity opportunity;
  final VoidCallback onTap;

  static const Color _airyBorder = Color(0xFFF3F4F3);

  String _productDisplayName(BuildContext context) {
    final String localized = ProductDisplayL10n.localizedProductName(
      context,
      opportunity.normalizedProductName,
    );
    if (localized != opportunity.normalizedProductName) {
      return localized;
    }
    return opportunity.displayName;
  }

  String _recommendationText(BuildContext context, AppLocalizations l10n) {
    if (opportunity.latestStoreName.trim().toLowerCase() ==
        opportunity.lowestStoreName.trim().toLowerCase()) {
      return l10n.recommendationWatchProductBeforeBuying;
    }
    return l10n.recommendationBuyAtStoreNextTime(opportunity.lowestStoreName);
  }

  @override
  Widget build(BuildContext context) {
    final AppLocalizations l10n = AppLocalizations.of(context);
    final String formattedLatest = PriceMemoryFormatters.formatPrice(
      opportunity.latestPrice,
      currency: opportunity.currency,
    );
    final String formattedLowest = PriceMemoryFormatters.formatPrice(
      opportunity.lowestPrice,
      currency: opportunity.currency,
    );
    final String formattedSaving = PriceMemoryFormatters.formatPrice(
      opportunity.priceDifference,
      currency: opportunity.currency,
    );

    return SavingorInteractiveCard(
      onTap: onTap,
      borderRadius: BorderRadius.circular(18),
      accentTint: SavingorAccentColors.savings,
      borderColor: _airyBorder.withOpacity(0.6),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            children: <Widget>[
              Expanded(
                child: Text(
                  _productDisplayName(context),
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
          Text(
            l10n.saveUpToPerItem(formattedSaving),
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w800,
              color: SavingorColors.primaryStroke,
              height: 1.3,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            l10n.youPaidAtStore(formattedLatest, opportunity.latestStoreName),
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: SavingorColors.darkGreen.withOpacity(0.85),
              height: 1.35,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            l10n.bestKnownAtStore(formattedLowest, opportunity.lowestStoreName),
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w500,
              color: SavingorColors.textSecondary,
              height: 1.35,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            _recommendationText(context, l10n),
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: SavingorColors.darkGreen.withOpacity(0.78),
              height: 1.35,
            ),
          ),
        ],
      ),
    );
  }
}
