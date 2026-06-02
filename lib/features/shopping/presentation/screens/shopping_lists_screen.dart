import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:savingor_app/core/i18n/app_strings.dart';
import 'package:savingor_app/core/theme/savingor_design_system.dart';
import 'package:savingor_app/core/widgets/app_screen_states.dart';
import 'package:savingor_app/features/shopping/data/shopping_lists_store.dart';
import 'package:savingor_app/features/shopping/domain/models/shopping_list.dart';
import 'package:savingor_app/features/shopping/presentation/widgets/shopping_list_state_panel.dart';

class ShoppingListsScreen extends StatelessWidget {
  const ShoppingListsScreen({super.key, this.showBackButton = false});

  final bool showBackButton;

  static const Color _pageBackground = Colors.white;

  @override
  Widget build(BuildContext context) {
    final AppStrings t = AppStrings.of(context);
    final ShoppingListsStore store = ShoppingListsProvider.of(context);
    final double bottomInset = MediaQuery.paddingOf(context).bottom;

    return AnimatedBuilder(
      animation: store,
      builder: (BuildContext context, Widget? child) {
        if (!store.isAuthenticated) {
          return _buildSignInRequired(context, t);
        }

        final bool showNewListFab = !store.isLoadingLists &&
            store.listsError == null &&
            store.lists.isNotEmpty;

        return Scaffold(
          backgroundColor: _pageBackground,
          appBar: AppBar(
            title: Text(t.shoppingList, style: _titleStyle),
            centerTitle: false,
            elevation: 0,
            scrolledUnderElevation: 0,
            backgroundColor: _pageBackground,
            surfaceTintColor: Colors.transparent,
            leading: showBackButton
                ? IconButton(
                    icon: const Icon(
                      Icons.arrow_back_ios_new_rounded,
                      color: SavingorColors.darkGreen,
                      size: 20,
                    ),
                    onPressed: () => context.pop(),
                  )
                : null,
            automaticallyImplyLeading: showBackButton,
          ),
          body: _buildBody(context, store, bottomInset),
          floatingActionButton: showNewListFab
              ? FloatingActionButton.extended(
                  onPressed: () => context.push('/shopping/create'),
                  backgroundColor: SavingorColors.primaryGreen,
                  foregroundColor: SavingorColors.darkGreen,
                  icon: const Icon(Icons.add_rounded),
                  label: const Text(
                    'New list',
                    style: TextStyle(fontWeight: FontWeight.w700),
                  ),
                )
              : null,
        );
      },
    );
  }

  Widget _buildBody(
    BuildContext context,
    ShoppingListsStore store,
    double bottomInset,
  ) {
    if (store.isLoadingLists) {
      return ShoppingListStatePanel.loading(
        message: 'Loading shopping lists…',
      );
    }

    if (store.listsError != null) {
      return ShoppingListStatePanel.error(
        title: 'Could not load lists',
        message: store.listsError!,
        onRetry: store.retryLists,
      );
    }

    if (store.lists.isEmpty) {
      return ShoppingListStatePanel.empty(
        icon: Icons.checklist_rounded,
        title: 'No shopping lists yet',
        message:
            'Create a list to plan groceries, compare deals, and save smarter.',
        actionLabel: 'Create List',
        prominentAction: true,
        onAction: () => context.push('/shopping/create'),
      );
    }

    return ListView.separated(
      padding: EdgeInsets.fromLTRB(20, 8, 20, 96 + bottomInset),
      itemCount: store.lists.length,
      separatorBuilder: (_, __) => const SizedBox(height: 12),
      itemBuilder: (BuildContext context, int index) {
        final ShoppingList list = store.lists[index];
        return _ShoppingListCard(
          list: list,
          onOpen: () => context.push('/shopping/list/${list.id}'),
          onDelete: () => _confirmDelete(context, store, list),
        );
      },
    );
  }

  Widget _buildSignInRequired(BuildContext context, AppStrings t) {
    return Scaffold(
      backgroundColor: _pageBackground,
      appBar: AppBar(
        title: Text(t.shoppingList, style: _titleStyle),
        backgroundColor: _pageBackground,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
        leading: showBackButton
            ? IconButton(
                icon: const Icon(
                  Icons.arrow_back_ios_new_rounded,
                  color: SavingorColors.darkGreen,
                  size: 20,
                ),
                onPressed: () => context.pop(),
              )
            : null,
        automaticallyImplyLeading: showBackButton,
      ),
      body: AppSignInRequiredState(
        message: 'Create and sync shopping lists with your Savingor account.',
        onSignIn: () => context.push('/auth'),
      ),
    );
  }

  Future<void> _confirmDelete(
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
    await store.deleteList(list.id);
    if (!context.mounted) return;
    final String? error = store.mutationError;
    if (error != null) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(error)));
    }
  }

  static const TextStyle _titleStyle = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.w800,
    color: SavingorColors.darkGreen,
    letterSpacing: 0.2,
    height: 1.15,
  );
}

class _ShoppingListCard extends StatelessWidget {
  const _ShoppingListCard({
    required this.list,
    required this.onOpen,
    required this.onDelete,
  });

  final ShoppingList list;
  final VoidCallback onOpen;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onOpen,
        borderRadius: BorderRadius.circular(18),
        child: Ink(
          decoration: shoppingListCardDecoration(),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 8, 16),
            child: Row(
              children: <Widget>[
              Container(
                width: 46,
                height: 46,
                decoration: BoxDecoration(
                  color: SavingorColors.lightGreen,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: const Icon(
                  Icons.checklist_rounded,
                  color: SavingorColors.primaryStroke,
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      list.title,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: SavingorColors.darkGreen,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${list.itemCount} items'
                      '${list.checkedCount > 0 ? ' · ${list.checkedCount} checked' : ''}',
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                        color: SavingorColors.textSecondary,
                      ),
                    ),
                    if (list.estimatedTotal != null) ...<Widget>[
                      const SizedBox(height: 4),
                      Text(
                        'Est. \$${list.estimatedTotal!.toStringAsFixed(2)}',
                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: SavingorColors.darkGreen,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              IconButton(
                icon: const Icon(Icons.delete_outline_rounded),
                color: SavingorColors.textSecondary,
                onPressed: onDelete,
              ),
              const Icon(
                Icons.chevron_right_rounded,
                color: SavingorColors.textSecondary,
              ),
            ],
          ),
        ),
      ),
    ),
    );
  }
}
