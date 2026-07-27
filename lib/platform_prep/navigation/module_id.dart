/// Product-neutral stable identifier for an [AppModule].
///
/// Wraps a non-empty string. Equality is by [value].
class ModuleId {
  /// Creates a [ModuleId] from [value].
  ///
  /// Throws [ArgumentError] if [value] is empty or whitespace-only.
  ModuleId(String value) : value = _validate(value);

  /// Underlying stable string identifier.
  final String value;

  static String _validate(String value) {
    if (value.trim().isEmpty) {
      throw ArgumentError.value(
        value,
        'value',
        'ModuleId must be a non-empty string',
      );
    }
    return value;
  }

  @override
  bool operator ==(Object other) {
    return other is ModuleId && other.value == value;
  }

  @override
  int get hashCode => value.hashCode;

  @override
  String toString() => 'ModuleId($value)';
}
