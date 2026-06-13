import 'dart:math' as math;
import 'dart:ui' show ImageFilter;

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import 'package:savingor_app/core/theme/savingor_design_system.dart';
import 'package:savingor_app/l10n/app_localizations.dart';

/// Centered source picker shown when the user taps "Scan receipt".
abstract final class ReceiptSourceDialog {
  ReceiptSourceDialog._();

  static const double _dialogRadius = 28;
  static const double _maxDialogWidth = 420;
  static const double _widthFactor = 0.85;
  static const double _barrierOpacity = 0.57;
  static const double _blurSigma = 2.5;

  static Future<ImageSource?> show(BuildContext context) {
    return showGeneralDialog<ImageSource>(
      context: context,
      useRootNavigator: true,
      barrierDismissible: true,
      barrierLabel: MaterialLocalizations.of(context).modalBarrierDismissLabel,
      barrierColor: Colors.transparent,
      transitionDuration: const Duration(milliseconds: 220),
      pageBuilder: (
        BuildContext context,
        Animation<double> animation,
        Animation<double> secondaryAnimation,
      ) {
        return _ReceiptSourceDialogLayer(animation: animation);
      },
      transitionBuilder: (
        BuildContext context,
        Animation<double> animation,
        Animation<double> secondaryAnimation,
        Widget child,
      ) {
        return child;
      },
    );
  }

