import 'package:savingor_app/features/receipts/domain/models/receipt_source.dart';
import 'package:savingor_app/features/scanner/data/receipt_ocr_parser.dart';
import 'package:savingor_app/features/scanner/domain/models/smart_receipt.dart';
import 'package:savingor_app/features/scanner/domain/smart_receipt_repository.dart';

class SmartReceiptEnhancer {
  const SmartReceiptEnhancer(this._repository);

  final SmartReceiptRepository _repository;

  Future<SmartReceiptDraft> enhance({
    required ParsedReceiptData parsed,
    required ReceiptSource source,
    required String locale,
    required String currency,
    required bool isAuthenticated,
  }) async {
    final SmartReceiptDraft local = SmartReceiptDraft.fromLocalParser(
      parsed: parsed,
      currency: currency,
      source: source,
    );
    if (!isAuthenticated) {
      return SmartReceiptDraft.fromLocalParser(
        parsed: parsed,
        currency: currency,
        source: source,
        fallbackReason: SmartReceiptFailureKind.unauthenticated,
      );
    }

    try {
      final SmartReceiptData enhanced = await _repository.extract(
        SmartReceiptRequest(
          rawOcrText: parsed.rawText,
          locale: locale,
          currency: currency,
          parserCandidate: local.data,
        ),
      );
      return SmartReceiptDraft(
        data: _merge(enhanced, local.data),
        rawOcrText: parsed.rawText,
        source: source,
        provenance: SmartReceiptProvenance.aiEnhanced,
      );
    } on SmartReceiptException catch (error) {
      return SmartReceiptDraft.fromLocalParser(
        parsed: parsed,
        currency: currency,
        source: source,
        fallbackReason: error.kind,
      );
    } catch (_) {
      return SmartReceiptDraft.fromLocalParser(
        parsed: parsed,
        currency: currency,
        source: source,
        fallbackReason: SmartReceiptFailureKind.unavailable,
      );
    }
  }

  SmartReceiptData _merge(
    SmartReceiptData enhanced,
    SmartReceiptData local,
  ) {
    final int itemCount = enhanced.items.length > local.items.length
        ? enhanced.items.length
        : local.items.length;
    final List<SmartReceiptItemData> items = <SmartReceiptItemData>[];
    for (int index = 0;
        index < itemCount && index < kSmartReceiptMaximumItems;
        index++) {
      final SmartReceiptItemData? ai =
          index < enhanced.items.length ? enhanced.items[index] : null;
      final SmartReceiptItemData? fallback =
          index < local.items.length ? local.items[index] : null;
      if (ai == null && fallback != null) {
        items.add(fallback);
        continue;
      }
      if (ai == null) continue;
      items.add(
        SmartReceiptItemData(
          name: ai.name ?? fallback?.name,
          quantity: ai.quantity ?? fallback?.quantity,
          unit: ai.unit ?? fallback?.unit,
          unitPrice: ai.unitPrice ?? fallback?.unitPrice,
          totalPrice: ai.totalPrice ?? fallback?.totalPrice,
          category: ai.category ?? fallback?.category,
        ),
      );
    }

    return SmartReceiptData(
      storeName: enhanced.storeName ?? local.storeName,
      purchaseDate: enhanced.purchaseDate ?? local.purchaseDate,
      currency: enhanced.currency ?? local.currency,
      subtotal: enhanced.subtotal ?? local.subtotal,
      tax: enhanced.tax ?? local.tax,
      total: enhanced.total ?? local.total,
      items: items,
      warningCodes: enhanced.warningCodes,
    );
  }
}
