/// Line item on a grocery receipt.
class ReceiptItem {
  const ReceiptItem({
    required this.id,
    required this.name,
    this.normalizedName,
    this.category,
    this.quantity = 1,
    this.unit,
    this.unitPrice,
    required this.totalPrice,
    this.isEssential,
    this.confidence,
    this.notes,
  });

  final String id;
  final String name;
  final String? normalizedName;
  final String? category;
  final double quantity;
  final String? unit;
  final double? unitPrice;
  final double totalPrice;
  final bool? isEssential;
  final double? confidence;
  final String? notes;

  factory ReceiptItem.create({
    required String name,
    double quantity = 1,
    String? unit,
    double? unitPrice,
    double? totalPrice,
    String? category,
    String? normalizedName,
    bool? isEssential,
    double? confidence,
    String? notes,
  }) {
    final double resolvedTotal = totalPrice ??
        ((unitPrice != null) ? unitPrice * quantity : 0);
    return ReceiptItem(
      id: _newItemId(),
      name: name.trim(),
      normalizedName: normalizedName,
      category: category,
      quantity: quantity,
      unit: unit,
      unitPrice: unitPrice,
      totalPrice: resolvedTotal,
      isEssential: isEssential,
      confidence: confidence,
      notes: notes,
    );
  }

  factory ReceiptItem.fromMap(Map<String, dynamic> map) {
    return ReceiptItem(
      id: (map['id'] as String?) ?? _newItemId(),
      name: (map['name'] as String?)?.trim() ?? '',
      normalizedName: _nullableString(map['normalizedName']),
      category: _nullableString(map['category']),
      quantity: _parseDouble(map['quantity'], fallback: 1),
      unit: _nullableString(map['unit']),
      unitPrice: _nullableDouble(map['unitPrice']),
      totalPrice: _parseDouble(map['totalPrice']),
      isEssential: map['isEssential'] as bool?,
      confidence: _nullableDouble(map['confidence']),
      notes: _nullableString(map['notes']),
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'name': name,
      if (normalizedName != null) 'normalizedName': normalizedName,
      if (category != null) 'category': category,
      'quantity': quantity,
      if (unit != null) 'unit': unit,
      if (unitPrice != null) 'unitPrice': unitPrice,
      'totalPrice': totalPrice,
      if (isEssential != null) 'isEssential': isEssential,
      if (confidence != null) 'confidence': confidence,
      if (notes != null) 'notes': notes,
    };
  }

  ReceiptItem copyWith({
    String? id,
    String? name,
    String? normalizedName,
    String? category,
    double? quantity,
    String? unit,
    double? unitPrice,
    double? totalPrice,
    bool? isEssential,
    double? confidence,
    String? notes,
    bool clearNormalizedName = false,
    bool clearCategory = false,
    bool clearUnit = false,
    bool clearUnitPrice = false,
    bool clearNotes = false,
  }) {
    return ReceiptItem(
      id: id ?? this.id,
      name: name ?? this.name,
      normalizedName:
          clearNormalizedName ? null : (normalizedName ?? this.normalizedName),
      category: clearCategory ? null : (category ?? this.category),
      quantity: quantity ?? this.quantity,
      unit: clearUnit ? null : (unit ?? this.unit),
      unitPrice: clearUnitPrice ? null : (unitPrice ?? this.unitPrice),
      totalPrice: totalPrice ?? this.totalPrice,
      isEssential: isEssential ?? this.isEssential,
      confidence: confidence ?? this.confidence,
      notes: clearNotes ? null : (notes ?? this.notes),
    );
  }

  String get displayQuantity {
    if (quantity == quantity.roundToDouble()) {
      return quantity.toInt().toString();
    }
    return quantity.toStringAsFixed(2);
  }

  String get formattedTotalPrice => '\$${totalPrice.toStringAsFixed(2)}';

  static String? _nullableString(Object? value) {
    if (value == null) return null;
    if (value is! String) return value.toString();
    final String trimmed = value.trim();
    return trimmed.isEmpty ? null : trimmed;
  }

  static double? _nullableDouble(Object? value) {
    if (value == null) return null;
    if (value is double) return value;
    if (value is int) return value.toDouble();
    if (value is num) return value.toDouble();
    if (value is String) {
      return double.tryParse(value.trim());
    }
    return null;
  }

  static double _parseDouble(Object? value, {double fallback = 0}) {
    return _nullableDouble(value) ?? fallback;
  }

  static String _newItemId() {
    return 'item_${DateTime.now().microsecondsSinceEpoch}';
  }
}
