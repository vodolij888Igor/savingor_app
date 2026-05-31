import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/widgets.dart';

import 'package:savingor_app/features/expenses/data/expense_firestore_service.dart';
import 'package:savingor_app/features/expenses/domain/models/user_expense.dart';

/// App-level state for Firestore-backed expenses.
class ExpensesStore extends ChangeNotifier {
  ExpensesStore({
    ExpenseFirestoreService? service,
    FirebaseAuth? firebaseAuth,
  })  : _service = service ?? ExpenseFirestoreService(),
        _firebaseAuth = firebaseAuth ?? FirebaseAuth.instance {
    _authSubscription = _firebaseAuth.authStateChanges().listen(_onAuthChanged);
  }

  final ExpenseFirestoreService _service;
  final FirebaseAuth _firebaseAuth;

  StreamSubscription<User?>? _authSubscription;
  StreamSubscription<List<UserExpense>>? _expensesSubscription;

  String? _uid;
  List<UserExpense> _expenses = <UserExpense>[];

  bool _isLoading = true;
  String? _loadError;
  String? _mutationError;

  List<UserExpense> get expenses => List<UserExpense>.unmodifiable(_expenses);
  String? get uid => _uid;
  bool get isAuthenticated => _uid != null;
  bool get isLoading => _isLoading;
  String? get loadError => _loadError;
  String? get mutationError => _mutationError;

  void _onAuthChanged(User? user) {
    final String? nextUid = user?.uid;
    if (nextUid == _uid) return;
    _uid = nextUid;
    _subscribeToExpenses();
    notifyListeners();
  }

  void _subscribeToExpenses() {
    _expensesSubscription?.cancel();
    _expenses = <UserExpense>[];
    _loadError = null;

    if (_uid == null) {
      _isLoading = false;
      return;
    }

    _isLoading = true;
    _expensesSubscription = _service.watchUserExpenses(_uid!).listen(
      (List<UserExpense> expenses) {
        _expenses = expenses;
        _isLoading = false;
        _loadError = null;
        notifyListeners();
      },
      onError: (Object _) {
        _expenses = <UserExpense>[];
        _isLoading = false;
        _loadError = 'Could not load your expenses. Please try again.';
        notifyListeners();
      },
    );
  }

  void clearMutationError() {
    _mutationError = null;
  }

  void retry() {
    _subscribeToExpenses();
    notifyListeners();
  }

  Future<String?> createExpense({
    required String storeName,
    required DateTime purchaseDate,
    required double totalAmount,
  }) async {
    if (_uid == null) {
      _mutationError = 'Sign in to save expenses.';
      notifyListeners();
      return null;
    }

    try {
      _mutationError = null;
      final String expenseId = await _service.createExpense(
        uid: _uid!,
        storeName: storeName,
        purchaseDate: purchaseDate,
        totalAmount: totalAmount,
      );
      notifyListeners();
      return expenseId;
    } on ExpenseFirestoreException catch (error) {
      _mutationError = error.message;
      notifyListeners();
      return null;
    } catch (_) {
      _mutationError = 'Could not save the expense. Please try again.';
      notifyListeners();
      return null;
    }
  }

  Future<bool> deleteExpense(String expenseId) async {
    if (_uid == null) return false;

    try {
      _mutationError = null;
      await _service.deleteExpense(uid: _uid!, expenseId: expenseId);
      notifyListeners();
      return true;
    } catch (_) {
      _mutationError = 'Could not delete the expense. Please try again.';
      notifyListeners();
      return false;
    }
  }

  @override
  void dispose() {
    _authSubscription?.cancel();
    _expensesSubscription?.cancel();
    super.dispose();
  }
}

class ExpensesProvider extends InheritedNotifier<ExpensesStore> {
  const ExpensesProvider({
    super.key,
    required ExpensesStore notifier,
    required super.child,
  }) : super(notifier: notifier);

  static ExpensesStore of(BuildContext context) {
    final ExpensesProvider? provider =
        context.dependOnInheritedWidgetOfExactType<ExpensesProvider>();
    if (provider == null) {
      throw FlutterError('ExpensesProvider not found');
    }
    return provider.notifier!;
  }
}
