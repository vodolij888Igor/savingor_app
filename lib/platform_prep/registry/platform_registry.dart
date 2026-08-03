import 'package:savingor_app/platform_prep/application/platform_application.dart';
import 'package:savingor_app/platform_prep/bootstrap/platform_bootstrap.dart';
import 'package:savingor_app/platform_prep/environment/platform_environment.dart';
import 'package:savingor_app/platform_prep/kernel/platform_kernel.dart';
import 'package:savingor_app/platform_prep/platform/platform_facade.dart';
import 'package:savingor_app/platform_prep/runtime/platform_runtime.dart';

/// Immutable central registry of platform metadata and public platform objects.
///
/// Composes the stable top-level Application Platform surfaces. Metadata only —
/// no Flutter, GoRouter, UI, routing ownership, or feature wiring.
final class PlatformRegistry {
  /// Creates a registry from already-built platform APIs.
  const PlatformRegistry({
    required this.facade,
    required this.kernel,
    required this.environment,
    required this.runtime,
    required this.application,
  });

  /// Builds a registry from [facade] public surfaces.
  factory PlatformRegistry.fromFacade(PlatformFacade facade) {
    return PlatformRegistry(
      facade: facade,
      kernel: facade.kernel,
      environment: facade.environment,
      runtime: facade.runtime,
      application: facade.application,
    );
  }

  /// Builds a registry from [bootstrap] public platform surfaces.
  factory PlatformRegistry.fromBootstrap(PlatformBootstrap bootstrap) {
    return PlatformRegistry.fromFacade(bootstrap.facade);
  }

  /// Immutable single public Application Platform entry point.
  final PlatformFacade facade;

  /// Immutable platform core root.
  final PlatformKernel kernel;

  /// Immutable complete platform execution environment.
  final PlatformEnvironment environment;

  /// Immutable live platform runtime.
  final PlatformRuntime runtime;

  /// Immutable platform application entry point.
  final PlatformApplication application;
}
