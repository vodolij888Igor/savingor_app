import 'package:savingor_app/features/price_memory/domain/models/product_price_record.dart';

enum ProductBuyingAdviceKind {
  insufficientHistory,
  savingAvailable,
  paidBestPrice,
  noBetterPriceYet,
}

/// Rule-based buying advice from real product price records.
class ProductBuyingAdvice {
  const ProductBuyingAdvice({
    required this.kind,
    required this.currency,
    this.bestKnownUnitPrice,
    this.bestStore,
    this.latestPaidUnitPrice,
    this.latestStore,
    this.potentialSavingPerItem,
    this.recordCount = 0,
  });

  final ProductBuyingAdviceKind kind;
  final String currency;
  final double? bestKnownUnitPrice;
  final String? bestStore;
  final double? latestPaidUnitPrice;
  final String? latestStore;
  final double? potentialSavingPerItem;
  final int recordCount;

  String get neutralMessage {
    switch (kind) {
      case ProductBuyingAdviceKind.insufficientHistory:
        return 'Add more receipts with this item to unlock smarter buying advice.';
      case ProductBuyingAdviceKind.paidBestPrice:
        return 'You paid your best known price.';
      case ProductBuyingAdviceKind.noBetterPriceYet:
        return 'No better known price yet.';
      case ProductBuyingAdviceKind.savingAvailable:
        return '';
    }
  }

  String? get recommendationText {
    if (kind != ProductBuyingAdviceKind.savingAvailable) {
      return null;
    }

    final String? store = bestStore;
    if (store == null || store.isEmpty) {
      return 'Buy this item where you previously found the best price when it fits your shopping route.';
    }

    return 'Buy this item at $store when it fits your shopping route.';
  }

  String? get preferredStoreForShoppingList => bestStore ?? latestStore;

  double? get estimatedPriceForShoppingList =>
      bestKnownUnitPrice ?? latestPaidUnitPrice;
}

abstract final class ProductBuyingAdviceBuilder {
  static const double _priceEpsilon = 0.005;

  static ProductBuyingAdvice build(
    List<ProductPriceRecord> records, {
    String currency = 'CAD',
  }) {
    if (records.length < 2) {
      final ProductPriceRecord onlyRecord = records.first;
      return ProductBuyingAdvice(
        kind: ProductBuyingAdviceKind.insufficientHistory,
        currency: onlyRecord.currency.trim().isEmpty ? currency : onlyRecord.currency,
        bestKnownUnitPrice: _effectiveUnitPrice(onlyRecord),
        bestStore: _trimmedStore(onlyRecord.storeName),
        latestPaidUnitPrice: _effectiveUnitPrice(onlyRecord),
        latestStore: _trimmedStore(onlyRecord.storeName),
        recordCount: records.length,
      );
    }

    final List<ProductPriceRecord> sorted = List<ProductPriceRecord>.from(records)
      ..sort(_compareRecordsChronologically);

    final ProductPriceRecord latest = sorted.last;
    final ProductPriceRecord bestRecord = _bestUnitPriceRecord(sorted);
    final double latestUnit = _effectiveUnitPrice(latest);
    final double bestUnit = _effectiveUnitPrice(bestRecord);
    final String? bestStore = _trimmedStore(bestRecord.storeName);
    final String? latestStore = _trimmedStore(latest.storeName);
    final String resolvedCurrency =
        latest.currency.trim().isEmpty ? currency : latest.currency;

    if (latestUnit > bestUnit + _priceEpsilon) {
      return ProductBuyingAdvice(
        kind: ProductBuyingAdviceKind.savingAvailable,
        currency: resolvedCurrency,
        bestKnownUnitPrice: bestUnit,
        bestStore: bestStore,
        latestPaidUnitPrice: latestUnit,
        latestStore: latestStore,
        potentialSavingPerItem: latestUnit - bestUnit,
        recordCount: sorted.length,
      );
    }

    if (bestStore == null && latestStore == null) {
      return ProductBuyingAdvice(
        kind: ProductBuyingAdviceKind.noBetterPriceYet,
        currency: resolvedCurrency,
        bestKnownUnitPrice: bestUnit,
        latestPaidUnitPrice: latestUnit,
        recordCount: sorted.length,
      );
    }

    return ProductBuyingAdvice(
      kind: ProductBuyingAdviceKind.paidBestPrice,
      currency: resolvedCurrency,
      bestKnownUnitPrice: bestUnit,
      bestStore: bestStore,
      latestPaidUnitPrice: latestUnit,
      latestStore: latestStore,
      recordCount: sorted.length,
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
