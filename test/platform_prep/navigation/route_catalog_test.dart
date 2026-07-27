import 'package:flutter_test/flutter_test.dart';
import 'package:savingor_app/platform_prep/navigation/app_module.dart';
import 'package:savingor_app/platform_prep/navigation/module_id.dart';
import 'package:savingor_app/platform_prep/navigation/module_registry.dart';
import 'package:savingor_app/platform_prep/navigation/route_catalog.dart';
import 'package:savingor_app/platform_prep/navigation/route_contribution.dart';
import 'package:savingor_app/platform_prep/navigation/shell_tab_contribution.dart';
import 'package:savingor_app/savingor/modules/groceries/groceries_module.dart';
import 'package:savingor_app/savingor/modules/module_loader.dart';
import 'package:savingor_app/savingor/modules/savingor_module_registry.dart';

void main() {
  group('RouteCatalog', () {
    test('collects routes from registered modules in order', () {
      final RouteCatalog catalog = RouteCatalog(
        ModuleLoader(savingorModuleRegistry),
      );

      expect(catalog.routes, isNotEmpty);
      expect(
        catalog.routes.first.path,
        equals(groceriesModule.routeContributions.first.path),
      );
      expect(
        catalog.routes.length,
        equals(groceriesModule.routeContributions.length),
      );
      expect(
        catalog.routes.map((RouteContribution r) => r.path).toList(),
        equals(
          groceriesModule.routeContributions
              .map((RouteContribution r) => r.path)
              .toList(),
        ),
      );
    });

    test('preserves multi-module registration order', () {
      final AppModule first = _FakeModule(
        id: 'first',
        routes: <RouteContribution>[
          RouteContribution(name: 'a', path: '/a'),
        ],
      );
      final AppModule second = _FakeModule(
        id: 'second',
        routes: <RouteContribution>[
          RouteContribution(name: 'b', path: '/b'),
          RouteContribution(name: 'c', path: '/c'),
        ],
      );
      final RouteCatalog catalog = RouteCatalog(
        ModuleLoader(
          ModuleRegistry(<AppModule>[first, second]),
        ),
      );

      expect(
        catalog.routes.map((RouteContribution r) => r.name).toList(),
        <String>['a', 'b', 'c'],
      );
    });

    test('containsRouteName and containsRoutePath', () {
      final RouteCatalog catalog = RouteCatalog(
        ModuleLoader(savingorModuleRegistry),
      );

      expect(catalog.containsRouteName('deals'), isTrue);
      expect(catalog.containsRoutePath('/deals'), isTrue);
      expect(catalog.containsRouteName('missing'), isFalse);
      expect(catalog.containsRoutePath('/missing'), isFalse);
    });

    test('rejects duplicate route names across modules', () {
      expect(
        () => RouteCatalog(
          _StubLoader(<AppModule>[
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
    });

    test('rejects duplicate route paths across modules', () {
      expect(
        () => RouteCatalog(
          _StubLoader(<AppModule>[
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

    test('routes collection is unmodifiable', () {
      final RouteCatalog catalog = RouteCatalog(
        ModuleLoader(savingorModuleRegistry),
      );

      expect(
        () => catalog.routes.add(catalog.routes.first),
        throwsUnsupportedError,
      );
    });
  });
}

class _StubLoader extends ModuleLoader {
  _StubLoader(this._modules) : super(ModuleRegistry(const <AppModule>[]));

  final List<AppModule> _modules;

  @override
  List<AppModule> get modules => _modules;
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
