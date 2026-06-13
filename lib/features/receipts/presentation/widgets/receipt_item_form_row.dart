import 'package:flutter/material.dart';

import 'package:savingor_app/core/theme/savingor_design_system.dart';
import 'package:savingor_app/l10n/app_localizations.dart';

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
    final AppLocalizations l10n = AppLocalizations.of(context);

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
              Expanded(
                child: Text(
                  l10n.item,
                  style: const TextStyle(
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
                tooltip: l10n.removeItem,
              ),
            ],
          ),
          TextFormField(
            controller: nameController,
            enabled: enabled,
            textInputAction: TextInputAction.next,
            decoration: InputDecoration(
              labelText: l10n.itemName,
              border: const OutlineInputBorder(),
              isDense: true,
            ),
            validator: (String? value) {
              if (value == null || value.trim().isEmpty) {
                return l10n.enterItemName;
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
                  decoration: InputDecoration(
                    labelText: l10n.qty,
                    border: const OutlineInputBorder(),
                    isDense: true,
                  ),
                  validator: (String? value) {
                    if (value == null || value.trim().isEmpty) {
                      return l10n.qty;
                    }
                    final double? qty = double.tryParse(value.trim());
                    if (qty == null || qty <= 0) {
                      return l10n.invalidValue;
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
                  decoration: InputDecoration(
                    labelText: l10n.price,
                    prefixText: '\$ ',
                    border: const OutlineInputBorder(),
                    isDense: true,
                  ),
                  validator: (String? value) {
                    if (value == null || value.trim().isEmpty) {
                      return l10n.price;
                    }
                    final double? price = double.tryParse(value.trim());
                    if (price == null || price < 0) {
                      return l10n.invalidValue;
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
            decoration: InputDecoration(
              labelText: l10n.categoryOptional,
              border: const OutlineInputBorder(),
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
