import 'package:flutter/widgets.dart';

class FavoritesStore extends ChangeNotifier {
  final Set<String> _ids = <String>{};

  bool isSaved(String id) => _ids.contains(id);

  void toggle(String id) {
    if (_ids.contains(id)) {
      _ids.remove(id);
    } else {
      _ids.add(id);
    }
    notifyListeners();
  }

  Set<String> get savedIds => Set.unmodifiable(_ids);
}

class FavoritesProvider extends InheritedNotifier<FavoritesStore> {
  const FavoritesProvider(
      {super.key, required FavoritesStore notifier, required super.child})
      : super(notifier: notifier);

  static FavoritesStore of(BuildContext context) {
    final provider =
        context.dependOnInheritedWidgetOfExactType<FavoritesProvider>();
    if (provider == null) {
      throw FlutterError('FavoritesProvider not found');
    }

    return provider.notifier!;
  }
}
