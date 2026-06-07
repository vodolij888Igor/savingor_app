import 'package:cloud_firestore/cloud_firestore.dart';

/// Line item at `users/{uid}/shoppingLists/{listId}/items/{itemId}`.
class ShoppingListItem {
  const ShoppingListItem({
    required this.id,
    required this.name,
    required this.quantity,
    required this.isCompleted,
    this.completedAt,
    this.store,
    this.unitPrice,
    this.dealId,
    this.category,
    this.notes,
    this.sortOrder = 0,
    required this.createdAt,
    required this.updatedAt,
  });

  final String id;
  final String name;
  final int quantity;
  final bool isCompleted;
  final DateTime? completedAt;
  final String? store;
  final double? unitPrice;
  final String? dealId;
  final String? category;
  final String? notes;
  final int sortOrder;
  final DateTime createdAt;
  final DateTime updatedAt;

  bool get isActive => !isCompleted;

  double? get lineTotal {
    if (unitPrice == null || isCompleted) return null;
    return unitPrice! * quantity;
  }

  factory ShoppingListItem.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
  ) {
    final Map<String, dynamic> data = snapshot.data() ?? <String, dynamic>{};
    return ShoppingListItem(
      id: snapshot.id,
      name: (data['name'] as String?)?.trim() ?? '',
      quantity: ((data['quantity'] as num?)?.toInt() ?? 1).clamp(1, 999),
      isCompleted: _readCompletedFlag(data),
      completedAt: _timestampToNullableDate(data['completedAt']),
      store: (data['store'] as String?)?.trim(),
      unitPrice: (data['unitPrice'] as num?)?.toDouble(),
      dealId: data['dealId'] as String?,
      category: (data['category'] as String?)?.trim(),
      notes: (data['notes'] as String?)?.trim(),
      sortOrder: (data['sortOrder'] as num?)?.toInt() ?? 0,
      createdAt: _timestampToDate(data['createdAt']),
      updatedAt: _timestampToDate(data['updatedAt']),
    );
  }

  static bool _readCompletedFlag(Map<String, dynamic> data) {
    if (data.containsKey('isCompleted')) {
      return data['isCompleted'] as bool? ?? false;
    }
    return data['isChecked'] as bool? ?? false;
  }

  Map<String, dynamic> toFirestore({bool isCreate = false}) {
    final double? safeUnitPrice = _safeUnitPrice(unitPrice);

    return <String, dynamic>{
      'name': name,
      'quantity': quantity,
      'isCompleted': isCompleted,
      if (isCompleted && completedAt != null)
        'completedAt': Timestamp.fromDate(completedAt!)
      else if (!isCreate)
        'completedAt': FieldValue.delete(),
      if (store != null && store!.isNotEmpty) 'store': store,
      if (safeUnitPrice != null) 'unitPrice': safeUnitPrice,
      if (dealId != null) 'dealId': dealId,
      if (category != null && category!.isNotEmpty) 'category': category,
      if (notes != null && notes!.isNotEmpty) 'notes': notes,
      'sortOrder': sortOrder,
      'updatedAt': FieldValue.serverTimestamp(),
      if (isCreate) 'createdAt': FieldValue.serverTimestamp(),
    };
  }

  static double? _safeUnitPrice(double? value) {
    if (value == null || !value.isFinite || value < 0) {
      return null;
    }
    return value;
  }

  ShoppingListItem copyWith({
    String? name,
    int? quantity,
    bool? isCompleted,
    DateTime? completedAt,
    bool clearCompletedAt = false,
    String? store,
    double? unitPrice,
    String? dealId,
    String? category,
    String? notes,
    int? sortOrder,
  }) {
    return ShoppingListItem(
      id: id,
      name: name ?? this.name,
      quantity: quantity ?? this.quantity,
      isCompleted: isCompleted ?? this.isCompleted,
      completedAt: clearCompletedAt ? null : (completedAt ?? this.completedAt),
      store: store ?? this.store,
      unitPrice: unitPrice ?? this.unitPrice,
      dealId: dealId ?? this.dealId,
      category: category ?? this.category,
      notes: notes ?? this.notes,
      sortOrder: sortOrder ?? this.sortOrder,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }

  static DateTime _timestampToDate(Object? value) {
    if (value is Timestamp) return value.toDate();
    if (value is DateTime) return value;
    return DateTime.now();
  }

  static DateTime? _timestampToNullableDate(Object? value) {
    if (value is Timestamp) return value.toDate();
    if (value is DateTime) return value;
    return null;
  }
}

/// Payload for creating items alongside a new list.
class NewShoppingListItemInput {
  const NewShoppingListItemInput({
    required this.name,
    this.quantity = 1,
    this.store,
    this.unitPrice,
  });

  final String name;
  final int quantity;
  final String? store;
  final double? unitPrice;
}
