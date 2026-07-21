import 'package:flutter/material.dart';
import 'package:savingor_app/core/theme/savingor_design_system.dart';
import 'package:savingor_app/features/scanner/domain/models/smart_receipt.dart';
import 'package:savingor_app/l10n/app_localizations.dart';

class SmartReceiptReviewBanner extends StatelessWidget {
  const SmartReceiptReviewBanner({
    super.key,
    required this.provenance,
    this.fallbackReason,
    this.warningCodes = const <String>[],
  });

  final SmartReceiptProvenance provenance;
  final SmartReceiptFailureKind? fallbackReason;
  final List<String> warningCodes;

  @override
  Widget build(BuildContext context) {
    final AppLocalizations l10n = AppLocalizations.of(context);
    final bool enhanced = provenance == SmartReceiptProvenance.aiEnhanced;
    final List<String> warnings =
        SmartReceiptWarningPresenter.messages(l10n, warningCodes);
    final String status =
        enhanced ? l10n.smartReceiptAiEnhanced : l10n.smartReceiptLocalParser;
    final String description = enhanced
        ? l10n.smartReceiptAiEnhancedDescription
        : _fallbackDescription(l10n);

    return Semantics(
      container: true,
      label: '$status. ${l10n.smartReceiptReviewTitle}. $description',
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: enhanced
              ? SavingorColors.lightGreen.withOpacity(0.2)
              : context.savingor.surfaceElevated,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color: enhanced
                ? SavingorColors.primaryStroke.withOpacity(0.28)
                : context.savingor.border,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              children: <Widget>[
                Icon(
                  enhanced
                      ? Icons.auto_awesome_rounded
                      : Icons.receipt_long_outlined,
                  color: context.savingor.brandTitle,
                  size: 22,
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    status,
                    style: TextStyle(
                      color: context.savingor.textPrimary,
                      fontSize: 15,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              l10n.smartReceiptReviewTitle,
              style: TextStyle(
                color: context.savingor.textPrimary,
                fontSize: 14,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              description,
              style: TextStyle(
                color: context.savingor.textSecondary,
                height: 1.35,
              ),
            ),
            for (final String warning in warnings) ...<Widget>[
              const SizedBox(height: 10),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Icon(
                    Icons.info_outline_rounded,
                    size: 18,
                    color: context.savingor.textSecondary,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      warning,
                      style: TextStyle(
                        color: context.savingor.textSecondary,
                        height: 1.35,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }

  String _fallbackDescription(AppLocalizations l10n) {
    switch (fallbackReason) {
      case SmartReceiptFailureKind.quota:
        return l10n.smartReceiptLocalQuotaDescription;
      case SmartReceiptFailureKind.unauthenticated:
        return l10n.smartReceiptLocalSignInDescription;
      case SmartReceiptFailureKind.timeout:
      case SmartReceiptFailureKind.refusal:
      case SmartReceiptFailureKind.malformed:
      case SmartReceiptFailureKind.unavailable:
      case null:
        return l10n.smartReceiptLocalFallbackDescription;
    }
  }
}

abstract final class SmartReceiptWarningPresenter {
  static List<String> messages(
    AppLocalizations l10n,
    Iterable<String> warningCodes,
  ) {
    final Set<_WarningGroup> groups = <_WarningGroup>{};
    for (final String code in warningCodes) {
      if (code == 'IDENTIFIERS_REDACTED') {
        groups.add(_WarningGroup.privacy);
      } else if (code == 'ITEM_COUNT_TRUNCATED') {
        groups.add(_WarningGroup.items);
      } else if (code.contains('MISMATCH')) {
        groups.add(_WarningGroup.totals);
      } else if (code.startsWith('UNCERTAIN_') || code == 'OCR_AMBIGUOUS') {
        groups.add(_WarningGroup.uncertain);
      } else {
        groups.add(_WarningGroup.invalid);
      }
    }
    return <String>[
      if (groups.contains(_WarningGroup.uncertain))
        l10n.smartReceiptWarningUncertain,
      if (groups.contains(_WarningGroup.totals)) l10n.smartReceiptWarningTotals,
      if (groups.contains(_WarningGroup.invalid))
        l10n.smartReceiptWarningInvalid,
      if (groups.contains(_WarningGroup.privacy))
        l10n.smartReceiptWarningPrivacy,
      if (groups.contains(_WarningGroup.items)) l10n.smartReceiptWarningItems,
    ];
  }
}

enum _WarningGroup { uncertain, totals, invalid, privacy, items }
