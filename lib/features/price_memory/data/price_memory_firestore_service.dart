import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:savingor_app/features/price_memory/domain/models/product_price_record.dart';

/// Firestore access for product price memory at `users/{uid}/priceRecords`.
class PriceMemoryFirestoreService {
  PriceMemoryFirestoreService({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance;

  final FirebaseFirestore _firestore;

  CollectionReference<Map<String, dynamic>> _priceRecordsCollection(
    String userId,
  ) {
    return _firestore
        .collection('users')
        .doc(userId)
        .collection('priceRecords');
  }

  Future<void> createRecords(
    String userId,
    List<ProductPriceRecord> records,
  ) async {
    if (records.isEmpty) {
      return;
    }

    final CollectionReference<Map<String, dynamic>> collection =
        _priceRecordsCollection(userId);
    final WriteBatch batch = _firestore.batch();

    for (final ProductPriceRecord record in records) {
      final DocumentReference<Map<String, dynamic>> docRef =
          record.id.isNotEmpty ? collection.doc(record.id) : collection.doc();
      batch.set(docRef, record.toMap());
    }

    await batch.commit();
  }

  Future<int> deleteForReceipt(String userId, String receiptId) async {
    final QuerySnapshot<Map<String, dynamic>> snapshot =
        await _priceRecordsCollection(userId)
            .where('receiptId', isEqualTo: receiptId)
            .get();

    if (snapshot.docs.isEmpty) {
      return 0;
    }

    final WriteBatch batch = _firestore.batch();
    for (final QueryDocumentSnapshot<Map<String, dynamic>> doc
        in snapshot.docs) {
      batch.delete(doc.reference);
    }
    await batch.commit();
    return snapshot.docs.length;
  }
}
