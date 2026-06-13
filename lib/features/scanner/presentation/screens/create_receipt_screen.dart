import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:savingor_app/core/app_state.dart';
import 'package:savingor_app/core/i18n/receipt_l10n.dart';
import 'package:savingor_app/core/theme/savingor_design_system.dart';
import 'package:savingor_app/features/receipts/domain/models/receipt.dart';
import 'package:savingor_app/features/receipts/domain/models/receipt_item.dart';
import 'package:savingor_app/features/receipts/domain/models/receipt_source.dart';
import 'package:savingor_app/features/receipts/presentation/widgets/receipt_item_form_row.dart';
import 'package:savingor_app/features/scanner/data/receipt_store.dart';
import 'package:savingor_app/l10n/app_localizations.dart';

class CreateReceiptScreen extends StatefulWidget {
  const CreateReceiptScreen({
    super.key,
    this.receiptId,
    this.initialStoreName,
    this.initialDate,
    this.initialTotal,
    this.initialCategory,
    this.initialNotes,
    this.initialStoreAddress,
    this.initialItemNames = const <String>[],
    this.initialSource = ReceiptSource.manual,
    this.isEditing = false,
  });

  final String? receiptId;
  final String? initialStoreName;
  final DateTime? initialDate;
  final double? initialTotal;
  final String? initialCategory;
  final String? initialNotes;
  final String? initialStoreAddress;
  final List<String> initialItemNames;
  final ReceiptSource initialSource;
  final bool isEditing;
  @override
  State<CreateReceiptScreen> createState() => _CreateReceiptScreenState();
}

