import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:savingor_app/core/i18n/app_strings.dart';
import 'package:savingor_app/features/ai_assistant/presentation/screens/ai_savings_assistant_screen.dart';
import 'package:savingor_app/features/analytics/presentation/screens/savings_analytics_screen.dart';
import 'package:savingor_app/features/budget/presentation/screens/monthly_goal_budget_screen.dart';
import 'package:savingor_app/features/deals/data/mock_deals.dart';
import 'package:savingor_app/features/deals/domain/models/deal.dart';
import 'package:savingor_app/features/deals/presentation/screens/deal_details_screen.dart';
import 'package:savingor_app/features/deals/presentation/screens/deals_map_screen.dart';
import 'package:savingor_app/features/deals/presentation/screens/saved_deals_screen.dart';
import 'package:savingor_app/features/expenses/presentation/screens/add_grocery_expense_screen.dart';
import 'package:savingor_app/features/expenses/presentation/screens/expenses_screen.dart';
import 'package:savingor_app/features/home/presentation/screens/home_dashboard_screen.dart';
import 'package:savingor_app/features/onboarding/presentation/screens/language_select_screen.dart';
import 'package:savingor_app/features/price_memory/domain/models/savings_opportunity.dart';
import 'package:savingor_app/features/price_memory/presentation/screens/basket_optimizer_screen.dart';
import 'package:savingor_app/features/price_memory/presentation/screens/product_price_detail_screen.dart';
import 'package:savingor_app/features/price_memory/presentation/screens/product_price_insights_screen.dart';
import 'package:savingor_app/features/price_memory/presentation/screens/savings_opportunities_screen.dart';
import 'package:savingor_app/features/profile/presentation/screens/app_settings_screen.dart';
import 'package:savingor_app/features/profile/presentation/screens/edit_profile_screen.dart';
import 'package:savingor_app/features/profile/presentation/screens/profile_screen.dart';
import 'package:savingor_app/features/receipts/domain/models/receipt_item.dart';
import 'package:savingor_app/features/receipts/domain/models/receipt_source.dart';
import 'package:savingor_app/features/scanner/domain/models/smart_receipt.dart';
import 'package:savingor_app/features/scanner/domain/receipt_ocr_draft_mapper.dart';
import 'package:savingor_app/features/scanner/presentation/screens/create_receipt_screen.dart';
import 'package:savingor_app/features/scanner/presentation/screens/receipt_detail_screen.dart';
import 'package:savingor_app/features/scanner/presentation/screens/receipt_scanner_screen.dart';
import 'package:savingor_app/features/shopping/presentation/screens/add_shopping_list_item_screen.dart';
import 'package:savingor_app/features/shopping/presentation/screens/create_shopping_list_screen.dart';
import 'package:savingor_app/features/shopping/presentation/screens/finalize_shopping_trip_screen.dart';
import 'package:savingor_app/features/shopping/presentation/screens/select_list_to_finalize_screen.dart';
import 'package:savingor_app/features/shopping/presentation/screens/shopping_list_detail_screen.dart';
import 'package:savingor_app/features/shopping/presentation/screens/shopping_lists_screen.dart';
import 'package:savingor_app/features/start_saving/presentation/screens/start_saving_screen.dart';
import 'package:savingor_app/features/subscription/presentation/screens/subscription_screen.dart';
import 'package:savingor_app/savingor/modules/groceries/groceries_module.dart';
import 'package:savingor_app/savingor/routing/platform_route_adapter.dart';
import 'package:savingor_app/savingor/routing/platform_route_binding.dart';
import 'package:savingor_app/savingor/routing/platform_route_binding_registry.dart';
import 'package:savingor_app/platform_prep/navigation/active_route_catalog.dart';
import 'package:savingor_app/platform_prep/navigation/route_contribution.dart';

/// Production Groceries route bindings for [PlatformRouteAdapter].
///
/// Maps every [groceriesModule] route contribution to an existing Savingor
/// screen builder. Not wired into [createAppRouter] yet.
final PlatformRouteBindingRegistry groceriesRouteBindings =
    PlatformRouteBindingRegistry(_buildGroceriesRouteBindings());

/// Builds a [PlatformRouteAdapter] for [catalog] using [groceriesRouteBindings].
PlatformRouteAdapter createGroceriesRouteAdapter(ActiveRouteCatalog catalog) {
  return PlatformRouteAdapter(
    catalog: catalog,
    bindings: groceriesRouteBindings,
  );
}

