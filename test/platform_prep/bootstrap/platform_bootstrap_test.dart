import 'package:flutter_test/flutter_test.dart';
import 'package:savingor_app/platform_prep/bootstrap/bootstrap.dart';
import 'package:savingor_app/platform_prep/modules/active_module_set.dart';
import 'package:savingor_app/platform_prep/modules/module_activation_service.dart';
import 'package:savingor_app/platform_prep/navigation/module_id.dart';
import 'package:savingor_app/platform_prep/navigation/route_catalog.dart';
import 'package:savingor_app/platform_prep/navigation/route_contribution.dart';
import 'package:savingor_app/platform_prep/navigation/shell_tab_catalog.dart';
import 'package:savingor_app/platform_prep/navigation/shell_tab_contribution.dart';
import 'package:savingor_app/savingor/modules/groceries/groceries_module.dart';
import 'package:savingor_app/savingor/navigation/platform_navigation_facade.dart';

void main() {
  group('PlatformBootstrap.savingor', () {
    late PlatformBootstrap bootstrap;

    setUp(() {
      bootstrap = PlatformBootstrap.savingor();
    });

    test('builds successfully', () {
      expect(bootstrap, isA<PlatformBootstrap>());
    });

    test('registry is available', () {
      expect(bootstrap.moduleRegistry, isNotNull);
      expect(bootstrap.moduleRegistry.modules, isNotEmpty);
    });

    test('loader is available', () {
      expect(bootstrap.moduleLoader, isNotNull);
    });

    test('featureFlags is available', () {
      expect(bootstrap.featureFlags, isNotNull);
    });

    test('routeCatalog is available', () {
      expect(bootstrap.routeCatalog, isA<RouteCatalog>());
      expect(bootstrap.routeCatalog.routes, isNotEmpty);
    });

    test('shellTabCatalog is available', () {
      expect(bootstrap.shellTabCatalog, isA<ShellTabCatalog>());
      expect(bootstrap.shellTabCatalog.tabs, isNotEmpty);
    });

    test('activationService exists', () {
      expect(bootstrap.activationService, isA<ModuleActivationService>());
    });

    test('activeModules exists', () {
      expect(bootstrap.activeModules, isA<ActiveModuleSet>());
      expect(bootstrap.activeModules.count, equals(1));
    });

    test('activeModules contains GroceriesModule', () {
      expect(
        bootstrap.activeModules.findById(ModuleId('groceries')),
        same(groceriesModule),
      );
      expect(bootstrap.activeModules.contains(ModuleId('groceries')), isTrue);
    });

    test('activeModules evaluation occurs once', () {
      final ActiveModuleSet active = bootstrap.activeModules;
      final ModuleActivationService activation = bootstrap.activationService;

      expect(identical(bootstrap.activeModules, active), isTrue);
      expect(identical(bootstrap.activationService, activation), isTrue);
    });

    test('catalogs are built exactly once', () {
      final RouteCatalog routes = bootstrap.routeCatalog;
      final ShellTabCatalog tabs = bootstrap.shellTabCatalog;

      expect(identical(bootstrap.routeCatalog, routes), isTrue);
      expect(identical(bootstrap.shellTabCatalog, tabs), isTrue);
    });

    test('bootstrap remains internally consistent', () {
      expect(
        bootstrap.moduleLoader.modules,
        same(bootstrap.moduleRegistry.modules),
      );
      expect(bootstrap.moduleLoader.moduleCount, equals(1));
      expect(
        bootstrap.moduleLoader.get(ModuleId('groceries')),
        same(groceriesModule),
      );

      expect(
        bootstrap.routeCatalog.routes.length,
        equals(groceriesModule.routeContributions.length),
      );
      expect(
        bootstrap.shellTabCatalog.tabCount,
        equals(groceriesModule.shellTabs.length),
      );
      expect(bootstrap.routeCatalog.containsRoutePath('/deals'), isTrue);
      expect(bootstrap.shellTabCatalog.containsStableKey('home'), isTrue);

      expect(bootstrap.activeModules.count, equals(1));
      expect(
        bootstrap.activeModules.findById(ModuleId('groceries')),
        same(bootstrap.moduleLoader.get(ModuleId('groceries'))),
      );
      expect(
        bootstrap.activationService.rules,
        hasLength(1),
      );
      expect(
        bootstrap.activationService.rules.single.moduleId.value,
        equals('groceries'),
      );
      expect(
        bootstrap.activationService.rules.single.requiredFlag,
        isNull,
      );
    });

    test('loader moduleCount is 1', () {
      expect(bootstrap.moduleLoader.moduleCount, equals(1));
    });

    test('groceries module exists', () {
      expect(
        bootstrap.moduleLoader.get(ModuleId('groceries')),
        same(groceriesModule),
      );
      expect(bootstrap.moduleLoader.contains(ModuleId('groceries')), isTrue);
    });
  });

  group('PlatformBootstrap navigation facade', () {
    late PlatformBootstrap bootstrap;

    setUp(() {
      bootstrap = PlatformBootstrap.savingor();
    });

    test('facade creation', () {
      expect(bootstrap.navigation, isA<PlatformNavigationFacade>());
      expect(bootstrap.navigation.routeCount, greaterThan(0));
      expect(bootstrap.navigation.shellTabCount, greaterThan(0));
      expect(bootstrap.navigation.moduleCount, equals(1));
    });

    test('bootstrap integration', () {
      expect(
        bootstrap.navigation.routes.map(
          (RouteContribution r) => '${r.name}:${r.path}',
        ),
        equals(
          bootstrap.activeRouteCatalog.routes.map(
            (RouteContribution r) => '${r.name}:${r.path}',
          ),
        ),
      );
      expect(
        bootstrap.navigation.shellTabs.map(
          (ShellTabContribution t) => '${t.key}:${t.routePath}',
        ),
        equals(
          bootstrap.activeShellTabCatalog.tabs.map(
            (ShellTabContribution t) => '${t.key}:${t.routePath}',
          ),
        ),
      );
      expect(
        bootstrap.navigation.module(ModuleId('groceries')),
        same(groceriesModule),
      );
      expect(bootstrap.navigation.containsRoute('deals'), isTrue);
      expect(bootstrap.navigation.routeByPath('/deals').name, equals('deals'));
      expect(bootstrap.navigation.shellTab('home').routePath, equals('/deals'));
    });

    test('singleton behavior', () {
      final PlatformNavigationFacade first = bootstrap.navigation;
      final PlatformNavigationFacade second = bootstrap.navigation;

      expect(identical(first, second), isTrue);
      expect(identical(bootstrap.navigation, first), isTrue);
    });

    test('immutability', () {
      expect(
        () => bootstrap.navigation.routes.add(
          RouteContribution(name: 'x', path: '/x'),
        ),
        throwsUnsupportedError,
      );
      expect(
        () => bootstrap.navigation.shellTabs.add(
          ShellTabContribution(key: 'x', routePath: '/x', sortOrder: 9),
        ),
        throwsUnsupportedError,
      );
      expect(
        () => bootstrap.navigation.modules.add(groceriesModule),
        throwsUnsupportedError,
      );
    });

    test('backward compatibility', () {
      // Existing bootstrap surfaces remain available alongside navigation.
      expect(bootstrap.activeRouteCatalog, isNotNull);
      expect(bootstrap.activeShellTabCatalog, isNotNull);
      expect(bootstrap.queryService, isNotNull);
      expect(bootstrap.moduleContext, isNotNull);
      expect(bootstrap.routeCatalog, isNotNull);
      expect(bootstrap.shellTabCatalog, isNotNull);
      expect(
        bootstrap.navigation.routeCount,
        equals(bootstrap.activeRouteCatalog.routeCount),
      );
      expect(
        bootstrap.navigation.shellTabCount,
        equals(bootstrap.activeShellTabCatalog.tabCount),
      );
      expect(
        bootstrap.navigation.moduleCount,
        equals(bootstrap.activeModules.count),
      );
    });
  });
}
