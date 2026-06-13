import 'dart:math' as math;

import 'package:savingor_app/features/price_memory/domain/models/basket_optimization_result.dart';
import 'package:savingor_app/features/price_memory/domain/models/basket_price_recommendation.dart';
import 'package:savingor_app/features/price_memory/domain/models/product_price_record.dart';
import 'package:savingor_app/features/price_memory/domain/product_name_normalizer.dart';
import 'package:savingor_app/features/shopping/domain/models/shopping_list_item.dart';
import 'package:savingor_app/features/shopping/domain/shopping_basket_item_grouper.dart';

/// Matches shopping list items to price memory and builds basket recommendations.
///
/// UI-independent: pass any [shoppingItems] collection (one list or merged from
/// all active lists) plus [priceRecords]. Callers resolve which items to include;
/// this class only performs matching and optimization.
abstract final class BasketOptimizer {
  static BasketOptimizationResult optimize({
    required List<ShoppingListItem> shoppingItems,
    required List<ProductPriceRecord> priceRecords,
    int? activeListsIncluded,
  }) {
    final List<ShoppingListItem> uncheckedItems =
        ShoppingBasketItemGrouper.groupByProduct(
      shoppingItems,
    );

    if (uncheckedItems.isEmpty) {
      return BasketOptimizationResult(
        recommendations: const <BasketPriceRecommendation>[],
        storePlan: const <BasketStorePlanEntry>[],
        estimatedBestTotal: 0,
        estimatedLatestTotal: 0,
        totalPotentialSaving: 0,
        matchedItemsCount: 0,
        unmatchedItemsCount: 0,
        activeListsIncluded: activeListsIncluded,
      );
    }

    final Map<String, List<ProductPriceRecord>> recordsByProduct =
        _indexRecordsByProduct(priceRecords);

    final List<BasketPriceRecommendation> recommendations = uncheckedItems
        .map(
          (ShoppingListItem item) => _recommendForItem(
            item: item,
            recordsByProduct: recordsByProduct,
          ),
        )
        .toList(growable: false);

    recommendations.sort(_compareRecommendations);

    double estimatedBestTotal = 0;
    double estimatedLatestTotal = 0;
    int matchedItemsCount = 0;
    int unmatchedItemsCount = 0;

    for (final BasketPriceRecommendation recommendation in recommendations) {
      if (recommendation.hasPriceData) {
        matchedItemsCount += 1;
        estimatedBestTotal += recommendation.bestLineTotal;
        estimatedLatestTotal += recommendation.latestLineTotal;
      } else {
        unmatchedItemsCount += 1;
      }
    }

    final double totalPotentialSaving =
        math.max(0, estimatedLatestTotal - estimatedBestTotal);

    return BasketOptimizationResult(
      recommendations: recommendations,
      storePlan: _buildStorePlan(recommendations),
      estimatedBestTotal: estimatedBestTotal,
      estimatedLatestTotal: estimatedLatestTotal,
      totalPotentialSaving: totalPotentialSaving,
      matchedItemsCount: matchedItemsCount,
      unmatchedItemsCount: unmatchedItemsCount,
      activeListsIncluded: activeListsIncluded,
    );
  }

  static Map<String, List<ProductPriceRecord>> _indexRecordsByProduct(
    List<ProductPriceRecord> priceRecords,
  ) {
    final Map<String, List<ProductPriceRecord>> indexed =
        <String, List<ProductPriceRecord>>{};

    for (final ProductPriceRecord record in priceRecords) {
      final String key = _recordKey(record);
      if (key.isEmpty) continue;
      indexed.putIfAbsent(key, () => <ProductPriceRecord>[]).add(record);
    }

    return indexed;
  }

  static String _recordKey(ProductPriceRecord record) {
    if (record.normalizedProductName.trim().isNotEmpty) {
      return record.normalizedProductName.trim().toLowerCase();
    }
    return ProductNameNormalizer.normalize(record.productName);
  }

  static String _itemKey(ShoppingListItem item) {
    return ProductNameNormalizer.normalize(item.name);
  }

