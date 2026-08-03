import 'package:savingor_app/platform_prep/application/platform_application.dart';
import 'package:savingor_app/platform_prep/bootstrap/platform_bootstrap.dart';
import 'package:savingor_app/platform_prep/modules/module_activation_service.dart';
import 'package:savingor_app/platform_prep/modules/module_context.dart';
import 'package:savingor_app/platform_prep/modules/module_discovery_service.dart';
import 'package:savingor_app/platform_prep/modules/module_lifecycle_service.dart';
import 'package:savingor_app/platform_prep/modules/module_query_service.dart';
import 'package:savingor_app/savingor/navigation/platform_navigation_facade.dart';

/// Immutable live runtime view of the Savingor application platform.
///
/// Future entry point for application execution. Exposes runtime metadata and
/// public platform APIs only — no Flutter, GoRouter, UI, or feature wiring.
final class PlatformRuntime {
  /// Creates a runtime from already-built platform APIs.
  const PlatformRuntime({
    required this.application,
    required this.navigation,
    required this.moduleContext,
    required this.query,
    required this.discovery,
    required this.lifecycle,
    required this.activation,
  });

  /// Builds a runtime from [application] public surfaces.
  factory PlatformRuntime.fromApplication(PlatformApplication application) {
    return PlatformRuntime(
      application: application,
      navigation: application.navigation,
      moduleContext: application.moduleContext,
      query: application.query,
      discovery: application.discovery,
      lifecycle: application.lifecycle,
      activation: application.activation,
    );
  }

  /// Builds a runtime from [bootstrap] public platform surfaces.
  factory PlatformRuntime.fromBootstrap(PlatformBootstrap bootstrap) {
    return PlatformRuntime.fromApplication(bootstrap.application);
  }

  /// Immutable platform application entry point.
  final PlatformApplication application;

  /// Navigation metadata façade.
  final PlatformNavigationFacade navigation;

  /// Immutable module platform context.
  final ModuleContext moduleContext;

  /// Read-only module query API.
  final ModuleQueryService query;

  /// Read-only module discovery API.
  final ModuleDiscoveryService discovery;

  /// Module lifecycle snapshot API.
  final ModuleLifecycleService lifecycle;

  /// Module activation evaluator API.
  final ModuleActivationService activation;
}
