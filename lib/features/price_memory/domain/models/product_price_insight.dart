import 'package:savingor_app/features/price_memory/domain/models/product_price_record.dart';

/// Aggregated price memory for one normalized product.
class ProductPriceInsight {
  const ProductPriceInsight({
    required this.normalizedProductName,
    required this.displayName,
    required this.latestPrice,
    required this.lowestPrice,
    required this.highestPrice,
    required this.recordCount,
    required this.latestStoreName,
    required this.latestPurchaseDate,
    required this.records,
    this.currency = 'CAD',
  });

  final String normalizedProductName;
  final String displayName;
  final double latestPrice;
  final double lowestPrice;
  final double highestPrice;
  final int recordCount;
  final String latestStoreName;
  final DateTime latestPurchaseDate;
  final List<ProductPriceRecord> records;
  final String currency;

  String get recordCountLabel =>
      '$recordCount ${recordCount == 1 ? 'record' : 'records'}';
}
