import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:savingor_app/core/app_state.dart';
import 'package:savingor_app/features/deals/domain/models/deal.dart';
import 'package:savingor_app/features/onboarding/presentation/screens/auth_screen.dart';
import 'package:savingor_app/features/onboarding/presentation/screens/language_select_screen.dart';
import 'package:savingor_app/features/onboarding/presentation/screens/mini_splash_screen.dart';
import 'package:savingor_app/features/onboarding/presentation/screens/splash_screen.dart';
import 'package:savingor_app/features/profile/presentation/screens/profile_screen.dart';
import 'package:savingor_app/features/subscription/presentation/screens/subscription_screen.dart';
import 'package:savingor_app/features/deals/presentation/screens/deals_map_screen.dart';
import 'package:savingor_app/features/deals/presentation/screens/deal_details_screen.dart';
import 'package:savingor_app/features/scanner/presentation/screens/receipt_scanner_screen.dart';
import 'package:savingor_app/features/shopping/presentation/screens/shopping_lists_screen.dart';
import 'package:savingor_app/features/shopping/presentation/screens/shopping_list_detail_screen.dart';
import 'package:savingor_app/features/shopping/presentation/screens/create_shopping_list_screen.dart';
import 'package:savingor_app/features/shopping/presentation/screens/add_shopping_list_item_screen.dart';
import 'package:savingor_app/features/deals/presentation/screens/saved_deals_screen.dart';
import 'package:savingor_app/features/start_saving/presentation/screens/start_saving_screen.dart';
import 'package:savingor_app/features/expenses/presentation/screens/add_grocery_expense_screen.dart';
import 'package:savingor_app/core/widgets/bottom_nav_shell.dart';
import 'package:savingor_app/features/deals/data/mock_deals.dart';
import 'package:savingor_app/core/i18n/app_strings.dart';

/// Built after [AppState] is hydrated so redirects can read prefs-backed flags.
GoRouter createAppRouter({required AppState appState}) {
  // TODO(auth-routing): Add session-aware branches (logged-in → shell, invalid session → /auth)
  // alongside [AppState] prefs flags. Do not remove language/onboarding gates until spec is aligned.
  return GoRouter(
    initialLocation: '/mini-splash',
    refreshListenable: appState,
    // Android (and other platforms) may supply a non-/ defaultRouteName from
    // restoration or the engine; that would ignore initialLocation and open /deals.
    overridePlatformDefaultLocation: true,
    redirect: (context, state) {
      if (!appState.isHydrated) return null;

      final path = state.uri.path;
      if (path == '/mini-splash') return null;
      if (path == '/language') return null;

      final lang = appState.language;
      final done = appState.onboardingCompleted;

      bool isShell(String p) =>
          p.startsWith('/deals') ||
          p.startsWith('/scanner') ||
          p.startsWith('/saved') ||
          p.startsWith('/shopping') ||
          p.startsWith('/profile') ||
          p.startsWith('/subscription');

      if (lang == null) {
        if (path == '/splash' || path == '/auth' || isShell(path)) {
          return '/language';
        }
        if (path == '/' || path.isEmpty) return '/mini-splash';
        return null;
      }

      if (path == '/splash' && done) return '/deals';
      if (isShell(path) && !done) return '/splash';
      if (path == '/auth' && !done) return '/splash';

      if (path == '/' || path.isEmpty) return '/mini-splash';

      return null;
    },
    routes: [
      GoRoute(
        path: '/mini-splash',
        builder: (context, state) => const MiniSplashScreen(),
      ),
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
      GoRoute(
        path: '/subscription',
        builder: (context, state) => const SubscriptionScreen(),
      ),
      GoRoute(
        path: '/start-saving/scan-receipt',
        builder: (context, state) => const ReceiptScannerScreen(),
      ),
      GoRoute(
        path: '/start-saving/shopping-list',
        builder: (context, state) =>
            const ShoppingListsScreen(showBackButton: true),
      ),
      GoRoute(
        path: '/add-grocery-expense',
        builder: (context, state) => const AddGroceryExpenseScreen(),
      ),
      GoRoute(
        path: '/start-saving',
        builder: (context, state) => const StartSavingScreen(),
      ),
      GoRoute(
        path: '/shopping/create',
        builder: (context, state) => const CreateShoppingListScreen(),
      ),
      GoRoute(
        path: '/shopping/list/:listId',
        pageBuilder: (context, state) {
          final String listId = state.pathParameters['listId'] ?? '';
          return MaterialPage<void>(
            key: state.pageKey,
            child: ShoppingListDetailScreen(listId: listId),
          );
        },
      ),
      GoRoute(
        path: '/shopping/list/:listId/add-item',
        pageBuilder: (context, state) {
          final String listId = state.pathParameters['listId'] ?? '';
          return MaterialPage<void>(
            key: state.pageKey,
            child: AddShoppingListItemScreen(listId: listId),
          );
        },
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
              final id =
                  uri.pathSegments.isNotEmpty ? uri.pathSegments.last : '';
              Deal? deal;
              try {
                deal = mockDeals.firstWhere((d) => d.id == id);
              } catch (e) {
                deal = null;
              }

              if (deal == null) {
                return Scaffold(
                  appBar:
                      AppBar(title: Text(AppStrings.of(context).dealDetails)),
                  body:
                      Center(child: Text(AppStrings.of(context).dealNotFound)),
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
            builder: (context, state) => const ShoppingListsScreen(),
          ),
          GoRoute(
            path: '/profile',
            builder: (context, state) => const ProfileScreen(),
          ),
        ],
      ),
      GoRoute(
        path: '/',
        builder: (context, state) => const MiniSplashScreen(),
      ),
    ],
  );
}
