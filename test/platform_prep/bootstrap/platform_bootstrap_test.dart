import 'package:flutter_test/flutter_test.dart';
import 'package:savingor_app/platform_prep/bootstrap/bootstrap.dart';
import 'package:savingor_app/platform_prep/navigation/module_id.dart';
import 'package:savingor_app/platform_prep/navigation/route_catalog.dart';
import 'package:savingor_app/platform_prep/navigation/shell_tab_catalog.dart';
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

    test('routeCatalog is available', () {
      expect(bootstrap.routeCatalog, isA<RouteCatalog>());
      expect(bootstrap.routeCatalog.routes, isNotEmpty);
    });

    test('shellTabCatalog is available', () {
      expect(bootstrap.shellTabCatalog, isA<ShellTabCatalog>());
      expect(bootstrap.shellTabCatalog.tabs, isNotEmpty);
    });

    test('catalogs are built exactly once', () {
      final RouteCatalog routes = bootstrap.routeCatalog;
      final ShellTabCatalog tabs = bootstrap.shellTabCatalog;

      expect(identical(bootstrap.routeCatalog, routes), isTrue);
      expect(identical(bootstrap.shellTabCatalog, tabs), isTrue);
    });

    test('registry, loader, and catalogs remain internally consistent', () {
      expect(
        bootstrap.moduleLoader.modules,
        same(bootstrap.moduleRegistry.modules),
      );
      expect(bootstrap.moduleLoader.moduleCount, equals(1));
      expect(
        bootstrap.moduleLoader.get(ModuleId('groceries')),
        same(groceriesModule),
      );

      expect(
        bootstrap.routeCatalog.routes.length,
        equals(groceriesModule.routeContributions.length),
      );
      expect(
        bootstrap.shellTabCatalog.tabCount,
        equals(groceriesModule.shellTabs.length),
      );
      expect(bootstrap.routeCatalog.containsRoutePath('/deals'), isTrue);
      expect(bootstrap.shellTabCatalog.containsStableKey('home'), isTrue);
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
