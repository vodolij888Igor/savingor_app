import 'dart:math' as math;

import 'package:savingor_app/features/price_memory/domain/models/product_price_insight.dart';
import 'package:savingor_app/features/price_memory/domain/models/product_price_record.dart';
import 'package:savingor_app/features/price_memory/domain/product_name_normalizer.dart';

/// Groups raw price records into product-level insights.
abstract final class ProductPriceInsightsGrouper {
  static Map<String, List<ProductPriceRecord>> groupRecords(
    List<ProductPriceRecord> records,
  ) {
    final Map<String, List<ProductPriceRecord>> grouped =
        <String, List<ProductPriceRecord>>{};

    for (final ProductPriceRecord record in records) {
      final String groupKey = _groupKeyFor(record);
      if (groupKey.isEmpty) {
        continue;
      }
      grouped.putIfAbsent(groupKey, () => <ProductPriceRecord>[]).add(record);
    }

    return grouped;
  }

  static List<ProductPriceInsight> group(List<ProductPriceRecord> records) {
    if (records.isEmpty) {
      return const <ProductPriceInsight>[];
    }

    final Map<String, List<ProductPriceRecord>> grouped = groupRecords(records);

    final List<ProductPriceInsight> insights = grouped.entries
        .map(_buildInsight)
        .toList(growable: false)
      ..sort(
        (ProductPriceInsight a, ProductPriceInsight b) =>
            b.latestPurchaseDate.compareTo(a.latestPurchaseDate),
      );

    return insights;
  }

  static ProductPriceInsight? findInsight({
    required List<ProductPriceRecord> records,
    required String normalizedProductName,
  }) {
    final String targetKey = normalizedProductName.trim().toLowerCase();
    if (targetKey.isEmpty) {
      return null;
    }

    for (final ProductPriceInsight insight in group(records)) {
      if (insight.normalizedProductName == targetKey) {
        return insight;
      }
    }
    return null;
  }

  static String _groupKeyFor(ProductPriceRecord record) {
    if (record.normalizedProductName.trim().isNotEmpty) {
      return record.normalizedProductName.trim().toLowerCase();
    }
    return ProductNameNormalizer.normalize(record.productName);
  }

  static ProductPriceInsight _buildInsight(
    MapEntry<String, List<ProductPriceRecord>> entry,
  ) {
    final List<ProductPriceRecord> sortedRecords =
        List<ProductPriceRecord>.from(entry.value)
          ..sort(
            (ProductPriceRecord a, ProductPriceRecord b) =>
                b.purchaseDate.compareTo(a.purchaseDate),
          );

    final ProductPriceRecord latestRecord = sortedRecords.first;
    final List<double> prices = sortedRecords
        .map((ProductPriceRecord record) => record.totalPrice)
        .toList(growable: false);

    return ProductPriceInsight(
      normalizedProductName: entry.key,
      displayName: _displayName(sortedRecords),
      latestPrice: latestRecord.totalPrice,
      lowestPrice: prices.reduce(math.min),
      highestPrice: prices.reduce(math.max),
      recordCount: sortedRecords.length,
      latestStoreName: latestRecord.storeName,
      latestPurchaseDate: latestRecord.purchaseDate,
      records: sortedRecords,
      currency: latestRecord.currency,
    );
  }

  static String displayNameFor(List<ProductPriceRecord> records) {
    return _displayName(records);
  }

  static String _displayName(List<ProductPriceRecord> records) {
    for (final ProductPriceRecord record in records) {
      final String trimmed = record.productName.trim();
      if (trimmed.isNotEmpty) {
        return trimmed;
      }
    }
    return records.first.normalizedProductName;
  }
}
