import 'package:savingor_app/platform_prep/feature_flags/feature_flag_service.dart';
import 'package:savingor_app/platform_prep/feature_flags/local_feature_flag_service.dart';
import 'package:savingor_app/platform_prep/navigation/module_registry.dart';
import 'package:savingor_app/platform_prep/navigation/route_catalog.dart';
import 'package:savingor_app/platform_prep/navigation/shell_tab_catalog.dart';
import 'package:savingor_app/savingor/modules/module_loader.dart';
import 'package:savingor_app/savingor/modules/savingor_module_registry.dart';

/// Immutable composition root for platform module and feature-flag services.
///
/// Metadata and service wiring only — not connected to app runtime yet.
final class PlatformBootstrap {
  /// Creates a bootstrap from pre-built platform services.
  ///
  /// [routeCatalog] and [shellTabCatalog] are built once from [moduleLoader]
  /// when omitted, keeping registry, loader, and catalogs consistent.
  PlatformBootstrap({
    required ModuleRegistry moduleRegistry,
    required ModuleLoader moduleLoader,
    required FeatureFlagService featureFlags,
    RouteCatalog? routeCatalog,
    ShellTabCatalog? shellTabCatalog,
  })  : _moduleRegistry = moduleRegistry,
        _moduleLoader = moduleLoader,
        _featureFlags = featureFlags,
        _routeCatalog = routeCatalog ?? RouteCatalog(moduleLoader),
        _shellTabCatalog = shellTabCatalog ?? ShellTabCatalog(moduleLoader);

  final ModuleRegistry _moduleRegistry;
  final ModuleLoader _moduleLoader;
  final FeatureFlagService _featureFlags;
  final RouteCatalog _routeCatalog;
  final ShellTabCatalog _shellTabCatalog;

  /// Registered modules with uniqueness validation.
  ModuleRegistry get moduleRegistry => _moduleRegistry;

  /// Read-only view over [moduleRegistry].
  ModuleLoader get moduleLoader => _moduleLoader;

  /// Feature flag evaluation service (not invoked by this bootstrap).
  FeatureFlagService get featureFlags => _featureFlags;

  /// Aggregated route metadata from registered modules.
  RouteCatalog get routeCatalog => _routeCatalog;

  /// Aggregated shell-tab metadata from registered modules.
  ShellTabCatalog get shellTabCatalog => _shellTabCatalog;

  /// Savingor product bootstrap with default registry, loader, catalogs, and
  /// empty flags.
  factory PlatformBootstrap.savingor() {
    final ModuleRegistry registry = savingorModuleRegistry;
    final ModuleLoader loader = ModuleLoader(registry);
    final FeatureFlagService flags = LocalFeatureFlagService();
    final RouteCatalog routes = RouteCatalog(loader);
    final ShellTabCatalog tabs = ShellTabCatalog(loader);

    return PlatformBootstrap(
      moduleRegistry: registry,
      moduleLoader: loader,
      featureFlags: flags,
      routeCatalog: routes,
      shellTabCatalog: tabs,
    );
  }
}
