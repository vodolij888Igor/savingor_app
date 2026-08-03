import 'package:savingor_app/platform_prep/navigation/app_module.dart';
import 'package:savingor_app/platform_prep/navigation/module_id.dart';
import 'package:savingor_app/platform_prep/navigation/route_contribution.dart';
import 'package:savingor_app/platform_prep/navigation/shell_tab_contribution.dart';
import 'package:savingor_app/savingor/navigation/navigation_resolver.dart';
import 'package:savingor_app/savingor/navigation/production_navigation_composition.dart';

/// Product-neutral façade over [NavigationResolver].
///
/// Exposes a stable lookup API for modules without GoRouter, widgets,
/// BuildContext, navigation execution, or UI. All lookups delegate to the
/// resolver and return immutable metadata only.
final class PlatformNavigationService {
  /// Creates a service that delegates to [resolver].
  PlatformNavigationService({required NavigationResolver resolver})
      : _resolver = resolver;

  /// Creates a service from [composition] via a new [NavigationResolver].
  factory PlatformNavigationService.fromComposition(
    ProductionNavigationComposition composition,
  ) {
    return PlatformNavigationService(
      resolver: NavigationResolver(composition: composition),
    );
  }

  final NavigationResolver _resolver;

  /// Active routes (unmodifiable).
  List<RouteContribution> get routes => _resolver.routes;

  /// Active shell tabs (unmodifiable).
  List<ShellTabContribution> get shellTabs => _resolver.shellTabs;

  /// Active modules (unmodifiable).
  List<AppModule> get modules => _resolver.modules;

  /// Resolves a route by stable [name].
  ///
  /// Throws [StateError] when missing.
  RouteContribution routeByName(String name) {
    return _resolver.resolveRouteByName(name);
  }

  /// Resolves a route by [path].
  ///
  /// Throws [StateError] when missing.
  RouteContribution routeByPath(String path) {
    return _resolver.resolveRouteByPath(path);
  }

  /// Resolves a shell tab by stable [key].
  ///
  /// Throws [StateError] when missing.
  ShellTabContribution shellTab(String key) {
    return _resolver.resolveShellTabByKey(key);
  }

  /// Resolves an active module by [id].
  ///
  /// Throws [StateError] when missing.
  AppModule module(ModuleId id) {
    return _resolver.resolveModuleById(id);
  }

  /// Whether a route with [name] is present.
  bool containsRoute(String name) {
    return _resolver.findRouteByName(name) != null;
  }

  /// Whether a shell tab with [key] is present.
  bool containsShellTab(String key) {
    return _resolver.findShellTabByKey(key) != null;
  }

  /// Whether an active module with [id] is present.
  bool containsModule(ModuleId id) {
    return _resolver.findModuleById(id) != null;
  }
}
