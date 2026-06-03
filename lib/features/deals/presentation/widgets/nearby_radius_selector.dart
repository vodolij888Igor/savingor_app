import 'package:flutter/material.dart';

import 'package:savingor_app/core/theme/savingor_design_system.dart';

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
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: radiusOptionsKm.map((double radiusKm) {
        final bool selected = selectedRadiusKm == radiusKm;
        return Material(
          color: selected
              ? SavingorColors.primaryStroke.withOpacity(0.14)
              : Colors.white,
          borderRadius: BorderRadius.circular(20),
          child: InkWell(
            onTap: () => onRadiusSelected(radiusKm),
            borderRadius: BorderRadius.circular(20),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: selected
                      ? SavingorColors.primaryStroke.withOpacity(0.45)
                      : const Color(0xFFE8ECE9),
                ),
              ),
              child: Text(
                '${radiusKm.round()} km',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  color: selected
                      ? SavingorColors.darkGreen
                      : SavingorColors.textSecondary,
                ),
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}
