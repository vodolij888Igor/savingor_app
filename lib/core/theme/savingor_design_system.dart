import 'package:flutter/material.dart';

/// Savingor brand palette — aligned with approved onboarding CTA and grocery aesthetic.
abstract final class SavingorColors {
  /// Primary actions / soft CTA fill (approved onboarding button green).
  static const Color primaryGreen = Color(0xFF7BC96E);
  /// Primary button labels and strong readable green copy.
  static const Color darkGreen = Color(0xFF15803D);
  /// Natural stroke on primary buttons (leaf-toned, not mint-neon).
  static const Color primaryStroke = Color(0xFF4F9D47);
  /// Warm gold for “or” / savings accents — harvest tone, not neon.
  static const Color goldAccent = Color(0xFFC9A052);
  /// Soft green wash for selected rows, chips, highlights.
  static const Color lightGreen = Color(0xFFEEF6EC);
  /// Secondary mint tint for surfaces.
  static const Color mint = Color(0xFFE3EFE0);
  static const Color background = Color(0xFFF8FAF9);
  static const Color card = Colors.white;
  static const Color textPrimary = Color(0xFF111827);
  static const Color textSecondary = Color(0xFF6B7280);
  /// Clean neutral chrome.
  static const Color border = Color(0xFFE5E7EB);

  // --- Onboarding (slides 0–1) — approved portfolio palette; do not alter hex values casually ---
  /// Near-black subtitle on hero brand block & slide 2 — optimized for readability on photography.
  static const Color onboardingSubtitleDeep = Color(0xFF02180E);
  /// Active page-indicator dot on onboarding — warm apple / leaf green (approved).
  static const Color onboardingDotActive = Color(0xFF4FAF48);
}

abstract final class SavingorSpacing {
  static const double xs = 4;
  static const double sm = 8;
  static const double md = 12;
  static const double lg = 16;
  static const double xl = 20;
  static const double xxl = 24;
  static const double section = 32;
}

abstract final class SavingorRadius {
  static const double sm = 10;
  static const double md = 14;
  static const double lg = 18;
  static const double xl = 24;
  static const double pill = 999;
}

abstract final class SavingorShadows {
  static const List<BoxShadow> soft = <BoxShadow>[
    BoxShadow(
      color: Color(0x12000000),
      blurRadius: 12,
      offset: Offset(0, 4),
    ),
  ];

  static const List<BoxShadow> medium = <BoxShadow>[
    BoxShadow(
      color: Color(0x14000000),
      blurRadius: 18,
      offset: Offset(0, 8),
    ),
  ];
}

/// Shared typography for the startup, language, and onboarding flow.
///
/// One source of truth so every premium headline + companion subtitle in the
/// pre-auth surfaces (mini splash, language picker, onboarding PageView) stays
/// visually aligned. Inherits the app's default font family by design — assign
/// per-screen accents (shadows, max width, etc.) via [TextStyle.copyWith].
abstract final class SavingorTextStyles {
  /// Premium centered title used on the language screen and every onboarding
  /// slide that displays a textual headline. Heavy weight + slightly open
  /// tracking gives a strong, branded Savingor presence over any background.
  static const TextStyle onboardingTitle = TextStyle(
    color: SavingorColors.darkGreen,
    fontWeight: FontWeight.w900,
    fontSize: 31,
    height: 1.14,
    letterSpacing: 0.3,
  );

  /// Companion subtitle paired with [onboardingTitle]. Readable but not heavy
  /// enough to fight the title — preserves the hierarchy.
  static const TextStyle onboardingSubtitle = TextStyle(
    color: SavingorColors.onboardingSubtitleDeep,
    fontWeight: FontWeight.w600,
    fontSize: 16.5,
    height: 1.4,
    letterSpacing: 0.15,
  );
}

/// Primary [FilledButton] / [ElevatedButton] — soft green fill, dark green label, premium radius.
abstract final class SavingorButtonStyles {
  static ButtonStyle primaryFilled() {
    return FilledButton.styleFrom(
      backgroundColor: SavingorColors.primaryGreen,
      foregroundColor: SavingorColors.darkGreen,
      elevation: 0,
      shadowColor: Colors.transparent,
      minimumSize: const Size.fromHeight(56),
      side: const BorderSide(color: SavingorColors.primaryStroke, width: 1),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(SavingorRadius.xl),
      ),
      textStyle: const TextStyle(
        fontWeight: FontWeight.w600,
        letterSpacing: 0.15,
        fontSize: 16,
      ),
    );
  }

  static ButtonStyle primaryElevated() {
    return ElevatedButton.styleFrom(
      backgroundColor: SavingorColors.primaryGreen,
      foregroundColor: SavingorColors.darkGreen,
      elevation: 0,
      shadowColor: Colors.transparent,
      surfaceTintColor: Colors.transparent,
      minimumSize: const Size.fromHeight(56),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(SavingorRadius.xl),
        side: const BorderSide(color: SavingorColors.primaryStroke, width: 1),
      ),
      textStyle: const TextStyle(
        fontWeight: FontWeight.w600,
        fontSize: 16,
      ),
    );
  }
}

abstract final class SavingorTheme {
  static ThemeData get lightTheme {
    final scheme = ColorScheme.fromSeed(
      seedColor: SavingorColors.primaryGreen,
      brightness: Brightness.light,
    ).copyWith(
      primary: SavingorColors.primaryGreen,
      onPrimary: SavingorColors.darkGreen,
      primaryContainer: SavingorColors.lightGreen,
      onPrimaryContainer: SavingorColors.darkGreen,
      secondary: SavingorColors.goldAccent,
      onSecondary: const Color(0xFF3D2E12),
      secondaryContainer: SavingorColors.mint,
      onSecondaryContainer: SavingorColors.darkGreen,
      surface: SavingorColors.card,
      onSurface: SavingorColors.textPrimary,
      outline: SavingorColors.border,
    );

    return ThemeData(
      useMaterial3: true,
      colorScheme: scheme,
      scaffoldBackgroundColor: SavingorColors.background,
      filledButtonTheme: FilledButtonThemeData(
        style: SavingorButtonStyles.primaryFilled(),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: SavingorButtonStyles.primaryElevated(),
      ),
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: SavingorColors.primaryGreen,
        foregroundColor: SavingorColors.darkGreen,
        elevation: 2,
        focusElevation: 2,
        hoverElevation: 3,
        highlightElevation: 3,
        extendedTextStyle: TextStyle(
          fontWeight: FontWeight.w600,
          fontSize: 15,
          letterSpacing: 0.1,
        ),
      ),
    );
  }
}
