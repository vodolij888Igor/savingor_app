import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:savingor_app/platform_prep/bootstrap/bootstrap.dart';
import 'package:savingor_app/platform_prep/modules/active_module_set.dart';
import 'package:savingor_app/platform_prep/navigation/active_route_catalog.dart';
import 'package:savingor_app/platform_prep/navigation/app_module.dart';
import 'package:savingor_app/platform_prep/navigation/module_id.dart';
import 'package:savingor_app/platform_prep/navigation/route_contribution.dart';
import 'package:savingor_app/platform_prep/navigation/shell_tab_contribution.dart';
import 'package:savingor_app/savingor/bootstrap/route_parity_startup.dart';
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

  setUp(() {
    debugResetRouteParityVerificationCallCount();
  });

  group('verifySavingorProductionRouteParity', () {
    test('successful parity passes', () {
      expect(
        () => verifySavingorProductionRouteParity(
          activeRouteCatalog: PlatformBootstrap.savingor().activeRouteCatalog,
          isReleaseMode: false,
        ),
        returnsNormally,
      );
    });

    test('parity failure triggers assertion in debug', () {
      expect(
        () => verifySavingorProductionRouteParity(
          activeRouteCatalog: catalogOf(<RouteContribution>[
            RouteContribution(name: 'deals', path: '/deals'),
          ]),
          bindings: PlatformRouteBindingRegistry(<PlatformRouteBinding>[
            bindingOf('deals', '/deals'),
          ]),
          productionRoutes: const <ProductionRouteContract>[],
          isReleaseMode: false,
        ),
        throwsA(
          isA<AssertionError>().having(
            (AssertionError e) => e.message,
            'message',
            contains('Production route parity validation failed'),
          ),
        ),
      );
    });

    test('release mode skips validation', () {
      debugResetRouteParityVerificationCallCount();

      expect(
        () => verifySavingorProductionRouteParity(
          activeRouteCatalog: catalogOf(<RouteContribution>[
            RouteContribution(name: 'deals', path: '/deals'),
          ]),
          bindings: PlatformRouteBindingRegistry(<PlatformRouteBinding>[
            bindingOf('deals', '/deals'),
          ]),
          productionRoutes: const <ProductionRouteContract>[],
          isReleaseMode: true,
        ),
        returnsNormally,
      );

      expect(debugRouteParityVerificationCallCount, equals(0));
    });
  });

  group('PlatformBootstrap route parity startup', () {
    test('validation executes once during savingor bootstrap', () {
      debugResetRouteParityVerificationCallCount();

      final PlatformBootstrap bootstrap = PlatformBootstrap.savingor();

      expect(debugRouteParityVerificationCallCount, equals(1));

      // Accessing services must not re-run parity.
      bootstrap.activeRouteCatalog;
      bootstrap.moduleContext;
      bootstrap.routeCatalog;
      expect(debugRouteParityVerificationCallCount, equals(1));
    });

    test('successful parity passes through PlatformBootstrap.savingor', () {
      expect(() => PlatformBootstrap.savingor(), returnsNormally);
    });
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
