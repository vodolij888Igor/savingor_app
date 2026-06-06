/// Normalizes product names for price memory and future comparison.
abstract final class ProductNameNormalizer {
  static String normalize(String raw) {
    String normalized = raw.trim().toLowerCase();
    normalized = normalized.replaceAll(RegExp(r'\s+'), ' ');
    normalized = normalized.replaceAll(RegExp(r"[^\w\s%./-]"), '');
    return normalized.trim();
  }
}
