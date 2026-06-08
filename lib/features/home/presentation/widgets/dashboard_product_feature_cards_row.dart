import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:savingor_app/core/theme/savingor_design_system.dart';
import 'package:savingor_app/features/price_memory/domain/models/product_price_record.dart';
import 'package:savingor_app/features/price_memory/domain/models/savings_opportunity.dart';
import 'package:savingor_app/features/price_memory/domain/price_memory_formatters.dart';
import 'package:savingor_app/features/price_memory/domain/savings_opportunity_finder.dart';

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
  static const Color _airyBorder = Color(0xFFF3F4F3);
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
    final List<SavingsOpportunity> opportunities =
        SavingsOpportunityFinder.find(records).take(maxCards).toList();
    final bool hasOpportunities = opportunities.isNotEmpty;

    return Container(
      padding: const EdgeInsets.fromLTRB(12, 10, 12, 12),
      decoration: BoxDecoration(
        color: SavingorColors.lightGreen.withOpacity(0.22),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: SavingorColors.primaryStroke.withOpacity(0.12),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Row(
            children: <Widget>[
              const Expanded(
                child: Text(
                  'Top saving opportunities',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                    color: SavingorColors.darkGreen,
                  ),
                ),
              ),
              if (hasOpportunities)
                TextButton(
                  onPressed: () =>
                      context.push('/analytics/savings-opportunities'),
                  style: TextButton.styleFrom(
                    foregroundColor: SavingorColors.primaryStroke,
                    padding: EdgeInsets.zero,
                    minimumSize: Size.zero,
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                  child: const Text(
                    'See all',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
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

/// Grocery-style icon from product name — no savings/piggy-bank icons.
abstract final class _GroceryProductIcons {
  static IconData forProduct(String productName) {
    final String lower = productName.toLowerCase();

    if (lower.contains('milk') ||
        lower.contains('juice') ||
        lower.contains('water') ||
        lower.contains('soda') ||
        lower.contains('drink')) {
      return Icons.local_drink_rounded;
    }
    if (lower.contains('bread') ||
        lower.contains('bagel') ||
        lower.contains('toast') ||
        lower.contains('bun') ||
        lower.contains('roll') ||
        lower.contains('croissant')) {
      return Icons.bakery_dining_rounded;
    }
    if (lower.contains('egg')) {
      return Icons.egg_alt_rounded;
    }
    if (lower.contains('chicken') ||
        lower.contains('beef') ||
        lower.contains('pork') ||
        lower.contains('meat') ||
        lower.contains('fish') ||
        lower.contains('salmon') ||
        lower.contains('turkey') ||
        lower.contains('steak')) {
      return Icons.restaurant_rounded;
    }
    if (lower.contains('banana') ||
        lower.contains('apple') ||
        lower.contains('fruit') ||
        lower.contains('berry') ||
        lower.contains('vegetable') ||
        lower.contains('lettuce') ||
        lower.contains('tomato')) {
      return Icons.eco_rounded;
    }
    if (lower.contains('cheese') ||
        lower.contains('yogurt') ||
        lower.contains('butter')) {
      return Icons.breakfast_dining_rounded;
    }

    return Icons.shopping_basket_outlined;
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
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: DashboardProductFeatureCardsRow._airyBorder.withOpacity(0.7),
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
                decoration: BoxDecoration(
                  color: SavingorColors.lightGreen.withOpacity(0.55),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.receipt_long_outlined,
                  color: SavingorColors.primaryStroke,
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              const Expanded(
                child: Text(
                  'Scan receipts to discover saving opportunities.',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: SavingorColors.darkGreen,
                    height: 1.35,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed: onAddReceipt,
              icon: const Icon(Icons.add_a_photo_outlined, size: 16),
              label: const Text(
                'Add receipt',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                ),
              ),
              style: OutlinedButton.styleFrom(
                foregroundColor: SavingorColors.darkGreen,
                side: BorderSide(
                  color: SavingorColors.primaryStroke.withOpacity(0.35),
                ),
                padding: const EdgeInsets.symmetric(vertical: 10),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
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
    final String currency = opportunity.currency;
    final String bestKnownLine =
        'Best known: ${PriceMemoryFormatters.formatPrice(opportunity.lowestPrice, currency: currency)} at ${opportunity.lowestStoreName}';
    final String latestLine =
        'Latest paid: ${PriceMemoryFormatters.formatPrice(opportunity.latestPrice, currency: currency)} at ${opportunity.latestStoreName}';
    final String saveBadge =
        'Save up to ${PriceMemoryFormatters.formatPrice(opportunity.priceDifference, currency: currency)}';
    final IconData productIcon =
        _GroceryProductIcons.forProduct(opportunity.displayName);

    return SizedBox(
      width: width,
      height: DashboardProductFeatureCardsRow._listHeight,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(20),
          child: Ink(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: SavingorColors.primaryStroke.withOpacity(0.22),
                width: 1.2,
              ),
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
            ),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(14, 14, 14, 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  Center(
                    child: Container(
                      width: 58,
                      height: 58,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: SavingorColors.primaryStroke.withOpacity(0.16),
                        ),
                        boxShadow: <BoxShadow>[
                          BoxShadow(
                            color:
                                SavingorColors.primaryStroke.withOpacity(0.1),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Icon(
                        productIcon,
                        size: 30,
                        color: SavingorColors.primaryStroke,
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    opportunity.displayName,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w800,
                      color: DashboardProductFeatureCardsRow._nearBlack,
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
                    style: const TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: SavingorColors.textSecondary,
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
                      color: SavingorColors.darkGreen.withOpacity(0.82),
                      height: 1.25,
                    ),
                  ),
                  const Spacer(),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                    decoration: BoxDecoration(
                      color: SavingorColors.primaryGreen.withOpacity(0.82),
                      borderRadius: BorderRadius.circular(SavingorRadius.pill),
                      boxShadow: <BoxShadow>[
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
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w800,
                        color: DashboardProductFeatureCardsRow._nearBlack,
                      ),
                    ),
                  ),
                  const SizedBox(height: 6),
                  const Text(
                    'Based on receipt history',
                    textAlign: TextAlign.center,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 9,
                      fontWeight: FontWeight.w500,
                      color: SavingorColors.textSecondary,
                      height: 1.1,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
