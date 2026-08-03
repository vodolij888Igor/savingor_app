import 'package:savingor_app/platform_prep/modules/active_module_set.dart';
import 'package:savingor_app/platform_prep/navigation/app_module.dart';
import 'package:savingor_app/platform_prep/navigation/route_contribution.dart';

/// Collects [RouteContribution] metadata from active modules only.
///
/// Preserves active-module order and route declaration order. Does not build
/// GoRouter routes or change runtime navigation.
class ActiveRouteCatalog {
  /// Creates a catalog from [activeModules].
  ///
  /// Throws [StateError] when route names or paths collide across modules.
  ActiveRouteCatalog(ActiveModuleSet activeModules)
      : _routes = List<RouteContribution>.unmodifiable(
          _collectAndValidate(activeModules),
        );

  final List<RouteContribution> _routes;

  /// Route contributions from active modules (unmodifiable).
  List<RouteContribution> get routes => _routes;

  /// Number of collected routes.
  int get routeCount => _routes.length;

  /// Whether any contribution uses [name].
  bool containsRouteName(String name) => findByName(name) != null;

  /// Whether any contribution uses [path].
  bool containsRoutePath(String path) => findByPath(path) != null;

  /// Returns the contribution with [name], or `null` if none is present.
  RouteContribution? findByName(String name) {
    for (final RouteContribution route in _routes) {
      if (route.name == name) {
        return route;
      }
    }
    return null;
  }

  /// Returns the contribution with [path], or `null` if none is present.
  RouteContribution? findByPath(String path) {
    for (final RouteContribution route in _routes) {
      if (route.path == path) {
        return route;
      }
    }
    return null;
  }

  static List<RouteContribution> _collectAndValidate(
    ActiveModuleSet activeModules,
  ) {
    final List<RouteContribution> collected = <RouteContribution>[];
    final Set<String> names = <String>{};
    final Set<String> paths = <String>{};

    for (final AppModule module in activeModules.modules) {
      for (final RouteContribution route in module.routeContributions) {
        if (!names.add(route.name)) {
          throw StateError('Duplicate route name: "${route.name}"');
        }
        if (!paths.add(route.path)) {
          throw StateError('Duplicate route path: "${route.path}"');
        }
        collected.add(route);
      }
    }

    return collected;
  }
}
