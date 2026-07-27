/// Product-neutral descriptor for a shell tab contributed by an [AppModule].
///
/// Excludes icons and localized labels so the contract stays UI-agnostic.
class ShellTabContribution {
  /// Creates a shell tab contribution.
  ///
  /// Throws [ArgumentError] if [key] or [routePath] is empty or whitespace-only.
  ShellTabContribution({
    required String key,
    required String routePath,
    required this.sortOrder,
  })  : key = _validateNonEmpty(key, 'key'),
        routePath = _validateNonEmpty(routePath, 'routePath');

  /// Stable tab key (unique across a [ModuleRegistry]).
  final String key;

  /// Path this tab navigates to.
  final String routePath;

  /// Relative order among shell tabs (lower values appear first).
  final int sortOrder;

  static String _validateNonEmpty(String value, String label) {
    if (value.trim().isEmpty) {
      throw ArgumentError.value(
        value,
        label,
        'ShellTabContribution.$label must be a non-empty string',
      );
    }
    return value;
  }
}
