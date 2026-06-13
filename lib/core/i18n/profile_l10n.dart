import 'package:flutter/widgets.dart';

import 'package:savingor_app/features/profile/data/user_profile_service.dart';
import 'package:savingor_app/l10n/app_localizations.dart';

/// Display-time localization for profile account error messages.
abstract final class ProfileL10n {
  static String localizeException(BuildContext context, UserProfileException error) {
    final AppLocalizations l10n = AppLocalizations.of(context);
    return switch (error.message) {
      'You need to be signed in to edit your profile.' => l10n.signInToEditProfile,
      'Please enter your full name.' => l10n.pleaseEnterFullName,
      'Could not save your changes. Please try again.' => l10n.couldNotSaveChanges,
      'You need to be signed in to change your password.' =>
        l10n.signInToChangePassword,
      'Current password is incorrect.' => l10n.currentPasswordIncorrect,
      'New password is too weak. Use at least 6 characters.' => l10n.passwordTooWeak,
      'Network error. Check your connection and try again.' =>
        l10n.networkErrorTryAgain,
      'For security, please sign in again and retry.' => l10n.recentLoginRequired,
      'Too many attempts. Please try again later.' => l10n.tooManyAttempts,
      'Could not update your password. Please try again.' =>
        l10n.couldNotUpdatePassword,
      'No email is linked to this account.' => l10n.noEmailLinked,
      'Could not send the reset email. Please try again.' =>
        l10n.couldNotSendResetEmail,
      _ => error.message,
    };
  }
}
