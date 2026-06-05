import 'package:flutter/material.dart';

import 'package:savingor_app/core/theme/savingor_design_system.dart';
import 'package:savingor_app/features/receipts/domain/models/receipt_source.dart';

/// Compact source badge for receipt list and detail screens.
class ReceiptSourceBadge extends StatelessWidget {
  const ReceiptSourceBadge({
    super.key,
    required this.source,
    this.compact = false,
  });

  final ReceiptSource source;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    final double iconSize = compact ? 13 : 14;
    final double fontSize = compact ? 11 : 12;
    final EdgeInsets padding = compact
        ? const EdgeInsets.symmetric(horizontal: 8, vertical: 4)
        : const EdgeInsets.symmetric(horizontal: 10, vertical: 5);

    return Container(
      padding: padding,
      decoration: BoxDecoration(
        color: SavingorColors.lightGreen.withOpacity(0.45),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(
          color: SavingorColors.primaryStroke.withOpacity(0.25),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Icon(
            source.icon,
            size: iconSize,
            color: SavingorColors.primaryStroke,
          ),
          const SizedBox(width: 4),
          Text(
            source.label,
            style: TextStyle(
              fontSize: fontSize,
              fontWeight: FontWeight.w700,
              color: SavingorColors.primaryStroke,
            ),
          ),
        ],
      ),
    );
  }
}
