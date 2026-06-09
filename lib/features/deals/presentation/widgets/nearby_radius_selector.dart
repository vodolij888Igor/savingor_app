import 'package:flutter/material.dart';



import 'package:savingor_app/core/theme/savingor_design_system.dart';

import 'package:savingor_app/core/widgets/savingor_interactive.dart';



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

        return SavingorInteractivePressable(

          onTap: () => onRadiusSelected(radiusKm),

          borderRadius: BorderRadius.circular(20),

          liftOnHover: false,

          expandWidth: false,

          builder: (BuildContext context, SavingorInteractionState state) {

            return AnimatedContainer(

              duration: SavingorInteraction.duration,

              curve: SavingorInteraction.curve,

              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),

              decoration: BoxDecoration(

                color: selected

                    ? SavingorColors.lightGreen

                    : state.pressed

                        ? SavingorInteraction.pressedBackgroundTint

                        : state.hovered

                            ? SavingorInteraction.hoverBackgroundTint

                            : Colors.white,

                borderRadius: BorderRadius.circular(20),

                border: Border.all(

                  color: selected

                      ? SavingorColors.primaryStroke.withOpacity(0.55)

                      : state.hovered

                          ? SavingorColors.primaryStroke.withOpacity(0.65)

                          : SavingorColors.border,

                  width: state.hovered && !selected ? 1.5 : 1,

                ),

                boxShadow: state.hovered && !selected

                    ? SavingorInteraction.cardShadow(hovered: true)

                    : null,

              ),

              child: Text(

                '${radiusKm.round()} km',

                style: TextStyle(

                  fontSize: 13,

                  fontWeight: FontWeight.w700,

                  color: selected

                      ? SavingorColors.primaryStroke

                      : SavingorColors.textSecondary,

                ),

              ),

            );

          },

        );

      }).toList(),

    );

  }

}


