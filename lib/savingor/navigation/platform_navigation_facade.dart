import 'package:savingor_app/platform_prep/bootstrap/platform_bootstrap.dart';
import 'package:savingor_app/platform_prep/navigation/app_module.dart';
import 'package:savingor_app/platform_prep/navigation/module_id.dart';
import 'package:savingor_app/platform_prep/navigation/route_contribution.dart';
import 'package:savingor_app/platform_prep/navigation/shell_tab_contribution.dart';
import 'package:savingor_app/savingor/navigation/platform_navigation_service.dart';
import 'package:savingor_app/savingor/navigation/production_navigation_composition.dart';
import 'package:savingor_app/savingor/navigation/production_navigation_composition_service.dart';

/// Single public entry point for reading platform navigation metadata.
///
/// Composes [PlatformNavigationService] internally. Does not expose resolver,
/// composition, or other implementation types. Metadata only — no GoRouter,
/// widgets, BuildContext, navigation execution, or runtime routing ownership.
final class PlatformNavigationFacade {
  PlatformNavigationFacade._(this._service);

  /// Builds a facade from [bootstrap] navigation catalogs.
  factory PlatformNavigationFacade.fromBootstrap(PlatformBootstrap bootstrap) {
    return PlatformNavigationFacade.fromComposition(
      ProductionNavigationCompositionService(bootstrap: bootstrap).composition,
    );
  }

  /// Builds a facade from an existing [composition].
  factory PlatformNavigationFacade.fromComposition(
    ProductionNavigationComposition composition,
  ) {
    return PlatformNavigationFacade._(
      PlatformNavigationService.fromComposition(composition),
    );
  }

  final PlatformNavigationService _service;

  /// Active routes (unmodifiable).
  List<RouteContribution> get routes => _service.routes;

  /// Active shell tabs (unmodifiable).
  List<ShellTabContribution> get shellTabs => _service.shellTabs;

  /// Active modules (unmodifiable).
  List<AppModule> get modules => _service.modules;

  /// Number of active routes.
  int get routeCount => routes.length;

  /// Number of active shell tabs.
  int get shellTabCount => shellTabs.length;

  /// Number of active modules.
  int get moduleCount => modules.length;

  /// Resolves a route by stable [name].
  ///
  /// Throws [StateError] when missing.
  RouteContribution routeByName(String name) => _service.routeByName(name);

  /// Resolves a route by [path].
  ///
  /// Throws [StateError] when missing.
  RouteContribution routeByPath(String path) => _service.routeByPath(path);

  /// Resolves a shell tab by stable [key].
  ///
  /// Throws [StateError] when missing.
  ShellTabContribution shellTab(String key) => _service.shellTab(key);

  /// Resolves an active module by [id].
  ///
  /// Throws [StateError] when missing.
  AppModule module(ModuleId id) => _service.module(id);

  /// Whether a route with [name] is present.
  bool containsRoute(String name) => _service.containsRoute(name);

  /// Whether a shell tab with [key] is present.
  bool containsShellTab(String key) => _service.containsShellTab(key);

  /// Whether an active module with [id] is present.
  bool containsModule(ModuleId id) => _service.containsModule(id);
}
