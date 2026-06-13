import 'package:flutter/material.dart';

import 'package:savingor_app/core/theme/savingor_design_system.dart';
import 'package:savingor_app/features/home/domain/home_dashboard_summary.dart';
import 'package:savingor_app/l10n/app_localizations.dart';

class DashboardSummarySection extends StatelessWidget {
  const DashboardSummarySection({
    super.key,
    required this.summary,
    required this.formatCurrency,
  });

  final HomeDashboardSummary summary;
  final String Function(double amount) formatCurrency;

  @override
  Widget build(BuildContext context) {
    final AppLocalizations l10n = AppLocalizations.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          l10n.yourSavingsSnapshot,
          style: SavingorAppTextStyles.sectionTitleLarge,
        ),
        const SizedBox(height: SavingorSpacing.md),
        Row(
          children: <Widget>[
            Expanded(
              child: _SummaryMetricCard(
                icon: Icons.payments_outlined,
                label: l10n.thisMonthSpent,
                value: formatCurrency(summary.spentThisMonth),
                iconColor: SavingorAccentColors.expenses,
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: _SummaryMetricCard(
                icon: Icons.receipt_long_outlined,
                label: l10n.receipts,
                value: '${summary.receiptCount}',
                iconColor: const Color(0xFF5B8FA8),
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        Row(
          children: <Widget>[
            Expanded(
              child: _SummaryMetricCard(
                icon: Icons.savings_outlined,
                label: l10n.potentialSavingsFound,
                value: formatCurrency(summary.potentialSavingsFound),
                iconColor: SavingorColors.primaryStroke,
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: _SummaryMetricCard(
                icon: Icons.inventory_2_outlined,
                label: l10n.productsTracked,
                value: '${summary.productsTracked}',
                iconColor: const Color(0xFF8B6BA8),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _SummaryMetricCard extends StatelessWidget {
  const _SummaryMetricCard({
    required this.icon,
    required this.label,
    required this.value,
    required this.iconColor,
  });

  final IconData icon;
  final String label;
  final String value;
  final Color iconColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: SavingorSurfaces.premiumCard(radius: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Icon(icon, size: 18, color: iconColor),
          const SizedBox(height: 8),
          Text(
            label,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: SavingorColors.textSecondary,
              height: 1.25,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w800,
              color: SavingorColors.textPrimary,
              height: 1.1,
            ),
          ),
        ],
      ),
    );
  }
}
