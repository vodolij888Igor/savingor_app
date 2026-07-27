/// Optional evaluation context for feature flag decisions.
///
/// Product-neutral: no Firebase, widget, or app-specific types.
class FeatureFlagContext {
  /// Creates an immutable evaluation context.
  ///
  /// Prefer passing a const [attributes] map. The [attributes] getter always
  /// returns an unmodifiable view.
  const FeatureFlagContext({
    this.userId,
    this.locale,
    this.platform,
    Map<String, Object?> attributes = const <String, Object?>{},
  }) : _attributes = attributes;

  /// Signed-in user id when available.
  final String? userId;

  /// Active locale code when available (e.g. `en`).
  final String? locale;

  /// Host platform label when available (e.g. `android`, `ios`, `web`).
  final String? platform;

  final Map<String, Object?> _attributes;

  /// Additional opaque attributes (unmodifiable view).
  Map<String, Object?> get attributes =>
      Map<String, Object?>.unmodifiable(_attributes);
}
