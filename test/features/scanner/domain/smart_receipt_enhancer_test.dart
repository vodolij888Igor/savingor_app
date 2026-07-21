import 'package:flutter_test/flutter_test.dart';
import 'package:savingor_app/features/receipts/domain/models/receipt_source.dart';
import 'package:savingor_app/features/scanner/data/receipt_ocr_parser.dart';
import 'package:savingor_app/features/scanner/domain/models/smart_receipt.dart';
import 'package:savingor_app/features/scanner/domain/smart_receipt_enhancer.dart';
import 'package:savingor_app/features/scanner/domain/smart_receipt_repository.dart';

void main() {
  const ParsedReceiptData local = ParsedReceiptData(
    storeName: 'LOCAL MARKET',
    subtotal: 10,
    tax: 1.30,
    total: 11.30,
    lineItems: <ParsedReceiptLineItem>[
      ParsedReceiptLineItem(
        name: 'MILK',
        quantity: 1,
        unitPrice: 4.50,
        lineTotal: 4.50,
      ),
    ],
    rawText: 'LOCAL MARKET\nMILK 4.50\nTOTAL 11.30',
  );

  test('authenticated extraction returns an editable AI-enhanced draft',
      () async {
    final _FakeRepository repository = _FakeRepository(
      result: const SmartReceiptData(
        storeName: 'Local Market',
        currency: 'CAD',
        total: 11.30,
        items: <SmartReceiptItemData>[
          SmartReceiptItemData(
            name: 'Milk 2%',
            quantity: 1,
            unit: '2 L',
            unitPrice: 4.50,
            totalPrice: 4.50,
            category: 'Dairy',
          ),
        ],
        warningCodes: <String>['UNCERTAIN_TAX'],
      ),
    );

    final SmartReceiptDraft draft =
        await SmartReceiptEnhancer(repository).enhance(
      parsed: local,
      source: ReceiptSource.gallery,
      locale: 'en-CA',
      currency: 'CAD',
      isAuthenticated: true,
    );

    expect(repository.callCount, 1);
    expect(draft.provenance, SmartReceiptProvenance.aiEnhanced);
    expect(draft.rawOcrText, local.rawText);
    expect(draft.data.storeName, 'Local Market');
    expect(draft.data.subtotal, 10, reason: 'null AI values use local fields');
    expect(draft.data.items.single.unit, '2 L');
    expect(draft.data.items.single.category, 'Dairy');
    expect(draft.data.warningCodes, <String>['UNCERTAIN_TAX']);
  });

  test('unauthenticated flow uses the local parser without a network call',
      () async {
    final _FakeRepository repository = _FakeRepository(
      result: const SmartReceiptData(),
    );

    final SmartReceiptDraft draft =
        await SmartReceiptEnhancer(repository).enhance(
      parsed: local,
      source: ReceiptSource.scanned,
      locale: 'en-CA',
      currency: 'CAD',
      isAuthenticated: false,
    );

    expect(repository.callCount, 0);
    expect(draft.provenance, SmartReceiptProvenance.localParser);
    expect(draft.fallbackReason, SmartReceiptFailureKind.unauthenticated);
    expect(draft.data.storeName, local.storeName);
  });

  for (final SmartReceiptFailureKind kind in <SmartReceiptFailureKind>[
    SmartReceiptFailureKind.timeout,
    SmartReceiptFailureKind.refusal,
    SmartReceiptFailureKind.quota,
    SmartReceiptFailureKind.unavailable,
    SmartReceiptFailureKind.malformed,
  ]) {
    test('$kind falls back locally with no retry or automatic save', () async {
      final _FakeRepository repository = _FakeRepository(error: kind);

      final SmartReceiptDraft draft =
          await SmartReceiptEnhancer(repository).enhance(
        parsed: local,
        source: ReceiptSource.scanned,
        locale: 'en-CA',
        currency: 'CAD',
        isAuthenticated: true,
      );

      expect(repository.callCount, 1, reason: 'fallback must not retry');
      expect(draft.provenance, SmartReceiptProvenance.localParser);
      expect(draft.fallbackReason, kind);
      expect(draft.data.total, 11.30);
      expect(draft.rawOcrText, local.rawText);
      // Enhancement only returns an editable draft. ReceiptStore is not a
      // dependency, so persistence cannot occur until the review form saves.
    });
  }
}

class _FakeRepository implements SmartReceiptRepository {
  _FakeRepository({this.result, this.error});

  final SmartReceiptData? result;
  final SmartReceiptFailureKind? error;
  int callCount = 0;

  @override
  Future<SmartReceiptData> extract(SmartReceiptRequest request) async {
    callCount++;
    if (error != null) throw SmartReceiptException(error!);
    return result!;
  }
}
