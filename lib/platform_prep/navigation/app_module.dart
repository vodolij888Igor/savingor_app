import 'package:savingor_app/platform_prep/navigation/module_id.dart';
import 'package:savingor_app/platform_prep/navigation/route_contribution.dart';
import 'package:savingor_app/platform_prep/navigation/shell_tab_contribution.dart';

/// Product-neutral contract for a composable application module.
///
/// Implementations declare identity, routes, and shell tabs without importing
/// product screens or router packages.
abstract class AppModule {
  /// Stable module identity.
  ModuleId get id;

  /// Routes this module contributes (unmodifiable when implemented via registry).
  List<RouteContribution> get routeContributions;

  /// Shell tabs this module contributes.
  List<ShellTabContribution> get shellTabs;
}
