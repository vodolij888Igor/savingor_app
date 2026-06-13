import 'package:cloud_firestore/cloud_firestore.dart';

/// User-owned shopping list document at `users/{uid}/shoppingLists/{listId}`.
class ShoppingList {
  const ShoppingList({
    required this.id,
    required this.title,
    required this.itemCount,
    required this.completedCount,
    this.estimatedTotal,
    required this.createdAt,
    required this.updatedAt,
    this.status = ShoppingListStatus.active,
    this.source = ShoppingListSource.manual,
    this.metadata = const <String, dynamic>{},
    this.lastFinalizedReceiptId,
  });

  final String id;
  final String title;
  final int itemCount;
  final int completedCount;
  final double? estimatedTotal;
  final DateTime createdAt;
  final DateTime updatedAt;
  final ShoppingListStatus status;
  final ShoppingListSource source;
  final Map<String, dynamic> metadata;
  final String? lastFinalizedReceiptId;

  factory ShoppingList.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
  ) {
    final Map<String, dynamic> data = snapshot.data() ?? <String, dynamic>{};
    return ShoppingList(
      id: snapshot.id,
      title: (data['title'] as String?)?.trim() ?? 'Untitled list',
      itemCount: (data['itemCount'] as num?)?.toInt() ?? 0,
      completedCount: _readCompletedCount(data),
      estimatedTotal: (data['estimatedTotal'] as num?)?.toDouble(),
      createdAt: _timestampToDate(data['createdAt']),
      updatedAt: _timestampToDate(data['updatedAt']),
      status: ShoppingListStatus.fromString(data['status'] as String?),
      source: ShoppingListSource.fromString(data['source'] as String?),
      metadata: Map<String, dynamic>.from(
        (data['metadata'] as Map<String, dynamic>?) ??
            const <String, dynamic>{},
      ),
      lastFinalizedReceiptId: _nullableString(data['lastFinalizedReceiptId']),
    );
  }

  Map<String, dynamic> toFirestore({bool isCreate = false}) {
    return <String, dynamic>{
      'title': title,
      'itemCount': itemCount,
      'completedCount': completedCount,
      if (estimatedTotal != null) 'estimatedTotal': estimatedTotal,
      if (lastFinalizedReceiptId != null)
        'lastFinalizedReceiptId': lastFinalizedReceiptId,
      'status': status.value,
      'source': source.value,
      'metadata': metadata,
      'updatedAt': Timestamp.fromDate(DateTime.now()),
      if (isCreate) 'createdAt': Timestamp.fromDate(DateTime.now()),
    };
  }

  ShoppingList copyWith({
    String? title,
    int? itemCount,
    int? completedCount,
    double? estimatedTotal,
    DateTime? updatedAt,
    ShoppingListStatus? status,
    String? lastFinalizedReceiptId,
    bool clearLastFinalizedReceiptId = false,
  }) {
    return ShoppingList(
      id: id,
      title: title ?? this.title,
      itemCount: itemCount ?? this.itemCount,
      completedCount: completedCount ?? this.completedCount,
      estimatedTotal: estimatedTotal ?? this.estimatedTotal,
      createdAt: createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      status: status ?? this.status,
      source: source,
      metadata: metadata,
      lastFinalizedReceiptId: clearLastFinalizedReceiptId
          ? null
          : (lastFinalizedReceiptId ?? this.lastFinalizedReceiptId),
    );
  }

  static String? _nullableString(Object? value) {
    if (value == null) return null;
    if (value is! String) return value.toString();
    final String trimmed = value.trim();
    return trimmed.isEmpty ? null : trimmed;
  }

  static int _readCompletedCount(Map<String, dynamic> data) {
    if (data.containsKey('completedCount')) {
      return (data['completedCount'] as num?)?.toInt() ?? 0;
    }
    return (data['checkedCount'] as num?)?.toInt() ?? 0;
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
