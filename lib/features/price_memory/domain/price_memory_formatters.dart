import 'package:savingor_app/core/services/currency_formatter.dart';

/// Formats product prices for price memory UI.
abstract final class PriceMemoryFormatters {
  static String formatPrice(double amount, {String currency = 'CAD'}) {
    return CurrencyFormatter.format(amount, currency);
  }

  static String formatDate(DateTime date) {
    const List<String> months = <String>[
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    return '${months[date.month - 1]} ${date.day}, ${date.year}';
  }
}
