import 'package:flutter/widgets.dart';
import 'shopping_item.dart';
import 'package:savingor_app/features/deals/domain/models/deal.dart';

class ShoppingListStore extends ChangeNotifier {
  final List<ShoppingItem> _items = [];

  List<ShoppingItem> get items => List.unmodifiable(_items);

  void addFromDeal(Deal deal) {
    final existing = _items.where((i) => i.id == deal.id).toList();
    if (existing.isNotEmpty) {
      existing.first.qty += 1;
    } else {
      _items.add(ShoppingItem(
        id: deal.id,
        title: deal.title,
        store: deal.store,
        price: deal.price,
      ));
    }
    notifyListeners();
  }

  void addCustom(String title, {String? store, double? price}) {
    final id = DateTime.now().microsecondsSinceEpoch.toString();
    _items.add(ShoppingItem(id: id, title: title, store: store, price: price));
    notifyListeners();
  }

  void increment(String id) {
    final item = _items.firstWhere((i) => i.id == id,
        orElse: () => throw StateError('Item not found'));
    item.qty += 1;
    notifyListeners();
  }

  void decrement(String id) {
    final item = _items.firstWhere((i) => i.id == id,
        orElse: () => throw StateError('Item not found'));
    if (item.qty > 1) item.qty -= 1;
    notifyListeners();
  }

  void toggleChecked(String id) {
    final item = _items.firstWhere((i) => i.id == id,
        orElse: () => throw StateError('Item not found'));
    item.isChecked = !item.isChecked;
    notifyListeners();
  }

  void remove(String id) {
    _items.removeWhere((i) => i.id == id);
    notifyListeners();
  }

  void clearChecked() {
    _items.removeWhere((i) => i.isChecked);
    notifyListeners();
  }

  double get totalEstimate {
    double total = 0.0;
    for (final i in _items) {
      if (i.price != null && !i.isChecked) {
        total += i.price! * i.qty;
      }
    }
    return total;
  }
}

class ShoppingListProvider extends InheritedNotifier<ShoppingListStore> {
  const ShoppingListProvider(
      {super.key, required ShoppingListStore notifier, required super.child})
      : super(notifier: notifier);

  static ShoppingListStore of(BuildContext context) {
    final provider =
        context.dependOnInheritedWidgetOfExactType<ShoppingListProvider>();
    if (provider == null) throw FlutterError('ShoppingListProvider not found');
    return provider.notifier!;
  }
}
