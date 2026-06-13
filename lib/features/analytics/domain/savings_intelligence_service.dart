import 'package:savingor_app/features/analytics/domain/models/product_savings_insight.dart';
import 'package:savingor_app/features/analytics/domain/models/savings_summary.dart';
import 'package:savingor_app/features/price_memory/domain/models/product_price_record.dart';
import 'package:savingor_app/features/price_memory/domain/product_price_insights_grouper.dart';

/// Computes savings value from receipt-linked price memory only.
abstract final class SavingsIntelligenceService {
  static SavingsSummary compute(List<ProductPriceRecord> records) {
    final DateTime now = DateTime.now();
    final DateTime monthStart = DateTime(now.year, now.month);
    final DateTime yearStart = DateTime(now.year);

    final Map<String, List<ProductPriceRecord>> grouped =
        ProductPriceInsightsGrouper.groupRecords(records);

    double estimatedSavedThisMonth = 0;
    double estimatedSavedThisYear = 0;
    double potentialMissedThisMonth = 0;
    double potentialMissedThisYear = 0;
    var hasCalculableData = false;

    final List<ProductSavingsInsight> productInsights =
        <ProductSavingsInsight>[];

    for (final MapEntry<String, List<ProductPriceRecord>> entry
        in grouped.entries) {
      final List<ProductPriceRecord> sorted = List<ProductPriceRecord>.from(
        entry.value,
      )..sort(_compareRecordsChronologically);

      double productEstimatedSaved = 0;
      double productPotentialMissed = 0;

      for (var index = 0; index < sorted.length; index++) {
        final ProductPriceRecord current = sorted[index];
        final List<ProductPriceRecord> priorRecords = sorted.sublist(0, index);

        if (priorRecords.isEmpty) {
          continue;
        }

        hasCalculableData = true;

        final double paidUnit = _effectiveUnitPrice(current);
        final double quantity = _effectiveQuantity(current);
        final double averageUnit = _averageUnitPrice(priorRecords);
        final double bestUnit = _bestUnitPrice(priorRecords);

        if (paidUnit < averageUnit) {
          final double saved = (averageUnit - paidUnit) * quantity;
          productEstimatedSaved += saved;

          if (!_isBeforePeriod(current.purchaseDate, monthStart)) {
            estimatedSavedThisMonth += saved;
          }
          if (!_isBeforePeriod(current.purchaseDate, yearStart)) {
            estimatedSavedThisYear += saved;
          }
        }

        if (paidUnit > bestUnit) {
          final double missed = (paidUnit - bestUnit) * quantity;
          productPotentialMissed += missed;

          if (!_isBeforePeriod(current.purchaseDate, monthStart)) {
            potentialMissedThisMonth += missed;
          }
          if (!_isBeforePeriod(current.purchaseDate, yearStart)) {
            potentialMissedThisYear += missed;
          }
        }
      }

      if (sorted.length < 2) {
        continue;
      }

      final ProductPriceRecord latest = sorted.last;
      final double latestUnit = _effectiveUnitPrice(latest);
      final ProductPriceRecord bestRecord = _bestUnitPriceRecord(sorted);
      final String? bestStore = _trimmedStore(bestRecord.storeName);
      final String? latestStore = _trimmedStore(latest.storeName);

      productInsights.add(
        ProductSavingsInsight(
          normalizedName: entry.key,
          displayName: ProductPriceInsightsGrouper.displayNameFor(sorted),
          estimatedSaved: productEstimatedSaved,
          potentialMissed: productPotentialMissed,
          latestPaidPrice: latestUnit,
          bestKnownPrice: _effectiveUnitPrice(bestRecord),
          averageKnownPrice: _averageUnitPrice(sorted),
          recordCount: sorted.length,
          bestStore: bestStore,
          latestStore: latestStore,
          currency: latest.currency,
        ),
      );
    }

    productInsights.sort(
      (ProductSavingsInsight a, ProductSavingsInsight b) =>
          b.topSavingsScore.compareTo(a.topSavingsScore),
    );

    final List<ProductSavingsInsight> topProducts = productInsights
        .where(
          (ProductSavingsInsight insight) =>
              insight.estimatedSaved > 0 || insight.potentialMissed > 0,
        )
        .take(5)
        .toList(growable: false);

    const double subscriptionPrice = SavingsSummary.defaultSubscriptionPrice;
    final double monthlyRoiAmount = estimatedSavedThisMonth - subscriptionPrice;
    final double? monthlyRoiMultiplier = estimatedSavedThisMonth > 0
        ? estimatedSavedThisMonth / subscriptionPrice
        : null;

    return SavingsSummary(
      estimatedSavedThisMonth: estimatedSavedThisMonth,
      estimatedSavedThisYear: estimatedSavedThisYear,
      potentialMissedThisMonth: potentialMissedThisMonth,
      potentialMissedThisYear: potentialMissedThisYear,
      subscriptionPrice: subscriptionPrice,
      monthlyRoiAmount: monthlyRoiAmount,
      monthlyRoiMultiplier: monthlyRoiMultiplier,
      trackedProductCount: grouped.length,
      productsWithSavingsCount: productInsights
          .where((ProductSavingsInsight insight) => insight.estimatedSaved > 0)
          .length,
      productsWithMissedSavingsCount: productInsights
          .where(
            (ProductSavingsInsight insight) => insight.potentialMissed > 0,
          )
          .length,
      topProducts: topProducts,
      hasCalculableData: hasCalculableData,
    );
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

  static bool _isBeforePeriod(DateTime date, DateTime periodStart) {
    return date.isBefore(periodStart);
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

  static double _effectiveQuantity(ProductPriceRecord record) {
    return record.quantity > 0 ? record.quantity : 1;
  }

  static double _averageUnitPrice(List<ProductPriceRecord> records) {
    if (records.isEmpty) {
      return 0;
    }

    final double total = records.fold<double>(
      0,
      (double sum, ProductPriceRecord record) =>
          sum + _effectiveUnitPrice(record),
    );

    return total / records.length;
  }

  static double _bestUnitPrice(List<ProductPriceRecord> records) {
    return records
        .map(_effectiveUnitPrice)
        .reduce((double a, double b) => a < b ? a : b);
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
