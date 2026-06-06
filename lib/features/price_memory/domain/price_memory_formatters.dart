/// Formats product prices for price memory UI.
abstract final class PriceMemoryFormatters {
  static String formatPrice(double amount, {String currency = 'CAD'}) {
    if (currency == 'CAD') {
      return '\$${amount.toStringAsFixed(2)}';
    }
    return '$currency ${amount.toStringAsFixed(2)}';
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
