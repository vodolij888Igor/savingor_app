import 'package:flutter/material.dart';

/// Semantic theme tokens for Savingor — use via [BuildContext.savingor].
@immutable
class SavingorThemeExtension extends ThemeExtension<SavingorThemeExtension> {
  const SavingorThemeExtension({
    required this.pageBackground,
    required this.surfacePrimary,
    required this.surfaceSecondary,
    required this.surfaceElevated,
    required this.surfaceStrong,
    required this.navBarSurface,
    required this.navBarBorder,
    required this.textPrimary,
    required this.textSecondary,
    required this.textMuted,
    required this.brandTitle,
    required this.brandHeading,
    required this.accentGreen,
    required this.buttonLabelOnGreen,
    required this.border,
    required this.divider,
    required this.inputFill,
    required this.inputFillDisabled,
    required this.disabledText,
    required this.selectedHighlight,
    required this.hoverHighlight,
    required this.pressedHighlight,
    required this.ringTrack,
    required this.chipSurface,
    required this.warningSurface,
    required this.errorSurface,
    required this.cardShadow,
    required this.modalBarrier,
    required this.error,
    required this.warning,
    required this.success,
    required this.destructive,
    required this.heroGradientStart,
    required this.heroGradientMid,
    required this.heroGradientEnd,
    required this.aiHeroStart,
    required this.aiHeroMid,
    required this.aiHeroEnd,
    required this.isDark,
  });

  final Color pageBackground;
  final Color surfacePrimary;
  final Color surfaceSecondary;
  final Color surfaceElevated;
  final Color surfaceStrong;
  final Color navBarSurface;
  final Color navBarBorder;
  final Color textPrimary;
  final Color textSecondary;
  final Color textMuted;
  final Color brandTitle;
  final Color brandHeading;
  final Color accentGreen;
  final Color buttonLabelOnGreen;
  final Color border;
  final Color divider;
  final Color inputFill;
  final Color inputFillDisabled;
  final Color disabledText;
  final Color selectedHighlight;
  final Color hoverHighlight;
  final Color pressedHighlight;
  final Color ringTrack;
  final Color chipSurface;
  final Color warningSurface;
  final Color errorSurface;
  final List<BoxShadow> cardShadow;
  final Color modalBarrier;
  final Color error;
  final Color warning;
  final Color success;
  final Color destructive;
  final Color heroGradientStart;
  final Color heroGradientMid;
  final Color heroGradientEnd;
  final Color aiHeroStart;
  final Color aiHeroMid;
  final Color aiHeroEnd;
  final bool isDark;

  static const SavingorThemeExtension light = SavingorThemeExtension(
    pageBackground: Color(0xFFFAFAF7),
    surfacePrimary: Colors.white,
    surfaceSecondary: Color(0xFFFAFAF7),
    surfaceElevated: Colors.white,
    surfaceStrong: Colors.white,
    navBarSurface: Color(0xFFFFFEFE),
    navBarBorder: Color(0xFFEEF1EF),
    textPrimary: Color(0xFF111827),
    textSecondary: Color(0xFF64748B),
    textMuted: Color(0xFF94A3B8),
    brandTitle: Color(0xFF4F9D47),
    brandHeading: Color(0xFF166534),
    accentGreen: Color(0xFF7BC96E),
    buttonLabelOnGreen: Color(0xFF166534),
    border: Color(0xFFE5E7EB),
    divider: Color(0xFFE5E7EB),
    inputFill: Colors.white,
    inputFillDisabled: Color(0xFFF6F7F6),
    disabledText: Color(0xFF94A3B8),
    selectedHighlight: Color(0xFFECFDF5),
    hoverHighlight: Color(0xFFF0FDF4),
    pressedHighlight: Color(0xFFD1FAE5),
    ringTrack: Color(0xFFF3F5F4),
    chipSurface: Colors.white,
    warningSurface: Color(0xFFFFFAF3),
    errorSurface: Color(0xFFFFF5F5),
    cardShadow: <BoxShadow>[
      BoxShadow(
        color: Color(0x0A000000),
        blurRadius: 12,
        offset: Offset(0, 3),
      ),
    ],
    modalBarrier: Color(0x99000000),
    error: Color(0xFFDC2626),
    warning: Color(0xFFF59E0B),
    success: Color(0xFF4F9D47),
    destructive: Color(0xFFB42318),
    heroGradientStart: Color(0xFFECFDF5),
    heroGradientMid: Color(0xFFF0FDF4),
    heroGradientEnd: Color(0xFFFAFAF7),
    aiHeroStart: Color(0xFFF5F3FF),
    aiHeroMid: Color(0xFFECFDF5),
    aiHeroEnd: Color(0xFFFAFAF7),
    isDark: false,
  );

