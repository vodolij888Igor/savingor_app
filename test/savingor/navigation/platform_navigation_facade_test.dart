import 'package:flutter_test/flutter_test.dart';

import 'package:savingor_app/platform_prep/bootstrap/bootstrap.dart';
import 'package:savingor_app/platform_prep/feature_flags/local_feature_flag_service.dart';
import 'package:savingor_app/platform_prep/modules/active_module_set.dart';
import 'package:savingor_app/platform_prep/modules/module_activation_rule.dart';
import 'package:savingor_app/platform_prep/modules/module_activation_service.dart';
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
import 'package:savingor_app/savingor/navigation/platform_navigation_service.dart';
import 'package:savingor_app/savingor/navigation/production_navigation_composition_service.dart';

void main() {
  group('PlatformNavigationFacade', () {
    test('facade construction from bootstrap', () {
      final PlatformNavigationFacade facade =
          PlatformNavigationFacade.fromBootstrap(PlatformBootstrap.savingor());

      expect(facade, isA<PlatformNavigationFacade>());
      expect(facade.routeCount, greaterThan(0));
      expect(facade.shellTabCount, greaterThan(0));
      expect(facade.moduleCount, equals(1));
    });

    test('delegation and lookup methods', () {
      final PlatformBootstrap bootstrap = PlatformBootstrap.savingor();
      final PlatformNavigationFacade facade =
          PlatformNavigationFacade.fromBootstrap(bootstrap);
      final PlatformNavigationService service =
          PlatformNavigationService.fromComposition(
        ProductionNavigationCompositionService(bootstrap: bootstrap)
            .composition,
      );

      expect(
        facade.routeByName('deals'),
        same(service.routeByName('deals')),
      );
      expect(
        facade.routeByPath('/scanner'),
        same(service.routeByPath('/scanner')),
      );
      expect(facade.shellTab('home'), same(service.shellTab('home')));
      expect(
        facade.module(ModuleId('groceries')),
        same(service.module(ModuleId('groceries'))),
      );
      expect(facade.containsRoute('deals'), isTrue);
      expect(facade.containsShellTab('home'), isTrue);
      expect(facade.containsModule(ModuleId('groceries')), isTrue);
      expect(
        facade.module(ModuleId('groceries')),
        same(groceriesModule),
      );
    });

    test('invalid lookups', () {
      final PlatformNavigationFacade facade =
          PlatformNavigationFacade.fromBootstrap(PlatformBootstrap.savingor());

      expect(facade.containsRoute('missing'), isFalse);
      expect(facade.containsShellTab('missing'), isFalse);
      expect(facade.containsModule(ModuleId('missing')), isFalse);

      expect(() => facade.routeByName('missing'), throwsStateError);
      expect(() => facade.routeByPath('/missing'), throwsStateError);
      expect(() => facade.shellTab('missing'), throwsStateError);
      expect(() => facade.module(ModuleId('missing')), throwsStateError);
    });

    test('immutability', () {
      final PlatformNavigationFacade facade =
          PlatformNavigationFacade.fromBootstrap(PlatformBootstrap.savingor());

      expect(
        () => facade.routes.add(
          RouteContribution(name: 'x', path: '/x'),
        ),
        throwsUnsupportedError,
      );
      expect(
        () => facade.shellTabs.add(
          ShellTabContribution(key: 'x', routePath: '/x', sortOrder: 9),
        ),
        throwsUnsupportedError,
      );
      expect(
        () => facade.modules.add(groceriesModule),
        throwsUnsupportedError,
      );
    });

    test('public API returns metadata types only', () {
      final PlatformNavigationFacade facade =
          PlatformNavigationFacade.fromBootstrap(PlatformBootstrap.savingor());

      expect(facade.routes, isA<List<RouteContribution>>());
      expect(facade.shellTabs, isA<List<ShellTabContribution>>());
      expect(facade.modules, isA<List<AppModule>>());
      expect(facade.routeByName('deals'), isA<RouteContribution>());
      expect(facade.routeByPath('/deals'), isA<RouteContribution>());
      expect(facade.shellTab('home'), isA<ShellTabContribution>());
      expect(facade.module(ModuleId('groceries')), isA<AppModule>());
      expect(facade.routeCount, equals(facade.routes.length));
      expect(facade.shellTabCount, equals(facade.shellTabs.length));
      expect(facade.moduleCount, equals(facade.modules.length));
    });

    test('empty bootstrap yields empty facade collections', () {
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

      final PlatformNavigationFacade facade =
          PlatformNavigationFacade.fromBootstrap(bootstrap);

      expect(facade.routeCount, equals(0));
      expect(facade.shellTabCount, equals(0));
      expect(facade.moduleCount, equals(0));
      expect(facade.containsRoute('deals'), isFalse);
    });
  });
}
