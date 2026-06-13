import 'package:flutter/widgets.dart';

import 'package:savingor_app/features/receipts/domain/models/receipt_source.dart';
import 'package:savingor_app/l10n/app_localizations.dart';

/// Localized display labels for receipt sources and store error messages.
abstract final class ReceiptL10n {
  static String sourceLabel(BuildContext context, ReceiptSource source) {
    final AppLocalizations l10n = AppLocalizations.of(context);
    return switch (source) {
      ReceiptSource.manual => l10n.receiptSourceManual,
      ReceiptSource.scanned => l10n.receiptSourceScanned,
      ReceiptSource.gallery => l10n.receiptSourceGallery,
      ReceiptSource.imported => l10n.receiptSourceImported,
      ReceiptSource.shoppingList => l10n.receiptSourceShoppingList,
      ReceiptSource.unknown => l10n.receiptSourceUnknown,
    };
  }

  static String notesSectionTitle(
    BuildContext context,
    ReceiptSource source,
  ) {
    final AppLocalizations l10n = AppLocalizations.of(context);
    return switch (source) {
      ReceiptSource.scanned => l10n.scanNotes,
      ReceiptSource.gallery => l10n.galleryScanNotes,
      ReceiptSource.imported => l10n.importNotes,
      ReceiptSource.shoppingList => l10n.tripNotes,
      ReceiptSource.manual || ReceiptSource.unknown => l10n.notes,
    };
  }

  /// Maps stable English store error strings to localized messages.
  static String localizeError(BuildContext context, String? error) {
    if (error == null || error.isEmpty) {
      return '';
    }

    final AppLocalizations l10n = AppLocalizations.of(context);
    return switch (error) {
      'Could not load your receipts. Please try again.' =>
        l10n.couldNotLoadYourReceipts,
      'Sign in to save receipts.' => l10n.signInToSaveReceipts,
      'Could not save the receipt. Please try again.' =>
        l10n.couldNotSaveReceipt,
      'Could not delete the receipt. Please try again.' =>
        l10n.couldNotDeleteReceipt,
      'Sign in to update receipts.' => l10n.signInToUpdateReceipts,
      'Receipt not found.' => l10n.receiptNotFound,
      'Could not update the receipt. Please try again.' =>
        l10n.couldNotUpdateReceipt,
      _ => error,
    };
  }
}
