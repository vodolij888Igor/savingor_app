import 'package:savingor_app/platform_prep/bootstrap/platform_bootstrap.dart';
import 'package:savingor_app/platform_prep/environment/platform_environment.dart';
import 'package:savingor_app/platform_prep/modules/module_lifecycle_service.dart';

/// High-level platform lifecycle phase.
enum PlatformLifecycleStatus {
  /// Platform objects have not been assembled.
  uninitialized,

  /// Platform assembly is in progress.
  initializing,

  /// Bootstrap composition has completed.
  bootstrapped,

  /// Modules have been activation-evaluated.
  activated,

  /// Platform is ready for consumers.
  ready,
}

/// Immutable platform lifecycle metadata and coordination primitives.
///
/// Exposes initialization, bootstrap, activation, and readiness state derived
/// from [PlatformEnvironment]. Metadata only — no Flutter, GoRouter, UI, or
/// feature wiring.
final class PlatformLifecycle {
  /// Creates lifecycle metadata from explicit state flags.
  const PlatformLifecycle({
    required this.environment,
    required this.isInitialized,
    required this.isBootstrapComplete,
    required this.isActivated,
    required this.isReady,
    required this.status,
  });

  /// Builds lifecycle metadata from [environment].
  ///
  /// Construction from an assembled [PlatformEnvironment] means initialization
  /// and bootstrap are complete; activation/readiness follow module state.
  factory PlatformLifecycle.fromEnvironment(PlatformEnvironment environment) {
    final bool activated = environment.query.activeModules().isNotEmpty ||
        environment.activation.rules.isNotEmpty;
    final PlatformLifecycleStatus status = activated
        ? PlatformLifecycleStatus.ready
        : PlatformLifecycleStatus.bootstrapped;

    return PlatformLifecycle(
      environment: environment,
      isInitialized: true,
      isBootstrapComplete: true,
      isActivated: activated,
      isReady: activated,
      status: status,
    );
  }

  /// Builds lifecycle metadata from [bootstrap.environment].
  factory PlatformLifecycle.fromBootstrap(PlatformBootstrap bootstrap) {
    return PlatformLifecycle.fromEnvironment(bootstrap.environment);
  }

  /// Environment this lifecycle snapshot describes.
  final PlatformEnvironment environment;

  /// Whether platform core objects have been initialized.
  final bool isInitialized;

  /// Whether bootstrap composition has completed.
  final bool isBootstrapComplete;

  /// Whether module activation evaluation has produced an active set or rules.
  final bool isActivated;

  /// Whether the platform is ready for consumers.
  final bool isReady;

  /// Derived high-level lifecycle status.
  final PlatformLifecycleStatus status;

  /// Whether any modules are currently active.
  bool get hasActiveModules => environment.query.activeModules().isNotEmpty;

  /// Whether lifecycle reports [PlatformLifecycleStatus.ready].
  bool get isReadyStatus => status == PlatformLifecycleStatus.ready;

  /// Whether lifecycle reports [PlatformLifecycleStatus.bootstrapped] or later.
  bool get hasCompletedBootstrap =>
      status == PlatformLifecycleStatus.bootstrapped ||
      status == PlatformLifecycleStatus.activated ||
      status == PlatformLifecycleStatus.ready;

  /// Module lifecycle snapshot from the environment.
  ModuleLifecycleService get moduleLifecycle => environment.lifecycle;
}
