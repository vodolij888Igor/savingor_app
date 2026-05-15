import 'package:flutter/widgets.dart';

import 'package:savingor_app/core/app_state.dart';

/// Copy for mini-splash, language picker, onboarding carousel, and auth shell.
/// Brand name "Savingor" stays literal in UI where required — not a key here.
abstract final class StartupFlowStrings {
  static const List<String> supportedLanguageCodes = [
    'en',
    'uk',
    'ru',
    'fr',
    'de',
    'es',
  ];

  static String normalizeLanguageCode(String? code) {
    if (code == null || code.isEmpty) return 'en';
    final c = code.toLowerCase().trim();
    return supportedLanguageCodes.contains(c) ? c : 'en';
  }

  /// UI for the language picker before a choice exists (uses [uiLang] only).
  static String tPicker(String uiLang, String key) =>
      _stringFor(normalizeLanguageCode(uiLang), key);

  /// Strings after language is selected (reads [AppState.language]).
  static String tr(BuildContext context, String key) {
    final lang = normalizeLanguageCode(AppStateProvider.of(context).language);
    return _stringFor(lang, key);
  }

  static String forLang(String? code, String key) =>
      _stringFor(normalizeLanguageCode(code), key);

  static String _stringFor(String lang, String key) {
    final map = _byLang[lang] ?? _byLang['en']!;
    return map[key] ?? _byLang['en']![key] ?? key;
  }

  static const Map<String, Map<String, String>> _byLang = {
    'en': _en,
    'uk': _uk,
    'ru': _ru,
    'fr': _fr,
    'de': _de,
    'es': _es,
  };

  static const Map<String, String> _en = {
    'lang_title': 'Choose your language',
    'lang_subtitle': 'This helps personalize your Savingor experience.',
    'lang_continue': 'Continue',
    'hero_subtitle': 'Money Saved, Money Earned.',
    'slide1_title': 'Smart savings every day',
    'slide1_subtitle':
        'Find the best deals, track prices and save on every shop.',
    'slide2_title': 'Scan receipts, save smarter',
    'slide2_subtitle':
        'See where your money goes and discover better ways to save.',
    'slide3_title': 'Plan your shopping smarter',
    'slide3_subtitle':
        'Savingor helps you plan your shopping list and see where each item is better to buy.',
    'btn_next': 'Next',
    'btn_get_started': 'Get Started',
    'auth_welcome': 'Sign in or create account',
    'auth_subtitle': 'Save your purchases, lists, and savings.',
    'auth_email': 'Email',
    'auth_password': 'Password',
    'auth_login': 'Log in',
    'auth_google': 'Continue with Google',
    'auth_apple': 'Continue with Apple',
    'auth_guest': 'Continue as Guest',
    'auth_or': 'or',
    'auth_no_account': 'Don\u2019t have an account?',
    'auth_create_account': 'Create account',
  };

  static const Map<String, String> _uk = {
    'lang_title': 'Оберіть мову',
    'lang_subtitle': 'Це допоможе персоналізувати Savingor для вас.',
    'lang_continue': 'Далі',
    'hero_subtitle': 'Гроші збережені — гроші зароблені.',
    'slide1_title': 'Розумна економія щодня',
    'slide1_subtitle':
        'Знаходьте найкращі пропозиції, відстежуйте ціни й економте щоразу.',
    'slide2_title': 'Скануйте чеки — економте розумніше',
    'slide2_subtitle':
        'Бачте, куди йдуть гроші, і відкривайте кращі способи заощаджувати.',
    'slide3_title': 'Плануйте покупки розумніше',
    'slide3_subtitle':
        'Savingor допомагає скласти список і бачити, де вигідніше купити кожну річ.',
    'btn_next': 'Далі',
    'btn_get_started': 'Почати',
    'auth_welcome': 'Увійдіть або створіть акаунт',
    'auth_subtitle': 'Збережіть свої покупки, списки та економію.',
    'auth_email': 'Ел. пошта',
    'auth_password': 'Пароль',
    'auth_login': 'Увійти',
    'auth_google': 'Продовжити з Google',
    'auth_apple': 'Продовжити з Apple',
    'auth_guest': 'Продовжити як гість',
    'auth_or': 'або',
    'auth_no_account': 'Немає акаунта?',
    'auth_create_account': 'Створити акаунт',
  };

  static const Map<String, String> _ru = {
    'lang_title': 'Выберите язык',
    'lang_subtitle': 'Это поможет персонализировать Savingor для вас.',
    'lang_continue': 'Продолжить',
    'hero_subtitle': 'Деньги сэкономлены — деньги заработаны.',
    'slide1_title': 'Умная экономия каждый день',
    'slide1_subtitle':
        'Находите лучшие предложения, следите за ценами и экономьте при каждой покупке.',
    'slide2_title': 'Сканируйте чеки — экономьте умнее',
    'slide2_subtitle':
        'Смотрите, куда уходят деньги, и находите лучшие способы экономить.',
    'slide3_title': 'Планируйте покупки умнее',
    'slide3_subtitle':
        'Savingor помогает составить список и видеть, где выгоднее купить каждый товар.',
    'btn_next': 'Далее',
    'btn_get_started': 'Начать',
    'auth_welcome': 'Войдите или создайте аккаунт',
    'auth_subtitle': 'Сохраняйте покупки, списки и экономию.',
    'auth_email': 'Эл. почта',
    'auth_password': 'Пароль',
    'auth_login': 'Войти',
    'auth_google': 'Продолжить с Google',
    'auth_apple': 'Продолжить с Apple',
    'auth_guest': 'Продолжить как гость',
    'auth_or': 'или',
    'auth_no_account': 'Нет аккаунта?',
    'auth_create_account': 'Создать аккаунт',
  };

