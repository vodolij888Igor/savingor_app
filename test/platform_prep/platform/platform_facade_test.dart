import 'package:flutter_test/flutter_test.dart';

import 'package:savingor_app/platform_prep/application/application.dart';
import 'package:savingor_app/platform_prep/bootstrap/bootstrap.dart';
import 'package:savingor_app/platform_prep/environment/environment.dart';
import 'package:savingor_app/platform_prep/kernel/kernel.dart';
import 'package:savingor_app/platform_prep/platform/platform.dart';
import 'package:savingor_app/platform_prep/runtime/runtime.dart';
import 'package:savingor_app/savingor/modules/groceries/groceries_module.dart';

void main() {
  group('PlatformFacade', () {
    late PlatformBootstrap bootstrap;
    late PlatformFacade facade;

    setUp(() {
      bootstrap = PlatformBootstrap.savingor();
      facade = bootstrap.facade;
    });

    test('construction', () {
      expect(facade, isA<PlatformFacade>());
      expect(PlatformFacade.fromBootstrap(bootstrap), isA<PlatformFacade>());
      expect(
          PlatformFacade.fromKernel(bootstrap.kernel), isA<PlatformFacade>());
    });

    test('immutability', () {
      expect(facade.kernel, same(facade.kernel));
      expect(facade.environment, same(facade.environment));
      expect(facade.runtime, same(facade.runtime));
      expect(facade.application, same(facade.application));
      expect(
        () => facade.application.navigation.routes
            .add(facade.application.navigation.routes.first),
        throwsUnsupportedError,
      );
      expect(
        () => facade.application.moduleContext.activeModules.modules
            .add(groceriesModule),
        throwsUnsupportedError,
      );
    });

    test('singleton behavior', () {
      expect(identical(bootstrap.facade, facade), isTrue);
      expect(identical(bootstrap.facade, bootstrap.facade), isTrue);
      expect(identical(facade.kernel, bootstrap.kernel), isTrue);
      expect(identical(facade.environment, bootstrap.environment), isTrue);
      expect(identical(facade.runtime, bootstrap.runtime), isTrue);
      expect(identical(facade.application, bootstrap.application), isTrue);
    });

    test('facade composition', () {
      expect(facade.kernel, isA<PlatformKernel>());
      expect(facade.environment, isA<PlatformEnvironment>());
      expect(facade.runtime, isA<PlatformRuntime>());
      expect(facade.application, isA<PlatformApplication>());

      expect(identical(facade.environment, facade.kernel.environment), isTrue);
      expect(identical(facade.runtime, facade.kernel.runtime), isTrue);
      expect(identical(facade.application, facade.kernel.application), isTrue);
      expect(
        facade.application.navigation.containsRoute('deals'),
        isTrue,
      );
      expect(
        facade.application.query.moduleById(
          groceriesModule.id,
        ),
        same(groceriesModule),
      );
    });

    test('bootstrap integration', () {
      expect(bootstrap.facade.application.navigation.moduleCount, equals(1));
      expect(
        bootstrap.facade.kernel.navigation.module(groceriesModule.id),
        same(groceriesModule),
      );
      expect(
        bootstrap.facade.runtime.moduleContext.activeRouteCatalog.routeCount,
        equals(bootstrap.activeRouteCatalog.routeCount),
      );
      expect(
        bootstrap.facade.environment.query.activeModules(),
        same(bootstrap.queryService.activeModules()),
      );
    });

    test('public exports', () {
      const PlatformFacade Function(PlatformKernel kernel) fromKernel =
          PlatformFacade.fromKernel;
      const PlatformFacade Function(PlatformBootstrap bootstrap) fromBootstrap =
          PlatformFacade.fromBootstrap;

      expect(fromKernel(bootstrap.kernel), isA<PlatformFacade>());
      expect(fromBootstrap(bootstrap), isA<PlatformFacade>());
      expect(facade, isA<PlatformFacade>());
    });
  });
}
