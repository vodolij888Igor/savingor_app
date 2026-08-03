import 'package:savingor_app/platform_prep/bootstrap/platform_bootstrap.dart';
import 'package:savingor_app/platform_prep/lifecycle/platform_lifecycle.dart';
import 'package:savingor_app/platform_prep/modules/module_activation_rule.dart';
import 'package:savingor_app/platform_prep/modules/module_activation_service.dart';
import 'package:savingor_app/platform_prep/navigation/app_module.dart';
import 'package:savingor_app/platform_prep/navigation/module_id.dart';

/// High-level platform activation phase.
enum PlatformActivationStatus {
  /// Activation has not been evaluated.
  inactive,

  /// Activation rules exist but no modules are active.
  pending,

  /// At least one module is active.
  active,

  /// Activation is complete and the platform reports ready.
  ready,
}

/// Immutable platform activation metadata and query helpers.
///
/// Derived from [PlatformLifecycle]. Metadata only — no Flutter, GoRouter, UI,
/// routing ownership, or feature wiring.
final class PlatformActivation {
  /// Creates activation metadata from explicit fields.
  const PlatformActivation({
    required this.lifecycle,
    required this.status,
    required this.isActivationReady,
    required this.isActivationAvailable,
    required this.hasActiveModules,
    required this.activeModules,
    required this.activationRules,
  });

  /// Builds activation metadata from [lifecycle].
  factory PlatformActivation.fromLifecycle(PlatformLifecycle lifecycle) {
    final List<AppModule> activeModules = List<AppModule>.unmodifiable(
      List<AppModule>.from(lifecycle.environment.query.activeModules()),
    );
    final List<ModuleActivationRule> rules =
        List<ModuleActivationRule>.unmodifiable(
      List<ModuleActivationRule>.from(lifecycle.environment.activation.rules),
    );
    final bool hasActiveModules = activeModules.isNotEmpty;
    final bool isActivationAvailable = rules.isNotEmpty || hasActiveModules;
    final bool isActivationReady =
        lifecycle.isActivated && lifecycle.isReady && hasActiveModules;

    final PlatformActivationStatus status;
    if (!isActivationAvailable) {
      status = PlatformActivationStatus.inactive;
    } else if (!hasActiveModules) {
      status = PlatformActivationStatus.pending;
    } else if (!isActivationReady) {
      status = PlatformActivationStatus.active;
    } else {
      status = PlatformActivationStatus.ready;
    }

    return PlatformActivation(
      lifecycle: lifecycle,
      status: status,
      isActivationReady: isActivationReady,
      isActivationAvailable: isActivationAvailable,
      hasActiveModules: hasActiveModules,
      activeModules: activeModules,
      activationRules: rules,
    );
  }

  /// Builds activation metadata from [bootstrap.platformLifecycle].
  factory PlatformActivation.fromBootstrap(PlatformBootstrap bootstrap) {
    return PlatformActivation.fromLifecycle(bootstrap.platformLifecycle);
  }

  /// Lifecycle snapshot this activation metadata describes.
  final PlatformLifecycle lifecycle;

  /// Derived high-level activation status.
  final PlatformActivationStatus status;

  /// Whether activation is ready for platform consumers.
  final bool isActivationReady;

  /// Whether activation rules or active modules are available.
  final bool isActivationAvailable;

  /// Whether any modules are currently active.
  final bool hasActiveModules;

  /// Active modules (unmodifiable).
  final List<AppModule> activeModules;

  /// Configured activation rules (unmodifiable).
  final List<ModuleActivationRule> activationRules;

  /// Underlying module activation service from the environment.
  ModuleActivationService get activationService =>
      lifecycle.environment.activation;

  /// Number of active modules.
  int get activeModuleCount => activeModules.length;

  /// Number of activation rules.
  int get activationRuleCount => activationRules.length;

  /// Whether activation reports [PlatformActivationStatus.ready].
  bool get isReadyStatus => status == PlatformActivationStatus.ready;

  /// Whether a module with [id] is active.
  bool containsActiveModule(ModuleId id) {
    for (final AppModule module in activeModules) {
      if (module.id == id) {
        return true;
      }
    }
    return false;
  }

  /// Returns the active module with [id], or `null`.
  AppModule? findActiveModule(ModuleId id) {
    for (final AppModule module in activeModules) {
      if (module.id == id) {
        return module;
      }
    }
    return null;
  }

  /// Whether an activation rule targets [id].
  bool containsActivationRule(ModuleId id) {
    for (final ModuleActivationRule rule in activationRules) {
      if (rule.moduleId == id) {
        return true;
      }
    }
    return false;
  }

  /// Returns the activation rule for [id], or `null`.
  ModuleActivationRule? findActivationRule(ModuleId id) {
    for (final ModuleActivationRule rule in activationRules) {
      if (rule.moduleId == id) {
        return rule;
      }
    }
    return null;
  }
}
