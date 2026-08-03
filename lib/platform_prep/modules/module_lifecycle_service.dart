import 'package:savingor_app/platform_prep/modules/active_module_set.dart';
import 'package:savingor_app/platform_prep/modules/module_lifecycle_state.dart';
import 'package:savingor_app/platform_prep/navigation/app_module.dart';
import 'package:savingor_app/platform_prep/navigation/module_id.dart';
import 'package:savingor_app/savingor/modules/module_loader.dart';

/// Derives immutable module lifecycle information from registration and
/// [ActiveModuleSet].
///
/// Does not modify activation rules or evaluate feature flags.
class ModuleLifecycleService {
  /// Creates a lifecycle snapshot from [loader] and [activeModules].
  ModuleLifecycleService({
    required ModuleLoader loader,
    required ActiveModuleSet activeModules,
  })  : _registered = List<AppModule>.unmodifiable(
          List<AppModule>.from(loader.modules),
        ),
        _activated = List<AppModule>.unmodifiable(
          List<AppModule>.from(activeModules.modules),
        ),
        _entries = List<ModuleLifecycleInfo>.unmodifiable(
          _buildEntries(loader, activeModules),
        );

  final List<AppModule> _registered;
  final List<AppModule> _activated;
  final List<ModuleLifecycleInfo> _entries;

  /// Lifecycle entries in loader registration order (unmodifiable).
  List<ModuleLifecycleInfo> get entries => _entries;

  /// All registered modules in loader order (unmodifiable).
  List<AppModule> get registered => _registered;

  /// Modules currently activated (unmodifiable; ActiveModuleSet order).
  List<AppModule> get activated => _activated;

  /// Registered modules that are not activated (unmodifiable; loader order).
  List<AppModule> get deactivated {
    final List<AppModule> result = <AppModule>[];
    for (final ModuleLifecycleInfo entry in _entries) {
      if (entry.state == ModuleLifecycleState.deactivated) {
        result.add(entry.module);
      }
    }
    return List<AppModule>.unmodifiable(result);
  }

  /// Returns modules matching [state].
  ///
  /// [ModuleLifecycleState.registered] returns every registered module.
  List<AppModule> modulesInState(ModuleLifecycleState state) {
    switch (state) {
      case ModuleLifecycleState.registered:
        return registered;
      case ModuleLifecycleState.activated:
        return activated;
      case ModuleLifecycleState.deactivated:
        return deactivated;
    }
  }

  /// Whether [id] is present in the loader registry.
  bool isRegistered(ModuleId id) {
    for (final AppModule module in _registered) {
      if (module.id == id) {
        return true;
      }
    }
    return false;
  }

  /// Lifecycle state for [id], or `null` if the module is not registered.
  ///
  /// Registered modules are [ModuleLifecycleState.activated] or
  /// [ModuleLifecycleState.deactivated] after activation evaluation.
  ModuleLifecycleState? stateOf(ModuleId id) {
    for (final ModuleLifecycleInfo entry in _entries) {
      if (entry.moduleId == id) {
        return entry.state;
      }
    }
    return null;
  }

  /// Lifecycle info for [id], or `null` if the module is not registered.
  ModuleLifecycleInfo? infoOf(ModuleId id) {
    for (final ModuleLifecycleInfo entry in _entries) {
      if (entry.moduleId == id) {
        return entry;
      }
    }
    return null;
  }

  static List<ModuleLifecycleInfo> _buildEntries(
    ModuleLoader loader,
    ActiveModuleSet activeModules,
  ) {
    final List<ModuleLifecycleInfo> entries = <ModuleLifecycleInfo>[];
    for (final AppModule module in loader.modules) {
      final bool isActive = activeModules.contains(module.id);
      entries.add(
        ModuleLifecycleInfo(
          module: module,
          state: isActive
              ? ModuleLifecycleState.activated
              : ModuleLifecycleState.deactivated,
        ),
      );
    }
    return entries;
  }
}
