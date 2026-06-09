import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:savingor_app/core/theme/savingor_design_system.dart';
import 'package:savingor_app/core/widgets/savingor_interactive.dart';
import 'package:savingor_app/features/analytics/domain/models/product_savings_insight.dart';
import 'package:savingor_app/features/analytics/domain/models/savings_summary.dart';

class SavingsValueSection extends StatelessWidget {
  const SavingsValueSection({
    super.key,
    required this.summary,
    required this.formatCurrency,
    this.proPaybackOnly = false,
  });

  final SavingsSummary summary;
  final String Function(double amount) formatCurrency;
  final bool proPaybackOnly;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        const Text(
          'Savings value',
          style: SavingorAppTextStyles.sectionTitle,
        ),
        const SizedBox(height: SavingorSpacing.md),
        if (!summary.hasCalculableData)
          _buildEmptyState()
        else if (proPaybackOnly)
          _SubscriptionRoiCard(
            summary: summary,
            formatCurrency: formatCurrency,
          )
        else ...<Widget>[
          Row(
            children: <Widget>[
              Expanded(
                child: _SavingsMetricCard(
                  label: 'Estimated saved',
                  subtitle: 'Estimated saved vs your average price',
                  value: formatCurrency(summary.estimatedSavedThisMonth),
                  icon: Icons.savings_outlined,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _SavingsMetricCard(
                  label: 'Potential missed',
                  subtitle: 'Potential savings missed',
                  value: formatCurrency(summary.potentialMissedThisMonth),
                  icon: Icons.trending_down_outlined,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          _SubscriptionRoiCard(
            summary: summary,
            formatCurrency: formatCurrency,
          ),
          const SizedBox(height: 12),
          _SavingsProgressCard(
            summary: summary,
            formatCurrency: formatCurrency,
          ),
        ],
      ],
    );
  }

  Widget _buildEmptyState() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFFF3F4F3).withOpacity(0.6)),
      ),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Icon(
            Icons.insights_outlined,
            color: SavingorColors.primaryStroke,
            size: 28,
          ),
          SizedBox(height: 12),
          Text(
            'Add more receipts to calculate your savings value.',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: SavingorColors.textSecondary,
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }
}

class TopSavingsProductsSection extends StatelessWidget {
  const TopSavingsProductsSection({
    super.key,
    required this.products,
    required this.formatCurrency,
  });

  final List<ProductSavingsInsight> products;
  final String Function(double amount) formatCurrency;

  @override
  Widget build(BuildContext context) {
    if (products.isEmpty) {
      return const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        const Text(
          'Top savings products',
          style: SavingorAppTextStyles.sectionTitle,
        ),
        const SizedBox(height: SavingorSpacing.md),
        ...products.map(
          (ProductSavingsInsight product) => Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: _ProductInsightCard(
              product: product,
              formatCurrency: formatCurrency,
            ),
          ),
        ),
      ],
    );
  }
}

class _SavingsMetricCard extends StatelessWidget {
  const _SavingsMetricCard({
    required this.label,
    required this.subtitle,
    required this.value,
    required this.icon,
  });

  final String label;
  final String subtitle;
  final String value;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFFF3F4F3).withOpacity(0.6)),
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 12,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Icon(icon, size: 22, color: SavingorAccentColors.savings),
          const SizedBox(height: 10),
          Text(
            label,
            style: SavingorAppTextStyles.bodySecondary(fontSize: 12).copyWith(
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            subtitle,
            style: const TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w500,
              color: SavingorColors.textSecondary,
              height: 1.3,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w800,
              color: Color(0xFF111827),
              letterSpacing: -0.3,
            ),
          ),
        ],
      ),
    );
  }
}

class _SubscriptionRoiCard extends StatelessWidget {
  const _SubscriptionRoiCard({
    required this.summary,
    required this.formatCurrency,
  });

  final SavingsSummary summary;
  final String Function(double amount) formatCurrency;

