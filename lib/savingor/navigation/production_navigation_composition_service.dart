import 'package:savingor_app/platform_prep/bootstrap/platform_bootstrap.dart';
import 'package:savingor_app/platform_prep/modules/module_query_service.dart';
import 'package:savingor_app/platform_prep/navigation/active_route_catalog.dart';
import 'package:savingor_app/platform_prep/navigation/active_shell_tab_catalog.dart';
import 'package:savingor_app/savingor/navigation/production_navigation_composition.dart';

/// Composes production navigation metadata from [PlatformBootstrap].
///
/// Builds an immutable [ProductionNavigationComposition] exactly once.
/// Does not own GoRouter, execute navigation, or render UI.
final class ProductionNavigationCompositionService {
  /// Creates a service and composes navigation metadata from [bootstrap].
  ///
  /// Reads [ActiveRouteCatalog], [ActiveShellTabCatalog], and
  /// [ModuleQueryService] from [bootstrap].
  ProductionNavigationCompositionService({
    required PlatformBootstrap bootstrap,
  }) : composition = _compose(bootstrap);

  /// Immutable composed navigation metadata.
  final ProductionNavigationComposition composition;

  static ProductionNavigationComposition _compose(PlatformBootstrap bootstrap) {
    final ActiveRouteCatalog routes = bootstrap.activeRouteCatalog;
    final ActiveShellTabCatalog tabs = bootstrap.activeShellTabCatalog;
    final ModuleQueryService query = bootstrap.queryService;

    return ProductionNavigationComposition(
      routes: routes.routes,
      shellTabs: tabs.tabs,
      modules: query.activeModules(),
    );
  }
}
