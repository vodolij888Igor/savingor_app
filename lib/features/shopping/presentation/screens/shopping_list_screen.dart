// ignore_for_file: prefer_const_constructors
import 'package:flutter/material.dart';
import 'package:savingor_app/features/shopping/data/shopping_list_store.dart';
import 'package:savingor_app/l10n/app_localizations.dart';

class ShoppingListScreen extends StatefulWidget {
  const ShoppingListScreen({super.key});

  @override
  State<ShoppingListScreen> createState() => _ShoppingListScreenState();
}

class _ShoppingListScreenState extends State<ShoppingListScreen> {
  @override
  Widget build(BuildContext context) {
    final AppLocalizations l10n = AppLocalizations.of(context);
    final store = ShoppingListProvider.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.shoppingList),
        actions: [
          IconButton(
            onPressed: () => store.clearChecked(),
            icon: const Icon(Icons.delete_sweep),
            tooltip: l10n.clearPurchased,
          )
        ],
      ),
      body: AnimatedBuilder(
        animation: store,
        builder: (context, _) {
          final items = store.items;
          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(l10n.receiptItemsCount(items.length)),
                    Text(
                      l10n.estimatedPrefix(
                        '\$${store.totalEstimate.toStringAsFixed(2)}',
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: items.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(Icons.shopping_cart,
                                size: 72, color: Colors.grey),
                            const SizedBox(height: 12),
                            Text(l10n.shoppingList,
                                style: const TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.w600)),
                            const SizedBox(height: 8),
                            Text(
                              l10n.shoppingListEmptyMessage,
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      )
                    : ListView.separated(
                        itemCount: items.length,
                        separatorBuilder: (_, __) => const Divider(height: 1),
                        itemBuilder: (context, index) {
                          final item = items[index];
                          return Dismissible(
                            key: ValueKey(item.id),
                            direction: DismissDirection.endToStart,
                            onDismissed: (_) => store.remove(item.id),
                            background: Container(
                                color: Colors.red,
                                alignment: Alignment.centerRight,
                                padding: const EdgeInsets.only(right: 16),
                                child: const Icon(Icons.delete,
                                    color: Colors.white)),
                            child: ListTile(
                              leading: Checkbox(
                                  value: item.isChecked,
                                  onChanged: (_) =>
                                      store.toggleChecked(item.id)),
                              title: Text(item.title),
                              subtitle:
                                  item.store != null ? Text(item.store!) : null,
                              trailing: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  if (item.price != null)
                                    Padding(
                                        padding:
                                            const EdgeInsets.only(right: 8.0),
                                        child: Text(
                                            '\$${item.price!.toStringAsFixed(2)}')),
                                  IconButton(
                                      onPressed: () => store.decrement(item.id),
                                      icon: const Icon(Icons.remove)),
                                  Text('${item.qty}'),
                                  IconButton(
                                      onPressed: () => store.increment(item.id),
                                      icon: const Icon(Icons.add)),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
              ),
            ],
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showAddDialog(context),
        label: Text(l10n.addItem),
        icon: const Icon(Icons.add),
      ),
    );
  }

  void _showAddDialog(BuildContext context) {
    final AppLocalizations l10n = AppLocalizations.of(context);
    final titleCtrl = TextEditingController();
    final storeCtrl = TextEditingController();
    final priceCtrl = TextEditingController();
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (ctx) => Padding(
        padding: EdgeInsets.only(
            bottom: MediaQuery.of(ctx).viewInsets.bottom,
            left: 16,
            right: 16,
            top: 16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
                controller: titleCtrl,
                decoration: InputDecoration(labelText: l10n.itemName)),
            TextField(
                controller: storeCtrl,
                decoration: InputDecoration(labelText: l10n.storeOptional)),
            TextField(
                controller: priceCtrl,
                decoration: InputDecoration(labelText: l10n.priceOptional),
                keyboardType: TextInputType.numberWithOptions(decimal: true)),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                    child: ElevatedButton(
                        onPressed: () {
                          final title = titleCtrl.text.trim();
                          if (title.isEmpty) return;
                          final provider = ShoppingListProvider.of(context);
                          final price = double.tryParse(priceCtrl.text);
                          provider.addCustom(title,
                              store: storeCtrl.text.trim().isEmpty
                                  ? null
                                  : storeCtrl.text.trim(),
                              price: price);
                          Navigator.of(context).pop();
                        },
                        child: Text(l10n.save))),
                const SizedBox(width: 8),
                Expanded(
                    child: OutlinedButton(
                        onPressed: () => Navigator.of(context).pop(),
                        child: Text(l10n.cancel))),
              ],
            ),
            const SizedBox(height: 12),
          ],
        ),
      ),
    );
  }
}
