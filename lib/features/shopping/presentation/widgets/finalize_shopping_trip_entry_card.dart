import 'package:flutter/material.dart';

import 'package:savingor_app/core/theme/savingor_design_system.dart';
import 'package:savingor_app/core/widgets/savingor_interactive.dart';
import 'package:savingor_app/l10n/app_localizations.dart';

class FinalizeShoppingTripEntryCard extends StatelessWidget {
  const FinalizeShoppingTripEntryCard({
    super.key,
    required this.onTap,
  });

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final AppLocalizations l10n = AppLocalizations.of(context);

    return SavingorInteractiveCard(
      onTap: onTap,
      borderRadius: BorderRadius.circular(18),
      accentTint: SavingorColors.primaryStroke,
      borderColor: SavingorWorkflowTheme.inputBorder(context).withOpacity(0.6),
      padding: const EdgeInsets.all(16),
      child: Row(
        children: <Widget>[
          Container(
            width: 44,
            height: 44,
            decoration:
                SavingorWorkflowTheme.highlightCard(context, radius: 14),
            child: Icon(
              Icons.receipt_long_outlined,
              color: SavingorWorkflowTheme.accentText(context),
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  l10n.finalizeShoppingTrip,
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w800,
                    color: SavingorWorkflowTheme.primaryText(context),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  l10n.finalizeShoppingTripCardSubtitle,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: context.savingor.textSecondary,
                    height: 1.35,
                  ),
                ),
              ],
            ),
          ),
          Icon(
            Icons.chevron_right_rounded,
            color: context.savingor.textSecondary,
          ),
        ],
      ),
    );
  }
}
