import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

import 'package:savingor_app/features/shopping/domain/models/shopping_list.dart';
import 'package:savingor_app/features/shopping/domain/models/shopping_list_item.dart';
import 'package:savingor_app/features/shopping/domain/models/global_shopping_items_snapshot.dart';
import 'package:savingor_app/features/shopping/domain/shopping_basket_item_grouper.dart';
import 'package:savingor_app/features/shopping/domain/shopping_list_add_item_result.dart';

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
    return _listsCollection(uid).snapshots().map(
          (QuerySnapshot<Map<String, dynamic>> snapshot) =>
              _sortActiveLists(
            snapshot.docs.map(ShoppingList.fromFirestore).toList(growable: false),
          ),
        );
  }

  Future<List<ShoppingList>> fetchActiveLists(String uid) async {
    final QuerySnapshot<Map<String, dynamic>> snapshot =
        await _listsCollection(uid).get();
    return _sortActiveLists(
      snapshot.docs.map(ShoppingList.fromFirestore).toList(growable: false),
    );
  }

  static List<ShoppingList> _sortActiveLists(List<ShoppingList> lists) {
    final List<ShoppingList> active = lists
        .where((ShoppingList list) => list.status == ShoppingListStatus.active)
        .toList(growable: false)
      ..sort(
        (ShoppingList a, ShoppingList b) => b.updatedAt.compareTo(a.updatedAt),
      );
    return active;
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
    int completedCount = 0;
    for (final NewShoppingListItemInput input in normalizedItems) {
      if (input.unitPrice != null) {
        estimatedTotal += input.unitPrice! * input.quantity;
      }
    }

    batch.set(listRef, <String, dynamic>{
      'title': trimmedTitle,
      'itemCount': normalizedItems.length,
      'completedCount': completedCount,
      if (estimatedTotal > 0) 'estimatedTotal': estimatedTotal,
      'status': ShoppingListStatus.active.value,
      'source': ShoppingListSource.manual.value,
      'metadata': <String, dynamic>{},
      'createdAt': Timestamp.fromDate(DateTime.now()),
      'updatedAt': Timestamp.fromDate(DateTime.now()),
    });

    for (int index = 0; index < normalizedItems.length; index++) {
      final NewShoppingListItemInput input = normalizedItems[index];
      final DocumentReference<Map<String, dynamic>> itemRef =
          _itemsCollection(uid, listRef.id).doc();
      batch.set(itemRef, ShoppingListItem(
        id: itemRef.id,
        name: input.name.trim(),
        quantity: input.quantity.clamp(1, 999),
        isCompleted: false,
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

  Future<ShoppingListAddItemResult> addItem({
    required String uid,
    required String listId,
    required String name,
    int quantity = 1,
    String? store,
    double? unitPrice,
  }) async {
    final String trimmedName =
        ShoppingBasketItemGrouper.formatDisplayName(name);
    if (trimmedName.isEmpty) {
      throw const ShoppingListsException('Item name is required.');
    }

    final String? trimmedStore = _trimOptional(store);
    final double? safeUnitPrice = _sanitizeUnitPrice(unitPrice);

    try {
      final QuerySnapshot<Map<String, dynamic>> existing =
          await _itemsCollection(uid, listId).get();
      final List<ShoppingListItem> existingItems = existing.docs
          .map(ShoppingListItem.fromFirestore)
          .toList(growable: false);
      final String normalizedKey =
          ShoppingBasketItemGrouper.normalizedKey(trimmedName);
      final ShoppingListItem? duplicate =
          ShoppingBasketItemGrouper.findActiveDuplicate(
        items: existingItems,
        normalizedKey: normalizedKey,
      );

      if (duplicate != null) {
        final ShoppingListItem merged =
            ShoppingBasketItemGrouper.mergeItemPayload(
          existing: duplicate,
          newName: trimmedName,
          addedQuantity: quantity,
          addedStore: trimmedStore,
          addedUnitPrice: safeUnitPrice,
        );
        await updateItem(uid: uid, listId: listId, item: merged);
        return ShoppingListAddItemResult.quantityUpdated;
      }

      final DocumentReference<Map<String, dynamic>> itemRef =
          _itemsCollection(uid, listId).doc();

      await itemRef.set(
        ShoppingListItem(
          id: itemRef.id,
          name: trimmedName,
          quantity: quantity.clamp(1, 999),
          isCompleted: false,
          store: trimmedStore,
          unitPrice: safeUnitPrice,
          sortOrder: existing.size,
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        ).toFirestore(isCreate: true),
      );

      await _refreshListSummary(uid: uid, listId: listId);
      return ShoppingListAddItemResult.added;
    } catch (error, stackTrace) {
      debugPrint(
        'ShoppingListsFirestoreService.addItem failed for "$trimmedName": '
        '$error\n$stackTrace',
      );
      rethrow;
    }
  }

  /// Adds an item only when no active duplicate exists (idempotent quick-add).
  Future<ShoppingListAddItemResult> addItemIfAbsent({
    required String uid,
    required String listId,
    required String name,
    int quantity = 1,
    String? store,
    double? unitPrice,
  }) async {
    final String trimmedName =
        ShoppingBasketItemGrouper.formatDisplayName(name);
    if (trimmedName.isEmpty) {
      throw const ShoppingListsException('Item name is required.');
    }

    final String? trimmedStore = _trimOptional(store);
    final double? safeUnitPrice = _sanitizeUnitPrice(unitPrice);

    try {
      final QuerySnapshot<Map<String, dynamic>> existing =
          await _itemsCollection(uid, listId).get();
      final List<ShoppingListItem> existingItems = existing.docs
          .map(ShoppingListItem.fromFirestore)
          .toList(growable: false);
      final String normalizedKey =
          ShoppingBasketItemGrouper.normalizedKey(trimmedName);
      final ShoppingListItem? duplicate =
          ShoppingBasketItemGrouper.findActiveDuplicate(
        items: existingItems,
        normalizedKey: normalizedKey,
      );

      if (duplicate != null) {
        return ShoppingListAddItemResult.alreadyExists;
      }

      final DocumentReference<Map<String, dynamic>> itemRef =
          _itemsCollection(uid, listId).doc();

      await itemRef.set(
        ShoppingListItem(
          id: itemRef.id,
          name: trimmedName,
          quantity: quantity.clamp(1, 999),
          isCompleted: false,
          store: trimmedStore,
          unitPrice: safeUnitPrice,
          sortOrder: existing.size,
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        ).toFirestore(isCreate: true),
      );

      await _refreshListSummary(uid: uid, listId: listId);
      return ShoppingListAddItemResult.added;
    } catch (error, stackTrace) {
      debugPrint(
        'ShoppingListsFirestoreService.addItemIfAbsent failed for '
        '"$trimmedName": $error\n$stackTrace',
      );
      rethrow;
    }
  }

  static String? _trimOptional(String? value) {
    final String trimmed = value?.trim() ?? '';
    return trimmed.isEmpty ? null : trimmed;
  }

  static double? _sanitizeUnitPrice(double? unitPrice) {
    if (unitPrice == null || !unitPrice.isFinite || unitPrice < 0) {
      return null;
    }
    return unitPrice;
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

  Future<void> updateLastFinalizedReceiptId({
    required String uid,
    required String listId,
    required String receiptId,
  }) async {
    await _listsCollection(uid).doc(listId).set(
      <String, dynamic>{
        'lastFinalizedReceiptId': receiptId,
        'updatedAt': Timestamp.fromDate(DateTime.now()),
      },
      SetOptions(merge: true),
    );
  }

  Future<List<ShoppingListItem>> fetchCompletedItems({
    required String uid,
    required String listId,
  }) async {
    final QuerySnapshot<Map<String, dynamic>> snapshot =
        await _itemsCollection(uid, listId).get();
    return snapshot.docs
        .map(ShoppingListItem.fromFirestore)
        .where((ShoppingListItem item) => item.isCompleted)
        .toList(growable: false);
  }

  Future<List<ShoppingListItem>> fetchUncheckedItems({
    required String uid,
    required String listId,
  }) async {
    final QuerySnapshot<Map<String, dynamic>> snapshot =
        await _itemsCollection(uid, listId).get();
    return snapshot.docs
        .map(ShoppingListItem.fromFirestore)
        .where((ShoppingListItem item) => item.isActive)
        .toList(growable: false);
  }

  Future<GlobalShoppingItemsSnapshot> fetchGlobalShoppingItemsSnapshot(
    String uid,
  ) async {
    final QuerySnapshot<Map<String, dynamic>> listsSnapshot =
        await _listsCollection(uid).get();
    final List<ShoppingListItem> items = <ShoppingListItem>[];
    int activeListsIncluded = 0;

    for (final QueryDocumentSnapshot<Map<String, dynamic>> listDoc
        in listsSnapshot.docs) {
      final ShoppingList list = ShoppingList.fromFirestore(listDoc);
      if (list.status != ShoppingListStatus.active) {
        continue;
      }

      final QuerySnapshot<Map<String, dynamic>> itemsSnapshot =
          await _itemsCollection(uid, listDoc.id).get();
      bool listHasUnchecked = false;

      for (final QueryDocumentSnapshot<Map<String, dynamic>> itemDoc
          in itemsSnapshot.docs) {
        final ShoppingListItem item = ShoppingListItem.fromFirestore(itemDoc);
        if (item.isActive) {
          items.add(item);
          listHasUnchecked = true;
        }
      }

      if (listHasUnchecked) {
        activeListsIncluded += 1;
      }
    }

    return GlobalShoppingItemsSnapshot(
      uncheckedItems: items,
      activeListsIncluded: activeListsIncluded,
    );
  }

  Future<List<ShoppingListItem>> fetchAllUncheckedItems(String uid) async {
    final GlobalShoppingItemsSnapshot snapshot =
        await fetchGlobalShoppingItemsSnapshot(uid);
    return snapshot.uncheckedItems;
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

    int completedCount = 0;
    double estimatedTotal = 0;
    for (final ShoppingListItem item in items) {
      if (item.isCompleted) {
        completedCount += 1;
      } else if (item.unitPrice != null) {
        estimatedTotal += item.unitPrice! * item.quantity;
      }
    }

    await _listsCollection(uid).doc(listId).set(
      <String, dynamic>{
        'itemCount': items.length,
        'completedCount': completedCount,
        'estimatedTotal':
            estimatedTotal > 0 ? estimatedTotal : FieldValue.delete(),
        'updatedAt': Timestamp.fromDate(DateTime.now()),
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
