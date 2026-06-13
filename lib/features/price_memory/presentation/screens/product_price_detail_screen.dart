import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:savingor_app/core/i18n/locale_date_format.dart';
import 'package:savingor_app/core/i18n/product_display_l10n.dart';
import 'package:savingor_app/core/i18n/receipt_l10n.dart';
import 'package:savingor_app/core/theme/savingor_design_system.dart';
import 'package:savingor_app/features/price_memory/data/price_memory_store.dart';
import 'package:savingor_app/features/price_memory/domain/models/product_price_insight.dart';
import 'package:savingor_app/features/price_memory/domain/models/product_price_record.dart';
import 'package:savingor_app/features/price_memory/domain/models/savings_opportunity.dart';
import 'package:savingor_app/features/price_memory/domain/price_memory_formatters.dart';
import 'package:savingor_app/features/price_memory/presentation/widgets/product_buying_advice_card.dart';
import 'package:savingor_app/features/receipts/domain/models/receipt_source.dart';
import 'package:savingor_app/features/receipts/presentation/widgets/receipt_source_badge.dart';
import 'package:savingor_app/l10n/app_localizations.dart';

class ProductPriceDetailScreen extends StatelessWidget {
  const ProductPriceDetailScreen({
    super.key,
    required this.normalizedProductName,
    this.savingsOpportunity,
  });

  final String normalizedProductName;
  final SavingsOpportunity? savingsOpportunity;

  static BoxDecoration _cardDecoration(BuildContext context) =>
      SavingorWorkflowTheme.card(context);

