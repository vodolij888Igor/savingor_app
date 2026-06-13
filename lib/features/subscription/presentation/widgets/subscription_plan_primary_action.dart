import 'package:flutter/material.dart';

import 'package:savingor_app/core/theme/savingor_design_system.dart';
import 'package:savingor_app/l10n/app_localizations.dart';

/// Primary plan action on the Plans screen: upgrade for Free, current plan for Pro.
class SubscriptionPlanPrimaryAction extends StatelessWidget {
  const SubscriptionPlanPrimaryAction({
    super.key,
    required this.isPro,
    required this.isActivating,
    required this.onUpgrade,
  });

  final bool isPro;
  final bool isActivating;
  final VoidCallback onUpgrade;

  @override
  Widget build(BuildContext context) {
    final AppLocalizations l10n = AppLocalizations.of(context);
    final SavingorThemeExtension theme = context.savingor;

    return SizedBox(
      width: double.infinity,
      height: 52,
      child: isPro
          ? OutlinedButton.icon(
              onPressed: null,
              style: OutlinedButton.styleFrom(
                disabledForegroundColor:
                    theme.isDark ? theme.brandTitle : SavingorColors.darkGreen,
                backgroundColor: theme.isDark
                    ? theme.surfaceElevated.withOpacity(0.65)
                    : theme.surfacePrimary.withOpacity(0.6),
                side: BorderSide(
                  color: theme.isDark
                      ? theme.accentGreen.withOpacity(0.45)
                      : SavingorColors.primaryStroke.withOpacity(0.5),
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(18),
                ),
                textStyle: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                ),
              ),
              icon: Icon(
                Icons.check_circle_rounded,
                size: 20,
                color: theme.isDark
                    ? theme.brandTitle
                    : SavingorColors.primaryStroke,
              ),
              label: Text(l10n.currentPlan),
            )
          : ElevatedButton(
              onPressed: isActivating ? null : onUpgrade,
              style: theme.isDark
                  ? SavingorButtonStyles.primaryFilledFor(context).merge(
                      ButtonStyle(
                        minimumSize: const WidgetStatePropertyAll<Size>(
                          Size.fromHeight(52),
                        ),
                        shape: WidgetStatePropertyAll<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(18),
                          ),
                        ),
                        textStyle: const WidgetStatePropertyAll<TextStyle>(
                          TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.w800,
                            letterSpacing: 0.1,
                          ),
                        ),
                      ),
                    )
                  : ElevatedButton.styleFrom(
                      elevation: 0,
                      shadowColor: Colors.transparent,
                      surfaceTintColor: Colors.transparent,
                      backgroundColor: SavingorColors.primaryGreen,
                      foregroundColor: SavingorColors.darkGreen,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18),
                        side: const BorderSide(
                          color: SavingorColors.primaryStroke,
                          width: 1,
                        ),
                      ),
                      textStyle: const TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 0.1,
                      ),
                    ),
              child: isActivating
                  ? SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: theme.isDark
                            ? theme.buttonLabelOnGreen
                            : SavingorColors.darkGreen,
                      ),
                    )
                  : Text(l10n.upgradeToSavingorPro),
            ),
    );
  }
}
