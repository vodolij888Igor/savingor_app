import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/widgets.dart';

import 'package:savingor_app/features/receipts/data/receipt_firestore_service.dart';
import 'package:savingor_app/features/receipts/domain/models/receipt.dart';
import 'package:savingor_app/features/receipts/domain/models/receipt_item.dart';
import 'package:savingor_app/features/receipts/domain/models/receipt_source.dart';
import 'package:savingor_app/features/price_memory/data/price_memory_repository.dart';
import 'package:savingor_app/features/scanner/domain/models/monthly_receipt_scan_usage.dart';
import 'package:savingor_app/features/scanner/domain/monthly_receipt_scan_usage_service.dart';
import 'package:savingor_app/features/subscription/data/subscription_service.dart';

/// Error key returned when a Free user exceeds the monthly scan limit.
const String kMonthlyReceiptScanLimitReachedError =
    'monthly_receipt_scan_limit_reached';

/// App-level state for Firestore-backed grocery receipts.
class ReceiptStore extends ChangeNotifier {
  ReceiptStore({
    ReceiptFirestoreService? service,
    PriceMemoryRepository? priceMemoryRepository,
    FirebaseAuth? firebaseAuth,
    SubscriptionService? subscriptionService,
    MonthlyReceiptScanUsageService? scanUsageService,
  })  : _service = service ?? ReceiptFirestoreService(),
        _priceMemory = priceMemoryRepository ?? PriceMemoryRepository(),
        _firebaseAuth = firebaseAuth ?? FirebaseAuth.instance,
        _subscriptionService = subscriptionService ?? SubscriptionService(),
        _scanUsageService =
            scanUsageService ?? const MonthlyReceiptScanUsageService() {
    _authSubscription = _firebaseAuth.authStateChanges().listen(_onAuthChanged);
  }

  final ReceiptFirestoreService _service;
  final PriceMemoryRepository _priceMemory;
  final FirebaseAuth _firebaseAuth;
  final SubscriptionService _subscriptionService;
  final MonthlyReceiptScanUsageService _scanUsageService;

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

  MonthlyReceiptScanUsageService get scanUsageService => _scanUsageService;

  Future<MonthlyReceiptScanUsage> loadMonthlyScanUsage() async {
    final SubscriptionStatus status =
        await _subscriptionService.getCurrentSubscription();
    return _scanUsageService.computeUsage(
      receipts: _receipts,
      isPro: status.hasActiveProAccess,
      userId: _uid,
    );
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
    String? ocrRawText,
    String? categorySummary,
    List<ReceiptItem> items = const <ReceiptItem>[],
    String currency = 'CAD',
  }) async {
    if (_uid == null) {
      _mutationError = 'Sign in to save receipts.';
      notifyListeners();
      return null;
    }

    try {
      _mutationError = null;

      if (source.isFromImageCapture) {
        final SubscriptionStatus status =
            await _subscriptionService.getCurrentSubscription();
        final MonthlyReceiptScanUsage usage = _scanUsageService.computeUsage(
          receipts: _receipts,
          isPro: status.hasActiveProAccess,
          userId: _uid,
        );
        if (!_scanUsageService.canSaveNewScannedReceipt(
          source: source,
          usage: usage,
          isNewReceipt: true,
        )) {
          _mutationError = kMonthlyReceiptScanLimitReachedError;
          notifyListeners();
          return null;
        }
      }

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
        currency: currency.toUpperCase(),
        source: source,
        notes: _trimOrNull(notes),
        ocrRawText: _trimOrNull(ocrRawText),
        categorySummary: _trimOrNull(categorySummary) ?? 'Grocery',
        items: items,
      );
      final String receiptId = await _service.createReceipt(_uid!, receipt);
      final Receipt savedReceipt = receipt.copyWith(id: receiptId);
      await _syncPriceMemory(savedReceipt);
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
      try {
        await _priceMemory.deleteForReceipt(
          userId: _uid!,
          receiptId: receiptId,
        );
      } catch (error) {
        debugPrint(
          'PriceMemory: cleanup failed for receiptId=$receiptId: $error',
        );
      }
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
        categorySummary:
            _trimOrNull(categorySummary) ?? existing.categorySummary,
        items: items,
        updatedAt: DateTime.now(),
      );
      await _service.updateReceipt(_uid!, updated);
      await _syncPriceMemory(updated);
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

  Future<void> _syncPriceMemory(Receipt receipt) async {
    try {
      await _priceMemory.syncFromReceipt(receipt);
    } catch (error) {
      debugPrint(
        'PriceMemory: sync failed for receiptId=${receipt.id}: $error',
      );
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
