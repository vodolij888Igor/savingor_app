import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:savingor_app/features/expenses/domain/models/user_expense.dart';

/// Firestore access for user expenses under `users/{uid}/expenses`.
class ExpenseFirestoreService {
  ExpenseFirestoreService({
    FirebaseAuth? firebaseAuth,
    FirebaseFirestore? firestore,
  })  : _firebaseAuth = firebaseAuth ?? FirebaseAuth.instance,
        _firestore = firestore ?? FirebaseFirestore.instance;

  final FirebaseAuth _firebaseAuth;
  final FirebaseFirestore _firestore;

  String? get currentUid => _firebaseAuth.currentUser?.uid;

  CollectionReference<Map<String, dynamic>> _expensesCollection(String uid) {
    return _firestore.collection('users').doc(uid).collection('expenses');
  }

  Stream<List<UserExpense>> watchUserExpenses(String uid) {
    return _expensesCollection(uid)
        .orderBy('purchaseDate', descending: true)
        .snapshots()
        .map(
          (QuerySnapshot<Map<String, dynamic>> snapshot) => snapshot.docs
              .map(UserExpense.fromFirestore)
              .toList(growable: false),
        );
  }

  Future<String> createExpense({
    required String uid,
    required String storeName,
    required DateTime purchaseDate,
    required double totalAmount,
  }) async {
    final String trimmedStore = storeName.trim();
    if (trimmedStore.isEmpty) {
      throw const ExpenseFirestoreException('Store name is required.');
    }
    if (totalAmount <= 0) {
      throw const ExpenseFirestoreException('Total amount must be greater than zero.');
    }

    final DocumentReference<Map<String, dynamic>> expenseRef =
        _expensesCollection(uid).doc();

    await expenseRef.set(
      UserExpense(
        id: expenseRef.id,
        userId: uid,
        storeName: trimmedStore,
        purchaseDate: purchaseDate,
        totalAmount: totalAmount,
        createdAt: DateTime.now(),
      ).toFirestore(isCreate: true),
    );

    return expenseRef.id;
  }

  Future<void> deleteExpense({
    required String uid,
    required String expenseId,
  }) async {
    await _expensesCollection(uid).doc(expenseId).delete();
  }
}

class ExpenseFirestoreException implements Exception {
  const ExpenseFirestoreException(this.message);

  final String message;

  @override
  String toString() => message;
}
