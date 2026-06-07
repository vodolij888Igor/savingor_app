import 'package:savingor_app/features/analytics/domain/models/savings_recommendation.dart';
import 'package:savingor_app/features/price_memory/domain/models/product_price_record.dart';
import 'package:savingor_app/features/price_memory/domain/product_price_insights_grouper.dart';

/// Builds rule-based savings recommendations from real price memory.
abstract final class SavingsRecommendationService {
  static const double minAbsolutePriceDiff = 0.50;
  static const double minRelativePriceDiff = 0.10;
  static const int minBestStoreProductCount = 2;
  static const int maxRecommendations = 8;

  static List<SavingsRecommendation> compute(List<ProductPriceRecord> records) {
    if (records.isEmpty) {
      return const <SavingsRecommendation>[];
    }

    final Map<String, List<ProductPriceRecord>> grouped =
        ProductPriceInsightsGrouper.groupRecords(records);

    final List<SavingsRecommendation> recommendations =
        <SavingsRecommendation>[];

    final Map<String, int> bestStoreProductCounts = <String, int>{};

    for (final MapEntry<String, List<ProductPriceRecord>> entry
        in grouped.entries) {
      final List<ProductPriceRecord> sorted = List<ProductPriceRecord>.from(
        entry.value,
      )..sort(_compareRecordsChronologically);

      if (sorted.length < 2) {
        continue;
      }

      final String displayName =
          ProductPriceInsightsGrouper.displayNameFor(sorted);
      final int recordCount = sorted.length;
      final String dataBasis = _dataBasisText(recordCount);
      final ProductPriceRecord latest = sorted.last;
      final ProductPriceRecord bestRecord = _bestUnitPriceRecord(sorted);
      final double latestUnit = _effectiveUnitPrice(latest);
      final double bestUnit = _effectiveUnitPrice(bestRecord);
      final double highestUnit = _highestUnitPrice(sorted);
      final double lowestUnit = _bestUnitPrice(sorted);
      final String? bestStore = _trimmedStore(bestRecord.storeName);
      final String? latestStore = _trimmedStore(latest.storeName);

      if (bestStore != null) {
        bestStoreProductCounts[bestStore] =
            (bestStoreProductCounts[bestStore] ?? 0) + 1;
      }

      final SavingsRecommendation? storeSwitch = _buildStoreSwitchRecommendation(
        normalizedName: entry.key,
        displayName: displayName,
        latestUnit: latestUnit,
        bestUnit: bestUnit,
        latestStore: latestStore,
        bestStore: bestStore,
        dataBasis: dataBasis,
      );
      if (storeSwitch != null) {
        recommendations.add(storeSwitch);
      }

      final SavingsRecommendation? watchPrice = _buildWatchPriceRecommendation(
        normalizedName: entry.key,
        displayName: displayName,
        lowestUnit: lowestUnit,
        highestUnit: highestUnit,
        dataBasis: dataBasis,
      );
      if (watchPrice != null) {
        recommendations.add(watchPrice);
      }
    }

    for (final MapEntry<String, int> storeEntry in bestStoreProductCounts.entries) {
      if (storeEntry.value < minBestStoreProductCount) {
        continue;
      }

      final String storeName = storeEntry.key;
      final int productCount = storeEntry.value;
      final String productLabel =
          productCount == 1 ? 'product' : 'products';

      recommendations.add(
        SavingsRecommendation(
          type: SavingsRecommendationType.bestKnownStore,
          title: '$storeName has several of your best known prices',
          reason:
              '$productCount tracked $productLabel currently have their lowest known price at $storeName.',
          impactText: 'Use this store when it matches your shopping route.',
          priorityScore: productCount.toDouble(),
          storeName: storeName,
        ),
      );
    }

    recommendations.sort(
      (SavingsRecommendation a, SavingsRecommendation b) =>
          b.priorityScore.compareTo(a.priorityScore),
    );

    return recommendations.take(maxRecommendations).toList(growable: false);
  }

