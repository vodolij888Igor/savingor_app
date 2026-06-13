import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:savingor_app/core/theme/savingor_design_system.dart';

// Hover uses [MouseRegion] and is enabled on web/desktop only.
// Android emulator may not deliver hover events reliably; tap/press via
// [InkWell] always works. Never wrap [Row], [Wrap], or full screens — only
// individual cards/buttons with bounded constraints.

/// Shared motion tokens for press / hover feedback across Savingor.
abstract final class SavingorInteraction {
  static const Duration duration = Duration(milliseconds: 160);
  static const Curve curve = Curves.easeOut;
  static const double hoverScale = 1.025;
  static const double pressedScale = 0.985;
  static const double hoverLift = -3;

  /// Hover visuals/scale are web-only; mobile uses tap/press feedback only.
  static bool get enableHoverEffects => kIsWeb;

  static const Color hoverBackgroundTint = Color(0xFFF0FDF4);
  static const Color pressedBackgroundTint = Color(0xFFD1FAE5);

  static double scaleFor({
    required bool hovered,
    required bool pressed,
    required bool enabled,
    double hoverScaleValue = hoverScale,
    double pressedScaleValue = pressedScale,
  }) {
    if (!enabled) return 1.0;
    if (pressed) return pressedScaleValue;
    if (hovered) return hoverScaleValue;
    return 1.0;
  }

  static List<BoxShadow> cardShadow({
    bool hovered = false,
    bool pressed = false,
    Color tint = SavingorColors.primaryStroke,
  }) {
    if (pressed) {
      return <BoxShadow>[
        BoxShadow(
          color: tint.withOpacity(0.1),
          blurRadius: 10,
          offset: const Offset(0, 2),
        ),
      ];
    }
    if (hovered) {
      return <BoxShadow>[
        BoxShadow(
          color: tint.withOpacity(0.28),
          blurRadius: 22,
          spreadRadius: 0.5,
          offset: const Offset(0, 8),
        ),
        BoxShadow(
          color: SavingorColors.primaryGreen.withOpacity(0.2),
          blurRadius: 16,
          spreadRadius: 1,
          offset: const Offset(0, 4),
        ),
        const BoxShadow(
          color: Color(0x18000000),
          blurRadius: 14,
          offset: Offset(0, 4),
        ),
      ];
    }
    return const <BoxShadow>[
      BoxShadow(
        color: Color(0x0A000000),
        blurRadius: 12,
        offset: Offset(0, 3),
      ),
    ];
  }
}

/// Current hover / press state exposed to decoration builders.
class SavingorInteractionState {
  const SavingorInteractionState({
    required this.hovered,
    required this.pressed,
    required this.enabled,
  });

  final bool hovered;
  final bool pressed;
  final bool enabled;

  bool get isInteractive => enabled;
}

typedef SavingorInteractiveBuilder = Widget Function(
  BuildContext context,
  SavingorInteractionState state,
);

/// Core pressable wrapper — hover lift, scale, ink, and pointer cursor.
///
/// [MouseRegion] is the outermost layer with opaque hit-testing so hover is
/// detected across the full card width. Press uses [InkWell] when [enableInk]
/// is true, otherwise [Listener] + [GestureDetector].
class SavingorInteractivePressable extends StatefulWidget {
  const SavingorInteractivePressable({
    super.key,
    required this.builder,
    required this.onTap,
    this.borderRadius,
    this.enabled = true,
    this.enableInk = true,
    this.liftOnHover = false,
    this.expandWidth = false,
    this.hoverScale = SavingorInteraction.hoverScale,
    this.pressedScale = SavingorInteraction.pressedScale,
    this.splashColor,
    this.highlightColor,
    this.semanticLabel,
  });

  final SavingorInteractiveBuilder builder;
  final VoidCallback? onTap;
  final BorderRadius? borderRadius;
  final bool enabled;
  final bool enableInk;
  final bool liftOnHover;
  final bool expandWidth;
  final double hoverScale;
  final double pressedScale;
  final Color? splashColor;
  final Color? highlightColor;
  final String? semanticLabel;

