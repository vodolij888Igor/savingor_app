import 'package:savingor_app/platform_prep/application/platform_application.dart';
import 'package:savingor_app/platform_prep/bootstrap/platform_bootstrap.dart';
import 'package:savingor_app/platform_prep/environment/platform_environment.dart';
import 'package:savingor_app/platform_prep/kernel/platform_kernel.dart';
import 'package:savingor_app/platform_prep/platform/platform_facade.dart';
import 'package:savingor_app/platform_prep/runtime/platform_runtime.dart';

/// Immutable central registry of platform metadata and public platform objects.
///
/// Thin wrapper over [PlatformFacade]. Metadata only; no Flutter/GoRouter/UI
/// ownership.
final class PlatformRegistry {
  /// Creates a registry view over [facade].
  ///
  /// Optional named parameters are accepted for backwards compatibility; when
  /// provided they must be identical to the corresponding [facade] surfaces.
  PlatformRegistry({
    required this.facade,
    PlatformKernel? kernel,
    PlatformEnvironment? environment,
    PlatformRuntime? runtime,
    PlatformApplication? application,
  })  : assert(kernel == null || identical(kernel, facade.kernel)),
        assert(
          environment == null || identical(environment, facade.environment),
        ),
        assert(runtime == null || identical(runtime, facade.runtime)),
        assert(
          application == null || identical(application, facade.application),
        );

  /// Builds a registry from [facade] public surfaces.
  factory PlatformRegistry.fromFacade(PlatformFacade facade) {
    return PlatformRegistry(facade: facade);
  }

  /// Builds a registry from [bootstrap] public platform surfaces.
  factory PlatformRegistry.fromBootstrap(PlatformBootstrap bootstrap) {
    return PlatformRegistry.fromFacade(bootstrap.facade);
  }

  /// Immutable single public Application Platform entry point.
  final PlatformFacade facade;

  /// Immutable platform core root.
  PlatformKernel get kernel => facade.kernel;

  /// Immutable complete platform execution environment.
  PlatformEnvironment get environment => facade.environment;

  /// Immutable live platform runtime.
  PlatformRuntime get runtime => facade.runtime;

  /// Immutable platform application entry point.
  PlatformApplication get application => facade.application;
}
