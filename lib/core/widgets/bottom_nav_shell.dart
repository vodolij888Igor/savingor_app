import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:savingor_app/core/i18n/app_strings.dart';
import 'package:savingor_app/core/theme/savingor_design_system.dart';

class BottomNavShell extends StatelessWidget {
  const BottomNavShell({super.key, required this.child});

  final Widget child;

  int _indexFromLocation(String location) {
    if (location.contains('/deals')) return 0;
    if (location.contains('/scanner')) return 1;
    if (location.contains('/shopping')) return 2;
    if (location.contains('/analytics')) return 3;
    if (location.contains('/profile')) return 4;
    return 0;
  }

  void _onTabSelected(BuildContext context, int index) {
    switch (index) {
      case 0:
        context.go('/deals');
        break;
      case 1:
        context.go('/scanner');
        break;
      case 2:
        context.go('/shopping');
        break;
      case 3:
        context.go('/analytics');
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
    final AppStrings t = AppStrings.of(context);

    final List<_NavTabData> tabs = <_NavTabData>[
      _NavTabData(
        outlinedIcon: Icons.home_outlined,
        filledIcon: Icons.home_rounded,
        label: t.home,
        palette: _NavTabPalette.home,
      ),
      _NavTabData(
        outlinedIcon: Icons.receipt_long_outlined,
        filledIcon: Icons.receipt_long_rounded,
        label: t.receipts,
        palette: _NavTabPalette.receipts,
      ),
      _NavTabData(
        outlinedIcon: Icons.list_alt_outlined,
        filledIcon: Icons.list_alt_rounded,
        label: t.shopping,
        palette: _NavTabPalette.shopping,
      ),
      _NavTabData(
        outlinedIcon: Icons.insights_outlined,
        filledIcon: Icons.insights_rounded,
        label: t.analytics,
        palette: _NavTabPalette.analytics,
      ),
      _NavTabData(
        outlinedIcon: Icons.person_outline_rounded,
        filledIcon: Icons.person_rounded,
        label: t.profile,
        palette: _NavTabPalette.profile,
      ),
    ];

    return Scaffold(
      extendBody: true,
      backgroundColor: SavingorColors.background,
      body: child,
      bottomNavigationBar: _FloatingPremiumNavBar(
        currentIndex: currentIndex,
        tabs: tabs,
        onTabSelected: (int index) => _onTabSelected(context, index),
      ),
    );
  }
}

/// Soft fintech accent per tab — pastel fills, readable deep tones.
class _NavTabPalette {
  const _NavTabPalette({
    required this.accent,
    required this.deep,
    required this.pillTop,
    required this.pillBottom,
    required this.pillBorder,
  });

  final Color accent;
  final Color deep;
  final Color pillTop;
  final Color pillBottom;
  final Color pillBorder;

  Color get inactiveIcon => accent.withOpacity(0.72);
  Color get inactiveLabel => deep.withOpacity(0.78);
  Color get iconHalo => accent.withOpacity(0.14);

  static const _NavTabPalette home = _NavTabPalette(
    accent: Color(0xFF5BA352),
    deep: SavingorColors.darkGreen,
    pillTop: Color(0xFFEEF8EB),
    pillBottom: Color(0xFFD4EDD0),
    pillBorder: Color(0xFF9FD49A),
  );

  static const _NavTabPalette receipts = _NavTabPalette(
    accent: Color(0xFF5B8FD4),
    deep: Color(0xFF2E5F9E),
    pillTop: Color(0xFFEAF1FB),
    pillBottom: Color(0xFFD4E3F6),
    pillBorder: Color(0xFF9BB8E8),
  );

  static const _NavTabPalette shopping = _NavTabPalette(
    accent: Color(0xFFC4895A),
    deep: Color(0xFF9A6535),
    pillTop: Color(0xFFFFF5EB),
    pillBottom: Color(0xFFF5E4CF),
    pillBorder: Color(0xFFE0C49A),
  );

  static const _NavTabPalette analytics = _NavTabPalette(
    accent: Color(0xFF9B7BB8),
    deep: Color(0xFF6D4F87),
    pillTop: Color(0xFFF3EDF8),
    pillBottom: Color(0xFFE4D8EF),
    pillBorder: Color(0xFFC4AED6),
  );

  static const _NavTabPalette profile = _NavTabPalette(
    accent: Color(0xFF4A9E98),
    deep: Color(0xFF2A6B67),
    pillTop: Color(0xFFE8F6F5),
    pillBottom: Color(0xFFD0EBE9),
    pillBorder: Color(0xFF8EC9C4),
  );
}

class _NavTabData {
  const _NavTabData({
    required this.outlinedIcon,
    required this.filledIcon,
    required this.label,
    required this.palette,
  });

  final IconData outlinedIcon;
  final IconData filledIcon;
  final String label;
  final _NavTabPalette palette;
}

/// Floating bar with a color-shifting sliding pill per active tab.
class _FloatingPremiumNavBar extends StatelessWidget {
  const _FloatingPremiumNavBar({
    required this.currentIndex,
    required this.tabs,
    required this.onTabSelected,
  });

