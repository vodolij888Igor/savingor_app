import 'package:flutter/material.dart';

import 'package:savingor_app/core/theme/savingor_design_system.dart';
import 'package:savingor_app/features/price_memory/domain/models/product_price_record.dart';
import 'package:savingor_app/features/price_memory/domain/price_memory_formatters.dart';
import 'package:savingor_app/features/price_memory/domain/product_buying_advice.dart';
import 'package:savingor_app/features/shopping/data/shopping_lists_store.dart';
import 'package:savingor_app/features/shopping/domain/shopping_list_add_item_result.dart';
import 'package:savingor_app/l10n/app_localizations.dart';

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

  Future<void> _addToShoppingList(
    ProductBuyingAdvice advice,
    AppLocalizations l10n,
  ) async {
    if (_isAdding) {
      return;
    }

    final ShoppingListsStore store = ShoppingListsProvider.of(context);
    if (!store.isAuthenticated) {
      _showSnackBar(l10n.signInToAddShoppingItems);
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
        _showSnackBar(l10n.addedToShoppingList);
      case ShoppingListAddItemResult.alreadyExists:
        _showSnackBar(l10n.alreadyInShoppingList);
      case ShoppingListAddItemResult.quantityUpdated:
        _showSnackBar(l10n.quantityUpdatedSnack);
      case ShoppingListAddItemResult.notAuthenticated:
        _showSnackBar(
          store.mutationError ?? l10n.signInToAddShoppingItems,
        );
      case ShoppingListAddItemResult.failed:
        _showSnackBar(
          store.mutationError ?? l10n.couldNotAddItem,
        );
    }
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  String _recommendationText(
    ProductBuyingAdvice advice,
    AppLocalizations l10n,
  ) {
    final String? store = advice.bestStore;
    if (store == null || store.isEmpty) {
      return l10n.buyItemAtBestPriceWhenFitsRoute;
    }
    return l10n.buyItemAtStoreWhenFitsRoute(store);
  }

  String _neutralMessage(ProductBuyingAdvice advice, AppLocalizations l10n) {
    switch (advice.kind) {
      case ProductBuyingAdviceKind.insufficientHistory:
        return l10n.buyingAdviceInsufficientHistory;
      case ProductBuyingAdviceKind.paidBestPrice:
        return l10n.buyingAdvicePaidBestPrice;
      case ProductBuyingAdviceKind.noBetterPriceYet:
        return l10n.buyingAdviceNoBetterPriceYet;
      case ProductBuyingAdviceKind.savingAvailable:
        return '';
    }
  }

  String _priceAtStore(
    AppLocalizations l10n,
    double price,
    String? store,
    String currency,
  ) {
    final String formatted = PriceMemoryFormatters.formatPrice(
      price,
      currency: currency,
    );
    if (store == null || store.isEmpty) {
      return formatted;
    }
    return l10n.priceAtStore(formatted, store);
  }

  @override
  Widget build(BuildContext context) {
    final AppLocalizations l10n = AppLocalizations.of(context);
    final ProductBuyingAdvice advice = ProductBuyingAdviceBuilder.build(
      widget.records,
      currency: widget.currency,
    );

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: context.savingor.isDark
          ? SavingorWorkflowTheme.highlightCard(context)
          : BoxDecoration(
              color: SavingorColors.lightGreen.withOpacity(0.35),
              borderRadius: BorderRadius.circular(18),
              border: Border.all(
                color: SavingorColors.primaryStroke.withOpacity(0.25),
              ),
            ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            l10n.buyingAdvice,
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w700,
              color: SavingorWorkflowTheme.accentText(context),
              letterSpacing: 0.2,
            ),
          ),
          const SizedBox(height: 12),
          ..._buildBody(advice, l10n),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed:
                  _isAdding ? null : () => _addToShoppingList(advice, l10n),
              style: OutlinedButton.styleFrom(
                foregroundColor: SavingorWorkflowTheme.primaryText(context),
                side: BorderSide(
                  color: context.savingor.isDark
                      ? context.savingor.border.withOpacity(0.9)
                      : SavingorColors.primaryStroke.withOpacity(0.45),
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
              label: Text(
                l10n.addToShoppingList,
                style: const TextStyle(
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

  List<Widget> _buildBody(ProductBuyingAdvice advice, AppLocalizations l10n) {
    switch (advice.kind) {
      case ProductBuyingAdviceKind.insufficientHistory:
      case ProductBuyingAdviceKind.paidBestPrice:
      case ProductBuyingAdviceKind.noBetterPriceYet:
        return <Widget>[
          Text(
            _neutralMessage(advice, l10n),
            style: TextStyle(
              fontSize:
                  advice.kind == ProductBuyingAdviceKind.insufficientHistory
                      ? 14
                      : 15,
              fontWeight:
                  advice.kind == ProductBuyingAdviceKind.insufficientHistory
                      ? FontWeight.w600
                      : FontWeight.w700,
              color: advice.kind == ProductBuyingAdviceKind.insufficientHistory
                  ? context.savingor.textSecondary
                  : SavingorWorkflowTheme.primaryText(context),
              height: advice.kind == ProductBuyingAdviceKind.insufficientHistory
                  ? 1.4
                  : 1.35,
            ),
          ),
        ];
      case ProductBuyingAdviceKind.savingAvailable:
        return <Widget>[
          _detailLine(
            l10n.bestKnownPriceAdviceLabel,
            _priceAtStore(
              l10n,
              advice.bestKnownUnitPrice!,
              advice.bestStore,
              advice.currency,
            ),
          ),
          const SizedBox(height: 8),
          _detailLine(
            l10n.latestPaidAdviceLabel,
            _priceAtStore(
              l10n,
              advice.latestPaidUnitPrice!,
              advice.latestStore,
              advice.currency,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            l10n.potentialSavingPerItem(
              PriceMemoryFormatters.formatPrice(
                advice.potentialSavingPerItem!,
                currency: advice.currency,
              ),
            ),
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w800,
              color: SavingorWorkflowTheme.accentText(context),
              height: 1.3,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            _recommendationText(advice, l10n),
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: SavingorWorkflowTheme.primaryText(context),
              height: 1.4,
            ),
          ),
        ];
    }
  }

  Widget _detailLine(String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        SizedBox(
          width: 118,
          child: Text(
            label,
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: context.savingor.textSecondary,
            ),
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w700,
              color: SavingorWorkflowTheme.primaryText(context),
              height: 1.35,
            ),
          ),
        ),
      ],
    );
  }
}