List<PlatformRouteBinding> _buildGroceriesRouteBindings() {
  final List<PlatformRouteBinding> bindings = <PlatformRouteBinding>[
    PlatformRouteBinding(
      routeName: 'deals',
      routePath: '/deals',
      builder: (BuildContext context) => const HomeDashboardScreen(),
    ),
    PlatformRouteBinding(
      routeName: 'deal-details',
      routePath: '/deals/:id',
      builder: _buildDealDetails,
    ),
    PlatformRouteBinding(
      routeName: 'start-saving',
      routePath: '/start-saving',
      builder: (BuildContext context) => const StartSavingScreen(),
    ),
    PlatformRouteBinding(
      routeName: 'start-saving-select-list-to-finalize',
      routePath: '/start-saving/select-list-to-finalize',
      builder: (BuildContext context) => const SelectListToFinalizeScreen(),
    ),
    PlatformRouteBinding(
      routeName: 'start-saving-monthly-goal-budget',
      routePath: '/start-saving/monthly-goal-budget',
      builder: (BuildContext context) => const MonthlyGoalBudgetScreen(),
    ),
    PlatformRouteBinding(
      routeName: 'start-saving-scan-receipt',
      routePath: '/start-saving/scan-receipt',
      builder: (BuildContext context) => const ReceiptScannerScreen(),
    ),
    PlatformRouteBinding(
      routeName: 'start-saving-shopping-list',
      routePath: '/start-saving/shopping-list',
      builder: (BuildContext context) =>
          const ShoppingListsScreen(showBackButton: true),
    ),
    PlatformRouteBinding(
      routeName: 'nearby-stores',
      routePath: '/nearby-stores',
      builder: (BuildContext context) => DealsMapScreen(),
    ),
    PlatformRouteBinding(
      routeName: 'scanner',
      routePath: '/scanner',
      builder: (BuildContext context) => const ReceiptScannerScreen(),
    ),
    PlatformRouteBinding(
      routeName: 'scanner-create',
      routePath: '/scanner/create',
      builder: _buildCreateReceipt,
    ),
    PlatformRouteBinding(
      routeName: 'scanner-receipt-detail',
      routePath: '/scanner/:receiptId',
      builder: _buildReceiptDetail,
    ),
    PlatformRouteBinding(
      routeName: 'expenses',
      routePath: '/expenses',
      builder: (BuildContext context) => const ExpensesScreen(),
    ),
    PlatformRouteBinding(
      routeName: 'expenses-create',
      routePath: '/expenses/create',
      builder: (BuildContext context) => const _RedirectToScannerCreate(),
    ),
    PlatformRouteBinding(
      routeName: 'add-grocery-expense',
      routePath: '/add-grocery-expense',
      builder: (BuildContext context) => const AddGroceryExpenseScreen(),
    ),
    PlatformRouteBinding(
      routeName: 'shopping',
      routePath: '/shopping',
      builder: (BuildContext context) => const ShoppingListsScreen(),
    ),
    PlatformRouteBinding(
      routeName: 'shopping-create',
      routePath: '/shopping/create',
      builder: (BuildContext context) => const CreateShoppingListScreen(),
    ),
    PlatformRouteBinding(
      routeName: 'shopping-list',
      routePath: '/shopping/list/:listId',
      builder: _buildShoppingListDetail,
    ),
    PlatformRouteBinding(
      routeName: 'shopping-list-add-item',
      routePath: '/shopping/list/:listId/add-item',
      builder: _buildAddShoppingListItem,
    ),
    PlatformRouteBinding(
      routeName: 'shopping-list-finalize-trip',
      routePath: '/shopping/list/:listId/finalize-trip',
      builder: _buildFinalizeShoppingTrip,
    ),
    PlatformRouteBinding(
      routeName: 'shopping-basket-optimizer',
      routePath: '/shopping/basket-optimizer',
      builder: _buildBasketOptimizer,
    ),
    PlatformRouteBinding(
      routeName: 'analytics',
      routePath: '/analytics',
      builder: (BuildContext context) => const SavingsAnalyticsScreen(),
    ),
    PlatformRouteBinding(
      routeName: 'analytics-savings-opportunities',
      routePath: '/analytics/savings-opportunities',
      builder: (BuildContext context) => const SavingsOpportunitiesScreen(),
    ),
    PlatformRouteBinding(
      routeName: 'analytics-product-price-insights',
      routePath: '/analytics/product-price-insights',
      builder: (BuildContext context) => const ProductPriceInsightsScreen(),
    ),
    PlatformRouteBinding(
      routeName: 'analytics-product-price-insights-detail',
      routePath: '/analytics/product-price-insights/detail',
      builder: _buildProductPriceDetail,
    ),
    PlatformRouteBinding(
      routeName: 'ai-assistant',
      routePath: '/ai-assistant',
      builder: (BuildContext context) => const AiSavingsAssistantScreen(),
    ),
    PlatformRouteBinding(
      routeName: 'profile',
      routePath: '/profile',
      builder: (BuildContext context) => const ProfileScreen(),
    ),
    PlatformRouteBinding(
      routeName: 'profile-edit',
      routePath: '/profile/edit',
      builder: (BuildContext context) => const EditProfileScreen(),
    ),
    PlatformRouteBinding(
      routeName: 'profile-settings',
      routePath: '/profile/settings',
      builder: (BuildContext context) => const AppSettingsScreen(),
    ),
    PlatformRouteBinding(
      routeName: 'profile-settings-language',
      routePath: '/profile/settings/language',
      builder: (BuildContext context) => const LanguageSelectScreen(
        mode: LanguageSelectMode.settings,
      ),
    ),
    PlatformRouteBinding(
      routeName: 'saved',
      routePath: '/saved',
      builder: (BuildContext context) => const SavedDealsScreen(),
    ),
    PlatformRouteBinding(
      routeName: 'subscription',
      routePath: '/subscription',
      builder: (BuildContext context) => const SubscriptionScreen(),
    ),
  ];

  _assertAlignedWithGroceriesModule(bindings);
  return bindings;
}

