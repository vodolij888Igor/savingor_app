import 'package:savingor_app/platform_prep/navigation/app_module.dart';
import 'package:savingor_app/platform_prep/navigation/module_id.dart';
import 'package:savingor_app/platform_prep/navigation/route_contribution.dart';
import 'package:savingor_app/platform_prep/navigation/shell_tab_contribution.dart';

/// Groceries vertical module metadata for future platform composition.
///
/// Declares route and shell-tab descriptors only. Not wired to the live router
/// or UI.
final class GroceriesModule implements AppModule {
  GroceriesModule._();

  @override
  final ModuleId id = ModuleId('groceries');

  @override
  final List<RouteContribution> routeContributions =
      List<RouteContribution>.unmodifiable(<RouteContribution>[
    RouteContribution(name: 'deals', path: '/deals'),
    RouteContribution(name: 'deal-details', path: '/deals/:id'),
    RouteContribution(name: 'start-saving', path: '/start-saving'),
    RouteContribution(
      name: 'start-saving-select-list-to-finalize',
      path: '/start-saving/select-list-to-finalize',
    ),
    RouteContribution(
      name: 'start-saving-monthly-goal-budget',
      path: '/start-saving/monthly-goal-budget',
    ),
    RouteContribution(
      name: 'start-saving-scan-receipt',
      path: '/start-saving/scan-receipt',
    ),
    RouteContribution(
      name: 'start-saving-shopping-list',
      path: '/start-saving/shopping-list',
    ),
    RouteContribution(name: 'nearby-stores', path: '/nearby-stores'),
    RouteContribution(name: 'scanner', path: '/scanner'),
    RouteContribution(name: 'scanner-create', path: '/scanner/create'),
    RouteContribution(
      name: 'scanner-receipt-detail',
      path: '/scanner/:receiptId',
    ),
    RouteContribution(name: 'expenses', path: '/expenses'),
    RouteContribution(name: 'expenses-create', path: '/expenses/create'),
    RouteContribution(
      name: 'add-grocery-expense',
      path: '/add-grocery-expense',
    ),
    RouteContribution(name: 'shopping', path: '/shopping'),
    RouteContribution(name: 'shopping-create', path: '/shopping/create'),
    RouteContribution(
      name: 'shopping-list',
      path: '/shopping/list/:listId',
    ),
    RouteContribution(
      name: 'shopping-list-add-item',
      path: '/shopping/list/:listId/add-item',
    ),
    RouteContribution(
      name: 'shopping-list-finalize-trip',
      path: '/shopping/list/:listId/finalize-trip',
    ),
    RouteContribution(
      name: 'shopping-basket-optimizer',
      path: '/shopping/basket-optimizer',
    ),
    RouteContribution(name: 'analytics', path: '/analytics'),
    RouteContribution(
      name: 'analytics-savings-opportunities',
      path: '/analytics/savings-opportunities',
    ),
    RouteContribution(
      name: 'analytics-product-price-insights',
      path: '/analytics/product-price-insights',
    ),
    RouteContribution(
      name: 'analytics-product-price-insights-detail',
      path: '/analytics/product-price-insights/detail',
    ),
    RouteContribution(name: 'ai-assistant', path: '/ai-assistant'),
    RouteContribution(name: 'profile', path: '/profile'),
    RouteContribution(name: 'profile-edit', path: '/profile/edit'),
    RouteContribution(name: 'profile-settings', path: '/profile/settings'),
    RouteContribution(
      name: 'profile-settings-language',
      path: '/profile/settings/language',
    ),
    RouteContribution(name: 'saved', path: '/saved'),
    RouteContribution(name: 'subscription', path: '/subscription'),
  ]);

  @override
  final List<ShellTabContribution> shellTabs =
      List<ShellTabContribution>.unmodifiable(<ShellTabContribution>[
    ShellTabContribution(key: 'home', routePath: '/deals', sortOrder: 0),
    ShellTabContribution(
      key: 'nearby-stores',
      routePath: '/nearby-stores',
      sortOrder: 1,
    ),
    ShellTabContribution(key: 'scanner', routePath: '/scanner', sortOrder: 2),
    ShellTabContribution(
      key: 'ai-assistant',
      routePath: '/ai-assistant',
      sortOrder: 3,
    ),
    ShellTabContribution(key: 'profile', routePath: '/profile', sortOrder: 4),
  ]);
}

/// Canonical Groceries module instance (metadata only; not registered at runtime).
final GroceriesModule groceriesModule = GroceriesModule._();
