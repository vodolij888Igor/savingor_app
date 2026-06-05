import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/widgets.dart';

import 'package:savingor_app/features/receipts/data/receipt_firestore_service.dart';
import 'package:savingor_app/features/receipts/domain/models/receipt.dart';
import 'package:savingor_app/features/receipts/domain/models/receipt_item.dart';
import 'package:savingor_app/features/receipts/domain/models/receipt_source.dart';

/// App-level state for Firestore-backed grocery receipts.
class ReceiptStore extends ChangeNotifier {
  ReceiptStore({
    ReceiptFirestoreService? service,
    FirebaseAuth? firebaseAuth,
  })  : _service = service ?? ReceiptFirestoreService(),
        _firebaseAuth = firebaseAuth ?? FirebaseAuth.instance {
    _authSubscription = _firebaseAuth.authStateChanges().listen(_onAuthChanged);
  }

  final ReceiptFirestoreService _service;
  final FirebaseAuth _firebaseAuth;

  StreamSubscription<User?>? _authSubscription;
  StreamSubscription<List<Receipt>>? _receiptsSubscription;

  String? _uid;
  List<Receipt> _receipts = <Receipt>[];

  bool _isLoading = true;
  String? _loadError;
  String? _mutationError;

  List<Receipt> get receipts => List<Receipt>.unmodifiable(_receipts);
  String? get uid => _uid;
  bool get isAuthenticated => _uid != null;
  bool get isLoading => _isLoading;
  String? get loadError => _loadError;
  String? get mutationError => _mutationError;

  void _onAuthChanged(User? user) {
    final String? nextUid = user?.uid;
    if (nextUid == _uid) return;
    _uid = nextUid;
    _subscribeToReceipts();
    notifyListeners();
  }

  void _subscribeToReceipts() {
    _receiptsSubscription?.cancel();
    _receipts = <Receipt>[];
    _loadError = null;

    if (_uid == null) {
      _isLoading = false;
      return;
    }

    _isLoading = true;
    _receiptsSubscription = _service.watchUserReceipts(_uid!).listen(
      (List<Receipt> receipts) {
        _receipts = receipts;
        _isLoading = false;
        _loadError = null;
        notifyListeners();
      },
      onError: (Object _) {
        _receipts = <Receipt>[];
        _isLoading = false;
        _loadError = 'Could not load your receipts. Please try again.';
        notifyListeners();
      },
    );
  }

  void clearMutationError() {
    _mutationError = null;
  }

  void retry() {
    _subscribeToReceipts();
    notifyListeners();
  }

  Receipt? receiptById(String receiptId) {
    for (final Receipt receipt in _receipts) {
      if (receipt.id == receiptId) {
        return receipt;
      }
    }
    return null;
  }

  Future<String?> createReceipt({
    required String storeName,
    required DateTime purchaseDate,
    required double total,
    ReceiptSource source = ReceiptSource.manual,
    String? storeAddress,
    String? placeId,
    String? storeId,
    double? subtotal,
    double? tax,
    String? notes,
    String? categorySummary,
    List<ReceiptItem> items = const <ReceiptItem>[],
  }) async {
    if (_uid == null) {
      _mutationError = 'Sign in to save receipts.';
      notifyListeners();
      return null;
    }

    try {
      _mutationError = null;
      final DateTime now = DateTime.now();
      final Receipt receipt = Receipt(
        id: '',
        userId: _uid!,
        storeName: storeName.trim(),
        storeAddress: _trimOrNull(storeAddress),
        placeId: _trimOrNull(placeId),
        storeId: _trimOrNull(storeId),
        purchaseDate: purchaseDate,
        createdAt: now,
        updatedAt: now,
        subtotal: subtotal,
        tax: tax,
        total: total,
        source: source,
        notes: _trimOrNull(notes),
        categorySummary: _trimOrNull(categorySummary) ?? 'Grocery',
        items: items,
      );
      final String receiptId =
          await _service.createReceipt(_uid!, receipt);
      notifyListeners();
      return receiptId;
    } catch (_) {
      _mutationError = 'Could not save the receipt. Please try again.';
      notifyListeners();
      return null;
    }
  }

  Future<bool> deleteReceipt(String receiptId) async {
    if (_uid == null) return false;

    try {
      _mutationError = null;
      await _service.deleteReceipt(_uid!, receiptId);
      notifyListeners();
      return true;
    } catch (_) {
      _mutationError = 'Could not delete the receipt. Please try again.';
      notifyListeners();
      return false;
    }
  }

  Future<bool> updateReceipt({
    required String receiptId,
    required String storeName,
    required DateTime purchaseDate,
    required double total,
    ReceiptSource? source,
    String? storeAddress,
    String? placeId,
    String? storeId,
    double? subtotal,
    double? tax,
    String? notes,
    String? categorySummary,
    List<ReceiptItem>? items,
  }) async {
    if (_uid == null) {
      _mutationError = 'Sign in to update receipts.';
      notifyListeners();
      return false;
    }

    final Receipt? existing = receiptById(receiptId);
    if (existing == null) {
      _mutationError = 'Receipt not found.';
      notifyListeners();
      return false;
    }

    try {
      _mutationError = null;
      final Receipt updated = existing.copyWith(
        storeName: storeName.trim(),
        purchaseDate: purchaseDate,
        total: total,
        source: source,
        storeAddress: _trimOrNull(storeAddress),
        placeId: _trimOrNull(placeId),
        storeId: _trimOrNull(storeId),
        subtotal: subtotal,
        tax: tax,
        notes: _trimOrNull(notes),
        clearNotes: _trimOrNull(notes) == null,
        categorySummary: _trimOrNull(categorySummary) ?? existing.categorySummary,
        items: items,
        updatedAt: DateTime.now(),
      );
      await _service.updateReceipt(_uid!, updated);
      notifyListeners();
      return true;
    } catch (_) {
      _mutationError = 'Could not update the receipt. Please try again.';
      notifyListeners();
      return false;
    }
  }

  String? _trimOrNull(String? value) {
    if (value == null) return null;
    final String trimmed = value.trim();
    return trimmed.isEmpty ? null : trimmed;
  }

  @override
  void dispose() {
    _authSubscription?.cancel();
    _receiptsSubscription?.cancel();
    super.dispose();
  }
}

class ReceiptProvider extends InheritedNotifier<ReceiptStore> {
  const ReceiptProvider({
    super.key,
    required ReceiptStore notifier,
    required super.child,
  }) : super(notifier: notifier);

  static ReceiptStore of(BuildContext context) {
    final ReceiptProvider? provider =
        context.dependOnInheritedWidgetOfExactType<ReceiptProvider>();
    if (provider == null) {
      throw FlutterError('ReceiptProvider not found');
    }
    return provider.notifier!;
  }
}
