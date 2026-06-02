import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:savingor_app/core/theme/savingor_design_system.dart';
import 'package:savingor_app/features/shopping/data/shopping_lists_store.dart';
import 'package:savingor_app/features/shopping/domain/models/shopping_list.dart';
import 'package:savingor_app/features/shopping/domain/models/shopping_list_item.dart';
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
        SnackBar(content: Text(error)),
      );
      store.clearMutationError();
    }
  }

  Future<void> _toggleItem(
    ShoppingListsStore store,
    ShoppingListItem item,
  ) async {
    final bool ok = await store.toggleItemChecked(
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
  ) async {
    final bool? confirmed = await showDialog<bool>(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: const Text('Delete list?'),
          content: Text('“${list.title}” will be permanently removed.'),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(false),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(true),
              child: const Text(
                'Delete',
                style: TextStyle(color: Color(0xFFB91C1C)),
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

  @override
  Widget build(BuildContext context) {
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
              list?.title ?? 'Shopping list',
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
                  tooltip: 'Delete list',
                  onPressed: () => _confirmDeleteList(context, store, list),
                ),
            ],
          ),
          body: _buildBody(context, store, list, bottomInset),
          floatingActionButton: _shouldShowAddItemFab(store, list)
              ? FloatingActionButton.extended(
                  onPressed: () => context.push(
                    '/shopping/list/${widget.listId}/add-item',
                  ),
                  backgroundColor: SavingorColors.primaryGreen,
                  foregroundColor: SavingorColors.darkGreen,
                  icon: const Icon(Icons.add_rounded),
                  label: const Text(
                    'Add item',
                    style: TextStyle(fontWeight: FontWeight.w700),
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
    return true;
  }

  Widget _buildBody(
    BuildContext context,
    ShoppingListsStore store,
    ShoppingList? list,
    double bottomInset,
  ) {
    if (store.listsError != null) {
      return ShoppingListStatePanel.error(
        title: 'Could not load lists',
        message: store.listsError!,
        onRetry: store.retryLists,
      );
    }

    if (store.isLoadingLists || store.isLoadingItems) {
      return ShoppingListStatePanel.loading(
        message: store.isLoadingItems
            ? 'Loading list items…'
            : 'Loading shopping list…',
      );
    }

    if (store.itemsError != null) {
      return ShoppingListStatePanel.error(
        title: 'Could not load items',
        message: store.itemsError!,
        onRetry: () => store.watchListItems(widget.listId),
      );
    }

    if (list == null) {
      return ShoppingListStatePanel.empty(
        icon: Icons.checklist_rounded,
        title: 'List not found',
        message: 'This shopping list may have been deleted.',
        actionLabel: 'Back to lists',
        onAction: () => context.pop(),
      );
    }

    if (store.items.isEmpty) {
      return ShoppingListStatePanel.empty(
        icon: Icons.shopping_cart_outlined,
        title: 'No items yet',
        message: 'Add items to this list to track what you need.',
        actionLabel: 'Add item',
        prominentAction: true,
        onAction: () =>
            context.push('/shopping/list/${widget.listId}/add-item'),
      );
    }

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
                  '${store.items.length} items'
                  '${list.checkedCount > 0 ? ' · ${list.checkedCount} checked' : ''}',
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    color: SavingorColors.darkGreen,
                  ),
                ),
                Text(
                  'Est. \$${store.activeListEstimate.toStringAsFixed(2)}',
                  style: const TextStyle(
                    fontWeight: FontWeight.w700,
                    color: SavingorColors.darkGreen,
                  ),
                ),
              ],
            ),
          ),
        ),
        Expanded(
          child: ListView.separated(
            padding: EdgeInsets.fromLTRB(20, 0, 20, 96 + bottomInset),
            itemCount: store.items.length,
            separatorBuilder: (_, __) => const SizedBox(height: 10),
            itemBuilder: (BuildContext context, int index) {
              final ShoppingListItem item = store.items[index];
              return _ItemTile(
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
              );
            },
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
  });

  final ShoppingListItem item;
  final int maxQuantity;
  final VoidCallback onToggle;
  final VoidCallback onIncrement;
  final VoidCallback onDecrement;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
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
      child: Container(
        decoration: shoppingListCardDecoration(radius: 16),
        padding: const EdgeInsets.fromLTRB(8, 8, 12, 8),
        child: Row(
          children: <Widget>[
            Checkbox(
              value: item.isChecked,
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
                      decoration:
                          item.isChecked ? TextDecoration.lineThrough : null,
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
            if (item.unitPrice != null)
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
    );
  }
}
