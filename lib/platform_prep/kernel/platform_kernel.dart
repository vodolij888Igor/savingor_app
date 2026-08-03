import 'package:savingor_app/platform_prep/application/platform_application.dart';
import 'package:savingor_app/platform_prep/bootstrap/platform_bootstrap.dart';
import 'package:savingor_app/platform_prep/environment/platform_environment.dart';
import 'package:savingor_app/platform_prep/modules/module_activation_service.dart';
import 'package:savingor_app/platform_prep/modules/module_context.dart';
import 'package:savingor_app/platform_prep/modules/module_discovery_service.dart';
import 'package:savingor_app/platform_prep/modules/module_lifecycle_service.dart';
import 'package:savingor_app/platform_prep/modules/module_query_service.dart';
import 'package:savingor_app/platform_prep/runtime/platform_runtime.dart';
import 'package:savingor_app/savingor/navigation/platform_navigation_facade.dart';

/// Immutable root object for the complete Savingor platform core.
///
/// Composes environment, runtime, and application platform APIs. Metadata
/// only — no Flutter, GoRouter, UI, routing ownership, or feature wiring.
final class PlatformKernel {
  /// Creates a kernel from already-built platform APIs.
  const PlatformKernel({
    required this.environment,
    required this.runtime,
    required this.application,
    required this.navigation,
    required this.moduleContext,
    required this.query,
    required this.discovery,
    required this.lifecycle,
    required this.activation,
  });

  /// Builds a kernel from [environment] public surfaces.
  factory PlatformKernel.fromEnvironment(PlatformEnvironment environment) {
    return PlatformKernel(
      environment: environment,
      runtime: environment.runtime,
      application: environment.application,
      navigation: environment.navigation,
      moduleContext: environment.moduleContext,
      query: environment.query,
      discovery: environment.discovery,
      lifecycle: environment.lifecycle,
      activation: environment.activation,
    );
  }

  /// Builds a kernel from [bootstrap] public platform surfaces.
  factory PlatformKernel.fromBootstrap(PlatformBootstrap bootstrap) {
    return PlatformKernel.fromEnvironment(bootstrap.environment);
  }

  /// Immutable complete platform execution environment.
  final PlatformEnvironment environment;

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
