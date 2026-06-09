import 'package:flutter/material.dart';

import 'package:savingor_app/core/theme/savingor_design_system.dart';
import 'package:savingor_app/core/widgets/savingor_interactive.dart';

/// Premium action row for the Start saving menu.
class StartSavingActionCard extends StatelessWidget {
  const StartSavingActionCard({
    super.key,
    required this.icon,
    required this.accentColor,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  final IconData icon;
  final Color accentColor;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  static const Color _titleCharcoal = Color(0xFF1F2933);
  static const Color _subtitleGray = Color(0xFF64748B);
  static const Color _cardBorder = Color(0xFFE2E6E1);

  static const double _cardRadius = 20;
  static const double _iconBadgeSize = 44;
  static const double _iconSize = 24;
  static const double _accentBarWidth = 4;

  @override
  Widget build(BuildContext context) {
    return SavingorInteractiveCard(
      onTap: onTap,
      borderRadius: BorderRadius.circular(_cardRadius),
      accentTint: accentColor,
      borderColor: _cardBorder,
      hoverBackgroundColor: const Color(0xFFFFFEFE),
      boxShadow: const <BoxShadow>[
        BoxShadow(
          color: Color(0x12000000),
          blurRadius: 14,
          offset: Offset(0, 4),
        ),
        BoxShadow(
          color: Color(0x06000000),
          blurRadius: 4,
          offset: Offset(0, 1),
        ),
      ],
      hoverBoxShadow: <BoxShadow>[
        BoxShadow(
          color: accentColor.withOpacity(0.14),
          blurRadius: 18,
          offset: const Offset(0, 6),
        ),
        const BoxShadow(
          color: Color(0x12000000),
          blurRadius: 12,
          offset: Offset(0, 3),
        ),
      ],
      child: ClipRRect(
        borderRadius: BorderRadius.circular(_cardRadius),
        child: IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Container(
                width: _accentBarWidth,
                color: accentColor,
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(14, 16, 12, 16),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Container(
                        width: _iconBadgeSize,
                        height: _iconBadgeSize,
                        decoration: BoxDecoration(
                          color: accentColor.withOpacity(0.13),
                          borderRadius: BorderRadius.circular(13),
                          border: Border.all(
                            color: accentColor.withOpacity(0.24),
                            width: 0.75,
                          ),
                        ),
                        child: Icon(
                          icon,
                          size: _iconSize,
                          color: accentColor,
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
                                fontSize: 16,
                                fontWeight: FontWeight.w800,
                                color: _titleCharcoal,
                                height: 1.2,
                                letterSpacing: -0.15,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              subtitle,
                              style: const TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w500,
                                color: _subtitleGray,
                                height: 1.35,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Icon(
                        Icons.chevron_right_rounded,
                        color: SavingorColors.textSecondary.withOpacity(0.55),
                        size: 22,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