  @override
  State<SavingorInteractivePressable> createState() =>
      _SavingorInteractivePressableState();
}

class _SavingorInteractivePressableState
    extends State<SavingorInteractivePressable> {
  bool _hovered = false;
  bool _pressed = false;

  bool get _isEnabled => widget.enabled && widget.onTap != null;

  SavingorInteractionState get _state => SavingorInteractionState(
        hovered:
            _hovered && _isEnabled && SavingorInteraction.enableHoverEffects,
        pressed: _pressed && _isEnabled,
        enabled: _isEnabled,
      );

  void _setHovered(bool value) {
    if (_hovered == value) return;
    setState(() => _hovered = value);
  }

  void _setPressed(bool value) {
    if (_pressed == value) return;
    setState(() => _pressed = value);
  }

  void _handleExit() {
    _setHovered(false);
    _setPressed(false);
  }

  Widget _buildScaledChild() {
    final double effectiveHoverScale =
        SavingorInteraction.enableHoverEffects ? widget.hoverScale : 1.0;
    final double scale = SavingorInteraction.scaleFor(
      hovered: _hovered,
      pressed: _pressed,
      enabled: _isEnabled,
      hoverScaleValue: effectiveHoverScale,
      pressedScaleValue: widget.pressedScale,
    );
    final double lift = widget.liftOnHover &&
            SavingorInteraction.enableHoverEffects &&
            _hovered &&
            !_pressed &&
            _isEnabled
        ? SavingorInteraction.hoverLift
        : 0;

    return AnimatedScale(
      scale: scale,
      duration: SavingorInteraction.duration,
      curve: SavingorInteraction.curve,
      alignment: Alignment.center,
      child: AnimatedContainer(
        duration: SavingorInteraction.duration,
        curve: SavingorInteraction.curve,
        transform: Matrix4.translationValues(0, lift, 0),
        transformAlignment: Alignment.center,
        child: _buildTapChild(),
      ),
    );
  }

  Widget _buildTapChild() {
    final Widget built = widget.builder(context, _state);

    if (!_isEnabled) {
      return built;
    }

    if (widget.enableInk && widget.borderRadius != null) {
      return Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: widget.onTap,
          onHighlightChanged: _setPressed,
          borderRadius: widget.borderRadius,
          splashColor: widget.splashColor ??
              SavingorColors.primaryStroke.withOpacity(0.12),
          highlightColor: widget.highlightColor ??
              SavingorColors.primaryGreen.withOpacity(0.14),
          child: built,
        ),
      );
    }

    return Listener(
      behavior: HitTestBehavior.opaque,
      onPointerDown: (_) => _setPressed(true),
      onPointerUp: (_) => _setPressed(false),
      onPointerCancel: (_) => _setPressed(false),
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: widget.onTap,
        child: built,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    Widget content = MouseRegion(
      hitTestBehavior: HitTestBehavior.opaque,
      cursor: _isEnabled ? SystemMouseCursors.click : SystemMouseCursors.basic,
      onEnter: (_) => _setHovered(true),
      onExit: (_) => _handleExit(),
      child: _buildScaledChild(),
    );

    if (widget.expandWidth) {
      content = SizedBox(width: double.infinity, child: content);
    }

    if (widget.semanticLabel != null) {
      content = Semantics(
        button: true,
        label: widget.semanticLabel,
        enabled: _isEnabled,
        child: content,
      );
    }

    return content;
  }
}

/// White / light card with consistent hover border, shadow, and background.
class SavingorInteractiveCard extends StatelessWidget {
  const SavingorInteractiveCard({
    super.key,
    required this.child,
    required this.onTap,
    this.borderRadius = const BorderRadius.all(Radius.circular(18)),
    this.padding,
    this.backgroundColor,
    this.hoverBackgroundColor,
    this.borderColor,
    this.hoverBorderColor,
    this.accentTint,
    this.enabled = true,
    this.showInk = true,
    this.liftOnHover = false,
    this.semanticLabel,
    this.boxShadow,
    this.hoverBoxShadow,
    this.expandWidth = true,
  });

