import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:savingor_app/core/i18n/shopping_l10n.dart';
import 'package:savingor_app/core/theme/savingor_design_system.dart';
import 'package:savingor_app/features/shopping/data/shopping_lists_store.dart';
import 'package:savingor_app/features/shopping/presentation/widgets/create_shopping_list_sheet.dart';
import 'package:savingor_app/features/shopping/domain/models/shopping_list_item.dart';
import 'package:savingor_app/l10n/app_localizations.dart';

class CreateShoppingListScreen extends StatefulWidget {
  const CreateShoppingListScreen({super.key});

  static const Color _pageBackground = Colors.white;

  @override
  State<CreateShoppingListScreen> createState() =>
      _CreateShoppingListScreenState();
}

class _CreateShoppingListScreenState extends State<CreateShoppingListScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  late final TextEditingController _titleController;
  final List<_ItemRowControllers> _itemRows = <_ItemRowControllers>[
    _ItemRowControllers(),
  ];

  bool _isSaving = false;

  bool _defaultTitleApplied = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_defaultTitleApplied) {
      _defaultTitleApplied = true;
      _titleController.text = CreateShoppingListSheet.defaultTitle(context);
    }
  }

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController();
  }

  @override
  void dispose() {
    _titleController.dispose();
    for (final _ItemRowControllers row in _itemRows) {
      row.dispose();
    }
    super.dispose();
  }

  void _addRow() {
    setState(() => _itemRows.add(_ItemRowControllers()));
  }

  void _removeRow(int index) {
    if (_itemRows.length == 1) return;
    setState(() {
      _itemRows.removeAt(index).dispose();
    });
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isSaving = true);
    final ShoppingListsStore store = ShoppingListsProvider.of(context);

    final List<NewShoppingListItemInput> items = _itemRows
        .map(
          (_ItemRowControllers row) => NewShoppingListItemInput(
            name: row.nameController.text.trim(),
            quantity: int.tryParse(row.qtyController.text.trim()) ?? 1,
            store: row.storeController.text.trim().isEmpty
                ? null
                : row.storeController.text.trim(),
            unitPrice: double.tryParse(row.priceController.text.trim()),
          ),
        )
        .where((NewShoppingListItemInput item) => item.name.isNotEmpty)
        .toList(growable: false);

    final String? listId = await store.createList(
      title: _titleController.text.trim(),
      items: items,
    );

    if (!mounted) return;
    setState(() => _isSaving = false);

    if (listId != null) {
      context.pop();
      return;
    }

    final String? error = store.mutationError;
    if (error != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(ShoppingL10n.localizeError(context, error))),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final AppLocalizations l10n = AppLocalizations.of(context);
    final double bottomInset = MediaQuery.paddingOf(context).bottom;

    return Scaffold(
      backgroundColor: CreateShoppingListScreen._pageBackground,
      appBar: AppBar(
        title: Text(
          l10n.newShoppingList,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w800,
            color: SavingorColors.darkGreen,
          ),
        ),
        elevation: 0,
        scrolledUnderElevation: 0,
        backgroundColor: CreateShoppingListScreen._pageBackground,
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
        color: CreateShoppingListScreen._pageBackground,
        child: Form(
          key: _formKey,
          child: ListView(
            padding: EdgeInsets.fromLTRB(20, 8, 20, 24 + bottomInset),
            children: <Widget>[
            TextFormField(
              controller: _titleController,
              decoration: InputDecoration(
                labelText: l10n.listTitle,
                border: const OutlineInputBorder(),
              ),
              validator: (String? value) {
                if (value == null || value.trim().isEmpty) {
                  return l10n.enterListTitle;
                }
                return null;
              },
            ),
            const SizedBox(height: 24),
            Text(
              l10n.itemsOptional,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w700,
                color: SavingorColors.darkGreen,
              ),
            ),
            const SizedBox(height: 12),
            for (int i = 0; i < _itemRows.length; i++)
              _ItemRowEditor(
                row: _itemRows[i],
                index: i,
                canRemove: _itemRows.length > 1,
                onRemove: () => _removeRow(i),
              ),
            Align(
              alignment: Alignment.centerLeft,
              child: TextButton.icon(
                onPressed: _isSaving ? null : _addRow,
                icon: const Icon(Icons.add_rounded),
                label: Text(l10n.addAnotherItem),
              ),
            ),
            const SizedBox(height: 16),
            FilledButton(
              onPressed: _isSaving ? null : _save,
              style: SavingorButtonStyles.primaryFilled(),
              child: _isSaving
                  ? const SizedBox(
                      width: 22,
                      height: 22,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : Text(l10n.createList),
            ),
          ],
        ),
      ),
      ),
    );
  }
}

class _ItemRowControllers {
  _ItemRowControllers()
      : nameController = TextEditingController(),
        qtyController = TextEditingController(text: '1'),
        storeController = TextEditingController(),
        priceController = TextEditingController();

  final TextEditingController nameController;
  final TextEditingController qtyController;
  final TextEditingController storeController;
  final TextEditingController priceController;

  void dispose() {
    nameController.dispose();
    qtyController.dispose();
    storeController.dispose();
    priceController.dispose();
  }
}

class _ItemRowEditor extends StatelessWidget {
  const _ItemRowEditor({
    required this.row,
    required this.index,
    required this.canRemove,
    required this.onRemove,
  });

  final _ItemRowControllers row;
  final int index;
  final bool canRemove;
  final VoidCallback onRemove;

  @override
  Widget build(BuildContext context) {
    final AppLocalizations l10n = AppLocalizations.of(context);

    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Row(
            children: <Widget>[
              Expanded(
                child: TextFormField(
                  controller: row.nameController,
                  decoration: InputDecoration(
                    labelText: l10n.itemName,
                    border: const OutlineInputBorder(),
                    hintText: 'Item ${index + 1}',
                  ),
                ),
              ),
              if (canRemove)
                IconButton(
                  onPressed: onRemove,
                  icon: const Icon(Icons.close_rounded),
                ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: <Widget>[
              Expanded(
                child: TextFormField(
                  controller: row.qtyController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: l10n.qty,
                    border: const OutlineInputBorder(),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                flex: 2,
                child: TextFormField(
                  controller: row.storeController,
                  decoration: InputDecoration(
                    labelText: l10n.storeOptional,
                    border: const OutlineInputBorder(),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          TextFormField(
            controller: row.priceController,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            decoration: InputDecoration(
              labelText: l10n.priceOptional,
              border: const OutlineInputBorder(),
            ),
          ),
        ],
      ),
    );
  }
}