  final int currentIndex;
  final List<_NavTabData> tabs;
  final ValueChanged<int> onTabSelected;

  static const double _cardRadius = 24;
  static const double _barHeight = 74;
  static const Duration _animDuration = Duration(milliseconds: 320);

  @override
  Widget build(BuildContext context) {
    final double bottomSafe = MediaQuery.paddingOf(context).bottom;
    final _NavTabPalette activePalette = tabs[currentIndex].palette;

    return Padding(
      padding: EdgeInsets.fromLTRB(16, 0, 16, 10 + bottomSafe),
      child: DecoratedBox(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(_cardRadius),
          boxShadow: <BoxShadow>[
            BoxShadow(
              color: activePalette.accent.withOpacity(0.18),
              blurRadius: 26,
              offset: const Offset(0, 10),
              spreadRadius: -2,
            ),
            BoxShadow(
              color: Colors.black.withOpacity(0.07),
              blurRadius: 14,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(_cardRadius),
          child: Material(
            color: SavingorColors.card,
            child: SizedBox(
              height: _barHeight,
              child: LayoutBuilder(
                builder: (BuildContext context, BoxConstraints constraints) {
                  final double tabWidth =
                      constraints.maxWidth / tabs.length;
                  const double pillInset = 4;
                  final double pillWidth = tabWidth - pillInset * 2;
                  final double pillLeft =
                      currentIndex * tabWidth + pillInset;

                  return Stack(
                    clipBehavior: Clip.none,
                    alignment: Alignment.center,
                    children: <Widget>[
                      AnimatedPositioned(
                        duration: _animDuration,
                        curve: Curves.easeOutCubic,
                        left: pillLeft,
                        top: 7,
                        width: pillWidth,
                        height: _barHeight - 14,
                        child: AnimatedContainer(
                          duration: _animDuration,
                          curve: Curves.easeOutCubic,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(22),
                            gradient: LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: <Color>[
                                activePalette.pillTop,
                                activePalette.pillBottom,
                              ],
                            ),
                            border: Border.all(
                              color: activePalette.pillBorder,
                              width: 1.2,
                            ),
                            boxShadow: <BoxShadow>[
                              BoxShadow(
                                color: activePalette.accent.withOpacity(0.28),
                                blurRadius: 12,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children:
                            List<Widget>.generate(tabs.length, (int index) {
                          return Expanded(
                            child: _FloatingNavItem(
                              tab: tabs[index],
                              selected: currentIndex == index,
                              onTap: () => onTabSelected(index),
                              animationDuration: _animDuration,
                            ),
                          );
                        }),
                      ),
                    ],
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _FloatingNavItem extends StatelessWidget {
  const _FloatingNavItem({
    required this.tab,
    required this.selected,
    required this.onTap,
    required this.animationDuration,
  });

  final _NavTabData tab;
  final bool selected;
  final VoidCallback onTap;
  final Duration animationDuration;

  static const double _inactiveIconSize = 25;
  static const double _activeIconSize = 29;

  @override
  Widget build(BuildContext context) {
    final _NavTabPalette palette = tab.palette;

    return Semantics(
      button: true,
      selected: selected,
      label: tab.label,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(22),
          splashColor: palette.accent.withOpacity(0.22),
          highlightColor: Colors.transparent,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 9, horizontal: 2),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                SizedBox(
                  height: 38,
                  child: Center(
                    child: Stack(
                      alignment: Alignment.center,
                      children: <Widget>[
                        AnimatedContainer(
                          duration: animationDuration,
                          curve: Curves.easeOutCubic,
                          width: selected ? 40 : 34,
                          height: selected ? 40 : 34,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: selected
                                ? palette.accent.withOpacity(0.18)
                                : palette.iconHalo,
                          ),
                        ),
                        AnimatedScale(
                          scale: selected ? 1.1 : 1.0,
                          duration: animationDuration,
                          curve: Curves.easeOutBack,
                          child: AnimatedSwitcher(
                            duration: animationDuration,
                            switchInCurve: Curves.easeOutCubic,
                            switchOutCurve: Curves.easeInCubic,
                            transitionBuilder: (
                              Widget child,
                              Animation<double> animation,
                            ) {
                              return ScaleTransition(
                                scale: animation,
                                child: FadeTransition(
                                  opacity: animation,
                                  child: child,
                                ),
                              );
                            },
                            child: Icon(
                              selected ? tab.filledIcon : tab.outlinedIcon,
                              key: ValueKey<bool>(selected),
                              size: selected
                                  ? _activeIconSize
                                  : _inactiveIconSize,
                              color: selected
                                  ? palette.deep
                                  : palette.inactiveIcon,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 2),
                AnimatedDefaultTextStyle(
                  duration: animationDuration,
                  curve: Curves.easeOutCubic,
                  style: TextStyle(
                    fontSize: selected ? 12 : 11,
                    fontWeight:
                        selected ? FontWeight.w800 : FontWeight.w600,
                    color: selected
                        ? palette.deep
                        : palette.inactiveLabel,
                    letterSpacing: selected ? 0.18 : 0.04,
                    height: 1.15,
                  ),
                  child: Text(
                    tab.label,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.center,
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
