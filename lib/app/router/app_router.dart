import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:savingor_app/core/app_state.dart';
import 'package:savingor_app/features/deals/domain/models/deal.dart';
import 'package:savingor_app/features/onboarding/presentation/screens/auth_screen.dart';
import 'package:savingor_app/features/onboarding/presentation/screens/language_select_screen.dart';
import 'package:savingor_app/features/onboarding/presentation/screens/mini_splash_screen.dart';
import 'package:savingor_app/features/onboarding/presentation/screens/splash_screen.dart';
import 'package:savingor_app/features/profile/presentation/screens/app_settings_screen.dart';
import 'package:savingor_app/features/profile/presentation/screens/edit_profile_screen.dart';
import 'package:savingor_app/features/profile/presentation/screens/profile_screen.dart';
import 'package:savingor_app/features/subscription/presentation/screens/subscription_screen.dart';
import 'package:savingor_app/features/deals/presentation/screens/deals_map_screen.dart';
import 'package:savingor_app/features/home/presentation/screens/home_dashboard_screen.dart';
import 'package:savingor_app/features/deals/presentation/screens/deal_details_screen.dart';
import 'package:savingor_app/features/scanner/presentation/screens/receipt_scanner_screen.dart';
import 'package:savingor_app/features/scanner/presentation/screens/create_receipt_screen.dart';
import 'package:savingor_app/features/scanner/presentation/screens/receipt_detail_screen.dart';
import 'package:savingor_app/features/receipts/domain/models/receipt_item.dart';
import 'package:savingor_app/features/receipts/domain/models/receipt_source.dart';
import 'package:savingor_app/features/scanner/domain/receipt_ocr_draft_mapper.dart';
import 'package:savingor_app/features/shopping/presentation/screens/shopping_lists_screen.dart';
import 'package:savingor_app/features/shopping/presentation/screens/shopping_list_detail_screen.dart';
import 'package:savingor_app/features/shopping/presentation/screens/create_shopping_list_screen.dart';
import 'package:savingor_app/features/shopping/presentation/screens/add_shopping_list_item_screen.dart';
import 'package:savingor_app/features/shopping/presentation/screens/finalize_shopping_trip_screen.dart';
import 'package:savingor_app/features/shopping/presentation/screens/select_list_to_finalize_screen.dart';
import 'package:savingor_app/features/deals/presentation/screens/saved_deals_screen.dart';
import 'package:savingor_app/features/start_saving/presentation/screens/start_saving_screen.dart';
import 'package:savingor_app/features/budget/presentation/screens/monthly_goal_budget_screen.dart';
import 'package:savingor_app/features/expenses/presentation/screens/add_grocery_expense_screen.dart';
import 'package:savingor_app/features/expenses/presentation/screens/expenses_screen.dart';
import 'package:savingor_app/features/analytics/presentation/screens/savings_analytics_screen.dart';
import 'package:savingor_app/features/price_memory/presentation/screens/product_price_insights_screen.dart';
import 'package:savingor_app/features/price_memory/presentation/screens/product_price_detail_screen.dart';
import 'package:savingor_app/features/price_memory/presentation/screens/savings_opportunities_screen.dart';
import 'package:savingor_app/features/price_memory/presentation/screens/basket_optimizer_screen.dart';
import 'package:savingor_app/features/price_memory/domain/models/savings_opportunity.dart';
import 'package:savingor_app/features/ai_assistant/presentation/screens/ai_savings_assistant_screen.dart';
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
          p.startsWith('/nearby-stores') ||
          p.startsWith('/start-saving') ||
          p.startsWith('/shopping') ||
          p.startsWith('/expenses') ||
          p.startsWith('/analytics') ||
          p.startsWith('/ai-assistant') ||
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
      GoRoute(
        path: '/shopping/list/:listId/finalize-trip',
        pageBuilder: (context, state) {
          final String listId = state.pathParameters['listId'] ?? '';
          return MaterialPage<void>(
            key: state.pageKey,
            child: FinalizeShoppingTripScreen(listId: listId),
          );
        },
      ),
      GoRoute(
        path: '/expenses/create',
        redirect: (context, state) => '/scanner/create',
      ),
      GoRoute(
        path: '/scanner/create',
        builder: (context, state) {
          final Object? extra = state.extra;
          if (extra is Map<String, dynamic>) {
            final Object? dateValue = extra['initialDate'];
            DateTime? initialDate;
            if (dateValue is DateTime) {
              initialDate = dateValue;
            }

            final Object? totalValue = extra['initialTotal'];
            double? initialTotal;
            if (totalValue is double) {
              initialTotal = totalValue;
            } else if (totalValue is num) {
              initialTotal = totalValue.toDouble();
            }

            final List<String> initialItemNames =
                (extra['initialItemNames'] as List<dynamic>?)
                        ?.map((dynamic item) => item.toString())
                        .toList(growable: false) ??
                    const <String>[];

            final List<ReceiptItem> initialItems =
                ReceiptOcrDraftMapper.itemsFromExtra(
              extra['initialItems'] as List<dynamic>?,
            );

            final Object? subtotalValue = extra['initialSubtotal'];
            double? initialSubtotal;
            if (subtotalValue is double) {
              initialSubtotal = subtotalValue;
            } else if (subtotalValue is num) {
              initialSubtotal = subtotalValue.toDouble();
            }

            final Object? taxValue = extra['initialTax'];
            double? initialTax;
            if (taxValue is double) {
              initialTax = taxValue;
            } else if (taxValue is num) {
              initialTax = taxValue.toDouble();
            }

            final ReceiptSource initialSource = _parseReceiptSource(
              extra['initialSource'] as String?,
            );

            return CreateReceiptScreen(
              receiptId: extra['receiptId'] as String?,
              initialStoreName: extra['initialStoreName'] as String?,
              initialDate: initialDate,
              initialTotal: initialTotal,
              initialCategory: extra['initialCategory'] as String?,
              initialNotes: extra['initialNotes'] as String?,
              initialOcrRawText: extra['initialOcrRawText'] as String?,
              initialStoreAddress: extra['initialStoreAddress'] as String?,
              initialItemNames: initialItemNames,
              initialItems: initialItems,
              initialSubtotal: initialSubtotal,
              initialTax: initialTax,
              initialSource: initialSource,
              isEditing: extra['isEditing'] == true,
            );
          }

          return const CreateReceiptScreen();
        },
      ),
      GoRoute(
        path: '/scanner/:receiptId',
        builder: (context, state) {
          final String receiptId = state.pathParameters['receiptId'] ?? '';
          return ReceiptDetailScreen(receiptId: receiptId);
        },
      ),
      GoRoute(
        path: '/expenses',
        builder: (context, state) => const ExpensesScreen(),
      ),
      GoRoute(
        path: '/shopping',
        builder: (context, state) => const ShoppingListsScreen(),
      ),
      GoRoute(
        path: '/analytics',
        builder: (context, state) => const SavingsAnalyticsScreen(),
      ),
      GoRoute(
        path: '/shopping/basket-optimizer',
        builder: (context, state) {
          final String? listId = state.uri.queryParameters['listId'];
          return BasketOptimizerScreen(listId: listId);
        },
      ),
      GoRoute(
        path: '/analytics/savings-opportunities',
        builder: (context, state) => const SavingsOpportunitiesScreen(),
      ),
      GoRoute(
        path: '/analytics/product-price-insights',
        builder: (context, state) => const ProductPriceInsightsScreen(),
        routes: <RouteBase>[
          GoRoute(
            path: 'detail',
            builder: (context, state) {
              final Object? extra = state.extra;
              if (extra is SavingsOpportunity) {
                return ProductPriceDetailScreen(
                  normalizedProductName: extra.normalizedProductName,
                  savingsOpportunity: extra,
                );
              }

              final String normalizedProductName = extra is String ? extra : '';
              return ProductPriceDetailScreen(
                normalizedProductName: normalizedProductName,
              );
            },
          ),
        ],
      ),
      GoRoute(
        path: '/saved',
        builder: (context, state) => const SavedDealsScreen(),
      ),
      ShellRoute(
        builder: (context, state, child) => BottomNavShell(child: child),
        routes: [
          GoRoute(
            path: '/deals',
            builder: (context, state) => const HomeDashboardScreen(),
          ),
          GoRoute(
            path: '/start-saving',
            builder: (context, state) => const StartSavingScreen(),
            routes: <RouteBase>[
              GoRoute(
                path: 'select-list-to-finalize',
                builder: (context, state) => const SelectListToFinalizeScreen(),
              ),
              GoRoute(
                path: 'monthly-goal-budget',
                builder: (context, state) => const MonthlyGoalBudgetScreen(),
              ),
            ],
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
            path: '/nearby-stores',
            builder: (context, state) => DealsMapScreen(),
          ),
          GoRoute(
            path: '/scanner',
            builder: (context, state) => const ReceiptScannerScreen(),
          ),
          GoRoute(
            path: '/ai-assistant',
            builder: (context, state) => const AiSavingsAssistantScreen(),
          ),
          GoRoute(
            path: '/profile',
            builder: (context, state) => const ProfileScreen(),
            routes: [
              GoRoute(
                path: 'edit',
                builder: (context, state) => const EditProfileScreen(),
              ),
              // Nested like edit — BottomNavShell hides the bar for
              // /profile/settings (not an exact main-tab path).
              GoRoute(
                path: 'settings',
                builder: (context, state) => const AppSettingsScreen(),
                routes: <RouteBase>[
                  GoRoute(
                    path: 'language',
                    builder: (context, state) => const LanguageSelectScreen(
                      mode: LanguageSelectMode.settings,
                    ),
                  ),
                ],
              ),
            ],
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

ReceiptSource _parseReceiptSource(String? value) {
  return ReceiptSource.fromValue(value);
}
