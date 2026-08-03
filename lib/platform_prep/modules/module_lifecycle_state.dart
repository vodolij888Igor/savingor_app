import 'package:savingor_app/platform_prep/navigation/module_id.dart';
import 'package:savingor_app/platform_prep/navigation/app_module.dart';

/// Lifecycle phase for a registered application module.
enum ModuleLifecycleState {
  /// Present in the module registry / loader.
  registered,

  /// Present in the [ActiveModuleSet].
  activated,

  /// Registered but not present in the [ActiveModuleSet].
  deactivated,
}

/// Immutable lifecycle snapshot for a single module.
class ModuleLifecycleInfo {
  /// Creates lifecycle info for [module] in [state].
  const ModuleLifecycleInfo({
    required this.module,
    required this.state,
  });

  /// Module this info describes.
  final AppModule module;

  /// Current lifecycle state after activation evaluation.
  final ModuleLifecycleState state;

  /// Stable module identity.
  ModuleId get moduleId => module.id;
}
