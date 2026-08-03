import 'package:flutter_test/flutter_test.dart';

import 'package:savingor_app/platform_prep/navigation/app_module.dart';
import 'package:savingor_app/platform_prep/navigation/module_id.dart';
import 'package:savingor_app/platform_prep/navigation/route_contribution.dart';
import 'package:savingor_app/platform_prep/navigation/shell_tab_contribution.dart';
import 'package:savingor_app/savingor/navigation/navigation_resolver.dart';
import 'package:savingor_app/savingor/navigation/production_navigation_composition.dart';

void main() {
  late RouteContribution dealsRoute;
  late RouteContribution scannerRoute;
  late ShellTabContribution homeTab;
  late AppModule groceries;
  late ProductionNavigationComposition composition;
  late NavigationResolver resolver;

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
    composition = ProductionNavigationComposition(
      routes: <RouteContribution>[dealsRoute, scannerRoute],
      shellTabs: <ShellTabContribution>[homeTab],
      modules: <AppModule>[groceries],
    );
    resolver = NavigationResolver(composition: composition);
  });

  group('NavigationResolver', () {
    test('lookup by path', () {
      expect(resolver.findRouteByPath('/deals'), same(dealsRoute));
      expect(resolver.resolveRouteByPath('/scanner'), same(scannerRoute));
    });

    test('lookup by name', () {
      expect(resolver.findRouteByName('deals'), same(dealsRoute));
      expect(resolver.resolveRouteByName('scanner'), same(scannerRoute));
    });

    test('lookup by shell key', () {
      expect(resolver.findShellTabByKey('home'), same(homeTab));
      expect(resolver.resolveShellTabByKey('home'), same(homeTab));
    });

    test('lookup by module id', () {
      expect(resolver.findModuleById(ModuleId('groceries')), same(groceries));
      expect(
          resolver.resolveModuleById(ModuleId('groceries')), same(groceries));
    });

    test('missing entries', () {
      expect(resolver.findRouteByName('missing'), isNull);
      expect(resolver.findRouteByPath('/missing'), isNull);
      expect(resolver.findShellTabByKey('missing'), isNull);
      expect(resolver.findModuleById(ModuleId('missing')), isNull);

      expect(
        () => resolver.resolveRouteByName('missing'),
        throwsA(
          isA<StateError>().having(
            (StateError e) => e.message,
            'message',
            contains('Unknown route name: "missing"'),
          ),
        ),
      );
      expect(
        () => resolver.resolveRouteByPath('/missing'),
        throwsA(
          isA<StateError>().having(
            (StateError e) => e.message,
            'message',
            contains('Unknown route path: "/missing"'),
          ),
        ),
      );
      expect(
        () => resolver.resolveShellTabByKey('missing'),
        throwsA(
          isA<StateError>().having(
            (StateError e) => e.message,
            'message',
            contains('Unknown shell tab key: "missing"'),
          ),
        ),
      );
      expect(
        () => resolver.resolveModuleById(ModuleId('missing')),
        throwsA(
          isA<StateError>().having(
            (StateError e) => e.message,
            'message',
            contains('Unknown module id: "missing"'),
          ),
        ),
      );
    });

    test('duplicate protection', () {
      expect(
        () => ProductionNavigationComposition(
          routes: <RouteContribution>[
            RouteContribution(name: 'deals', path: '/deals'),
            RouteContribution(name: 'deals', path: '/other'),
          ],
          shellTabs: const <ShellTabContribution>[],
          modules: const <AppModule>[],
        ),
        throwsA(
          isA<StateError>().having(
            (StateError e) => e.message,
            'message',
            contains('Duplicate route name'),
          ),
        ),
      );
      expect(
        () => ProductionNavigationComposition(
          routes: <RouteContribution>[
            RouteContribution(name: 'a', path: '/same'),
            RouteContribution(name: 'b', path: '/same'),
          ],
          shellTabs: const <ShellTabContribution>[],
          modules: const <AppModule>[],
        ),
        throwsA(
          isA<StateError>().having(
            (StateError e) => e.message,
            'message',
            contains('Duplicate route path'),
          ),
        ),
      );
      expect(
        () => ProductionNavigationComposition(
          routes: const <RouteContribution>[],
          shellTabs: <ShellTabContribution>[
            ShellTabContribution(key: 'home', routePath: '/a', sortOrder: 0),
            ShellTabContribution(key: 'home', routePath: '/b', sortOrder: 1),
          ],
          modules: const <AppModule>[],
        ),
        throwsA(
          isA<StateError>().having(
            (StateError e) => e.message,
            'message',
            contains('Duplicate shell tab key'),
          ),
        ),
      );
      expect(
        () => ProductionNavigationComposition(
          routes: const <RouteContribution>[],
          shellTabs: const <ShellTabContribution>[],
          modules: <AppModule>[
            _FakeModule(id: 'g', routes: const <RouteContribution>[]),
            _FakeModule(id: 'g', routes: const <RouteContribution>[]),
          ],
        ),
        throwsA(
          isA<StateError>().having(
            (StateError e) => e.message,
            'message',
            contains('Duplicate module id'),
          ),
        ),
      );
    });

    test('immutability', () {
      expect(
        () => resolver.routes.add(
          RouteContribution(name: 'x', path: '/x'),
        ),
        throwsUnsupportedError,
      );
      expect(
        () => resolver.shellTabs.add(
          ShellTabContribution(key: 'x', routePath: '/x', sortOrder: 9),
        ),
        throwsUnsupportedError,
      );
      expect(
        () => resolver.modules.add(
          _FakeModule(id: 'x', routes: const <RouteContribution>[]),
        ),
        throwsUnsupportedError,
      );
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
