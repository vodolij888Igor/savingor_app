import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../domain/models/deal.dart';
import '../presentation/screens/home/home_screen.dart';
import '../presentation/screens/home/deals_map/deals_map_screen.dart';
import '../presentation/screens/home/deals_map/deal_details_screen.dart';
import '../presentation/screens/receipt_scanner/receipt_scanner_screen.dart';
import '../presentation/screens/shopping_list/shopping_list_screen.dart';
import '../presentation/widgets/bottom_nav_shell.dart';
import '../data/mock/mock_deals.dart';

final GoRouter appRouter = GoRouter(
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const HomeScreen(),
    ),
    ShellRoute(
      builder: (context, state, child) => BottomNavShell(child: child),
      routes: [
        GoRoute(
          path: '/deals',
          builder: (context, state) => const DealsMapScreen(),
        ),
        GoRoute(
          path: '/deals/:id',
          builder: (context, state) {
            final uri = state.uri;
            final id = uri.pathSegments.isNotEmpty ? uri.pathSegments.last : '';
            Deal? deal;
            try {
              deal = mockDeals.firstWhere((d) => d.id == id);
            } catch (e) {
              deal = null;
            }

            if (deal == null) {
              return Scaffold(
                appBar: AppBar(title: const Text('Deal Details')),
                body: const Center(child: Text('Deal not found')),
              );
            }

            return DealDetailsScreen(deal: deal);
          },
        ),
        GoRoute(
          path: '/scanner',
          builder: (context, state) => const ReceiptScannerScreen(),
        ),
        GoRoute(
          path: '/shopping',
          builder: (context, state) => const ShoppingListScreen(),
        ),
      ],
    ),
  ],
);
