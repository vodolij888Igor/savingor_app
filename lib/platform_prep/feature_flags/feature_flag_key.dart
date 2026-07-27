/// Product-neutral stable identifier for a feature flag.
///
/// Wraps a non-empty string. Equality is by [value].
class FeatureFlagKey {
  /// Creates a [FeatureFlagKey] from [value].
  ///
  /// Throws [ArgumentError] if [value] is empty or whitespace-only.
  FeatureFlagKey(String value) : value = _validate(value);

  /// Underlying stable string identifier.
  final String value;

  static String _validate(String value) {
    if (value.trim().isEmpty) {
      throw ArgumentError.value(
        value,
        'value',
        'FeatureFlagKey must be a non-empty string',
      );
    }
    return value;
  }

  @override
  bool operator ==(Object other) {
    return other is FeatureFlagKey && other.value == value;
  }

  @override
  int get hashCode => value.hashCode;

  @override
  String toString() => 'FeatureFlagKey($value)';
}
