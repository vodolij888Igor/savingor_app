import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/widgets.dart';

import 'package:savingor_app/features/shopping/data/shopping_lists_firestore_service.dart';
import 'package:savingor_app/features/shopping/domain/models/shopping_list.dart';
import 'package:savingor_app/features/shopping/domain/models/shopping_list_item.dart';
import 'package:savingor_app/features/shopping/domain/models/global_shopping_items_snapshot.dart';

/// App-level state for Firestore-backed shopping lists.
class ShoppingListsStore extends ChangeNotifier {
  ShoppingListsStore({
    ShoppingListsFirestoreService? service,
    FirebaseAuth? firebaseAuth,
  })  : _service = service ?? ShoppingListsFirestoreService(),
        _firebaseAuth = firebaseAuth ?? FirebaseAuth.instance {
    _authSubscription = _firebaseAuth.authStateChanges().listen(_onAuthChanged);
    _onAuthChanged(_firebaseAuth.currentUser);
  }

  final ShoppingListsFirestoreService _service;
  final FirebaseAuth _firebaseAuth;

  StreamSubscription<User?>? _authSubscription;
  StreamSubscription<List<ShoppingList>>? _listsSubscription;
  StreamSubscription<List<ShoppingListItem>>? _itemsSubscription;

  String? _uid;
  String? _activeListId;

  List<ShoppingList> _lists = <ShoppingList>[];
  List<ShoppingListItem> _items = <ShoppingListItem>[];

  bool _isLoadingLists = true;
  bool _isLoadingItems = false;
  String? _listsError;
  String? _itemsError;
  String? _mutationError;

  List<ShoppingList> get lists => List<ShoppingList>.unmodifiable(_lists);
  List<ShoppingListItem> get items => List<ShoppingListItem>.unmodifiable(_items);
  String? get uid => _uid;
  String? get activeListId => _activeListId;
  bool get isAuthenticated => _uid != null;
  bool get isLoadingLists => _isLoadingLists;
  bool get isLoadingItems => _isLoadingItems;
  String? get listsError => _listsError;
  String? get itemsError => _itemsError;
  String? get mutationError => _mutationError;

  double get activeListEstimate {
    double total = 0;
    for (final ShoppingListItem item in _items) {
      final double? lineTotal = item.lineTotal;
      if (lineTotal != null) total += lineTotal;
    }
    return total;
  }

  /// Active shopping list count for dashboard and summary views.
  int get listCount => _lists.length;

  /// Sum of list-level estimated totals (unchecked priced items).
  double get totalEstimatedListValue {
    double total = 0;
    for (final ShoppingList list in _lists) {
      if (list.estimatedTotal != null) {
        total += list.estimatedTotal!;
      }
    }
    return total;
  }

  void _onAuthChanged(User? user) {
    final String? nextUid = user?.uid;
    if (nextUid == _uid) return;
    _uid = nextUid;
    _activeListId = null;
    _items = <ShoppingListItem>[];
    _itemsSubscription?.cancel();
    _itemsSubscription = null;
    _subscribeToLists();
    notifyListeners();
  }

  void _subscribeToLists() {
    _listsSubscription?.cancel();
    _lists = <ShoppingList>[];
    _listsError = null;

    if (_uid == null) {
      _isLoadingLists = false;
      return;
    }

    _isLoadingLists = true;
    _listsSubscription = _service.watchLists(_uid!).listen(
      (List<ShoppingList> lists) {
        _lists = lists;
        _isLoadingLists = false;
        _listsError = null;
        notifyListeners();
      },
      onError: (Object _) {
        _lists = <ShoppingList>[];
        _isLoadingLists = false;
        _listsError = 'Could not load your shopping lists. Please try again.';
        notifyListeners();
      },
    );
  }

  void watchListItems(String listId) {
    if (_uid == null) return;
    if (_activeListId == listId && _itemsSubscription != null) return;

    _activeListId = listId;
    _itemsSubscription?.cancel();
    _items = <ShoppingListItem>[];
    _itemsError = null;
    _isLoadingItems = true;
    notifyListeners();

    _itemsSubscription = _service.watchItems(_uid!, listId).listen(
      (List<ShoppingListItem> items) {
        _items = items;
        _isLoadingItems = false;
        _itemsError = null;
        notifyListeners();
      },
      onError: (Object _) {
        _items = <ShoppingListItem>[];
        _isLoadingItems = false;
        _itemsError = 'Could not load list items. Please try again.';
        notifyListeners();
      },
    );
  }

  void clearActiveList() {
    _activeListId = null;
    _itemsSubscription?.cancel();
    _itemsSubscription = null;
    _items = <ShoppingListItem>[];
    _itemsError = null;
    _isLoadingItems = false;
    notifyListeners();
  }

  void clearMutationError() {
    _mutationError = null;
  }

  void retryLists() {
    _subscribeToLists();
    notifyListeners();
  }

