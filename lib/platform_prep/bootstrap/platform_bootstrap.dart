import 'package:savingor_app/platform_prep/application/platform_application.dart';
import 'package:savingor_app/platform_prep/discovery/platform_discovery.dart';
import 'package:savingor_app/platform_prep/environment/platform_environment.dart';
import 'package:savingor_app/platform_prep/feature_flags/feature_flag_service.dart';
import 'package:savingor_app/platform_prep/feature_flags/local_feature_flag_service.dart';
import 'package:savingor_app/platform_prep/kernel/platform_kernel.dart';
import 'package:savingor_app/platform_prep/lifecycle/platform_lifecycle.dart';
import 'package:savingor_app/platform_prep/modules/active_module_set.dart';
import 'package:savingor_app/platform_prep/modules/module_activation_rule.dart';
import 'package:savingor_app/platform_prep/modules/module_activation_service.dart';
import 'package:savingor_app/platform_prep/modules/module_context.dart';
import 'package:savingor_app/platform_prep/modules/module_discovery_service.dart';
import 'package:savingor_app/platform_prep/modules/module_lifecycle_service.dart';
import 'package:savingor_app/platform_prep/modules/module_query_service.dart';
import 'package:savingor_app/platform_prep/navigation/active_route_catalog.dart';
import 'package:savingor_app/platform_prep/navigation/active_shell_tab_catalog.dart';
import 'package:savingor_app/platform_prep/navigation/module_id.dart';
import 'package:savingor_app/platform_prep/navigation/module_registry.dart';
import 'package:savingor_app/platform_prep/navigation/route_catalog.dart';
import 'package:savingor_app/platform_prep/navigation/shell_tab_catalog.dart';
import 'package:savingor_app/platform_prep/platform/platform_facade.dart';
import 'package:savingor_app/platform_prep/registry/platform_registry.dart';
import 'package:savingor_app/platform_prep/runtime/platform_runtime.dart';
import 'package:savingor_app/savingor/bootstrap/route_parity_startup.dart';
import 'package:savingor_app/savingor/modules/module_loader.dart';
import 'package:savingor_app/savingor/modules/savingor_module_registry.dart';
import 'package:savingor_app/savingor/navigation/platform_navigation_facade.dart';
import 'package:savingor_app/savingor/navigation/production_navigation_composition.dart';

/// Immutable composition root for platform module and feature-flag services.
///
/// Metadata and service wiring only — not connected to app runtime yet.
final class PlatformBootstrap {
  /// Creates a bootstrap from pre-built platform services.
  ///
  /// Optional catalogs/lifecycle/discovery/query are built once when omitted.
  /// [moduleContext] and [navigation] are built once in the constructor body.
  ///
  /// When [verifyProductionRouteParity] is true, Groceries route parity runs
  /// exactly once here (skipped in release builds).
  PlatformBootstrap({
    required ModuleRegistry moduleRegistry,
    required ModuleLoader moduleLoader,
    required FeatureFlagService featureFlags,
    required ModuleActivationService activationService,
    required ActiveModuleSet activeModules,
    RouteCatalog? routeCatalog,
    ShellTabCatalog? shellTabCatalog,
    ActiveRouteCatalog? activeRouteCatalog,
    ActiveShellTabCatalog? activeShellTabCatalog,
    ModuleLifecycleService? lifecycleService,
    ModuleDiscoveryService? discoveryService,
    ModuleQueryService? queryService,
    bool verifyProductionRouteParity = false,
  })  : _moduleRegistry = moduleRegistry,
        _moduleLoader = moduleLoader,
        _featureFlags = featureFlags,
        _activationService = activationService,
        _activeModules = activeModules,
        _routeCatalog = routeCatalog ?? RouteCatalog(moduleLoader),
        _shellTabCatalog = shellTabCatalog ?? ShellTabCatalog(moduleLoader),
        _activeRouteCatalog =
            activeRouteCatalog ?? ActiveRouteCatalog(activeModules),
        _activeShellTabCatalog =
            activeShellTabCatalog ?? ActiveShellTabCatalog(activeModules),
        _lifecycleService = lifecycleService ??
            ModuleLifecycleService(
              loader: moduleLoader,
              activeModules: activeModules,
            ) {
    _discoveryService = discoveryService ??
        ModuleDiscoveryService(
          registry: _moduleRegistry,
          lifecycle: _lifecycleService,
        );
    _queryService = queryService ??
        ModuleQueryService(
          discovery: _discoveryService,
          lifecycle: _lifecycleService,
        );
    _moduleContext = ModuleContext(
      bootstrap: this,
      moduleRegistry: _moduleRegistry,
      moduleLoader: _moduleLoader,
      featureFlags: _featureFlags,
      routeCatalog: _routeCatalog,
      shellTabCatalog: _shellTabCatalog,
      activeRouteCatalog: _activeRouteCatalog,
      activeShellTabCatalog: _activeShellTabCatalog,
      activationService: _activationService,
      activeModules: _activeModules,
      lifecycleService: _lifecycleService,
      discoveryService: _discoveryService,
      queryService: _queryService,
    );
    _navigation = PlatformNavigationFacade.fromComposition(
      ProductionNavigationComposition(
        routes: _activeRouteCatalog.routes,
        shellTabs: _activeShellTabCatalog.tabs,
        modules: _queryService.activeModules(),
      ),
    );
    _application = PlatformApplication(
      navigation: _navigation,
      moduleContext: _moduleContext,
      query: _queryService,
      discovery: _discoveryService,
      lifecycle: _lifecycleService,
      activation: _activationService,
    );
    _runtime = PlatformRuntime.fromApplication(_application);
    _environment = PlatformEnvironment.fromRuntime(_runtime);
    _kernel = PlatformKernel.fromEnvironment(_environment);
    _facade = PlatformFacade.fromKernel(_kernel);
    _platformRegistry = PlatformRegistry.fromFacade(_facade);
    _platformDiscovery = PlatformDiscovery.fromRegistry(_platformRegistry);
    _platformLifecycle = PlatformLifecycle.fromEnvironment(_environment);

    if (verifyProductionRouteParity) {
      verifySavingorProductionRouteParity(
        activeRouteCatalog: _activeRouteCatalog,
      );
    }
  }

