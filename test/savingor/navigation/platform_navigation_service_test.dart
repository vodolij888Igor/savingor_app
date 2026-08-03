import 'package:flutter_test/flutter_test.dart';

import 'package:savingor_app/platform_prep/navigation/app_module.dart';
import 'package:savingor_app/platform_prep/navigation/module_id.dart';
import 'package:savingor_app/platform_prep/navigation/route_contribution.dart';
import 'package:savingor_app/platform_prep/navigation/shell_tab_contribution.dart';
import 'package:savingor_app/savingor/navigation/navigation.dart';

void main() {
  late RouteContribution dealsRoute;
  late RouteContribution scannerRoute;
  late ShellTabContribution homeTab;
  late AppModule groceries;
  late NavigationResolver resolver;
  late PlatformNavigationService service;

  setUp(() {
    dealsRoute = RouteContribution(name: 'deals', path: '/deals');
    scannerRoute = RouteContribution(name: 'scanner', path: '/scanner');
    homeTab = ShellTabContribution(
      key: 'home',
      routePath: '/deals',
      sortOrder: 0,
    );
    groceries = _FakeModule(
      id: 'groceries',
      routes: <RouteContribution>[dealsRoute, scannerRoute],
      tabs: <ShellTabContribution>[homeTab],
    );
    final ProductionNavigationComposition composition =
        ProductionNavigationComposition(
      routes: <RouteContribution>[dealsRoute, scannerRoute],
      shellTabs: <ShellTabContribution>[homeTab],
      modules: <AppModule>[groceries],
    );
    resolver = NavigationResolver(composition: composition);
    service = PlatformNavigationService(resolver: resolver);
  });

  group('PlatformNavigationService', () {
    test('all public methods — valid lookups', () {
      expect(service.routeByName('deals'), same(dealsRoute));
      expect(service.routeByPath('/scanner'), same(scannerRoute));
      expect(service.shellTab('home'), same(homeTab));
      expect(service.module(ModuleId('groceries')), same(groceries));
      expect(service.containsRoute('deals'), isTrue);
      expect(service.containsRoute('scanner'), isTrue);
      expect(service.containsShellTab('home'), isTrue);
      expect(service.containsModule(ModuleId('groceries')), isTrue);
      expect(service.routes, hasLength(2));
      expect(service.shellTabs, hasLength(1));
      expect(service.modules, hasLength(1));
    });

    test('invalid lookups', () {
      expect(service.containsRoute('missing'), isFalse);
      expect(service.containsShellTab('missing'), isFalse);
      expect(service.containsModule(ModuleId('missing')), isFalse);

      expect(
        () => service.routeByName('missing'),
        throwsA(
          isA<StateError>().having(
            (StateError e) => e.message,
            'message',
            contains('Unknown route name'),
          ),
        ),
      );
      expect(
        () => service.routeByPath('/missing'),
        throwsA(
          isA<StateError>().having(
            (StateError e) => e.message,
            'message',
            contains('Unknown route path'),
          ),
        ),
      );
      expect(
        () => service.shellTab('missing'),
        throwsA(
          isA<StateError>().having(
            (StateError e) => e.message,
            'message',
            contains('Unknown shell tab key'),
          ),
        ),
      );
      expect(
        () => service.module(ModuleId('missing')),
        throwsA(
          isA<StateError>().having(
            (StateError e) => e.message,
            'message',
            contains('Unknown module id'),
          ),
        ),
      );
    });

    test('immutability', () {
      expect(
        () => service.routes.add(
          RouteContribution(name: 'x', path: '/x'),
        ),
        throwsUnsupportedError,
      );
      expect(
        () => service.shellTabs.add(
          ShellTabContribution(key: 'x', routePath: '/x', sortOrder: 1),
        ),
        throwsUnsupportedError,
      );
      expect(
        () => service.modules.add(
          _FakeModule(id: 'x', routes: const <RouteContribution>[]),
        ),
        throwsUnsupportedError,
      );
    });

    test('delegation correctness', () {
      expect(service.routeByName('deals'),
          same(resolver.resolveRouteByName('deals')));
      expect(
        service.routeByPath('/scanner'),
        same(resolver.resolveRouteByPath('/scanner')),
      );
      expect(service.shellTab('home'),
          same(resolver.resolveShellTabByKey('home')));
      expect(
        service.module(ModuleId('groceries')),
        same(resolver.resolveModuleById(ModuleId('groceries'))),
      );
      expect(
        service.containsRoute('deals'),
        equals(resolver.findRouteByName('deals') != null),
      );
      expect(
        service.containsShellTab('home'),
        equals(resolver.findShellTabByKey('home') != null),
      );
      expect(
        service.containsModule(ModuleId('groceries')),
        equals(resolver.findModuleById(ModuleId('groceries')) != null),
      );
      expect(identical(service.routes, resolver.routes), isTrue);
      expect(identical(service.shellTabs, resolver.shellTabs), isTrue);
      expect(identical(service.modules, resolver.modules), isTrue);
    });

    test('fromComposition factory delegates through resolver', () {
      final PlatformNavigationService fromComposition =
          PlatformNavigationService.fromComposition(
        ProductionNavigationComposition(
          routes: <RouteContribution>[dealsRoute],
          shellTabs: <ShellTabContribution>[homeTab],
          modules: <AppModule>[groceries],
        ),
      );

      expect(fromComposition.routeByName('deals'), same(dealsRoute));
      expect(fromComposition.containsShellTab('home'), isTrue);
      expect(fromComposition.containsModule(ModuleId('groceries')), isTrue);
    });
  });
}

final class _FakeModule implements AppModule {
  _FakeModule({
    required String id,
    required List<RouteContribution> routes,
    List<ShellTabContribution> tabs = const <ShellTabContribution>[],
  })  : id = ModuleId(id),
        routeContributions = List<RouteContribution>.unmodifiable(routes),
        shellTabs = List<ShellTabContribution>.unmodifiable(tabs);

  @override
  final ModuleId id;

  @override
  final List<RouteContribution> routeContributions;

  @override
  final List<ShellTabContribution> shellTabs;
}
