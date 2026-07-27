import 'package:flutter_test/flutter_test.dart';
import 'package:savingor_app/platform_prep/bootstrap/bootstrap.dart';
import 'package:savingor_app/platform_prep/navigation/module_id.dart';
import 'package:savingor_app/savingor/modules/groceries/groceries_module.dart';

void main() {
  group('PlatformBootstrap.savingor', () {
    late PlatformBootstrap bootstrap;

    setUp(() {
      bootstrap = PlatformBootstrap.savingor();
    });

    test('builds successfully', () {
      expect(bootstrap, isA<PlatformBootstrap>());
    });

    test('registry is available', () {
      expect(bootstrap.moduleRegistry, isNotNull);
      expect(bootstrap.moduleRegistry.modules, isNotEmpty);
    });

    test('loader is available', () {
      expect(bootstrap.moduleLoader, isNotNull);
    });

    test('featureFlags is available', () {
      expect(bootstrap.featureFlags, isNotNull);
    });

    test('loader moduleCount is 1', () {
      expect(bootstrap.moduleLoader.moduleCount, equals(1));
    });

    test('groceries module exists', () {
      expect(
        bootstrap.moduleLoader.get(ModuleId('groceries')),
        same(groceriesModule),
      );
      expect(bootstrap.moduleLoader.contains(ModuleId('groceries')), isTrue);
    });
  });
}
