import 'package:savingor_app/features/receipts/domain/models/receipt_item.dart';
import 'package:savingor_app/features/receipts/domain/models/receipt_source.dart';
import 'package:savingor_app/features/scanner/data/receipt_ocr_parser.dart';
import 'package:savingor_app/features/scanner/domain/models/smart_receipt.dart';

/// Converts OCR parse output into editable receipt draft values.
abstract final class ReceiptOcrDraftMapper {
  /// Builds [ReceiptItem] drafts for the create/edit receipt form.
  ///
  /// Items without a recognized price are included with [totalPrice] 0 so the
  /// user can fill them in manually. Price memory sync skips zero-price lines.
  static List<ReceiptItem> toReceiptItems(ParsedReceiptData parsed) {
    final List<ReceiptItem> items = <ReceiptItem>[];
    int index = 0;

    for (final ParsedReceiptLineItem line in parsed.lineItems) {
      final String name = line.name.trim();
      if (name.isEmpty) continue;

      final double quantity = line.quantity ?? 1;
      final double totalPrice = line.hasRecognizedPrice ? line.lineTotal! : 0;
      final double? unitPrice = line.hasRecognizedPrice
          ? (line.unitPrice ??
              (quantity > 0 ? totalPrice / quantity : totalPrice))
          : null;

      items.add(
        ReceiptItem(
          id: 'ocr_item_${DateTime.now().microsecondsSinceEpoch}_$index',
          name: name,
          quantity: quantity,
          unitPrice: unitPrice,
          totalPrice: totalPrice,
          confidence: line.hasRecognizedPrice ? 0.75 : null,
        ),
      );
      index++;
    }

    return items;
  }

  /// Builds GoRouter `extra` for the create-receipt form from OCR output.
  ///
  /// User-visible [notes] are intentionally omitted. Raw OCR text is passed
  /// separately via [initialOcrRawText] for technical storage only.
  static Map<String, dynamic> buildCreateReceiptExtra({
    required ParsedReceiptData parsed,
    required ReceiptSource receiptSource,
  }) {
    final List<ReceiptItem> draftItems = toReceiptItems(parsed);

    return <String, dynamic>{
      'initialStoreName': parsed.storeName,
      'initialDate': parsed.date,
      'initialTotal': parsed.total,
      'initialSubtotal': parsed.subtotal,
      'initialTax': parsed.tax,
      'initialCategory': 'Grocery',
      if (parsed.rawText.trim().isNotEmpty) 'initialOcrRawText': parsed.rawText,
      'initialItems': itemsToExtra(draftItems),
      'initialSource': receiptSource.value,
    };
  }

  /// Builds editable route values from either an AI-enhanced or local draft.
  /// Saving remains an explicit action on the existing receipt review screen.
  static Map<String, dynamic> buildSmartReceiptExtra(SmartReceiptDraft draft) {
    final List<ReceiptItem> items = <ReceiptItem>[];
    for (int index = 0; index < draft.data.items.length; index++) {
      final SmartReceiptItemData item = draft.data.items[index];
      final String name = item.name?.trim() ?? '';
      if (name.isEmpty) continue;
      final double quantity = item.quantity ?? 1;
      final double totalPrice = item.totalPrice ?? 0;
      items.add(
        ReceiptItem(
          id: 'smart_receipt_item_$index',
          name: name,
          quantity: quantity,
          unit: item.unit,
          unitPrice: item.unitPrice ??
              (quantity > 0 && totalPrice > 0 ? totalPrice / quantity : null),
          totalPrice: totalPrice,
          category: item.category,
          confidence: draft.provenance == SmartReceiptProvenance.aiEnhanced
              ? 0.85
              : 0.75,
        ),
      );
    }

    return <String, dynamic>{
      'initialStoreName': draft.data.storeName,
      'initialDate': draft.data.purchaseDate,
      'initialTotal': draft.data.total,
      'initialSubtotal': draft.data.subtotal,
      'initialTax': draft.data.tax,
      'initialCategory': 'Grocery',
      'initialCurrency': draft.data.currency,
      if (draft.rawOcrText.trim().isNotEmpty)
        'initialOcrRawText': draft.rawOcrText,
      'initialItems': itemsToExtra(items),
      'initialSource': draft.source.value,
      'smartReceiptProvenance': draft.provenance.name,
      'smartReceiptWarningCodes': draft.data.warningCodes,
      if (draft.fallbackReason != null)
        'smartReceiptFallbackReason': draft.fallbackReason!.name,
    };
  }

  /// Serializes draft items for GoRouter `extra` maps.
  static List<Map<String, dynamic>> itemsToExtra(
    List<ReceiptItem> items,
  ) {
    return items
        .map(
          (ReceiptItem item) => <String, dynamic>{
            'name': item.name,
            'quantity': item.quantity,
            'totalPrice': item.totalPrice,
            if (item.unitPrice != null) 'unitPrice': item.unitPrice,
            if (item.unit != null) 'unit': item.unit,
            if (item.category != null) 'category': item.category,
          },
        )
        .toList(growable: false);
  }

  /// Restores draft items from GoRouter `extra` maps.
  static List<ReceiptItem> itemsFromExtra(List<dynamic>? rawItems) {
    if (rawItems == null || rawItems.isEmpty) {
      return const <ReceiptItem>[];
    }

    final List<ReceiptItem> items = <ReceiptItem>[];
    int index = 0;

    for (final dynamic raw in rawItems) {
      if (raw is! Map) continue;
      final String name = (raw['name'] as String?)?.trim() ?? '';
      if (name.isEmpty) continue;

      final double quantity = _parseDouble(raw['quantity'], fallback: 1);
      final double totalPrice = _parseDouble(raw['totalPrice']);
      final double? unitPrice = _nullableDouble(raw['unitPrice']);
      final String? unit = (raw['unit'] as String?)?.trim();
      final String? category = (raw['category'] as String?)?.trim();

      items.add(
        ReceiptItem(
          id: 'ocr_item_restored_$index',
          name: name,
          quantity: quantity,
          unit: unit == null || unit.isEmpty ? null : unit,
          unitPrice: unitPrice ??
              (quantity > 0 && totalPrice > 0 ? totalPrice / quantity : null),
          totalPrice: totalPrice,
          category: category == null || category.isEmpty ? null : category,
        ),
      );
      index++;
    }

    return items;
  }

  static double _parseDouble(Object? value, {double fallback = 0}) {
    if (value == null) return fallback;
    if (value is double) return value;
    if (value is int) return value.toDouble();
    if (value is num) return value.toDouble();
    if (value is String) return double.tryParse(value.trim()) ?? fallback;
    return fallback;
  }

  static double? _nullableDouble(Object? value) {
    if (value == null) return null;
    final double parsed = _parseDouble(value, fallback: double.nan);
    return parsed.isFinite ? parsed : null;
  }
}
