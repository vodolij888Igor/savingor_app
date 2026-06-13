import 'package:flutter/material.dart';

import 'package:savingor_app/core/app_settings_options.dart';
import 'package:savingor_app/core/app_state.dart';
import 'package:savingor_app/core/i18n/app_settings_l10n.dart';
import 'package:savingor_app/core/theme/savingor_design_system.dart';
import 'package:savingor_app/l10n/app_localizations.dart';

Future<void> _showPickerSheet(
  BuildContext context, {
  required String title,
  required String subtitle,
  required Widget Function(BuildContext sheetContext) childBuilder,
}) {
  final SavingorThemeExtension theme = context.savingor;
  return showModalBottomSheet<void>(
    context: context,
    backgroundColor: theme.isDark ? theme.surfaceStrong : theme.surfacePrimary,
    isScrollControlled: true,
    useSafeArea: true,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(26)),
    ),
    builder: (BuildContext sheetContext) {
      return _PickerSheet(
        title: title,
        subtitle: subtitle,
        child: childBuilder(sheetContext),
      );
    },
  );
}

Future<void> showAppearancePicker(BuildContext context) async {
  final AppState appState = AppStateProvider.of(context);
  final String current = appState.appearance;
  final AppLocalizations l10n = AppLocalizations.of(context);

  await _showPickerSheet(
    context,
    title: l10n.appearance,
    subtitle: l10n.appearanceHelper,
    childBuilder: (BuildContext sheetContext) => Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        _PickerOptionTile(
          icon: Icons.light_mode_rounded,
          label: l10n.appearanceLight,
          selected: current == 'light',
          onTap: () {
            appState.setAppearance('light');
            Navigator.of(sheetContext).pop();
          },
        ),
        const SizedBox(height: SavingorSpacing.sm),
        _PickerOptionTile(
          icon: Icons.dark_mode_rounded,
          label: l10n.appearanceDark,
          selected: current == 'dark',
          onTap: () {
            appState.setAppearance('dark');
            Navigator.of(sheetContext).pop();
          },
        ),
      ],
    ),
  );
}

Future<void> showRegionPicker(BuildContext context) async {
  final AppState appState = AppStateProvider.of(context);
  final String current = appState.region;
  final AppLocalizations l10n = AppLocalizations.of(context);

  await _showPickerSheet(
    context,
    title: l10n.region,
    subtitle: l10n.regionHelper,
    childBuilder: (BuildContext sheetContext) => Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        for (int i = 0; i < AppSettingsOptions.regions.length; i++) ...<Widget>[
          if (i > 0) const SizedBox(height: SavingorSpacing.sm),
          _PickerOptionTile(
            icon: Icons.public_rounded,
            label: AppSettingsL10n.regionLabel(
              sheetContext,
              AppSettingsOptions.regions[i].id,
            ),
            selected: current == AppSettingsOptions.regions[i].id,
            onTap: () {
              appState.setRegion(AppSettingsOptions.regions[i].id);
              Navigator.of(sheetContext).pop();
            },
          ),
        ],
      ],
    ),
  );
}

Future<void> showCurrencyPicker(BuildContext context) async {
  final AppState appState = AppStateProvider.of(context);
  final String current = appState.currency;
  final AppLocalizations l10n = AppLocalizations.of(context);

  await _showPickerSheet(
    context,
    title: l10n.currency,
    subtitle: l10n.currencyHelper,
    childBuilder: (BuildContext sheetContext) => Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        for (int i = 0;
            i < AppSettingsOptions.currencies.length;
            i++) ...<Widget>[
          if (i > 0) const SizedBox(height: SavingorSpacing.sm),
          _PickerOptionTile(
            icon: Icons.attach_money_rounded,
            label: AppSettingsOptions.currencies[i],
            selected: current == AppSettingsOptions.currencies[i],
            onTap: () async {
              final String selected = AppSettingsOptions.currencies[i];
              Navigator.of(sheetContext).pop();
              final CurrencyChangeResult result =
                  await appState.changeDisplayCurrency(selected);
              if (!context.mounted) return;
              final ScaffoldMessengerState messenger =
                  ScaffoldMessenger.of(context);
              if (result.success) {
                messenger.showSnackBar(
                  SnackBar(
                    content: Text(result.successMessage ?? 'Currency updated.'),
                  ),
                );
              } else if (result.errorMessage != null) {
                messenger.showSnackBar(
                  SnackBar(content: Text(result.errorMessage!)),
                );
              }
            },
          ),
        ],
      ],
    ),
  );
}

class _PickerSheet extends StatelessWidget {
  const _PickerSheet({
    required this.title,
    required this.subtitle,
    required this.child,
  });

  final String title;
  final String subtitle;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final SavingorThemeExtension theme = context.savingor;
    final double bottomSafe = MediaQuery.paddingOf(context).bottom;

    return Container(
      decoration: theme.isDark
          ? BoxDecoration(
              color: theme.surfaceStrong,
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(26),
              ),
              border: Border.all(color: theme.border.withOpacity(0.85)),
            )
          : null,
      child: Padding(
        padding: EdgeInsets.fromLTRB(24, 18, 24, 24 + bottomSafe),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: theme.border,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 18),
            Text(
              title,
              style: TextStyle(
                fontSize: 19,
                fontWeight: FontWeight.w800,
                color:
                    theme.isDark ? theme.textPrimary : SavingorColors.darkGreen,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              subtitle,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: theme.textSecondary,
                height: 1.4,
              ),
            ),
            const SizedBox(height: 20),
            child,
          ],
        ),
      ),
    );
  }
}

class _PickerOptionTile extends StatelessWidget {
  const _PickerOptionTile({
    required this.icon,
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final SavingorThemeExtension theme = context.savingor;
    final bool isDark = theme.isDark;

    final Color tileColor = selected
        ? (isDark
            ? theme.selectedHighlight
            : SavingorColors.lightGreen.withOpacity(0.65))
        : (isDark ? theme.surfaceElevated : const Color(0xFFFCFDFC));

    final Color borderColor = selected
        ? (isDark
            ? theme.accentGreen.withOpacity(0.45)
            : SavingorColors.primaryStroke.withOpacity(0.45))
        : theme.border.withOpacity(isDark ? 0.9 : 0.85);

    final Color labelColor =
        isDark ? theme.textPrimary : const Color(0xFF1A2E24);

    final Color checkColor =
        isDark ? theme.accentGreen : SavingorColors.primaryGreen;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(18),
        child: Ink(
          decoration: BoxDecoration(
            color: tileColor,
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: borderColor),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Container(
                  width: 40,
                  height: 40,
                  decoration: SavingorSurfaces.accentIconBlock(
                    accent: isDark
                        ? theme.brandTitle
                        : SavingorAccentColors.savings,
                    radius: 12,
                  ),
                  child: Icon(
                    icon,
                    size: 20,
                    color: isDark
                        ? theme.brandTitle
                        : SavingorAccentColors.savings,
                  ),
                ),
                const SizedBox(width: SavingorSpacing.md),
                Expanded(
                  child: Text(
                    label,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: labelColor,
                      height: 1.25,
                    ),
                  ),
                ),
                if (selected) ...<Widget>[
                  const SizedBox(width: 8),
                  Icon(
                    Icons.check_circle_rounded,
                    color: checkColor,
                    size: 24,
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