  static BasketPriceRecommendation _recommendForItem({
    required ShoppingListItem item,
    required Map<String, List<ProductPriceRecord>> recordsByProduct,
  }) {
    final String normalizedName = _itemKey(item);
    final List<ProductPriceRecord> matches =
        recordsByProduct[normalizedName] ?? const <ProductPriceRecord>[];

    if (matches.isEmpty) {
      return BasketPriceRecommendation(
        shoppingItemId: item.id,
        shoppingItemName: item.name.trim(),
        normalizedProductName: normalizedName,
        shoppingQuantity: item.quantity,
        hasPriceData: false,
        message: 'Add receipts with this item to unlock recommendations.',
      );
    }

    final ProductPriceRecord bestRecord = _selectBestRecord(matches);
    final ProductPriceRecord latestRecord = _selectLatestRecord(matches);
    final double bestUnit = _effectiveUnitPrice(bestRecord);
    final double latestUnit = _effectiveUnitPrice(latestRecord);
    final double savingPerUnit =
        latestUnit > bestUnit ? latestUnit - bestUnit : 0;

    return BasketPriceRecommendation(
      shoppingItemId: item.id,
      shoppingItemName: item.name.trim(),
      normalizedProductName: normalizedName,
      shoppingQuantity: item.quantity,
      hasPriceData: true,
      bestKnownPrice: bestUnit,
      bestStoreName: bestRecord.storeName,
      latestKnownPrice: latestUnit,
      latestStoreName: latestRecord.storeName,
      potentialSavingPerItem: savingPerUnit * item.quantity,
      currency: bestRecord.currency,
      recordCount: matches.length,
    );
  }

  static ProductPriceRecord _selectBestRecord(
      List<ProductPriceRecord> records) {
    return records.reduce(
      (ProductPriceRecord current, ProductPriceRecord candidate) {
        final double currentUnit = _effectiveUnitPrice(current);
        final double candidateUnit = _effectiveUnitPrice(candidate);
        if (candidateUnit < currentUnit) return candidate;
        if (candidateUnit > currentUnit) return current;
        return candidate.purchaseDate.isAfter(current.purchaseDate)
            ? candidate
            : current;
      },
    );
  }

  static ProductPriceRecord _selectLatestRecord(
      List<ProductPriceRecord> records) {
    return records.reduce(
      (ProductPriceRecord current, ProductPriceRecord candidate) =>
          candidate.purchaseDate.isAfter(current.purchaseDate)
              ? candidate
              : current,
    );
  }

  static double _effectiveUnitPrice(ProductPriceRecord record) {
    if (record.unitPrice != null) {
      return record.unitPrice!;
    }
    if (record.quantity > 0) {
      return record.totalPrice / record.quantity;
    }
    return record.totalPrice;
  }

  static List<BasketStorePlanEntry> _buildStorePlan(
    List<BasketPriceRecommendation> recommendations,
  ) {
    final Map<String, List<BasketStorePlanItem>> grouped =
        <String, List<BasketStorePlanItem>>{};

    for (final BasketPriceRecommendation recommendation in recommendations) {
      if (!recommendation.hasPriceData ||
          recommendation.bestStoreName == null ||
          recommendation.bestKnownPrice == null) {
        continue;
      }

      grouped
          .putIfAbsent(
              recommendation.bestStoreName!, () => <BasketStorePlanItem>[])
          .add(
            BasketStorePlanItem(
              shoppingItemName: recommendation.shoppingItemName,
              unitPrice: recommendation.bestKnownPrice!,
              quantity: recommendation.shoppingQuantity,
            ),
          );
    }

    final List<BasketStorePlanEntry> plan = grouped.entries.map(
      (MapEntry<String, List<BasketStorePlanItem>> entry) {
        final double storeTotal = entry.value.fold<double>(
          0,
          (double sum, BasketStorePlanItem item) => sum + item.lineTotal,
        );
        return BasketStorePlanEntry(
          storeName: entry.key,
          items: entry.value,
          estimatedStoreTotal: storeTotal,
        );
      },
    ).toList(growable: false)
      ..sort(
        (BasketStorePlanEntry a, BasketStorePlanEntry b) =>
            b.estimatedStoreTotal.compareTo(a.estimatedStoreTotal),
      );

    return plan;
  }

  static int _compareRecommendations(
    BasketPriceRecommendation a,
    BasketPriceRecommendation b,
  ) {
    if (a.hasPriceData && !b.hasPriceData) return -1;
    if (!a.hasPriceData && b.hasPriceData) return 1;

    if (a.hasPriceData && b.hasPriceData) {
      final int bySaving =
          b.potentialSavingPerItem.compareTo(a.potentialSavingPerItem);
      if (bySaving != 0) return bySaving;
      return b.recordCount.compareTo(a.recordCount);
    }

    return a.shoppingItemName.toLowerCase().compareTo(
          b.shoppingItemName.toLowerCase(),
        );
  }
}
