import 'package:flutter_test/flutter_test.dart';
import 'package:savingor_app/platform_prep/bootstrap/bootstrap.dart';
import 'package:savingor_app/platform_prep/modules/modules.dart';
import 'package:savingor_app/platform_prep/navigation/module_id.dart';
import 'package:savingor_app/savingor/modules/groceries/groceries_module.dart';

void main() {
  group('ModuleQueryService', () {
    late PlatformBootstrap bootstrap;
    late ModuleQueryService query;

    setUp(() {
      bootstrap = PlatformBootstrap.savingor();
      query = bootstrap.queryService;
    });

    test('query by id', () {
      expect(query.moduleById(ModuleId('groceries')), same(groceriesModule));
      expect(query.moduleById(ModuleId('fuel')), isNull);
      expect(query.exists(ModuleId('groceries')), isTrue);
      expect(query.exists(ModuleId('fuel')), isFalse);
    });

    test('active lookup', () {
      expect(query.activeModules(), hasLength(1));
      expect(query.activeModules().single, same(groceriesModule));
      expect(query.isActive(ModuleId('groceries')), isTrue);
      expect(query.isActive(ModuleId('fuel')), isFalse);
      expect(query.registeredModules(), equals(query.activeModules()));
    });

    test('lifecycle lookup', () {
      final ModuleLifecycleInfo? info =
          query.lifecycleOf(ModuleId('groceries'));
      expect(info, isNotNull);
      expect(info!.module, same(groceriesModule));
      expect(info.state, equals(ModuleLifecycleState.activated));
      expect(query.lifecycleOf(ModuleId('fuel')), isNull);
    });

    test('immutable results', () {
      expect(
        () => query.activeModules().add(groceriesModule),
        throwsUnsupportedError,
      );
      expect(
        () => query.registeredModules().add(groceriesModule),
        throwsUnsupportedError,
      );
    });

    test('bootstrap integration', () {
      expect(bootstrap.queryService, isA<ModuleQueryService>());
      expect(
        identical(bootstrap.moduleContext.queryService, bootstrap.queryService),
        isTrue,
      );
      expect(identical(bootstrap.queryService, query), isTrue);
      expect(
        query.moduleById(ModuleId('groceries')),
        same(bootstrap.discoveryService.findById(ModuleId('groceries'))),
      );
      expect(
        query.lifecycleOf(ModuleId('groceries')),
        same(bootstrap.lifecycleService.infoOf(ModuleId('groceries'))),
      );
    });
  });
}
