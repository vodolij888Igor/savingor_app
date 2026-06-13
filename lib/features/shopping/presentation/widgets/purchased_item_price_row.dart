import 'package:flutter/material.dart';

import 'package:savingor_app/core/i18n/product_display_l10n.dart';
import 'package:savingor_app/core/theme/savingor_design_system.dart';
import 'package:savingor_app/features/shopping/domain/models/shopping_list_item.dart';
import 'package:savingor_app/l10n/app_localizations.dart';

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

  String _itemDisplayName(BuildContext context) {
    final String localized = ProductDisplayL10n.localizedProductName(
      context,
      item.name,
    );
    if (localized != item.name) {
      return localized;
    }
    return item.name;
  }

  @override
  Widget build(BuildContext context) {
    final AppLocalizations l10n = AppLocalizations.of(context);
    final String itemName = _itemDisplayName(context);
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
                  itemName,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w800,
                    color: SavingorColors.darkGreen,
                  ),
                ),
              ),
              Text(
                l10n.qtyWithCount(item.quantity),
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
            decoration: InputDecoration(
              labelText: l10n.unitPrice,
              prefixText: '\$ ',
              border: const OutlineInputBorder(),
              isDense: true,
            ),
            validator: (String? value) {
              if (value == null || value.trim().isEmpty) {
                return l10n.enterPriceForProduct(itemName);
              }
              final double? price = double.tryParse(value.trim());
              if (price == null || price <= 0) {
                return l10n.enterValidPriceForProduct(itemName);
              }
              return null;
            },
          ),
          const SizedBox(height: 8),
          Text(
            lineTotal > 0
                ? l10n.lineTotalWithAmount('\$${lineTotal.toStringAsFixed(2)}')
                : l10n.lineTotalEmpty,
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
