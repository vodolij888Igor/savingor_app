import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:savingor_app/features/shopping/domain/models/shopping_list.dart';
import 'package:savingor_app/features/shopping/domain/models/shopping_list_item.dart';

/// Firestore access for user shopping lists under `users/{uid}/shoppingLists`.
class ShoppingListsFirestoreService {
  ShoppingListsFirestoreService({
    FirebaseAuth? firebaseAuth,
    FirebaseFirestore? firestore,
  })  : _firebaseAuth = firebaseAuth ?? FirebaseAuth.instance,
        _firestore = firestore ?? FirebaseFirestore.instance;

  final FirebaseAuth _firebaseAuth;
  final FirebaseFirestore _firestore;

  String? get currentUid => _firebaseAuth.currentUser?.uid;

  CollectionReference<Map<String, dynamic>> _listsCollection(String uid) {
    return _firestore.collection('users').doc(uid).collection('shoppingLists');
  }

  CollectionReference<Map<String, dynamic>> _itemsCollection(
    String uid,
    String listId,
  ) {
    return _listsCollection(uid).doc(listId).collection('items');
  }

  Stream<List<ShoppingList>> watchLists(String uid) {
    return _listsCollection(uid)
        .orderBy('updatedAt', descending: true)
        .snapshots()
        .map(
          (QuerySnapshot<Map<String, dynamic>> snapshot) => snapshot.docs
              .map(ShoppingList.fromFirestore)
              .where(
                (ShoppingList list) => list.status == ShoppingListStatus.active,
              )
              .toList(growable: false),
        );
  }

  Stream<List<ShoppingListItem>> watchItems(String uid, String listId) {
    return _itemsCollection(uid, listId)
        .orderBy('sortOrder')
        .snapshots()
        .map(
          (QuerySnapshot<Map<String, dynamic>> snapshot) => snapshot.docs
              .map(ShoppingListItem.fromFirestore)
              .toList(growable: false),
        );
  }

  Future<String> createList({
    required String uid,
    required String title,
    List<NewShoppingListItemInput> items = const <NewShoppingListItemInput>[],
  }) async {
    final String trimmedTitle = title.trim();
    if (trimmedTitle.isEmpty) {
      throw const ShoppingListsException('List title is required.');
    }

    final DocumentReference<Map<String, dynamic>> listRef =
        _listsCollection(uid).doc();
    final WriteBatch batch = _firestore.batch();

    final List<NewShoppingListItemInput> normalizedItems = items
        .where((NewShoppingListItemInput item) => item.name.trim().isNotEmpty)
        .toList(growable: false);

    double estimatedTotal = 0;
    int checkedCount = 0;
    for (final NewShoppingListItemInput input in normalizedItems) {
      if (input.unitPrice != null) {
        estimatedTotal += input.unitPrice! * input.quantity;
      }
    }

    batch.set(listRef, <String, dynamic>{
      'title': trimmedTitle,
      'itemCount': normalizedItems.length,
      'checkedCount': checkedCount,
      if (estimatedTotal > 0) 'estimatedTotal': estimatedTotal,
      'status': ShoppingListStatus.active.value,
      'source': ShoppingListSource.manual.value,
      'metadata': <String, dynamic>{},
      'createdAt': FieldValue.serverTimestamp(),
      'updatedAt': FieldValue.serverTimestamp(),
    });

    for (int index = 0; index < normalizedItems.length; index++) {
      final NewShoppingListItemInput input = normalizedItems[index];
      final DocumentReference<Map<String, dynamic>> itemRef =
          _itemsCollection(uid, listRef.id).doc();
      batch.set(itemRef, ShoppingListItem(
        id: itemRef.id,
        name: input.name.trim(),
        quantity: input.quantity.clamp(1, 999),
        isChecked: false,
        store: input.store?.trim(),
        unitPrice: input.unitPrice,
        sortOrder: index,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      ).toFirestore(isCreate: true));
    }

    await batch.commit();
    return listRef.id;
  }

  Future<void> deleteList({
    required String uid,
    required String listId,
  }) async {
    final QuerySnapshot<Map<String, dynamic>> itemsSnapshot =
        await _itemsCollection(uid, listId).get();
    final WriteBatch batch = _firestore.batch();
    for (final QueryDocumentSnapshot<Map<String, dynamic>> doc
        in itemsSnapshot.docs) {
      batch.delete(doc.reference);
    }
    batch.delete(_listsCollection(uid).doc(listId));
    await batch.commit();
  }

  Future<void> addItem({
    required String uid,
    required String listId,
    required String name,
    int quantity = 1,
    String? store,
    double? unitPrice,
  }) async {
    final String trimmedName = name.trim();
    if (trimmedName.isEmpty) {
      throw const ShoppingListsException('Item name is required.');
    }

    final QuerySnapshot<Map<String, dynamic>> existing =
        await _itemsCollection(uid, listId).get();
    final DocumentReference<Map<String, dynamic>> itemRef =
        _itemsCollection(uid, listId).doc();

    await itemRef.set(
      ShoppingListItem(
        id: itemRef.id,
        name: trimmedName,
        quantity: quantity.clamp(1, 999),
        isChecked: false,
        store: store?.trim(),
        unitPrice: unitPrice,
        sortOrder: existing.size,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      ).toFirestore(isCreate: true),
    );

    await _refreshListSummary(uid: uid, listId: listId);
  }

  Future<void> updateItem({
    required String uid,
    required String listId,
    required ShoppingListItem item,
  }) async {
    await _itemsCollection(uid, listId).doc(item.id).set(
          item.toFirestore(),
          SetOptions(merge: true),
        );
    await _refreshListSummary(uid: uid, listId: listId);
  }

  Future<void> deleteItem({
    required String uid,
    required String listId,
    required String itemId,
  }) async {
    await _itemsCollection(uid, listId).doc(itemId).delete();
    await _refreshListSummary(uid: uid, listId: listId);
  }

  Future<void> _refreshListSummary({
    required String uid,
    required String listId,
  }) async {
    final QuerySnapshot<Map<String, dynamic>> snapshot =
        await _itemsCollection(uid, listId).get();
    final List<ShoppingListItem> items = snapshot.docs
        .map(ShoppingListItem.fromFirestore)
        .toList(growable: false);

    int checkedCount = 0;
    double estimatedTotal = 0;
    for (final ShoppingListItem item in items) {
      if (item.isChecked) {
        checkedCount += 1;
      } else if (item.unitPrice != null) {
        estimatedTotal += item.unitPrice! * item.quantity;
      }
    }

    await _listsCollection(uid).doc(listId).set(
      <String, dynamic>{
        'itemCount': items.length,
        'checkedCount': checkedCount,
        'estimatedTotal': estimatedTotal > 0 ? estimatedTotal : FieldValue.delete(),
        'updatedAt': FieldValue.serverTimestamp(),
      },
      SetOptions(merge: true),
    );
  }
}

class ShoppingListsException implements Exception {
  const ShoppingListsException(this.message);

  final String message;

  @override
  String toString() => message;
}
