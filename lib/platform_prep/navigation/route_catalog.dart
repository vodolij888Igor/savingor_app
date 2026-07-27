import 'package:savingor_app/platform_prep/navigation/app_module.dart';
import 'package:savingor_app/platform_prep/navigation/route_contribution.dart';
import 'package:savingor_app/savingor/modules/module_loader.dart';

/// Collects [RouteContribution] metadata from every registered module.
///
/// Preserves module registration order. Does not build GoRouter routes or
/// change runtime navigation.
class RouteCatalog {
  /// Creates a catalog from [loader].
  ///
  /// Throws [StateError] when route names or paths collide across modules.
  RouteCatalog(ModuleLoader loader)
      : _routes = List<RouteContribution>.unmodifiable(
          _collectAndValidate(loader),
        );

  final List<RouteContribution> _routes;

  /// Route contributions in module registration order (unmodifiable).
  List<RouteContribution> get routes => _routes;

  /// Whether any contribution uses [name].
  bool containsRouteName(String name) {
    for (final RouteContribution route in _routes) {
      if (route.name == name) {
        return true;
      }
    }
    return false;
  }

  /// Whether any contribution uses [path].
  bool containsRoutePath(String path) {
    for (final RouteContribution route in _routes) {
      if (route.path == path) {
        return true;
      }
    }
    return false;
  }

  static List<RouteContribution> _collectAndValidate(ModuleLoader loader) {
    final List<RouteContribution> collected = <RouteContribution>[];
    final Set<String> names = <String>{};
    final Set<String> paths = <String>{};

    for (final AppModule module in loader.modules) {
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
