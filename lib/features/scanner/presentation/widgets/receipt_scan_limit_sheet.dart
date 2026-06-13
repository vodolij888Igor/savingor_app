import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:savingor_app/core/theme/savingor_design_system.dart';
import 'package:savingor_app/core/widgets/savingor_interactive.dart';
import 'package:savingor_app/l10n/app_localizations.dart';

/// Polished limit state when Free users have used all monthly scans.
abstract final class ReceiptScanLimitSheet {
  ReceiptScanLimitSheet._();

  static Future<void> show(BuildContext context) {
    return showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (BuildContext sheetContext) {
        return _ReceiptScanLimitSheetBody(
          onOpenPlans: () async {
            Navigator.of(sheetContext).pop();
            await context.push('/subscription');
          },
        );
      },
    );
  }
}

class _ReceiptScanLimitSheetBody extends StatelessWidget {
  const _ReceiptScanLimitSheetBody({required this.onOpenPlans});

  final VoidCallback onOpenPlans;

  @override
  Widget build(BuildContext context) {
    final AppLocalizations l10n = AppLocalizations.of(context);
    final SavingorThemeExtension theme = context.savingor;
    final double bottomInset = MediaQuery.paddingOf(context).bottom;

    return SafeArea(
      child: Padding(
        padding: EdgeInsets.fromLTRB(16, 0, 16, 12 + bottomInset),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(22),
          child: Container(
            padding: const EdgeInsets.fromLTRB(22, 22, 22, 24),
            decoration: theme.isDark
                ? BoxDecoration(
                    color: theme.surfaceStrong,
                    border: Border.all(color: theme.border, width: 0.75),
                    boxShadow: theme.cardShadow,
                  )
                : const BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: <Color>[
                        Color(0xFFF6FBF8),
                        Color(0xFFF0F9F4),
                        Color(0xFFFAFAF7),
                      ],
                    ),
                    border: Border.fromBorderSide(
                      BorderSide(color: Color(0x244F9D47), width: 0.75),
                    ),
                  ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        color: theme.isDark
                            ? theme.surfaceElevated
                            : SavingorColors.lightGreen,
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(
                          color: theme.isDark
                              ? theme.border.withOpacity(0.85)
                              : SavingorColors.primaryStroke.withOpacity(0.2),
                        ),
                      ),
                      child: Icon(
                        Icons.document_scanner_outlined,
                        color: theme.brandTitle,
                      ),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Text(
                        l10n.monthlyScanLimitTitle,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w800,
                          color: theme.textPrimary,
                          height: 1.2,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: SavingorSpacing.md),
                Text(
                  l10n.monthlyScanLimitDescription,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: theme.textSecondary,
                    height: 1.45,
                  ),
                ),
                const SizedBox(height: SavingorSpacing.xl),
                SavingorInteractiveFilledButton(
                  onPressed: onOpenPlans,
                  width: double.infinity,
                  borderRadius: BorderRadius.circular(18),
                  child: Text(l10n.unlockUnlimitedScansWithSavingorPro),
                ),
                const SizedBox(height: SavingorSpacing.sm),
                Center(
                  child: SavingorInteractiveTextButton(
                    onPressed: onOpenPlans,
                    foregroundColor: theme.brandTitle,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 8,
                    ),
                    child: Text(
                      l10n.viewProBenefits,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