  Future<String?> createList({
    required String title,
    List<NewShoppingListItemInput> items = const <NewShoppingListItemInput>[],
  }) async {
    if (_uid == null) {
      _mutationError = 'Sign in to create shopping lists.';
      notifyListeners();
      return null;
    }

    try {
      _mutationError = null;
      final String listId = await _service.createList(
        uid: _uid!,
        title: title,
        items: items,
      );
      notifyListeners();
      return listId;
    } on ShoppingListsException catch (error) {
      _mutationError = error.message;
      notifyListeners();
      return null;
    } catch (_) {
      _mutationError = 'Could not create the list. Please try again.';
      notifyListeners();
      return null;
    }
  }

  Future<bool> deleteList(String listId) async {
    if (_uid == null) return false;

    try {
      _mutationError = null;
      await _service.deleteList(uid: _uid!, listId: listId);
      if (_activeListId == listId) {
        clearActiveList();
      }
      notifyListeners();
      return true;
    } catch (_) {
      _mutationError = 'Could not delete the list. Please try again.';
      notifyListeners();
      return false;
    }
  }

  Future<bool> addItem({
    required String listId,
    required String name,
    int quantity = 1,
    String? store,
    double? unitPrice,
  }) async {
    if (_uid == null) return false;

    try {
      _mutationError = null;
      await _service.addItem(
        uid: _uid!,
        listId: listId,
        name: name,
        quantity: quantity,
        store: store,
        unitPrice: unitPrice,
      );
      notifyListeners();
      return true;
    } on ShoppingListsException catch (error) {
      _mutationError = error.message;
      notifyListeners();
      return false;
    } catch (_) {
      _mutationError = 'Could not add the item. Please try again.';
      notifyListeners();
      return false;
    }
  }

  Future<bool> toggleItemCompleted({
    required String listId,
    required ShoppingListItem item,
  }) async {
    if (_uid == null) return false;

    try {
      _mutationError = null;
      final bool willComplete = !item.isCompleted;
      await _service.updateItem(
        uid: _uid!,
        listId: listId,
        item: item.copyWith(
          isCompleted: willComplete,
          completedAt: willComplete ? DateTime.now() : null,
          clearCompletedAt: !willComplete,
        ),
      );
      notifyListeners();
      return true;
    } catch (_) {
      _mutationError = 'Could not update the item. Please try again.';
      notifyListeners();
      return false;
    }
  }

  Future<bool> updateItemQuantity({
    required String listId,
    required ShoppingListItem item,
    required int quantity,
  }) async {
    if (_uid == null) return false;
    if (quantity < 1) return false;

    try {
      _mutationError = null;
      await _service.updateItem(
        uid: _uid!,
        listId: listId,
        item: item.copyWith(quantity: quantity),
      );
      notifyListeners();
      return true;
    } catch (_) {
      _mutationError = 'Could not update quantity. Please try again.';
      notifyListeners();
      return false;
    }
  }

  Future<bool> deleteItem({
    required String listId,
    required String itemId,
  }) async {
    if (_uid == null) return false;

    try {
      _mutationError = null;
      await _service.deleteItem(
        uid: _uid!,
        listId: listId,
        itemId: itemId,
      );
      notifyListeners();
      return true;
    } catch (_) {
      _mutationError = 'Could not remove the item. Please try again.';
      notifyListeners();
      return false;
    }
  }

  Future<List<ShoppingListItem>> fetchUncheckedItemsForList(String listId) async {
    if (_uid == null) return const <ShoppingListItem>[];
    return _service.fetchUncheckedItems(uid: _uid!, listId: listId);
  }

  Future<List<ShoppingListItem>> fetchAllUncheckedItems() async {
    if (_uid == null) return const <ShoppingListItem>[];
    final GlobalShoppingItemsSnapshot snapshot =
        await _service.fetchGlobalShoppingItemsSnapshot(_uid!);
    return snapshot.uncheckedItems;
  }

  Future<GlobalShoppingItemsSnapshot> fetchGlobalShoppingItemsSnapshot() async {
    if (_uid == null) {
      return const GlobalShoppingItemsSnapshot(
        uncheckedItems: <ShoppingListItem>[],
        activeListsIncluded: 0,
      );
    }
    return _service.fetchGlobalShoppingItemsSnapshot(_uid!);
  }

  Future<bool> markLastFinalizedReceipt({
    required String listId,
    required String receiptId,
  }) async {
    if (_uid == null) return false;

    try {
      _mutationError = null;
      await _service.updateLastFinalizedReceiptId(
        uid: _uid!,
        listId: listId,
        receiptId: receiptId,
      );
      notifyListeners();
      return true;
    } catch (_) {
      _mutationError = 'Could not update the shopping list. Please try again.';
      notifyListeners();
      return false;
    }
  }

  @override
  void dispose() {
    _authSubscription?.cancel();
    _listsSubscription?.cancel();
    _itemsSubscription?.cancel();
    super.dispose();
  }
}

class ShoppingListsProvider extends InheritedNotifier<ShoppingListsStore> {
  const ShoppingListsProvider({
    super.key,
    required ShoppingListsStore notifier,
    required super.child,
  }) : super(notifier: notifier);

  static ShoppingListsStore of(BuildContext context) {
    final ShoppingListsProvider? provider =
        context.dependOnInheritedWidgetOfExactType<ShoppingListsProvider>();
    if (provider == null) {
      throw FlutterError('ShoppingListsProvider not found');
    }
    return provider.notifier!;
  }
}
