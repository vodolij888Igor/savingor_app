import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:savingor_app/features/receipts/domain/models/receipt_source.dart';

/// A single product price observation from a saved receipt line item.
class ProductPriceRecord {
  const ProductPriceRecord({
    required this.id,
    required this.userId,
    required this.receiptId,
    required this.receiptItemId,
    required this.productName,
    required this.normalizedProductName,
    this.category,
    required this.storeName,
    this.storeId,
    this.placeId,
    this.storeAddress,
    required this.purchaseDate,
    required this.createdAt,
    required this.source,
    required this.quantity,
    this.unit,
    this.unitPrice,
    required this.totalPrice,
    this.currency = 'CAD',
    this.city,
    this.region,
    this.country,
    this.confidence,
    this.isAnonymizationReady = false,
  });

  final String id;
  final String userId;
  final String receiptId;
  final String receiptItemId;
  final String productName;
  final String normalizedProductName;
  final String? category;
  final String storeName;
  final String? storeId;
  final String? placeId;
  final String? storeAddress;
  final DateTime purchaseDate;
  final DateTime createdAt;
  final ReceiptSource source;
  final double quantity;
  final String? unit;
  final double? unitPrice;
  final double totalPrice;
  final String currency;
  final String? city;
  final String? region;
  final String? country;
  final double? confidence;
  final bool isAnonymizationReady;

  factory ProductPriceRecord.fromMap(Map<String, dynamic> map, String id) {
    return ProductPriceRecord(
      id: id,
      userId: (map['userId'] as String?) ?? '',
      receiptId: (map['receiptId'] as String?) ?? '',
      receiptItemId: (map['receiptItemId'] as String?) ?? '',
      productName: (map['productName'] as String?)?.trim() ?? '',
      normalizedProductName:
          (map['normalizedProductName'] as String?)?.trim() ?? '',
      category: _nullableString(map['category']),
      storeName: (map['storeName'] as String?)?.trim() ?? '',
      storeId: _nullableString(map['storeId']),
      placeId: _nullableString(map['placeId']),
      storeAddress: _nullableString(map['storeAddress']),
      purchaseDate: _parseDateTime(map['purchaseDate']),
      createdAt: _parseDateTime(map['createdAt']),
      source: ReceiptSource.fromValue(map['source'] as String?),
      quantity: _parseDouble(map['quantity'], fallback: 1),
      unit: _nullableString(map['unit']),
      unitPrice: _nullableDouble(map['unitPrice']),
      totalPrice: _parseDouble(map['totalPrice']),
      currency: _nullableString(map['currency']) ?? 'CAD',
      city: _nullableString(map['city']),
      region: _nullableString(map['region']),
      country: _nullableString(map['country']),
      confidence: _nullableDouble(map['confidence']),
      isAnonymizationReady: map['isAnonymizationReady'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'userId': userId,
      'receiptId': receiptId,
      'receiptItemId': receiptItemId,
      'productName': productName,
      'normalizedProductName': normalizedProductName,
      if (category != null) 'category': category,
      'storeName': storeName,
      if (storeId != null) 'storeId': storeId,
      if (placeId != null) 'placeId': placeId,
      if (storeAddress != null) 'storeAddress': storeAddress,
      'purchaseDate': Timestamp.fromDate(purchaseDate),
      'createdAt': Timestamp.fromDate(createdAt),
      'source': source.value,
      'quantity': quantity,
      if (unit != null) 'unit': unit,
      if (unitPrice != null) 'unitPrice': unitPrice,
      'totalPrice': totalPrice,
      'currency': currency,
      if (city != null) 'city': city,
      if (region != null) 'region': region,
      if (country != null) 'country': country,
      if (confidence != null) 'confidence': confidence,
      'isAnonymizationReady': isAnonymizationReady,
    };
  }

  static DateTime _parseDateTime(Object? value) {
    if (value is Timestamp) return value.toDate();
    if (value is DateTime) return value;
    if (value is String) {
      final DateTime? parsed = DateTime.tryParse(value);
      if (parsed != null) return parsed;
    }
    if (value is int) {
      return DateTime.fromMillisecondsSinceEpoch(value);
    }
    return DateTime.now();
  }

  static double _parseDouble(Object? value, {double fallback = 0}) {
    return _nullableDouble(value) ?? fallback;
  }

  static double? _nullableDouble(Object? value) {
    if (value == null) return null;
    if (value is double) return value;
    if (value is int) return value.toDouble();
    if (value is num) return value.toDouble();
    if (value is String) {
      return double.tryParse(value.trim());
    }
    return null;
  }

  static String? _nullableString(Object? value) {
    if (value == null) return null;
    if (value is! String) return value.toString();
    final String trimmed = value.trim();
    return trimmed.isEmpty ? null : trimmed;
  }
}
