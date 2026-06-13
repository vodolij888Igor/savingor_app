import 'package:flutter/material.dart';

import 'package:savingor_app/core/theme/savingor_design_system.dart';
import 'package:savingor_app/l10n/app_localizations.dart';

/// Compact Pro label for premium feature entry cards.
class ProFeatureBadge extends StatelessWidget {
  const ProFeatureBadge({super.key});

  @override
  Widget build(BuildContext context) {
    final SavingorThemeExtension theme = context.savingor;
    final AppLocalizations l10n = AppLocalizations.of(context);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color:
            theme.isDark ? theme.selectedHighlight : SavingorColors.lightGreen,
        borderRadius: BorderRadius.circular(SavingorRadius.pill),
        border: Border.all(
          color: theme.isDark
              ? theme.accentGreen.withOpacity(0.35)
              : SavingorColors.primaryStroke.withOpacity(0.22),
        ),
      ),
      child: Text(
        l10n.pro,
        style: TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.w800,
          color: theme.isDark ? theme.brandTitle : SavingorColors.darkGreen,
          letterSpacing: 0.15,
        ),
      ),
    );
  }
}
