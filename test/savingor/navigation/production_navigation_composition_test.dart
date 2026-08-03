import 'package:flutter_test/flutter_test.dart';

import 'package:savingor_app/platform_prep/bootstrap/bootstrap.dart';
import 'package:savingor_app/platform_prep/modules/active_module_set.dart';
import 'package:savingor_app/platform_prep/modules/module_activation_rule.dart';
import 'package:savingor_app/platform_prep/modules/module_activation_service.dart';
import 'package:savingor_app/platform_prep/feature_flags/local_feature_flag_service.dart';
import 'package:savingor_app/platform_prep/navigation/active_route_catalog.dart';
import 'package:savingor_app/platform_prep/navigation/active_shell_tab_catalog.dart';
import 'package:savingor_app/platform_prep/navigation/app_module.dart';
import 'package:savingor_app/platform_prep/navigation/module_id.dart';
import 'package:savingor_app/platform_prep/navigation/module_registry.dart';
import 'package:savingor_app/platform_prep/navigation/route_contribution.dart';
import 'package:savingor_app/platform_prep/navigation/shell_tab_contribution.dart';
import 'package:savingor_app/savingor/modules/groceries/groceries_module.dart';
import 'package:savingor_app/savingor/modules/module_loader.dart';
import 'package:savingor_app/savingor/navigation/navigation.dart';