  String _productDisplayName(
      BuildContext context, ProductPriceInsight insight) {
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
    final PriceMemoryStore store = PriceMemoryProvider.of(context);
    final double bottomInset = MediaQuery.paddingOf(context).bottom;

    return AnimatedBuilder(
      animation: store,
      builder: (BuildContext context, Widget? _) {
        final ProductPriceInsight? insight =
            store.insightForNormalizedName(normalizedProductName);

        return Scaffold(
          backgroundColor: context.savingor.pageBackground,
          appBar: AppBar(
            title: Text(
              insight != null
                  ? _productDisplayName(context, insight)
                  : l10n.productHistoryTitle,
              style: SavingorAppTextStyles.screenTitle(context),
            ),
            elevation: 0,
            scrolledUnderElevation: 0,
            backgroundColor: context.savingor.pageBackground,
            surfaceTintColor: Colors.transparent,
            leading: IconButton(
              icon: Icon(
                Icons.arrow_back_ios_new_rounded,
                color: SavingorWorkflowTheme.appBarIcon(context),
                size: 20,
              ),
              onPressed: () => context.pop(),
            ),
          ),
          body: insight == null
              ? Center(
                  child: Text(
                    l10n.productNotFound,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: context.savingor.textSecondary,
                    ),
                  ),
                )
              : _buildContent(
                  context,
                  insight,
                  bottomInset,
                  l10n,
                ),
        );
      },
    );
  }

  Widget _buildContent(
    BuildContext context,
    ProductPriceInsight insight,
    double bottomInset,
    AppLocalizations l10n,
  ) {
    final String productName = _productDisplayName(context, insight);

    return ListView(
      padding: EdgeInsets.fromLTRB(20, 8, 20, 24 + bottomInset),
      children: <Widget>[
        Container(
          padding: const EdgeInsets.all(18),
          decoration: _cardDecoration(context),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                productName,
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w800,
                  color: SavingorWorkflowTheme.headingText(context),
                ),
              ),
              const SizedBox(height: 10),
              _summaryLine(
                context,
                l10n.latestPriceLabel,
                l10n.priceAtStore(
                  PriceMemoryFormatters.formatPrice(
                    insight.latestPrice,
                    currency: insight.currency,
                  ),
                  insight.latestStoreName,
                ),
              ),
              const SizedBox(height: 6),
              _summaryLine(
                context,
                l10n.bestKnownLabel,
                l10n.priceAtStore(
                  PriceMemoryFormatters.formatPrice(
                    insight.lowestPrice,
                    currency: insight.currency,
                  ),
                  insight.lowestStoreName,
                ),
              ),
              const SizedBox(height: 6),
              _summaryLine(
                context,
                l10n.highestPriceLabel,
                PriceMemoryFormatters.formatPrice(
                  insight.highestPrice,
                  currency: insight.currency,
                ),
              ),
              const SizedBox(height: 6),
              _summaryLine(
                context,
                l10n.averagePriceLabel,
                PriceMemoryFormatters.formatPrice(
                  insight.averagePrice,
                  currency: insight.currency,
                ),
              ),
              const SizedBox(height: 6),
              _summaryLine(
                context,
                l10n.recordsLabel,
                l10n.priceRecordCount(insight.recordCount),
              ),
            ],
          ),
        ),
        const SizedBox(height: SavingorSpacing.lg),
        ProductBuyingAdviceCard(
          productName: insight.displayName,
          records: insight.records,
          currency: insight.currency,
        ),
        const SizedBox(height: SavingorSpacing.lg),
        Text(
          l10n.priceHistory,
          style: SavingorAppTextStyles.sectionTitle(context),
        ),
        const SizedBox(height: SavingorSpacing.sm),
        Container(
          decoration: _cardDecoration(context),
          child: Column(
            children:
                List<Widget>.generate(insight.records.length, (int index) {
              final ProductPriceRecord record = insight.records[index];
              return Column(
                children: <Widget>[
                  if (index > 0)
                    Divider(
                      height: 1,
                      color: context.savingor.isDark
                          ? context.savingor.divider.withOpacity(0.85)
                          : const Color(0xFFF3F4F3).withOpacity(0.8),
                    ),
                  _historyRow(context, record, l10n),
                ],
              );
            }),
          ),
        ),
      ],
    );
  }

  Widget _summaryLine(BuildContext context, String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        SizedBox(
          width: 72,
          child: Text(
            label,
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: context.savingor.textSecondary,
            ),
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w700,
              color: SavingorWorkflowTheme.primaryText(context),
            ),
          ),
        ),
      ],
    );
  }

  Widget _historyRow(
    BuildContext context,
    ProductPriceRecord record,
    AppLocalizations l10n,
  ) {
    final String quantityLabel =
        record.quantity == record.quantity.roundToDouble()
            ? record.quantity.toInt().toString()
            : record.quantity.toStringAsFixed(2);

    final List<String> detailParts = <String>[
      l10n.quantityLabelWithCount(quantityLabel),
      if (record.unit != null && record.unit!.trim().isNotEmpty)
        record.unit!.trim(),
      if (record.category != null && record.category!.trim().isNotEmpty)
        record.category!.trim(),
    ];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  LocaleDateFormat.formatMediumDate(
                      context, record.purchaseDate),
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: SavingorWorkflowTheme.primaryText(context),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  record.storeName,
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: SavingorWorkflowTheme.primaryText(context)
                        .withOpacity(0.82),
                  ),
                ),
                if (detailParts.isNotEmpty) ...<Widget>[
                  const SizedBox(height: 4),
                  Text(
                    detailParts.join(' · '),
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: context.savingor.textSecondary,
                    ),
                  ),
                ],
                const SizedBox(height: 8),
                _PriceHistorySourceBadge(source: record.source),
              ],
            ),
          ),
          Text(
            PriceMemoryFormatters.formatPrice(
              record.totalPrice,
              currency: record.currency,
            ),
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w800,
              color: SavingorWorkflowTheme.accentText(context),
            ),
          ),
        ],
      ),
    );
  }
}

/// Price-history source badge — dark theme uses elevated surface; light unchanged.
class _PriceHistorySourceBadge extends StatelessWidget {
  const _PriceHistorySourceBadge({required this.source});

  final ReceiptSource source;

  @override
  Widget build(BuildContext context) {
    if (!context.savingor.isDark) {
      return ReceiptSourceBadge(source: source, compact: true);
    }

    final SavingorThemeExtension theme = context.savingor;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: theme.surfaceStrong,
        borderRadius: BorderRadius.circular(999),
        border: Border.all(
          color: theme.border.withOpacity(0.9),
          width: 0.75,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Icon(
            source.icon,
            size: 13,
            color: theme.brandHeading,
          ),
          const SizedBox(width: 4),
          Text(
            ReceiptL10n.sourceLabel(context, source),
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w700,
              color: theme.brandHeading,
            ),
          ),
        ],
      ),
    );
  }
}
