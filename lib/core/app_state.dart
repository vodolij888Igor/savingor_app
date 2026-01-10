import 'package:flutter/widgets.dart';

class AppState extends ChangeNotifier {
  String? _language;

  String? get language => _language;

  void setLanguage(String lang) {
    _language = lang;
    notifyListeners();
  }
}

class AppStateProvider extends InheritedNotifier<AppState> {
  const AppStateProvider({super.key, required AppState notifier, required super.child}) : super(notifier: notifier);

  static AppState of(BuildContext context) {
    final prov = context.dependOnInheritedWidgetOfExactType<AppStateProvider>();
    if (prov == null) throw FlutterError('AppStateProvider not found');
    return prov.notifier!;
  }
}
