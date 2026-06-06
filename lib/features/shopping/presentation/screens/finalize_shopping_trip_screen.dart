import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:savingor_app/core/theme/savingor_design_system.dart';
import 'package:savingor_app/core/widgets/app_screen_states.dart';
import 'package:savingor_app/features/receipts/domain/models/receipt_item.dart';
import 'package:savingor_app/features/receipts/domain/models/receipt_source.dart';
import 'package:savingor_app/features/scanner/data/receipt_store.dart';
import 'package:savingor_app/features/shopping/data/shopping_lists_store.dart';
import 'package:savingor_app/features/shopping/domain/models/shopping_list.dart';
import 'package:savingor_app/features/shopping/domain/models/shopping_list_item.dart';
import 'package:savingor_app/features/shopping/domain/shopping_trip_receipt_builder.dart';
import 'package:savingor_app/features/shopping/presentation/widgets/purchased_item_price_row.dart';
import 'package:savingor_app/features/shopping/presentation/widgets/shopping_list_state_panel.dart';

class FinalizeShoppingTripScreen extends StatefulWidget {
  const FinalizeShoppingTripScreen({super.key, required this.listId});

  final String listId;

  static const Color _pageBackground = Colors.white;

  @override
  State<FinalizeShoppingTripScreen> createState() =>
      _FinalizeShoppingTripScreenState();
}

