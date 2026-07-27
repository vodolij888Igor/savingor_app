/// Product-neutral descriptor for a route contributed by an [AppModule].
///
/// Intentionally excludes builders and router types so modules can declare
/// routes without depending on navigation implementations or product screens.
class RouteContribution {
  /// Creates a route contribution with a non-empty [name] and [path].
  ///
  /// Throws [ArgumentError] if [name] or [path] is empty or whitespace-only.
  RouteContribution({
    required String name,
    required String path,
  })  : name = _validateNonEmpty(name, 'name'),
        path = _validateNonEmpty(path, 'path');

  /// Stable route name (unique across a [ModuleRegistry]).
  final String name;

  /// Route path (unique across a [ModuleRegistry]).
  final String path;

  static String _validateNonEmpty(String value, String label) {
    if (value.trim().isEmpty) {
      throw ArgumentError.value(
        value,
        label,
        'RouteContribution.$label must be a non-empty string',
      );
    }
    return value;
  }
}
