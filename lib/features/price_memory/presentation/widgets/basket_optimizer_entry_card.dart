import 'package:flutter/material.dart';

import 'package:savingor_app/core/theme/savingor_design_system.dart';
import 'package:savingor_app/core/widgets/savingor_interactive.dart';

class BasketOptimizerEntryCard extends StatelessWidget {
  const BasketOptimizerEntryCard({
    super.key,
    required this.onTap,
    this.title = 'Optimize my basket',
    this.subtitle =
        'Find the best known stores from your receipt history',
  });

  final VoidCallback onTap;
  final String title;
  final String subtitle;

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
              Icons.shopping_basket_outlined,
              color: SavingorColors.primaryStroke,
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w800,
                    color: SavingorColors.darkGreen,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: const TextStyle(
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
