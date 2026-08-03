import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:savingor_app/platform_prep/bootstrap/bootstrap.dart';
import 'package:savingor_app/platform_prep/modules/active_module_set.dart';
import 'package:savingor_app/platform_prep/navigation/active_route_catalog.dart';
import 'package:savingor_app/platform_prep/navigation/app_module.dart';
import 'package:savingor_app/platform_prep/navigation/module_id.dart';
import 'package:savingor_app/platform_prep/navigation/route_contribution.dart';
import 'package:savingor_app/platform_prep/navigation/shell_tab_contribution.dart';
import 'package:savingor_app/savingor/routing/routing.dart';

void main() {
  Widget stub(BuildContext context) => const SizedBox();

  PlatformRouteBinding bindingOf(String name, String path) {
    return PlatformRouteBinding(
      routeName: name,
      routePath: path,
      builder: stub,
    );
  }

  ActiveRouteCatalog catalogOf(List<RouteContribution> routes) {
    return ActiveRouteCatalog(
      ActiveModuleSet(<AppModule>[
        _FakeModule(id: 'test', routes: routes),
      ]),
    );
  }

  group('PlatformRouteParityValidator', () {
    test('current production Groceries routes pass parity validation', () {
      final PlatformBootstrap bootstrap = PlatformBootstrap.savingor();
      final RouteParityResult result = PlatformRouteParityValidator(
        catalog: bootstrap.activeRouteCatalog,
        bindings: groceriesRouteBindings,
      ).validate(productionRoutes: groceriesProductionRouteContracts);

      expect(result.isValid, isTrue);
      expect(result.errors, isEmpty);
    });

    test('valid result has no errors', () {
      final ActiveRouteCatalog catalog = catalogOf(<RouteContribution>[
        RouteContribution(name: 'deals', path: '/deals'),
      ]);
      final PlatformRouteBindingRegistry bindings =
          PlatformRouteBindingRegistry(<PlatformRouteBinding>[
        bindingOf('deals', '/deals'),
      ]);
      final RouteParityResult result = PlatformRouteParityValidator(
        catalog: catalog,
        bindings: bindings,
      ).validate(
        productionRoutes: <ProductionRouteContract>[
          ProductionRouteContract(name: 'deals', path: '/deals'),
        ],
      );

      expect(result.isValid, isTrue);
      expect(result.errors, isEmpty);
    });

    test('missing production route is reported', () {
      final RouteParityResult result = PlatformRouteParityValidator(
        catalog: catalogOf(<RouteContribution>[
          RouteContribution(name: 'deals', path: '/deals'),
        ]),
        bindings: PlatformRouteBindingRegistry(<PlatformRouteBinding>[
          bindingOf('deals', '/deals'),
        ]),
      ).validate(productionRoutes: const <ProductionRouteContract>[]);

      expect(result.isValid, isFalse);
      expect(
        result.errors,
        contains(
          'Active platform route missing from production contracts: '
          '"deals" at "/deals"',
        ),
      );
    });

    test('missing binding is reported', () {
      final RouteParityResult result = PlatformRouteParityValidator(
        catalog: catalogOf(<RouteContribution>[
          RouteContribution(name: 'deals', path: '/deals'),
        ]),
        bindings: PlatformRouteBindingRegistry(const <PlatformRouteBinding>[]),
      ).validate(
        productionRoutes: <ProductionRouteContract>[
          ProductionRouteContract(name: 'deals', path: '/deals'),
        ],
      );

      expect(result.isValid, isFalse);
      expect(
        result.errors,
        contains(
          'Active platform route absent from bindings: "deals" at "/deals"',
        ),
      );
    });

    test('route-name mismatch is reported', () {
      final RouteParityResult result = PlatformRouteParityValidator(
        catalog: catalogOf(<RouteContribution>[
          RouteContribution(name: 'deals', path: '/deals'),
        ]),
        bindings: PlatformRouteBindingRegistry(<PlatformRouteBinding>[
          bindingOf('deals', '/deals'),
        ]),
      ).validate(
        productionRoutes: <ProductionRouteContract>[
          ProductionRouteContract(name: 'home', path: '/deals'),
        ],
      );

      expect(result.isValid, isFalse);
      expect(
        result.errors,
        contains(
          'Route-name mismatch for path "/deals": '
          'platform "deals", production "home"',
        ),
      );
    });

    test('route-path mismatch is reported', () {
      final RouteParityResult result = PlatformRouteParityValidator(
        catalog: catalogOf(<RouteContribution>[
          RouteContribution(name: 'deals', path: '/deals'),
        ]),
        bindings: PlatformRouteBindingRegistry(<PlatformRouteBinding>[
          bindingOf('deals', '/deals'),
        ]),
      ).validate(
        productionRoutes: <ProductionRouteContract>[
          ProductionRouteContract(name: 'deals', path: '/home'),
        ],
      );

      expect(result.isValid, isFalse);
      expect(
        result.errors,
        contains(
          'Route-path mismatch for name "deals": '
          'platform "/deals", production "/home"',
        ),
      );
    });

    test('duplicate production name is reported', () {
      final RouteParityResult result = PlatformRouteParityValidator(
        catalog: catalogOf(<RouteContribution>[
          RouteContribution(name: 'deals', path: '/deals'),
        ]),
        bindings: PlatformRouteBindingRegistry(<PlatformRouteBinding>[
          bindingOf('deals', '/deals'),
        ]),
      ).validate(
        productionRoutes: <ProductionRouteContract>[
          ProductionRouteContract(name: 'deals', path: '/deals'),
          ProductionRouteContract(name: 'deals', path: '/other'),
        ],
      );

      expect(result.isValid, isFalse);
      expect(
        result.errors,
        contains('Duplicate production route name: "deals"'),
      );
    });

    test('duplicate production path is reported', () {
      final RouteParityResult result = PlatformRouteParityValidator(
        catalog: catalogOf(<RouteContribution>[
          RouteContribution(name: 'deals', path: '/deals'),
        ]),
        bindings: PlatformRouteBindingRegistry(<PlatformRouteBinding>[
          bindingOf('deals', '/deals'),
        ]),
      ).validate(
        productionRoutes: <ProductionRouteContract>[
          ProductionRouteContract(name: 'deals', path: '/deals'),
          ProductionRouteContract(name: 'home', path: '/deals'),
        ],
      );

      expect(result.isValid, isFalse);
      expect(
        result.errors,
        contains('Duplicate production route path: "/deals"'),
      );
    });

    test('extra binding is reported', () {
      final RouteParityResult result = PlatformRouteParityValidator(
        catalog: catalogOf(<RouteContribution>[
          RouteContribution(name: 'deals', path: '/deals'),
        ]),
        bindings: PlatformRouteBindingRegistry(<PlatformRouteBinding>[
          bindingOf('deals', '/deals'),
          bindingOf('extra', '/extra'),
        ]),
      ).validate(
        productionRoutes: <ProductionRouteContract>[
          ProductionRouteContract(name: 'deals', path: '/deals'),
        ],
      );

      expect(result.isValid, isFalse);
      expect(
        result.errors,
        contains(
          'Extra platform binding not represented by an active route: '
          '"extra" at "/extra"',
        ),
      );
    });

    test('multiple mismatches are collected deterministically', () {
      final RouteParityResult result = PlatformRouteParityValidator(
        catalog: catalogOf(<RouteContribution>[
          RouteContribution(name: 'a', path: '/a'),
          RouteContribution(name: 'b', path: '/b'),
        ]),
        bindings: PlatformRouteBindingRegistry(<PlatformRouteBinding>[
          bindingOf('a', '/a'),
          bindingOf('extra', '/extra'),
        ]),
      ).validate(
        productionRoutes: <ProductionRouteContract>[
          ProductionRouteContract(name: 'dup', path: '/x'),
          ProductionRouteContract(name: 'dup', path: '/y'),
          ProductionRouteContract(name: 'a', path: '/a-wrong'),
        ],
      );

      expect(result.isValid, isFalse);
      expect(result.errors, <String>[
        'Duplicate production route name: "dup"',
        'Route-path mismatch for name "a": platform "/a", production "/a-wrong"',
        'Active platform route missing from production contracts: "b" at "/b"',
        'Active platform route absent from bindings: "b" at "/b"',
        'Extra platform binding not represented by an active route: '
            '"extra" at "/extra"',
      ]);
    });

    test('result errors are unmodifiable', () {
      final RouteParityResult result = PlatformRouteParityValidator(
        catalog: catalogOf(<RouteContribution>[
          RouteContribution(name: 'deals', path: '/deals'),
        ]),
        bindings: PlatformRouteBindingRegistry(const <PlatformRouteBinding>[]),
      ).validate(productionRoutes: const <ProductionRouteContract>[]);

      expect(result.errors, isNotEmpty);
      expect(() => result.errors.add('x'), throwsUnsupportedError);
    });
  });

  group('Groceries route parity integration', () {
    test(
      'bootstrap catalog, Task 20 bindings, and production contracts align',
      () {
        final PlatformBootstrap bootstrap = PlatformBootstrap.savingor();
        final RouteParityResult result = PlatformRouteParityValidator(
          catalog: bootstrap.activeRouteCatalog,
          bindings: groceriesRouteBindings,
        ).validate(productionRoutes: groceriesProductionRouteContracts);

        expect(result.isValid, isTrue);
        expect(result.errors, isEmpty);
        expect(
          bootstrap.activeRouteCatalog.routeCount,
          equals(groceriesProductionRouteContracts.length),
        );
        expect(
          groceriesRouteBindings.bindings.length,
          equals(groceriesProductionRouteContracts.length),
        );
      },
    );
  });
}

final class _FakeModule implements AppModule {
  _FakeModule({required String id, required List<RouteContribution> routes})
      : id = ModuleId(id),
        routeContributions = List<RouteContribution>.unmodifiable(routes);

  @override
  final ModuleId id;

  @override
  final List<RouteContribution> routeContributions;

  @override
  List<ShellTabContribution> get shellTabs => const <ShellTabContribution>[];
}