  final Widget child;
  final VoidCallback? onTap;
  final BorderRadius borderRadius;
  final EdgeInsetsGeometry? padding;
  final Color? backgroundColor;
  final Color? hoverBackgroundColor;
  final Color? borderColor;
  final Color? hoverBorderColor;
  final Color? accentTint;
  final bool enabled;
  final bool showInk;
  final bool liftOnHover;
  final String? semanticLabel;
  final List<BoxShadow>? boxShadow;
  final List<BoxShadow>? hoverBoxShadow;

  /// Full-width cards in [Column] layouts only — never use inside [Row]/[Wrap].
  final bool expandWidth;

  @override
  Widget build(BuildContext context) {
    return SavingorInteractivePressable(
      onTap: onTap,
      borderRadius: borderRadius,
      enabled: enabled,
      enableInk: showInk,
      liftOnHover: liftOnHover,
      expandWidth: expandWidth,
      splashColor:
          (accentTint ?? SavingorColors.primaryStroke).withOpacity(0.1),
      highlightColor: SavingorColors.primaryGreen.withOpacity(0.12),
      semanticLabel: semanticLabel,
      builder: (BuildContext context, SavingorInteractionState state) {
        final Color tint = accentTint ?? SavingorColors.primaryStroke;
        final Color resolvedBorder = _borderColor(context, state, tint);
        final Color resolvedBackground = _backgroundColor(context, state);
        final List<BoxShadow> resolvedShadow = _shadows(state, tint);
        final double borderWidth = _borderWidth(state);

        return AnimatedContainer(
          duration: SavingorInteraction.duration,
          curve: SavingorInteraction.curve,
          padding: padding,
          decoration: BoxDecoration(
            color: resolvedBackground,
            borderRadius: borderRadius,
            border: Border.all(color: resolvedBorder, width: borderWidth),
            boxShadow: resolvedShadow,
          ),
          child: child,
        );
      },
    );
  }

  Color _backgroundColor(BuildContext context, SavingorInteractionState state) {
    final Color base = backgroundColor ?? context.savingor.surfacePrimary;
    if (!state.isInteractive) return base;
    if (state.pressed) {
      return Color.lerp(
            hoverBackgroundColor ?? base,
            SavingorInteraction.pressedBackgroundTint,
            0.55,
          ) ??
          SavingorInteraction.pressedBackgroundTint;
    }
    if (state.hovered) {
      return Color.lerp(
            hoverBackgroundColor ?? base,
            SavingorInteraction.hoverBackgroundTint,
            0.72,
          ) ??
          SavingorInteraction.hoverBackgroundTint;
    }
    return base;
  }

  Color _borderColor(
      BuildContext context, SavingorInteractionState state, Color tint) {
    final Color base = borderColor ?? context.savingor.border;
    if (!state.isInteractive) return base.withOpacity(0.65);
    if (state.pressed) {
      return hoverBorderColor ?? SavingorColors.primaryStroke.withOpacity(0.55);
    }
    if (state.hovered) {
      return hoverBorderColor ?? SavingorColors.primaryStroke.withOpacity(0.68);
    }
    return base.withOpacity(0.65);
  }

  double _borderWidth(SavingorInteractionState state) {
    if (!state.isInteractive) return 0.75;
    if (state.hovered) return 1.5;
    if (state.pressed) return 1.25;
    return 0.75;
  }

  List<BoxShadow> _shadows(SavingorInteractionState state, Color tint) {
    if (state.pressed && state.isInteractive) {
      return SavingorInteraction.cardShadow(pressed: true, tint: tint);
    }
    if (state.hovered && state.isInteractive) {
      return hoverBoxShadow ??
          SavingorInteraction.cardShadow(hovered: true, tint: tint);
    }
    return boxShadow ?? SavingorInteraction.cardShadow();
  }
}

