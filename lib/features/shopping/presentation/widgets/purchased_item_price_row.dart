import 'package:flutter/material.dart';

import 'package:savingor_app/core/theme/savingor_design_system.dart';
import 'package:savingor_app/features/shopping/domain/models/shopping_list_item.dart';

class PurchasedItemPriceRow extends StatelessWidget {
  const PurchasedItemPriceRow({
    super.key,
    required this.item,
    required this.unitPriceController,
    required this.onChanged,
  });

  final ShoppingListItem item;
  final TextEditingController unitPriceController;
  final VoidCallback onChanged;

  @override
  Widget build(BuildContext context) {
    final double? unitPrice = double.tryParse(unitPriceController.text.trim());
    final double lineTotal =
        unitPrice != null && unitPrice > 0 ? unitPrice * item.quantity : 0;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: SavingorColors.lightGreen.withOpacity(0.12),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: SavingorColors.primaryStroke.withOpacity(0.12),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            children: <Widget>[
              Expanded(
                child: Text(
                  item.name,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w800,
                    color: SavingorColors.darkGreen,
                  ),
                ),
              ),
              Text(
                'Qty ${item.quantity}',
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: SavingorColors.textSecondary,
                ),
              ),
            ],
          ),
          if (item.store != null && item.store!.isNotEmpty) ...<Widget>[
            const SizedBox(height: 4),
            Text(
              item.store!,
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: SavingorColors.textSecondary,
              ),
            ),
          ],
          const SizedBox(height: 12),
          TextFormField(
            controller: unitPriceController,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            onChanged: (_) => onChanged(),
            decoration: const InputDecoration(
              labelText: 'Unit price',
              prefixText: '\$ ',
              border: OutlineInputBorder(),
              isDense: true,
            ),
            validator: (String? value) {
              if (value == null || value.trim().isEmpty) {
                return 'Enter a price for ${item.name}';
              }
              final double? price = double.tryParse(value.trim());
              if (price == null || price <= 0) {
                return 'Enter a valid price for ${item.name}';
              }
              return null;
            },
          ),
          const SizedBox(height: 8),
          Text(
            lineTotal > 0
                ? 'Line total: \$${lineTotal.toStringAsFixed(2)}'
                : 'Line total: —',
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w700,
              color: SavingorColors.darkGreen,
            ),
          ),
        ],
      ),
    );
  }
}

class PurchasedItemPriceFields {
  PurchasedItemPriceFields({
    required this.item,
    required this.unitPriceController,
  });

  factory PurchasedItemPriceFields.fromItem(ShoppingListItem item) {
    return PurchasedItemPriceFields(
      item: item,
      unitPriceController: TextEditingController(
        text: item.unitPrice != null && item.unitPrice! > 0
            ? item.unitPrice!.toStringAsFixed(2)
            : '',
      ),
    );
  }

  final ShoppingListItem item;
  final TextEditingController unitPriceController;

  void dispose() {
    unitPriceController.dispose();
  }
}
