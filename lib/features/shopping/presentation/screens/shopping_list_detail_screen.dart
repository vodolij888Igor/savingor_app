import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:savingor_app/core/i18n/shopping_l10n.dart';
import 'package:savingor_app/core/theme/savingor_design_system.dart';
import 'package:savingor_app/l10n/app_localizations.dart';
import 'package:savingor_app/features/shopping/data/shopping_lists_store.dart';
import 'package:savingor_app/features/shopping/domain/models/shopping_list.dart';
import 'package:savingor_app/features/shopping/domain/models/shopping_list_item.dart';
import 'package:savingor_app/features/price_memory/presentation/widgets/basket_optimizer_entry_card.dart';
import 'package:savingor_app/features/shopping/presentation/widgets/finalize_shopping_trip_entry_card.dart';
import 'package:savingor_app/features/shopping/presentation/widgets/shopping_list_state_panel.dart';

class ShoppingListDetailScreen extends StatefulWidget {
  const ShoppingListDetailScreen({super.key, required this.listId});

  final String listId;

  @override
  State<ShoppingListDetailScreen> createState() =>
      _ShoppingListDetailScreenState();
}

class _ShoppingListDetailScreenState extends State<ShoppingListDetailScreen> {
  static const Color _pageBackground = Colors.white;
  static const int _maxQuantity = 999;

