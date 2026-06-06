import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/widgets.dart';

import 'package:savingor_app/features/price_memory/data/price_memory_firestore_service.dart';
import 'package:savingor_app/features/price_memory/domain/models/product_price_insight.dart';
import 'package:savingor_app/features/price_memory/domain/models/product_price_record.dart';
import 'package:savingor_app/features/price_memory/domain/product_price_insights_grouper.dart';
import 'package:savingor_app/features/price_memory/domain/savings_opportunity_finder.dart';
import 'package:savingor_app/features/price_memory/domain/models/savings_opportunity.dart';

/// App-level state for Firestore-backed product price memory.
class PriceMemoryStore extends ChangeNotifier {
  PriceMemoryStore({
    PriceMemoryFirestoreService? service,
    FirebaseAuth? firebaseAuth,
  })  : _service = service ?? PriceMemoryFirestoreService(),
        _firebaseAuth = firebaseAuth ?? FirebaseAuth.instance {
    _authSubscription = _firebaseAuth.authStateChanges().listen(_onAuthChanged);
  }

  final PriceMemoryFirestoreService _service;
  final FirebaseAuth _firebaseAuth;

  StreamSubscription<User?>? _authSubscription;
  StreamSubscription<List<ProductPriceRecord>>? _recordsSubscription;

  String? _uid;
  List<ProductPriceRecord> _records = <ProductPriceRecord>[];

  bool _isLoading = true;
  String? _loadError;

  List<ProductPriceRecord> get records => List<ProductPriceRecord>.unmodifiable(_records);
  List<ProductPriceInsight> get insights =>
      ProductPriceInsightsGrouper.group(_records);

  List<SavingsOpportunity> get savingsOpportunities =>
      SavingsOpportunityFinder.find(_records);

  String? get uid => _uid;
  bool get isAuthenticated => _uid != null;
  bool get isLoading => _isLoading;
  String? get loadError => _loadError;
  bool get hasRecords => _records.isNotEmpty;

  ProductPriceInsight? insightForNormalizedName(String normalizedProductName) {
    return ProductPriceInsightsGrouper.findInsight(
      records: _records,
      normalizedProductName: normalizedProductName,
    );
  }

  void _onAuthChanged(User? user) {
    final String? nextUid = user?.uid;
    if (nextUid == _uid) {
      return;
    }
    _uid = nextUid;
    _subscribeToRecords();
    notifyListeners();
  }

  void _subscribeToRecords() {
    _recordsSubscription?.cancel();
    _records = <ProductPriceRecord>[];
    _loadError = null;

    if (_uid == null) {
      _isLoading = false;
      return;
    }

    _isLoading = true;
    _recordsSubscription =
        _service.watchPriceRecordsForUser(_uid!).listen(
      (List<ProductPriceRecord> records) {
        _records = records;
        _isLoading = false;
        _loadError = null;
        notifyListeners();
      },
      onError: (Object _) {
        _records = <ProductPriceRecord>[];
        _isLoading = false;
        _loadError = 'Could not load your price memory. Please try again.';
        notifyListeners();
      },
    );
  }

  void retry() {
    _subscribeToRecords();
    notifyListeners();
  }

  @override
  void dispose() {
    _authSubscription?.cancel();
    _recordsSubscription?.cancel();
    super.dispose();
  }
}

class PriceMemoryProvider extends InheritedNotifier<PriceMemoryStore> {
  const PriceMemoryProvider({
    super.key,
    required PriceMemoryStore notifier,
    required super.child,
  }) : super(notifier: notifier);

  static PriceMemoryStore of(BuildContext context) {
    final PriceMemoryProvider? provider =
        context.dependOnInheritedWidgetOfExactType<PriceMemoryProvider>();
    if (provider == null) {
      throw FlutterError('PriceMemoryProvider not found');
    }
    return provider.notifier!;
  }
}
