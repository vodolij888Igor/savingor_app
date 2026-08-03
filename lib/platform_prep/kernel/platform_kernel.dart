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

/// Immutable root object for the complete application platform core.
///
/// Thin wrapper over [PlatformEnvironment] — leaf APIs are delegated. Metadata
/// only; no Flutter/GoRouter/UI ownership.
final class PlatformKernel {
  /// Creates a kernel view over [environment].
  ///
  /// Optional named parameters are accepted for backwards compatibility; when
  /// provided they must be identical to the corresponding [environment]
  /// surfaces.
  PlatformKernel({
    required this.environment,
    PlatformRuntime? runtime,
    PlatformApplication? application,
    PlatformNavigationFacade? navigation,
    ModuleContext? moduleContext,
    ModuleQueryService? query,
    ModuleDiscoveryService? discovery,
    ModuleLifecycleService? lifecycle,
    ModuleActivationService? activation,
  })  : assert(runtime == null || identical(runtime, environment.runtime)),
        assert(
          application == null ||
              identical(application, environment.application),
        ),
        assert(
          navigation == null || identical(navigation, environment.navigation),
        ),
        assert(
          moduleContext == null ||
              identical(moduleContext, environment.moduleContext),
        ),
        assert(query == null || identical(query, environment.query)),
        assert(
          discovery == null || identical(discovery, environment.discovery),
        ),
        assert(
          lifecycle == null || identical(lifecycle, environment.lifecycle),
        ),
        assert(
          activation == null || identical(activation, environment.activation),
        );

  /// Builds a kernel from [environment] public surfaces.
  factory PlatformKernel.fromEnvironment(PlatformEnvironment environment) {
    return PlatformKernel(environment: environment);
  }

  /// Builds a kernel from [bootstrap] public platform surfaces.
  factory PlatformKernel.fromBootstrap(PlatformBootstrap bootstrap) {
    return PlatformKernel.fromEnvironment(bootstrap.environment);
  }

  /// Immutable complete platform execution environment.
  final PlatformEnvironment environment;

  /// Immutable live platform runtime.
  PlatformRuntime get runtime => environment.runtime;

  /// Immutable platform application entry point.
  PlatformApplication get application => environment.application;

  /// Navigation metadata façade.
  PlatformNavigationFacade get navigation => environment.navigation;

  /// Immutable module platform context.
  ModuleContext get moduleContext => environment.moduleContext;

  /// Read-only module query API.
  ModuleQueryService get query => environment.query;

  /// Read-only module discovery API.
  ModuleDiscoveryService get discovery => environment.discovery;

  /// Module lifecycle snapshot API.
  ModuleLifecycleService get lifecycle => environment.lifecycle;

  /// Module activation evaluator API.
  ModuleActivationService get activation => environment.activation;
}
