import 'package:flutter/material.dart';

import 'package:savingor_app/core/theme/savingor_design_system.dart';
import 'package:savingor_app/features/price_memory/domain/models/product_price_record.dart';
import 'package:savingor_app/features/price_memory/domain/price_memory_formatters.dart';
import 'package:savingor_app/features/price_memory/domain/product_buying_advice.dart';
import 'package:savingor_app/features/shopping/data/shopping_lists_store.dart';
import 'package:savingor_app/features/shopping/domain/shopping_list_add_item_result.dart';

class ProductBuyingAdviceCard extends StatefulWidget {
  const ProductBuyingAdviceCard({
    super.key,
    required this.productName,
    required this.records,
    this.currency = 'CAD',
  });

  final String productName;
  final List<ProductPriceRecord> records;
  final String currency;

  @override
  State<ProductBuyingAdviceCard> createState() =>
      _ProductBuyingAdviceCardState();
}

class _ProductBuyingAdviceCardState extends State<ProductBuyingAdviceCard> {
  bool _isAdding = false;

  Future<void> _addToShoppingList(ProductBuyingAdvice advice) async {
    if (_isAdding) {
      return;
    }

    final ShoppingListsStore store = ShoppingListsProvider.of(context);
    if (!store.isAuthenticated) {
      _showSnackBar('Sign in to add items to your shopping list.');
      return;
    }

    setState(() => _isAdding = true);

    final ShoppingListAddItemResult result = await store.addToLatestActiveList(
      name: widget.productName,
      store: advice.preferredStoreForShoppingList,
      unitPrice: advice.estimatedPriceForShoppingList,
    );

    if (!mounted) {
      return;
    }

    setState(() => _isAdding = false);

    switch (result) {
      case ShoppingListAddItemResult.added:
        _showSnackBar('Added to shopping list');
      case ShoppingListAddItemResult.alreadyExists:
        _showSnackBar('Already in shopping list');
      case ShoppingListAddItemResult.quantityUpdated:
        _showSnackBar('Quantity updated');
      case ShoppingListAddItemResult.notAuthenticated:
        _showSnackBar(
          store.mutationError ?? 'Sign in to add items to your shopping list.',
        );
      case ShoppingListAddItemResult.failed:
        _showSnackBar(
          store.mutationError ?? 'Could not add the item. Please try again.',
        );
    }
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final ProductBuyingAdvice advice = ProductBuyingAdviceBuilder.build(
      widget.records,
      currency: widget.currency,
    );

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: SavingorColors.lightGreen.withOpacity(0.35),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: SavingorColors.primaryStroke.withOpacity(0.25),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          const Text(
            'Buying advice',
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w700,
              color: SavingorColors.primaryStroke,
              letterSpacing: 0.2,
            ),
          ),
          const SizedBox(height: 12),
          ..._buildBody(advice),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed: _isAdding ? null : () => _addToShoppingList(advice),
              style: OutlinedButton.styleFrom(
                foregroundColor: SavingorColors.darkGreen,
                side: BorderSide(
                  color: SavingorColors.primaryStroke.withOpacity(0.45),
                ),
                padding: const EdgeInsets.symmetric(vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              icon: _isAdding
                  ? const SizedBox(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Icon(Icons.playlist_add_rounded, size: 20),
              label: const Text(
                'Add to shopping list',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> _buildBody(ProductBuyingAdvice advice) {
    switch (advice.kind) {
      case ProductBuyingAdviceKind.insufficientHistory:
        return <Widget>[
          Text(
            advice.neutralMessage,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: SavingorColors.textSecondary,
              height: 1.4,
            ),
          ),
        ];
      case ProductBuyingAdviceKind.paidBestPrice:
      case ProductBuyingAdviceKind.noBetterPriceYet:
        return <Widget>[
          Text(
            advice.neutralMessage,
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w700,
              color: SavingorColors.darkGreen,
              height: 1.35,
            ),
          ),
        ];
      case ProductBuyingAdviceKind.savingAvailable:
        return <Widget>[
          _detailLine(
            'Best known price',
            _priceAtStore(
              advice.bestKnownUnitPrice!,
              advice.bestStore,
              advice.currency,
            ),
          ),
          const SizedBox(height: 8),
          _detailLine(
            'Latest paid',
            _priceAtStore(
              advice.latestPaidUnitPrice!,
              advice.latestStore,
              advice.currency,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            'Potential saving: ${PriceMemoryFormatters.formatPrice(advice.potentialSavingPerItem!, currency: advice.currency)} per item',
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w800,
              color: SavingorColors.primaryStroke,
              height: 1.3,
            ),
          ),
          if (advice.recommendationText != null) ...<Widget>[
            const SizedBox(height: 10),
            Text(
              advice.recommendationText!,
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: SavingorColors.darkGreen,
                height: 1.4,
              ),
            ),
          ],
        ];
    }
  }

  String _priceAtStore(double price, String? store, String currency) {
    final String formatted = PriceMemoryFormatters.formatPrice(
      price,
      currency: currency,
    );
    if (store == null || store.isEmpty) {
      return formatted;
    }
    return '$formatted at $store';
  }

  Widget _detailLine(String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        SizedBox(
          width: 118,
          child: Text(
            label,
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: SavingorColors.textSecondary,
            ),
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w700,
              color: SavingorColors.darkGreen,
              height: 1.35,
            ),
          ),
        ),
      ],
    );
  }
}
