import 'package:flutter/material.dart';

import 'package:savingor_app/core/theme/savingor_design_system.dart';
import 'package:savingor_app/core/widgets/savingor_interactive.dart';
import 'package:savingor_app/l10n/app_localizations.dart';

/// Radius filter chips for the nearby stores screen.
class NearbyRadiusSelector extends StatelessWidget {
  const NearbyRadiusSelector({
    super.key,
    required this.selectedRadiusKm,
    required this.radiusOptionsKm,
    required this.onRadiusSelected,
  });

  final double selectedRadiusKm;
  final List<double> radiusOptionsKm;
  final ValueChanged<double> onRadiusSelected;

  @override
  Widget build(BuildContext context) {
    final AppLocalizations l10n = AppLocalizations.of(context);

    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: radiusOptionsKm.map((double radiusKm) {
        final bool selected = selectedRadiusKm == radiusKm;
        return SavingorInteractivePressable(
          onTap: () => onRadiusSelected(radiusKm),
          borderRadius: BorderRadius.circular(20),
          liftOnHover: false,
          expandWidth: false,
          builder: (BuildContext context, SavingorInteractionState state) {
            final SavingorThemeExtension theme = context.savingor;
            return AnimatedContainer(
              duration: SavingorInteraction.duration,
              curve: SavingorInteraction.curve,
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
              decoration: BoxDecoration(
                color: selected
                    ? theme.selectedHighlight
                    : state.pressed
                        ? theme.pressedHighlight
                        : state.hovered
                            ? theme.hoverHighlight
                            : theme.chipSurface,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: selected
                      ? theme.accentGreen.withOpacity(0.65)
                      : theme.border,
                  width: selected ? 1.25 : 1,
                ),
                boxShadow: state.hovered && !selected ? theme.cardShadow : null,
              ),
              child: Text(
                l10n.mapRadiusKm(radiusKm.round()),
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  color: selected ? theme.brandTitle : theme.textSecondary,
                ),
              ),
            );
          },
        );
      }).toList(),
    );
  }
}
