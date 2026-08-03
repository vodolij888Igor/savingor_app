import 'package:savingor_app/platform_prep/navigation/app_module.dart';
import 'package:savingor_app/platform_prep/navigation/module_id.dart';
import 'package:savingor_app/platform_prep/navigation/route_contribution.dart';
import 'package:savingor_app/platform_prep/navigation/shell_tab_contribution.dart';
import 'package:savingor_app/savingor/navigation/production_navigation_composition.dart';

/// Product-neutral resolver over a [ProductionNavigationComposition].
///
/// Returns immutable route/tab/module metadata only. Does not own GoRouter,
/// execute navigation, run builders, or render UI. Lookups are O(1).
final class NavigationResolver {
  /// Creates a resolver bound to [composition].
  NavigationResolver({required ProductionNavigationComposition composition})
      : _composition = composition;

  final ProductionNavigationComposition _composition;

  /// Active routes (unmodifiable, composition order).
  List<RouteContribution> get routes => _composition.routes;

  /// Active shell tabs (unmodifiable, composition order).
  List<ShellTabContribution> get shellTabs => _composition.shellTabs;

  /// Active modules (unmodifiable, composition order).
  List<AppModule> get modules => _composition.modules;

  /// Returns the route with [name], or `null` if absent.
  RouteContribution? findRouteByName(String name) {
    return _composition.findRouteByName(name);
  }

  /// Returns the route with [path], or `null` if absent.
  RouteContribution? findRouteByPath(String path) {
    return _composition.findRouteByPath(path);
  }

  /// Returns the shell tab with [key], or `null` if absent.
  ShellTabContribution? findShellTabByKey(String key) {
    return _composition.findShellTabByKey(key);
  }

  /// Returns the module with [id], or `null` if absent.
  AppModule? findModuleById(ModuleId id) {
    return _composition.findModuleById(id);
  }

  /// Resolves the route with [name].
  ///
  /// Throws [StateError] when no route uses [name].
  RouteContribution resolveRouteByName(String name) {
    final RouteContribution? route = findRouteByName(name);
    if (route == null) {
      throw StateError('Unknown route name: "$name"');
    }
    return route;
  }

  /// Resolves the route with [path].
  ///
  /// Throws [StateError] when no route uses [path].
  RouteContribution resolveRouteByPath(String path) {
    final RouteContribution? route = findRouteByPath(path);
    if (route == null) {
      throw StateError('Unknown route path: "$path"');
    }
    return route;
  }

  /// Resolves the shell tab with [key].
  ///
  /// Throws [StateError] when no shell tab uses [key].
  ShellTabContribution resolveShellTabByKey(String key) {
    final ShellTabContribution? tab = findShellTabByKey(key);
    if (tab == null) {
      throw StateError('Unknown shell tab key: "$key"');
    }
    return tab;
  }

  /// Resolves the module with [id].
  ///
  /// Throws [StateError] when no active module uses [id].
  AppModule resolveModuleById(ModuleId id) {
    final AppModule? module = findModuleById(id);
    if (module == null) {
      throw StateError('Unknown module id: "${id.value}"');
    }
    return module;
  }
}
