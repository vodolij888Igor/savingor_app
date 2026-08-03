import 'package:flutter_test/flutter_test.dart';

import 'package:savingor_app/platform_prep/application/application.dart';
import 'package:savingor_app/platform_prep/bootstrap/bootstrap.dart';
import 'package:savingor_app/platform_prep/discovery/discovery.dart';
import 'package:savingor_app/platform_prep/environment/environment.dart';
import 'package:savingor_app/platform_prep/kernel/kernel.dart';
import 'package:savingor_app/platform_prep/navigation/module_id.dart';
import 'package:savingor_app/platform_prep/platform/platform.dart';
import 'package:savingor_app/platform_prep/registry/registry.dart';
import 'package:savingor_app/platform_prep/runtime/runtime.dart';
import 'package:savingor_app/savingor/modules/groceries/groceries_module.dart';

void main() {
  group('PlatformDiscovery', () {
    late PlatformBootstrap bootstrap;
    late PlatformDiscovery discovery;

    setUp(() {
      bootstrap = PlatformBootstrap.savingor();
      discovery = bootstrap.platformDiscovery;
    });

    test('discovery queries', () {
      expect(discovery.modules, isNotEmpty);
      expect(discovery.registeredModules, isNotEmpty);
      expect(discovery.activeModules, isNotEmpty);
      expect(discovery.routes, isNotEmpty);
      expect(discovery.shellTabs, isNotEmpty);
      expect(discovery.applications, hasLength(1));
      expect(discovery.application, isA<PlatformApplication>());
      expect(discovery.runtime, isA<PlatformRuntime>());
      expect(discovery.environment, isA<PlatformEnvironment>());
      expect(discovery.kernel, isA<PlatformKernel>());
      expect(discovery.facade, isA<PlatformFacade>());
    });

    test('lookup correctness', () {
      expect(discovery.containsModule(ModuleId('groceries')), isTrue);
      expect(discovery.findModuleById(ModuleId('groceries')),
          same(groceriesModule));
      expect(discovery.findModuleById(ModuleId('missing')), isNull);

      expect(discovery.containsRoute('deals'), isTrue);
      expect(discovery.findRouteByName('deals')?.path, equals('/deals'));
      expect(discovery.findRouteByPath('/deals')?.name, equals('deals'));
      expect(discovery.findRouteByName('missing'), isNull);
      expect(discovery.findRouteByPath('/missing'), isNull);

      expect(discovery.containsShellTab('home'), isTrue);
      expect(discovery.findShellTabByKey('home')?.routePath, equals('/deals'));
      expect(discovery.findShellTabByKey('missing'), isNull);

      expect(discovery.applications.single, same(bootstrap.application));
      expect(discovery.runtime, same(bootstrap.runtime));
    });

    test('immutable collections', () {
      expect(
        () => discovery.modules.add(groceriesModule),
        throwsUnsupportedError,
      );
      expect(
        () => discovery.routes.add(discovery.routes.first),
        throwsUnsupportedError,
      );
      expect(
        () => discovery.shellTabs.add(discovery.shellTabs.first),
        throwsUnsupportedError,
      );
      expect(
        () => discovery.applications.add(bootstrap.application),
        throwsUnsupportedError,
      );
      expect(
        () => discovery.registeredModules.add(groceriesModule),
        throwsUnsupportedError,
      );
      expect(
        () => discovery.activeModules.add(groceriesModule),
        throwsUnsupportedError,
      );
    });

    test('registry integration', () {
      expect(identical(discovery.registry, bootstrap.platformRegistry), isTrue);
      expect(identical(discovery.facade, bootstrap.facade), isTrue);
      expect(identical(discovery.kernel, bootstrap.kernel), isTrue);
      expect(identical(discovery.application, bootstrap.application), isTrue);
      expect(
        discovery.routes.map((r) => '${r.name}:${r.path}'),
        equals(
          bootstrap.platformRegistry.application.navigation.routes
              .map((r) => '${r.name}:${r.path}'),
        ),
      );
    });

    test('bootstrap construction', () {
      expect(bootstrap.platformDiscovery, isA<PlatformDiscovery>());
      expect(
        identical(bootstrap.platformDiscovery, bootstrap.platformDiscovery),
        isTrue,
      );
      expect(
        PlatformDiscovery.fromBootstrap(bootstrap).registry,
        same(bootstrap.platformRegistry),
      );
      expect(
        PlatformDiscovery.fromRegistry(bootstrap.platformRegistry).application,
        same(bootstrap.application),
      );
    });

    test('public exports', () {
      const PlatformDiscovery Function(PlatformRegistry registry) fromRegistry =
          PlatformDiscovery.fromRegistry;
      const PlatformDiscovery Function(PlatformBootstrap bootstrap)
          fromBootstrap = PlatformDiscovery.fromBootstrap;

      expect(
          fromRegistry(bootstrap.platformRegistry), isA<PlatformDiscovery>());
      expect(fromBootstrap(bootstrap), isA<PlatformDiscovery>());
      expect(discovery, isA<PlatformDiscovery>());
    });
  });
}
