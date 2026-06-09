import 'package:flutter/material.dart';

import 'package:savingor_app/core/theme/savingor_design_system.dart';
import 'package:savingor_app/core/widgets/savingor_interactive.dart';

class FinalizeShoppingTripEntryCard extends StatelessWidget {
  const FinalizeShoppingTripEntryCard({
    super.key,
    required this.onTap,
  });

  final VoidCallback onTap;

  static const Color _airyBorder = Color(0xFFF3F4F3);

  @override
  Widget build(BuildContext context) {
    return SavingorInteractiveCard(
      onTap: onTap,
      borderRadius: BorderRadius.circular(18),
      accentTint: SavingorColors.primaryStroke,
      borderColor: _airyBorder.withOpacity(0.6),
      padding: const EdgeInsets.all(16),
      child: Row(
        children: <Widget>[
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: SavingorColors.lightGreen,
              borderRadius: BorderRadius.circular(14),
            ),
            child: const Icon(
              Icons.receipt_long_outlined,
              color: SavingorColors.primaryStroke,
            ),
          ),
          const SizedBox(width: 14),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  'Finalize shopping trip',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w800,
                    color: SavingorColors.darkGreen,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  'Create a receipt from purchased items and update your price history',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: SavingorColors.textSecondary,
                    height: 1.35,
                  ),
                ),
              ],
            ),
          ),
          const Icon(
            Icons.chevron_right_rounded,
            color: SavingorColors.textSecondary,
          ),
        ],
      ),
    );
  }
}
