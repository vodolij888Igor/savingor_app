import 'package:savingor_app/features/scanner/domain/models/smart_receipt.dart';

abstract final class SmartReceiptContractMapper {
  static const Set<String> _warningCodes = <String>{
    'OCR_AMBIGUOUS',
    'UNCERTAIN_STORE_NAME',
    'UNCERTAIN_PURCHASE_DATE',
    'UNCERTAIN_CURRENCY',
    'UNCERTAIN_SUBTOTAL',
    'UNCERTAIN_TAX',
    'UNCERTAIN_TOTAL',
    'UNCERTAIN_ITEM',
    'IDENTIFIERS_REDACTED',
    'MODEL_OUTPUT_INVALID',
    'STORE_NAME_INVALID',
    'PURCHASE_DATE_INVALID',
    'PURCHASE_DATE_OUT_OF_RANGE',
    'CURRENCY_INVALID',
    'CURRENCY_CONFLICT',
    'MONETARY_VALUE_INVALID',
    'ITEM_VALUE_INVALID',
    'ITEM_COUNT_TRUNCATED',
    'SUBTOTAL_TAX_TOTAL_MISMATCH',
    'ITEM_TOTAL_MISMATCH',
    'ITEM_ARITHMETIC_MISMATCH',
  };

  static Map<String, Object?> toPayload(SmartReceiptRequest request) {
    return <String, Object?>{
      // Leave headroom beneath the backend's 32 KiB whole-payload limit even
      // when all 50 bounded parser candidates are present.
      'rawOcrText': _bounded(request.rawOcrText, 10000),
      'locale': _bounded(request.locale.replaceAll('_', '-'), 35),
      'currency': _bounded(request.currency.trim().toUpperCase(), 3),
      'parserCandidate': <String, Object?>{
        'storeName': _nullableBounded(request.parserCandidate.storeName, 160),
        'purchaseDate': _formatDate(request.parserCandidate.purchaseDate),
        'subtotal': request.parserCandidate.subtotal,
        'tax': request.parserCandidate.tax,
        'total': request.parserCandidate.total,
        'items': request.parserCandidate.items
            .take(kSmartReceiptMaximumItems)
            .map(
              (SmartReceiptItemData item) => <String, Object?>{
                'name': _nullableBounded(item.name, 200),
                'quantity': item.quantity,
                'unit': _nullableBounded(item.unit, 32),
                'unitPrice': item.unitPrice,
                'totalPrice': item.totalPrice,
                'category': _nullableBounded(item.category, 80),
              },
            )
            .toList(growable: false),
      },
    };
  }

  static SmartReceiptData fromResponse(Object? rawResponse) {
    final Map<String, Object?> response = _object(rawResponse);
    _expectKeys(response, const <String>{'receipt', 'processing'});

    final Map<String, Object?> processing = _object(response['processing']);
    _expectKeys(
      processing,
      const <String>{'schemaVersion', 'model', 'appCheckVerified'},
    );
    if (processing['schemaVersion'] != '1' ||
        processing['model'] != 'gpt-5.6-sol' ||
        processing['appCheckVerified'] is! bool) {
      throw const SmartReceiptException(SmartReceiptFailureKind.malformed);
    }

    final Map<String, Object?> receipt = _object(response['receipt']);
    _expectKeys(receipt, const <String>{
      'storeName',
      'purchaseDate',
      'currency',
      'subtotal',
      'tax',
      'total',
      'items',
      'warningCodes',
    });
    final Object? rawItems = receipt['items'];
    final Object? rawWarnings = receipt['warningCodes'];
    if (rawItems is! List ||
        rawItems.length > kSmartReceiptMaximumItems ||
        rawWarnings is! List) {
      throw const SmartReceiptException(SmartReceiptFailureKind.malformed);
    }

    final List<SmartReceiptItemData> items = rawItems.map((Object? rawItem) {
      final Map<String, Object?> item = _object(rawItem);
      _expectKeys(item, const <String>{
        'name',
        'quantity',
        'unit',
        'unitPrice',
        'totalPrice',
        'category',
      });
      return SmartReceiptItemData(
        name: _nullableString(item['name'], maximum: 200),
        quantity: _nullableNumber(item['quantity']),
        unit: _nullableString(item['unit'], maximum: 32),
        unitPrice: _nullableMoney(item['unitPrice']),
        totalPrice: _nullableMoney(item['totalPrice']),
        category: _nullableString(item['category'], maximum: 80),
      );
    }).toList(growable: false);

    final List<String> warningCodes = rawWarnings.map((Object? value) {
      if (value is! String || !_warningCodes.contains(value)) {
        throw const SmartReceiptException(SmartReceiptFailureKind.malformed);
      }
      return value;
    }).toList(growable: false);

    return SmartReceiptData(
      storeName: _nullableString(receipt['storeName'], maximum: 160),
      purchaseDate: _nullableDate(receipt['purchaseDate']),
      currency: _nullableCurrency(receipt['currency']),
      subtotal: _nullableMoney(receipt['subtotal']),
      tax: _nullableMoney(receipt['tax']),
      total: _nullableMoney(receipt['total']),
      items: items,
      warningCodes: warningCodes,
    );
  }

