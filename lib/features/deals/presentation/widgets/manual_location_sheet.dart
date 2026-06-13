import 'package:flutter/material.dart';

import 'package:savingor_app/core/theme/savingor_design_system.dart';
import 'package:savingor_app/l10n/app_localizations.dart';

/// Bottom sheet for entering a city or area manually.
class ManualLocationSheet extends StatefulWidget {
  const ManualLocationSheet({super.key});

  static Future<String?> show(BuildContext context) {
    final SavingorThemeExtension theme = context.savingor;
    return showModalBottomSheet<String>(
      context: context,
      isScrollControlled: true,
      backgroundColor:
          theme.isDark ? theme.surfaceStrong : theme.surfacePrimary,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (BuildContext context) => const ManualLocationSheet(),
    );
  }

  @override
  State<ManualLocationSheet> createState() => _ManualLocationSheetState();
}

class _ManualLocationSheetState extends State<ManualLocationSheet> {
  final TextEditingController _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _save() {
    Navigator.of(context).pop(_controller.text);
  }

  InputDecoration _fieldDecoration(
    BuildContext context,
    AppLocalizations l10n,
  ) {
    if (!context.savingor.isDark) {
      return InputDecoration(
        labelText: l10n.mapCityOrArea,
        hintText: 'Calgary',
        helperText: l10n.mapCityOrAreaExample,
        helperStyle: TextStyle(
          fontSize: 12,
          color: context.savingor.textSecondary.withOpacity(0.9),
        ),
        filled: true,
        fillColor: const Color(0xFFF8FAF8),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: Color(0xFFE8ECE9)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(
            color: SavingorColors.primaryStroke,
            width: 1.5,
          ),
        ),
      );
    }

    final SavingorThemeExtension theme = context.savingor;
    return InputDecoration(
      labelText: l10n.mapCityOrArea,
      hintText: 'Calgary',
      helperText: l10n.mapCityOrAreaExample,
      labelStyle: TextStyle(
        color: theme.textSecondary.withOpacity(0.95),
        fontWeight: FontWeight.w500,
      ),
      hintStyle: TextStyle(
        color: theme.textMuted.withOpacity(0.95),
        fontWeight: FontWeight.w500,
      ),
      helperStyle: TextStyle(
        fontSize: 12,
        color: theme.textSecondary.withOpacity(0.92),
      ),
      filled: true,
      fillColor: theme.inputFill,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide(color: theme.border.withOpacity(0.85)),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide(color: theme.border.withOpacity(0.9)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide(
          color: theme.accentGreen,
          width: 1.5,
        ),
      ),
    );
  }

  ButtonStyle _cancelButtonStyle(BuildContext context) {
    if (!context.savingor.isDark) {
      return OutlinedButton.styleFrom(
        foregroundColor: context.savingor.textSecondary,
        side: BorderSide(
          color: context.savingor.border.withOpacity(0.85),
        ),
        padding: const EdgeInsets.symmetric(vertical: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      );
    }

    final SavingorThemeExtension theme = context.savingor;
    return OutlinedButton.styleFrom(
      foregroundColor: theme.textPrimary,
      backgroundColor: theme.surfaceElevated,
      side: BorderSide(color: theme.border.withOpacity(0.9)),
      padding: const EdgeInsets.symmetric(vertical: 12),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
    );
  }

  ButtonStyle _saveButtonStyle(BuildContext context) {
    if (!context.savingor.isDark) {
      return FilledButton.styleFrom(
        backgroundColor: context.savingor.accentGreen,
        foregroundColor: context.savingor.buttonLabelOnGreen,
        padding: const EdgeInsets.symmetric(vertical: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      );
    }

    final SavingorThemeExtension theme = context.savingor;
    return FilledButton.styleFrom(
      backgroundColor: theme.accentGreen,
      foregroundColor: theme.buttonLabelOnGreen,
      padding: const EdgeInsets.symmetric(vertical: 12),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final AppLocalizations l10n = AppLocalizations.of(context);
    final SavingorThemeExtension theme = context.savingor;
    final bool isDark = theme.isDark;
    final double bottomInset = MediaQuery.viewInsetsOf(context).bottom;

    return Container(
      decoration: isDark
          ? BoxDecoration(
              color: theme.surfaceStrong,
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(20),
              ),
              border: Border.all(color: theme.border.withOpacity(0.85)),
            )
          : null,
      child: Padding(
        padding: EdgeInsets.fromLTRB(20, 16, 20, 20 + bottomInset),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: isDark ? theme.border : const Color(0xFFE0E4E1),
                  borderRadius: BorderRadius.circular(999),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              l10n.mapSetLocation,
              style: SavingorAppTextStyles.sectionTitleLarge(context),
            ),
            const SizedBox(height: SavingorSpacing.md),
            TextField(
              controller: _controller,
              autofocus: true,
              textInputAction: TextInputAction.done,
              onSubmitted: (_) => _save(),
              style: isDark
                  ? TextStyle(
                      color: theme.textPrimary,
                      fontWeight: FontWeight.w500,
                      fontSize: 16,
                    )
                  : null,
              cursorColor: isDark ? theme.accentGreen : null,
              decoration: _fieldDecoration(context, l10n),
            ),
            const SizedBox(height: SavingorSpacing.lg),
            Row(
              children: <Widget>[
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Navigator.of(context).pop(),
                    style: _cancelButtonStyle(context),
                    child: Text(
                      l10n.cancel,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: FilledButton(
                    onPressed: _save,
                    style: _saveButtonStyle(context),
                    child: Text(
                      l10n.save,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
