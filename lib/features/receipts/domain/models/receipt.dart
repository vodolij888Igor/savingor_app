import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:savingor_app/features/receipts/domain/models/receipt_item.dart';
import 'package:savingor_app/features/receipts/domain/models/receipt_source.dart';

/// Grocery receipt with line items for receipt intelligence.
class Receipt {
  const Receipt({
    required this.id,
    required this.userId,
    required this.storeName,
    this.storeId,
    this.placeId,
    this.storeAddress,
    required this.purchaseDate,
    required this.createdAt,
    required this.updatedAt,
    this.subtotal,
    this.tax,
    required this.total,
    this.currency = 'CAD',
    this.source = ReceiptSource.manual,
    this.notes,
    this.categorySummary,
    this.items = const <ReceiptItem>[],
  });

  final String id;
  final String userId;
  final String storeName;
  final String? storeId;
  final String? placeId;
  final String? storeAddress;
  final DateTime purchaseDate;
  final DateTime createdAt;
  final DateTime updatedAt;
  final double? subtotal;
  final double? tax;
  final double total;
  final String currency;
  final ReceiptSource source;
  final String? notes;
  final String? categorySummary;
  final List<ReceiptItem> items;

  /// Legacy alias used by analytics and older screens.
  DateTime get date => purchaseDate;

  /// Legacy alias — prefer [categorySummary].
  String get category {
    if (categorySummary != null && categorySummary!.trim().isNotEmpty) {
      return categorySummary!.trim();
    }
    return 'Grocery';
  }

  int get itemCount => items.length;

  bool get hasItems => items.isNotEmpty;

  bool get hasAddress =>
      storeAddress != null && storeAddress!.trim().isNotEmpty;

  String? get displayAddress =>
      hasAddress ? storeAddress!.trim() : null;

  String get formattedTotal => '\$${total.toStringAsFixed(2)}';

  String get formattedCurrencyTotal {
    if (currency == 'CAD') {
      return formattedTotal;
    }
    return '$currency ${total.toStringAsFixed(2)}';
  }

  String get statusText {
    switch (source) {
      case ReceiptSource.scanned:
        return 'Scanned receipt';
      case ReceiptSource.gallery:
        return 'Gallery receipt';
      case ReceiptSource.imported:
        return 'Imported receipt';
      case ReceiptSource.manual:
        return 'Manual receipt';
      case ReceiptSource.unknown:
        return 'Receipt';
    }
  }

  String get notesSectionTitle => source.notesSectionTitle;

  double get computedItemsTotal {
    if (items.isEmpty) {
      return 0;
    }
    return items.fold<double>(
      0,
      (double sum, ReceiptItem item) => sum + item.totalPrice,
    );
  }

  factory Receipt.fromMap(Map<String, dynamic> map, String id) {
    final List<ReceiptItem> parsedItems = _parseItems(map['items']);
    final String? legacyCategory = _nullableString(map['category']);

    return Receipt(
      id: id,
      userId: (map['userId'] as String?) ?? '',
      storeName: (map['storeName'] as String?)?.trim() ?? '',
      storeId: _nullableString(map['storeId']),
      placeId: _nullableString(map['placeId']),
      storeAddress: _nullableString(map['storeAddress']),
      purchaseDate: _parseDateTime(map['purchaseDate'] ?? map['date']),
      createdAt: _parseDateTime(map['createdAt']),
      updatedAt: _parseDateTime(map['updatedAt']),
      subtotal: _nullableDouble(map['subtotal']),
      tax: _nullableDouble(map['tax']),
      total: _parseDouble(map['total']),
      currency: _nullableString(map['currency']) ?? 'CAD',
      source: _parseSource(map, legacyNotes: map['notes']),
      notes: _nullableString(map['notes']),
      categorySummary:
          _nullableString(map['categorySummary']) ?? legacyCategory,
      items: parsedItems,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'userId': userId,
      'storeName': storeName,
      if (storeId != null) 'storeId': storeId,
      if (placeId != null) 'placeId': placeId,
      if (storeAddress != null) 'storeAddress': storeAddress,
      'purchaseDate': Timestamp.fromDate(purchaseDate),
      'createdAt': Timestamp.fromDate(createdAt),
      'updatedAt': Timestamp.fromDate(updatedAt),
      if (subtotal != null) 'subtotal': subtotal,
      if (tax != null) 'tax': tax,
      'total': total,
      'currency': currency,
      'source': source.value,
      if (notes != null) 'notes': notes,
      if (categorySummary != null) 'categorySummary': categorySummary,
      'items': items.map((ReceiptItem item) => item.toMap()).toList(),
    };
  }

