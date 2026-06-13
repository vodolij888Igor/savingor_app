import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:savingor_app/core/i18n/shopping_l10n.dart';
import 'package:savingor_app/core/theme/savingor_design_system.dart';
import 'package:savingor_app/features/shopping/data/shopping_lists_store.dart';
import 'package:savingor_app/l10n/app_localizations.dart';

class AddShoppingListItemScreen extends StatefulWidget {
  const AddShoppingListItemScreen({super.key, required this.listId});

  final String listId;
  @override
  State<AddShoppingListItemScreen> createState() =>
      _AddShoppingListItemScreenState();
}

class _AddShoppingListItemScreenState extends State<AddShoppingListItemScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _storeController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();

  bool _isSaving = false;

  @override
  void dispose() {
    _nameController.dispose();
    _storeController.dispose();
    _priceController.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isSaving = true);
    final ShoppingListsStore store = ShoppingListsProvider.of(context);

    final bool ok = await store.addItem(
      listId: widget.listId,
      name: _nameController.text,
      store: _storeController.text,
      unitPrice: double.tryParse(_priceController.text.trim()),
    );

    if (!mounted) return;
    setState(() => _isSaving = false);

    if (ok) {
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
    final double keyboardInset = MediaQuery.viewInsetsOf(context).bottom;

    return Scaffold(
      backgroundColor: context.savingor.pageBackground,
      appBar: AppBar(
        title: Text(
          l10n.addItem,
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
                controller: _nameController,
                textInputAction: TextInputAction.next,
                decoration: SavingorWorkflowTheme.fieldDecoration(
                  context,
                  label: l10n.itemName,
                ),
                validator: (String? value) {
                  if (value == null || value.trim().isEmpty) {
                    return l10n.enterItemName;
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _storeController,
                textInputAction: TextInputAction.next,
                decoration: SavingorWorkflowTheme.fieldDecoration(
                  context,
                  label: l10n.storeOptional,
                ),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _priceController,
                keyboardType:
                    const TextInputType.numberWithOptions(decimal: true),
                textInputAction: TextInputAction.done,
                decoration: SavingorWorkflowTheme.fieldDecoration(
                  context,
                  label: l10n.priceOptional,
                ),
              ),
              const SizedBox(height: 24),
              FilledButton(
                onPressed: _isSaving ? null : _save,
                style: SavingorButtonStyles.primaryFilledFor(context),
                child: _isSaving
                    ? const SizedBox(
                        width: 22,
                        height: 22,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : Text(l10n.saveItem),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
