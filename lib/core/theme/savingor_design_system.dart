import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:savingor_app/core/theme/savingor_theme_extension.dart';

export 'package:savingor_app/core/theme/savingor_theme_extension.dart';

/// Savingor brand palette — brand accents stay constant across themes.
abstract final class SavingorColors {
  /// Primary actions — premium fresh green (softened, not neon).
  static const Color primaryGreen = Color(0xFF7BC96E);

  /// Deep green for primary button labels on green fills.
  static const Color darkGreen = Color(0xFF166534);

  /// Rich saturated green for branded greetings.
  static const Color deepGreen = Color(0xFF14532D);

  /// Natural stroke on primary buttons and branded titles (light mode).
  static const Color primaryStroke = Color(0xFF4F9D47);

  /// Warm gold for savings highlights.
  static const Color goldAccent = Color(0xFFC9A052);

  /// Soft green wash for selected rows, chips, highlights (light).
  static const Color lightGreen = Color(0xFFECFDF5);

  /// Secondary mint tint for surfaces.
  static const Color mint = Color(0xFFD1FAE5);

  /// Legacy light tokens — prefer [BuildContext.savingor] in widgets.
  static const Color background = Color(0xFFFAFAF7);
  static const Color card = Colors.white;
  static const Color textPrimary = Color(0xFF111827);
  static const Color textSecondary = Color(0xFF64748B);
  static const Color border = Color(0xFFE5E7EB);
  static const Color pageWhite = Color(0xFFFAFAF7);

  // --- Onboarding — approved portfolio palette ---
  static const Color onboardingSubtitleDeep = Color(0xFF02180E);
  static const Color onboardingDotActive = Color(0xFF4FAF48);
}

/// Feature accent colors — semantic; unchanged across themes.
abstract final class SavingorAccentColors {
  static const Color expenses = Color(0xFFEF4444);
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
  static List<BoxShadow> soft(BuildContext context) =>
      context.savingor.cardShadow;

  static const List<BoxShadow> medium = <BoxShadow>[
    BoxShadow(
      color: Color(0x14000000),
      blurRadius: 18,
      offset: Offset(0, 8),
    ),
  ];
}

abstract final class SavingorTextStyles {
  static const TextStyle onboardingTitle = TextStyle(
    color: SavingorColors.darkGreen,
    fontWeight: FontWeight.w900,
    fontSize: 31,
    height: 1.14,
    letterSpacing: 0.3,
  );

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
  static TextStyle screenTitle(BuildContext context) => TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.w800,
        color: context.savingor.brandTitle,
        letterSpacing: -0.2,
      );

  static TextStyle pageTitle(BuildContext context) => TextStyle(
        fontSize: 28,
        fontWeight: FontWeight.w800,
        color: context.savingor.brandTitle,
        height: 1.1,
        letterSpacing: -0.4,
      );

  static TextStyle greetingTitle(BuildContext context) => TextStyle(
        fontSize: 28,
        fontWeight: FontWeight.w800,
        color: context.savingor.brandTitle,
        height: 1.1,
        letterSpacing: -0.4,
      );

  static TextStyle sectionTitle(BuildContext context) => TextStyle(
        fontSize: 17,
        fontWeight: FontWeight.w700,
        color: context.savingor.textPrimary,
      );

  static TextStyle sectionTitleLarge(BuildContext context) => TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.w800,
        color: context.savingor.textPrimary,
      );

  static TextStyle cardTitle(BuildContext context) => TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w700,
        color: context.savingor.textPrimary,
        height: 1.2,
      );

  static TextStyle bodySecondary(BuildContext context, {double fontSize = 14}) {
    return TextStyle(
      fontSize: fontSize,
      fontWeight: FontWeight.w500,
      color: context.savingor.textSecondary,
      height: 1.35,
    );
  }

  /// Legacy const styles for gradual migration — light appearance only.
  static const TextStyle screenTitleLegacy = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.w800,
    color: SavingorColors.primaryStroke,
    letterSpacing: -0.2,
  );
}

