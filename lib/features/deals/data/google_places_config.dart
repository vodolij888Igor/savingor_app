/// Runtime Google Places configuration via `--dart-define` (no secrets in source).
abstract final class GooglePlacesConfig {
  static const String apiKey = String.fromEnvironment('GOOGLE_PLACES_API_KEY');

  static bool get hasApiKey => apiKey.isNotEmpty;
}
