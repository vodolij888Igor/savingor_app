import 'package:flutter_test/flutter_test.dart';

import 'package:savingor_app/platform_prep/bootstrap/bootstrap.dart';
import 'package:savingor_app/platform_prep/environment/environment.dart';
import 'package:savingor_app/platform_prep/lifecycle/lifecycle.dart';
import 'package:savingor_app/platform_prep/modules/module_lifecycle_service.dart';
import 'package:savingor_app/savingor/modules/groceries/groceries_module.dart';

void main() {
  group('PlatformLifecycle', () {
    late PlatformBootstrap bootstrap;
    late PlatformLifecycle lifecycle;

    setUp(() {
      bootstrap = PlatformBootstrap.savingor();
      lifecycle = bootstrap.platformLifecycle;
    });

    test('lifecycle construction', () {
      expect(lifecycle, isA<PlatformLifecycle>());
      expect(
        PlatformLifecycle.fromEnvironment(bootstrap.environment),
        isA<PlatformLifecycle>(),
      );
      expect(
        PlatformLifecycle.fromBootstrap(bootstrap),
        isA<PlatformLifecycle>(),
      );
    });

    test('lifecycle state queries', () {
      expect(lifecycle.isInitialized, isTrue);
      expect(lifecycle.isBootstrapComplete, isTrue);
      expect(lifecycle.isActivated, isTrue);
      expect(lifecycle.isReady, isTrue);
      expect(lifecycle.status, equals(PlatformLifecycleStatus.ready));
      expect(lifecycle.isReadyStatus, isTrue);
      expect(lifecycle.hasCompletedBootstrap, isTrue);
      expect(lifecycle.hasActiveModules, isTrue);
      expect(lifecycle.moduleLifecycle, isA<ModuleLifecycleService>());
      expect(
        lifecycle.moduleLifecycle.activated,
        contains(groceriesModule),
      );
    });

    test('immutable behavior', () {
      expect(lifecycle.environment, same(lifecycle.environment));
      expect(lifecycle.status, same(lifecycle.status));
      expect(
        () => lifecycle.moduleLifecycle.activated.add(groceriesModule),
        throwsUnsupportedError,
      );
      expect(
        identical(bootstrap.platformLifecycle, bootstrap.platformLifecycle),
        isTrue,
      );
    });

    test('bootstrap integration', () {
      expect(bootstrap.platformLifecycle, same(lifecycle));
      expect(
        identical(lifecycle.environment, bootstrap.environment),
        isTrue,
      );
      expect(
        identical(lifecycle.moduleLifecycle, bootstrap.lifecycleService),
        isTrue,
      );
    });

    test('public exports', () {
      const PlatformLifecycle Function(PlatformEnvironment environment)
          fromEnvironment = PlatformLifecycle.fromEnvironment;
      const PlatformLifecycle Function(PlatformBootstrap bootstrap)
          fromBootstrap = PlatformLifecycle.fromBootstrap;

      expect(fromEnvironment(bootstrap.environment), isA<PlatformLifecycle>());
      expect(fromBootstrap(bootstrap), isA<PlatformLifecycle>());
      expect(PlatformLifecycleStatus.ready, isNotNull);
      expect(lifecycle, isA<PlatformLifecycle>());
    });

    test('environment integration', () {
      final PlatformLifecycle fromEnvironment =
          PlatformLifecycle.fromEnvironment(bootstrap.environment);

      expect(fromEnvironment.isReady, isTrue);
      expect(fromEnvironment.status, equals(PlatformLifecycleStatus.ready));
      expect(
        identical(fromEnvironment.environment, bootstrap.environment),
        isTrue,
      );
      expect(
        identical(
            fromEnvironment.moduleLifecycle, bootstrap.environment.lifecycle),
        isTrue,
      );
      expect(
        fromEnvironment.hasActiveModules,
        equals(bootstrap.environment.query.activeModules().isNotEmpty),
      );
    });
  });
}
