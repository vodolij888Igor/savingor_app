/// Metadata-only description of a production Savingor route.
///
/// Contains name and path only — no builders, screens, or GoRouter types.
class ProductionRouteContract {
  /// Creates a contract for [name] and [path].
  ///
  /// Throws [ArgumentError] if [name] or [path] is empty or whitespace-only.
  ProductionRouteContract({
    required String name,
    required String path,
  })  : name = _validateNonEmpty(name, 'name'),
        path = _validateNonEmpty(path, 'path');

  /// Stable route name (platform-aligned identifier).
  final String name;

  /// Route path as used by the production router.
  final String path;

  static String _validateNonEmpty(String value, String label) {
    if (value.trim().isEmpty) {
      throw ArgumentError.value(
        value,
        label,
        'ProductionRouteContract.$label must be a non-empty string',
      );
    }
    return value;
  }
}
