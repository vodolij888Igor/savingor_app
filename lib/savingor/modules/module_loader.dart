import 'package:savingor_app/platform_prep/navigation/app_module.dart';
import 'package:savingor_app/platform_prep/navigation/module_id.dart';
import 'package:savingor_app/platform_prep/navigation/module_registry.dart';

/// Thin read-only view over a [ModuleRegistry].
///
/// Does not cache, evaluate feature flags, or mutate the registry.
class ModuleLoader {
  /// Creates a loader for [registry].
  ModuleLoader(this._registry);

  final ModuleRegistry _registry;

  /// Registered modules in registry insertion order (unmodifiable).
  List<AppModule> get modules => _registry.modules;

  /// Number of registered modules.
  int get moduleCount => _registry.modules.length;

  /// Whether a module with [id] is registered.
  bool contains(ModuleId id) => _registry.findById(id) != null;

  /// Returns the module with [id], or `null` if none is registered.
  AppModule? get(ModuleId id) => _registry.findById(id);
}
