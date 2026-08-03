import 'package:savingor_app/platform_prep/feature_flags/feature_flag_context.dart';
import 'package:savingor_app/platform_prep/feature_flags/feature_flag_key.dart';
import 'package:savingor_app/platform_prep/feature_flags/feature_flag_service.dart';
import 'package:savingor_app/platform_prep/modules/active_module_set.dart';
import 'package:savingor_app/platform_prep/modules/module_activation_rule.dart';
import 'package:savingor_app/platform_prep/navigation/app_module.dart';
import 'package:savingor_app/savingor/modules/module_loader.dart';

/// Evaluates which registered modules are active for a given flag context.
///
/// Product-neutral: does not mutate loader, registry, flags, or rules.
class ModuleActivationService {
  /// Creates a service from [loader], [featureFlags], and [rules].
  ///
  /// Throws [StateError] when a rule references an unknown module or when
  /// multiple rules target the same module ID.
  ModuleActivationService({
    required ModuleLoader loader,
    required FeatureFlagService featureFlags,
    required Iterable<ModuleActivationRule> rules,
  })  : _loader = loader,
        _featureFlags = featureFlags,
        _rules = List<ModuleActivationRule>.unmodifiable(
          List<ModuleActivationRule>.from(rules),
        ) {
    _validateRules(_loader, _rules);
  }

  final ModuleLoader _loader;
  final FeatureFlagService _featureFlags;
  final List<ModuleActivationRule> _rules;

  /// Configured activation rules (unmodifiable).
  List<ModuleActivationRule> get rules => _rules;

  /// Returns modules that are active for [context], in loader registration order.
  ActiveModuleSet evaluate({
    FeatureFlagContext context = const FeatureFlagContext(),
  }) {
    final Map<String, ModuleActivationRule> rulesById =
        <String, ModuleActivationRule>{
      for (final ModuleActivationRule rule in _rules) rule.moduleId.value: rule,
    };

    final List<AppModule> active = <AppModule>[];
    for (final AppModule module in _loader.modules) {
      final ModuleActivationRule? rule = rulesById[module.id.value];
      if (rule == null) {
        continue;
      }

      final FeatureFlagKey? requiredFlag = rule.requiredFlag;
      if (requiredFlag == null) {
        active.add(module);
        continue;
      }

      if (_featureFlags.isEnabled(requiredFlag, context: context)) {
        active.add(module);
      }
    }

    return ActiveModuleSet(active);
  }

  static void _validateRules(
    ModuleLoader loader,
    List<ModuleActivationRule> rules,
  ) {
    final Set<String> registeredIds = <String>{
      for (final AppModule module in loader.modules) module.id.value,
    };
    final Set<String> seenRuleIds = <String>{};

    for (final ModuleActivationRule rule in rules) {
      final String moduleId = rule.moduleId.value;
      if (!registeredIds.contains(moduleId)) {
        throw StateError(
          'Activation rule references unknown module ID: "$moduleId"',
        );
      }
      if (!seenRuleIds.add(moduleId)) {
        throw StateError(
          'Duplicate activation rule for module ID: "$moduleId"',
        );
      }
    }
  }
}
