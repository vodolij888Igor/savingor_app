import 'package:savingor_app/features/receipts/domain/models/receipt_source.dart';
import 'package:savingor_app/features/scanner/data/receipt_ocr_parser.dart';

const int kSmartReceiptMaximumItems = 50;

enum SmartReceiptProvenance { aiEnhanced, localParser }

enum SmartReceiptFailureKind {
  unauthenticated,
  quota,
  timeout,
  refusal,
  malformed,
  unavailable,
}

class SmartReceiptItemData {
  const SmartReceiptItemData({
    this.name,
    this.quantity,
    this.unit,
    this.unitPrice,
    this.totalPrice,
    this.category,
  });

  final String? name;
  final double? quantity;
  final String? unit;
  final double? unitPrice;
  final double? totalPrice;
  final String? category;
}

class SmartReceiptData {
  const SmartReceiptData({
    this.storeName,
    this.purchaseDate,
    this.currency,
    this.subtotal,
    this.tax,
    this.total,
    this.items = const <SmartReceiptItemData>[],
    this.warningCodes = const <String>[],
  });

  final String? storeName;
  final DateTime? purchaseDate;
  final String? currency;
  final double? subtotal;
  final double? tax;
  final double? total;
  final List<SmartReceiptItemData> items;
  final List<String> warningCodes;
}

class SmartReceiptRequest {
  const SmartReceiptRequest({
    required this.rawOcrText,
    required this.locale,
    required this.currency,
    required this.parserCandidate,
  });

  final String rawOcrText;
  final String locale;
  final String currency;
  final SmartReceiptData parserCandidate;
}

class SmartReceiptDraft {
  const SmartReceiptDraft({
    required this.data,
    required this.rawOcrText,
    required this.source,
    required this.provenance,
    this.fallbackReason,
  });

  final SmartReceiptData data;
  final String rawOcrText;
  final ReceiptSource source;
  final SmartReceiptProvenance provenance;
  final SmartReceiptFailureKind? fallbackReason;

  factory SmartReceiptDraft.fromLocalParser({
    required ParsedReceiptData parsed,
    required String currency,
    required ReceiptSource source,
    SmartReceiptFailureKind? fallbackReason,
  }) {
    return SmartReceiptDraft(
      data: SmartReceiptData(
        storeName: parsed.storeName,
        purchaseDate: parsed.date,
        currency: currency,
        subtotal: parsed.subtotal,
        tax: parsed.tax,
        total: parsed.total,
        items: parsed.lineItems
            .take(kSmartReceiptMaximumItems)
            .map(
              (ParsedReceiptLineItem item) => SmartReceiptItemData(
                name: item.name,
                quantity: item.quantity,
                unitPrice: item.unitPrice,
                totalPrice: item.lineTotal,
              ),
            )
            .toList(growable: false),
      ),
      rawOcrText: parsed.rawText,
      source: source,
      provenance: SmartReceiptProvenance.localParser,
      fallbackReason: fallbackReason,
    );
  }
}

class SmartReceiptException implements Exception {
  const SmartReceiptException(this.kind);

  final SmartReceiptFailureKind kind;
}
