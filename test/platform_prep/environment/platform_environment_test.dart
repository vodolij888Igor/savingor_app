import 'package:flutter_test/flutter_test.dart';

import 'package:savingor_app/platform_prep/application/application.dart';
import 'package:savingor_app/platform_prep/bootstrap/bootstrap.dart';
import 'package:savingor_app/platform_prep/environment/environment.dart';
import 'package:savingor_app/platform_prep/modules/module_activation_service.dart';
import 'package:savingor_app/platform_prep/modules/module_context.dart';
import 'package:savingor_app/platform_prep/modules/module_discovery_service.dart';
import 'package:savingor_app/platform_prep/modules/module_lifecycle_service.dart';
import 'package:savingor_app/platform_prep/modules/module_query_service.dart';
import 'package:savingor_app/platform_prep/navigation/module_id.dart';
import 'package:savingor_app/platform_prep/runtime/runtime.dart';
import 'package:savingor_app/savingor/modules/groceries/groceries_module.dart';
import 'package:savingor_app/savingor/navigation/platform_navigation_facade.dart';

void main() {
  group('PlatformEnvironment', () {
    late PlatformBootstrap bootstrap;
    late PlatformEnvironment environment;

    setUp(() {
      bootstrap = PlatformBootstrap.savingor();
      environment = bootstrap.environment;
    });

    test('construction', () {
      expect(environment, isA<PlatformEnvironment>());
      expect(
        PlatformEnvironment.fromBootstrap(bootstrap),
        isA<PlatformEnvironment>(),
      );
      expect(
        PlatformEnvironment.fromRuntime(bootstrap.runtime),
        isA<PlatformEnvironment>(),
      );
    });

    test('immutability', () {
      expect(environment.runtime, same(environment.runtime));
      expect(environment.application, same(environment.application));
      expect(
        () => environment.navigation.routes
            .add(environment.navigation.routes.first),
        throwsUnsupportedError,
      );
      expect(
        () => environment.moduleContext.activeModules.modules
            .add(groceriesModule),
        throwsUnsupportedError,
      );
    });

    test('singleton behavior', () {
      expect(identical(bootstrap.environment, environment), isTrue);
      expect(identical(bootstrap.environment, bootstrap.environment), isTrue);
      expect(identical(environment.runtime, bootstrap.runtime), isTrue);
      expect(
        identical(environment.application, bootstrap.application),
        isTrue,
      );
      expect(identical(environment.navigation, bootstrap.navigation), isTrue);
      expect(
        identical(environment.moduleContext, bootstrap.moduleContext),
        isTrue,
      );
      expect(identical(environment.query, bootstrap.queryService), isTrue);
      expect(
        identical(environment.discovery, bootstrap.discoveryService),
        isTrue,
      );
      expect(
        identical(environment.lifecycle, bootstrap.lifecycleService),
        isTrue,
      );
      expect(
        identical(environment.activation, bootstrap.activationService),
        isTrue,
      );
    });

    test('environment composition', () {
      expect(environment.runtime, isA<PlatformRuntime>());
      expect(environment.application, isA<PlatformApplication>());
      expect(environment.navigation, isA<PlatformNavigationFacade>());
      expect(environment.moduleContext, isA<ModuleContext>());
      expect(environment.query, isA<ModuleQueryService>());
      expect(environment.discovery, isA<ModuleDiscoveryService>());
      expect(environment.lifecycle, isA<ModuleLifecycleService>());
      expect(environment.activation, isA<ModuleActivationService>());

      expect(
        identical(environment.application, environment.runtime.application),
        isTrue,
      );
      expect(
        identical(environment.navigation, environment.runtime.navigation),
        isTrue,
      );
      expect(
        identical(environment.query, environment.runtime.query),
        isTrue,
      );
      expect(environment.navigation.containsRoute('deals'), isTrue);
      expect(
        environment.query.moduleById(ModuleId('groceries')),
        same(groceriesModule),
      );
    });

    test('bootstrap integration', () {
      expect(bootstrap.environment.navigation.moduleCount, equals(1));
      expect(
        bootstrap.environment.navigation.module(ModuleId('groceries')),
        same(groceriesModule),
      );
      expect(
        bootstrap.environment.moduleContext.activeRouteCatalog.routeCount,
        equals(bootstrap.activeRouteCatalog.routeCount),
      );
      expect(
        bootstrap.environment.query.activeModules(),
        same(bootstrap.queryService.activeModules()),
      );
    });

    test('public exports', () {
      // environment.dart re-exports PlatformEnvironment as the public API.
      const PlatformEnvironment Function(PlatformRuntime runtime) fromRuntime =
          PlatformEnvironment.fromRuntime;
      const PlatformEnvironment Function(PlatformBootstrap bootstrap)
          fromBootstrap = PlatformEnvironment.fromBootstrap;

      expect(fromRuntime(bootstrap.runtime), isA<PlatformEnvironment>());
      expect(fromBootstrap(bootstrap), isA<PlatformEnvironment>());
      expect(environment, isA<PlatformEnvironment>());
    });
  });
}