  static const Map<String, String> _fr = {
    'lang_title': 'Choisissez votre langue',
    'lang_subtitle': 'Cela personnalise votre expérience Savingor.',
    'lang_continue': 'Continuer',
    'hero_subtitle': 'Argent épargné, argent gagné.',
    'slide1_title': 'Économies intelligentes au quotidien',
    'slide1_subtitle':
        'Trouvez les meilleures offres, suivez les prix et économisez à chaque achat.',
    'slide2_title': 'Scannez vos tickets, économisez plus malin',
    'slide2_subtitle':
        'Voyez où va votre argent et découvrez de meilleures façons d’économiser.',
    'slide3_title': 'Planifiez vos courses plus intelligemment',
    'slide3_subtitle':
        'Savingor vous aide à préparer votre liste et à voir où chaque article est le plus avantageux.',
    'btn_next': 'Suivant',
    'btn_get_started': 'Commencer',
    'auth_welcome': 'Connectez-vous ou créez un compte',
    'auth_subtitle': 'Enregistrez vos achats, listes et économies.',
    'auth_email': 'E-mail',
    'auth_password': 'Mot de passe',
    'auth_login': 'Se connecter',
    'auth_google': 'Continuer avec Google',
    'auth_apple': 'Continuer avec Apple',
    'auth_guest': 'Continuer en invité',
    'auth_or': 'ou',
    'auth_no_account': 'Pas encore de compte\u00A0?',
    'auth_create_account': 'Créer un compte',
  };

  static const Map<String, String> _de = {
    'lang_title': 'Sprache wählen',
    'lang_subtitle': 'So personalisieren wir Savingor für Sie.',
    'lang_continue': 'Weiter',
    'hero_subtitle': 'Geld gespart, Geld verdient.',
    'slide1_title': 'Jeden Tag clever sparen',
    'slide1_subtitle':
        'Finden Sie die besten Angebote, verfolgen Sie Preise und sparen Sie beim Einkauf.',
    'slide2_title': 'Belege scannen, smarter sparen',
    'slide2_subtitle':
        'Sehen Sie, wohin Ihr Geld fließt, und entdecken Sie bessere Sparwege.',
    'slide3_title': 'Einkäufe smarter planen',
    'slide3_subtitle':
        'Savingor hilft Ihnen bei der Einkaufsliste und zeigt, wo sich jedes Produkt am besten kauft.',
    'btn_next': 'Weiter',
    'btn_get_started': 'Loslegen',
    'auth_welcome': 'Einloggen oder Konto erstellen',
    'auth_subtitle': 'Speichern Sie Ihre Einkäufe, Listen und Ersparnisse.',
    'auth_email': 'E-Mail',
    'auth_password': 'Passwort',
    'auth_login': 'Anmelden',
    'auth_google': 'Mit Google fortfahren',
    'auth_apple': 'Mit Apple fortfahren',
    'auth_guest': 'Als Gast fortfahren',
    'auth_or': 'oder',
    'auth_no_account': 'Noch kein Konto?',
    'auth_create_account': 'Konto erstellen',
  };

  static const Map<String, String> _es = {
    'lang_title': 'Elige tu idioma',
    'lang_subtitle': 'Así personalizamos Savingor para ti.',
    'lang_continue': 'Continuar',
    'hero_subtitle': 'Dinero ahorrado, dinero ganado.',
    'slide1_title': 'Ahorro inteligente cada día',
    'slide1_subtitle':
        'Encuentra las mejores ofertas, sigue precios y ahorra en cada compra.',
    'slide2_title': 'Escanea tickets y ahorra con más cabeza',
    'slide2_subtitle':
        'Mira a dónde va tu dinero y descubre mejores formas de ahorrar.',
    'slide3_title': 'Planifica tus compras con más inteligencia',
    'slide3_subtitle':
        'Savingor te ayuda con la lista y a ver dónde conviene más comprar cada artículo.',
    'btn_next': 'Siguiente',
    'btn_get_started': 'Empezar',
    'auth_welcome': 'Inicia sesión o crea una cuenta',
    'auth_subtitle': 'Guarda tus compras, listas y ahorros.',
    'auth_email': 'Correo',
    'auth_password': 'Contraseña',
    'auth_login': 'Iniciar sesión',
    'auth_google': 'Continuar con Google',
    'auth_apple': 'Continuar con Apple',
    'auth_guest': 'Continuar como invitado',
    'auth_or': 'o',
    'auth_no_account': '¿No tienes cuenta?',
    'auth_create_account': 'Crear cuenta',
  };
}