class _CreateReceiptScreenState extends State<CreateReceiptScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _storeController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _categoryController = TextEditingController();
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _subtotalController = TextEditingController();
  final TextEditingController _taxController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _notesController = TextEditingController();

  DateTime _selectedDate = DateTime.now();
  bool _isSaving = false;
  bool _totalManuallyEdited = false;
  ReceiptSource _source = ReceiptSource.manual;
  final List<EditableReceiptItemFields> _itemFields =
      <EditableReceiptItemFields>[];

  @override
  void initState() {
    super.initState();
    _source = widget.initialSource;
    _selectedDate = widget.initialDate ?? DateTime.now();
    _dateController.text = _formatDate(_selectedDate);

    if (widget.initialStoreName != null) {
      _storeController.text = widget.initialStoreName!;
    }
    if (widget.initialCategory != null) {
      _categoryController.text = widget.initialCategory!;
    }
    if (widget.initialTotal != null) {
      _amountController.text = widget.initialTotal!.toStringAsFixed(2);
    }
    if (widget.initialNotes != null) {
      _notesController.text = widget.initialNotes!;
    }
    if (widget.initialStoreAddress != null) {
      _addressController.text = widget.initialStoreAddress!;
    }

    if (widget.isEditing && widget.receiptId != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _loadExistingReceipt();
      });
    } else if (widget.initialItemNames.isNotEmpty) {
      for (final String itemName in widget.initialItemNames) {
        final EditableReceiptItemFields fields =
            EditableReceiptItemFields.fromReceiptItem(
          id: 'item_${DateTime.now().microsecondsSinceEpoch}_${_itemFields.length}',
          name: itemName,
          quantity: 1,
          totalPrice: 0,
        );
        fields.priceController.addListener(_syncTotalFromItems);
        _itemFields.add(fields);
      }
    }
  }

  void _loadExistingReceipt() {
    final ReceiptStore store = ReceiptProvider.of(context);
    final Receipt? receipt = store.receiptById(widget.receiptId!);
    if (receipt == null) {
      return;
    }

    setState(() {
      _storeController.text = receipt.storeName;
      _selectedDate = receipt.purchaseDate;
      _dateController.text = _formatDate(receipt.purchaseDate);
      _categoryController.text = receipt.categorySummary ?? receipt.category;
      _amountController.text = receipt.total.toStringAsFixed(2);
      _subtotalController.text = receipt.subtotal?.toStringAsFixed(2) ?? '';
      _taxController.text = receipt.tax?.toStringAsFixed(2) ?? '';
      _addressController.text = receipt.displayAddress ?? '';
      _notesController.text = receipt.notes ?? '';
      _source = receipt.source;
      _totalManuallyEdited = true;

      for (final EditableReceiptItemFields fields in _itemFields) {
        fields.dispose();
      }
      _itemFields.clear();

      for (final ReceiptItem item in receipt.items) {
        final EditableReceiptItemFields fields =
            EditableReceiptItemFields.fromReceiptItem(
          id: item.id,
          name: item.name,
          quantity: item.quantity,
          totalPrice: item.totalPrice,
          category: item.category,
        );
        fields.priceController.addListener(_syncTotalFromItems);
        _itemFields.add(fields);
      }
    });
  }

  @override
  void dispose() {
    _storeController.dispose();
    _dateController.dispose();
    _categoryController.dispose();
    _amountController.dispose();
    _subtotalController.dispose();
    _taxController.dispose();
    _addressController.dispose();
    _notesController.dispose();
    for (final EditableReceiptItemFields fields in _itemFields) {
      fields.dispose();
    }
    super.dispose();
  }

  String _formatDate(DateTime date) {
    final String month = date.month.toString().padLeft(2, '0');
    final String day = date.day.toString().padLeft(2, '0');
    return '${date.year}-$month-$day';
  }

  Future<void> _pickDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: SavingorColors.primaryStroke,
              onPrimary: Colors.white,
              surface: Colors.white,
              onSurface: SavingorColors.darkGreen,
            ),
          ),
          child: child ?? const SizedBox.shrink(),
        );
      },
    );

    if (picked == null) return;
    setState(() {
      _selectedDate = picked;
      _dateController.text = _formatDate(picked);
    });
  }

  void _addItemRow() {
    setState(() {
      final EditableReceiptItemFields fields =
          EditableReceiptItemFields.empty();
      fields.priceController.addListener(_syncTotalFromItems);
      _itemFields.add(fields);
      _totalManuallyEdited = false;
      _syncTotalFromItems();
    });
  }

  void _removeItemRow(int index) {
    setState(() {
      _itemFields.removeAt(index).dispose();
      _syncTotalFromItems();
    });
  }

  void _syncTotalFromItems() {
    if (_totalManuallyEdited || _itemFields.isEmpty) {
      return;
    }

    double sum = 0;
    for (final EditableReceiptItemFields fields in _itemFields) {
      final double? price = double.tryParse(fields.priceController.text.trim());
      if (price != null) {
        sum += price;
      }
    }
    _amountController.text = sum.toStringAsFixed(2);
  }

  List<ReceiptItem> _buildReceiptItems() {
    final List<ReceiptItem> items = <ReceiptItem>[];
    for (final EditableReceiptItemFields fields in _itemFields) {
      final String name = fields.nameController.text.trim();
      if (name.isEmpty) {
        continue;
      }
      final double quantity =
          double.tryParse(fields.quantityController.text.trim()) ?? 1;
      final double totalPrice =
          double.tryParse(fields.priceController.text.trim()) ?? 0;
      final String? category = fields.categoryController.text.trim().isEmpty
          ? null
          : fields.categoryController.text.trim();

      items.add(
        ReceiptItem(
          id: fields.id,
          name: name,
          quantity: quantity,
          totalPrice: totalPrice,
          category: category,
          unitPrice: quantity > 0 ? totalPrice / quantity : totalPrice,
        ),
      );
    }
    return items;
  }

  double? _optionalAmount(TextEditingController controller) {
    final String trimmed = controller.text.trim();
    if (trimmed.isEmpty) {
      return null;
    }
    return double.tryParse(trimmed);
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;

    final double? totalAmount = double.tryParse(_amountController.text.trim());
    if (totalAmount == null || totalAmount <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text(AppLocalizations.of(context).enterValidTotalAmount)),
      );
      return;
    }

    setState(() => _isSaving = true);
    final ReceiptStore store = ReceiptProvider.of(context);
    final List<ReceiptItem> items = _buildReceiptItems();
    final String? notes = _notesController.text.trim().isEmpty
        ? null
        : _notesController.text.trim();
    final String? address = _addressController.text.trim().isEmpty
        ? null
        : _addressController.text.trim();
    final String categorySummary = _categoryController.text.trim().isEmpty
        ? 'Grocery'
        : _categoryController.text.trim();

    if (widget.isEditing) {
      final String? receiptId = widget.receiptId;
      if (receiptId == null || receiptId.isEmpty) {
        setState(() => _isSaving = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(AppLocalizations.of(context).receiptNotFound)),
        );
        return;
      }

      final bool updated = await store.updateReceipt(
        receiptId: receiptId,
        storeName: _storeController.text.trim(),
        purchaseDate: _selectedDate,
        total: totalAmount,
        source: _source,
        storeAddress: address,
        subtotal: _optionalAmount(_subtotalController),
        tax: _optionalAmount(_taxController),
        notes: notes,
        categorySummary: categorySummary,
        items: items,
      );

      if (!mounted) return;
      setState(() => _isSaving = false);

      if (updated) {
        context.pop();
        return;
      }

      _showMutationError(store.mutationError);
      return;
    }

    final AppState appState = AppStateProvider.of(context);
    final String? receiptId = await store.createReceipt(
      storeName: _storeController.text.trim(),
      purchaseDate: _selectedDate,
      total: totalAmount,
      source: _source,
      storeAddress: address,
      subtotal: _optionalAmount(_subtotalController),
      tax: _optionalAmount(_taxController),
      notes: notes,
      categorySummary: categorySummary,
      items: items,
      currency: appState.currency,
    );

    if (!mounted) return;
    setState(() => _isSaving = false);

    if (receiptId != null) {
      context.pop();
      return;
    }

    _showMutationError(store.mutationError);
  }

  void _showMutationError(String? error) {
    if (error != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(ReceiptL10n.localizeError(context, error))),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final AppLocalizations l10n = AppLocalizations.of(context);
    final double bottomInset = MediaQuery.paddingOf(context).bottom;
    final double keyboardInset = MediaQuery.viewInsetsOf(context).bottom;
    final String appBarTitle =
        widget.isEditing ? l10n.editReceipt : l10n.addReceipt;
    final String saveLabel =
        widget.isEditing ? l10n.updateReceipt : l10n.saveReceipt;

    return Scaffold(
      backgroundColor: context.savingor.pageBackground,
      appBar: AppBar(
        title: Text(
          appBarTitle,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w800,
            color: SavingorColors.darkGreen,
          ),
        ),
        elevation: 0,
        scrolledUnderElevation: 0,
        backgroundColor: context.savingor.pageBackground,
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
      body: ColoredBox(
        color: context.savingor.pageBackground,
        child: Form(
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
                decoration: InputDecoration(
                  labelText: l10n.storeName,
                  border: const OutlineInputBorder(),
                ),
                validator: (String? value) {
                  if (value == null || value.trim().isEmpty) {
                    return l10n.enterStoreName;
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _addressController,
                enabled: !_isSaving,
                textInputAction: TextInputAction.next,
                decoration: InputDecoration(
                  labelText: l10n.storeAddressOptional,
                  border: const OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _dateController,
                readOnly: true,
                onTap: _isSaving ? null : _pickDate,
                decoration: InputDecoration(
                  labelText: l10n.purchaseDate,
                  border: const OutlineInputBorder(),
                  suffixIcon: const Icon(Icons.calendar_today_outlined),
                ),
                validator: (String? value) {
                  if (value == null || value.trim().isEmpty) {
                    return l10n.selectPurchaseDate;
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _categoryController,
                enabled: !_isSaving,
                textInputAction: TextInputAction.next,
                decoration: InputDecoration(
                  labelText: l10n.categorySummary,
                  border: const OutlineInputBorder(),
                  hintText: l10n.grocery,
                ),
              ),
              const SizedBox(height: 16),
              Row(
                children: <Widget>[
                  Expanded(
                    child: TextFormField(
                      controller: _subtotalController,
                      enabled: !_isSaving,
                      keyboardType: const TextInputType.numberWithOptions(
                        decimal: true,
                      ),
                      decoration: InputDecoration(
                        labelText: l10n.subtotalOptional,
                        prefixText: '\$ ',
                        border: const OutlineInputBorder(),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: TextFormField(
                      controller: _taxController,
                      enabled: !_isSaving,
                      keyboardType: const TextInputType.numberWithOptions(
                        decimal: true,
                      ),
                      decoration: InputDecoration(
                        labelText: l10n.taxOptional,
                        prefixText: '\$ ',
                        border: const OutlineInputBorder(),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _amountController,
                enabled: !_isSaving,
                keyboardType:
                    const TextInputType.numberWithOptions(decimal: true),
                onChanged: (_) => _totalManuallyEdited = true,
                decoration: InputDecoration(
                  labelText: l10n.receiptTotal,
                  prefixText: '\$ ',
                  border: const OutlineInputBorder(),
                  helperText: _itemFields.isNotEmpty
                      ? l10n.autoCalculatedFromItems
                      : null,
                ),
                validator: (String? value) {
                  if (value == null || value.trim().isEmpty) {
                    return l10n.enterTotalAmount;
                  }
                  final double? amount = double.tryParse(value.trim());
                  if (amount == null || amount <= 0) {
                    return l10n.enterValidAmount;
                  }
                  return null;
                },
              ),
              const SizedBox(height: 24),
              Row(
                children: <Widget>[
                  Expanded(
                    child: Text(
                      l10n.items,
                      style: const TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w700,
                        color: SavingorColors.darkGreen,
                      ),
                    ),
                  ),
                  TextButton.icon(
                    onPressed: _isSaving ? null : _addItemRow,
                    icon: const Icon(Icons.add_rounded, size: 18),
                    label: Text(l10n.addItem),
                  ),
                ],
              ),
              if (_itemFields.isEmpty)
                Text(
                  l10n.addLineItemsHint,
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                    color: context.savingor.textSecondary.withOpacity(0.95),
                    height: 1.4,
                  ),
                )
              else
                ...List<Widget>.generate(_itemFields.length, (int index) {
                  final EditableReceiptItemFields fields = _itemFields[index];
                  return ReceiptItemFormRow(
                    nameController: fields.nameController,
                    quantityController: fields.quantityController,
                    priceController: fields.priceController,
                    categoryController: fields.categoryController,
                    enabled: !_isSaving,
                    onRemove: () => _removeItemRow(index),
                  );
                }),
              const SizedBox(height: 16),
              TextFormField(
                controller: _notesController,
                enabled: !_isSaving,
                textInputAction: TextInputAction.done,
                maxLines: 3,
                decoration: InputDecoration(
                  labelText: l10n.notesOptional,
                  border: const OutlineInputBorder(),
                  alignLabelWithHint: true,
                ),
              ),
              const SizedBox(height: 24),
              FilledButton(
                onPressed: _isSaving ? null : _save,
                style: SavingorButtonStyles.primaryFilled(),
                child: _isSaving
                    ? const SizedBox(
                        width: 22,
                        height: 22,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : Text(saveLabel),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
