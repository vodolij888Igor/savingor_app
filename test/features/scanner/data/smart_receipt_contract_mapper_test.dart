import 'package:flutter_test/flutter_test.dart';
import 'package:savingor_app/features/scanner/data/smart_receipt_contract_mapper.dart';
import 'package:savingor_app/features/scanner/domain/models/smart_receipt.dart';

void main() {
  group('SmartReceiptContractMapper', () {
    test('builds the bounded callable request without image data', () {
      final Map<String, Object?> payload = SmartReceiptContractMapper.toPayload(
        SmartReceiptRequest(
          rawOcrText: 'Market\n2026-06-12\nTOTAL 12.34',
          locale: 'en_CA',
          currency: 'cad',
          parserCandidate: SmartReceiptData(
            storeName: 'Market',
            purchaseDate: DateTime(2026, 6, 12),
            subtotal: 11,
            tax: 1.34,
            total: 12.34,
            items: const <SmartReceiptItemData>[
              SmartReceiptItemData(
                name: 'Milk',
                quantity: 1,
                unitPrice: 4.99,
                totalPrice: 4.99,
              ),
            ],
          ),
        ),
      );

      expect(payload.keys, <String>{
        'rawOcrText',
        'locale',
        'currency',
        'parserCandidate',
      });
      expect(payload['locale'], 'en-CA');
      expect(payload['currency'], 'CAD');
      expect(payload.keys.any((String key) => key.contains('image')), isFalse);
      final Map<String, Object?> candidate =
          payload['parserCandidate']! as Map<String, Object?>;
      expect(candidate['purchaseDate'], '2026-06-12');
      expect(candidate['total'], 12.34);
    });

    test('maps a complete strict response', () {
      final SmartReceiptData result =
          SmartReceiptContractMapper.fromResponse(_validResponse());

      expect(result.storeName, 'Market');
      expect(result.purchaseDate, DateTime(2026, 6, 12));
      expect(result.currency, 'CAD');
      expect(result.total, 12.34);
      expect(result.items.single.unit, 'each');
      expect(result.items.single.category, 'Dairy');
      expect(result.warningCodes, <String>['IDENTIFIERS_REDACTED']);
    });

    test('rejects incomplete, extra, and invalid responses', () {
      final Map<String, Object?> incomplete = _validResponse();
      (incomplete['receipt']! as Map<String, Object?>).remove('total');
      expect(
        () => SmartReceiptContractMapper.fromResponse(incomplete),
        throwsA(isA<SmartReceiptException>()),
      );

      final Map<String, Object?> extra = _validResponse();
      (extra['receipt']! as Map<String, Object?>)['rawOcrText'] =
          'must not pass';
      expect(
        () => SmartReceiptContractMapper.fromResponse(extra),
        throwsA(isA<SmartReceiptException>()),
      );

      final Map<String, Object?> invalid = _validResponse();
      (invalid['receipt']! as Map<String, Object?>)['total'] = -1;
      expect(
        () => SmartReceiptContractMapper.fromResponse(invalid),
        throwsA(isA<SmartReceiptException>()),
      );
    });
  });
}

Map<String, Object?> _validResponse() {
  return <String, Object?>{
    'receipt': <String, Object?>{
      'storeName': 'Market',
      'purchaseDate': '2026-06-12',
      'currency': 'CAD',
      'subtotal': 11,
      'tax': 1.34,
      'total': 12.34,
      'items': <Object?>[
        <String, Object?>{
          'name': 'Milk',
          'quantity': 1,
          'unit': 'each',
          'unitPrice': 4.99,
          'totalPrice': 4.99,
          'category': 'Dairy',
        },
      ],
      'warningCodes': <String>['IDENTIFIERS_REDACTED'],
    },
    'processing': <String, Object?>{
      'schemaVersion': '1',
      'model': 'gpt-5.6-sol',
      'appCheckVerified': false,
    },
  };
}
