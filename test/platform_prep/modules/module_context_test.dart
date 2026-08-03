import 'package:flutter_test/flutter_test.dart';
import 'package:savingor_app/platform_prep/bootstrap/bootstrap.dart';
import 'package:savingor_app/platform_prep/modules/module_context.dart';
import 'package:savingor_app/platform_prep/navigation/module_id.dart';
import 'package:savingor_app/savingor/modules/groceries/groceries_module.dart';

void main() {
  group('ModuleContext', () {
    late PlatformBootstrap bootstrap;
    late ModuleContext context;

    setUp(() {
      bootstrap = PlatformBootstrap.savingor();
      context = bootstrap.moduleContext;
    });

    test('context exposes all services', () {
      expect(context.bootstrap, isNotNull);
      expect(context.moduleRegistry, isNotNull);
      expect(context.moduleLoader, isNotNull);
      expect(context.featureFlags, isNotNull);
      expect(context.routeCatalog, isNotNull);
      expect(context.shellTabCatalog, isNotNull);
      expect(context.activeRouteCatalog, isNotNull);
      expect(context.activeShellTabCatalog, isNotNull);
      expect(context.activationService, isNotNull);
      expect(context.activeModules, isNotNull);
      expect(context.lifecycleService, isNotNull);
      expect(context.discoveryService, isNotNull);
      expect(context.queryService, isNotNull);
    });

    test('same singleton instances as bootstrap', () {
      expect(identical(context.bootstrap, bootstrap), isTrue);
      expect(
        identical(context.moduleRegistry, bootstrap.moduleRegistry),
        isTrue,
      );
      expect(identical(context.moduleLoader, bootstrap.moduleLoader), isTrue);
      expect(identical(context.featureFlags, bootstrap.featureFlags), isTrue);
      expect(identical(context.routeCatalog, bootstrap.routeCatalog), isTrue);
      expect(
        identical(context.shellTabCatalog, bootstrap.shellTabCatalog),
        isTrue,
      );
      expect(
        identical(context.activeRouteCatalog, bootstrap.activeRouteCatalog),
        isTrue,
      );
      expect(
        identical(
          context.activeShellTabCatalog,
          bootstrap.activeShellTabCatalog,
        ),
        isTrue,
      );
      expect(
        identical(context.activationService, bootstrap.activationService),
        isTrue,
      );
      expect(identical(context.activeModules, bootstrap.activeModules), isTrue);
      expect(
        identical(context.lifecycleService, bootstrap.lifecycleService),
        isTrue,
      );
      expect(
        identical(context.discoveryService, bootstrap.discoveryService),
        isTrue,
      );
      expect(
        identical(context.queryService, bootstrap.queryService),
        isTrue,
      );
    });

    test('context is built once and immutable', () {
      expect(identical(bootstrap.moduleContext, context), isTrue);
      expect(
        () => context.activeModules.modules.add(groceriesModule),
        throwsUnsupportedError,
      );
      expect(
        () =>
            context.routeCatalog.routes.add(context.routeCatalog.routes.first),
        throwsUnsupportedError,
      );
      expect(
        () => context.shellTabCatalog.tabs
            .add(context.shellTabCatalog.tabs.first),
        throwsUnsupportedError,
      );
    });

    test('bootstrap consistency through context', () {
      expect(context.moduleLoader.moduleCount, equals(1));
      expect(
        context.moduleLoader.get(ModuleId('groceries')),
        same(groceriesModule),
      );
      expect(
        context.activeModules.findById(ModuleId('groceries')),
        same(groceriesModule),
      );
      expect(
        context.routeCatalog.routes.length,
        equals(groceriesModule.routeContributions.length),
      );
      expect(
        context.shellTabCatalog.tabCount,
        equals(groceriesModule.shellTabs.length),
      );
      expect(
        context.moduleLoader.modules,
        same(context.moduleRegistry.modules),
      );
    });
  });
}
