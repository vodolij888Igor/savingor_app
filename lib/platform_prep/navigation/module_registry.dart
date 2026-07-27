import 'package:savingor_app/platform_prep/navigation/app_module.dart';
import 'package:savingor_app/platform_prep/navigation/module_id.dart';
import 'package:savingor_app/platform_prep/navigation/route_contribution.dart';
import 'package:savingor_app/platform_prep/navigation/shell_tab_contribution.dart';

/// Registry of [AppModule] instances with uniqueness validation.
///
/// Modules are stored in insertion order. Lookups by [ModuleId] return `null`
/// when no matching module is registered.
class ModuleRegistry {
  /// Creates a registry from [modules].
  ///
  /// Throws [StateError] when module IDs, route names, route paths, or shell
  /// tab keys collide.
  ModuleRegistry(List<AppModule> modules)
      : _modules = List<AppModule>.unmodifiable(List<AppModule>.from(modules)) {
    _validateUnique(_modules);
  }

  final List<AppModule> _modules;

  /// Registered modules in insertion order (unmodifiable).
  List<AppModule> get modules => _modules;

  /// Returns the module with [id], or `null` if none is registered.
  AppModule? findById(ModuleId id) {
    for (final AppModule module in _modules) {
      if (module.id == id) {
        return module;
      }
    }
    return null;
  }

  static void _validateUnique(List<AppModule> modules) {
    final Set<String> moduleIds = <String>{};
    final Set<String> routeNames = <String>{};
    final Set<String> routePaths = <String>{};
    final Set<String> shellTabKeys = <String>{};

    for (final AppModule module in modules) {
      final String moduleId = module.id.value;
      if (!moduleIds.add(moduleId)) {
        throw StateError('Duplicate module ID: "$moduleId"');
      }

      for (final RouteContribution route in module.routeContributions) {
        if (!routeNames.add(route.name)) {
          throw StateError('Duplicate route name: "${route.name}"');
        }
        if (!routePaths.add(route.path)) {
          throw StateError('Duplicate route path: "${route.path}"');
        }
      }

      for (final ShellTabContribution tab in module.shellTabs) {
        if (!shellTabKeys.add(tab.key)) {
          throw StateError('Duplicate shell tab key: "${tab.key}"');
        }
      }
    }
  }
}
