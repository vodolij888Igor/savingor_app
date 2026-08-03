import 'package:flutter_test/flutter_test.dart';

import 'package:savingor_app/platform_prep/application/application.dart';
import 'package:savingor_app/platform_prep/bootstrap/bootstrap.dart';
import 'package:savingor_app/platform_prep/environment/environment.dart';
import 'package:savingor_app/platform_prep/kernel/kernel.dart';
import 'package:savingor_app/platform_prep/platform/platform.dart';
import 'package:savingor_app/platform_prep/registry/registry.dart';
import 'package:savingor_app/platform_prep/runtime/runtime.dart';
import 'package:savingor_app/savingor/modules/groceries/groceries_module.dart';

void main() {
  group('PlatformRegistry', () {
    late PlatformBootstrap bootstrap;
    late PlatformRegistry platformRegistry;

    setUp(() {
      bootstrap = PlatformBootstrap.savingor();
      platformRegistry = bootstrap.platformRegistry;
    });

    test('construction', () {
      expect(platformRegistry, isA<PlatformRegistry>());
      expect(
        PlatformRegistry.fromBootstrap(bootstrap),
        isA<PlatformRegistry>(),
      );
      expect(
        PlatformRegistry.fromFacade(bootstrap.facade),
        isA<PlatformRegistry>(),
      );
    });

    test('immutability', () {
      expect(platformRegistry.facade, same(platformRegistry.facade));
      expect(platformRegistry.kernel, same(platformRegistry.kernel));
      expect(platformRegistry.environment, same(platformRegistry.environment));
      expect(platformRegistry.runtime, same(platformRegistry.runtime));
      expect(platformRegistry.application, same(platformRegistry.application));
      expect(
        () => platformRegistry.application.navigation.routes
            .add(platformRegistry.application.navigation.routes.first),
        throwsUnsupportedError,
      );
      expect(
        () => platformRegistry.application.moduleContext.activeModules.modules
            .add(groceriesModule),
        throwsUnsupportedError,
      );
    });

    test('singleton behavior', () {
      expect(identical(bootstrap.platformRegistry, platformRegistry), isTrue);
      expect(
        identical(bootstrap.platformRegistry, bootstrap.platformRegistry),
        isTrue,
      );
      expect(identical(platformRegistry.facade, bootstrap.facade), isTrue);
      expect(identical(platformRegistry.kernel, bootstrap.kernel), isTrue);
      expect(
        identical(platformRegistry.environment, bootstrap.environment),
        isTrue,
      );
      expect(identical(platformRegistry.runtime, bootstrap.runtime), isTrue);
      expect(
        identical(platformRegistry.application, bootstrap.application),
        isTrue,
      );
    });

    test('registry composition', () {
      expect(platformRegistry.facade, isA<PlatformFacade>());
      expect(platformRegistry.kernel, isA<PlatformKernel>());
      expect(platformRegistry.environment, isA<PlatformEnvironment>());
      expect(platformRegistry.runtime, isA<PlatformRuntime>());
      expect(platformRegistry.application, isA<PlatformApplication>());

      expect(
        identical(platformRegistry.kernel, platformRegistry.facade.kernel),
        isTrue,
      );
      expect(
        identical(
          platformRegistry.environment,
          platformRegistry.facade.environment,
        ),
        isTrue,
      );
      expect(
        identical(platformRegistry.runtime, platformRegistry.facade.runtime),
        isTrue,
      );
      expect(
        identical(
          platformRegistry.application,
          platformRegistry.facade.application,
        ),
        isTrue,
      );
      expect(
        platformRegistry.application.navigation.containsRoute('deals'),
        isTrue,
      );
      expect(
        platformRegistry.application.query.moduleById(groceriesModule.id),
        same(groceriesModule),
      );
    });

    test('bootstrap integration', () {
      expect(
        bootstrap.platformRegistry.application.navigation.moduleCount,
        equals(1),
      );
      expect(
        bootstrap.platformRegistry.kernel.navigation.module(groceriesModule.id),
        same(groceriesModule),
      );
      expect(
        bootstrap.platformRegistry.runtime.moduleContext.activeRouteCatalog
            .routeCount,
        equals(bootstrap.activeRouteCatalog.routeCount),
      );
      expect(
        bootstrap.platformRegistry.environment.query.activeModules(),
        same(bootstrap.queryService.activeModules()),
      );
    });

    test('public exports', () {
      const PlatformRegistry Function(PlatformFacade facade) fromFacade =
          PlatformRegistry.fromFacade;
      const PlatformRegistry Function(PlatformBootstrap bootstrap)
          fromBootstrap = PlatformRegistry.fromBootstrap;

      expect(fromFacade(bootstrap.facade), isA<PlatformRegistry>());
      expect(fromBootstrap(bootstrap), isA<PlatformRegistry>());
      expect(platformRegistry, isA<PlatformRegistry>());
    });
  });
}
