import 'package:savingor_app/platform_prep/feature_flags/feature_flag_context.dart';
import 'package:savingor_app/platform_prep/feature_flags/feature_flag_key.dart';
import 'package:savingor_app/platform_prep/feature_flags/feature_flag_service.dart';

/// In-memory [FeatureFlagService] backed by a fixed defaults map.
///
/// Unknown keys evaluate to `false`. No remote providers.
class LocalFeatureFlagService extends FeatureFlagService {
  /// Creates a service from [defaults].
  ///
  /// Stores an unmodifiable copy so later mutation of the input map cannot
  /// change evaluation results.
  LocalFeatureFlagService({
    Map<FeatureFlagKey, bool> defaults = const <FeatureFlagKey, bool>{},
  }) : _defaults = Map<FeatureFlagKey, bool>.unmodifiable(
          Map<FeatureFlagKey, bool>.from(defaults),
        );

  final Map<FeatureFlagKey, bool> _defaults;

  /// Configured default values (unmodifiable).
  Map<FeatureFlagKey, bool> get defaults => _defaults;

  @override
  bool isEnabled(
    FeatureFlagKey key, {
    FeatureFlagContext context = const FeatureFlagContext(),
  }) {
    return _defaults[key] ?? false;
  }
}