void _assertAlignedWithGroceriesModule(List<PlatformRouteBinding> bindings) {
  final List<RouteContribution> contributions =
      groceriesModule.routeContributions;
  assert(
    bindings.length == contributions.length,
    'Groceries route bindings must match groceriesModule contributions '
    '(${bindings.length} vs ${contributions.length})',
  );
  for (int i = 0; i < contributions.length; i++) {
    final RouteContribution contribution = contributions[i];
    final PlatformRouteBinding binding = bindings[i];
    assert(
      binding.routeName == contribution.name &&
          binding.routePath == contribution.path,
      'Groceries binding order/name/path mismatch at index $i: '
      'expected ${contribution.name}@${contribution.path}, '
      'got ${binding.routeName}@${binding.routePath}',
    );
  }
}

Widget _buildDealDetails(BuildContext context) {
  final GoRouterState state = GoRouterState.of(context);
  final String id =
      state.uri.pathSegments.isNotEmpty ? state.uri.pathSegments.last : '';
  Deal? deal;
  try {
    deal = mockDeals.firstWhere((Deal d) => d.id == id);
  } catch (_) {
    deal = null;
  }

  if (deal == null) {
    return Scaffold(
      appBar: AppBar(title: Text(AppStrings.of(context).dealDetails)),
      body: Center(child: Text(AppStrings.of(context).dealNotFound)),
    );
  }

  return DealDetailsScreen(deal: deal);
}

Widget _buildCreateReceipt(BuildContext context) {
  final Object? extra = GoRouterState.of(context).extra;
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

    final List<ReceiptItem> initialItems = ReceiptOcrDraftMapper.itemsFromExtra(
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
      initialCurrency: extra['initialCurrency'] as String?,
      initialSource: ReceiptSource.fromValue(extra['initialSource'] as String?),
      smartReceiptProvenance: _parseSmartReceiptProvenance(
        extra['smartReceiptProvenance'] as String?,
      ),
      smartReceiptFallbackReason: _parseSmartReceiptFailureKind(
        extra['smartReceiptFallbackReason'] as String?,
      ),
      smartReceiptWarningCodes:
          (extra['smartReceiptWarningCodes'] as List<dynamic>?)
                  ?.whereType<String>()
                  .toList(growable: false) ??
              const <String>[],
      isEditing: extra['isEditing'] == true,
    );
  }

  return const CreateReceiptScreen();
}

Widget _buildReceiptDetail(BuildContext context) {
  final String receiptId =
      GoRouterState.of(context).pathParameters['receiptId'] ?? '';
  return ReceiptDetailScreen(receiptId: receiptId);
}

Widget _buildShoppingListDetail(BuildContext context) {
  final String listId =
      GoRouterState.of(context).pathParameters['listId'] ?? '';
  return ShoppingListDetailScreen(listId: listId);
}

Widget _buildAddShoppingListItem(BuildContext context) {
  final String listId =
      GoRouterState.of(context).pathParameters['listId'] ?? '';
  return AddShoppingListItemScreen(listId: listId);
}

Widget _buildFinalizeShoppingTrip(BuildContext context) {
  final String listId =
      GoRouterState.of(context).pathParameters['listId'] ?? '';
  return FinalizeShoppingTripScreen(listId: listId);
}

Widget _buildBasketOptimizer(BuildContext context) {
  final String? listId =
      GoRouterState.of(context).uri.queryParameters['listId'];
  return BasketOptimizerScreen(listId: listId);
}

Widget _buildProductPriceDetail(BuildContext context) {
  final Object? extra = GoRouterState.of(context).extra;
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
}

SmartReceiptProvenance? _parseSmartReceiptProvenance(String? value) {
  for (final SmartReceiptProvenance provenance
      in SmartReceiptProvenance.values) {
    if (provenance.name == value) return provenance;
  }
  return null;
}

SmartReceiptFailureKind? _parseSmartReceiptFailureKind(String? value) {
  for (final SmartReceiptFailureKind kind in SmartReceiptFailureKind.values) {
    if (kind.name == value) return kind;
  }
  return null;
}

/// Matches `/expenses/create` → `/scanner/create` redirect semantics.
class _RedirectToScannerCreate extends StatefulWidget {
  const _RedirectToScannerCreate();

  @override
  State<_RedirectToScannerCreate> createState() =>
      _RedirectToScannerCreateState();
}

class _RedirectToScannerCreateState extends State<_RedirectToScannerCreate> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      context.go('/scanner/create');
    });
  }

  @override
  Widget build(BuildContext context) => const SizedBox.shrink();
}