/// Reusable card chrome — theme-aware surfaces.
abstract final class SavingorSurfaces {
  static BoxDecoration premiumCard(
    BuildContext context, {
    double radius = 18,
    Color? borderColor,
  }) {
    final SavingorThemeExtension t = context.savingor;
    final Color cardColor = t.isDark ? t.surfaceElevated : t.surfacePrimary;
    return BoxDecoration(
      color: cardColor,
      borderRadius: BorderRadius.circular(radius),
      border: Border.all(
        color: (borderColor ?? t.border).withOpacity(t.isDark ? 0.95 : 0.65),
        width: 0.5,
      ),
      boxShadow: t.cardShadow,
    );
  }

  /// Hero card for main tabs — light keeps approved gradient; dark uses elevated surface.
  static BoxDecoration tabHeroCard(
    BuildContext context, {
    double radius = 22,
    List<Color>? lightGradientColors,
  }) {
    final SavingorThemeExtension t = context.savingor;
    if (t.isDark) {
      return BoxDecoration(
        color: t.surfaceStrong,
        borderRadius: BorderRadius.circular(radius),
        border: Border.all(color: t.border, width: 0.75),
        boxShadow: t.cardShadow,
      );
    }
    final List<Color> colors = lightGradientColors ??
        const <Color>[
          Color(0xFFF2FAF4),
          Color(0xFFFAFAF5),
        ];
    return BoxDecoration(
      borderRadius: BorderRadius.circular(radius),
      gradient: LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: colors,
      ),
      border: Border.all(
        color: SavingorColors.primaryStroke.withOpacity(0.14),
        width: 0.75,
      ),
      boxShadow: const <BoxShadow>[
        BoxShadow(
          color: Color(0x0F4F9D47),
          blurRadius: 20,
          offset: Offset(0, 7),
        ),
        BoxShadow(
          color: Color(0x06000000),
          blurRadius: 8,
          offset: Offset(0, 2),
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

  static BoxDecoration profileHero(BuildContext context, {double radius = 28}) {
    final SavingorThemeExtension t = context.savingor;
    return BoxDecoration(
      borderRadius: BorderRadius.circular(radius),
      gradient: LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: <Color>[
          t.heroGradientStart,
          t.heroGradientMid,
          t.heroGradientEnd,
        ],
      ),
      border: Border.all(color: t.border.withOpacity(0.55)),
      boxShadow: t.cardShadow,
    );
  }

  static BoxDecoration aiHero(BuildContext context, {double radius = 20}) {
    final SavingorThemeExtension t = context.savingor;
    return BoxDecoration(
      borderRadius: BorderRadius.circular(radius),
      gradient: LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: <Color>[t.aiHeroStart, t.aiHeroMid, t.aiHeroEnd],
      ),
      border: Border.all(color: t.border.withOpacity(0.5)),
      boxShadow: t.cardShadow,
    );
  }

  static BoxDecoration locationCard(BuildContext context,
      {double radius = 18}) {
    final SavingorThemeExtension t = context.savingor;
    return BoxDecoration(
      borderRadius: BorderRadius.circular(radius),
      color: t.isDark ? t.surfaceElevated : t.surfacePrimary,
      border: Border.all(color: t.border.withOpacity(0.85)),
      boxShadow: t.cardShadow,
    );
  }
}

/// Theme-aware helpers for Start Saving workflow screens — light values unchanged.
abstract final class SavingorWorkflowTheme {
  static Color primaryText(BuildContext context) => context.savingor.isDark
      ? context.savingor.textPrimary
      : SavingorColors.darkGreen;

  static Color accentText(BuildContext context) => context.savingor.isDark
      ? context.savingor.brandTitle
      : SavingorColors.primaryStroke;

  static Color headingText(BuildContext context) => context.savingor.isDark
      ? context.savingor.textPrimary
      : SavingorColors.darkGreen;

  static Color appBarIcon(BuildContext context) => context.savingor.isDark
      ? context.savingor.textPrimary
      : SavingorColors.darkGreen;

  static Color inputFill(BuildContext context) =>
      context.savingor.isDark ? context.savingor.inputFill : Colors.white;

