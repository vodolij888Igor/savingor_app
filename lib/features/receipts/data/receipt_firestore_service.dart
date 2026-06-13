import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:savingor_app/features/receipts/domain/models/receipt.dart';

/// Firestore access for receipts under `users/{uid}/receipts/{receiptId}`.
///
/// Also merges legacy documents from the top-level `receipts` collection so
/// existing user data continues to appear during the transition.
class ReceiptFirestoreService {
  ReceiptFirestoreService({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance;

  final FirebaseFirestore _firestore;

  CollectionReference<Map<String, dynamic>> _userReceiptsCollection(
    String userId,
  ) {
    return _firestore.collection('users').doc(userId).collection('receipts');
  }

  CollectionReference<Map<String, dynamic>> get _legacyReceiptsCollection =>
      _firestore.collection('receipts');

  Stream<List<Receipt>> watchUserReceipts(String userId) {
    final StreamController<List<Receipt>> controller =
        StreamController<List<Receipt>>.broadcast();

    QuerySnapshot<Map<String, dynamic>>? latestPrimary;
    QuerySnapshot<Map<String, dynamic>>? latestLegacy;

    void emitMerged() {
      if (controller.isClosed) {
        return;
      }

      final List<Receipt> merged = _mergeReceiptSnapshots(
        userId: userId,
        primary: latestPrimary,
        legacy: latestLegacy,
      );
      controller.add(merged);
    }

    late final StreamSubscription<QuerySnapshot<Map<String, dynamic>>>
        primarySub;
    late final StreamSubscription<QuerySnapshot<Map<String, dynamic>>>
        legacySub;

    primarySub = _userReceiptsCollection(userId)
        .orderBy('purchaseDate', descending: true)
        .snapshots()
        .listen(
      (QuerySnapshot<Map<String, dynamic>> snapshot) {
        latestPrimary = snapshot;
        emitMerged();
      },
      onError: controller.addError,
    );

    legacySub = _legacyReceiptsCollection
        .where('userId', isEqualTo: userId)
        .snapshots()
        .listen(
      (QuerySnapshot<Map<String, dynamic>> snapshot) {
        latestLegacy = snapshot;
        emitMerged();
      },
      onError: controller.addError,
    );

    controller.onCancel = () async {
      await primarySub.cancel();
      await legacySub.cancel();
    };

    return controller.stream;
  }

  Future<String> createReceipt(String userId, Receipt receipt) async {
    final CollectionReference<Map<String, dynamic>> collection =
        _userReceiptsCollection(userId);
    final DocumentReference<Map<String, dynamic>> receiptRef =
        receipt.id.isNotEmpty ? collection.doc(receipt.id) : collection.doc();

    await receiptRef.set(receipt.toMap());
    return receiptRef.id;
  }

  Future<void> updateReceipt(String userId, Receipt receipt) async {
    final Receipt updated = receipt.copyWith(updatedAt: DateTime.now());
    await _userReceiptsCollection(userId).doc(updated.id).set(updated.toMap());
  }

  Future<void> deleteReceipt(String userId, String receiptId) async {
    final DocumentReference<Map<String, dynamic>> primaryRef =
        _userReceiptsCollection(userId).doc(receiptId);

    final DocumentSnapshot<Map<String, dynamic>> primarySnapshot =
        await primaryRef.get();
    if (primarySnapshot.exists) {
      await primaryRef.delete();
      return;
    }

    await _legacyReceiptsCollection.doc(receiptId).delete();
  }

  Future<Receipt?> getReceiptById(String userId, String receiptId) async {
    final DocumentSnapshot<Map<String, dynamic>> primarySnapshot =
        await _userReceiptsCollection(userId).doc(receiptId).get();

    if (primarySnapshot.exists) {
      final Map<String, dynamic>? data = primarySnapshot.data();
      if (data != null) {
        return Receipt.fromMap(data, primarySnapshot.id);
      }
    }

    final DocumentSnapshot<Map<String, dynamic>> legacySnapshot =
        await _legacyReceiptsCollection.doc(receiptId).get();
    if (!legacySnapshot.exists) {
      return null;
    }

    final Map<String, dynamic>? data = legacySnapshot.data();
    if (data == null) {
      return null;
    }

    final Receipt receipt = Receipt.fromMap(data, legacySnapshot.id);
    if (receipt.userId != userId) {
      return null;
    }
    return receipt;
  }

  List<Receipt> _mergeReceiptSnapshots({
    required String userId,
    required QuerySnapshot<Map<String, dynamic>>? primary,
    required QuerySnapshot<Map<String, dynamic>>? legacy,
  }) {
    final Map<String, Receipt> byId = <String, Receipt>{};

    void addDocs(QuerySnapshot<Map<String, dynamic>>? snapshot) {
      if (snapshot == null) {
        return;
      }
      for (final QueryDocumentSnapshot<Map<String, dynamic>> doc
          in snapshot.docs) {
        try {
          final Receipt receipt = Receipt.fromMap(doc.data(), doc.id);
          if (receipt.userId.isEmpty || receipt.userId == userId) {
            byId[receipt.id] = receipt;
          }
        } catch (_) {
          // Skip malformed documents.
        }
      }
    }

    addDocs(primary);
    addDocs(legacy);

    final List<Receipt> receipts = byId.values.toList(growable: false)
      ..sort(
        (Receipt a, Receipt b) => b.purchaseDate.compareTo(a.purchaseDate),
      );
    return receipts;
  }
}
