import 'package:flutter/material.dart';

import 'package:savingor_app/l10n/app_localizations.dart';

/// Localized display labels for app settings values (stable ids unchanged).
abstract final class AppSettingsL10n {
  static String regionLabel(BuildContext context, String regionId) {
    final AppLocalizations l10n = AppLocalizations.of(context);
    return regionId == 'us' ? l10n.regionUnitedStates : l10n.regionCanada;
  }

  static String appearanceLabel(BuildContext context, String mode) {
    final AppLocalizations l10n = AppLocalizations.of(context);
    return mode == 'dark' ? l10n.appearanceDark : l10n.appearanceLight;
  }
}
