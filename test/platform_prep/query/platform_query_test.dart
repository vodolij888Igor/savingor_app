import 'package:flutter_test/flutter_test.dart';

import 'package:savingor_app/platform_prep/activation/activation.dart';
import 'package:savingor_app/platform_prep/application/application.dart';
import 'package:savingor_app/platform_prep/bootstrap/bootstrap.dart';
import 'package:savingor_app/platform_prep/discovery/discovery.dart';
import 'package:savingor_app/platform_prep/lifecycle/lifecycle.dart';
import 'package:savingor_app/platform_prep/navigation/module_id.dart';
import 'package:savingor_app/platform_prep/platform/platform.dart';
import 'package:savingor_app/platform_prep/query/query.dart';
import 'package:savingor_app/platform_prep/registry/registry.dart';
import 'package:savingor_app/savingor/modules/groceries/groceries_module.dart';

void main() {
  group('PlatformQuery', () {
    late PlatformBootstrap bootstrap;
    late PlatformQuery query;

    setUp(() {
      bootstrap = PlatformBootstrap.savingor();
      query = bootstrap.platformQuery;
    });

    test('query construction', () {
      expect(query, isA<PlatformQuery>());
      expect(
        PlatformQuery.fromFacade(
          bootstrap.facade,
          registry: bootstrap.platformRegistry,
          discovery: bootstrap.platformDiscovery,
          lifecycle: bootstrap.platformLifecycle,
          activation: bootstrap.platformActivation,
        ),
        isA<PlatformQuery>(),
      );
      expect(PlatformQuery.fromBootstrap(bootstrap), isA<PlatformQuery>());
    });

    test('composed lookups', () {
      expect(query.applications, hasLength(1));
      expect(query.application, isA<PlatformApplication>());
      expect(query.modules, contains(groceriesModule));
      expect(query.routes, isNotEmpty);
      expect(query.shellTabs, isNotEmpty);
      expect(query.registry, isA<PlatformRegistry>());
      expect(query.discovery, isA<PlatformDiscovery>());
      expect(query.lifecycle, isA<PlatformLifecycle>());
      expect(query.activation, isA<PlatformActivation>());
      expect(query.facade, isA<PlatformFacade>());

      expect(query.containsModule(ModuleId('groceries')), isTrue);
      expect(
          query.findModuleById(ModuleId('groceries')), same(groceriesModule));
      expect(query.findModuleById(ModuleId('missing')), isNull);
      expect(query.containsRoute('deals'), isTrue);
      expect(query.findRouteByName('deals')?.path, equals('/deals'));
      expect(query.findRouteByPath('/deals')?.name, equals('deals'));
      expect(query.containsShellTab('home'), isTrue);
      expect(query.findShellTabByKey('home')?.routePath, equals('/deals'));
      expect(query.isLifecycleReady, isTrue);
      expect(query.isActivationReady, isTrue);
    });

    test('immutable behavior', () {
      expect(
        () => query.applications.add(bootstrap.application),
        throwsUnsupportedError,
      );
      expect(
        () => query.modules.add(groceriesModule),
        throwsUnsupportedError,
      );
      expect(
        () => query.routes.add(query.routes.first),
        throwsUnsupportedError,
      );
      expect(
        () => query.shellTabs.add(query.shellTabs.first),
        throwsUnsupportedError,
      );
    });

    test('facade integration', () {
      expect(identical(query.facade, bootstrap.facade), isTrue);
      expect(
          identical(query.application, bootstrap.facade.application), isTrue);
      expect(identical(query.registry, bootstrap.platformRegistry), isTrue);
      expect(identical(query.discovery, bootstrap.platformDiscovery), isTrue);
      expect(identical(query.lifecycle, bootstrap.platformLifecycle), isTrue);
      expect(identical(query.activation, bootstrap.platformActivation), isTrue);
      expect(
        query.routes.map((r) => '${r.name}:${r.path}'),
        equals(
          bootstrap.facade.application.navigation.routes
              .map((r) => '${r.name}:${r.path}'),
        ),
      );
    });

    test('bootstrap construction', () {
      expect(bootstrap.platformQuery, same(query));
      expect(
          identical(bootstrap.platformQuery, bootstrap.platformQuery), isTrue);
      expect(
        PlatformQuery.fromBootstrap(bootstrap).findModuleById(
          ModuleId('groceries'),
        ),
        same(groceriesModule),
      );
    });

    test('public exports', () {
      const PlatformQuery Function(
        PlatformFacade facade, {
        required PlatformRegistry registry,
        required PlatformDiscovery discovery,
        required PlatformLifecycle lifecycle,
        required PlatformActivation activation,
      }) fromFacade = PlatformQuery.fromFacade;
      const PlatformQuery Function(PlatformBootstrap bootstrap) fromBootstrap =
          PlatformQuery.fromBootstrap;

      expect(
        fromFacade(
          bootstrap.facade,
          registry: bootstrap.platformRegistry,
          discovery: bootstrap.platformDiscovery,
          lifecycle: bootstrap.platformLifecycle,
          activation: bootstrap.platformActivation,
        ),
        isA<PlatformQuery>(),
      );
      expect(fromBootstrap(bootstrap), isA<PlatformQuery>());
      expect(query, isA<PlatformQuery>());
    });
  });
}
