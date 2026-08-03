import 'package:flutter_test/flutter_test.dart';

import 'package:savingor_app/platform_prep/activation/activation.dart';
import 'package:savingor_app/platform_prep/bootstrap/bootstrap.dart';
import 'package:savingor_app/platform_prep/lifecycle/lifecycle.dart';
import 'package:savingor_app/platform_prep/modules/module_activation_rule.dart';
import 'package:savingor_app/platform_prep/modules/module_activation_service.dart';
import 'package:savingor_app/platform_prep/navigation/module_id.dart';
import 'package:savingor_app/savingor/modules/groceries/groceries_module.dart';

void main() {
  group('PlatformActivation', () {
    late PlatformBootstrap bootstrap;
    late PlatformActivation activation;

    setUp(() {
      bootstrap = PlatformBootstrap.savingor();
      activation = bootstrap.platformActivation;
    });

    test('activation construction', () {
      expect(activation, isA<PlatformActivation>());
      expect(
        PlatformActivation.fromLifecycle(bootstrap.platformLifecycle),
        isA<PlatformActivation>(),
      );
      expect(
        PlatformActivation.fromBootstrap(bootstrap),
        isA<PlatformActivation>(),
      );
    });

    test('activation queries', () {
      expect(activation.status, equals(PlatformActivationStatus.ready));
      expect(activation.isActivationReady, isTrue);
      expect(activation.isActivationAvailable, isTrue);
      expect(activation.hasActiveModules, isTrue);
      expect(activation.isReadyStatus, isTrue);
      expect(activation.activeModuleCount, equals(1));
      expect(activation.activationRuleCount, greaterThan(0));
      expect(activation.containsActiveModule(ModuleId('groceries')), isTrue);
      expect(
        activation.findActiveModule(ModuleId('groceries')),
        same(groceriesModule),
      );
      expect(activation.findActiveModule(ModuleId('missing')), isNull);
      expect(activation.containsActivationRule(ModuleId('groceries')), isTrue);
      expect(
        activation.findActivationRule(ModuleId('groceries')),
        isA<ModuleActivationRule>(),
      );
      expect(activation.findActivationRule(ModuleId('missing')), isNull);
      expect(activation.activationService, isA<ModuleActivationService>());
    });

    test('immutable collections', () {
      expect(
        () => activation.activeModules.add(groceriesModule),
        throwsUnsupportedError,
      );
      expect(
        () => activation.activationRules.add(activation.activationRules.first),
        throwsUnsupportedError,
      );
    });

    test('lifecycle integration', () {
      expect(
          identical(activation.lifecycle, bootstrap.platformLifecycle), isTrue);
      expect(activation.lifecycle.isActivated, isTrue);
      expect(activation.lifecycle.isReady, isTrue);
      expect(
        identical(
          activation.activationService,
          bootstrap.platformLifecycle.environment.activation,
        ),
        isTrue,
      );
    });

    test('bootstrap construction', () {
      expect(bootstrap.platformActivation, same(activation));
      expect(
        identical(bootstrap.platformActivation, bootstrap.platformActivation),
        isTrue,
      );
      expect(
        PlatformActivation.fromBootstrap(bootstrap).activeModules,
        equals(activation.activeModules),
      );
    });

    test('public exports', () {
      const PlatformActivation Function(PlatformLifecycle lifecycle)
          fromLifecycle = PlatformActivation.fromLifecycle;
      const PlatformActivation Function(PlatformBootstrap bootstrap)
          fromBootstrap = PlatformActivation.fromBootstrap;

      expect(
        fromLifecycle(bootstrap.platformLifecycle),
        isA<PlatformActivation>(),
      );
      expect(fromBootstrap(bootstrap), isA<PlatformActivation>());
      expect(PlatformActivationStatus.ready, isNotNull);
      expect(activation, isA<PlatformActivation>());
    });
  });
}
