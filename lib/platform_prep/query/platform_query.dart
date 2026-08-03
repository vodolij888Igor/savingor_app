import 'package:savingor_app/platform_prep/activation/platform_activation.dart';
import 'package:savingor_app/platform_prep/application/platform_application.dart';
import 'package:savingor_app/platform_prep/bootstrap/platform_bootstrap.dart';
import 'package:savingor_app/platform_prep/discovery/platform_discovery.dart';
import 'package:savingor_app/platform_prep/lifecycle/platform_lifecycle.dart';
import 'package:savingor_app/platform_prep/navigation/app_module.dart';
import 'package:savingor_app/platform_prep/navigation/module_id.dart';
import 'package:savingor_app/platform_prep/navigation/route_contribution.dart';
import 'package:savingor_app/platform_prep/navigation/shell_tab_contribution.dart';
import 'package:savingor_app/platform_prep/platform/platform_facade.dart';
import 'package:savingor_app/platform_prep/registry/platform_registry.dart';

/// Immutable single read-only querying surface over Application Platform APIs.
///
/// Composes existing facade, registry, discovery, lifecycle, and activation
/// APIs rather than duplicating logic. Metadata only — no Flutter, GoRouter,
/// UI, routing ownership, or feature wiring.
final class PlatformQuery {
  /// Creates a query surface over composed platform APIs.
  const PlatformQuery({
    required this.facade,
    required this.registry,
    required this.discovery,
    required this.lifecycle,
    required this.activation,
  });

  /// Builds a query surface from [facade] and companion platform APIs.
  factory PlatformQuery.fromFacade(
    PlatformFacade facade, {
    required PlatformRegistry registry,
    required PlatformDiscovery discovery,
    required PlatformLifecycle lifecycle,
    required PlatformActivation activation,
  }) {
    return PlatformQuery(
      facade: facade,
      registry: registry,
      discovery: discovery,
      lifecycle: lifecycle,
      activation: activation,
    );
  }

  /// Builds a query surface from [bootstrap] platform surfaces.
  factory PlatformQuery.fromBootstrap(PlatformBootstrap bootstrap) {
    return PlatformQuery.fromFacade(
      bootstrap.facade,
      registry: bootstrap.platformRegistry,
      discovery: bootstrap.platformDiscovery,
      lifecycle: bootstrap.platformLifecycle,
      activation: bootstrap.platformActivation,
    );
  }

  /// Platform facade entry point.
  final PlatformFacade facade;

  /// Platform registry.
  final PlatformRegistry registry;

  /// Platform discovery API.
  final PlatformDiscovery discovery;

  /// Platform lifecycle API.
  final PlatformLifecycle lifecycle;

  /// Platform activation API.
  final PlatformActivation activation;

  /// Platform applications (unmodifiable).
  List<PlatformApplication> get applications => discovery.applications;

  /// Primary platform application.
  PlatformApplication get application => facade.application;

  /// Active modules (unmodifiable).
  List<AppModule> get modules => discovery.modules;

  /// Active routes (unmodifiable).
  List<RouteContribution> get routes => discovery.routes;

  /// Active shell tabs (unmodifiable).
  List<ShellTabContribution> get shellTabs => discovery.shellTabs;

  /// Whether a module with [id] is present.
  bool containsModule(ModuleId id) => discovery.containsModule(id);

  /// Returns the module with [id], or `null`.
  AppModule? findModuleById(ModuleId id) => discovery.findModuleById(id);

  /// Whether a route with [name] is present.
  bool containsRoute(String name) => discovery.containsRoute(name);

  /// Returns the route with [name], or `null`.
  RouteContribution? findRouteByName(String name) =>
      discovery.findRouteByName(name);

  /// Returns the route with [path], or `null`.
  RouteContribution? findRouteByPath(String path) =>
      discovery.findRouteByPath(path);

  /// Whether a shell tab with [key] is present.
  bool containsShellTab(String key) => discovery.containsShellTab(key);

  /// Returns the shell tab with [key], or `null`.
  ShellTabContribution? findShellTabByKey(String key) =>
      discovery.findShellTabByKey(key);

  /// Whether the platform lifecycle reports ready.
  bool get isLifecycleReady => lifecycle.isReady;

  /// Whether platform activation reports ready.
  bool get isActivationReady => activation.isActivationReady;
}
