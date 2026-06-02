import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:savingor_app/features/scanner/domain/models/receipt.dart';

/// Firestore access for grocery receipts in the top-level `receipts` collection.
class ReceiptFirestoreService {
  ReceiptFirestoreService({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance;

  final FirebaseFirestore _firestore;

  CollectionReference<Map<String, dynamic>> get _receiptsCollection =>
      _firestore.collection('receipts');

  Stream<List<Receipt>> watchUserReceipts(String userId) {
    return _receiptsCollection
        .where('userId', isEqualTo: userId)
        .snapshots()
        .map(_receiptsFromSnapshot);
  }

  Future<String> createReceipt(Receipt receipt) async {
    final DocumentReference<Map<String, dynamic>> receiptRef =
        receipt.id.isNotEmpty
            ? _receiptsCollection.doc(receipt.id)
            : _receiptsCollection.doc();

    await receiptRef.set(receipt.toMap());
    return receiptRef.id;
  }

  Future<void> deleteReceipt(String receiptId) async {
    await _receiptsCollection.doc(receiptId).delete();
  }

  Future<Receipt?> getReceiptById(String receiptId) async {
    final DocumentSnapshot<Map<String, dynamic>> snapshot =
        await _receiptsCollection.doc(receiptId).get();

    if (!snapshot.exists) return null;

    final Map<String, dynamic>? data = snapshot.data();
    if (data == null) return null;

    try {
      return Receipt.fromMap(data, snapshot.id);
    } catch (_) {
      return null;
    }
  }

  List<Receipt> _receiptsFromSnapshot(
    QuerySnapshot<Map<String, dynamic>> snapshot,
  ) {
    final List<Receipt> receipts = <Receipt>[];

    for (final QueryDocumentSnapshot<Map<String, dynamic>> doc
        in snapshot.docs) {
      try {
        receipts.add(Receipt.fromMap(doc.data(), doc.id));
      } catch (_) {
        // Skip malformed documents so one bad record does not break the stream.
      }
    }

    receipts.sort((Receipt a, Receipt b) => b.date.compareTo(a.date));

    return receipts;
  }
}
