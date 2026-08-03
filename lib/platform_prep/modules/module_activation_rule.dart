import 'package:savingor_app/platform_prep/feature_flags/feature_flag_key.dart';
import 'package:savingor_app/platform_prep/navigation/module_id.dart';

/// Product-neutral rule describing when a module may become active.
///
/// A null [requiredFlag] means the module is always enabled when this rule is
/// present. Otherwise activation requires [FeatureFlagService] to return true
/// for [requiredFlag].
class ModuleActivationRule {
  /// Creates an activation rule for [moduleId].
  const ModuleActivationRule({
    required this.moduleId,
    this.requiredFlag,
  });

  /// Module this rule applies to.
  final ModuleId moduleId;

  /// Optional flag that must be enabled for activation.
  final FeatureFlagKey? requiredFlag;
}