  static Color inputBorder(BuildContext context) => context.savingor.isDark
      ? context.savingor.border
      : const Color(0xFFF3F4F3);

  static Color progressTrack(BuildContext context) => context.savingor.isDark
      ? context.savingor.ringTrack
      : const Color(0xFFF0F2F1);

  static Color errorText(BuildContext context) => context.savingor.isDark
      ? context.savingor.error
      : const Color(0xFFB91C1C);

  static Color overBudget(BuildContext context) => context.savingor.isDark
      ? context.savingor.error
      : const Color(0xFFEF4444);

  static Color progressValue(BuildContext context, {required bool isOver}) {
    if (isOver) return overBudget(context);
    return context.savingor.isDark
        ? context.savingor.accentGreen
        : SavingorColors.primaryGreen;
  }

  static BoxDecoration card(BuildContext context, {double radius = 18}) =>
      SavingorSurfaces.premiumCard(context, radius: radius);

  static BoxDecoration highlightCard(BuildContext context,
      {double radius = 18}) {
    final SavingorThemeExtension t = context.savingor;
    if (t.isDark) {
      return BoxDecoration(
        color: t.surfaceElevated,
        borderRadius: BorderRadius.circular(radius),
        border: Border.all(color: t.border.withOpacity(0.85)),
        boxShadow: t.cardShadow,
      );
    }
    return BoxDecoration(
      color: SavingorColors.lightGreen.withOpacity(0.35),
      borderRadius: BorderRadius.circular(radius),
      border: Border.all(
        color: const Color(0xFFF3F4F3).withOpacity(0.6),
        width: 0.5,
      ),
    );
  }

  static InputDecoration fieldDecoration(
    BuildContext context, {
    required String label,
    Widget? suffixIcon,
    String? prefixText,
  }) {
    final SavingorThemeExtension t = context.savingor;
    final Color border = inputBorder(context);
    final Color focusBorder =
        t.isDark ? t.accentGreen : SavingorColors.primaryStroke;
    return InputDecoration(
      labelText: label,
      prefixText: prefixText,
      suffixIcon: suffixIcon,
      labelStyle: TextStyle(
        color: t.textSecondary.withOpacity(0.95),
        fontWeight: FontWeight.w500,
      ),
      filled: true,
      fillColor: inputFill(context),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide(color: border.withOpacity(0.9)),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide(color: border.withOpacity(0.9)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide(color: focusBorder, width: 1.2),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide(color: errorText(context)),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide(color: errorText(context), width: 1.2),
      ),
    );
  }
}

abstract final class SavingorButtonStyles {
  static ButtonStyle primaryFilled() {
    return _legacyPrimaryFilled();
  }