  /// Premium graphite-green dark palette.
  static const SavingorThemeExtension dark = SavingorThemeExtension(
    pageBackground: Color(0xFF111814),
    surfacePrimary: Color(0xFF18221C),
    surfaceSecondary: Color(0xFF1E2A23),
    surfaceElevated: Color(0xFF202D25),
    surfaceStrong: Color(0xFF26362C),
    navBarSurface: Color(0xFF1A2420),
    navBarBorder: Color(0xFF34483B),
    textPrimary: Color(0xFFF2F6F3),
    textSecondary: Color(0xFFBAC7BE),
    textMuted: Color(0xFF89988E),
    brandTitle: Color(0xFF55C967),
    brandHeading: Color(0xFF9AE090),
    accentGreen: Color(0xFF55C967),
    buttonLabelOnGreen: Color(0xFF102015),
    border: Color(0xFF34483B),
    divider: Color(0xFF34483B),
    inputFill: Color(0xFF18221C),
    inputFillDisabled: Color(0xFF141C18),
    disabledText: Color(0xFF6F7E75),
    selectedHighlight: Color(0xFF243528),
    hoverHighlight: Color(0xFF1F2E24),
    pressedHighlight: Color(0xFF2A3D30),
    ringTrack: Color(0xFF2A3530),
    chipSurface: Color(0xFF202D25),
    warningSurface: Color(0xFF2A2618),
    errorSurface: Color(0xFF2A1C1C),
    cardShadow: <BoxShadow>[
      BoxShadow(
        color: Color(0x33000000),
        blurRadius: 12,
        offset: Offset(0, 3),
      ),
    ],
    modalBarrier: Color(0xB3000000),
    error: Color(0xFFF87171),
    warning: Color(0xFFFBBF24),
    success: Color(0xFF55C967),
    destructive: Color(0xFFEF9A9A),
    heroGradientStart: Color(0xFF1E2A23),
    heroGradientMid: Color(0xFF19231D),
    heroGradientEnd: Color(0xFF111814),
    aiHeroStart: Color(0xFF221E2A),
    aiHeroMid: Color(0xFF1E2A23),
    aiHeroEnd: Color(0xFF111814),
    isDark: true,
  );

  static SavingorThemeExtension of(BuildContext context) {
    return Theme.of(context).extension<SavingorThemeExtension>() ?? light;
  }

  @override
  SavingorThemeExtension copyWith({
    Color? pageBackground,
    Color? surfacePrimary,
    Color? surfaceSecondary,
    Color? surfaceElevated,
    Color? surfaceStrong,
    Color? navBarSurface,
    Color? navBarBorder,
    Color? textPrimary,
    Color? textSecondary,
    Color? textMuted,
    Color? brandTitle,
    Color? brandHeading,
    Color? accentGreen,
    Color? buttonLabelOnGreen,
    Color? border,
    Color? divider,
    Color? inputFill,
    Color? inputFillDisabled,
    Color? disabledText,
    Color? selectedHighlight,
    Color? hoverHighlight,
    Color? pressedHighlight,
    Color? ringTrack,
    Color? chipSurface,
    Color? warningSurface,
    Color? errorSurface,
    List<BoxShadow>? cardShadow,
    Color? modalBarrier,
    Color? error,
    Color? warning,
    Color? success,
    Color? destructive,
    Color? heroGradientStart,
    Color? heroGradientMid,
    Color? heroGradientEnd,
    Color? aiHeroStart,
    Color? aiHeroMid,
    Color? aiHeroEnd,
    bool? isDark,
  }) {
    return SavingorThemeExtension(
      pageBackground: pageBackground ?? this.pageBackground,
      surfacePrimary: surfacePrimary ?? this.surfacePrimary,
      surfaceSecondary: surfaceSecondary ?? this.surfaceSecondary,
      surfaceElevated: surfaceElevated ?? this.surfaceElevated,
      surfaceStrong: surfaceStrong ?? this.surfaceStrong,
      navBarSurface: navBarSurface ?? this.navBarSurface,
      navBarBorder: navBarBorder ?? this.navBarBorder,
      textPrimary: textPrimary ?? this.textPrimary,
      textSecondary: textSecondary ?? this.textSecondary,
      textMuted: textMuted ?? this.textMuted,
      brandTitle: brandTitle ?? this.brandTitle,
      brandHeading: brandHeading ?? this.brandHeading,
      accentGreen: accentGreen ?? this.accentGreen,
      buttonLabelOnGreen: buttonLabelOnGreen ?? this.buttonLabelOnGreen,
      border: border ?? this.border,
      divider: divider ?? this.divider,
      inputFill: inputFill ?? this.inputFill,
      inputFillDisabled: inputFillDisabled ?? this.inputFillDisabled,
      disabledText: disabledText ?? this.disabledText,
      selectedHighlight: selectedHighlight ?? this.selectedHighlight,
      hoverHighlight: hoverHighlight ?? this.hoverHighlight,
      pressedHighlight: pressedHighlight ?? this.pressedHighlight,
      ringTrack: ringTrack ?? this.ringTrack,
      chipSurface: chipSurface ?? this.chipSurface,
      warningSurface: warningSurface ?? this.warningSurface,
      errorSurface: errorSurface ?? this.errorSurface,
      cardShadow: cardShadow ?? this.cardShadow,
      modalBarrier: modalBarrier ?? this.modalBarrier,
      error: error ?? this.error,
      warning: warning ?? this.warning,
      success: success ?? this.success,
      destructive: destructive ?? this.destructive,
      heroGradientStart: heroGradientStart ?? this.heroGradientStart,
      heroGradientMid: heroGradientMid ?? this.heroGradientMid,
      heroGradientEnd: heroGradientEnd ?? this.heroGradientEnd,
      aiHeroStart: aiHeroStart ?? this.aiHeroStart,
      aiHeroMid: aiHeroMid ?? this.aiHeroMid,
      aiHeroEnd: aiHeroEnd ?? this.aiHeroEnd,
      isDark: isDark ?? this.isDark,
    );
  }

  @override
  SavingorThemeExtension lerp(
    ThemeExtension<SavingorThemeExtension>? other,
    double t,
  ) {
    if (other is! SavingorThemeExtension) return this;
    return t < 0.5 ? this : other;
  }
}

extension SavingorThemeContext on BuildContext {
  SavingorThemeExtension get savingor => SavingorThemeExtension.of(this);
}
