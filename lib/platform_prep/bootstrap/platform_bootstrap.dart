import 'package:savingor_app/platform_prep/feature_flags/feature_flag_service.dart';
import 'package:savingor_app/platform_prep/feature_flags/local_feature_flag_service.dart';
import 'package:savingor_app/platform_prep/modules/active_module_set.dart';
import 'package:savingor_app/platform_prep/modules/module_activation_rule.dart';
import 'package:savingor_app/platform_prep/modules/module_activation_service.dart';
import 'package:savingor_app/platform_prep/modules/module_context.dart';
import 'package:savingor_app/platform_prep/navigation/module_id.dart';
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
  /// when omitted. [activationService] and [activeModules] are required so
  /// activation is evaluated exactly once by the caller (typically
  /// [PlatformBootstrap.savingor]).
  ///
  /// [moduleContext] is built once in the constructor body.
  PlatformBootstrap({
    required ModuleRegistry moduleRegistry,
    required ModuleLoader moduleLoader,
    required FeatureFlagService featureFlags,
    required ModuleActivationService activationService,
    required ActiveModuleSet activeModules,
    RouteCatalog? routeCatalog,
    ShellTabCatalog? shellTabCatalog,
  })  : _moduleRegistry = moduleRegistry,
        _moduleLoader = moduleLoader,
        _featureFlags = featureFlags,
        _activationService = activationService,
        _activeModules = activeModules,
        _routeCatalog = routeCatalog ?? RouteCatalog(moduleLoader),
        _shellTabCatalog = shellTabCatalog ?? ShellTabCatalog(moduleLoader) {
    _moduleContext = ModuleContext(
      bootstrap: this,
      moduleRegistry: _moduleRegistry,
      moduleLoader: _moduleLoader,
      featureFlags: _featureFlags,
      routeCatalog: _routeCatalog,
      shellTabCatalog: _shellTabCatalog,
      activationService: _activationService,
      activeModules: _activeModules,
    );
  }

  final ModuleRegistry _moduleRegistry;
  final ModuleLoader _moduleLoader;
  final FeatureFlagService _featureFlags;
  final ModuleActivationService _activationService;
  final ActiveModuleSet _activeModules;
  final RouteCatalog _routeCatalog;
  final ShellTabCatalog _shellTabCatalog;
  late final ModuleContext _moduleContext;

  /// Registered modules with uniqueness validation.
  ModuleRegistry get moduleRegistry => _moduleRegistry;

  /// Read-only view over [moduleRegistry].
  ModuleLoader get moduleLoader => _moduleLoader;

  /// Feature flag evaluation service (not invoked by this bootstrap).
  FeatureFlagService get featureFlags => _featureFlags;

  /// Module activation evaluator constructed once at bootstrap.
  ModuleActivationService get activationService => _activationService;

  /// Modules active after the single bootstrap-time evaluation.
  ActiveModuleSet get activeModules => _activeModules;

  /// Aggregated route metadata from registered modules.
  RouteCatalog get routeCatalog => _routeCatalog;

  /// Aggregated shell-tab metadata from registered modules.
  ShellTabCatalog get shellTabCatalog => _shellTabCatalog;

  /// Immutable module context built once from this bootstrap.
  ModuleContext get moduleContext => _moduleContext;

  /// Savingor product bootstrap with default registry, loader, catalogs,
  /// activation rules, and empty flags.
  ///
  /// Groceries is always enabled. Activation is evaluated exactly once here.
  factory PlatformBootstrap.savingor() {
    final ModuleRegistry registry = savingorModuleRegistry;
    final ModuleLoader loader = ModuleLoader(registry);
    final FeatureFlagService flags = LocalFeatureFlagService();
    final RouteCatalog routes = RouteCatalog(loader);
    final ShellTabCatalog tabs = ShellTabCatalog(loader);
    final ModuleActivationService activation = ModuleActivationService(
      loader: loader,
      featureFlags: flags,
      rules: <ModuleActivationRule>[
        ModuleActivationRule(moduleId: ModuleId('groceries')),
      ],
    );
    final ActiveModuleSet active = activation.evaluate();

    return PlatformBootstrap(
      moduleRegistry: registry,
      moduleLoader: loader,
      featureFlags: flags,
      routeCatalog: routes,
      shellTabCatalog: tabs,
      activationService: activation,
      activeModules: active,
    );
  }
}
