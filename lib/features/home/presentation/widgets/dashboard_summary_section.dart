import 'package:flutter/material.dart';

import 'package:savingor_app/core/theme/savingor_design_system.dart';
import 'package:savingor_app/features/home/domain/home_dashboard_summary.dart';

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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        const Text(
          'Your savings snapshot',
          style: SavingorAppTextStyles.sectionTitleLarge,
        ),
        const SizedBox(height: SavingorSpacing.md),
        Row(
          children: <Widget>[
            Expanded(
              child: _SummaryMetricCard(
                icon: Icons.payments_outlined,
                label: 'This month spent',
                value: formatCurrency(summary.spentThisMonth),
                iconColor: SavingorAccentColors.expenses,
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: _SummaryMetricCard(
                icon: Icons.receipt_long_outlined,
                label: 'Receipts',
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
                label: 'Potential savings found',
                value: formatCurrency(summary.potentialSavingsFound),
                iconColor: SavingorColors.primaryStroke,
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: _SummaryMetricCard(
                icon: Icons.inventory_2_outlined,
                label: 'Products tracked',
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

  static const Color _airyBorder = Color(0xFFF3F4F3);
  static const Color _nearBlack = Color(0xFF111827);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: _airyBorder.withOpacity(0.6)),
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
          Icon(icon, size: 22, color: iconColor),
          const SizedBox(height: 10),
          Text(
            label,
            style: const TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: SavingorColors.textSecondary,
              height: 1.25,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            value,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w800,
              color: _nearBlack,
              letterSpacing: -0.3,
            ),
          ),
        ],
      ),
    );
  }
}