  @override
  Widget build(BuildContext context) {
    final double subscriptionPrice = summary.subscriptionPrice;
    final double saved = summary.estimatedSavedThisMonth;
    final bool paidFor = summary.subscriptionIsPaidFor;

    final String title = paidFor ? 'Pro paid for itself' : 'Pro payback';
    final String mainValue = paidFor
        ? '+${formatCurrency(summary.monthlyRoiAmount)} after subscription'
        : '${formatCurrency(saved)} of ${formatCurrency(subscriptionPrice)} covered';
    final String subtitle = paidFor
        ? 'Return: ${summary.monthlyRoiMultiplier?.toStringAsFixed(1) ?? '1.0'}x this month'
        : 'Need ${formatCurrency(summary.subscriptionRemainingAmount)} more to cover Pro';

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: SavingorSurfaces.premiumCard(),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            width: 40,
            height: 40,
            decoration: SavingorSurfaces.accentIconBlock(
              accent: SavingorAccentColors.budget,
            ),
            child: const Icon(
              Icons.workspace_premium_outlined,
              color: SavingorAccentColors.budget,
              size: 22,
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  title,
                  style: SavingorAppTextStyles.bodySecondary(fontSize: 12).copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  mainValue,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                    color: Color(0xFF111827),
                    letterSpacing: -0.3,
                    height: 1.25,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  subtitle,
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: SavingorColors.textSecondary,
                    height: 1.3,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _SavingsProgressCard extends StatelessWidget {
  const _SavingsProgressCard({
    required this.summary,
    required this.formatCurrency,
  });

  final SavingsSummary summary;
  final String Function(double amount) formatCurrency;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFFF3F4F3).withOpacity(0.6)),
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 12,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          const Row(
            children: <Widget>[
              Icon(
                Icons.trending_up_outlined,
                color: SavingorAccentColors.savings,
                size: 22,
              ),
              SizedBox(width: 10),
              Text(
                'Savings progress',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: SavingorColors.textPrimary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          _ProgressMetricRow(
            label: 'Estimated saved this month',
            value: formatCurrency(summary.estimatedSavedThisMonth),
            valueColor: SavingorAccentColors.savings,
          ),
          const SizedBox(height: 10),
          _ProgressMetricRow(
            label: 'Potential savings found',
            value: formatCurrency(summary.potentialMissedThisMonth),
            valueColor: SavingorAccentColors.budget,
          ),
          const SizedBox(height: 14),
          const Text(
            'Set a personal monthly savings target later based on your grocery budget.',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: SavingorColors.textSecondary,
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }
}

class _ProgressMetricRow extends StatelessWidget {
  const _ProgressMetricRow({
    required this.label,
    required this.value,
    required this.valueColor,
  });

  final String label;
  final String value;
  final Color valueColor;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Expanded(
          child: Text(
            label,
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w500,
              color: SavingorColors.textSecondary,
              height: 1.3,
            ),
          ),
        ),
        const SizedBox(width: 12),
        Text(
          value,
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w800,
            color: valueColor,
          ),
        ),
      ],
    );
  }
}

class _ProductInsightCard extends StatelessWidget {
  const _ProductInsightCard({
    required this.product,
    required this.formatCurrency,
  });

  final ProductSavingsInsight product;
  final String Function(double amount) formatCurrency;

  static const Color _airyBorder = Color(0xFFF3F4F3);

  @override
  Widget build(BuildContext context) {
    return SavingorInteractiveCard(
      onTap: () => _openProductDetail(context),
      borderRadius: BorderRadius.circular(18),
      accentTint: SavingorAccentColors.savings,
      borderColor: _airyBorder.withOpacity(0.6),
      padding: const EdgeInsets.all(16),
      child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Expanded(
                      child: Text(
                        product.displayName,
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w800,
                          color: Color(0xFF111827),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    const Icon(
                      Icons.chevron_right_rounded,
                      color: SavingorColors.textSecondary,
                      size: 22,
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Text(
                  '${product.recordCount} price ${product.recordCount == 1 ? 'record' : 'records'}',
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: SavingorColors.textSecondary,
                  ),
                ),
                const SizedBox(height: 12),
                if (product.estimatedSaved > 0)
                  _ProductMetricRow(
                    label: 'Estimated saved vs your average price',
                    value: formatCurrency(product.estimatedSaved),
                    valueColor: SavingorAccentColors.savings,
                  ),
                if (product.potentialMissed > 0) ...<Widget>[
                  if (product.estimatedSaved > 0) const SizedBox(height: 8),
                  _ProductMetricRow(
                    label: 'Potential savings missed',
                    value: formatCurrency(product.potentialMissed),
                    valueColor: SavingorAccentColors.budget,
                  ),
                ],
                const SizedBox(height: 12),
                Wrap(
                  spacing: 16,
                  runSpacing: 6,
                  children: <Widget>[
                    _PriceChip(
                      label: 'Latest paid',
                      value: formatCurrency(product.latestPaidPrice),
                    ),
                    _PriceChip(
                      label: 'Best known',
                      value: formatCurrency(product.bestKnownPrice),
                    ),
                    _PriceChip(
                      label: 'Average',
                      value: formatCurrency(product.averageKnownPrice),
                    ),
                  ],
                ),
                if (product.latestStore != null ||
                    product.bestStore != null) ...<Widget>[
                  const SizedBox(height: 10),
                  if (product.latestStore != null)
                    Text(
                      'Latest: ${product.latestStore}',
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: SavingorColors.textSecondary,
                      ),
                    ),
                  if (product.bestStore != null)
                    Text(
                      'Best price at: ${product.bestStore}',
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: SavingorColors.textSecondary,
                      ),
                    ),
                ],
              ],
      ),
    );
  }

  void _openProductDetail(BuildContext context) {
    final String normalizedName = product.normalizedName.trim();
    if (normalizedName.isEmpty) {
      return;
    }

    context.push(
      '/analytics/product-price-insights/detail',
      extra: normalizedName,
    );
  }

}

class _ProductMetricRow extends StatelessWidget {
  const _ProductMetricRow({
    required this.label,
    required this.value,
    required this.valueColor,
  });

  final String label;
  final String value;
  final Color valueColor;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Expanded(
          child: Text(
            label,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: SavingorColors.textSecondary,
              height: 1.3,
            ),
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w800,
            color: valueColor,
          ),
        ),
      ],
    );
  }
}

class _PriceChip extends StatelessWidget {
  const _PriceChip({
    required this.label,
    required this.value,
  });

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          label,
          style: const TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w500,
            color: SavingorColors.textSecondary,
          ),
        ),
        Text(
          value,
          style: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w700,
            color: Color(0xFF111827),
          ),
        ),
      ],
    );
  }
}
