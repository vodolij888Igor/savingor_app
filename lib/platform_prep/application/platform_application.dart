import 'package:savingor_app/platform_prep/bootstrap/platform_bootstrap.dart';
import 'package:savingor_app/platform_prep/modules/module_activation_service.dart';
import 'package:savingor_app/platform_prep/modules/module_context.dart';
import 'package:savingor_app/platform_prep/modules/module_discovery_service.dart';
import 'package:savingor_app/platform_prep/modules/module_lifecycle_service.dart';
import 'package:savingor_app/platform_prep/modules/module_query_service.dart';
import 'package:savingor_app/savingor/navigation/platform_navigation_facade.dart';

/// Immutable public entry point for the Savingor application platform.
///
/// Composes navigation and module platform APIs only. Does not own routing,
/// UI, Flutter types, or feature wiring.
final class PlatformApplication {
  /// Creates an application from already-built platform APIs.
  const PlatformApplication({
    required this.navigation,
    required this.moduleContext,
    required this.query,
    required this.discovery,
    required this.lifecycle,
    required this.activation,
  });

  /// Builds an application from [bootstrap] public platform surfaces.
  factory PlatformApplication.fromBootstrap(PlatformBootstrap bootstrap) {
    return PlatformApplication(
      navigation: bootstrap.navigation,
      moduleContext: bootstrap.moduleContext,
      query: bootstrap.queryService,
      discovery: bootstrap.discoveryService,
      lifecycle: bootstrap.lifecycleService,
      activation: bootstrap.activationService,
    );
  }

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
