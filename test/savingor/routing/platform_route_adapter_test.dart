import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';

import 'package:savingor_app/platform_prep/modules/active_module_set.dart';
import 'package:savingor_app/platform_prep/navigation/active_route_catalog.dart';
import 'package:savingor_app/platform_prep/navigation/app_module.dart';
import 'package:savingor_app/platform_prep/navigation/module_id.dart';
import 'package:savingor_app/platform_prep/navigation/route_contribution.dart';
import 'package:savingor_app/platform_prep/navigation/shell_tab_contribution.dart';
import 'package:savingor_app/savingor/modules/groceries/groceries_module.dart';
import 'package:savingor_app/savingor/routing/routing.dart';

void main() {
  const Key groceriesWidgetKey = Key('groceries-test-route');

  Widget groceriesTestBuilder(BuildContext context) {
    return const SizedBox(key: groceriesWidgetKey);
  }

  group('PlatformRouteAdapter', () {
    test('builds one GoRoute for the active Groceries route', () {
      final ActiveRouteCatalog catalog = ActiveRouteCatalog(
        ActiveModuleSet(<AppModule>[
          _SingleRouteModule(
            id: 'groceries',
            route: RouteContribution(name: 'deals', path: '/deals'),
          ),
        ]),
      );
      final PlatformRouteAdapter adapter = PlatformRouteAdapter(
        catalog: catalog,
        bindings: PlatformRouteBindingRegistry(<PlatformRouteBinding>[
          PlatformRouteBinding(
            routeName: 'deals',
            routePath: '/deals',
            builder: groceriesTestBuilder,
          ),
        ]),
      );

      final List<GoRoute> routes = adapter.buildRoutes();
      expect(routes, hasLength(1));
      expect(routes.single.name, equals('deals'));
      expect(routes.single.path, equals('/deals'));
    });

    test('route name and path match the active contribution', () {
      final RouteContribution contribution =
          groceriesModule.routeContributions.first;
      final ActiveRouteCatalog catalog = ActiveRouteCatalog(
        ActiveModuleSet(<AppModule>[
          _SingleRouteModule(id: 'groceries', route: contribution),
        ]),
      );
      final PlatformRouteAdapter adapter = PlatformRouteAdapter(
        catalog: catalog,
        bindings: PlatformRouteBindingRegistry(<PlatformRouteBinding>[
          PlatformRouteBinding(
            routeName: contribution.name,
            routePath: contribution.path,
            builder: groceriesTestBuilder,
          ),
        ]),
      );

      final GoRoute route = adapter.buildRoutes().single;
      expect(route.name, equals(contribution.name));
      expect(route.path, equals(contribution.path));
    });

    testWidgets('builder returns the expected test widget', (
      WidgetTester tester,
    ) async {
      final ActiveRouteCatalog catalog = ActiveRouteCatalog(
        ActiveModuleSet(<AppModule>[
          _SingleRouteModule(
            id: 'groceries',
            route: RouteContribution(name: 'deals', path: '/deals'),
          ),
        ]),
      );
      final PlatformRouteAdapter adapter = PlatformRouteAdapter(
        catalog: catalog,
        bindings: PlatformRouteBindingRegistry(<PlatformRouteBinding>[
          PlatformRouteBinding(
            routeName: 'deals',
            routePath: '/deals',
            builder: groceriesTestBuilder,
          ),
        ]),
      );

      final GoRoute route = adapter.buildRoutes().single;
      final GoRouter router = GoRouter(
        initialLocation: '/deals',
        routes: <RouteBase>[route],
      );

      await tester.pumpWidget(
        MaterialApp.router(routerConfig: router),
      );

      expect(find.byKey(groceriesWidgetKey), findsOneWidget);
    });

    test('route order follows ActiveRouteCatalog', () {
      final ActiveRouteCatalog catalog = ActiveRouteCatalog(
        ActiveModuleSet(<AppModule>[
          _FakeModule(
            id: 'a',
            routes: <RouteContribution>[
              RouteContribution(name: 'first', path: '/first'),
              RouteContribution(name: 'second', path: '/second'),
            ],
          ),
          _FakeModule(
            id: 'b',
            routes: <RouteContribution>[
              RouteContribution(name: 'third', path: '/third'),
            ],
          ),
        ]),
      );
      final PlatformRouteAdapter adapter = PlatformRouteAdapter(
        catalog: catalog,
        bindings: PlatformRouteBindingRegistry(<PlatformRouteBinding>[
          PlatformRouteBinding(
            routeName: 'first',
            routePath: '/first',
            builder: (_) => const SizedBox(),
          ),
          PlatformRouteBinding(
            routeName: 'third',
            routePath: '/third',
            builder: (_) => const SizedBox(),
          ),
          PlatformRouteBinding(
            routeName: 'second',
            routePath: '/second',
            builder: (_) => const SizedBox(),
          ),
        ]),
      );

      expect(
        adapter.buildRoutes().map((GoRoute r) => r.name).toList(),
        <String>['first', 'second', 'third'],
      );
    });

    test('missing binding throws StateError', () {
      expect(
        () => PlatformRouteAdapter(
          catalog: ActiveRouteCatalog(
            ActiveModuleSet(<AppModule>[
              _SingleRouteModule(
                id: 'groceries',
                route: RouteContribution(name: 'deals', path: '/deals'),
              ),
            ]),
          ),
          bindings:
              PlatformRouteBindingRegistry(const <PlatformRouteBinding>[]),
        ),
        throwsA(
          isA<StateError>().having(
            (StateError e) => e.message,
            'message',
            contains('Missing route binding'),
          ),
        ),
      );
    });

    test('mismatched name/path throws StateError', () {
      expect(
        () => PlatformRouteAdapter(
          catalog: ActiveRouteCatalog(
            ActiveModuleSet(<AppModule>[
              _SingleRouteModule(
                id: 'groceries',
                route: RouteContribution(name: 'deals', path: '/deals'),
              ),
            ]),
          ),
          bindings: PlatformRouteBindingRegistry(<PlatformRouteBinding>[
            PlatformRouteBinding(
              routeName: 'deals',
              routePath: '/wrong',
              builder: (_) => const SizedBox(),
            ),
          ]),
        ),
        throwsA(
          isA<StateError>().having(
            (StateError e) => e.message,
            'message',
            contains('mismatch'),
          ),
        ),
      );
    });

    test('duplicate binding names throw StateError', () {
      expect(
        () => PlatformRouteBindingRegistry(<PlatformRouteBinding>[
          PlatformRouteBinding(
            routeName: 'deals',
            routePath: '/deals',
            builder: (_) => const SizedBox(),
          ),
          PlatformRouteBinding(
            routeName: 'deals',
            routePath: '/other',
            builder: (_) => const SizedBox(),
          ),
        ]),
        throwsA(
          isA<StateError>().having(
            (StateError e) => e.message,
            'message',
            contains('deals'),
          ),
        ),
      );
    });

    test('duplicate binding paths throw StateError', () {
      expect(
        () => PlatformRouteBindingRegistry(<PlatformRouteBinding>[
          PlatformRouteBinding(
            routeName: 'a',
            routePath: '/deals',
            builder: (_) => const SizedBox(),
          ),
          PlatformRouteBinding(
            routeName: 'b',
            routePath: '/deals',
            builder: (_) => const SizedBox(),
          ),
        ]),
        throwsA(
          isA<StateError>().having(
            (StateError e) => e.message,
            'message',
            contains('/deals'),
          ),
        ),
      );
    });

    test('extra binding for an inactive/unknown route throws StateError', () {
      expect(
        () => PlatformRouteAdapter(
          catalog: ActiveRouteCatalog(
            ActiveModuleSet(<AppModule>[
              _SingleRouteModule(
                id: 'groceries',
                route: RouteContribution(name: 'deals', path: '/deals'),
              ),
            ]),
          ),
          bindings: PlatformRouteBindingRegistry(<PlatformRouteBinding>[
            PlatformRouteBinding(
              routeName: 'deals',
              routePath: '/deals',
              builder: (_) => const SizedBox(),
            ),
            PlatformRouteBinding(
              routeName: 'fuel-home',
              routePath: '/fuel',
              builder: (_) => const SizedBox(),
            ),
          ]),
        ),
        throwsA(
          isA<StateError>().having(
            (StateError e) => e.message,
            'message',
            contains('Extra route binding'),
          ),
        ),
      );
    });

    test('returned route list is unmodifiable', () {
      final PlatformRouteAdapter adapter = PlatformRouteAdapter(
        catalog: ActiveRouteCatalog(
          ActiveModuleSet(<AppModule>[
            _SingleRouteModule(
              id: 'groceries',
              route: RouteContribution(name: 'deals', path: '/deals'),
            ),
          ]),
        ),
        bindings: PlatformRouteBindingRegistry(<PlatformRouteBinding>[
          PlatformRouteBinding(
            routeName: 'deals',
            routePath: '/deals',
            builder: groceriesTestBuilder,
          ),
        ]),
      );

      final List<GoRoute> routes = adapter.buildRoutes();
      expect(
        () => routes.add(routes.first),
        throwsUnsupportedError,
      );
    });
  });
}

class _SingleRouteModule implements AppModule {
  _SingleRouteModule({
    required String id,
    required RouteContribution route,
  })  : id = ModuleId(id),
        routeContributions = List<RouteContribution>.unmodifiable(
          <RouteContribution>[route],
        ),
        shellTabs = const <ShellTabContribution>[];

  @override
  final ModuleId id;

  @override
  final List<RouteContribution> routeContributions;

  @override
  final List<ShellTabContribution> shellTabs;
}

class _FakeModule implements AppModule {
  _FakeModule({
    required String id,
    required List<RouteContribution> routes,
  })  : id = ModuleId(id),
        routeContributions = List<RouteContribution>.unmodifiable(routes),
        shellTabs = const <ShellTabContribution>[];

  @override
  final ModuleId id;

  @override
  final List<RouteContribution> routeContributions;

  @override
  final List<ShellTabContribution> shellTabs;
}
