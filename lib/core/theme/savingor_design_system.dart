import 'package:flutter/material.dart';

/// Savingor brand palette — fresh grocery + smart savings aesthetic.
abstract final class SavingorColors {
  /// Primary actions — premium fresh green (softened, not neon).
  static const Color primaryGreen = Color(0xFF7BC96E);
  /// Deep green for important headings and primary button labels.
  static const Color darkGreen = Color(0xFF166534);
  /// Rich saturated green for branded greetings.
  static const Color deepGreen = Color(0xFF14532D);
  /// Natural stroke on primary buttons and branded titles.
  static const Color primaryStroke = Color(0xFF4F9D47);
  /// Warm gold for savings highlights.
  static const Color goldAccent = Color(0xFFC9A052);
  /// Soft green wash for selected rows, chips, highlights.
  static const Color lightGreen = Color(0xFFECFDF5);
  /// Secondary mint tint for surfaces.
  static const Color mint = Color(0xFFD1FAE5);
  /// Warm off-white app background.
  static const Color background = Color(0xFFFAFAF7);
  static const Color card = Colors.white;
  static const Color textPrimary = Color(0xFF111827);
  static const Color textSecondary = Color(0xFF64748B);
  static const Color border = Color(0xFFE5E7EB);
  /// Premium screen background — warm light white.
  static const Color pageWhite = Color(0xFFFAFAF7);

  // --- Onboarding (slides 0–1) — approved portfolio palette; do not alter hex values casually ---
  /// Near-black subtitle on hero brand block & slide 2 — optimized for readability on photography.
  static const Color onboardingSubtitleDeep = Color(0xFF02180E);
  /// Active page-indicator dot on onboarding — warm apple / leaf green (approved).
  static const Color onboardingDotActive = Color(0xFF4FAF48);
}

/// Feature accent colors — use sparingly on icons, badges, and small highlights.
abstract final class SavingorAccentColors {
  static const Color expenses = Color(0xFFEF4444);
  /// Map / stores — teal-green, not blue.
  static const Color map = Color(0xFF14B8A6);
  static const Color ai = Color(0xFF8B5CF6);
  static const Color savings = Color(0xFF4F9D47);
  static const Color budget = Color(0xFFF59E0B);
  static const Color priceMemory = Color(0xFF0D9488);
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

/// Shared typography for in-app surfaces (post-onboarding).
abstract final class SavingorAppTextStyles {
  /// App bar / compact main screen title — strong brand green.
  static const TextStyle screenTitle = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.w800,
    color: SavingorColors.primaryStroke,
    letterSpacing: -0.2,
  );

  /// Large in-body main screen title — matches dashboard greeting green.
  static const TextStyle pageTitle = TextStyle(
    fontSize: 28,
    fontWeight: FontWeight.w800,
    color: SavingorColors.primaryStroke,
    height: 1.1,
    letterSpacing: -0.4,
  );

  /// Dashboard greeting — rich saturated brand green.
  static const TextStyle greetingTitle = TextStyle(
    fontSize: 28,
    fontWeight: FontWeight.w800,
    color: SavingorColors.primaryStroke,
    height: 1.1,
    letterSpacing: -0.4,
  );

  static const TextStyle sectionTitle = TextStyle(
    fontSize: 17,
    fontWeight: FontWeight.w700,
    color: SavingorColors.textPrimary,
  );

  static const TextStyle sectionTitleLarge = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.w800,
    color: SavingorColors.textPrimary,
  );

  static const TextStyle cardTitle = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w700,
    color: SavingorColors.textPrimary,
    height: 1.2,
  );

  static TextStyle bodySecondary({double fontSize = 14}) {
    return TextStyle(
      fontSize: fontSize,
      fontWeight: FontWeight.w500,
      color: SavingorColors.textSecondary,
      height: 1.35,
    );
  }
}

/// Reusable card chrome for premium white surfaces.
abstract final class SavingorSurfaces {
  static BoxDecoration premiumCard({
    double radius = 18,
    Color borderColor = SavingorColors.border,
  }) {
    return BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(radius),
      border: Border.all(color: borderColor.withOpacity(0.65), width: 0.5),
      boxShadow: const <BoxShadow>[
        BoxShadow(
          color: Color(0x0A000000),
          blurRadius: 12,
          offset: Offset(0, 3),
        ),
      ],
    );
  }

  static BoxDecoration accentIconBlock({
    required Color accent,
    double radius = 14,
  }) {
    return BoxDecoration(
      color: accent.withOpacity(0.12),
      borderRadius: BorderRadius.circular(radius),
    );
  }

  /// Soft green gradient for profile / hero cards.
  static BoxDecoration profileHero({double radius = 28}) {
    return BoxDecoration(
      borderRadius: BorderRadius.circular(radius),
      gradient: const LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: <Color>[
          Color(0xFFECFDF5),
          Color(0xFFF0FDF4),
          Color(0xFFFAFAF7),
        ],
      ),
      border: Border.all(color: SavingorColors.border.withOpacity(0.55)),
      boxShadow: const <BoxShadow>[
        BoxShadow(
          color: Color(0x0D16A34A),
          blurRadius: 20,
          offset: Offset(0, 8),
        ),
      ],
    );
  }

  /// AI assistant hero — light green + light purple wash.
  static BoxDecoration aiHero({double radius = 20}) {
    return BoxDecoration(
      borderRadius: BorderRadius.circular(radius),
      gradient: const LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: <Color>[
          Color(0xFFF5F3FF),
          Color(0xFFECFDF5),
          Color(0xFFFAFAF7),
        ],
      ),
      border: Border.all(color: SavingorColors.border.withOpacity(0.5)),
      boxShadow: const <BoxShadow>[
        BoxShadow(
          color: Color(0x0A000000),
          blurRadius: 14,
          offset: Offset(0, 4),
        ),
      ],
    );
  }

  /// Location card with soft teal-green tint.
  static BoxDecoration locationCard({double radius = 18}) {
    return BoxDecoration(
      borderRadius: BorderRadius.circular(radius),
      color: Colors.white,
      border: Border.all(color: SavingorColors.border.withOpacity(0.65)),
      boxShadow: const <BoxShadow>[
        BoxShadow(
          color: Color(0x0A14B8A6),
          blurRadius: 14,
          offset: Offset(0, 4),
        ),
      ],
    );
  }
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

  /// Secondary actions on profile/settings surfaces — outlined, calm chrome.
  static ButtonStyle secondaryOutlined() {
    return OutlinedButton.styleFrom(
      foregroundColor: SavingorColors.darkGreen,
      backgroundColor: SavingorColors.card,
      elevation: 0,
      minimumSize: const Size.fromHeight(52),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      side: BorderSide(color: SavingorColors.border.withOpacity(0.9)),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(SavingorRadius.xl),
      ),
      textStyle: const TextStyle(
        fontWeight: FontWeight.w600,
        fontSize: 15,
        letterSpacing: 0.1,
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