class _FinalizeShoppingTripScreenState extends State<FinalizeShoppingTripScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _storeController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _totalController = TextEditingController();

  ShoppingListsStore? _listsStore;
  bool _watchStarted = false;
  DateTime _purchaseDate = DateTime.now();
  bool _isSaving = false;
  bool _totalManuallyEdited = false;
  bool _fieldsInitialized = false;
  bool _initScheduled = false;

  final List<PurchasedItemPriceFields> _itemFields = <PurchasedItemPriceFields>[];

  @override
  void initState() {
    super.initState();
    _dateController.text = _formatDate(_purchaseDate);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _listsStore ??= ShoppingListsProvider.of(context);
    if (!_watchStarted) {
      _watchStarted = true;
      _listsStore!.watchListItems(widget.listId);
    }
  }

  @override
  void dispose() {
    _storeController.dispose();
    _addressController.dispose();
    _dateController.dispose();
    _totalController.dispose();
    for (final PurchasedItemPriceFields fields in _itemFields) {
      fields.dispose();
    }
    super.dispose();
  }

  ShoppingList? _findList(ShoppingListsStore store) {
    for (final ShoppingList list in store.lists) {
      if (list.id == widget.listId) return list;
    }
    return null;
  }

  void _scheduleFieldInitialization(ShoppingListsStore store) {
    if (_fieldsInitialized || _initScheduled) {
      return;
    }
    if (store.isLoadingLists || store.isLoadingItems) {
      return;
    }

    final ShoppingTripReceiptDraft draft = ShoppingTripReceiptBuilder.buildDraft(
      listItems: store.items,
    );
    if (draft.isEmpty) {
      return;
    }

    _initScheduled = true;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted || _fieldsInitialized) {
        return;
      }
      _applyFieldInitialization(draft);
      setState(() {
        _fieldsInitialized = true;
      });
    });
  }

  void _applyFieldInitialization(ShoppingTripReceiptDraft draft) {
    if (draft.suggestedStoreName != null) {
      _storeController.text = draft.suggestedStoreName!;
    }

    for (final PurchasedItemPriceFields fields in _itemFields) {
      fields.dispose();
    }
    _itemFields.clear();

    for (final ShoppingListItem item in draft.purchasedItems) {
      final PurchasedItemPriceFields fields =
          PurchasedItemPriceFields.fromItem(item);
      fields.unitPriceController.addListener(_onItemPriceChanged);
      _itemFields.add(fields);
    }

    _syncTotalFromItems(rebuild: false);
  }

  void _onItemPriceChanged() {
    _syncTotalFromItems();
  }

  String _formatDate(DateTime date) {
    const List<String> months = <String>[
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
    ];
    return '${months[date.month - 1]} ${date.day}, ${date.year}';
  }

  Future<void> _pickDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _purchaseDate,
      firstDate: DateTime(2020),
      lastDate: DateTime.now().add(const Duration(days: 1)),
    );
    if (picked == null) return;
    setState(() {
      _purchaseDate = picked;
      _dateController.text = _formatDate(picked);
    });
  }

  void _syncTotalFromItems({bool rebuild = true}) {
    if (_totalManuallyEdited) return;

    double sum = 0;
    for (final PurchasedItemPriceFields fields in _itemFields) {
      final double? unitPrice =
          double.tryParse(fields.unitPriceController.text.trim());
      if (unitPrice != null && unitPrice > 0) {
        sum += unitPrice * fields.item.quantity;
      }
    }
    _totalController.text = sum > 0 ? sum.toStringAsFixed(2) : '';
    if (rebuild && mounted) {
      setState(() {});
    }
  }

  double _computedSubtotal(List<ShoppingListItem> purchasedItems) {
    return ShoppingTripReceiptBuilder.computeSubtotal(
      ShoppingTripReceiptBuilder.buildReceiptItems(
        purchasedItems: purchasedItems,
        unitPricesByItemId: _unitPricesByItemId(),
      ),
    );
  }

  Map<String, double> _unitPricesByItemId() {
    final Map<String, double> prices = <String, double>{};
    for (final PurchasedItemPriceFields fields in _itemFields) {
      final double? unitPrice =
          double.tryParse(fields.unitPriceController.text.trim());
      if (unitPrice != null && unitPrice > 0) {
        prices[fields.item.id] = unitPrice;
      }
    }
    return prices;
  }

  Future<bool> _confirmDuplicateReceipt() async {
    final bool? confirmed = await showDialog<bool>(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: const Text('Create another receipt?'),
          content: const Text(
            'This list may already have a receipt. Create another receipt from these purchased items?',
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(false),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(true),
              child: const Text('Create receipt'),
            ),
          ],
        );
      },
    );
    return confirmed == true;
  }

  Future<void> _save(ShoppingList list) async {
    if (!_formKey.currentState!.validate()) return;

    if (list.lastFinalizedReceiptId != null) {
      final bool confirmed = await _confirmDuplicateReceipt();
      if (!confirmed || !mounted) return;
    }

    final double? total = double.tryParse(_totalController.text.trim());
    if (total == null || total <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Enter a valid receipt total.')),
      );
      return;
    }

    final List<ShoppingListItem> purchasedItems = _itemFields
        .map((PurchasedItemPriceFields fields) => fields.item)
        .toList(growable: false);
    final List<ReceiptItem> receiptItems =
        ShoppingTripReceiptBuilder.buildReceiptItems(
      purchasedItems: purchasedItems,
      unitPricesByItemId: _unitPricesByItemId(),
    );

    if (receiptItems.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Add valid prices for at least one purchased item.'),
        ),
      );
      return;
    }

    setState(() => _isSaving = true);

    final ReceiptStore receiptStore = ReceiptProvider.of(context);
    final ShoppingListsStore shoppingStore = ShoppingListsProvider.of(context);
    final String? address = _addressController.text.trim().isEmpty
        ? null
        : _addressController.text.trim();

    final String? receiptId = await receiptStore.createReceipt(
      storeName: _storeController.text.trim(),
      purchaseDate: _purchaseDate,
      total: total,
      subtotal: ShoppingTripReceiptBuilder.computeSubtotal(receiptItems),
      source: ReceiptSource.shoppingList,
      storeAddress: address,
      notes: ShoppingTripReceiptBuilder.buildNotes(listTitle: list.title),
      categorySummary: 'Grocery',
      items: receiptItems,
    );

    if (!mounted) return;

    if (receiptId == null) {
      setState(() => _isSaving = false);
      final String? error = receiptStore.mutationError;
      if (error != null) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(error)));
      }
      return;
    }

    await shoppingStore.markLastFinalizedReceipt(
      listId: widget.listId,
      receiptId: receiptId,
    );

    if (!mounted) return;
    setState(() => _isSaving = false);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Receipt saved. Price history updated.')),
    );
    context.push('/scanner/$receiptId');
  }

  @override
  Widget build(BuildContext context) {
    final ShoppingListsStore store = ShoppingListsProvider.of(context);
    final double bottomInset = MediaQuery.paddingOf(context).bottom;
    final double keyboardInset = MediaQuery.viewInsetsOf(context).bottom;

    return AnimatedBuilder(
      animation: store,
      builder: (BuildContext context, Widget? _) {
        final ShoppingList? list = _findList(store);
        _scheduleFieldInitialization(store);

        return Scaffold(
          backgroundColor: FinalizeShoppingTripScreen._pageBackground,
          appBar: AppBar(
            title: const Text(
              'Finalize shopping trip',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w800,
                color: SavingorColors.darkGreen,
              ),
            ),
            elevation: 0,
            scrolledUnderElevation: 0,
            backgroundColor: FinalizeShoppingTripScreen._pageBackground,
            surfaceTintColor: Colors.transparent,
            leading: IconButton(
              icon: const Icon(
                Icons.arrow_back_ios_new_rounded,
                color: SavingorColors.darkGreen,
                size: 20,
              ),
              onPressed: _isSaving ? null : () => context.pop(),
            ),
          ),
          body: _buildBody(
            context,
            store,
            list,
            bottomInset,
            keyboardInset,
          ),
        );
      },
    );
  }

  Widget _buildBody(
    BuildContext context,
    ShoppingListsStore store,
    ShoppingList? list,
    double bottomInset,
    double keyboardInset,
  ) {
    if (store.isLoadingLists || store.isLoadingItems) {
      return ShoppingListStatePanel.loading(message: 'Loading purchased items…');
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

    final ShoppingTripReceiptDraft draft = ShoppingTripReceiptBuilder.buildDraft(
      listItems: store.items,
    );

    if (draft.isEmpty) {
      return AppEmptyState(
        icon: Icons.shopping_bag_outlined,
        title: 'No purchased items yet',
        message: 'Check off items you bought before creating a receipt.',
        actionLabel: 'Back to list',
        prominentAction: true,
        onAction: () => context.pop(),
      );
    }

    if (!_fieldsInitialized) {
      return ShoppingListStatePanel.loading(
        message: 'Preparing purchased items…',
      );
    }

    return Form(
      key: _formKey,
      child: ListView(
        padding: EdgeInsets.fromLTRB(
          20,
          8,
          20,
          24 + bottomInset + keyboardInset,
        ),
        children: <Widget>[
          TextFormField(
            controller: _storeController,
            enabled: !_isSaving,
            textInputAction: TextInputAction.next,
            decoration: const InputDecoration(
              labelText: 'Store name',
              border: OutlineInputBorder(),
            ),
            validator: (String? value) {
              if (value == null || value.trim().isEmpty) {
                return 'Enter the store name for this trip';
              }
              return null;
            },
          ),
          if (draft.hasMultipleStores) ...<Widget>[
            const SizedBox(height: 8),
            const Text(
              'Use the store from this shopping trip. For multiple stores, create separate receipts later.',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: SavingorColors.textSecondary,
                height: 1.35,
              ),
            ),
          ],
          const SizedBox(height: 16),
          TextFormField(
            controller: _addressController,
            enabled: !_isSaving,
            textInputAction: TextInputAction.next,
            decoration: const InputDecoration(
              labelText: 'Store address (optional)',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _dateController,
            readOnly: true,
            onTap: _isSaving ? null : _pickDate,
            decoration: const InputDecoration(
              labelText: 'Purchase date',
              border: OutlineInputBorder(),
              suffixIcon: Icon(Icons.calendar_today_outlined),
            ),
            validator: (String? value) {
              if (value == null || value.trim().isEmpty) {
                return 'Select a purchase date';
              }
              return null;
            },
          ),
          const SizedBox(height: 24),
          const Text(
            'Purchased items',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w800,
              color: SavingorColors.darkGreen,
            ),
          ),
          const SizedBox(height: 12),
          ..._itemFields.map(
            (PurchasedItemPriceFields fields) => PurchasedItemPriceRow(
              item: fields.item,
              unitPriceController: fields.unitPriceController,
              onChanged: () => _syncTotalFromItems(),
            ),
          ),
          const SizedBox(height: 8),
          TextFormField(
            controller: _totalController,
            enabled: !_isSaving,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            onChanged: (_) {
              _totalManuallyEdited = true;
            },
            decoration: const InputDecoration(
              labelText: 'Receipt total',
              prefixText: '\$ ',
              border: OutlineInputBorder(),
            ),
            validator: (String? value) {
              if (value == null || value.trim().isEmpty) {
                return 'Enter the receipt total';
              }
              final double? total = double.tryParse(value.trim());
              if (total == null || total <= 0) {
                return 'Enter a valid receipt total';
              }
              return null;
            },
          ),
          const SizedBox(height: 8),
          Text(
            'Subtotal from item prices: '
            '\$${_computedSubtotal(draft.purchasedItems).toStringAsFixed(2)}',
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: SavingorColors.textSecondary,
            ),
          ),
          const SizedBox(height: 24),
          FilledButton(
            onPressed: _isSaving ? null : () => _save(list),
            style: SavingorButtonStyles.primaryFilled(),
            child: _isSaving
                ? const SizedBox(
                    width: 22,
                    height: 22,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Text('Save receipt'),
          ),
        ],
      ),
    );
  }
}
