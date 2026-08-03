import 'package:flutter_test/flutter_test.dart';

import 'package:savingor_app/platform_prep/application/application.dart';
import 'package:savingor_app/platform_prep/bootstrap/bootstrap.dart';
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
  group('PlatformRuntime', () {
    late PlatformBootstrap bootstrap;
    late PlatformRuntime runtime;

    setUp(() {
      bootstrap = PlatformBootstrap.savingor();
      runtime = bootstrap.runtime;
    });

    test('construction', () {
      expect(runtime, isA<PlatformRuntime>());
      expect(
        PlatformRuntime.fromBootstrap(bootstrap),
        isA<PlatformRuntime>(),
      );
      expect(
        PlatformRuntime.fromApplication(bootstrap.application),
        isA<PlatformRuntime>(),
      );
    });

    test('immutability', () {
      expect(runtime.application, same(runtime.application));
      expect(runtime.navigation, same(runtime.navigation));
      expect(
        () => runtime.navigation.routes.add(runtime.navigation.routes.first),
        throwsUnsupportedError,
      );
      expect(
        () => runtime.moduleContext.activeModules.modules.add(groceriesModule),
        throwsUnsupportedError,
      );
    });

    test('runtime composition', () {
      expect(identical(runtime.application, bootstrap.application), isTrue);
      expect(identical(runtime.navigation, runtime.application.navigation),
          isTrue);
      expect(
        identical(runtime.moduleContext, runtime.application.moduleContext),
        isTrue,
      );
      expect(identical(runtime.query, runtime.application.query), isTrue);
      expect(
          identical(runtime.discovery, runtime.application.discovery), isTrue);
      expect(
          identical(runtime.lifecycle, runtime.application.lifecycle), isTrue);
      expect(
        identical(runtime.activation, runtime.application.activation),
        isTrue,
      );
    });

    test('API exposure', () {
      expect(runtime.application, isA<PlatformApplication>());
      expect(runtime.navigation, isA<PlatformNavigationFacade>());
      expect(runtime.moduleContext, isA<ModuleContext>());
      expect(runtime.query, isA<ModuleQueryService>());
      expect(runtime.discovery, isA<ModuleDiscoveryService>());
      expect(runtime.lifecycle, isA<ModuleLifecycleService>());
      expect(runtime.activation, isA<ModuleActivationService>());

      expect(runtime.navigation.containsRoute('deals'), isTrue);
      expect(
        runtime.query.moduleById(ModuleId('groceries')),
        same(groceriesModule),
      );
      expect(runtime.discovery.contains(ModuleId('groceries')), isTrue);
      expect(runtime.query.isActive(ModuleId('groceries')), isTrue);
      expect(runtime.activation.rules, isNotEmpty);
    });

    test('bootstrap integration', () {
      expect(bootstrap.runtime.navigation.moduleCount, equals(1));
      expect(
        bootstrap.runtime.navigation.module(ModuleId('groceries')),
        same(groceriesModule),
      );
      expect(
        bootstrap.runtime.moduleContext.activeRouteCatalog.routeCount,
        equals(bootstrap.activeRouteCatalog.routeCount),
      );
      expect(
        bootstrap.runtime.query.activeModules(),
        same(bootstrap.queryService.activeModules()),
      );
    });

    test('singleton behavior', () {
      expect(identical(bootstrap.runtime, runtime), isTrue);
      expect(identical(bootstrap.runtime, bootstrap.runtime), isTrue);
      expect(identical(runtime.navigation, bootstrap.navigation), isTrue);
      expect(
        identical(runtime.moduleContext, bootstrap.moduleContext),
        isTrue,
      );
      expect(identical(runtime.query, bootstrap.queryService), isTrue);
      expect(identical(runtime.discovery, bootstrap.discoveryService), isTrue);
      expect(identical(runtime.lifecycle, bootstrap.lifecycleService), isTrue);
      expect(
        identical(runtime.activation, bootstrap.activationService),
        isTrue,
      );
    });
  });
}
