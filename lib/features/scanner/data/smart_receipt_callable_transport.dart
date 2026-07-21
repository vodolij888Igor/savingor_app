import 'package:cloud_functions/cloud_functions.dart';

abstract interface class SmartReceiptCallableTransport {
  Future<Object?> call(Map<String, Object?> payload);
}

class FirebaseSmartReceiptCallableTransport
    implements SmartReceiptCallableTransport {
  FirebaseSmartReceiptCallableTransport({FirebaseFunctions? functions})
      : _functions = functions ??
            FirebaseFunctions.instanceFor(region: 'northamerica-northeast1');

  final FirebaseFunctions _functions;

  @override
  Future<Object?> call(Map<String, Object?> payload) async {
    final HttpsCallable callable = _functions.httpsCallable(
      'extractSmartReceipt',
      options: HttpsCallableOptions(timeout: const Duration(seconds: 55)),
    );
    final HttpsCallableResult<dynamic> result = await callable.call(payload);
    return result.data;
  }
}