  final ModuleRegistry _moduleRegistry;
  final ModuleLoader _moduleLoader;
  final FeatureFlagService _featureFlags;
  final ModuleActivationService _activationService;
  final ActiveModuleSet _activeModules;
  final RouteCatalog _routeCatalog;
  final ShellTabCatalog _shellTabCatalog;
  final ActiveRouteCatalog _activeRouteCatalog;
  final ActiveShellTabCatalog _activeShellTabCatalog;
  final ModuleLifecycleService _lifecycleService;
  late final ModuleDiscoveryService _discoveryService;
  late final ModuleQueryService _queryService;
  late final ModuleContext _moduleContext;
  late final PlatformNavigationFacade _navigation;
  late final PlatformApplication _application;
  late final PlatformRuntime _runtime;
  late final PlatformEnvironment _environment;
  late final PlatformKernel _kernel;
  late final PlatformFacade _facade;
  late final PlatformRegistry _platformRegistry;
  late final PlatformDiscovery _platformDiscovery;
  late final PlatformLifecycle _platformLifecycle;

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

  /// Route metadata from active modules only.
  ActiveRouteCatalog get activeRouteCatalog => _activeRouteCatalog;

  /// Shell-tab metadata from active modules only.
  ActiveShellTabCatalog get activeShellTabCatalog => _activeShellTabCatalog;

  /// Lifecycle snapshot derived from registration and [activeModules].
  ModuleLifecycleService get lifecycleService => _lifecycleService;

  /// Read-only module discovery over registry and lifecycle.
  ModuleDiscoveryService get discoveryService => _discoveryService;

  /// Read-only query façade over discovery and lifecycle.
  ModuleQueryService get queryService => _queryService;

  /// Immutable module context built once from this bootstrap.
  ModuleContext get moduleContext => _moduleContext;

  /// Single entry point for platform navigation metadata (built once).
  PlatformNavigationFacade get navigation => _navigation;

  /// Immutable public platform application entry point (built once).
  PlatformApplication get application => _application;

  /// Immutable live platform runtime entry point (built once).
  PlatformRuntime get runtime => _runtime;

  /// Immutable complete platform execution environment (built once).
  PlatformEnvironment get environment => _environment;

  /// Immutable platform core root (built once).
  PlatformKernel get kernel => _kernel;

  /// Immutable single public Application Platform entry point (built once).
  PlatformFacade get facade => _facade;

  /// Immutable central registry of platform metadata and public objects
  /// (built once).
  PlatformRegistry get platformRegistry => _platformRegistry;

  /// Immutable read-only discovery API over [platformRegistry] (built once).
  PlatformDiscovery get platformDiscovery => _platformDiscovery;

  /// Immutable platform lifecycle metadata API (built once).
  PlatformLifecycle get platformLifecycle => _platformLifecycle;

  /// Savingor product bootstrap with default registry, loader, catalogs,
  /// activation rules, lifecycle, discovery, query, and empty flags.
  ///
  /// Groceries is always enabled. Activation is evaluated exactly once here.
  /// Production route parity is verified once at construction (non-release).
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
    final ActiveRouteCatalog activeRoutes = ActiveRouteCatalog(active);
    final ActiveShellTabCatalog activeTabs = ActiveShellTabCatalog(active);
    final ModuleLifecycleService lifecycle = ModuleLifecycleService(
      loader: loader,
      activeModules: active,
    );
    final ModuleDiscoveryService discovery = ModuleDiscoveryService(
      registry: registry,
      lifecycle: lifecycle,
    );
    final ModuleQueryService query = ModuleQueryService(
      discovery: discovery,
      lifecycle: lifecycle,
    );

    return PlatformBootstrap(
      moduleRegistry: registry,
      moduleLoader: loader,
      featureFlags: flags,
      routeCatalog: routes,
      shellTabCatalog: tabs,
      activeRouteCatalog: activeRoutes,
      activeShellTabCatalog: activeTabs,
      activationService: activation,
      activeModules: active,
      lifecycleService: lifecycle,
      discoveryService: discovery,
      queryService: query,
      verifyProductionRouteParity: true,
    );
  }
}
