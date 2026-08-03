import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';

import 'package:savingor_app/platform_prep/bootstrap/bootstrap.dart';
import 'package:savingor_app/platform_prep/navigation/active_route_catalog.dart';
import 'package:savingor_app/platform_prep/navigation/route_contribution.dart';
import 'package:savingor_app/savingor/modules/groceries/groceries_module.dart';
import 'package:savingor_app/savingor/routing/routing.dart';

void main() {
  group('groceriesRouteBindings', () {
    late ActiveRouteCatalog catalog;
    late PlatformRouteAdapter adapter;

    setUp(() {
      catalog = PlatformBootstrap.savingor().activeRouteCatalog;
      adapter = createGroceriesRouteAdapter(catalog);
    });

    test('covers every Groceries route contribution exactly once', () {
      expect(
        groceriesRouteBindings.bindings.length,
        equals(groceriesModule.routeContributions.length),
      );

      for (final RouteContribution contribution
          in groceriesModule.routeContributions) {
        final PlatformRouteBinding? binding =
            groceriesRouteBindings.findByName(contribution.name);
        expect(binding, isNotNull, reason: contribution.name);
        expect(binding!.routePath, equals(contribution.path));
        expect(
          groceriesRouteBindings.findByPath(contribution.path),
          same(binding),
        );
      }
    });

    test('binding order matches groceriesModule declaration order', () {
      expect(
        groceriesRouteBindings.bindings
            .map((PlatformRouteBinding b) => b.routeName)
            .toList(),
        equals(
          groceriesModule.routeContributions
              .map((RouteContribution c) => c.name)
              .toList(),
        ),
      );
      expect(
        groceriesRouteBindings.bindings
            .map((PlatformRouteBinding b) => b.routePath)
            .toList(),
        equals(
          groceriesModule.routeContributions
              .map((RouteContribution c) => c.path)
              .toList(),
        ),
      );
    });

    test('preserves production route names and paths for key screens', () {
      expect(
        groceriesRouteBindings.findByName('deals')?.routePath,
        equals('/deals'),
      );
      expect(
        groceriesRouteBindings.findByName('subscription')?.routePath,
        equals('/subscription'),
      );
      expect(
        groceriesRouteBindings.findByName('scanner-create')?.routePath,
        equals('/scanner/create'),
      );
      expect(
        groceriesRouteBindings.findByName('expenses-create')?.routePath,
        equals('/expenses/create'),
      );
      expect(
        groceriesRouteBindings
            .findByPath('/profile/settings/language')
            ?.routeName,
        equals('profile-settings-language'),
      );
    });

    test('every binding exposes a builder', () {
      for (final PlatformRouteBinding binding
          in groceriesRouteBindings.bindings) {
        expect(binding.builder, isNotNull, reason: binding.routeName);
      }
    });

    test(
        'adapter aligns with ActiveRouteCatalog and builds deterministic routes',
        () {
      final List<GoRoute> routes = adapter.buildRoutes();

      expect(routes.length, equals(catalog.routeCount));
      expect(
        routes.map((GoRoute r) => r.name).toList(),
        equals(
          catalog.routes.map((RouteContribution c) => c.name).toList(),
        ),
      );
      expect(
        routes.map((GoRoute r) => r.path).toList(),
        equals(
          catalog.routes.map((RouteContribution c) => c.path).toList(),
        ),
      );
    });

    test('createGroceriesRouteAdapter is deterministic across calls', () {
      final List<GoRoute> first =
          createGroceriesRouteAdapter(catalog).buildRoutes();
      final List<GoRoute> second =
          createGroceriesRouteAdapter(catalog).buildRoutes();

      expect(
        first.map((GoRoute r) => '${r.name}:${r.path}').toList(),
        equals(second.map((GoRoute r) => '${r.name}:${r.path}').toList()),
      );
    });
  });
}
