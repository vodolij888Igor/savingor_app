import 'package:savingor_app/platform_prep/navigation/app_module.dart';
import 'package:savingor_app/platform_prep/navigation/module_id.dart';
import 'package:savingor_app/platform_prep/navigation/route_contribution.dart';
import 'package:savingor_app/platform_prep/navigation/shell_tab_contribution.dart';

/// Immutable production navigation metadata snapshot.
///
/// Metadata only — no builders, GoRouter ownership, UI, or navigation
/// execution. Collections are unmodifiable and ordered deterministically.
final class ProductionNavigationComposition {
  /// Creates a composition from [routes], [shellTabs], and [modules].
  ///
  /// Copies inputs into unmodifiable lists and builds lookup indexes.
  /// Throws [StateError] when route names/paths or shell-tab keys collide.
  factory ProductionNavigationComposition({
    required Iterable<RouteContribution> routes,
    required Iterable<ShellTabContribution> shellTabs,
    required Iterable<AppModule> modules,
  }) {
    final List<RouteContribution> routeList =
        List<RouteContribution>.unmodifiable(
            List<RouteContribution>.from(routes));
    final List<ShellTabContribution> tabList =
        List<ShellTabContribution>.unmodifiable(
      List<ShellTabContribution>.from(shellTabs),
    );
    final List<AppModule> moduleList =
        List<AppModule>.unmodifiable(List<AppModule>.from(modules));

    final Map<String, RouteContribution> routesByName =
        <String, RouteContribution>{};
    final Map<String, RouteContribution> routesByPath =
        <String, RouteContribution>{};
    for (final RouteContribution route in routeList) {
      if (routesByName.containsKey(route.name)) {
        throw StateError('Duplicate route name: "${route.name}"');
      }
      if (routesByPath.containsKey(route.path)) {
        throw StateError('Duplicate route path: "${route.path}"');
      }
      routesByName[route.name] = route;
      routesByPath[route.path] = route;
    }

    final Map<String, ShellTabContribution> tabsByKey =
        <String, ShellTabContribution>{};
    for (final ShellTabContribution tab in tabList) {
      if (tabsByKey.containsKey(tab.key)) {
        throw StateError('Duplicate shell tab key: "${tab.key}"');
      }
      tabsByKey[tab.key] = tab;
    }

    final Map<ModuleId, AppModule> modulesById = <ModuleId, AppModule>{};
    for (final AppModule module in moduleList) {
      if (modulesById.containsKey(module.id)) {
        throw StateError('Duplicate module id: "${module.id.value}"');
      }
      modulesById[module.id] = module;
    }

    return ProductionNavigationComposition._(
      routes: routeList,
      shellTabs: tabList,
      modules: moduleList,
      routesByName: Map<String, RouteContribution>.unmodifiable(routesByName),
      routesByPath: Map<String, RouteContribution>.unmodifiable(routesByPath),
      shellTabsByKey: Map<String, ShellTabContribution>.unmodifiable(tabsByKey),
      modulesById: Map<ModuleId, AppModule>.unmodifiable(modulesById),
    );
  }

  ProductionNavigationComposition._({
    required this.routes,
    required this.shellTabs,
    required this.modules,
    required Map<String, RouteContribution> routesByName,
    required Map<String, RouteContribution> routesByPath,
    required Map<String, ShellTabContribution> shellTabsByKey,
    required Map<ModuleId, AppModule> modulesById,
  })  : _routesByName = routesByName,
        _routesByPath = routesByPath,
        _shellTabsByKey = shellTabsByKey,
        _modulesById = modulesById;

  /// Active routes in catalog declaration order (unmodifiable).
  final List<RouteContribution> routes;

  /// Active shell tabs in catalog order (unmodifiable).
  final List<ShellTabContribution> shellTabs;

  /// Active modules in registration order (unmodifiable).
  final List<AppModule> modules;

  final Map<String, RouteContribution> _routesByName;
  final Map<String, RouteContribution> _routesByPath;
  final Map<String, ShellTabContribution> _shellTabsByKey;
  final Map<ModuleId, AppModule> _modulesById;

  /// Number of active routes.
  int get routeCount => routes.length;

  /// Number of active shell tabs.
  int get shellTabCount => shellTabs.length;

  /// Number of active modules.
  int get moduleCount => modules.length;

  /// Whether a route with [name] is present.
  bool containsRouteName(String name) => _routesByName.containsKey(name);

  /// Whether a route with [path] is present.
  bool containsRoutePath(String path) => _routesByPath.containsKey(path);

  /// Whether a shell tab with [stableKey] is present.
  bool containsShellTabKey(String stableKey) =>
      _shellTabsByKey.containsKey(stableKey);

  /// Whether a module with [id] is present.
  bool containsModuleId(ModuleId id) => _modulesById.containsKey(id);

  /// Returns the route with [name], or `null`.
  RouteContribution? findRouteByName(String name) => _routesByName[name];

  /// Returns the route with [path], or `null`.
  RouteContribution? findRouteByPath(String path) => _routesByPath[path];

  /// Returns the shell tab with [stableKey], or `null`.
  ShellTabContribution? findShellTabByKey(String stableKey) =>
      _shellTabsByKey[stableKey];

  /// Returns the module with [id], or `null`.
  AppModule? findModuleById(ModuleId id) => _modulesById[id];
}
