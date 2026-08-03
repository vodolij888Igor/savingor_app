import 'package:flutter_test/flutter_test.dart';
import 'package:savingor_app/platform_prep/bootstrap/bootstrap.dart';
import 'package:savingor_app/platform_prep/modules/active_module_set.dart';
import 'package:savingor_app/platform_prep/navigation/active_shell_tab_catalog.dart';
import 'package:savingor_app/platform_prep/navigation/app_module.dart';
import 'package:savingor_app/platform_prep/navigation/module_id.dart';
import 'package:savingor_app/platform_prep/navigation/route_contribution.dart';
import 'package:savingor_app/platform_prep/navigation/shell_tab_contribution.dart';
import 'package:savingor_app/savingor/modules/groceries/groceries_module.dart';

void main() {
  group('ActiveShellTabCatalog', () {
    test('Groceries tabs are present because Groceries is active', () {
      final PlatformBootstrap bootstrap = PlatformBootstrap.savingor();
      final ActiveShellTabCatalog catalog = bootstrap.activeShellTabCatalog;

      expect(catalog.tabCount, equals(groceriesModule.shellTabs.length));
      expect(catalog.containsStableKey('home'), isTrue);
      expect(catalog.findByStableKey('home')?.routePath, equals('/deals'));
      expect(
        catalog.tabs.map((ShellTabContribution t) => t.key).toList(),
        equals(
          groceriesModule.shellTabs
              .map((ShellTabContribution t) => t.key)
              .toList(),
        ),
      );
    });

    test('inactive registered modules contribute nothing', () {
      final AppModule active = _FakeModule(
        id: 'active',
        tabs: <ShellTabContribution>[
          ShellTabContribution(
            key: 'active-tab',
            routePath: '/active',
            sortOrder: 0,
          ),
        ],
      );
      final AppModule inactive = _FakeModule(
        id: 'inactive',
        tabs: <ShellTabContribution>[
          ShellTabContribution(
            key: 'inactive-tab',
            routePath: '/inactive',
            sortOrder: 0,
          ),
        ],
      );
      final ActiveShellTabCatalog catalog = ActiveShellTabCatalog(
        ActiveModuleSet(<AppModule>[active]),
      );

      expect(catalog.tabCount, equals(1));
      expect(catalog.containsStableKey('active-tab'), isTrue);
      expect(catalog.containsStableKey('inactive-tab'), isFalse);
      expect(inactive.shellTabs, isNotEmpty);
    });

    test('ordering is deterministic', () {
      final AppModule first = _FakeModule(
        id: 'first',
        tabs: <ShellTabContribution>[
          ShellTabContribution(key: 'late', routePath: '/late', sortOrder: 10),
          ShellTabContribution(key: 'tie-a', routePath: '/a', sortOrder: 0),
        ],
      );
      final AppModule second = _FakeModule(
        id: 'second',
        tabs: <ShellTabContribution>[
          ShellTabContribution(key: 'tie-b', routePath: '/b', sortOrder: 0),
          ShellTabContribution(key: 'mid', routePath: '/mid', sortOrder: 5),
        ],
      );
      final ActiveShellTabCatalog catalog = ActiveShellTabCatalog(
        ActiveModuleSet(<AppModule>[first, second]),
      );

      expect(
        catalog.tabs.map((ShellTabContribution t) => t.key).toList(),
        <String>['tie-a', 'tie-b', 'mid', 'late'],
      );
    });

    test('duplicate validation works', () {
      expect(
        () => ActiveShellTabCatalog(
          ActiveModuleSet(<AppModule>[
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

    test('collections are unmodifiable', () {
      final ActiveShellTabCatalog catalog =
          PlatformBootstrap.savingor().activeShellTabCatalog;

      expect(
        () => catalog.tabs.add(catalog.tabs.first),
        throwsUnsupportedError,
      );
    });

    test('bootstrap and ModuleContext expose identical catalog instances', () {
      final PlatformBootstrap bootstrap = PlatformBootstrap.savingor();

      expect(
        identical(
          bootstrap.activeShellTabCatalog,
          bootstrap.moduleContext.activeShellTabCatalog,
        ),
        isTrue,
      );
      expect(
        identical(
          bootstrap.activeShellTabCatalog,
          bootstrap.activeShellTabCatalog,
        ),
        isTrue,
      );
    });
  });
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
