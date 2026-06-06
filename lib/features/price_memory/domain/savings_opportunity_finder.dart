import 'package:savingor_app/features/price_memory/domain/models/product_price_insight.dart';
import 'package:savingor_app/features/price_memory/domain/models/product_price_record.dart';
import 'package:savingor_app/features/price_memory/domain/models/savings_opportunity.dart';
import 'package:savingor_app/features/price_memory/domain/product_price_insights_grouper.dart';

/// Finds savings opportunities from grouped product price memory.
abstract final class SavingsOpportunityFinder {
  static List<SavingsOpportunity> find(List<ProductPriceRecord> records) {
    final List<ProductPriceInsight> insights =
        ProductPriceInsightsGrouper.group(records);

    final List<SavingsOpportunity> opportunities = <SavingsOpportunity>[];

    for (final ProductPriceInsight insight in insights) {
      final SavingsOpportunity? opportunity = _fromInsight(insight);
      if (opportunity != null) {
        opportunities.add(opportunity);
      }
    }

    opportunities.sort(
      (SavingsOpportunity a, SavingsOpportunity b) {
        final int bySaving = b.priceDifference.compareTo(a.priceDifference);
        if (bySaving != 0) {
          return bySaving;
        }
        return b.latestPurchaseDate.compareTo(a.latestPurchaseDate);
      },
    );

    return opportunities;
  }

  static SavingsOpportunity? _fromInsight(ProductPriceInsight insight) {
    if (insight.recordCount < 2) {
      return null;
    }

    if (insight.lowestPrice >= insight.latestPrice) {
      return null;
    }

    final double priceDifference = insight.latestPrice - insight.lowestPrice;
    if (priceDifference <= 0) {
      return null;
    }

    final ProductPriceRecord? lowestRecord =
        _recordForLowestPrice(insight.records, insight.lowestPrice);
    if (lowestRecord == null) {
      return null;
    }

    final double percentageDifference =
        insight.latestPrice == 0 ? 0 : (priceDifference / insight.latestPrice) * 100;

    return SavingsOpportunity(
      id: insight.normalizedProductName,
      normalizedProductName: insight.normalizedProductName,
      displayName: insight.displayName,
      latestPrice: insight.latestPrice,
      latestStoreName: insight.latestStoreName,
      latestPurchaseDate: insight.latestPurchaseDate,
      lowestPrice: insight.lowestPrice,
      lowestStoreName: lowestRecord.storeName,
      lowestPurchaseDate: lowestRecord.purchaseDate,
      priceDifference: priceDifference,
      percentageDifference: percentageDifference,
      recordCount: insight.recordCount,
      currency: insight.currency,
    );
  }

  static ProductPriceRecord? _recordForLowestPrice(
    List<ProductPriceRecord> records,
    double lowestPrice,
  ) {
    ProductPriceRecord? bestMatch;

    for (final ProductPriceRecord record in records) {
      if (record.totalPrice != lowestPrice) {
        continue;
      }
      if (bestMatch == null ||
          record.purchaseDate.isAfter(bestMatch.purchaseDate)) {
        bestMatch = record;
      }
    }

    return bestMatch;
  }
}
