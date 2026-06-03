import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/widgets.dart';

import 'package:savingor_app/features/scanner/data/receipt_firestore_service.dart';
import 'package:savingor_app/features/scanner/domain/models/receipt.dart';

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

  Future<String?> createReceipt({
    required String storeName,
    required DateTime date,
    required String category,
    required double total,
    String? notes,
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
        date: date,
        category: category.trim(),
        total: total,
        notes: notes?.trim().isEmpty ?? true ? null : notes?.trim(),
        createdAt: now,
        updatedAt: now,
      );
      final String receiptId = await _service.createReceipt(receipt);
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
      await _service.deleteReceipt(receiptId);
      notifyListeners();
      return true;
    } catch (_) {
      _mutationError = 'Could not delete the receipt. Please try again.';
      notifyListeners();
      return false;
    }
  }

  Receipt? _findReceiptById(String receiptId) {
    for (final Receipt receipt in _receipts) {
      if (receipt.id == receiptId) return receipt;
    }
    return null;
  }

  Future<bool> updateReceipt({
    required String receiptId,
    required String storeName,
    required DateTime date,
    required String category,
    required double total,
    String? notes,
  }) async {
    if (_uid == null) {
      _mutationError = 'Sign in to update receipts.';
      notifyListeners();
      return false;
    }

    final Receipt? existing = _findReceiptById(receiptId);
    if (existing == null) {
      _mutationError = 'Receipt not found.';
      notifyListeners();
      return false;
    }

    try {
      _mutationError = null;
      final String? trimmedNotes =
          notes?.trim().isEmpty ?? true ? null : notes?.trim();
      final Receipt updated = existing.copyWith(
        storeName: storeName.trim(),
        date: date,
        category: category.trim(),
        total: total,
        notes: trimmedNotes,
        clearNotes: trimmedNotes == null,
        updatedAt: DateTime.now(),
      );
      await _service.updateReceipt(updated);
      notifyListeners();
      return true;
    } catch (_) {
      _mutationError = 'Could not update the receipt. Please try again.';
      notifyListeners();
      return false;
    }
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
