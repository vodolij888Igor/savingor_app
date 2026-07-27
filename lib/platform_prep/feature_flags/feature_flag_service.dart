import 'package:savingor_app/platform_prep/feature_flags/feature_flag_context.dart';
import 'package:savingor_app/platform_prep/feature_flags/feature_flag_key.dart';

/// Product-neutral contract for evaluating feature flags.
abstract class FeatureFlagService {
  /// Whether [key] is enabled for [context].
  bool isEnabled(
    FeatureFlagKey key, {
    FeatureFlagContext context = const FeatureFlagContext(),
  });

  /// Evaluates each of [keys] via [isEnabled].
  ///
  /// Returns an unmodifiable map from key to enabled state.
  Map<FeatureFlagKey, bool> evaluateAll(
    Iterable<FeatureFlagKey> keys, {
    FeatureFlagContext context = const FeatureFlagContext(),
  }) {
    final Map<FeatureFlagKey, bool> results = <FeatureFlagKey, bool>{};
    for (final FeatureFlagKey key in keys) {
      results[key] = isEnabled(key, context: context);
    }
    return Map<FeatureFlagKey, bool>.unmodifiable(results);
  }
}
