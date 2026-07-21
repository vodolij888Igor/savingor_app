import 'dart:async';

import 'package:cloud_functions/cloud_functions.dart';
import 'package:savingor_app/features/scanner/data/smart_receipt_callable_transport.dart';
import 'package:savingor_app/features/scanner/data/smart_receipt_contract_mapper.dart';
import 'package:savingor_app/features/scanner/domain/models/smart_receipt.dart';
import 'package:savingor_app/features/scanner/domain/smart_receipt_repository.dart';

class FirebaseSmartReceiptRepository implements SmartReceiptRepository {
  FirebaseSmartReceiptRepository(this._transport);

  final SmartReceiptCallableTransport _transport;

  @override
  Future<SmartReceiptData> extract(SmartReceiptRequest request) async {
    try {
      final Object? response =
          await _transport.call(SmartReceiptContractMapper.toPayload(request));
      return SmartReceiptContractMapper.fromResponse(response);
    } on SmartReceiptException {
      rethrow;
    } on TimeoutException {
      throw const SmartReceiptException(SmartReceiptFailureKind.timeout);
    } on FirebaseFunctionsException catch (error) {
      throw SmartReceiptException(
        mapSmartReceiptFunctionsFailure(error.code, error.details),
      );
    } catch (_) {
      throw const SmartReceiptException(SmartReceiptFailureKind.unavailable);
    }
  }
}

SmartReceiptFailureKind mapSmartReceiptFunctionsFailure(
  String code,
  Object? details,
) {
  switch (code) {
    case 'unauthenticated':
      return SmartReceiptFailureKind.unauthenticated;
    case 'resource-exhausted':
      return SmartReceiptFailureKind.quota;
    case 'deadline-exceeded':
    case 'cancelled':
      return SmartReceiptFailureKind.timeout;
    case 'failed-precondition':
      if (details is Map && details['warningCode'] == 'MODEL_REFUSAL') {
        return SmartReceiptFailureKind.refusal;
      }
      return SmartReceiptFailureKind.unavailable;
    case 'invalid-argument':
      return SmartReceiptFailureKind.malformed;
    default:
      return SmartReceiptFailureKind.unavailable;
  }
}
