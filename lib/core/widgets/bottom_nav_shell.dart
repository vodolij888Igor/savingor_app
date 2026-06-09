import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:savingor_app/core/i18n/app_strings.dart';
import 'package:savingor_app/core/theme/savingor_design_system.dart';
import 'package:savingor_app/core/widgets/savingor_interactive.dart';

class BottomNavShell extends StatelessWidget {
  const BottomNavShell({super.key, required this.child});

  final Widget child;

  /// Main app-level destinations only — deeper workflow screens hide the bar.
  static const Set<String> _mainTabPaths = <String>{
    '/deals',
    '/start-saving',
    '/nearby-stores',
    '/scanner',
    '/ai-assistant',
    '/profile',
  };

  static bool shouldShowBottomNav(String location) {
    final String path = _normalizePath(location);
    return _mainTabPaths.contains(path);
  }

  static String _normalizePath(String location) {
    if (location.isEmpty) {
      return '/';
    }
    return location.endsWith('/') && location.length > 1
        ? location.substring(0, location.length - 1)
        : location;
  }

  int _indexFromLocation(String location) {
    if (location.startsWith('/start-saving')) return 0;
    if (location.startsWith('/deals')) return 0;
    if (location.startsWith('/nearby-stores')) return 1;
    if (location.startsWith('/scanner')) return 2;
    if (location.startsWith('/ai-assistant')) return 3;
    if (location.startsWith('/profile')) return 4;
    return 0;
  }

  void _onTabSelected(BuildContext context, int index) {
    switch (index) {
      case 0:
        context.go('/deals');
        break;
      case 1:
        context.go('/nearby-stores');
        break;
      case 2:
        context.go('/scanner');
        break;
      case 3:
        context.go('/ai-assistant');
        break;
      case 4:
        context.go('/profile');
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    final String location = GoRouterState.of(context).uri.path;
    final int currentIndex = _indexFromLocation(location);
    final bool showBottomNav = shouldShowBottomNav(location);
    final AppStrings t = AppStrings.of(context);

    return Scaffold(
      extendBody: showBottomNav,
      backgroundColor: SavingorColors.background,
      body: child,
      bottomNavigationBar: showBottomNav
          ? _PremiumNavBar(
              currentIndex: currentIndex,
              homeLabel: t.home,
              mapLabel: t.storesMap,
              aiLabel: t.aiAssistant,
              profileLabel: t.profile,
              onTabSelected: (int index) => _onTabSelected(context, index),
            )
          : null,
    );
  }
}

class _PremiumNavBar extends StatelessWidget {
  const _PremiumNavBar({
    required this.currentIndex,
    required this.homeLabel,
    required this.mapLabel,
    required this.aiLabel,
    required this.profileLabel,
    required this.onTabSelected,
  });

  final int currentIndex;
  final String homeLabel;
  final String mapLabel;
  final String aiLabel;
  final String profileLabel;
  final ValueChanged<int> onTabSelected;

  static const double _barHeight = 78;
  static const double _barRadius = 30;

