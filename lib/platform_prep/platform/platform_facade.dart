import 'package:savingor_app/platform_prep/application/platform_application.dart';
import 'package:savingor_app/platform_prep/bootstrap/platform_bootstrap.dart';
import 'package:savingor_app/platform_prep/environment/platform_environment.dart';
import 'package:savingor_app/platform_prep/kernel/platform_kernel.dart';
import 'package:savingor_app/platform_prep/runtime/platform_runtime.dart';

/// Stable public entry point to the Application Platform.
///
/// Thin wrapper over [PlatformKernel]. Prefer this type (or
/// [PlatformBootstrap.facade] / [PlatformBootstrap.platformQuery]) for new
/// product code. Metadata only; no Flutter/GoRouter/UI ownership.
final class PlatformFacade {
  /// Creates a facade view over [kernel].
  ///
  /// Optional named parameters are accepted for backwards compatibility; when
  /// provided they must be identical to the corresponding [kernel] surfaces.
  PlatformFacade({
    required this.kernel,
    PlatformEnvironment? environment,
    PlatformRuntime? runtime,
    PlatformApplication? application,
  })  : assert(
          environment == null || identical(environment, kernel.environment),
        ),
        assert(runtime == null || identical(runtime, kernel.runtime)),
        assert(
          application == null || identical(application, kernel.application),
        );

  /// Builds a facade from [kernel] public surfaces.
  factory PlatformFacade.fromKernel(PlatformKernel kernel) {
    return PlatformFacade(kernel: kernel);
  }

  /// Builds a facade from [bootstrap] public platform surfaces.
  factory PlatformFacade.fromBootstrap(PlatformBootstrap bootstrap) {
    return PlatformFacade.fromKernel(bootstrap.kernel);
  }

  /// Immutable platform core root.
  final PlatformKernel kernel;

  /// Immutable complete platform execution environment.
  PlatformEnvironment get environment => kernel.environment;

  /// Immutable live platform runtime.
  PlatformRuntime get runtime => kernel.runtime;

  /// Immutable platform application entry point.
  PlatformApplication get application => kernel.application;
}