  Receipt copyWith({
    String? id,
    String? userId,
    String? storeName,
    String? storeId,
    String? placeId,
    String? storeAddress,
    DateTime? purchaseDate,
    DateTime? createdAt,
    DateTime? updatedAt,
    double? subtotal,
    double? tax,
    double? total,
    String? currency,
    ReceiptSource? source,
    String? notes,
    String? categorySummary,
    List<ReceiptItem>? items,
    bool clearStoreId = false,
    bool clearPlaceId = false,
    bool clearStoreAddress = false,
    bool clearSubtotal = false,
    bool clearTax = false,
    bool clearNotes = false,
    bool clearCategorySummary = false,
  }) {
    return Receipt(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      storeName: storeName ?? this.storeName,
      storeId: clearStoreId ? null : (storeId ?? this.storeId),
      placeId: clearPlaceId ? null : (placeId ?? this.placeId),
      storeAddress:
          clearStoreAddress ? null : (storeAddress ?? this.storeAddress),
      purchaseDate: purchaseDate ?? this.purchaseDate,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      subtotal: clearSubtotal ? null : (subtotal ?? this.subtotal),
      tax: clearTax ? null : (tax ?? this.tax),
      total: total ?? this.total,
      currency: currency ?? this.currency,
      source: source ?? this.source,
      notes: clearNotes ? null : (notes ?? this.notes),
      categorySummary: clearCategorySummary
          ? null
          : (categorySummary ?? this.categorySummary),
      items: items ?? this.items,
    );
  }

  static List<ReceiptItem> _parseItems(Object? value) {
    if (value is! List<dynamic>) {
      return const <ReceiptItem>[];
    }

    final List<ReceiptItem> items = <ReceiptItem>[];
    for (final dynamic rawItem in value) {
      if (rawItem is! Map<String, dynamic>) {
        continue;
      }
      try {
        final ReceiptItem item = ReceiptItem.fromMap(rawItem);
        if (item.name.isNotEmpty) {
          items.add(item);
        }
      } catch (_) {
        // Skip malformed line items.
      }
    }
    return items;
  }

  static ReceiptSource _parseSource(
    Map<String, dynamic> map, {
    Object? legacyNotes,
  }) {
    final String? explicit = _nullableString(map['source']);
    if (explicit != null) {
      return ReceiptSource.fromValue(explicit);
    }

    final String? notes = _nullableString(legacyNotes);
    if (notes != null && notes.length > 120) {
      return ReceiptSource.scanned;
    }

    return ReceiptSource.manual;
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

  static double _parseDouble(Object? value) {
    if (value == null) return 0;
    if (value is double) return value;
    if (value is int) return value.toDouble();
    if (value is num) return value.toDouble();
    if (value is String) {
      final String normalized =
          value.trim().replaceAll(RegExp(r'[^\d.\-]'), '');
      if (normalized.isEmpty) return 0;
      return double.tryParse(normalized) ?? 0;
    }
    return 0;
  }

  static double? _nullableDouble(Object? value) {
    if (value == null) return null;
    final double parsed = _parseDouble(value);
    return parsed;
  }

  static String? _nullableString(Object? value) {
    if (value == null) return null;
    if (value is! String) return value.toString();
    final String trimmed = value.trim();
    return trimmed.isEmpty ? null : trimmed;
  }
}
