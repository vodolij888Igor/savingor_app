import 'package:savingor_app/platform_prep/application/platform_application.dart';
import 'package:savingor_app/platform_prep/bootstrap/platform_bootstrap.dart';
import 'package:savingor_app/platform_prep/modules/module_activation_service.dart';
import 'package:savingor_app/platform_prep/modules/module_context.dart';
import 'package:savingor_app/platform_prep/modules/module_discovery_service.dart';
import 'package:savingor_app/platform_prep/modules/module_lifecycle_service.dart';
import 'package:savingor_app/platform_prep/modules/module_query_service.dart';
import 'package:savingor_app/platform_prep/runtime/platform_runtime.dart';
import 'package:savingor_app/savingor/navigation/platform_navigation_facade.dart';

/// Immutable complete execution environment for the Savingor platform.
///
/// Composes runtime and application platform APIs. Metadata only — no Flutter,
/// GoRouter, UI, navigation ownership, or feature wiring.
final class PlatformEnvironment {
  /// Creates an environment from already-built platform APIs.
  const PlatformEnvironment({
    required this.runtime,
    required this.application,
    required this.navigation,
    required this.moduleContext,
    required this.query,
    required this.discovery,
    required this.lifecycle,
    required this.activation,
  });

  /// Builds an environment from [runtime] public surfaces.
  factory PlatformEnvironment.fromRuntime(PlatformRuntime runtime) {
    return PlatformEnvironment(
      runtime: runtime,
      application: runtime.application,
      navigation: runtime.navigation,
      moduleContext: runtime.moduleContext,
      query: runtime.query,
      discovery: runtime.discovery,
      lifecycle: runtime.lifecycle,
      activation: runtime.activation,
    );
  }

  /// Builds an environment from [bootstrap] public platform surfaces.
  factory PlatformEnvironment.fromBootstrap(PlatformBootstrap bootstrap) {
    return PlatformEnvironment.fromRuntime(bootstrap.runtime);
  }

  /// Immutable live platform runtime.
  final PlatformRuntime runtime;

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
