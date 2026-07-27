import 'package:savingor_app/platform_prep/feature_flags/feature_flag_key.dart';

/// Savingor Groceries vertical feature-flag keys.
///
/// Product-specific; not part of the universal platform contracts.
abstract final class GroceriesFlags {
  /// Whether the Groceries vertical is enabled.
  static final FeatureFlagKey verticalEnabled =
      FeatureFlagKey('vertical.groceries.enabled');
}
