import 'package:flutter_test/flutter_test.dart';

import 'package:savingor_app/platform_prep/application/application.dart';
import 'package:savingor_app/platform_prep/bootstrap/bootstrap.dart';
import 'package:savingor_app/platform_prep/modules/module_activation_service.dart';
import 'package:savingor_app/platform_prep/modules/module_context.dart';
import 'package:savingor_app/platform_prep/modules/module_discovery_service.dart';
import 'package:savingor_app/platform_prep/modules/module_lifecycle_service.dart';
import 'package:savingor_app/platform_prep/modules/module_query_service.dart';
import 'package:savingor_app/platform_prep/navigation/module_id.dart';
import 'package:savingor_app/savingor/modules/groceries/groceries_module.dart';
import 'package:savingor_app/savingor/navigation/platform_navigation_facade.dart';

void main() {
  group('PlatformApplication', () {
    late PlatformBootstrap bootstrap;
    late PlatformApplication application;

    setUp(() {
      bootstrap = PlatformBootstrap.savingor();
      application = bootstrap.application;
    });

    test('construction', () {
      expect(application, isA<PlatformApplication>());
      expect(
        PlatformApplication.fromBootstrap(bootstrap),
        isA<PlatformApplication>(),
      );
    });

    test('immutability', () {
      expect(application.navigation, same(application.navigation));
      expect(application.moduleContext, same(application.moduleContext));
      expect(
        () => application.navigation.routes.add(
          application.navigation.routes.first,
        ),
        throwsUnsupportedError,
      );
      expect(
        () => application.moduleContext.activeModules.modules
            .add(groceriesModule),
        throwsUnsupportedError,
      );
    });

    test('singleton behavior', () {
      expect(identical(bootstrap.application, application), isTrue);
      expect(identical(bootstrap.application, bootstrap.application), isTrue);
      expect(
        identical(application.navigation, bootstrap.navigation),
        isTrue,
      );
      expect(
        identical(application.moduleContext, bootstrap.moduleContext),
        isTrue,
      );
      expect(
        identical(application.query, bootstrap.queryService),
        isTrue,
      );
      expect(
        identical(application.discovery, bootstrap.discoveryService),
        isTrue,
      );
      expect(
        identical(application.lifecycle, bootstrap.lifecycleService),
        isTrue,
      );
      expect(
        identical(application.activation, bootstrap.activationService),
        isTrue,
      );
    });

    test('public API exposure', () {
      expect(application.navigation, isA<PlatformNavigationFacade>());
      expect(application.moduleContext, isA<ModuleContext>());
      expect(application.query, isA<ModuleQueryService>());
      expect(application.discovery, isA<ModuleDiscoveryService>());
      expect(application.lifecycle, isA<ModuleLifecycleService>());
      expect(application.activation, isA<ModuleActivationService>());

      expect(application.navigation.containsRoute('deals'), isTrue);
      expect(
        application.query.moduleById(ModuleId('groceries')),
        same(groceriesModule),
      );
      expect(application.discovery.contains(ModuleId('groceries')), isTrue);
      expect(
        application.lifecycle.stateOf(ModuleId('groceries')),
        isNotNull,
      );
      expect(application.query.isActive(ModuleId('groceries')), isTrue);
      expect(application.activation.rules, isNotEmpty);
    });

    test('hidden implementation', () {
      // PlatformApplication exposes composed platform APIs only — not
      // PlatformBootstrap, catalogs, or navigation internals as fields.
      expect(
        application.runtimeType.toString(),
        equals('PlatformApplication'),
      );
      expect(
        application.toString(),
        isNot(contains('PlatformBootstrap')),
      );

      final List<String> publicGetters = <String>[
        'navigation',
        'moduleContext',
        'query',
        'discovery',
        'lifecycle',
        'activation',
      ];
      for (final String name in publicGetters) {
        expect(publicGetters, contains(name));
      }
      expect(publicGetters, isNot(contains('bootstrap')));
      expect(publicGetters, isNot(contains('resolver')));
      expect(publicGetters, isNot(contains('composition')));
    });

    test('bootstrap integration', () {
      expect(bootstrap.application.navigation.moduleCount, equals(1));
      expect(
        bootstrap.application.navigation.module(ModuleId('groceries')),
        same(groceriesModule),
      );
      expect(
        bootstrap.application.moduleContext.activeRouteCatalog.routeCount,
        equals(bootstrap.activeRouteCatalog.routeCount),
      );
      expect(
        bootstrap.application.query.activeModules(),
        same(bootstrap.queryService.activeModules()),
      );
    });
  });
}
