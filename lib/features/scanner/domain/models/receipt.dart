import 'package:cloud_firestore/cloud_firestore.dart';

/// Grocery receipt document for the scanner / receipt tracker feature.
class Receipt {
  const Receipt({
    required this.id,
    required this.userId,
    required this.storeName,
    required this.date,
    required this.category,
    required this.total,
    this.notes,
    required this.createdAt,
    required this.updatedAt,
  });

  final String id;
  final String userId;
  final String storeName;
  final DateTime date;
  final String category;
  final double total;
  final String? notes;
  final DateTime createdAt;
  final DateTime updatedAt;

  factory Receipt.fromMap(Map<String, dynamic> map, String id) {
    return Receipt(
      id: id,
      userId: (map['userId'] as String?) ?? '',
      storeName: (map['storeName'] as String?)?.trim() ?? '',
      date: _parseDateTime(map['date']),
      category: (map['category'] as String?)?.trim() ?? '',
      total: _parseTotal(map['total']),
      notes: _parseNullableString(map['notes']),
      createdAt: _parseDateTime(map['createdAt']),
      updatedAt: _parseDateTime(map['updatedAt']),
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'userId': userId,
      'storeName': storeName,
      'date': Timestamp.fromDate(date),
      'category': category,
      'total': total,
      if (notes != null) 'notes': notes,
      'createdAt': Timestamp.fromDate(createdAt),
      'updatedAt': Timestamp.fromDate(updatedAt),
    };
  }

  Receipt copyWith({
    String? id,
    String? userId,
    String? storeName,
    DateTime? date,
    String? category,
    double? total,
    String? notes,
    bool clearNotes = false,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Receipt(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      storeName: storeName ?? this.storeName,
      date: date ?? this.date,
      category: category ?? this.category,
      total: total ?? this.total,
      notes: clearNotes ? null : (notes ?? this.notes),
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
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

  static double _parseTotal(Object? value) {
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

  static String? _parseNullableString(Object? value) {
    if (value == null) return null;
    if (value is! String) return value.toString();
    final String trimmed = value.trim();
    return trimmed.isEmpty ? null : trimmed;
  }
}
