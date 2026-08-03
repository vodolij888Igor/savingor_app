import 'package:savingor_app/platform_prep/modules/module_discovery_service.dart';
import 'package:savingor_app/platform_prep/modules/module_lifecycle_service.dart';
import 'package:savingor_app/platform_prep/modules/module_lifecycle_state.dart';
import 'package:savingor_app/platform_prep/navigation/app_module.dart';
import 'package:savingor_app/platform_prep/navigation/module_id.dart';

/// Product-neutral read-only query façade over discovery and lifecycle.
///
/// Returns immutable collections and value objects only. Does not evaluate
/// feature flags or change activation.
class ModuleQueryService {
  /// Creates a query service from [discovery] and [lifecycle].
  ModuleQueryService({
    required ModuleDiscoveryService discovery,
    required ModuleLifecycleService lifecycle,
  })  : _discovery = discovery,
        _lifecycle = lifecycle;

  final ModuleDiscoveryService _discovery;
  final ModuleLifecycleService _lifecycle;

  /// Returns the registered module with [id], or `null` if none exists.
  AppModule? moduleById(ModuleId id) => _discovery.findById(id);

  /// Active modules (unmodifiable).
  List<AppModule> activeModules() => _discovery.activeModules;

  /// Registered modules (unmodifiable).
  List<AppModule> registeredModules() => _discovery.registeredModules;

  /// Lifecycle info for [id], or `null` if the module is not registered.
  ModuleLifecycleInfo? lifecycleOf(ModuleId id) => _lifecycle.infoOf(id);

  /// Whether [id] is currently activated.
  bool isActive(ModuleId id) {
    return _lifecycle.stateOf(id) == ModuleLifecycleState.activated;
  }

  /// Whether [id] is registered.
  bool exists(ModuleId id) => _discovery.contains(id);
}
