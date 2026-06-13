import 'package:cloud_firestore/cloud_firestore.dart';

/// User expense document at `users/{uid}/expenses/{expenseId}`.
class UserExpense {
  const UserExpense({
    required this.id,
    required this.userId,
    required this.storeName,
    required this.purchaseDate,
    required this.totalAmount,
    required this.createdAt,
    this.currency = 'CAD',
  });

  final String id;
  final String userId;
  final String storeName;
  final DateTime purchaseDate;
  final double totalAmount;
  final DateTime createdAt;
  final String currency;

  factory UserExpense.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
  ) {
    final Map<String, dynamic> data = snapshot.data() ?? <String, dynamic>{};
    return UserExpense(
      id: snapshot.id,
      userId: (data['userId'] as String?) ?? '',
      storeName: (data['storeName'] as String?)?.trim() ?? 'Unknown store',
      purchaseDate: _timestampToDate(data['purchaseDate']),
      totalAmount: (data['totalAmount'] as num?)?.toDouble() ?? 0,
      createdAt: _timestampToDate(data['createdAt']),
      currency: _parseCurrency(data['currency']),
    );
  }

  Map<String, dynamic> toFirestore({bool isCreate = false}) {
    return <String, dynamic>{
      'userId': userId,
      'storeName': storeName,
      'purchaseDate': Timestamp.fromDate(purchaseDate),
      'totalAmount': totalAmount,
      'currency': currency,
      if (isCreate) 'createdAt': FieldValue.serverTimestamp(),
    };
  }

  static String _parseCurrency(Object? value) {
    if (value is String && value.trim().isNotEmpty) {
      return value.trim().toUpperCase();
    }
    return 'CAD';
  }

  static DateTime _timestampToDate(Object? value) {
    if (value is Timestamp) return value.toDate();
    if (value is DateTime) return value;
    return DateTime.now();
  }
}
