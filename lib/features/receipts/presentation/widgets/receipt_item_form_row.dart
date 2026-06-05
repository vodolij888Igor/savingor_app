import 'package:flutter/material.dart';

import 'package:savingor_app/core/theme/savingor_design_system.dart';

/// Editable receipt line item row for manual receipt entry.
class ReceiptItemFormRow extends StatelessWidget {
  const ReceiptItemFormRow({
    super.key,
    required this.nameController,
    required this.quantityController,
    required this.priceController,
    required this.categoryController,
    required this.onRemove,
    this.enabled = true,
  });

  final TextEditingController nameController;
  final TextEditingController quantityController;
  final TextEditingController priceController;
  final TextEditingController categoryController;
  final VoidCallback onRemove;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: SavingorColors.lightGreen.withOpacity(0.12),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: SavingorColors.primaryStroke.withOpacity(0.12),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Row(
            children: <Widget>[
              const Expanded(
                child: Text(
                  'Item',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: SavingorColors.darkGreen,
                  ),
                ),
              ),
              IconButton(
                onPressed: enabled ? onRemove : null,
                icon: const Icon(
                  Icons.close_rounded,
                  size: 20,
                  color: SavingorColors.textSecondary,
                ),
                tooltip: 'Remove item',
              ),
            ],
          ),
          TextFormField(
            controller: nameController,
            enabled: enabled,
            textInputAction: TextInputAction.next,
            decoration: const InputDecoration(
              labelText: 'Item name',
              border: OutlineInputBorder(),
              isDense: true,
            ),
            validator: (String? value) {
              if (value == null || value.trim().isEmpty) {
                return 'Enter an item name';
              }
              return null;
            },
          ),
          const SizedBox(height: 10),
          Row(
            children: <Widget>[
              Expanded(
                child: TextFormField(
                  controller: quantityController,
                  enabled: enabled,
                  keyboardType:
                      const TextInputType.numberWithOptions(decimal: true),
                  textInputAction: TextInputAction.next,
                  decoration: const InputDecoration(
                    labelText: 'Qty',
                    border: OutlineInputBorder(),
                    isDense: true,
                  ),
                  validator: (String? value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Qty';
                    }
                    final double? qty = double.tryParse(value.trim());
                    if (qty == null || qty <= 0) {
                      return 'Invalid';
                    }
                    return null;
                  },
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                flex: 2,
                child: TextFormField(
                  controller: priceController,
                  enabled: enabled,
                  keyboardType:
                      const TextInputType.numberWithOptions(decimal: true),
                  textInputAction: TextInputAction.next,
                  decoration: const InputDecoration(
                    labelText: 'Price',
                    prefixText: '\$ ',
                    border: OutlineInputBorder(),
                    isDense: true,
                  ),
                  validator: (String? value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Price';
                    }
                    final double? price = double.tryParse(value.trim());
                    if (price == null || price < 0) {
                      return 'Invalid';
                    }
                    return null;
                  },
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          TextFormField(
            controller: categoryController,
            enabled: enabled,
            textInputAction: TextInputAction.done,
            decoration: const InputDecoration(
              labelText: 'Category (optional)',
              border: OutlineInputBorder(),
              isDense: true,
            ),
          ),
        ],
      ),
    );
  }
}

/// Holds controllers for one editable receipt item row.
class EditableReceiptItemFields {
  EditableReceiptItemFields({
    required this.id,
    required this.nameController,
    required this.quantityController,
    required this.priceController,
    required this.categoryController,
  });

  factory EditableReceiptItemFields.empty() {
    return EditableReceiptItemFields(
      id: 'item_${DateTime.now().microsecondsSinceEpoch}',
      nameController: TextEditingController(),
      quantityController: TextEditingController(text: '1'),
      priceController: TextEditingController(),
      categoryController: TextEditingController(),
    );
  }

  factory EditableReceiptItemFields.fromReceiptItem({
    required String id,
    required String name,
    required double quantity,
    required double totalPrice,
    String? category,
  }) {
    return EditableReceiptItemFields(
      id: id,
      nameController: TextEditingController(text: name),
      quantityController: TextEditingController(
        text: quantity == quantity.roundToDouble()
            ? quantity.toInt().toString()
            : quantity.toString(),
      ),
      priceController: TextEditingController(text: totalPrice.toStringAsFixed(2)),
      categoryController: TextEditingController(text: category ?? ''),
    );
  }

  final String id;
  final TextEditingController nameController;
  final TextEditingController quantityController;
  final TextEditingController priceController;
  final TextEditingController categoryController;

  void dispose() {
    nameController.dispose();
    quantityController.dispose();
    priceController.dispose();
    categoryController.dispose();
  }
}
