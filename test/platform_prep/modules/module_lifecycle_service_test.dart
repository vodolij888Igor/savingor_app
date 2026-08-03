import 'package:flutter_test/flutter_test.dart';
import 'package:savingor_app/platform_prep/bootstrap/bootstrap.dart';
import 'package:savingor_app/platform_prep/modules/modules.dart';
import 'package:savingor_app/platform_prep/navigation/app_module.dart';
import 'package:savingor_app/platform_prep/navigation/module_id.dart';
import 'package:savingor_app/platform_prep/navigation/module_registry.dart';
import 'package:savingor_app/platform_prep/navigation/route_contribution.dart';
import 'package:savingor_app/platform_prep/navigation/shell_tab_contribution.dart';
import 'package:savingor_app/savingor/modules/groceries/groceries_module.dart';
import 'package:savingor_app/savingor/modules/module_loader.dart';

void main() {
  group('ModuleLifecycleService', () {
    test('lifecycle state for groceries is activated', () {
      final PlatformBootstrap bootstrap = PlatformBootstrap.savingor();
      final ModuleLifecycleService lifecycle = bootstrap.lifecycleService;

      expect(
        lifecycle.stateOf(ModuleId('groceries')),
        equals(ModuleLifecycleState.activated),
      );
      expect(lifecycle.isRegistered(ModuleId('groceries')), isTrue);
      expect(lifecycle.infoOf(ModuleId('groceries'))?.module,
          same(groceriesModule));
      expect(
        lifecycle.modulesInState(ModuleLifecycleState.registered),
        contains(groceriesModule),
      );
      expect(
        lifecycle.modulesInState(ModuleLifecycleState.activated),
        contains(groceriesModule),
      );
      expect(
        lifecycle.modulesInState(ModuleLifecycleState.deactivated),
        isEmpty,
      );
    });

    test('immutable collections', () {
      final PlatformBootstrap bootstrap = PlatformBootstrap.savingor();
      final ModuleLifecycleService lifecycle = bootstrap.lifecycleService;

      expect(
        () => lifecycle.entries.add(lifecycle.entries.first),
        throwsUnsupportedError,
      );
      expect(
        () => lifecycle.registered.add(groceriesModule),
        throwsUnsupportedError,
      );
      expect(
        () => lifecycle.activated.add(groceriesModule),
        throwsUnsupportedError,
      );
      expect(
        () => lifecycle.deactivated.add(groceriesModule),
        throwsUnsupportedError,
      );
    });

    test('activation consistency with ActiveModuleSet', () {
      final AppModule activeModule = _FakeModule(id: 'active');
      final AppModule inactiveModule = _FakeModule(id: 'inactive');
      final ModuleLoader loader = ModuleLoader(
        ModuleRegistry(<AppModule>[activeModule, inactiveModule]),
      );
      final ActiveModuleSet active = ActiveModuleSet(<AppModule>[activeModule]);
      final ModuleLifecycleService lifecycle = ModuleLifecycleService(
        loader: loader,
        activeModules: active,
      );

      expect(lifecycle.stateOf(ModuleId('active')),
          ModuleLifecycleState.activated);
      expect(
        lifecycle.stateOf(ModuleId('inactive')),
        ModuleLifecycleState.deactivated,
      );
      expect(lifecycle.stateOf(ModuleId('missing')), isNull);
      expect(
        lifecycle.activated,
        <AppModule>[activeModule],
      );
      expect(
        lifecycle.deactivated,
        <AppModule>[inactiveModule],
      );
      expect(
        lifecycle.registered.map((AppModule m) => m.id.value).toList(),
        <String>['active', 'inactive'],
      );

      // Does not alter activation inputs.
      expect(active.modules, <AppModule>[activeModule]);
      expect(loader.modules, <AppModule>[activeModule, inactiveModule]);
    });

    test('bootstrap integration', () {
      final PlatformBootstrap bootstrap = PlatformBootstrap.savingor();
      final ModuleContext context = bootstrap.moduleContext;

      expect(bootstrap.lifecycleService, isA<ModuleLifecycleService>());
      expect(
        identical(context.lifecycleService, bootstrap.lifecycleService),
        isTrue,
      );
      expect(
        identical(bootstrap.lifecycleService, bootstrap.lifecycleService),
        isTrue,
      );
      expect(
        bootstrap.lifecycleService.activated,
        equals(bootstrap.activeModules.modules),
      );
      expect(
        bootstrap.lifecycleService.activated.first,
        same(bootstrap.activeModules.modules.first),
      );
      expect(
        bootstrap.lifecycleService.registered,
        equals(bootstrap.moduleLoader.modules),
      );
    });
  });
}

class _FakeModule implements AppModule {
  _FakeModule({required String id})
      : id = ModuleId(id),
        routeContributions = List<RouteContribution>.unmodifiable(
          <RouteContribution>[
            RouteContribution(name: '$id-route', path: '/$id'),
          ],
        ),
        shellTabs = const <ShellTabContribution>[];

  @override
  final ModuleId id;

  @override
  final List<RouteContribution> routeContributions;

  @override
  final List<ShellTabContribution> shellTabs;
}
