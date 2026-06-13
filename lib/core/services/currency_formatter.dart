/// Central monetary display formatter for Savingor financial UI.
abstract final class CurrencyFormatter {
  /// Formats [amount] with an explicit currency code prefix, e.g. `CAD $123.45`.
  static String format(double amount, String currencyCode) {
    final String code = currencyCode.toUpperCase();
    final String grouped = _groupedAmount(amount.abs());
    if (amount < 0) {
      return '$code -\$$grouped';
    }
    return '$code \$$grouped';
  }

  static String _groupedAmount(double amount) {
    final String fixed = amount.toStringAsFixed(2);
    final List<String> parts = fixed.split('.');
    final String intPart = parts[0];
    final String decPart = parts.length > 1 ? parts[1] : '00';
    final StringBuffer grouped = StringBuffer();
    for (int i = 0; i < intPart.length; i++) {
      if (i > 0 && (intPart.length - i) % 3 == 0) {
        grouped.write(',');
      }
      grouped.write(intPart[i]);
    }
    return '${grouped.toString()}.$decPart';
  }
}