  static Map<String, Object?> _object(Object? value) {
    if (value is! Map) {
      throw const SmartReceiptException(SmartReceiptFailureKind.malformed);
    }
    final Map<String, Object?> result = <String, Object?>{};
    for (final MapEntry<Object?, Object?> entry in value.entries) {
      if (entry.key is! String) {
        throw const SmartReceiptException(SmartReceiptFailureKind.malformed);
      }
      result[entry.key! as String] = entry.value;
    }
    return result;
  }

  static void _expectKeys(
    Map<String, Object?> value,
    Set<String> expected,
  ) {
    if (value.keys.toSet().difference(expected).isNotEmpty ||
        expected.difference(value.keys.toSet()).isNotEmpty) {
      throw const SmartReceiptException(SmartReceiptFailureKind.malformed);
    }
  }

  static String _bounded(String value, int maximum) {
    final String trimmed = value.trim();
    return trimmed.length <= maximum ? trimmed : trimmed.substring(0, maximum);
  }

  static String? _nullableBounded(String? value, int maximum) {
    if (value == null) return null;
    final String bounded = _bounded(value, maximum);
    return bounded.isEmpty ? null : bounded;
  }

  static String? _nullableString(Object? value, {int? maximum}) {
    if (value == null) return null;
    if (value is! String || value.trim().isEmpty) {
      throw const SmartReceiptException(SmartReceiptFailureKind.malformed);
    }
    final String trimmed = value.trim();
    if (maximum != null && trimmed.length > maximum) {
      throw const SmartReceiptException(SmartReceiptFailureKind.malformed);
    }
    return trimmed;
  }

  static double? _nullableNumber(Object? value) {
    if (value == null) return null;
    if (value is! num || !value.isFinite || value <= 0) {
      throw const SmartReceiptException(SmartReceiptFailureKind.malformed);
    }
    return value.toDouble();
  }

  static double? _nullableMoney(Object? value) {
    if (value == null) return null;
    if (value is! num || !value.isFinite || value < 0 || value > 1000000) {
      throw const SmartReceiptException(SmartReceiptFailureKind.malformed);
    }
    return value.toDouble();
  }

  static DateTime? _nullableDate(Object? value) {
    final String? text = _nullableString(value, maximum: 10);
    if (text == null) return null;
    if (!RegExp(r'^\d{4}-\d{2}-\d{2}$').hasMatch(text)) {
      throw const SmartReceiptException(SmartReceiptFailureKind.malformed);
    }
    final DateTime? date = DateTime.tryParse(text);
    if (date == null || _formatDate(date) != text) {
      throw const SmartReceiptException(SmartReceiptFailureKind.malformed);
    }
    return date;
  }

  static String? _nullableCurrency(Object? value) {
    final String? currency = _nullableString(value, maximum: 3);
    if (currency == null) return null;
    if (!RegExp(r'^[A-Z]{3}$').hasMatch(currency)) {
      throw const SmartReceiptException(SmartReceiptFailureKind.malformed);
    }
    return currency;
  }

  static String? _formatDate(DateTime? date) {
    if (date == null) return null;
    final String month = date.month.toString().padLeft(2, '0');
    final String day = date.day.toString().padLeft(2, '0');
    return '${date.year}-$month-$day';
  }
}
