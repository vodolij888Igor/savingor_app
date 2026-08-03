import 'package:flutter_test/flutter_test.dart';

import 'package:savingor_app/platform_prep/application/application.dart';
import 'package:savingor_app/platform_prep/bootstrap/bootstrap.dart';
import 'package:savingor_app/platform_prep/environment/environment.dart';
import 'package:savingor_app/platform_prep/kernel/kernel.dart';
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
  group('PlatformKernel', () {
    late PlatformBootstrap bootstrap;
    late PlatformKernel kernel;

    setUp(() {
      bootstrap = PlatformBootstrap.savingor();
      kernel = bootstrap.kernel;
    });

    test('construction', () {
      expect(kernel, isA<PlatformKernel>());
      expect(PlatformKernel.fromBootstrap(bootstrap), isA<PlatformKernel>());
      expect(
        PlatformKernel.fromEnvironment(bootstrap.environment),
        isA<PlatformKernel>(),
      );
    });

    test('immutability', () {
      expect(kernel.environment, same(kernel.environment));
      expect(kernel.runtime, same(kernel.runtime));
      expect(
        () => kernel.navigation.routes.add(kernel.navigation.routes.first),
        throwsUnsupportedError,
      );
      expect(
        () => kernel.moduleContext.activeModules.modules.add(groceriesModule),
        throwsUnsupportedError,
      );
    });

    test('singleton behavior', () {
      expect(identical(bootstrap.kernel, kernel), isTrue);
      expect(identical(bootstrap.kernel, bootstrap.kernel), isTrue);
      expect(identical(kernel.environment, bootstrap.environment), isTrue);
      expect(identical(kernel.runtime, bootstrap.runtime), isTrue);
      expect(identical(kernel.application, bootstrap.application), isTrue);
      expect(identical(kernel.navigation, bootstrap.navigation), isTrue);
      expect(identical(kernel.moduleContext, bootstrap.moduleContext), isTrue);
      expect(identical(kernel.query, bootstrap.queryService), isTrue);
      expect(identical(kernel.discovery, bootstrap.discoveryService), isTrue);
      expect(identical(kernel.lifecycle, bootstrap.lifecycleService), isTrue);
      expect(identical(kernel.activation, bootstrap.activationService), isTrue);
    });

    test('kernel composition', () {
      expect(kernel.environment, isA<PlatformEnvironment>());
      expect(kernel.runtime, isA<PlatformRuntime>());
      expect(kernel.application, isA<PlatformApplication>());
      expect(kernel.navigation, isA<PlatformNavigationFacade>());
      expect(kernel.moduleContext, isA<ModuleContext>());
      expect(kernel.query, isA<ModuleQueryService>());
      expect(kernel.discovery, isA<ModuleDiscoveryService>());
      expect(kernel.lifecycle, isA<ModuleLifecycleService>());
      expect(kernel.activation, isA<ModuleActivationService>());

      expect(identical(kernel.runtime, kernel.environment.runtime), isTrue);
      expect(
        identical(kernel.application, kernel.environment.application),
        isTrue,
      );
      expect(
        identical(kernel.navigation, kernel.environment.navigation),
        isTrue,
      );
      expect(kernel.navigation.containsRoute('deals'), isTrue);
      expect(
        kernel.query.moduleById(ModuleId('groceries')),
        same(groceriesModule),
      );
    });

    test('bootstrap integration', () {
      expect(bootstrap.kernel.navigation.moduleCount, equals(1));
      expect(
        bootstrap.kernel.navigation.module(ModuleId('groceries')),
        same(groceriesModule),
      );
      expect(
        bootstrap.kernel.moduleContext.activeRouteCatalog.routeCount,
        equals(bootstrap.activeRouteCatalog.routeCount),
      );
      expect(
        bootstrap.kernel.query.activeModules(),
        same(bootstrap.queryService.activeModules()),
      );
    });

    test('public exports', () {
      const PlatformKernel Function(PlatformEnvironment environment)
          fromEnvironment = PlatformKernel.fromEnvironment;
      const PlatformKernel Function(PlatformBootstrap bootstrap) fromBootstrap =
          PlatformKernel.fromBootstrap;

      expect(fromEnvironment(bootstrap.environment), isA<PlatformKernel>());
      expect(fromBootstrap(bootstrap), isA<PlatformKernel>());
      expect(kernel, isA<PlatformKernel>());
    });
  });
}
