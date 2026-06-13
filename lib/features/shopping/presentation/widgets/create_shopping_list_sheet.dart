import 'package:flutter/material.dart';

import 'package:savingor_app/core/i18n/shopping_l10n.dart';
import 'package:savingor_app/core/theme/savingor_design_system.dart';
import 'package:savingor_app/features/shopping/data/shopping_lists_store.dart';
import 'package:savingor_app/l10n/app_localizations.dart';

/// Quick create flow for a new shopping list (name only, real Firestore persistence).
class CreateShoppingListSheet extends StatefulWidget {
  const CreateShoppingListSheet({super.key});

  static String defaultTitle(BuildContext context) =>
      AppLocalizations.of(context).weeklyGroceriesDefault;

  static Future<void> show(BuildContext context) {
    return showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (BuildContext context) => const CreateShoppingListSheet(),
    );
  }

  @override
  State<CreateShoppingListSheet> createState() =>
      _CreateShoppingListSheetState();
}

class _CreateShoppingListSheetState extends State<CreateShoppingListSheet> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  late final TextEditingController _titleController;
  final FocusNode _titleFocusNode = FocusNode();

  bool _isSaving = false;

  bool _defaultTitleApplied = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_defaultTitleApplied) {
      _defaultTitleApplied = true;
      _titleController.text = CreateShoppingListSheet.defaultTitle(context);
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) return;
        _titleController.selection = TextSelection(
          baseOffset: 0,
          extentOffset: _titleController.text.length,
        );
        _titleFocusNode.requestFocus();
      });
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
    _titleFocusNode.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isSaving = true);
    final ShoppingListsStore store = ShoppingListsProvider.of(context);

    final String? listId = await store.createList(
      title: _titleController.text.trim(),
    );

    if (!mounted) return;
    setState(() => _isSaving = false);

    if (listId != null) {
      Navigator.of(context).pop();
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
    final double bottomInset = MediaQuery.viewInsetsOf(context).bottom;

    return Padding(
      padding: EdgeInsets.fromLTRB(20, 12, 20, 20 + bottomInset),
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: SavingorColors.textSecondary.withOpacity(0.25),
                  borderRadius: BorderRadius.circular(999),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              l10n.newShoppingList,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w800,
                color: SavingorColors.darkGreen,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              l10n.newShoppingListHint,
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w500,
                color: SavingorColors.textSecondary,
                height: 1.4,
              ),
            ),
            const SizedBox(height: 20),
            TextFormField(
              controller: _titleController,
              focusNode: _titleFocusNode,
              textInputAction: TextInputAction.done,
              enabled: !_isSaving,
              decoration: InputDecoration(
                labelText: l10n.listName,
                border: const OutlineInputBorder(),
              ),
              validator: (String? value) {
                if (value == null || value.trim().isEmpty) {
                  return l10n.enterListName;
                }
                return null;
              },
              onFieldSubmitted: (_) => _save(),
            ),
            const SizedBox(height: 20),
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
    );
  }
}
