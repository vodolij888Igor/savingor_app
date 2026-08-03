import 'package:savingor_app/platform_prep/application/platform_application.dart';
import 'package:savingor_app/platform_prep/bootstrap/platform_bootstrap.dart';
import 'package:savingor_app/platform_prep/modules/module_activation_service.dart';
import 'package:savingor_app/platform_prep/modules/module_context.dart';
import 'package:savingor_app/platform_prep/modules/module_discovery_service.dart';
import 'package:savingor_app/platform_prep/modules/module_lifecycle_service.dart';
import 'package:savingor_app/platform_prep/modules/module_query_service.dart';
import 'package:savingor_app/savingor/navigation/platform_navigation_facade.dart';

/// Immutable live runtime view of the application platform.
///
/// Thin wrapper over [PlatformApplication] — leaf APIs are delegated to avoid
/// duplicated field storage. Metadata only; no Flutter/GoRouter/UI ownership.
final class PlatformRuntime {
  /// Creates a runtime view over [application].
  ///
  /// Optional named parameters are accepted for backwards compatibility; when
  /// provided they must be identical to the corresponding [application]
  /// surfaces.
  PlatformRuntime({
    required this.application,
    PlatformNavigationFacade? navigation,
    ModuleContext? moduleContext,
    ModuleQueryService? query,
    ModuleDiscoveryService? discovery,
    ModuleLifecycleService? lifecycle,
    ModuleActivationService? activation,
  })  : assert(
          navigation == null || identical(navigation, application.navigation),
        ),
        assert(
          moduleContext == null ||
              identical(moduleContext, application.moduleContext),
        ),
        assert(query == null || identical(query, application.query)),
        assert(
          discovery == null || identical(discovery, application.discovery),
        ),
        assert(
          lifecycle == null || identical(lifecycle, application.lifecycle),
        ),
        assert(
          activation == null || identical(activation, application.activation),
        );

  /// Builds a runtime from [application] public surfaces.
  factory PlatformRuntime.fromApplication(PlatformApplication application) {
    return PlatformRuntime(application: application);
  }

  /// Builds a runtime from [bootstrap] public platform surfaces.
  factory PlatformRuntime.fromBootstrap(PlatformBootstrap bootstrap) {
    return PlatformRuntime.fromApplication(bootstrap.application);
  }

  /// Immutable platform application entry point.
  final PlatformApplication application;

  /// Navigation metadata façade.
  PlatformNavigationFacade get navigation => application.navigation;

  /// Immutable module platform context.
  ModuleContext get moduleContext => application.moduleContext;

  /// Read-only module query API.
  ModuleQueryService get query => application.query;

  /// Read-only module discovery API.
  ModuleDiscoveryService get discovery => application.discovery;

  /// Module lifecycle snapshot API.
  ModuleLifecycleService get lifecycle => application.lifecycle;

  /// Module activation evaluator API.
  ModuleActivationService get activation => application.activation;
}
