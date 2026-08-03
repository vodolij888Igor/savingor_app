import 'package:savingor_app/platform_prep/application/platform_application.dart';
import 'package:savingor_app/platform_prep/bootstrap/platform_bootstrap.dart';
import 'package:savingor_app/platform_prep/modules/module_activation_service.dart';
import 'package:savingor_app/platform_prep/modules/module_context.dart';
import 'package:savingor_app/platform_prep/modules/module_discovery_service.dart';
import 'package:savingor_app/platform_prep/modules/module_lifecycle_service.dart';
import 'package:savingor_app/platform_prep/modules/module_query_service.dart';
import 'package:savingor_app/platform_prep/runtime/platform_runtime.dart';
import 'package:savingor_app/savingor/navigation/platform_navigation_facade.dart';

/// Immutable complete execution environment for the application platform.
///
/// Thin wrapper over [PlatformRuntime] — leaf APIs are delegated. Metadata
/// only; no Flutter/GoRouter/UI ownership.
final class PlatformEnvironment {
  /// Creates an environment view over [runtime].
  ///
  /// Optional named parameters are accepted for backwards compatibility; when
  /// provided they must be identical to the corresponding [runtime] surfaces.
  PlatformEnvironment({
    required this.runtime,
    PlatformApplication? application,
    PlatformNavigationFacade? navigation,
    ModuleContext? moduleContext,
    ModuleQueryService? query,
    ModuleDiscoveryService? discovery,
    ModuleLifecycleService? lifecycle,
    ModuleActivationService? activation,
  })  : assert(
          application == null || identical(application, runtime.application),
        ),
        assert(
          navigation == null || identical(navigation, runtime.navigation),
        ),
        assert(
          moduleContext == null ||
              identical(moduleContext, runtime.moduleContext),
        ),
        assert(query == null || identical(query, runtime.query)),
        assert(discovery == null || identical(discovery, runtime.discovery)),
        assert(lifecycle == null || identical(lifecycle, runtime.lifecycle)),
        assert(
          activation == null || identical(activation, runtime.activation),
        );

  /// Builds an environment from [runtime] public surfaces.
  factory PlatformEnvironment.fromRuntime(PlatformRuntime runtime) {
    return PlatformEnvironment(runtime: runtime);
  }

  /// Builds an environment from [bootstrap] public platform surfaces.
  factory PlatformEnvironment.fromBootstrap(PlatformBootstrap bootstrap) {
    return PlatformEnvironment.fromRuntime(bootstrap.runtime);
  }

  /// Immutable live platform runtime.
  final PlatformRuntime runtime;

  /// Immutable platform application entry point.
  PlatformApplication get application => runtime.application;

  /// Navigation metadata façade.
  PlatformNavigationFacade get navigation => runtime.navigation;

  /// Immutable module platform context.
  ModuleContext get moduleContext => runtime.moduleContext;

  /// Read-only module query API.
  ModuleQueryService get query => runtime.query;

  /// Read-only module discovery API.
  ModuleDiscoveryService get discovery => runtime.discovery;

  /// Module lifecycle snapshot API.
  ModuleLifecycleService get lifecycle => runtime.lifecycle;

  /// Module activation evaluator API.
  ModuleActivationService get activation => runtime.activation;
}