  @override
  Widget build(BuildContext context) {
    final double bottomSafe = MediaQuery.paddingOf(context).bottom;

    return Padding(
      padding: EdgeInsets.fromLTRB(16, 0, 16, 10 + bottomSafe),
      child: Container(
        height: _barHeight,
        decoration: BoxDecoration(
          color: const Color(0xFFFFFEFE),
          borderRadius: BorderRadius.circular(_barRadius),
          border: Border.all(
            color: const Color(0xFFEEF1EF),
            width: 0.8,
          ),
          boxShadow: <BoxShadow>[
            BoxShadow(
              color: Colors.black.withOpacity(0.06),
              blurRadius: 16,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(_barRadius),
          child: Material(
            color: Colors.transparent,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Expanded(
                  child: _SideNavItem(
                    label: homeLabel,
                    outlinedIcon: Icons.home_outlined,
                    filledIcon: Icons.home_rounded,
                    selected: currentIndex == 0,
                    onTap: () => onTabSelected(0),
                  ),
                ),
                Expanded(
                  child: _SideNavItem(
                    label: mapLabel,
                    outlinedIcon: Icons.map_outlined,
                    filledIcon: Icons.map_rounded,
                    selected: currentIndex == 1,
                    onTap: () => onTabSelected(1),
                  ),
                ),
                Expanded(
                  child: _ScanReceiptNavItem(
                    selected: currentIndex == 2,
                    onTap: () => onTabSelected(2),
                  ),
                ),
                Expanded(
                  child: _SideNavItem(
                    label: aiLabel,
                    outlinedIcon: Icons.auto_awesome_outlined,
                    filledIcon: Icons.auto_awesome_rounded,
                    selected: currentIndex == 3,
                    onTap: () => onTabSelected(3),
                  ),
                ),
                Expanded(
                  child: _SideNavItem(
                    label: profileLabel,
                    outlinedIcon: Icons.person_outline_rounded,
                    filledIcon: Icons.person_rounded,
                    selected: currentIndex == 4,
                    onTap: () => onTabSelected(4),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _SideNavItem extends StatelessWidget {
  const _SideNavItem({
    required this.label,
    required this.outlinedIcon,
    required this.filledIcon,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final IconData outlinedIcon;
  final IconData filledIcon;
  final bool selected;
  final VoidCallback onTap;

  static const double _iconSize = 22;
  static const double _activeIconSize = 24;
  @override
  Widget build(BuildContext context) {
    return SavingorInteractivePressable(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      liftOnHover: false,
      hoverScale: 1.04,
      semanticLabel: label,
      builder: (BuildContext context, SavingorInteractionState state) {
        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            SizedBox(
              height: 36,
              child: Center(
                child: AnimatedContainer(
                  duration: SavingorInteraction.duration,
                  curve: SavingorInteraction.curve,
                  width: selected ? 38 : state.hovered ? 36 : 34,
                  height: selected ? 38 : state.hovered ? 36 : 34,
                  decoration: BoxDecoration(
                    color: selected
                        ? SavingorColors.lightGreen.withOpacity(0.62)
                        : state.hovered
                            ? SavingorColors.lightGreen.withOpacity(0.55)
                            : Colors.transparent,
                    borderRadius: BorderRadius.circular(12),
                    border: state.hovered && !selected
                        ? Border.all(
                            color: SavingorColors.primaryStroke.withOpacity(0.4),
                          )
                        : null,
                  ),
                  child: Icon(
                    selected ? filledIcon : outlinedIcon,
                    size: selected ? _activeIconSize : _iconSize,
                    color: selected
                        ? SavingorColors.darkGreen
                        : SavingorColors.textSecondary.withOpacity(0.82),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 3),
            Text(
              label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 11,
                fontWeight: selected ? FontWeight.w800 : FontWeight.w600,
                color: selected
                    ? SavingorColors.darkGreen
                    : SavingorColors.textSecondary.withOpacity(0.88),
                height: 1.15,
              ),
            ),
          ],
        );
      },
    );
  }
}

class _ScanReceiptNavItem extends StatelessWidget {
  const _ScanReceiptNavItem({
    required this.selected,
    required this.onTap,
  });

  final bool selected;
  final VoidCallback onTap;

  static const double _buttonWidth = 92;
  static const double _buttonHeight = 50;
  static const double _buttonRadius = 24;

  @override
  Widget build(BuildContext context) {
    return SavingorInteractivePressable(
      onTap: onTap,
      borderRadius: BorderRadius.circular(_buttonRadius),
      hoverScale: 1.02,
      semanticLabel: 'Scan receipt',
      builder: (BuildContext context, SavingorInteractionState state) {
        final bool hovered = state.hovered;

        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
          child: Center(
            child: AnimatedContainer(
              duration: SavingorInteraction.duration,
              curve: SavingorInteraction.curve,
              width: _buttonWidth,
              height: _buttonHeight,
              decoration: BoxDecoration(
                color: selected
                    ? SavingorColors.primaryGreen
                    : hovered
                        ? const Color(0xFF8DD480)
                        : SavingorColors.primaryGreen.withOpacity(0.88),
                borderRadius: BorderRadius.circular(_buttonRadius),
                border: Border.all(
                  color: SavingorColors.primaryStroke
                      .withOpacity(selected ? 0.24 : hovered ? 0.22 : 0.14),
                  width: 1.1,
                ),
                boxShadow: <BoxShadow>[
                  BoxShadow(
                    color: SavingorColors.primaryStroke
                        .withOpacity(hovered ? 0.2 : selected ? 0.18 : 0.1),
                    blurRadius: hovered ? 12 : 10,
                    offset: Offset(0, hovered ? 4 : 3),
                  ),
                ],
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Icon(
                    selected
                        ? Icons.document_scanner_rounded
                        : Icons.document_scanner_outlined,
                    size: 24,
                    color: SavingorColors.darkGreen,
                  ),
                  const SizedBox(height: 2),
                  Text(
                    'Scan receipt',
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 9,
                      fontWeight: selected ? FontWeight.w800 : FontWeight.w700,
                      color: SavingorColors.darkGreen,
                      height: 1.05,
                      letterSpacing: 0.01,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