  static Widget _buildModalCard(BuildContext context) {
    final AppLocalizations l10n = AppLocalizations.of(context);
    final double screenWidth = MediaQuery.sizeOf(context).width;
    final double dialogWidth = math.min(screenWidth * _widthFactor, _maxDialogWidth);
    final double horizontalInset = (screenWidth - dialogWidth) / 2;

    return SafeArea(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: horizontalInset),
        child: Center(
          child: Material(
            color: Colors.transparent,
            child: Container(
              width: dialogWidth,
              decoration: BoxDecoration(
                color: SavingorColors.pageWhite,
                borderRadius: BorderRadius.circular(_dialogRadius),
                border: Border.all(
                  color: SavingorColors.border.withOpacity(0.75),
                  width: 0.75,
                ),
                boxShadow: const <BoxShadow>[
                  BoxShadow(
                    color: Color(0x1A000000),
                    blurRadius: 28,
                    offset: Offset(0, 10),
                  ),
                  BoxShadow(
                    color: Color(0x0F4F9D47),
                    blurRadius: 20,
                    offset: Offset(0, 4),
                  ),
                ],
              ),
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 20, 20, 20),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    _DialogHeader(
                      onClose: () => Navigator.of(context).pop(),
                    ),
                    const SizedBox(height: SavingorSpacing.lg),
                    _SourceOptionCard(
                      title: l10n.takePhoto,
                      subtitle: l10n.takePhotoSubtitle,
                      icon: Icons.camera_alt_rounded,
                      emphasized: true,
                      onTap: () =>
                          Navigator.of(context).pop(ImageSource.camera),
                    ),
                    const SizedBox(height: SavingorSpacing.md),
                    _SourceOptionCard(
                      title: l10n.chooseFromGallery,
                      subtitle: l10n.chooseFromGallerySubtitle,
                      icon: Icons.photo_library_rounded,
                      emphasized: false,
                      onTap: () =>
                          Navigator.of(context).pop(ImageSource.gallery),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _ReceiptSourceDialogLayer extends StatefulWidget {
  const _ReceiptSourceDialogLayer({required this.animation});

  final Animation<double> animation;

  @override
  State<_ReceiptSourceDialogLayer> createState() =>
      _ReceiptSourceDialogLayerState();
}

class _ReceiptSourceDialogLayerState extends State<_ReceiptSourceDialogLayer> {
  late final CurvedAnimation _curved;

  @override
  void initState() {
    super.initState();
    _curved = CurvedAnimation(
      parent: widget.animation,
      curve: Curves.easeOutCubic,
    );
  }

  @override
  void dispose() {
    _curved.dispose();
    super.dispose();
  }

  void _dismiss() {
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: <Widget>[
        FadeTransition(
          opacity: _curved,
          child: GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: _dismiss,
            child: BackdropFilter(
              filter: ImageFilter.blur(
                sigmaX: ReceiptSourceDialog._blurSigma,
                sigmaY: ReceiptSourceDialog._blurSigma,
              ),
              child: ColoredBox(
                color: Colors.black.withOpacity(
                  ReceiptSourceDialog._barrierOpacity,
                ),
              ),
            ),
          ),
        ),
        FadeTransition(
          opacity: _curved,
          child: ScaleTransition(
            scale: Tween<double>(begin: 0.96, end: 1).animate(_curved),
            child: ReceiptSourceDialog._buildModalCard(context),
          ),
        ),
      ],
    );
  }
}

class _DialogHeader extends StatelessWidget {
  const _DialogHeader({required this.onClose});

  final VoidCallback onClose;

  @override
  Widget build(BuildContext context) {
    final AppLocalizations l10n = AppLocalizations.of(context);

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: SavingorColors.lightGreen,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: SavingorColors.primaryStroke.withOpacity(0.18),
            ),
          ),
          child: const Icon(
            Icons.document_scanner_rounded,
            size: 20,
            color: SavingorColors.primaryStroke,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                l10n.scanReceipt,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFF1A2E24),
                  height: 1.2,
                  letterSpacing: -0.2,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                l10n.chooseReceiptSource,
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                  color: SavingorColors.textSecondary.withOpacity(0.95),
                  height: 1.35,
                ),
              ),
            ],
          ),
        ),
        Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: onClose,
            borderRadius: BorderRadius.circular(20),
            child: Padding(
              padding: const EdgeInsets.all(6),
              child: Icon(
                Icons.close_rounded,
                size: 22,
                color: SavingorColors.textSecondary.withOpacity(0.85),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _SourceOptionCard extends StatelessWidget {
  const _SourceOptionCard({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.emphasized,
    required this.onTap,
  });

  final String title;
  final String subtitle;
  final IconData icon;
  final bool emphasized;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    const Color accent = SavingorColors.primaryStroke;

    final BoxDecoration decoration = emphasized
        ? BoxDecoration(
            borderRadius: BorderRadius.circular(18),
            gradient: const LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: <Color>[
                Color(0xFFF0FAF3),
                Color(0xFFFAFAF5),
              ],
            ),
            border: Border.all(
              color: accent.withOpacity(0.28),
              width: 1,
            ),
            boxShadow: <BoxShadow>[
              BoxShadow(
                color: accent.withOpacity(0.1),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
          )
        : BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(18),
            border: Border.all(
              color: SavingorColors.border.withOpacity(0.85),
              width: 0.75,
            ),
          );

    final BoxDecoration iconDecoration = emphasized
        ? BoxDecoration(
            color: accent,
            borderRadius: BorderRadius.circular(14),
            boxShadow: <BoxShadow>[
              BoxShadow(
                color: accent.withOpacity(0.25),
                blurRadius: 8,
                offset: const Offset(0, 3),
              ),
            ],
          )
        : BoxDecoration(
            color: SavingorColors.lightGreen,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: accent.withOpacity(0.2),
            ),
          );

    final Color iconColor =
        emphasized ? Colors.white : SavingorColors.primaryStroke;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(18),
        child: Ink(
          decoration: decoration,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            child: Row(
              children: <Widget>[
                Container(
                  width: 48,
                  height: 48,
                  decoration: iconDecoration,
                  child: Icon(icon, color: iconColor, size: 24),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        title,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: emphasized
                              ? SavingorColors.darkGreen
                              : const Color(0xFF1F2937),
                          height: 1.2,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        subtitle,
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                          color:
                              SavingorColors.textSecondary.withOpacity(0.95),
                          height: 1.35,
                        ),
                      ),
                    ],
                  ),
                ),
                Icon(
                  Icons.chevron_right_rounded,
                  color: emphasized
                      ? accent.withOpacity(0.75)
                      : SavingorColors.textSecondary.withOpacity(0.55),
                  size: 24,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
