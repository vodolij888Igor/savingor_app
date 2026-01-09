import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class BottomNavShell extends StatelessWidget {
  final Widget child;

  const BottomNavShell({super.key, required this.child});

  int _indexFromLocation(String location) {
    if (location.startsWith('/deals')) return 0;
    if (location.startsWith('/scanner')) return 1;
    if (location.startsWith('/shopping')) return 2;
    return 0;
  }

  @override
  Widget build(BuildContext context) {
    final location = GoRouterState.of(context).uri.path;

    final currentIndex = _indexFromLocation(location);

    return Scaffold(
      body: child,
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: currentIndex,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.map), label: 'Deals'),
          BottomNavigationBarItem(
              icon: Icon(Icons.receipt_long), label: 'Scanner'),
          BottomNavigationBarItem(icon: Icon(Icons.list), label: 'Shopping'),
        ],
        onTap: (idx) {
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
          }
        },
      ),
    );
  }
}
