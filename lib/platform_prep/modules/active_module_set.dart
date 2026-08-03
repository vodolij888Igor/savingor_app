import 'package:savingor_app/platform_prep/navigation/app_module.dart';
import 'package:savingor_app/platform_prep/navigation/module_id.dart';

/// Immutable set of modules that passed activation evaluation.
///
/// Modules are stored in deterministic [ModuleLoader] registration order.
class ActiveModuleSet {
  /// Creates an active set from [modules].
  ///
  /// Stores an unmodifiable copy so later mutation of the input cannot change
  /// this set.
  ActiveModuleSet(Iterable<AppModule> modules)
      : _modules = List<AppModule>.unmodifiable(List<AppModule>.from(modules));

  final List<AppModule> _modules;

  /// Active modules in registration order (unmodifiable).
  List<AppModule> get modules => _modules;

  /// Number of active modules.
  int get count => _modules.length;

  /// Whether a module with [id] is active.
  bool contains(ModuleId id) => findById(id) != null;

  /// Returns the active module with [id], or `null` if none is active.
  AppModule? findById(ModuleId id) {
    for (final AppModule module in _modules) {
      if (module.id == id) {
        return module;
      }
    }
    return null;
  }
}