/// Primary green filled action button with hover / press feedback.
class SavingorInteractiveFilledButton extends StatelessWidget {
  const SavingorInteractiveFilledButton({
    super.key,
    required this.onPressed,
    required this.child,
    this.minHeight = 52,
    this.padding = const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
    this.borderRadius =
        const BorderRadius.all(Radius.circular(SavingorRadius.xl)),
    this.width,
  });

  final VoidCallback? onPressed;
  final Widget child;
  final double minHeight;
  final EdgeInsetsGeometry padding;
  final BorderRadius borderRadius;
  final double? width;

  static const Color _pressedGreen = Color(0xFF5FAF52);
  static const Color _hoverGreen = Color(0xFF96D48C);

  @override
  Widget build(BuildContext context) {
    final bool enabled = onPressed != null;

    return SavingorInteractivePressable(
      onTap: onPressed,
      borderRadius: borderRadius,
      enabled: enabled,
      expandWidth: width != null,
      builder: (BuildContext context, SavingorInteractionState state) {
        final SavingorThemeExtension t = context.savingor;

        Color background;
        Color labelColor;
        Color iconColor;
        Color borderColor;
        List<BoxShadow> shadows;

        if (t.isDark) {
          background = t.accentGreen;
          if (enabled && state.pressed) {
            background = Color.lerp(t.accentGreen, Colors.black, 0.12)!;
          } else if (enabled && state.hovered) {
            background = Color.lerp(t.accentGreen, Colors.white, 0.08)!;
          } else if (!enabled) {
            background = t.accentGreen.withOpacity(0.45);
          }
          labelColor = t.buttonLabelOnGreen;
          iconColor = t.buttonLabelOnGreen;
          borderColor = t.accentGreen.withOpacity(
            enabled ? (state.hovered ? 0.45 : 0.32) : 0.2,
          );
          shadows = enabled
              ? <BoxShadow>[
                  BoxShadow(
                    color:
                        t.accentGreen.withOpacity(state.hovered ? 0.2 : 0.14),
                    blurRadius: state.hovered ? 12 : 8,
                    offset: Offset(0, state.hovered ? 4 : 3),
                  ),
                ]
              : const <BoxShadow>[];
        } else {
          background = SavingorColors.primaryGreen;
          if (enabled && state.pressed) {
            background = _pressedGreen;
          } else if (enabled && state.hovered) {
            background = _hoverGreen;
          } else if (!enabled) {
            background = SavingorColors.primaryGreen.withOpacity(0.55);
          }
          labelColor = SavingorColors.darkGreen;
          iconColor = SavingorColors.darkGreen;
          borderColor = SavingorColors.primaryStroke.withOpacity(
            enabled ? (state.hovered ? 0.55 : 0.35) : 0.2,
          );
          shadows = enabled && state.hovered
              ? <BoxShadow>[
                  BoxShadow(
                    color: SavingorColors.primaryStroke.withOpacity(0.32),
                    blurRadius: 18,
                    spreadRadius: 0.5,
                    offset: const Offset(0, 6),
                  ),
                  BoxShadow(
                    color: SavingorColors.primaryGreen.withOpacity(0.22),
                    blurRadius: 14,
                    offset: const Offset(0, 4),
                  ),
                ]
              : enabled
                  ? <BoxShadow>[
                      BoxShadow(
                        color: SavingorColors.primaryStroke.withOpacity(0.14),
                        blurRadius: 10,
                        offset: const Offset(0, 3),
                      ),
                    ]
                  : const <BoxShadow>[];
        }

        final double borderWidth = state.hovered ? 1.5 : 1;

        return AnimatedContainer(
          duration: SavingorInteraction.duration,
          curve: SavingorInteraction.curve,
          width: width,
          constraints: BoxConstraints(minHeight: minHeight),
          padding: padding,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: background,
            borderRadius: borderRadius,
            border: Border.all(
              color: borderColor,
              width: borderWidth,
            ),
            boxShadow: shadows,
          ),
          child: DefaultTextStyle(
            style: TextStyle(
              fontWeight: FontWeight.w700,
              fontSize: 16,
              color: labelColor,
              letterSpacing: 0.1,
            ),
            child: IconTheme(
              data: IconThemeData(
                color: iconColor,
                size: 20,
              ),
              child: child,
            ),
          ),
        );
      },
    );
  }
}

