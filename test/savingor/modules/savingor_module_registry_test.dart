import 'package:flutter_test/flutter_test.dart';
import 'package:savingor_app/platform_prep/navigation/module_id.dart';
import 'package:savingor_app/savingor/modules/modules.dart';

void main() {
  group('savingorModuleRegistry', () {
    test('contains exactly one module', () {
      expect(savingorModuleRegistry.modules, hasLength(1));
    });

    test('the module is Groceries', () {
      expect(savingorModuleRegistry.modules.single, same(groceriesModule));
      expect(
          savingorModuleRegistry.modules.single.id.value, equals('groceries'));
    });

    test('lookup by ModuleId groceries returns groceriesModule', () {
      expect(
        savingorModuleRegistry.findById(ModuleId('groceries')),
        same(groceriesModule),
      );
    });

    test('lookup for an unknown module returns null', () {
      expect(
        savingorModuleRegistry.findById(ModuleId('fuel')),
        isNull,
      );
    });

    test('module collection is unmodifiable', () {
      expect(
        () => savingorModuleRegistry.modules.add(groceriesModule),
        throwsUnsupportedError,
      );
    });

    test('registration order is deterministic', () {
      expect(
        savingorModuleRegistry.modules.map((m) => m.id.value).toList(),
        <String>['groceries'],
      );
    });
  });
}
