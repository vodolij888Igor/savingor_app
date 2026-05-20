// ignore_for_file: prefer_const_constructors
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:savingor_app/core/i18n/app_strings.dart';
import 'package:savingor_app/core/theme/savingor_design_system.dart';

class BottomNavShell extends StatelessWidget {
  final Widget child;

  const BottomNavShell({super.key, required this.child});

  int _indexFromLocation(String location) {
    if (location.contains('/deals')) return 0;
    if (location.contains('/scanner')) return 1;
    if (location.contains('/shopping')) return 2;
    if (location.contains('/saved')) return 3;
    if (location.contains('/profile')) return 4;
    return 0;
  }

  static const Color _navIndicator = Color(0xFFEAF5E8);

  @override
  Widget build(BuildContext context) {
    final String location = GoRouterState.of(context).uri.path;
    final int currentIndex = _indexFromLocation(location);
    final AppStrings t = AppStrings.of(context);

    return Scaffold(
      backgroundColor: SavingorColors.card,
      body: child,
      bottomNavigationBar: DecoratedBox(
        decoration: BoxDecoration(
          color: SavingorColors.card,
          border: Border(
            top: BorderSide(
              color: SavingorColors.border.withOpacity(0.5),
            ),
          ),
          boxShadow: <BoxShadow>[
            BoxShadow(
              color: SavingorColors.darkGreen.withOpacity(0.06),
              blurRadius: 20,
              offset: const Offset(0, -6),
            ),
          ],
        ),
        child: SafeArea(
          top: false,
          child: Theme(
            data: Theme.of(context).copyWith(
              navigationBarTheme: NavigationBarThemeData(
                height: 70,
                elevation: 0,
                backgroundColor: SavingorColors.card,
                indicatorColor: _navIndicator,
                surfaceTintColor: Colors.transparent,
                shadowColor: Colors.transparent,
                labelTextStyle: WidgetStateProperty.resolveWith<TextStyle?>(
                  (Set<WidgetState> states) {
                    if (states.contains(WidgetState.selected)) {
                      return const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: SavingorColors.darkGreen,
                        letterSpacing: 0.12,
                        height: 1.1,
                      );
                    }
                    return const TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w500,
                      color: Color(0xFF9CA3AF),
                      letterSpacing: 0.05,
                      height: 1.1,
                    );
                  },
                ),
              ),
            ),
            child: NavigationBar(
              selectedIndex: currentIndex,
              labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
              onDestinationSelected: (int idx) {
                switch (idx) {
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
                    context.go('/saved');
                    break;
                  case 4:
                    context.go('/profile');
                    break;
                }
              },
              destinations: <NavigationDestination>[
                NavigationDestination(
                  icon: const Icon(
                    Icons.map_outlined,
                    color: Color(0xFF9CA3AF),
                    size: 23,
                  ),
                  selectedIcon: const Icon(
                    Icons.map_rounded,
                    color: SavingorColors.darkGreen,
                    size: 24,
                  ),
                  label: t.deals,
                ),
                NavigationDestination(
                  icon: const Icon(
                    Icons.receipt_long_outlined,
                    color: Color(0xFF9CA3AF),
                    size: 23,
                  ),
                  selectedIcon: const Icon(
                    Icons.receipt_long_rounded,
                    color: SavingorColors.darkGreen,
                    size: 24,
                  ),
                  label: t.scanner,
                ),
                NavigationDestination(
                  icon: const Icon(
                    Icons.list_alt_outlined,
                    color: Color(0xFF9CA3AF),
                    size: 23,
                  ),
                  selectedIcon: const Icon(
                    Icons.list_alt_rounded,
                    color: SavingorColors.darkGreen,
                    size: 24,
                  ),
                  label: t.shopping,
                ),
                NavigationDestination(
                  icon: const Icon(
                    Icons.favorite_outline_rounded,
                    color: Color(0xFF9CA3AF),
                    size: 23,
                  ),
                  selectedIcon: const Icon(
                    Icons.favorite_rounded,
                    color: SavingorColors.darkGreen,
                    size: 24,
                  ),
                  label: t.saved,
                ),
                NavigationDestination(
                  icon: const Icon(
                    Icons.person_outline_rounded,
                    color: Color(0xFF9CA3AF),
                    size: 23,
                  ),
                  selectedIcon: const Icon(
                    Icons.person_rounded,
                    color: SavingorColors.darkGreen,
                    size: 24,
                  ),
                  label: 'Profile',
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
