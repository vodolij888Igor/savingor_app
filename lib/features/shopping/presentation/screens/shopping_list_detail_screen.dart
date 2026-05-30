import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:savingor_app/core/theme/savingor_design_system.dart';
import 'package:savingor_app/features/shopping/data/shopping_lists_store.dart';
import 'package:savingor_app/features/shopping/domain/models/shopping_list.dart';
import 'package:savingor_app/features/shopping/domain/models/shopping_list_item.dart';

class ShoppingListDetailScreen extends StatefulWidget {
  const ShoppingListDetailScreen({super.key, required this.listId});

  final String listId;

  @override
  State<ShoppingListDetailScreen> createState() =>
      _ShoppingListDetailScreenState();
}

class _ShoppingListDetailScreenState extends State<ShoppingListDetailScreen> {
  static const Color _pageBackground = Colors.white;
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
          ),
          body: _buildBody(context, store, bottomInset),
          floatingActionButton: FloatingActionButton.extended(
            onPressed: () =>
                context.push('/shopping/list/${widget.listId}/add-item'),
            backgroundColor: SavingorColors.primaryGreen,
            foregroundColor: SavingorColors.darkGreen,
            icon: const Icon(Icons.add_rounded),
            label: const Text(
              'Add item',
              style: TextStyle(fontWeight: FontWeight.w700),
            ),
          ),
        );
      },
    );
  }

  Widget _buildBody(
    BuildContext context,
    ShoppingListsStore store,
    double bottomInset,
  ) {
    if (store.isLoadingItems) {
      return const Center(
        child: CircularProgressIndicator(color: SavingorColors.primaryStroke),
      );
    }

    if (store.itemsError != null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(28),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              const Icon(Icons.error_outline_rounded, size: 56),
              const SizedBox(height: 12),
              Text(store.itemsError!),
              const SizedBox(height: 16),
              FilledButton(
                onPressed: () => store.watchListItems(widget.listId),
                style: SavingorButtonStyles.primaryFilled(),
                child: const Text('Retry'),
              ),
            ],
          ),
        ),
      );
    }

    if (store.items.isEmpty) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(28),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Icon(
                Icons.shopping_cart_outlined,
                size: 56,
                color: SavingorColors.textSecondary,
              ),
              SizedBox(height: 12),
              Text(
                'No items yet',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: SavingorColors.darkGreen,
                ),
              ),
              SizedBox(height: 8),
              Text(
                'Add items to this list to track what you need.',
                textAlign: TextAlign.center,
                style: TextStyle(color: SavingorColors.textSecondary),
              ),
            ],
          ),
        ),
      );
    }

    return Column(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 4, 20, 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(
                '${store.items.length} items',
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
        Expanded(
          child: ListView.separated(
            padding: EdgeInsets.fromLTRB(20, 0, 20, 96 + bottomInset),
            itemCount: store.items.length,
            separatorBuilder: (_, __) => const SizedBox(height: 10),
            itemBuilder: (BuildContext context, int index) {
              final ShoppingListItem item = store.items[index];
              return _ItemTile(
                item: item,
                onToggle: () => store.toggleItemChecked(
                  listId: widget.listId,
                  item: item,
                ),
                onIncrement: () => store.updateItemQuantity(
                  listId: widget.listId,
                  item: item,
                  quantity: item.quantity + 1,
                ),
                onDecrement: () {
                  if (item.quantity <= 1) return;
                  store.updateItemQuantity(
                    listId: widget.listId,
                    item: item,
                    quantity: item.quantity - 1,
                  );
                },
                onDelete: () => store.deleteItem(
                  listId: widget.listId,
                  itemId: item.id,
                ),
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
    required this.onToggle,
    required this.onIncrement,
    required this.onDecrement,
    required this.onDelete,
  });

  final ShoppingListItem item;
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
      child: Material(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
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
                        decoration: item.isChecked
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
              if (item.unitPrice != null)
                Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: Text(
                    '\$${item.unitPrice!.toStringAsFixed(2)}',
                    style: const TextStyle(fontWeight: FontWeight.w600),
                  ),
                ),
              IconButton(
                onPressed: onDecrement,
                icon: const Icon(Icons.remove_circle_outline_rounded),
              ),
              Text('${item.quantity}'),
              IconButton(
                onPressed: onIncrement,
                icon: const Icon(Icons.add_circle_outline_rounded),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
