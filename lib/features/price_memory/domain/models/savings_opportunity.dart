/// A product where the user paid more recently than their best known price.
class SavingsOpportunity {
  const SavingsOpportunity({
    required this.id,
    required this.normalizedProductName,
    required this.displayName,
    required this.latestPrice,
    required this.latestStoreName,
    required this.latestPurchaseDate,
    required this.lowestPrice,
    required this.lowestStoreName,
    required this.lowestPurchaseDate,
    required this.priceDifference,
    required this.percentageDifference,
    required this.recordCount,
    this.currency = 'CAD',
  });

  final String id;
  final String normalizedProductName;
  final String displayName;
  final double latestPrice;
  final String latestStoreName;
  final DateTime latestPurchaseDate;
  final double lowestPrice;
  final String lowestStoreName;
  final DateTime lowestPurchaseDate;
  final double priceDifference;
  final double percentageDifference;
  final int recordCount;
  final String currency;

  String get savingsMessage => 'Save up to ${_formatAmount(priceDifference)} per item';

  String get recommendation {
    if (latestStoreName.trim().toLowerCase() ==
        lowestStoreName.trim().toLowerCase()) {
      return 'Watch this product before buying again.';
    }
    return 'Buy at $lowestStoreName next time.';
  }

  String _formatAmount(double amount) {
    if (currency == 'CAD') {
      return '\$${amount.toStringAsFixed(2)}';
    }
    return '$currency ${amount.toStringAsFixed(2)}';
  }
}
