import 'package:savingor_app/platform_prep/application/platform_application.dart';
import 'package:savingor_app/platform_prep/bootstrap/platform_bootstrap.dart';
import 'package:savingor_app/platform_prep/environment/platform_environment.dart';
import 'package:savingor_app/platform_prep/kernel/platform_kernel.dart';
import 'package:savingor_app/platform_prep/runtime/platform_runtime.dart';

/// Immutable single public entry point to the Application Platform.
///
/// Exposes stable top-level platform APIs only. Metadata only — no Flutter,
/// GoRouter, UI, routing ownership, or feature wiring.
final class PlatformFacade {
  /// Creates a facade from already-built platform APIs.
  const PlatformFacade({
    required this.kernel,
    required this.environment,
    required this.runtime,
    required this.application,
  });

  /// Builds a facade from [kernel] public surfaces.
  factory PlatformFacade.fromKernel(PlatformKernel kernel) {
    return PlatformFacade(
      kernel: kernel,
      environment: kernel.environment,
      runtime: kernel.runtime,
      application: kernel.application,
    );
  }

  /// Builds a facade from [bootstrap] public platform surfaces.
  factory PlatformFacade.fromBootstrap(PlatformBootstrap bootstrap) {
    return PlatformFacade.fromKernel(bootstrap.kernel);
  }

  /// Immutable platform core root.
  final PlatformKernel kernel;

  /// Immutable complete platform execution environment.
  final PlatformEnvironment environment;

  /// Immutable live platform runtime.
  final PlatformRuntime runtime;

  /// Immutable platform application entry point.
  final PlatformApplication application;
}
