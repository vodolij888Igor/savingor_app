import 'package:flutter/material.dart';

import 'package:savingor_app/core/theme/savingor_design_system.dart';
import 'package:savingor_app/features/scanner/domain/models/monthly_receipt_scan_usage.dart';
import 'package:savingor_app/l10n/app_localizations.dart';

/// Compact monthly scan usage label for the receipt scanner screen.
class ReceiptScanUsageIndicator extends StatelessWidget {
  const ReceiptScanUsageIndicator({
    super.key,
    required this.usage,
    this.isLoading = false,
  });

  final MonthlyReceiptScanUsage? usage;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    final AppLocalizations l10n = AppLocalizations.of(context);
    final SavingorThemeExtension theme = context.savingor;

    if (isLoading) {
      return Padding(
        padding: const EdgeInsets.only(top: SavingorSpacing.sm),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            SizedBox(
              width: 14,
              height: 14,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                color: theme.textSecondary.withOpacity(0.8),
              ),
            ),
            const SizedBox(width: 8),
            Text(
              l10n.loadingScanUsage,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: theme.textSecondary,
              ),
            ),
          ],
        ),
      );
    }

    final MonthlyReceiptScanUsage? currentUsage = usage;
    if (currentUsage == null) {
      return const SizedBox.shrink();
    }

    if (currentUsage.hasUnlimitedScans) {
      return Padding(
        padding: const EdgeInsets.only(top: SavingorSpacing.sm),
        child: Text(
          l10n.unlimitedScansWithPro,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: theme.brandTitle.withOpacity(0.95),
          ),
        ),
      );
    }

    final String primaryLine = l10n.freeScansUsedThisMonth(
      currentUsage.usedCount,
      currentUsage.limit,
    );
    final String secondaryLine = currentUsage.remainingFreeScans == 0
        ? l10n.noFreeScansRemainingThisMonth
        : l10n.freeScansRemaining(currentUsage.remainingFreeScans);

    return Padding(
      padding: const EdgeInsets.only(top: SavingorSpacing.sm),
      child: Column(
        children: <Widget>[
          Text(
            primaryLine,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w700,
              color: theme.textSecondary,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            secondaryLine,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: currentUsage.isLimitReached
                  ? theme.brandTitle
                  : theme.textSecondary.withOpacity(0.92),
            ),
          ),
        ],
      ),
    );
  }
}
