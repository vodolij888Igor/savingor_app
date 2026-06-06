import 'package:flutter/material.dart';

import 'package:savingor_app/core/theme/savingor_design_system.dart';
import 'package:savingor_app/features/shopping/data/shopping_lists_store.dart';

/// Quick create flow for a new shopping list (name only, real Firestore persistence).
class CreateShoppingListSheet extends StatefulWidget {
  const CreateShoppingListSheet({super.key});

  static const String defaultTitle = 'Weekly groceries';

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

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: CreateShoppingListSheet.defaultTitle);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _titleController.selection = TextSelection(
        baseOffset: 0,
        extentOffset: _titleController.text.length,
      );
      _titleFocusNode.requestFocus();
    });
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
        SnackBar(content: Text(error)),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
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
            const Text(
              'New shopping list',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w800,
                color: SavingorColors.darkGreen,
              ),
            ),
            const SizedBox(height: 6),
            const Text(
              'Give your list a name. You can add items after creating it.',
              style: TextStyle(
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
              decoration: const InputDecoration(
                labelText: 'List name',
                border: OutlineInputBorder(),
              ),
              validator: (String? value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Enter a list name';
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
                  : const Text('Create list'),
            ),
          ],
        ),
      ),
    );
  }
}
