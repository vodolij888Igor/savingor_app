import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:savingor_app/features/deals/domain/models/deal.dart';
// Home screen import removed (not used here)
import 'package:savingor_app/features/onboarding/presentation/screens/splash_screen.dart';
import 'package:savingor_app/features/onboarding/presentation/screens/language_select_screen.dart';
import 'package:savingor_app/features/onboarding/presentation/screens/auth_screen.dart';
import 'package:savingor_app/features/profile/presentation/screens/profile_screen.dart';
import 'package:savingor_app/features/deals/presentation/screens/deals_map_screen.dart';
import 'package:savingor_app/features/deals/presentation/screens/deal_details_screen.dart';
import 'package:savingor_app/features/scanner/presentation/screens/receipt_scanner_screen.dart';
import 'package:savingor_app/features/shopping/presentation/screens/shopping_list_screen.dart';
import 'package:savingor_app/features/deals/presentation/screens/saved_deals_screen.dart';
import 'package:savingor_app/core/widgets/bottom_nav_shell.dart';
import 'package:savingor_app/features/deals/data/mock_deals.dart';
import 'package:savingor_app/core/i18n/app_strings.dart';

final GoRouter appRouter = GoRouter(
  initialLocation: '/splash',
  // Android (and other platforms) may supply a non-/ defaultRouteName from
  // restoration or the engine; that would ignore initialLocation and open /deals.
  overridePlatformDefaultLocation: true,
  routes: [
    // onboarding routes
    GoRoute(
      path: '/splash',
      builder: (context, state) => const SplashScreen(),
    ),
    GoRoute(
      path: '/language',
      builder: (context, state) => const LanguageSelectScreen(),
    ),
    GoRoute(
      path: '/auth',
      builder: (context, state) => const AuthScreen(),
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
                appBar: AppBar(title: Text(AppStrings.of(context).dealDetails)),
                body: Center(child: Text(AppStrings.of(context).dealNotFound)),
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
          path: '/saved',
          builder: (context, state) => const SavedDealsScreen(),
        ),
        GoRoute(
          path: '/shopping',
          builder: (context, state) => const ShoppingListScreen(),
        ),
        GoRoute(
          path: '/profile',
          builder: (context, state) => const ProfileScreen(),
        ),
      ],
    ),
    // fallback to splash
    GoRoute(
      path: '/',
      builder: (context, state) => const SplashScreen(),
    ),
  ],
);