/// Outlined secondary button with subtle hover feedback.
class SavingorInteractiveOutlinedButton extends StatelessWidget {
  const SavingorInteractiveOutlinedButton({
    super.key,
    required this.onPressed,
    required this.child,
    this.padding = const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
    this.borderRadius = const BorderRadius.all(Radius.circular(12)),
    this.foregroundColor = SavingorColors.primaryStroke,
    this.borderColor,
    this.accentTint,
  });

  final VoidCallback? onPressed;
  final Widget child;
  final EdgeInsetsGeometry padding;
  final BorderRadius borderRadius;
  final Color foregroundColor;
  final Color? borderColor;
  final Color? accentTint;

  @override
  Widget build(BuildContext context) {
    final bool enabled = onPressed != null;
    final Color tint = accentTint ?? foregroundColor;

    return SavingorInteractivePressable(
      onTap: onPressed,
      borderRadius: borderRadius,
      enabled: enabled,
      liftOnHover: false,
      expandWidth: false,
      splashColor: tint.withOpacity(0.1),
      highlightColor: SavingorColors.primaryGreen.withOpacity(0.1),
      builder: (BuildContext context, SavingorInteractionState state) {
        return AnimatedContainer(
          duration: SavingorInteraction.duration,
          curve: SavingorInteraction.curve,
          padding: padding,
          decoration: BoxDecoration(
            color: state.pressed && enabled
                ? SavingorInteraction.pressedBackgroundTint
                : state.hovered && enabled
                    ? SavingorInteraction.hoverBackgroundTint
                    : context.savingor.surfacePrimary,
            borderRadius: borderRadius,
            border: Border.all(
              color: state.hovered && enabled
                  ? SavingorColors.primaryStroke.withOpacity(0.65)
                  : (borderColor ?? tint.withOpacity(0.45)),
              width: state.hovered && enabled ? 1.5 : 1,
            ),
            boxShadow: state.hovered && enabled
                ? SavingorInteraction.cardShadow(hovered: true, tint: tint)
                : null,
          ),
          child: DefaultTextStyle(
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w700,
              color:
                  enabled ? foregroundColor : foregroundColor.withOpacity(0.5),
            ),
            child: child,
          ),
        );
      },
    );
  }
}

/// Low-emphasis text action (e.g. “See all”).
class SavingorInteractiveTextButton extends StatelessWidget {
  const SavingorInteractiveTextButton({
    super.key,
    required this.onPressed,
    required this.child,
    this.foregroundColor = SavingorColors.primaryStroke,
    this.padding = EdgeInsets.zero,
  });

  final VoidCallback? onPressed;
  final Widget child;
  final Color foregroundColor;
  final EdgeInsetsGeometry padding;

  @override
  Widget build(BuildContext context) {
    return SavingorInteractivePressable(
      onTap: onPressed,
      borderRadius: BorderRadius.circular(8),
      enabled: onPressed != null,
      liftOnHover: false,
      expandWidth: false,
      builder: (BuildContext context, SavingorInteractionState state) {
        return AnimatedContainer(
          duration: SavingorInteraction.duration,
          curve: SavingorInteraction.curve,
          padding: padding,
          decoration: BoxDecoration(
            color: state.pressed
                ? SavingorColors.primaryGreen.withOpacity(0.14)
                : state.hovered
                    ? SavingorColors.primaryGreen.withOpacity(0.1)
                    : Colors.transparent,
            borderRadius: BorderRadius.circular(8),
            border: state.hovered
                ? Border.all(
                    color: SavingorColors.primaryStroke.withOpacity(0.35),
                  )
                : null,
          ),
          child: DefaultTextStyle(
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w700,
              color: foregroundColor,
            ),
            child: child,
          ),
        );
      },
    );
  }
}
