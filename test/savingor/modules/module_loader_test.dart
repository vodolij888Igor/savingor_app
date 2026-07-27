import 'package:flutter_test/flutter_test.dart';
import 'package:savingor_app/platform_prep/navigation/module_id.dart';
import 'package:savingor_app/savingor/modules/module_loader.dart';
import 'package:savingor_app/savingor/modules/modules.dart';

void main() {
  late ModuleLoader loader;

  setUp(() {
    loader = ModuleLoader(savingorModuleRegistry);
  });

  group('ModuleLoader', () {
    test('moduleCount matches registry size', () {
      expect(loader.moduleCount, equals(1));
    });

    test('contains groceries', () {
      expect(loader.contains(ModuleId('groceries')), isTrue);
    });

    test('contains unknown is false', () {
      expect(loader.contains(ModuleId('fuel')), isFalse);
    });

    test('get groceries returns groceriesModule', () {
      expect(loader.get(ModuleId('groceries')), same(groceriesModule));
    });

    test('get unknown returns null', () {
      expect(loader.get(ModuleId('fuel')), isNull);
    });

    test('modules collection is unmodifiable', () {
      expect(
        () => loader.modules.add(groceriesModule),
        throwsUnsupportedError,
      );
    });
  });
}
