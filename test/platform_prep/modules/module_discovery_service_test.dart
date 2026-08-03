import 'package:flutter_test/flutter_test.dart';
import 'package:savingor_app/platform_prep/bootstrap/bootstrap.dart';
import 'package:savingor_app/platform_prep/modules/modules.dart';
import 'package:savingor_app/platform_prep/navigation/module_id.dart';
import 'package:savingor_app/savingor/modules/groceries/groceries_module.dart';

void main() {
  group('ModuleDiscoveryService', () {
    late PlatformBootstrap bootstrap;
    late ModuleDiscoveryService discovery;

    setUp(() {
      bootstrap = PlatformBootstrap.savingor();
      discovery = bootstrap.discoveryService;
    });

    test('discovery returns all registered modules', () {
      expect(discovery.registeredModules, hasLength(1));
      expect(discovery.registeredModules.single, same(groceriesModule));
      expect(
        discovery.registeredModules,
        equals(bootstrap.moduleRegistry.modules),
      );
    });

    test('discovery returns active modules', () {
      expect(discovery.activeModules, hasLength(1));
      expect(discovery.activeModules.single, same(groceriesModule));
      expect(
        discovery.activeModules,
        equals(bootstrap.activeModules.modules),
      );
      expect(
        discovery.modulesByActivationState(ModuleLifecycleState.activated),
        equals(discovery.activeModules),
      );
    });

    test('lookup by id and contains', () {
      expect(discovery.contains(ModuleId('groceries')), isTrue);
      expect(discovery.findById(ModuleId('groceries')), same(groceriesModule));
      expect(discovery.contains(ModuleId('fuel')), isFalse);
      expect(discovery.findById(ModuleId('fuel')), isNull);
    });

    test('immutable collections', () {
      expect(
        () => discovery.registeredModules.add(groceriesModule),
        throwsUnsupportedError,
      );
      expect(
        () => discovery.activeModules.add(groceriesModule),
        throwsUnsupportedError,
      );
      expect(
        () => discovery
            .modulesByActivationState(ModuleLifecycleState.registered)
            .add(groceriesModule),
        throwsUnsupportedError,
      );
    });

    test('bootstrap integration', () {
      expect(bootstrap.discoveryService, isA<ModuleDiscoveryService>());
      expect(
        identical(
          bootstrap.moduleContext.discoveryService,
          bootstrap.discoveryService,
        ),
        isTrue,
      );
      expect(
        identical(bootstrap.discoveryService, discovery),
        isTrue,
      );
      expect(
        discovery.findById(ModuleId('groceries')),
        same(bootstrap.moduleRegistry.findById(ModuleId('groceries'))),
      );
      expect(
        discovery.modulesByActivationState(ModuleLifecycleState.deactivated),
        isEmpty,
      );
    });
  });
}
