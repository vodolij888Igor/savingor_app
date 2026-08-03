import 'package:savingor_app/platform_prep/modules/module_lifecycle_service.dart';
import 'package:savingor_app/platform_prep/modules/module_lifecycle_state.dart';
import 'package:savingor_app/platform_prep/navigation/app_module.dart';
import 'package:savingor_app/platform_prep/navigation/module_id.dart';
import 'package:savingor_app/platform_prep/navigation/module_registry.dart';

/// Product-neutral read-only discovery API over registered and activated modules.
///
/// Reads only from [ModuleRegistry] and [ModuleLifecycleService]. Does not
/// evaluate feature flags or change activation.
class ModuleDiscoveryService {
  /// Creates a discovery service from [registry] and [lifecycle].
  ModuleDiscoveryService({
    required ModuleRegistry registry,
    required ModuleLifecycleService lifecycle,
  })  : _registry = registry,
        _lifecycle = lifecycle,
        _registered = List<AppModule>.unmodifiable(
          List<AppModule>.from(registry.modules),
        ),
        _active = List<AppModule>.unmodifiable(
          List<AppModule>.from(lifecycle.activated),
        );

  final ModuleRegistry _registry;
  final ModuleLifecycleService _lifecycle;
  final List<AppModule> _registered;
  final List<AppModule> _active;

  /// All registered modules in registry order (unmodifiable).
  List<AppModule> get registeredModules => _registered;

  /// Modules currently activated (unmodifiable).
  List<AppModule> get activeModules => _active;

  /// Whether a module with [id] is registered.
  bool contains(ModuleId id) => _registry.findById(id) != null;

  /// Returns the registered module with [id], or `null` if none exists.
  AppModule? findById(ModuleId id) => _registry.findById(id);

  /// Modules matching [state], via [ModuleLifecycleService] (unmodifiable).
  List<AppModule> modulesByActivationState(ModuleLifecycleState state) {
    return List<AppModule>.unmodifiable(
      List<AppModule>.from(_lifecycle.modulesInState(state)),
    );
  }
}
