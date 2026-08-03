import 'package:savingor_app/platform_prep/bootstrap/platform_bootstrap.dart';
import 'package:savingor_app/platform_prep/feature_flags/feature_flag_service.dart';
import 'package:savingor_app/platform_prep/modules/active_module_set.dart';
import 'package:savingor_app/platform_prep/modules/module_activation_service.dart';
import 'package:savingor_app/platform_prep/navigation/module_registry.dart';
import 'package:savingor_app/platform_prep/navigation/route_catalog.dart';
import 'package:savingor_app/platform_prep/navigation/shell_tab_catalog.dart';
import 'package:savingor_app/savingor/modules/module_loader.dart';

/// Immutable, product-neutral view over a [PlatformBootstrap] composition.
///
/// Exposes the same service instances owned by bootstrap. Not wired to router,
/// shell, or UI.
final class ModuleContext {
  /// Creates a context from already-built bootstrap services.
  const ModuleContext({
    required this.bootstrap,
    required this.moduleRegistry,
    required this.moduleLoader,
    required this.featureFlags,
    required this.routeCatalog,
    required this.shellTabCatalog,
    required this.activationService,
    required this.activeModules,
  });

  /// Owning bootstrap composition root.
  final PlatformBootstrap bootstrap;

  /// Registered modules with uniqueness validation.
  final ModuleRegistry moduleRegistry;

  /// Read-only view over [moduleRegistry].
  final ModuleLoader moduleLoader;

  /// Feature flag evaluation service.
  final FeatureFlagService featureFlags;

  /// Aggregated route metadata from registered modules.
  final RouteCatalog routeCatalog;

  /// Aggregated shell-tab metadata from registered modules.
  final ShellTabCatalog shellTabCatalog;

  /// Module activation evaluator.
  final ModuleActivationService activationService;

  /// Modules active after bootstrap-time evaluation.
  final ActiveModuleSet activeModules;
}
