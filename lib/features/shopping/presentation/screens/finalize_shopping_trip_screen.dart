import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:savingor_app/core/i18n/locale_date_format.dart';
import 'package:savingor_app/core/i18n/receipt_l10n.dart';
import 'package:savingor_app/core/i18n/shopping_l10n.dart';
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
import 'package:savingor_app/l10n/app_localizations.dart';

class FinalizeShoppingTripScreen extends StatefulWidget {
  const FinalizeShoppingTripScreen({super.key, required this.listId});

  final String listId;
  @override
  State<FinalizeShoppingTripScreen> createState() =>
      _FinalizeShoppingTripScreenState();
}

class _FinalizeShoppingTripScreenState
    extends State<FinalizeShoppingTripScreen> {
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
  bool _dateFieldInitialized = false;

  final List<PurchasedItemPriceFields> _itemFields =
      <PurchasedItemPriceFields>[];

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_dateFieldInitialized) {
      _dateFieldInitialized = true;
      _dateController.text = _formatDate(context, _purchaseDate);
    }
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

    final ShoppingTripReceiptDraft draft =
        ShoppingTripReceiptBuilder.buildDraft(
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

  String _formatDate(BuildContext context, DateTime date) =>
      LocaleDateFormat.formatMediumDate(context, date);

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
      _dateController.text = _formatDate(context, picked);
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

  double _computedSubtotalForItems(List<ShoppingListItem> purchasedItems) {
    return ShoppingTripReceiptBuilder.computeSubtotal(
      ShoppingTripReceiptBuilder.buildReceiptItems(
        purchasedItems: purchasedItems,
        unitPricesByItemId: _unitPricesByItemId(),
      ),
    );
  }

  double _computedGrandSubtotal(ShoppingTripReceiptDraft draft) {
    return _computedSubtotalForItems(draft.purchasedItems);
  }

  double _computedGroupSubtotal(ShoppingTripStoreGroup group) {
    return _computedSubtotalForItems(group.items);
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

  Future<bool> _confirmDuplicateReceipt(AppLocalizations l10n) async {
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
    return confirmed == true;
  }

  Future<void> _save(
    ShoppingList list,
    ShoppingTripReceiptDraft draft,
    AppLocalizations l10n,
  ) async {
    if (!_formKey.currentState!.validate()) return;

    if (list.lastFinalizedReceiptId != null) {
      final bool confirmed = await _confirmDuplicateReceipt(l10n);
      if (!confirmed || !mounted) return;
    }

    final List<ShoppingListItem> purchasedItems = _itemFields
        .map((PurchasedItemPriceFields fields) => fields.item)
        .toList(growable: false);

    if (draft.hasMultipleStores && !draft.allGroupsHaveStoreNames) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.addStoreToAllItems)),
      );
      return;
    }

    final List<ShoppingTripStoreGroup> groups = draft.storeGroups;
    if (groups.isEmpty) {
      return;
    }

    setState(() => _isSaving = true);

    final ReceiptStore receiptStore = ReceiptProvider.of(context);
    final ShoppingListsStore shoppingStore = ShoppingListsProvider.of(context);
    final String? address = _addressController.text.trim().isEmpty
        ? null
        : _addressController.text.trim();
    final String notes =
        ShoppingTripReceiptBuilder.buildNotes(listTitle: list.title);

    final List<String> createdReceiptIds = <String>[];

    for (final ShoppingTripStoreGroup group in groups) {
      final String storeName = ShoppingTripReceiptBuilder.resolveStoreName(
        group: group,
        formStoreName: _storeController.text,
      );

      if (storeName.isEmpty) {
        setState(() => _isSaving = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(l10n.enterStoreNameForTripSnack)),
        );
        return;
      }

      final List<ReceiptItem> receiptItems =
          ShoppingTripReceiptBuilder.buildReceiptItems(
        purchasedItems: group.items,
        unitPricesByItemId: _unitPricesByItemId(),
      );

      if (receiptItems.isEmpty) {
        setState(() => _isSaving = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(l10n.addValidPricesForStore(storeName)),
          ),
        );
        return;
      }

      final double subtotal =
          ShoppingTripReceiptBuilder.computeSubtotal(receiptItems);
      final double total = draft.hasMultipleStores
          ? subtotal
          : (double.tryParse(_totalController.text.trim()) ?? subtotal);

      if (total <= 0) {
        setState(() => _isSaving = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(l10n.enterValidReceiptTotal)),
        );
        return;
      }

      final String? receiptId = await receiptStore.createReceipt(
        storeName: storeName,
        purchaseDate: _purchaseDate,
        total: total,
        subtotal: subtotal,
        source: ReceiptSource.shoppingList,
        storeAddress: address,
        notes: notes,
        categorySummary: 'Grocery',
        items: receiptItems,
      );

      if (!mounted) return;

      if (receiptId == null) {
        setState(() => _isSaving = false);
        final String? error = receiptStore.mutationError;
        if (error != null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(ReceiptL10n.localizeError(context, error))),
          );
        }
        return;
      }

      createdReceiptIds.add(receiptId);
    }

    final bool itemsRemoved = await shoppingStore.deleteItems(
      listId: widget.listId,
      itemIds: purchasedItems.map((ShoppingListItem item) => item.id),
    );

    if (!mounted) return;

    if (!itemsRemoved) {
      setState(() => _isSaving = false);
      final String? error = shoppingStore.mutationError;
      if (error != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(ShoppingL10n.localizeError(context, error))),
        );
      }
      return;
    }

    await shoppingStore.markLastFinalizedReceipt(
      listId: widget.listId,
      receiptId: createdReceiptIds.last,
    );

    if (!mounted) return;
    setState(() => _isSaving = false);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          l10n.shoppingTripFinalized(createdReceiptIds.length),
        ),
      ),
    );

    if (createdReceiptIds.length == 1) {
      context.push('/scanner/${createdReceiptIds.first}');
      return;
    }

    context.pop();
  }

  @override
  Widget build(BuildContext context) {
    final AppLocalizations l10n = AppLocalizations.of(context);
    final ShoppingListsStore store = ShoppingListsProvider.of(context);
    final double bottomInset = MediaQuery.paddingOf(context).bottom;
    final double keyboardInset = MediaQuery.viewInsetsOf(context).bottom;

    return AnimatedBuilder(
      animation: store,
      builder: (BuildContext context, Widget? _) {
        final ShoppingList? list = _findList(store);
        _scheduleFieldInitialization(store);

        return Scaffold(
          backgroundColor: context.savingor.pageBackground,
          appBar: AppBar(
            title: Text(
              l10n.finalizeShoppingTrip,
              style: SavingorAppTextStyles.screenTitle(context).copyWith(
                color: SavingorWorkflowTheme.primaryText(context),
              ),
            ),
            elevation: 0,
            scrolledUnderElevation: 0,
            backgroundColor: context.savingor.pageBackground,
            surfaceTintColor: Colors.transparent,
            leading: IconButton(
              icon: Icon(
                Icons.arrow_back_ios_new_rounded,
                color: SavingorWorkflowTheme.appBarIcon(context),
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
            l10n,
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
    AppLocalizations l10n,
  ) {
    if (store.isLoadingLists || store.isLoadingItems) {
      return ShoppingListStatePanel.loading(
          message: l10n.loadingPurchasedItems);
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

    final ShoppingTripReceiptDraft draft =
        ShoppingTripReceiptBuilder.buildDraft(
      listItems: store.items,
    );

    if (draft.isEmpty) {
      return AppEmptyState(
        icon: Icons.shopping_bag_outlined,
        title: l10n.noPurchasedItemsYet,
        message: l10n.noPurchasedItemsYetMessage,
        actionLabel: l10n.backToList,
        prominentAction: true,
        onAction: () => context.pop(),
      );
    }

    if (!_fieldsInitialized) {
      return ShoppingListStatePanel.loading(
        message: l10n.preparingPurchasedItems,
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
          if (!draft.hasMultipleStores) ...<Widget>[
            TextFormField(
              controller: _storeController,
              enabled: !_isSaving,
              textInputAction: TextInputAction.next,
              decoration: SavingorWorkflowTheme.fieldDecoration(
                context,
                label: l10n.storeName,
              ),
              validator: (String? value) {
                if (value == null || value.trim().isEmpty) {
                  return l10n.enterStoreNameForTrip;
                }
                return null;
              },
            ),
          ] else ...<Widget>[
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(14),
              decoration:
                  SavingorWorkflowTheme.highlightCard(context, radius: 14),
              child: Text(
                l10n.creatingReceiptsPerStore(draft.receiptCount),
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: SavingorWorkflowTheme.primaryText(context),
                  height: 1.35,
                ),
              ),
            ),
          ],
          if (draft.hasMultipleStores &&
              !draft.allGroupsHaveStoreNames) ...<Widget>[
            const SizedBox(height: 8),
            Text(
              l10n.missingStoreOnItems,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: context.savingor.textSecondary,
                height: 1.35,
              ),
            ),
          ],
          const SizedBox(height: 16),
          TextFormField(
            controller: _addressController,
            enabled: !_isSaving,
            textInputAction: TextInputAction.next,
            decoration: SavingorWorkflowTheme.fieldDecoration(
              context,
              label: l10n.storeAddressOptional,
            ),
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _dateController,
            readOnly: true,
            onTap: _isSaving ? null : _pickDate,
            decoration: SavingorWorkflowTheme.fieldDecoration(
              context,
              label: l10n.purchaseDate,
              suffixIcon: const Icon(Icons.calendar_today_outlined),
            ),
            validator: (String? value) {
              if (value == null || value.trim().isEmpty) {
                return l10n.selectPurchaseDate;
              }
              return null;
            },
          ),
          const SizedBox(height: 24),
          if (draft.hasMultipleStores)
            ...draft.storeGroups.expand(
              (ShoppingTripStoreGroup group) => <Widget>[
                Text(
                  group.hasStoreName ? group.storeName : l10n.missingStore,
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w800,
                    color: SavingorWorkflowTheme.primaryText(context),
                  ),
                ),
                const SizedBox(height: 8),
                ...group.items.map(
                  (ShoppingListItem item) {
                    final PurchasedItemPriceFields fields =
                        _itemFields.firstWhere(
                      (PurchasedItemPriceFields candidate) =>
                          candidate.item.id == item.id,
                    );
                    return PurchasedItemPriceRow(
                      item: fields.item,
                      unitPriceController: fields.unitPriceController,
                      onChanged: () => _syncTotalFromItems(),
                    );
                  },
                ),
                const SizedBox(height: 6),
                Text(
                  l10n.receiptSubtotalLabel(
                    '\$${_computedGroupSubtotal(group).toStringAsFixed(2)}',
                  ),
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: SavingorWorkflowTheme.accentText(context),
                  ),
                ),
                const SizedBox(height: 18),
              ],
            )
          else ...<Widget>[
            Text(
              l10n.purchasedItems,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w800,
                color: SavingorWorkflowTheme.primaryText(context),
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
          ],
          if (!draft.hasMultipleStores) ...<Widget>[
            const SizedBox(height: 8),
            TextFormField(
              controller: _totalController,
              enabled: !_isSaving,
              keyboardType:
                  const TextInputType.numberWithOptions(decimal: true),
              onChanged: (_) {
                _totalManuallyEdited = true;
              },
              decoration: SavingorWorkflowTheme.fieldDecoration(
                context,
                label: l10n.receiptTotal,
                prefixText: '\$ ',
              ),
              validator: (String? value) {
                if (value == null || value.trim().isEmpty) {
                  return l10n.enterReceiptTotal;
                }
                final double? total = double.tryParse(value.trim());
                if (total == null || total <= 0) {
                  return l10n.enterValidReceiptTotal;
                }
                return null;
              },
            ),
            const SizedBox(height: 8),
            Text(
              l10n.subtotalFromItemPrices(
                '\$${_computedGrandSubtotal(draft).toStringAsFixed(2)}',
              ),
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: context.savingor.textSecondary,
              ),
            ),
          ] else ...<Widget>[
            Text(
              l10n.grandTotalAcrossReceipts(
                '\$${_computedGrandSubtotal(draft).toStringAsFixed(2)}',
              ),
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: context.savingor.textSecondary,
              ),
            ),
          ],
          const SizedBox(height: 24),
          FilledButton(
            onPressed: _isSaving ? null : () => _save(list, draft, l10n),
            style: SavingorButtonStyles.primaryFilledFor(context),
            child: _isSaving
                ? const SizedBox(
                    width: 22,
                    height: 22,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : Text(
                    draft.hasMultipleStores
                        ? l10n.saveReceipts
                        : l10n.saveReceipt,
                  ),
          ),
        ],
      ),
    );
  }
}