  ShoppingListsStore? _store;
  bool _watchStarted = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _store ??= ShoppingListsProvider.of(context);
    if (!_watchStarted) {
      _watchStarted = true;
      _store!.watchListItems(widget.listId);
    }
  }

  @override
  void dispose() {
    _store?.clearActiveList();
    super.dispose();
  }

  ShoppingList? _findList(ShoppingListsStore store) {
    for (final ShoppingList list in store.lists) {
      if (list.id == widget.listId) return list;
    }
    return null;
  }

  void _showMutationError(ShoppingListsStore store) {
    final String? error = store.mutationError;
    if (error != null && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(ShoppingL10n.localizeError(context, error))),
      );
      store.clearMutationError();
    }
  }

  Future<void> _toggleItem(
    ShoppingListsStore store,
    ShoppingListItem item,
  ) async {
    final bool ok = await store.toggleItemCompleted(
      listId: widget.listId,
      item: item,
    );
    if (!ok) _showMutationError(store);
  }

  Future<void> _updateQuantity(
    ShoppingListsStore store,
    ShoppingListItem item,
    int quantity,
  ) async {
    final bool ok = await store.updateItemQuantity(
      listId: widget.listId,
      item: item,
      quantity: quantity,
    );
    if (!ok) _showMutationError(store);
  }

  Future<void> _deleteItem(
    ShoppingListsStore store,
    String itemId,
  ) async {
    final bool ok = await store.deleteItem(
      listId: widget.listId,
      itemId: itemId,
    );
    if (!ok) _showMutationError(store);
  }

  Future<void> _confirmDeleteList(
    BuildContext context,
    ShoppingListsStore store,
    ShoppingList list,
    AppLocalizations l10n,
  ) async {
    final bool? confirmed = await showDialog<bool>(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: Text(l10n.deleteListQuestion),
          content: Text(l10n.deleteListConfirmMessage(list.title)),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(false),
              child: Text(l10n.cancel),
            ),
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(true),
              child: Text(
                l10n.delete,
                style: const TextStyle(color: Color(0xFFB91C1C)),
              ),
            ),
          ],
        );
      },
    );

    if (confirmed != true || !context.mounted) return;

    final bool ok = await store.deleteList(list.id);
    if (!context.mounted) return;

    if (ok) {
      context.pop();
      return;
    }
    _showMutationError(store);
  }

  Future<void> _openFinalizeTrip(
    BuildContext context,
    ShoppingList list,
    AppLocalizations l10n,
  ) async {
    if (list.lastFinalizedReceiptId != null) {
      final bool? confirmed = await showDialog<bool>(
        context: context,
        builder: (BuildContext dialogContext) {
          return AlertDialog(
            title: Text(l10n.createAnotherReceiptQuestion),
            content: Text(l10n.createAnotherReceiptMessage),
            actions: <Widget>[
              TextButton(
                onPressed: () => Navigator.of(dialogContext).pop(false),
                child: Text(l10n.cancel),
              ),
              TextButton(
                onPressed: () => Navigator.of(dialogContext).pop(true),
                child: Text(l10n.createReceipt),
              ),
            ],
          );
        },
      );
      if (confirmed != true || !context.mounted) return;
    }

    context.push('/shopping/list/${widget.listId}/finalize-trip');
  }

  @override
  Widget build(BuildContext context) {
    final AppLocalizations l10n = AppLocalizations.of(context);
    final ShoppingListsStore store = ShoppingListsProvider.of(context);
    final ShoppingList? list = _findList(store);
    final double bottomInset = MediaQuery.paddingOf(context).bottom;

    return AnimatedBuilder(
      animation: store,
      builder: (BuildContext context, Widget? child) {
        return Scaffold(
          backgroundColor: _pageBackground,
          appBar: AppBar(
            title: Text(
              list?.title ?? l10n.shoppingList,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w800,
                color: SavingorColors.darkGreen,
              ),
            ),
            elevation: 0,
            scrolledUnderElevation: 0,
            backgroundColor: _pageBackground,
            surfaceTintColor: Colors.transparent,
            leading: IconButton(
              icon: const Icon(
                Icons.arrow_back_ios_new_rounded,
                color: SavingorColors.darkGreen,
                size: 20,
              ),
              onPressed: () => context.pop(),
            ),
            actions: <Widget>[
              if (list != null)
                IconButton(
                  icon: const Icon(Icons.delete_outline_rounded),
                  color: SavingorColors.textSecondary,
                  tooltip: l10n.deleteList,
                  onPressed: () => _confirmDeleteList(context, store, list, l10n),
                ),
            ],
          ),
          body: _buildBody(context, store, list, bottomInset, l10n),
          floatingActionButton: _shouldShowAddItemFab(store, list)
              ? FloatingActionButton.extended(
                  onPressed: () => context.push(
                    '/shopping/list/${widget.listId}/add-item',
                  ),
                  backgroundColor: SavingorColors.primaryGreen,
                  foregroundColor: SavingorColors.darkGreen,
                  icon: const Icon(Icons.add_rounded),
                  label: Text(
                    l10n.addItem,
                    style: const TextStyle(fontWeight: FontWeight.w700),
                  ),
                )
              : null,
        );
      },
    );
  }

  bool _shouldShowAddItemFab(ShoppingListsStore store, ShoppingList? list) {
    if (list == null) return false;
    if (store.isLoadingLists || store.isLoadingItems) return false;
    if (store.itemsError != null || store.listsError != null) return false;
    return store.items.isNotEmpty;
  }

  Widget _buildBody(
    BuildContext context,
    ShoppingListsStore store,
    ShoppingList? list,
    double bottomInset,
    AppLocalizations l10n,
  ) {
    if (store.listsError != null) {
      return ShoppingListStatePanel.error(
        title: l10n.couldNotLoadLists,
        message: ShoppingL10n.localizeListsError(context, store.listsError),
        onRetry: store.retryLists,
      );
    }

    if (store.isLoadingLists || store.isLoadingItems) {
      return ShoppingListStatePanel.loading(
        message: store.isLoadingItems
            ? l10n.loadingListItems
            : l10n.loadingShoppingList,
      );
    }

    if (store.itemsError != null) {
      return ShoppingListStatePanel.error(
        title: l10n.couldNotLoadItems,
        message: ShoppingL10n.localizeItemsError(context, store.itemsError),
        onRetry: () => store.watchListItems(widget.listId),
      );
    }

    if (list == null) {
      return ShoppingListStatePanel.empty(
        icon: Icons.checklist_rounded,
        title: l10n.listNotFound,
        message: l10n.listNotFoundMessage,
        actionLabel: l10n.backToLists,
        onAction: () => context.pop(),
      );
    }

    if (store.items.isEmpty) {
      return ShoppingListStatePanel.empty(
        icon: Icons.shopping_cart_outlined,
        title: l10n.noShoppingItemsYet,
        message: l10n.noShoppingItemsYetMessage,
        actionLabel: l10n.addItem,
        prominentAction: true,
        onAction: () =>
            context.push('/shopping/list/${widget.listId}/add-item'),
      );
    }

    final List<ShoppingListItem> activeItems = store.items
        .where((ShoppingListItem item) => item.isActive)
        .toList(growable: false);
    final List<ShoppingListItem> completedItems = store.items
        .where((ShoppingListItem item) => item.isCompleted)
        .toList(growable: false);

    return Column(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 4, 20, 8),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: shoppingListCardDecoration(radius: 14),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  '${l10n.activeCountLabel(activeItems.length)}'
                  '${completedItems.isNotEmpty ? ' · ${l10n.purchasedSummary(completedItems.length)}' : ''}',
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    color: SavingorColors.darkGreen,
                  ),
                ),
                Text(
                  l10n.estimatedShort(
                    '\$${store.activeListEstimate.toStringAsFixed(2)}',
                  ),
                  style: const TextStyle(
                    fontWeight: FontWeight.w700,
                    color: SavingorColors.darkGreen,
                  ),
                ),
              ],
            ),
          ),
        ),
        if (activeItems.isEmpty && completedItems.isNotEmpty)
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 12),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                l10n.allItemsPurchased,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: SavingorColors.textSecondary,
                ),
              ),
            ),
          ),
        if (activeItems.isNotEmpty)
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 12),
            child: BasketOptimizerEntryCard(
              title: l10n.optimizeThisBasket,
              subtitle: l10n.optimizeThisBasketSubtitle,
              onTap: () => context.push(
                '/shopping/basket-optimizer?listId=${widget.listId}',
              ),
            ),
          ),
        if (completedItems.isNotEmpty)
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 12),
            child: FinalizeShoppingTripEntryCard(
              onTap: () => _openFinalizeTrip(context, list, l10n),
            ),
          ),
        Expanded(
          child: ListView(
            padding: EdgeInsets.fromLTRB(20, 0, 20, 96 + bottomInset),
            children: <Widget>[
              ...activeItems.map(
                (ShoppingListItem item) => Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: _ItemTile(
                    item: item,
                    maxQuantity: _maxQuantity,
                    onToggle: () => _toggleItem(store, item),
                    onIncrement: () {
                      if (item.quantity >= _maxQuantity) return;
                      _updateQuantity(store, item, item.quantity + 1);
                    },
                    onDecrement: () {
                      if (item.quantity <= 1) return;
                      _updateQuantity(store, item, item.quantity - 1);
                    },
                    onDelete: () => _deleteItem(store, item.id),
                  ),
                ),
              ),
              if (completedItems.isNotEmpty) ...<Widget>[
                Padding(
                  padding: const EdgeInsets.only(top: 8, bottom: 12),
                  child: Text(
                    l10n.purchased,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      color: SavingorColors.textSecondary,
                    ),
                  ),
                ),
                ...completedItems.map(
                  (ShoppingListItem item) => Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: _ItemTile(
                      item: item,
                      maxQuantity: _maxQuantity,
                      isCompletedStyle: true,
                      onToggle: () => _toggleItem(store, item),
                      onIncrement: () {
                        if (item.quantity >= _maxQuantity) return;
                        _updateQuantity(store, item, item.quantity + 1);
                      },
                      onDecrement: () {
                        if (item.quantity <= 1) return;
                        _updateQuantity(store, item, item.quantity - 1);
                      },
                      onDelete: () => _deleteItem(store, item.id),
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }
}

class _ItemTile extends StatelessWidget {
  const _ItemTile({
    required this.item,
    required this.maxQuantity,
    required this.onToggle,
    required this.onIncrement,
    required this.onDecrement,
    required this.onDelete,
    this.isCompletedStyle = false,
  });

  final ShoppingListItem item;
  final int maxQuantity;
  final VoidCallback onToggle;
  final VoidCallback onIncrement;
  final VoidCallback onDecrement;
  final VoidCallback onDelete;
  final bool isCompletedStyle;

  @override
  Widget build(BuildContext context) {
    final double contentOpacity = isCompletedStyle ? 0.55 : 1;

    return Dismissible(
      key: ValueKey<String>(item.id),
      direction: DismissDirection.endToStart,
      onDismissed: (_) => onDelete(),
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 16),
        decoration: BoxDecoration(
          color: const Color(0xFFB91C1C),
          borderRadius: BorderRadius.circular(16),
        ),
        child: const Icon(Icons.delete_outline_rounded, color: Colors.white),
      ),
      child: Opacity(
        opacity: contentOpacity,
        child: Container(
        decoration: shoppingListCardDecoration(radius: 16),
        padding: const EdgeInsets.fromLTRB(8, 8, 12, 8),
        child: Row(
          children: <Widget>[
            Checkbox(
              value: item.isCompleted,
              activeColor: SavingorColors.primaryStroke,
              onChanged: (_) => onToggle(),
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    item.name,
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      color: SavingorColors.darkGreen,
                      decoration: isCompletedStyle
                          ? TextDecoration.lineThrough
                          : null,
                    ),
                  ),
                  if (item.store != null && item.store!.isNotEmpty)
                    Text(
                      item.store!,
                      style: const TextStyle(
                        fontSize: 12,
                        color: SavingorColors.textSecondary,
                      ),
                    ),
                ],
              ),
            ),
            if (item.unitPrice != null && !isCompletedStyle)
              Padding(
                padding: const EdgeInsets.only(right: 8),
                child: Text(
                  '\$${item.unitPrice!.toStringAsFixed(2)}',
                  style: const TextStyle(fontWeight: FontWeight.w600),
                ),
              ),
            IconButton(
              onPressed: item.quantity <= 1 ? null : onDecrement,
              icon: const Icon(Icons.remove_circle_outline_rounded),
            ),
            Text(
              '${item.quantity}',
              style: const TextStyle(
                fontWeight: FontWeight.w700,
                color: SavingorColors.darkGreen,
              ),
            ),
            IconButton(
              onPressed: item.quantity >= maxQuantity ? null : onIncrement,
              icon: const Icon(Icons.add_circle_outline_rounded),
            ),
          ],
        ),
      ),
      ),
    );
  }
}