  static ButtonStyle primaryFilledFor(BuildContext context) {
    final SavingorThemeExtension t = context.savingor;
    if (!t.isDark) {
      return _legacyPrimaryFilled();
    }
    return FilledButton.styleFrom(
      backgroundColor: t.accentGreen,
      foregroundColor: t.buttonLabelOnGreen,
      elevation: 0,
      shadowColor: Colors.transparent,
      minimumSize: const Size.fromHeight(56),
      side: BorderSide(color: t.accentGreen.withOpacity(0.35)),
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

  static ButtonStyle _legacyPrimaryFilled() {
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

  static ButtonStyle secondaryOutlined(BuildContext context) {
    final SavingorThemeExtension t = context.savingor;
    return OutlinedButton.styleFrom(
      foregroundColor: t.brandHeading,
      backgroundColor: t.surfacePrimary,
      elevation: 0,
      minimumSize: const Size.fromHeight(52),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      side: BorderSide(color: t.border.withOpacity(0.9)),
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
  static ThemeData get lightTheme => _buildTheme(SavingorThemeExtension.light);

  static ThemeData get darkTheme => _buildTheme(SavingorThemeExtension.dark);

  static ThemeMode themeModeForAppearance(String appearance) {
    return appearance == 'dark' ? ThemeMode.dark : ThemeMode.light;
  }

  static void applySystemUiOverlay(ThemeMode mode) {
    SystemChrome.setSystemUIOverlayStyle(systemUiOverlayStyle(mode));
  }

  static SystemUiOverlayStyle systemUiOverlayStyle(ThemeMode mode) {
    final bool isDark = mode == ThemeMode.dark;
    final SavingorThemeExtension tokens =
        isDark ? SavingorThemeExtension.dark : SavingorThemeExtension.light;
    return SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: isDark ? Brightness.light : Brightness.dark,
      statusBarBrightness: isDark ? Brightness.dark : Brightness.light,
      systemNavigationBarColor: tokens.pageBackground,
      systemNavigationBarDividerColor: tokens.pageBackground,
      systemNavigationBarIconBrightness:
          isDark ? Brightness.light : Brightness.dark,
      systemNavigationBarContrastEnforced: false,
    );
  }

  static ThemeData _buildTheme(SavingorThemeExtension tokens) {
    final bool isDark = tokens.isDark;
    final ColorScheme scheme = ColorScheme.fromSeed(
      seedColor: SavingorColors.primaryGreen,
      brightness: isDark ? Brightness.dark : Brightness.light,
    ).copyWith(
      primary: tokens.accentGreen,
      onPrimary: tokens.buttonLabelOnGreen,
      primaryContainer:
          isDark ? const Color(0xFF243528) : SavingorColors.lightGreen,
      onPrimaryContainer:
          isDark ? tokens.brandHeading : SavingorColors.darkGreen,
      secondary: SavingorColors.goldAccent,
      onSecondary: const Color(0xFF3D2E12),
      secondaryContainer:
          isDark ? const Color(0xFF2A2820) : SavingorColors.mint,
      onSecondaryContainer:
          isDark ? tokens.textPrimary : SavingorColors.darkGreen,
      surface: tokens.surfacePrimary,
      onSurface: tokens.textPrimary,
      surfaceContainerHighest: tokens.surfaceElevated,
      onSurfaceVariant: tokens.textSecondary,
      outline: tokens.border,
      outlineVariant: tokens.divider,
      error: tokens.error,
      onError: Colors.white,
    );

    final InputDecorationTheme inputTheme = InputDecorationTheme(
      filled: true,
      fillColor: tokens.inputFill,
      hintStyle: TextStyle(
        color: tokens.textMuted,
        fontWeight: FontWeight.w500,
      ),
      labelStyle: TextStyle(
        color: tokens.textSecondary,
        fontWeight: FontWeight.w600,
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 13),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide(color: tokens.border.withOpacity(0.9)),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide(color: tokens.border.withOpacity(0.9)),
      ),
      disabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide(color: tokens.border.withOpacity(0.6)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide(
          color: SavingorColors.primaryStroke.withOpacity(0.55),
          width: 1.25,
        ),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide(color: tokens.error.withOpacity(0.85)),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide(color: tokens.error, width: 1.25),
      ),
    );

    return ThemeData(
      useMaterial3: true,
      brightness: isDark ? Brightness.dark : Brightness.light,
      colorScheme: scheme,
      scaffoldBackgroundColor: tokens.pageBackground,
      canvasColor: tokens.pageBackground,
      dividerColor: tokens.divider,
      disabledColor: tokens.disabledText,
      splashColor: SavingorColors.primaryGreen.withOpacity(0.12),
      highlightColor: SavingorColors.primaryGreen.withOpacity(0.08),
      extensions: <ThemeExtension<dynamic>>[tokens],
      appBarTheme: AppBarTheme(
        elevation: 0,
        scrolledUnderElevation: 0,
        backgroundColor: tokens.pageBackground,
        surfaceTintColor: Colors.transparent,
        foregroundColor: tokens.brandTitle,
        iconTheme: IconThemeData(color: tokens.brandTitle),
        titleTextStyle: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w800,
          color: tokens.brandTitle,
          letterSpacing: -0.2,
        ),
      ),
      cardTheme: CardTheme(
        color: tokens.surfacePrimary,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(SavingorRadius.lg),
          side: BorderSide(color: tokens.border.withOpacity(0.65), width: 0.5),
        ),
        shadowColor: Colors.black.withOpacity(isDark ? 0.4 : 0.06),
      ),
      dialogTheme: DialogTheme(
        backgroundColor: tokens.surfacePrimary,
        surfaceTintColor: Colors.transparent,
        elevation: isDark ? 8 : 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(22),
        ),
        titleTextStyle: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w800,
          color: tokens.brandHeading,
        ),
        contentTextStyle: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w500,
          color: tokens.textSecondary,
          height: 1.45,
        ),
      ),
      bottomSheetTheme: BottomSheetThemeData(
        backgroundColor: tokens.surfacePrimary,
        surfaceTintColor: Colors.transparent,
        modalBackgroundColor: tokens.surfacePrimary,
        modalBarrierColor: tokens.modalBarrier,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(26)),
        ),
      ),
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: tokens.navBarSurface,
        indicatorColor: tokens.selectedHighlight,
        labelTextStyle: WidgetStateProperty.resolveWith<TextStyle?>(
          (Set<WidgetState> states) {
            final bool selected = states.contains(WidgetState.selected);
            return TextStyle(
              fontSize: 11,
              fontWeight: selected ? FontWeight.w800 : FontWeight.w600,
              color: selected ? tokens.brandHeading : tokens.textSecondary,
            );
          },
        ),
        iconTheme: WidgetStateProperty.resolveWith<IconThemeData?>(
          (Set<WidgetState> states) {
            final bool selected = states.contains(WidgetState.selected);
            return IconThemeData(
              color: selected ? tokens.brandHeading : tokens.textSecondary,
              size: selected ? 24 : 22,
            );
          },
        ),
      ),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: isDark ? tokens.pageBackground : tokens.navBarSurface,
        selectedItemColor: tokens.brandHeading,
        unselectedItemColor: tokens.textSecondary,
        type: BottomNavigationBarType.fixed,
        elevation: 0,
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: tokens.accentGreen,
          foregroundColor: tokens.buttonLabelOnGreen,
          elevation: 0,
          shadowColor: Colors.transparent,
          minimumSize: const Size.fromHeight(56),
          side: BorderSide(
            color: tokens.isDark
                ? tokens.accentGreen.withOpacity(0.45)
                : SavingorColors.primaryStroke,
            width: 1,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(SavingorRadius.xl),
          ),
          textStyle: const TextStyle(
            fontWeight: FontWeight.w600,
            letterSpacing: 0.15,
            fontSize: 16,
          ),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: SavingorButtonStyles.primaryElevated(),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: tokens.brandHeading,
          backgroundColor: tokens.surfacePrimary,
          side: BorderSide(color: tokens.border.withOpacity(0.9)),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(SavingorRadius.xl),
          ),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: tokens.brandHeading,
        ),
      ),
      inputDecorationTheme: inputTheme,
      snackBarTheme: SnackBarThemeData(
        backgroundColor:
            isDark ? tokens.surfaceElevated : const Color(0xFF1F2937),
        contentTextStyle: TextStyle(
          color: isDark ? tokens.textPrimary : Colors.white,
          fontWeight: FontWeight.w500,
        ),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      dividerTheme: DividerThemeData(
        color: tokens.divider.withOpacity(0.5),
        thickness: 1,
        space: 1,
      ),
      chipTheme: ChipThemeData(
        backgroundColor: tokens.surfaceSecondary,
        selectedColor: tokens.selectedHighlight,
        disabledColor: tokens.inputFillDisabled,
        labelStyle: TextStyle(
          color: tokens.textPrimary,
          fontWeight: FontWeight.w600,
        ),
        secondaryLabelStyle: TextStyle(color: tokens.textSecondary),
        side: BorderSide(color: tokens.border.withOpacity(0.65)),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(SavingorRadius.pill),
        ),
      ),
      listTileTheme: ListTileThemeData(
        iconColor: tokens.textSecondary,
        textColor: tokens.textPrimary,
        tileColor: tokens.surfacePrimary,
      ),
      iconTheme: IconThemeData(color: tokens.textSecondary),
      primaryIconTheme: IconThemeData(color: tokens.brandTitle),
      progressIndicatorTheme: const ProgressIndicatorThemeData(
        color: SavingorColors.primaryStroke,
      ),
      switchTheme: SwitchThemeData(
        thumbColor: WidgetStateProperty.resolveWith<Color?>(
          (Set<WidgetState> states) {
            if (states.contains(WidgetState.selected)) {
              return SavingorColors.primaryGreen;
            }
            return tokens.textMuted;
          },
        ),
        trackColor: WidgetStateProperty.resolveWith<Color?>(
          (Set<WidgetState> states) {
            if (states.contains(WidgetState.selected)) {
              return SavingorColors.primaryGreen.withOpacity(0.35);
            }
            return tokens.border;
          },
        ),
      ),
      checkboxTheme: CheckboxThemeData(
        fillColor: WidgetStateProperty.resolveWith<Color?>(
          (Set<WidgetState> states) {
            if (states.contains(WidgetState.selected)) {
              return SavingorColors.primaryGreen;
            }
            return tokens.surfacePrimary;
          },
        ),
        checkColor: WidgetStateProperty.all(SavingorColors.darkGreen),
        side: BorderSide(color: tokens.border),
      ),
      radioTheme: RadioThemeData(
        fillColor: WidgetStateProperty.resolveWith<Color?>(
          (Set<WidgetState> states) {
            if (states.contains(WidgetState.selected)) {
              return SavingorColors.primaryGreen;
            }
            return tokens.textMuted;
          },
        ),
      ),
      popupMenuTheme: PopupMenuThemeData(
        color: tokens.surfacePrimary,
        surfaceTintColor: Colors.transparent,
        textStyle: TextStyle(color: tokens.textPrimary),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14),
        ),
      ),
      tooltipTheme: TooltipThemeData(
        decoration: BoxDecoration(
          color: isDark ? tokens.surfaceElevated : const Color(0xFF1F2937),
          borderRadius: BorderRadius.circular(8),
        ),
        textStyle: TextStyle(
          color: isDark ? tokens.textPrimary : Colors.white,
          fontSize: 12,
        ),
      ),
      datePickerTheme: DatePickerThemeData(
        backgroundColor: tokens.surfacePrimary,
        headerBackgroundColor: SavingorColors.primaryGreen,
        headerForegroundColor: SavingorColors.darkGreen,
        dayForegroundColor: WidgetStateProperty.resolveWith<Color?>(
          (Set<WidgetState> states) {
            if (states.contains(WidgetState.selected)) {
              return SavingorColors.darkGreen;
            }
            return tokens.textPrimary;
          },
        ),
        dayBackgroundColor: WidgetStateProperty.resolveWith<Color?>(
          (Set<WidgetState> states) {
            if (states.contains(WidgetState.selected)) {
              return SavingorColors.primaryGreen;
            }
            return null;
          },
        ),
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
      textTheme: TextTheme(
        displayLarge: TextStyle(color: tokens.textPrimary),
        displayMedium: TextStyle(color: tokens.textPrimary),
        displaySmall: TextStyle(color: tokens.textPrimary),
        headlineLarge: TextStyle(color: tokens.textPrimary),
        headlineMedium: TextStyle(color: tokens.textPrimary),
        headlineSmall: TextStyle(
          color: tokens.textPrimary,
          fontWeight: FontWeight.w800,
        ),
        titleLarge: TextStyle(
          color: tokens.textPrimary,
          fontWeight: FontWeight.w700,
        ),
        titleMedium: TextStyle(
          color: tokens.textPrimary,
          fontWeight: FontWeight.w600,
        ),
        titleSmall: TextStyle(color: tokens.textPrimary),
        bodyLarge: TextStyle(color: tokens.textPrimary),
        bodyMedium: TextStyle(color: tokens.textPrimary),
        bodySmall: TextStyle(color: tokens.textSecondary),
        labelLarge: TextStyle(color: tokens.textPrimary),
        labelMedium: TextStyle(color: tokens.textSecondary),
        labelSmall: TextStyle(color: tokens.textMuted),
      ),
    );
  }
}
