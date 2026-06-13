import 'package:flutter/foundation.dart';

import 'package:savingor_app/features/price_memory/data/price_memory_firestore_service.dart';
import 'package:savingor_app/features/price_memory/domain/models/product_price_record.dart';
import 'package:savingor_app/features/price_memory/domain/product_name_normalizer.dart';
import 'package:savingor_app/features/receipts/domain/models/receipt.dart';
import 'package:savingor_app/features/receipts/domain/models/receipt_item.dart';

/// Builds and syncs product price records from saved receipts.
class PriceMemoryRepository {
  PriceMemoryRepository({PriceMemoryFirestoreService? service})
      : _service = service ?? PriceMemoryFirestoreService();

  final PriceMemoryFirestoreService _service;

  /// Deletes existing records for [receipt], then recreates from line items.
  Future<void> syncFromReceipt(Receipt receipt) async {
    if (receipt.id.isEmpty || receipt.userId.isEmpty) {
      return;
    }

    final int deletedCount =
        await _service.deleteForReceipt(receipt.userId, receipt.id);
    debugPrint(
      'PriceMemory: deleted $deletedCount old records for receiptId=${receipt.id}',
    );

    if (!receipt.hasItems) {
      return;
    }

    final List<ProductPriceRecord> records = _buildRecordsFromReceipt(receipt);
    await _service.createRecords(receipt.userId, records);
    debugPrint(
      'PriceMemory: created ${records.length} price records for receiptId=${receipt.id}',
    );
  }

  Future<void> deleteForReceipt({
    required String userId,
    required String receiptId,
  }) async {
    final int deletedCount = await _service.deleteForReceipt(userId, receiptId);
    debugPrint(
      'PriceMemory: deleted $deletedCount price records for receiptId=$receiptId',
    );
  }

  List<ProductPriceRecord> _buildRecordsFromReceipt(Receipt receipt) {
    final DateTime now = DateTime.now();

    return receipt.items
        .where((ReceiptItem item) => item.name.trim().isNotEmpty)
        .map((ReceiptItem item) {
      final String normalizedName =
          item.normalizedName?.trim().isNotEmpty == true
              ? item.normalizedName!.trim()
              : ProductNameNormalizer.normalize(item.name);

      return ProductPriceRecord(
        id: '',
        userId: receipt.userId,
        receiptId: receipt.id,
        receiptItemId: item.id,
        productName: item.name.trim(),
        normalizedProductName: normalizedName,
        category: item.category,
        storeName: receipt.storeName,
        storeId: receipt.storeId,
        placeId: receipt.placeId,
        storeAddress: receipt.storeAddress,
        purchaseDate: receipt.purchaseDate,
        createdAt: now,
        source: receipt.source,
        quantity: item.quantity,
        unit: item.unit,
        unitPrice: item.unitPrice,
        totalPrice: item.totalPrice,
        currency: receipt.currency,
        confidence: item.confidence,
        isAnonymizationReady: false,
      );
    }).toList(growable: false);
  }
}
