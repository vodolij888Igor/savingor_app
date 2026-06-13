import 'package:flutter/widgets.dart';

import 'package:savingor_app/core/i18n/receipt_l10n.dart';
import 'package:savingor_app/features/analytics/domain/expense_analytics_calculator.dart';
import 'package:savingor_app/features/receipts/domain/models/receipt_source.dart';
import 'package:savingor_app/l10n/app_localizations.dart';

/// Localized labels for analytics recent-activity entries.
abstract final class AnalyticsActivityL10n {
  static String typeLabel(BuildContext context, AnalyticsActivityEntry entry) {
    final AppLocalizations l10n = AppLocalizations.of(context);
    return switch (entry.typeLabel) {
      'receipt' => l10n.activityTypeReceipt,
      'expense' => l10n.activityTypeManual,
      _ => entry.typeLabel,
    };
  }

  static String subtitle(BuildContext context, AnalyticsActivityEntry entry) {
    final AppLocalizations l10n = AppLocalizations.of(context);

    if (entry.typeLabel == 'expense') {
      return l10n.activityManualExpense;
    }

    if (entry.receiptSourceValue != null) {
      final ReceiptSource source =
          ReceiptSource.fromValue(entry.receiptSourceValue);
      final String sourceLabel = ReceiptL10n.sourceLabel(context, source);
      final int? itemCount = entry.receiptItemCount;
      if (itemCount != null && itemCount > 0) {
        return l10n.activityReceiptWithItems(sourceLabel, itemCount);
      }
      return sourceLabel;
    }

    return entry.subtitle;
  }
}
