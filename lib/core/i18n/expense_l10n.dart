import 'package:flutter/widgets.dart';

import 'package:savingor_app/l10n/app_localizations.dart';

/// Localized display labels for expense store error messages.
abstract final class ExpenseL10n {
  static String localizeError(BuildContext context, String? error) {
    if (error == null || error.isEmpty) {
      return '';
    }

    final AppLocalizations l10n = AppLocalizations.of(context);
    return switch (error) {
      'Could not load your expenses. Please try again.' =>
        l10n.couldNotLoadYourExpenses,
      'Sign in to save expenses.' => l10n.signInToSaveExpenses,
      'Could not save the expense. Please try again.' =>
        l10n.couldNotSaveExpense,
      'Could not delete the expense. Please try again.' =>
        l10n.couldNotDeleteExpense,
      'Store name is required.' => l10n.enterStoreName,
      'Total amount must be greater than zero.' => l10n.enterValidAmount,
      _ => error,
    };
  }
}
