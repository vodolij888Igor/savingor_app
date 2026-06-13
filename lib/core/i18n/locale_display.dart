/// Visible language badge labels (distinct from internal locale codes).
abstract final class LocaleDisplay {
  static String languageBadge(String? code) {
    switch (code?.trim().toLowerCase()) {
      case 'uk':
        return 'UA';
      case 'ru':
        return 'RU';
      case 'fr':
        return 'FR';
      case 'de':
        return 'DE';
      case 'es':
        return 'ES';
      case 'en':
        return 'EN';
      default:
        return 'EN';
    }
  }
}
