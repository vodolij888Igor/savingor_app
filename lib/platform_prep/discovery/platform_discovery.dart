import 'package:savingor_app/platform_prep/application/platform_application.dart';
import 'package:savingor_app/platform_prep/bootstrap/platform_bootstrap.dart';
import 'package:savingor_app/platform_prep/environment/platform_environment.dart';
import 'package:savingor_app/platform_prep/kernel/platform_kernel.dart';
import 'package:savingor_app/platform_prep/navigation/app_module.dart';
import 'package:savingor_app/platform_prep/navigation/module_id.dart';
import 'package:savingor_app/platform_prep/navigation/route_contribution.dart';
import 'package:savingor_app/platform_prep/navigation/shell_tab_contribution.dart';
import 'package:savingor_app/platform_prep/platform/platform_facade.dart';
import 'package:savingor_app/platform_prep/registry/platform_registry.dart';
import 'package:savingor_app/platform_prep/runtime/platform_runtime.dart';

/// Immutable read-only discovery API over [PlatformRegistry] metadata.
///
/// Queries modules, routes, shell tabs, applications, and runtime metadata.
/// Does not own routing, UI, Flutter types, or feature wiring.
final class PlatformDiscovery {
  /// Creates discovery over [registry].
  const PlatformDiscovery({required PlatformRegistry registry})
      : _registry = registry;

  /// Builds discovery from [registry].
  factory PlatformDiscovery.fromRegistry(PlatformRegistry registry) {
    return PlatformDiscovery(registry: registry);
  }

  /// Builds discovery from [bootstrap.platformRegistry].
  factory PlatformDiscovery.fromBootstrap(PlatformBootstrap bootstrap) {
    return PlatformDiscovery.fromRegistry(bootstrap.platformRegistry);
  }

  final PlatformRegistry _registry;

  /// Active modules (unmodifiable).
  List<AppModule> get modules => _registry.application.navigation.modules;

  /// Registered modules (unmodifiable).
  List<AppModule> get registeredModules =>
      _registry.application.discovery.registeredModules;

  /// Active modules via module discovery (unmodifiable).
  List<AppModule> get activeModules =>
      _registry.application.discovery.activeModules;

  /// Whether a module with [id] is active in navigation metadata.
  bool containsModule(ModuleId id) =>
      _registry.application.navigation.containsModule(id);

  /// Returns the active navigation module with [id], or `null`.
  AppModule? findModuleById(ModuleId id) {
    if (!containsModule(id)) {
      return null;
    }
    return _registry.application.navigation.module(id);
  }

  /// Active routes (unmodifiable).
  List<RouteContribution> get routes => _registry.application.navigation.routes;

  /// Whether a route with [name] is present.
  bool containsRoute(String name) =>
      _registry.application.navigation.containsRoute(name);

  /// Returns the route with [name], or `null`.
  RouteContribution? findRouteByName(String name) {
    return _registry.application.moduleContext.activeRouteCatalog
        .findByName(name);
  }

  /// Returns the route with [path], or `null`.
  RouteContribution? findRouteByPath(String path) {
    return _registry.application.moduleContext.activeRouteCatalog
        .findByPath(path);
  }

  /// Active shell tabs (unmodifiable).
  List<ShellTabContribution> get shellTabs =>
      _registry.application.navigation.shellTabs;

  /// Whether a shell tab with [key] is present.
  bool containsShellTab(String key) =>
      _registry.application.navigation.containsShellTab(key);

  /// Returns the shell tab with [key], or `null`.
  ShellTabContribution? findShellTabByKey(String key) {
    return _registry.application.moduleContext.activeShellTabCatalog
        .findByStableKey(key);
  }

  /// Platform applications known to the registry (unmodifiable).
  List<PlatformApplication> get applications =>
      List<PlatformApplication>.unmodifiable(
        <PlatformApplication>[_registry.application],
      );

  /// Primary platform application.
  PlatformApplication get application => _registry.application;

  /// Live platform runtime metadata.
  PlatformRuntime get runtime => _registry.runtime;

  /// Platform environment metadata.
  PlatformEnvironment get environment => _registry.environment;

  /// Platform kernel metadata.
  PlatformKernel get kernel => _registry.kernel;

  /// Platform facade metadata.
  PlatformFacade get facade => _registry.facade;

  /// Underlying platform registry.
  PlatformRegistry get registry => _registry;
}
