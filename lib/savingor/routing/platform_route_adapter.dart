import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';

import 'package:savingor_app/platform_prep/navigation/active_route_catalog.dart';
import 'package:savingor_app/platform_prep/navigation/route_contribution.dart';
import 'package:savingor_app/savingor/routing/platform_route_binding.dart';
import 'package:savingor_app/savingor/routing/platform_route_binding_registry.dart';

/// Adapts [ActiveRouteCatalog] metadata into GoRouter [GoRoute] instances.
///
/// Product-specific Flutter boundary over product-neutral route catalogs.
class PlatformRouteAdapter {
  /// Creates an adapter from [catalog] and [bindings].
  ///
  /// Throws [StateError] when active routes and bindings do not match 1:1 by
  /// name and path.
  PlatformRouteAdapter({
    required ActiveRouteCatalog catalog,
    required PlatformRouteBindingRegistry bindings,
  })  : _catalog = catalog,
        _bindings = bindings {
    _validateAlignment(_catalog, _bindings);
  }

  final ActiveRouteCatalog _catalog;
  final PlatformRouteBindingRegistry _bindings;

  /// Builds GoRouter routes for every active contribution, in catalog order.
  ///
  /// Returns a new unmodifiable list each call (no mutable cache).
  List<GoRoute> buildRoutes() {
    final List<GoRoute> routes = <GoRoute>[];

    for (final RouteContribution contribution in _catalog.routes) {
      final PlatformRouteBinding binding =
          _bindings.findByName(contribution.name)!;
      final WidgetBuilder builder = binding.builder;
      routes.add(
        GoRoute(
          name: contribution.name,
          path: contribution.path,
          builder: (BuildContext context, GoRouterState state) {
            return builder(context);
          },
        ),
      );
    }

    return List<GoRoute>.unmodifiable(routes);
  }

  static void _validateAlignment(
    ActiveRouteCatalog catalog,
    PlatformRouteBindingRegistry bindings,
  ) {
    final Set<String> activeNames = <String>{};
    final Set<String> activePaths = <String>{};

    for (final RouteContribution contribution in catalog.routes) {
      activeNames.add(contribution.name);
      activePaths.add(contribution.path);

      final PlatformRouteBinding? byName =
          bindings.findByName(contribution.name);
      if (byName == null) {
        throw StateError(
          'Missing route binding for active route name: "${contribution.name}"',
        );
      }
      if (byName.routePath != contribution.path) {
        throw StateError(
          'Route binding path mismatch for "${contribution.name}": '
          'expected "${contribution.path}", got "${byName.routePath}"',
        );
      }

      final PlatformRouteBinding? byPath =
          bindings.findByPath(contribution.path);
      if (byPath == null || byPath.routeName != contribution.name) {
        throw StateError(
          'Route binding name mismatch for path "${contribution.path}": '
          'expected "${contribution.name}"',
        );
      }
    }

    for (final PlatformRouteBinding binding in bindings.bindings) {
      if (!activeNames.contains(binding.routeName)) {
        throw StateError(
          'Extra route binding for unknown route name: "${binding.routeName}"',
        );
      }
      if (!activePaths.contains(binding.routePath)) {
        throw StateError(
          'Extra route binding for unknown route path: "${binding.routePath}"',
        );
      }
    }
  }
}
