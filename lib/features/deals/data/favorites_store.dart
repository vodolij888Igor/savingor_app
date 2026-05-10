import 'package:flutter/widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FavoritesStore extends ChangeNotifier {
  static const _kPrefsKey = 'favorites_ids';

  final Set<String> _ids = <String>{};

  /// Load saved ids from local storage. Call once before showing UI.
  Future<void> init() async {
    final prefs = await SharedPreferences.getInstance();
    final list = prefs.getStringList(_kPrefsKey) ?? <String>[];
    _ids
      ..clear()
      ..addAll(list);
    notifyListeners();
  }

  bool isSaved(String id) => _ids.contains(id);

  void toggle(String id) {
    if (_ids.contains(id)) {
      _ids.remove(id);
    } else {
      _ids.add(id);
    }
    // persist asynchronously (fire-and-forget)
    SharedPreferences.getInstance().then((prefs) {
      prefs.setStringList(_kPrefsKey, _ids.toList());
    });
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
