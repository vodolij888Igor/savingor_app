import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:savingor_app/features/scanner/data/firebase_smart_receipt_repository.dart';
import 'package:savingor_app/features/scanner/data/smart_receipt_callable_transport.dart';
import 'package:savingor_app/features/scanner/domain/models/smart_receipt.dart';

void main() {
  group('FirebaseSmartReceiptRepository', () {
    test('maps a successful network-boundary response with one call', () async {
      final _FakeTransport transport = _FakeTransport(_validResponse());
      final FirebaseSmartReceiptRepository repository =
          FirebaseSmartReceiptRepository(transport);

      final SmartReceiptData result = await repository.extract(_request());

      expect(transport.callCount, 1);
      expect(result.storeName, 'Market');
      expect(result.total, 12.34);
    });

    test('maps transport timeouts without retrying', () async {
      final _FakeTransport transport = _FakeTransport(
        TimeoutException('transport timed out'),
        throwsValue: true,
      );
      final FirebaseSmartReceiptRepository repository =
          FirebaseSmartReceiptRepository(transport);

      await expectLater(
        repository.extract(_request()),
        throwsA(
          isA<SmartReceiptException>().having(
            (SmartReceiptException error) => error.kind,
            'kind',
            SmartReceiptFailureKind.timeout,
          ),
        ),
      );
      expect(transport.callCount, 1);
    });

    test('maps unexpected provider failures to unavailable', () async {
      final _FakeTransport transport = _FakeTransport(
        StateError('provider failed'),
        throwsValue: true,
      );
      final FirebaseSmartReceiptRepository repository =
          FirebaseSmartReceiptRepository(transport);

      await expectLater(
        repository.extract(_request()),
        throwsA(
          isA<SmartReceiptException>().having(
            (SmartReceiptException error) => error.kind,
            'kind',
            SmartReceiptFailureKind.unavailable,
          ),
        ),
      );
      expect(transport.callCount, 1);
    });
  });

  test('maps callable error codes to controlled fallback reasons', () {
    expect(
      mapSmartReceiptFunctionsFailure('unauthenticated', null),
      SmartReceiptFailureKind.unauthenticated,
    );
    expect(
      mapSmartReceiptFunctionsFailure('resource-exhausted', null),
      SmartReceiptFailureKind.quota,
    );
    expect(
      mapSmartReceiptFunctionsFailure('deadline-exceeded', null),
      SmartReceiptFailureKind.timeout,
    );
    expect(
      mapSmartReceiptFunctionsFailure(
        'failed-precondition',
        <String, Object?>{'warningCode': 'MODEL_REFUSAL'},
      ),
      SmartReceiptFailureKind.refusal,
    );
    expect(
      mapSmartReceiptFunctionsFailure('invalid-argument', null),
      SmartReceiptFailureKind.malformed,
    );
    expect(
      mapSmartReceiptFunctionsFailure('unavailable', null),
      SmartReceiptFailureKind.unavailable,
    );
  });
}

SmartReceiptRequest _request() {
  return const SmartReceiptRequest(
    rawOcrText: 'Market\nTOTAL 12.34',
    locale: 'en-CA',
    currency: 'CAD',
    parserCandidate: SmartReceiptData(total: 12.34),
  );
}

Map<String, Object?> _validResponse() {
  return <String, Object?>{
    'receipt': <String, Object?>{
      'storeName': 'Market',
      'purchaseDate': null,
      'currency': 'CAD',
      'subtotal': null,
      'tax': null,
      'total': 12.34,
      'items': <Object?>[],
      'warningCodes': <String>[],
    },
    'processing': <String, Object?>{
      'schemaVersion': '1',
      'model': 'gpt-5.6-sol',
      'appCheckVerified': false,
    },
  };
}

class _FakeTransport implements SmartReceiptCallableTransport {
  _FakeTransport(this.value, {this.throwsValue = false});

  final Object? value;
  final bool throwsValue;
  int callCount = 0;

  @override
  Future<Object?> call(Map<String, Object?> payload) async {
    callCount++;
    if (throwsValue) throw value!;
    return value;
  }
}
