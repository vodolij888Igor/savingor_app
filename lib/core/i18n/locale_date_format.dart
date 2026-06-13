import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';

/// Locale-aware date display formatting (display only — not for storage).
abstract final class LocaleDateFormat {
  static String formatMediumDate(BuildContext context, DateTime date) {
    final String locale = Localizations.localeOf(context).toString();
    return DateFormat.yMMMd(locale).format(date);
  }
}
