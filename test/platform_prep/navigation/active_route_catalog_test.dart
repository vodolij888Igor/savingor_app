import 'package:flutter_test/flutter_test.dart';
import 'package:savingor_app/platform_prep/bootstrap/bootstrap.dart';
import 'package:savingor_app/platform_prep/modules/active_module_set.dart';
import 'package:savingor_app/platform_prep/navigation/active_route_catalog.dart';
import 'package:savingor_app/platform_prep/navigation/app_module.dart';
import 'package:savingor_app/platform_prep/navigation/module_id.dart';
import 'package:savingor_app/platform_prep/navigation/route_contribution.dart';
import 'package:savingor_app/platform_prep/navigation/shell_tab_contribution.dart';
import 'package:savingor_app/savingor/modules/groceries/groceries_module.dart';

void main() {
  group('ActiveRouteCatalog', () {
    test('Groceries routes are present because Groceries is active', () {
      final PlatformBootstrap bootstrap = PlatformBootstrap.savingor();
      final ActiveRouteCatalog catalog = bootstrap.activeRouteCatalog;

      expect(
        catalog.routeCount,
        equals(groceriesModule.routeContributions.length),
      );
      expect(catalog.containsRouteName('deals'), isTrue);
      expect(catalog.containsRoutePath('/deals'), isTrue);
      expect(catalog.findByName('deals')?.path, equals('/deals'));
      expect(catalog.findByPath('/scanner')?.name, equals('scanner'));
      expect(
        catalog.routes.map((RouteContribution r) => r.path).toList(),
        equals(
          groceriesModule.routeContributions
              .map((RouteContribution r) => r.path)
              .toList(),
        ),
      );
    });

    test('inactive registered modules contribute nothing', () {
      final AppModule active = _FakeModule(
        id: 'active',
        routes: <RouteContribution>[
          RouteContribution(name: 'active-home', path: '/active'),
        ],
      );
      final AppModule inactive = _FakeModule(
        id: 'inactive',
        routes: <RouteContribution>[
          RouteContribution(name: 'inactive-home', path: '/inactive'),
        ],
      );
      final ActiveRouteCatalog catalog = ActiveRouteCatalog(
        ActiveModuleSet(<AppModule>[active]),
      );

      expect(catalog.routeCount, equals(1));
      expect(catalog.containsRoutePath('/active'), isTrue);
      expect(catalog.containsRoutePath('/inactive'), isFalse);
      expect(catalog.findByName('inactive-home'), isNull);
      // inactive is registered in the fake sense only; not in ActiveModuleSet.
      expect(inactive.routeContributions, isNotEmpty);
    });

    test('ordering is deterministic', () {
      final AppModule first = _FakeModule(
        id: 'first',
        routes: <RouteContribution>[
          RouteContribution(name: 'a', path: '/a'),
          RouteContribution(name: 'b', path: '/b'),
        ],
      );
      final AppModule second = _FakeModule(
        id: 'second',
        routes: <RouteContribution>[
          RouteContribution(name: 'c', path: '/c'),
        ],
      );
      final ActiveRouteCatalog catalog = ActiveRouteCatalog(
        ActiveModuleSet(<AppModule>[first, second]),
      );

      expect(
        catalog.routes.map((RouteContribution r) => r.name).toList(),
        <String>['a', 'b', 'c'],
      );
    });

    test('duplicate validation works', () {
      expect(
        () => ActiveRouteCatalog(
          ActiveModuleSet(<AppModule>[
            _FakeModule(
              id: 'a',
              routes: <RouteContribution>[
                RouteContribution(name: 'shared', path: '/a'),
              ],
            ),
            _FakeModule(
              id: 'b',
              routes: <RouteContribution>[
                RouteContribution(name: 'shared', path: '/b'),
              ],
            ),
          ]),
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
        () => ActiveRouteCatalog(
          ActiveModuleSet(<AppModule>[
            _FakeModule(
              id: 'a',
              routes: <RouteContribution>[
                RouteContribution(name: 'a', path: '/shared'),
              ],
            ),
            _FakeModule(
              id: 'b',
              routes: <RouteContribution>[
                RouteContribution(name: 'b', path: '/shared'),
              ],
            ),
          ]),
        ),
        throwsA(
          isA<StateError>().having(
            (StateError e) => e.message,
            'message',
            contains('Duplicate route path'),
          ),
        ),
      );
    });

    test('collections are unmodifiable', () {
      final ActiveRouteCatalog catalog =
          PlatformBootstrap.savingor().activeRouteCatalog;

      expect(
        () => catalog.routes.add(catalog.routes.first),
        throwsUnsupportedError,
      );
    });

    test('bootstrap and ModuleContext expose identical catalog instances', () {
      final PlatformBootstrap bootstrap = PlatformBootstrap.savingor();

      expect(
        identical(
          bootstrap.activeRouteCatalog,
          bootstrap.moduleContext.activeRouteCatalog,
        ),
        isTrue,
      );
      expect(
        identical(bootstrap.activeRouteCatalog, bootstrap.activeRouteCatalog),
        isTrue,
      );
    });
  });
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
