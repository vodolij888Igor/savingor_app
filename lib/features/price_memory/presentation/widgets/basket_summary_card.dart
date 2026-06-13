import 'package:flutter/material.dart';

import 'package:savingor_app/core/theme/savingor_design_system.dart';
import 'package:savingor_app/features/price_memory/domain/models/basket_optimization_result.dart';
import 'package:savingor_app/features/price_memory/domain/price_memory_formatters.dart';
import 'package:savingor_app/l10n/app_localizations.dart';

class BasketSummaryCard extends StatelessWidget {
  const BasketSummaryCard({
    super.key,
    required this.result,
  });

  final BasketOptimizationResult result;

  @override
  Widget build(BuildContext context) {
    final AppLocalizations l10n = AppLocalizations.of(context);

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: SavingorWorkflowTheme.highlightCard(context),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            l10n.basketSummary,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w700,
              color: context.savingor.textSecondary,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: <Widget>[
              Expanded(
                child: _Metric(
                  label: l10n.estimatedBestTotal,
                  value: PriceMemoryFormatters.formatPrice(
                    result.estimatedBestTotal,
                    currency: result.currency,
                  ),
                ),
              ),
              Expanded(
                child: _Metric(
                  label: l10n.basketPotentialSaving,
                  value: result.totalPotentialSaving > 0
                      ? PriceMemoryFormatters.formatPrice(
                          result.totalPotentialSaving,
                          currency: result.currency,
                        )
                      : '—',
                  highlight: result.totalPotentialSaving > 0,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: <Widget>[
              Expanded(
                child: _Metric(
                  label: l10n.itemsMatched,
                  value: '${result.matchedItemsCount}',
                ),
              ),
              Expanded(
                child: _Metric(
                  label: l10n.noPriceHistoryLabel,
                  value: '${result.unmatchedItemsCount}',
                ),
              ),
            ],
          ),
          if (result.activeListsIncluded != null) ...<Widget>[
            const SizedBox(height: 12),
            _Metric(
              label: l10n.activeListsIncludedLabel,
              value: '${result.activeListsIncluded}',
            ),
          ],
        ],
      ),
    );
  }
}

class _Metric extends StatelessWidget {
  const _Metric({
    required this.label,
    required this.value,
    this.highlight = false,
  });

  final String label;
  final String value;
  final bool highlight;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: context.savingor.textSecondary,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w800,
            color: highlight
                ? SavingorWorkflowTheme.accentText(context)
                : SavingorWorkflowTheme.primaryText(context),
          ),
        ),
      ],
    );
  }
}
