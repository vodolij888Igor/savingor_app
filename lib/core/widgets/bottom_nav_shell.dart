// ignore_for_file: prefer_const_constructors
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:savingor_app/core/i18n/app_strings.dart';

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

  @override
  Widget build(BuildContext context) {
    final location = GoRouterState.of(context).uri.path;

    final currentIndex = _indexFromLocation(location);

    final colorScheme = Theme.of(context).colorScheme;
    final t = AppStrings.of(context);

    return Scaffold(
      body: child,
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        backgroundColor: colorScheme.surface,
        elevation: 8,
        selectedItemColor: colorScheme.primary,
        unselectedItemColor: Colors.black54,
        selectedIconTheme: IconThemeData(color: colorScheme.primary),
        unselectedIconTheme: const IconThemeData(color: Colors.black54),
        currentIndex: currentIndex,
        items: [
          BottomNavigationBarItem(icon: const Icon(Icons.map), label: t.deals),
          BottomNavigationBarItem(
              icon: const Icon(Icons.receipt_long), label: t.scanner),
          BottomNavigationBarItem(
              icon: const Icon(Icons.list), label: t.shopping),
          BottomNavigationBarItem(
              icon: const Icon(Icons.favorite), label: t.saved),
          BottomNavigationBarItem(
              icon: const Icon(Icons.person), label: 'Profile'),
        ],
        onTap: (idx) {
          switch (idx) {
            case 0:
              context.go('/app/deals');
              break;
            case 1:
              context.go('/app/scanner');
              break;
            case 2:
              context.go('/app/shopping');
              break;
            case 3:
              context.go('/app/saved');
              break;
            case 4:
              context.go('/app/profile');
              break;
          }
        },
      ),
    );
  }
}
