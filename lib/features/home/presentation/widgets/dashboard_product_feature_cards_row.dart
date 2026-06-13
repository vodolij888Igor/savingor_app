import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:savingor_app/core/app_state.dart';
import 'package:savingor_app/core/i18n/product_display_l10n.dart';
import 'package:savingor_app/core/theme/savingor_design_system.dart';
import 'package:savingor_app/core/widgets/savingor_interactive.dart';
import 'package:savingor_app/core/widgets/product_thumbnail_avatar.dart';
import 'package:savingor_app/features/price_memory/domain/models/product_price_record.dart';
import 'package:savingor_app/features/price_memory/domain/models/savings_opportunity.dart';
import 'package:savingor_app/features/price_memory/domain/savings_opportunity_finder.dart';
import 'package:savingor_app/l10n/app_localizations.dart';

/// Horizontal saving-opportunity cards from real price memory data.
class DashboardProductFeatureCardsRow extends StatelessWidget {
  const DashboardProductFeatureCardsRow({
    super.key,
    required this.records,
    this.maxCards = 5,
  });

  final List<ProductPriceRecord> records;
  final int maxCards;

  static const Color _nearBlack = Color(0xFF111827);
  static const double _listHeight = 252;
  static const double _cardGap = 10;

  double _cardWidth(BuildContext context) {
    final double screenWidth = MediaQuery.sizeOf(context).width;
    const double outerPadding = 40;
    const double sectionPadding = 24;
    return (screenWidth - outerPadding - sectionPadding - _cardGap) / 2;
  }

  @override
  Widget build(BuildContext context) {
    final AppLocalizations l10n = AppLocalizations.of(context);
    final List<SavingsOpportunity> opportunities =
        SavingsOpportunityFinder.find(records).take(maxCards).toList();
    final bool hasOpportunities = opportunities.isNotEmpty;

    return Container(
      padding: const EdgeInsets.fromLTRB(12, 10, 12, 12),
      decoration: SavingorSurfaces.premiumCard(context, radius: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Row(
            children: <Widget>[
              Expanded(
                child: Text(
                  l10n.topSavingOpportunities,
                  style: SavingorAppTextStyles.sectionTitleLarge(context),
                ),
              ),
              if (hasOpportunities)
                SavingorInteractiveTextButton(
                  onPressed: () =>
                      context.push('/analytics/savings-opportunities'),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                  child: Text(l10n.seeAll),
                ),
            ],
          ),
          const SizedBox(height: 4),
          if (!hasOpportunities)
            _EmptySavingOpportunitiesCard(
              onAddReceipt: () => context.push('/scanner/create'),
            )
          else
            SizedBox(
              height: _listHeight,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: opportunities.length,
                separatorBuilder: (_, __) => const SizedBox(width: _cardGap),
                itemBuilder: (BuildContext context, int index) {
                  final SavingsOpportunity opportunity = opportunities[index];
                  return _SavingOpportunityTile(
                    width: _cardWidth(context),
                    opportunity: opportunity,
                    onTap: () => context.push(
                      '/analytics/product-price-insights/detail',
                      extra: opportunity.normalizedProductName,
                    ),
                  );
                },
              ),
            ),
        ],
      ),
    );
  }
}

class _EmptySavingOpportunitiesCard extends StatelessWidget {
  const _EmptySavingOpportunitiesCard({required this.onAddReceipt});

  final VoidCallback onAddReceipt;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(14, 14, 14, 12),
      decoration: BoxDecoration(
        color: context.savingor.surfacePrimary,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: context.savingor.border.withOpacity(0.85),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                width: 40,
                height: 40,
                decoration: SavingorSurfaces.accentIconBlock(
                  accent: SavingorAccentColors.savings,
                  radius: 20,
                ),
                child: const Icon(
                  Icons.receipt_long_outlined,
                  color: SavingorAccentColors.savings,
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  'Scan receipts to discover saving opportunities.',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: context.savingor.textPrimary,
                    height: 1.35,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          SavingorInteractiveOutlinedButton(
            onPressed: onAddReceipt,
            foregroundColor: context.savingor.textPrimary,
            borderColor: context.savingor.border.withOpacity(0.85),
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 14),
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Icon(Icons.add_a_photo_outlined, size: 16),
                SizedBox(width: 6),
                Text('Add receipt'),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _SavingOpportunityTile extends StatelessWidget {
  const _SavingOpportunityTile({
    required this.width,
    required this.opportunity,
    required this.onTap,
  });

  final double width;
  final SavingsOpportunity opportunity;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final AppLocalizations l10n = AppLocalizations.of(context);
    final AppState appState = AppStateProvider.of(context);
    final SavingorThemeExtension theme = context.savingor;
    formatAmount(double amount) =>
        appState.formatMoney(amount, originalCurrency: opportunity.currency);

    final String bestKnownLine = l10n.bestKnownAtStore(
      formatAmount(opportunity.lowestPrice),
      opportunity.lowestStoreName,
    );
    final String latestLine = l10n.latestPaidAtStore(
      formatAmount(opportunity.latestPrice),
      opportunity.latestStoreName,
    );
    final String saveBadge =
        l10n.saveUpToAmount(formatAmount(opportunity.priceDifference));

    final String displayLabel = ProductDisplayL10n.localizedProductName(
      context,
      opportunity.normalizedProductName,
    );

    return SizedBox(
      width: width,
      height: DashboardProductFeatureCardsRow._listHeight,
      child: SavingorInteractiveCard(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        accentTint: SavingorColors.primaryStroke,
        borderColor: SavingorColors.primaryStroke.withOpacity(0.22),
        hoverBorderColor: SavingorColors.primaryStroke.withOpacity(0.34),
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: SavingorColors.primaryStroke.withOpacity(0.08),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
        hoverBoxShadow: <BoxShadow>[
          BoxShadow(
            color: SavingorColors.primaryStroke.withOpacity(0.14),
            blurRadius: 18,
            offset: const Offset(0, 6),
          ),
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
        padding: const EdgeInsets.fromLTRB(14, 14, 14, 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Center(
              child: ProductThumbnailAvatar(
                productName: opportunity.normalizedProductName,
                size: 58,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              displayLabel,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w800,
                color: theme.textPrimary,
                height: 1.15,
                letterSpacing: -0.2,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              bestKnownLine,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: context.savingor.textSecondary,
                height: 1.25,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              latestLine,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w500,
                color: context.savingor.textSecondary,
                height: 1.25,
              ),
            ),
            const Spacer(),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                color: theme.isDark
                    ? theme.accentGreen.withOpacity(0.22)
                    : SavingorColors.primaryGreen.withOpacity(0.82),
                borderRadius: BorderRadius.circular(SavingorRadius.pill),
                boxShadow: theme.isDark
                    ? null
                    : <BoxShadow>[
                        BoxShadow(
                          color: SavingorColors.primaryStroke.withOpacity(0.12),
                          blurRadius: 6,
                          offset: const Offset(0, 2),
                        ),
                      ],
              ),
              child: Text(
                saveBadge,
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w800,
                  color: theme.isDark
                      ? theme.brandTitle
                      : DashboardProductFeatureCardsRow._nearBlack,
                  height: 1.15,
                ),
              ),
            ),
            const SizedBox(height: 6),
            Text(
              l10n.basedOnReceiptHistory,
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 9,
                fontWeight: FontWeight.w500,
                color: context.savingor.textSecondary,
                height: 1.15,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
