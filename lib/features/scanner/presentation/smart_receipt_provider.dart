import 'package:flutter/widgets.dart';
import 'package:savingor_app/features/scanner/data/firebase_smart_receipt_repository.dart';
import 'package:savingor_app/features/scanner/data/smart_receipt_callable_transport.dart';
import 'package:savingor_app/features/scanner/domain/smart_receipt_repository.dart';

class SmartReceiptProvider extends InheritedWidget {
  const SmartReceiptProvider({
    super.key,
    required this.repository,
    required super.child,
  });

  final SmartReceiptRepository repository;

  static SmartReceiptRepository of(BuildContext context) {
    final SmartReceiptProvider? provider =
        context.dependOnInheritedWidgetOfExactType<SmartReceiptProvider>();
    assert(provider != null, 'No SmartReceiptProvider found in context.');
    return provider!.repository;
  }

  @override
  bool updateShouldNotify(SmartReceiptProvider oldWidget) {
    return repository != oldWidget.repository;
  }
}

SmartReceiptRepository createDefaultSmartReceiptRepository() {
  return FirebaseSmartReceiptRepository(
    FirebaseSmartReceiptCallableTransport(),
  );
}