void main() {
  group('ProductionNavigationComposition', () {
    test('preserves deterministic ordering', () {
      final ProductionNavigationComposition composition =
          ProductionNavigationComposition(
        routes: <RouteContribution>[
          RouteContribution(name: 'a', path: '/a'),
          RouteContribution(name: 'b', path: '/b'),
          RouteContribution(name: 'c', path: '/c'),
        ],
        shellTabs: <ShellTabContribution>[
          ShellTabContribution(key: 't0', routePath: '/a', sortOrder: 0),
          ShellTabContribution(key: 't1', routePath: '/b', sortOrder: 1),
        ],
        modules: <AppModule>[
          _FakeModule(
            id: 'm1',
            routes: <RouteContribution>[
              RouteContribution(name: 'a', path: '/a'),
            ],
          ),
          _FakeModule(
            id: 'm2',
            routes: <RouteContribution>[
              RouteContribution(name: 'b', path: '/b'),
            ],
          ),
        ],
      );

      expect(
        composition.routes.map((RouteContribution r) => r.name).toList(),
        <String>['a', 'b', 'c'],
      );
      expect(
        composition.shellTabs.map((ShellTabContribution t) => t.key).toList(),
        <String>['t0', 't1'],
      );
      expect(
        composition.modules.map((AppModule m) => m.id.value).toList(),
        <String>['m1', 'm2'],
      );
    });

    test('collections are unmodifiable', () {
      final ProductionNavigationComposition composition =
          ProductionNavigationComposition(
        routes: <RouteContribution>[
          RouteContribution(name: 'a', path: '/a'),
        ],
        shellTabs: <ShellTabContribution>[
          ShellTabContribution(key: 't0', routePath: '/a', sortOrder: 0),
        ],
        modules: <AppModule>[
          _FakeModule(
            id: 'm1',
            routes: <RouteContribution>[
              RouteContribution(name: 'a', path: '/a'),
            ],
          ),
        ],
      );

      expect(
        () => composition.routes.add(
          RouteContribution(name: 'x', path: '/x'),
        ),
        throwsUnsupportedError,
      );
      expect(
        () => composition.shellTabs.add(
          ShellTabContribution(key: 'x', routePath: '/x', sortOrder: 9),
        ),
        throwsUnsupportedError,
      );
      expect(
        () => composition.modules.add(
          _FakeModule(id: 'x', routes: const <RouteContribution>[]),
        ),
        throwsUnsupportedError,
      );
    });

    test('supports empty collections', () {
      final ProductionNavigationComposition composition =
          ProductionNavigationComposition(
        routes: const <RouteContribution>[],
        shellTabs: const <ShellTabContribution>[],
        modules: const <AppModule>[],
      );

      expect(composition.routeCount, equals(0));
      expect(composition.shellTabCount, equals(0));
      expect(composition.moduleCount, equals(0));
      expect(composition.findRouteByName('missing'), isNull);
      expect(composition.findRouteByPath('/missing'), isNull);
      expect(composition.findShellTabByKey('missing'), isNull);
      expect(composition.findModuleById(ModuleId('missing')), isNull);
    });

    test('lookup behavior', () {
      final RouteContribution route =
          RouteContribution(name: 'deals', path: '/deals');
      final ShellTabContribution tab = ShellTabContribution(
        key: 'home',
        routePath: '/deals',
        sortOrder: 0,
      );
      final AppModule module = _FakeModule(
        id: 'groceries',
        routes: <RouteContribution>[route],
        tabs: <ShellTabContribution>[tab],
      );

      final ProductionNavigationComposition composition =
          ProductionNavigationComposition(
        routes: <RouteContribution>[route],
        shellTabs: <ShellTabContribution>[tab],
        modules: <AppModule>[module],
      );

      expect(composition.findRouteByName('deals'), same(route));
      expect(composition.findRouteByPath('/deals'), same(route));
      expect(composition.findShellTabByKey('home'), same(tab));
      expect(composition.findModuleById(ModuleId('groceries')), same(module));
      expect(composition.containsRouteName('deals'), isTrue);
      expect(composition.containsRoutePath('/deals'), isTrue);
      expect(composition.containsShellTabKey('home'), isTrue);
      expect(composition.containsModuleId(ModuleId('groceries')), isTrue);
      expect(composition.findRouteByName('other'), isNull);
      expect(composition.containsRouteName('other'), isFalse);
    });
  });

  group('ProductionNavigationCompositionService', () {
    test('is consistent with PlatformBootstrap.savingor', () {
      final PlatformBootstrap bootstrap = PlatformBootstrap.savingor();
      final ProductionNavigationCompositionService service =
          ProductionNavigationCompositionService(bootstrap: bootstrap);
      final ProductionNavigationComposition composition = service.composition;

      expect(
        composition.routes.map((RouteContribution r) => '${r.name}:${r.path}'),
        equals(
          bootstrap.activeRouteCatalog.routes
              .map((RouteContribution r) => '${r.name}:${r.path}'),
        ),
      );
      expect(
        composition.shellTabs.map(
          (ShellTabContribution t) => '${t.key}:${t.routePath}:${t.sortOrder}',
        ),
        equals(
          bootstrap.activeShellTabCatalog.tabs.map(
            (ShellTabContribution t) =>
                '${t.key}:${t.routePath}:${t.sortOrder}',
          ),
        ),
      );
      expect(
        composition.modules.map((AppModule m) => m.id.value),
        equals(
          bootstrap.queryService
              .activeModules()
              .map((AppModule m) => m.id.value),
        ),
      );
      expect(composition.moduleCount, equals(1));
      expect(
        composition.findModuleById(ModuleId('groceries')),
        same(groceriesModule),
      );
      expect(
        composition.findRouteByName('deals')?.path,
        equals('/deals'),
      );
      expect(
        composition.findShellTabByKey('home')?.routePath,
        equals('/deals'),
      );
    });

    test('composition is built once and remains stable', () {
      final PlatformBootstrap bootstrap = PlatformBootstrap.savingor();
      final ProductionNavigationCompositionService service =
          ProductionNavigationCompositionService(bootstrap: bootstrap);

      expect(identical(service.composition, service.composition), isTrue);
      expect(service.composition.routeCount, greaterThan(0));
    });

    test('composes empty catalogs from an empty bootstrap', () {
      final ModuleRegistry registry = ModuleRegistry(const <AppModule>[]);
      final ModuleLoader loader = ModuleLoader(registry);
      final LocalFeatureFlagService flags = LocalFeatureFlagService();
      final ModuleActivationService activation = ModuleActivationService(
        loader: loader,
        featureFlags: flags,
        rules: const <ModuleActivationRule>[],
      );
      final ActiveModuleSet active = activation.evaluate();
      final PlatformBootstrap bootstrap = PlatformBootstrap(
        moduleRegistry: registry,
        moduleLoader: loader,
        featureFlags: flags,
        activationService: activation,
        activeModules: active,
        activeRouteCatalog: ActiveRouteCatalog(active),
        activeShellTabCatalog: ActiveShellTabCatalog(active),
      );

      final ProductionNavigationComposition composition =
          ProductionNavigationCompositionService(bootstrap: bootstrap)
              .composition;

      expect(composition.routeCount, equals(0));
      expect(composition.shellTabCount, equals(0));
      expect(composition.moduleCount, equals(0));
    });
  });
}

final class _FakeModule implements AppModule {
  _FakeModule({
    required String id,
    required List<RouteContribution> routes,
    List<ShellTabContribution> tabs = const <ShellTabContribution>[],
  })  : id = ModuleId(id),
        routeContributions = List<RouteContribution>.unmodifiable(routes),
        shellTabs = List<ShellTabContribution>.unmodifiable(tabs);

  @override
  final ModuleId id;

  @override
  final List<RouteContribution> routeContributions;

  @override
  final List<ShellTabContribution> shellTabs;
}
