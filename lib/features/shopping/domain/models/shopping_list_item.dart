import 'package:cloud_firestore/cloud_firestore.dart';

/// Line item at `users/{uid}/shoppingLists/{listId}/items/{itemId}`.
class ShoppingListItem {
  const ShoppingListItem({
    required this.id,
    required this.name,
    required this.quantity,
    required this.isChecked,
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
  final bool isChecked;
  final String? store;
  final double? unitPrice;
  final String? dealId;
  final String? category;
  final String? notes;
  final int sortOrder;
  final DateTime createdAt;
  final DateTime updatedAt;

  double? get lineTotal {
    if (unitPrice == null || isChecked) return null;
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
      isChecked: data['isChecked'] as bool? ?? false,
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

  Map<String, dynamic> toFirestore({bool isCreate = false}) {
    return <String, dynamic>{
      'name': name,
      'quantity': quantity,
      'isChecked': isChecked,
      if (store != null && store!.isNotEmpty) 'store': store,
      if (unitPrice != null) 'unitPrice': unitPrice,
      if (dealId != null) 'dealId': dealId,
      if (category != null && category!.isNotEmpty) 'category': category,
      if (notes != null && notes!.isNotEmpty) 'notes': notes,
      'sortOrder': sortOrder,
      'updatedAt': FieldValue.serverTimestamp(),
      if (isCreate) 'createdAt': FieldValue.serverTimestamp(),
    };
  }

  ShoppingListItem copyWith({
    String? name,
    int? quantity,
    bool? isChecked,
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
      isChecked: isChecked ?? this.isChecked,
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
