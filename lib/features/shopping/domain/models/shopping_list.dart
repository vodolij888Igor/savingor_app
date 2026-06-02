import 'package:cloud_firestore/cloud_firestore.dart';

/// User-owned shopping list document at `users/{uid}/shoppingLists/{listId}`.
class ShoppingList {
  const ShoppingList({
    required this.id,
    required this.title,
    required this.itemCount,
    required this.checkedCount,
    this.estimatedTotal,
    required this.createdAt,
    required this.updatedAt,
    this.status = ShoppingListStatus.active,
    this.source = ShoppingListSource.manual,
    this.metadata = const <String, dynamic>{},
  });

  final String id;
  final String title;
  final int itemCount;
  final int checkedCount;
  final double? estimatedTotal;
  final DateTime createdAt;
  final DateTime updatedAt;
  final ShoppingListStatus status;
  final ShoppingListSource source;
  final Map<String, dynamic> metadata;

  factory ShoppingList.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
  ) {
    final Map<String, dynamic> data = snapshot.data() ?? <String, dynamic>{};
    return ShoppingList(
      id: snapshot.id,
      title: (data['title'] as String?)?.trim() ?? 'Untitled list',
      itemCount: (data['itemCount'] as num?)?.toInt() ?? 0,
      checkedCount: (data['checkedCount'] as num?)?.toInt() ?? 0,
      estimatedTotal: (data['estimatedTotal'] as num?)?.toDouble(),
      createdAt: _timestampToDate(data['createdAt']),
      updatedAt: _timestampToDate(data['updatedAt']),
      status: ShoppingListStatus.fromString(data['status'] as String?),
      source: ShoppingListSource.fromString(data['source'] as String?),
      metadata: Map<String, dynamic>.from(
        (data['metadata'] as Map<String, dynamic>?) ?? const <String, dynamic>{},
      ),
    );
  }

  Map<String, dynamic> toFirestore({bool isCreate = false}) {
    return <String, dynamic>{
      'title': title,
      'itemCount': itemCount,
      'checkedCount': checkedCount,
      if (estimatedTotal != null) 'estimatedTotal': estimatedTotal,
      'status': status.value,
      'source': source.value,
      'metadata': metadata,
      'updatedAt': Timestamp.fromDate(DateTime.now()),
      if (isCreate) 'createdAt': Timestamp.fromDate(DateTime.now()),
    };
  }

  static DateTime _timestampToDate(Object? value) {
    if (value is Timestamp) return value.toDate();
    if (value is DateTime) return value;
    return DateTime.now();
  }
}

enum ShoppingListStatus {
  active('active'),
  archived('archived');

  const ShoppingListStatus(this.value);
  final String value;

  static ShoppingListStatus fromString(String? raw) {
    return ShoppingListStatus.values.firstWhere(
      (ShoppingListStatus status) => status.value == raw,
      orElse: () => ShoppingListStatus.active,
    );
  }
}

enum ShoppingListSource {
  manual('manual'),
  deal('deal'),
  ai('ai');

  const ShoppingListSource(this.value);
  final String value;

  static ShoppingListSource fromString(String? raw) {
    return ShoppingListSource.values.firstWhere(
      (ShoppingListSource source) => source.value == raw,
      orElse: () => ShoppingListSource.manual,
    );
  }
}
