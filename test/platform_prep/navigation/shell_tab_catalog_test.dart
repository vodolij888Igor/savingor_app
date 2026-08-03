import 'package:flutter_test/flutter_test.dart';
import 'package:savingor_app/platform_prep/navigation/app_module.dart';
import 'package:savingor_app/platform_prep/navigation/module_id.dart';
import 'package:savingor_app/platform_prep/navigation/module_registry.dart';
import 'package:savingor_app/platform_prep/navigation/route_contribution.dart';
import 'package:savingor_app/platform_prep/navigation/shell_tab_catalog.dart';
import 'package:savingor_app/platform_prep/navigation/shell_tab_contribution.dart';
import 'package:savingor_app/savingor/modules/groceries/groceries_module.dart';
import 'package:savingor_app/savingor/modules/module_loader.dart';
import 'package:savingor_app/savingor/modules/savingor_module_registry.dart';

void main() {
  group('ShellTabCatalog', () {
    test('collects tabs from the registered Groceries module', () {
      final ShellTabCatalog catalog = ShellTabCatalog(
        ModuleLoader(savingorModuleRegistry),
      );

      expect(catalog.tabs, isNotEmpty);
      expect(
        catalog.tabs.map((ShellTabContribution t) => t.key).toList(),
        equals(
          groceriesModule.shellTabs
              .map((ShellTabContribution t) => t.key)
              .toList(),
        ),
      );
      expect(
        catalog.tabs.map((ShellTabContribution t) => t.routePath).toList(),
        equals(
          groceriesModule.shellTabs
              .map((ShellTabContribution t) => t.routePath)
              .toList(),
        ),
      );
    });

    test('tabCount is correct', () {
      final ShellTabCatalog catalog = ShellTabCatalog(
        ModuleLoader(savingorModuleRegistry),
      );

      expect(catalog.tabCount, equals(groceriesModule.shellTabs.length));
      expect(catalog.tabCount, equals(5));
    });

    test('tabs are sorted by sortOrder', () {
      final ShellTabCatalog catalog = ShellTabCatalog(
        ModuleLoader(
          ModuleRegistry(<AppModule>[
            _FakeModule(
              id: 'a',
              tabs: <ShellTabContribution>[
                ShellTabContribution(
                  key: 'late',
                  routePath: '/late',
                  sortOrder: 10,
                ),
                ShellTabContribution(
                  key: 'early',
                  routePath: '/early',
                  sortOrder: 1,
                ),
                ShellTabContribution(
                  key: 'mid',
                  routePath: '/mid',
                  sortOrder: 5,
                ),
              ],
            ),
          ]),
        ),
      );

      expect(
        catalog.tabs.map((ShellTabContribution t) => t.key).toList(),
        <String>['early', 'mid', 'late'],
      );
      expect(
        catalog.tabs.map((ShellTabContribution t) => t.sortOrder).toList(),
        <int>[1, 5, 10],
      );
    });

    test('equal sortOrder preserves declaration order', () {
      final ShellTabCatalog catalog = ShellTabCatalog(
        ModuleLoader(
          ModuleRegistry(<AppModule>[
            _FakeModule(
              id: 'first',
              tabs: <ShellTabContribution>[
                ShellTabContribution(
                  key: 'a',
                  routePath: '/a',
                  sortOrder: 0,
                ),
                ShellTabContribution(
                  key: 'b',
                  routePath: '/b',
                  sortOrder: 0,
                ),
              ],
            ),
            _FakeModule(
              id: 'second',
              tabs: <ShellTabContribution>[
                ShellTabContribution(
                  key: 'c',
                  routePath: '/c',
                  sortOrder: 0,
                ),
              ],
            ),
          ]),
        ),
      );

      expect(
        catalog.tabs.map((ShellTabContribution t) => t.key).toList(),
        <String>['a', 'b', 'c'],
      );
    });

    test('containsStableKey returns true and false correctly', () {
      final ShellTabCatalog catalog = ShellTabCatalog(
        ModuleLoader(savingorModuleRegistry),
      );

      expect(catalog.containsStableKey('home'), isTrue);
      expect(catalog.containsStableKey('scanner'), isTrue);
      expect(catalog.containsStableKey('missing'), isFalse);
    });

    test('findByStableKey returns the correct tab', () {
      final ShellTabCatalog catalog = ShellTabCatalog(
        ModuleLoader(savingorModuleRegistry),
      );

      final ShellTabContribution? home = catalog.findByStableKey('home');
      expect(home, isNotNull);
      expect(home!.key, equals('home'));
      expect(home.routePath, equals('/deals'));
      expect(home.sortOrder, equals(0));
    });

    test('unknown stable key returns null', () {
      final ShellTabCatalog catalog = ShellTabCatalog(
        ModuleLoader(savingorModuleRegistry),
      );

      expect(catalog.findByStableKey('fuel'), isNull);
    });

    test('duplicate stable keys throw StateError', () {
      expect(
        () => ShellTabCatalog(
          _StubLoader(<AppModule>[
            _FakeModule(
              id: 'a',
              tabs: <ShellTabContribution>[
                ShellTabContribution(
                  key: 'home',
                  routePath: '/a',
                  sortOrder: 0,
                ),
              ],
            ),
            _FakeModule(
              id: 'b',
              tabs: <ShellTabContribution>[
                ShellTabContribution(
                  key: 'home',
                  routePath: '/b',
                  sortOrder: 1,
                ),
              ],
            ),
          ]),
        ),
        throwsA(
          isA<StateError>().having(
            (StateError e) => e.message,
            'message',
            contains('home'),
          ),
        ),
      );
    });

    test('returned tabs collection is unmodifiable', () {
      final ShellTabCatalog catalog = ShellTabCatalog(
        ModuleLoader(savingorModuleRegistry),
      );

      expect(
        () => catalog.tabs.add(catalog.tabs.first),
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
    required List<ShellTabContribution> tabs,
  })  : id = ModuleId(id),
        routeContributions = List<RouteContribution>.unmodifiable(
          <RouteContribution>[
            RouteContribution(name: '$id-route', path: '/$id'),
          ],
        ),
        shellTabs = List<ShellTabContribution>.unmodifiable(tabs);

  @override
  final ModuleId id;

  @override
  final List<RouteContribution> routeContributions;

  @override
  final List<ShellTabContribution> shellTabs;
}