  static SavingsRecommendation? _buildStoreSwitchRecommendation({
    required String normalizedName,
    required String displayName,
    required double latestUnit,
    required double bestUnit,
    required String? latestStore,
    required String? bestStore,
    required String dataBasis,
  }) {
    if (bestStore == null || latestStore == null) {
      return null;
    }

    if (_storesMatch(latestStore, bestStore)) {
      return null;
    }

    if (latestUnit <= bestUnit) {
      return null;
    }

    final double perItemSaving = latestUnit - bestUnit;
    if (perItemSaving <= 0) {
      return null;
    }

    return SavingsRecommendation(
      type: SavingsRecommendationType.storeSwitch,
      title: 'Buy $displayName at $bestStore next time',
      reason:
          'You recently paid ${_formatCurrency(latestUnit)} at $latestStore. '
          'Your best known price is ${_formatCurrency(bestUnit)} at $bestStore.',
      impactText:
          'Potential saving: ${_formatCurrency(perItemSaving)} per item',
      priorityScore: perItemSaving,
      dataBasisText: dataBasis,
      normalizedProductName: normalizedName,
      storeName: bestStore,
    );
  }

  static SavingsRecommendation? _buildWatchPriceRecommendation({
    required String normalizedName,
    required String displayName,
    required double lowestUnit,
    required double highestUnit,
    required String dataBasis,
  }) {
    final double priceDifference = highestUnit - lowestUnit;
    if (priceDifference <= 0) {
      return null;
    }

    final double relativeDifference =
        lowestUnit > 0 ? priceDifference / lowestUnit : 0;

    if (priceDifference < minAbsolutePriceDiff &&
        relativeDifference < minRelativePriceDiff) {
      return null;
    }

    return SavingsRecommendation(
      type: SavingsRecommendationType.watchPrice,
      title: 'Watch $displayName prices closely',
      reason:
          'Your known prices range from ${_formatCurrency(lowestUnit)} to '
          '${_formatCurrency(highestUnit)}.',
      impactText: 'Price difference: ${_formatCurrency(priceDifference)}',
      priorityScore: priceDifference,
      dataBasisText: dataBasis,
      normalizedProductName: normalizedName,
    );
  }

  static String _dataBasisText(int recordCount) {
    final String label = recordCount == 1 ? 'record' : 'records';
    return 'Based on $recordCount price $label';
  }

  static String _formatCurrency(double amount) {
    return '\$${amount.toStringAsFixed(2)}';
  }

  static bool _storesMatch(String a, String b) {
    return a.trim().toLowerCase() == b.trim().toLowerCase();
  }

  static int _compareRecordsChronologically(
    ProductPriceRecord a,
    ProductPriceRecord b,
  ) {
    final int dateCompare = a.purchaseDate.compareTo(b.purchaseDate);
    if (dateCompare != 0) {
      return dateCompare;
    }

    return a.createdAt.compareTo(b.createdAt);
  }

  static double _effectiveUnitPrice(ProductPriceRecord record) {
    final double? unitPrice = record.unitPrice;
    if (unitPrice != null) {
      return unitPrice;
    }

    final double quantity = record.quantity;
    if (quantity > 0) {
      return record.totalPrice / quantity;
    }

    return record.totalPrice;
  }

  static double _bestUnitPrice(List<ProductPriceRecord> records) {
    return records
        .map(_effectiveUnitPrice)
        .reduce((double a, double b) => a < b ? a : b);
  }

  static double _highestUnitPrice(List<ProductPriceRecord> records) {
    return records
        .map(_effectiveUnitPrice)
        .reduce((double a, double b) => a > b ? a : b);
  }

  static ProductPriceRecord _bestUnitPriceRecord(
    List<ProductPriceRecord> records,
  ) {
    return records.reduce(
      (ProductPriceRecord current, ProductPriceRecord candidate) {
        final double currentUnit = _effectiveUnitPrice(current);
        final double candidateUnit = _effectiveUnitPrice(candidate);
        return candidateUnit < currentUnit ? candidate : current;
      },
    );
  }

  static String? _trimmedStore(String? storeName) {
    final String trimmed = storeName?.trim() ?? '';
    return trimmed.isEmpty ? null : trimmed;
  }
}
