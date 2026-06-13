import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:savingor_app/core/i18n/shopping_l10n.dart';
import 'package:savingor_app/core/theme/savingor_design_system.dart';
import 'package:savingor_app/core/widgets/savingor_interactive.dart';
import 'package:savingor_app/core/widgets/app_screen_states.dart';
import 'package:savingor_app/features/shopping/data/shopping_lists_store.dart';
import 'package:savingor_app/features/shopping/domain/models/shopping_list.dart';
import 'package:savingor_app/features/price_memory/presentation/widgets/basket_optimizer_entry_card.dart';
import 'package:savingor_app/features/shopping/presentation/widgets/create_shopping_list_sheet.dart';
import 'package:savingor_app/features/shopping/presentation/widgets/shopping_list_state_panel.dart';
import 'package:savingor_app/l10n/app_localizations.dart';

class ShoppingListsScreen extends StatelessWidget {
  const ShoppingListsScreen({super.key, this.showBackButton = false});

  final bool showBackButton;

  static const Color _pageBackground = Colors.white;

  @override
  Widget build(BuildContext context) {
    final AppLocalizations l10n = AppLocalizations.of(context);
    final ShoppingListsStore store = ShoppingListsProvider.of(context);
    final double bottomInset = MediaQuery.paddingOf(context).bottom;

    return AnimatedBuilder(
      animation: store,
      builder: (BuildContext context, Widget? child) {
        if (!store.isAuthenticated) {
          return _buildSignInRequired(context, l10n);
        }

        final bool showNewListFab = !store.isLoadingLists && store.listsError == null;

        return Scaffold(
          backgroundColor: _pageBackground,
          appBar: AppBar(
            title: Text(l10n.shoppingList, style: _titleStyle),
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
            actions: <Widget>[
              if (showNewListFab)
                TextButton.icon(
                  onPressed: () => CreateShoppingListSheet.show(context),
                  icon: const Icon(
                    Icons.add_rounded,
                    color: SavingorColors.darkGreen,
                  ),
                  label: Text(
                    l10n.newList,
                    style: const TextStyle(
                      fontWeight: FontWeight.w700,
                      color: SavingorColors.darkGreen,
                    ),
                  ),
                ),
            ],
          ),
          body: _buildBody(context, store, bottomInset, l10n),
          floatingActionButton: showNewListFab
              ? FloatingActionButton.extended(
                  onPressed: () => CreateShoppingListSheet.show(context),
                  backgroundColor: SavingorColors.primaryGreen,
                  foregroundColor: SavingorColors.darkGreen,
                  icon: const Icon(Icons.playlist_add_rounded),
                  label: Text(
                    l10n.newList,
                    style: const TextStyle(fontWeight: FontWeight.w700),
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
    AppLocalizations l10n,
  ) {
    if (store.isLoadingLists) {
      return ShoppingListStatePanel.loading(
        message: l10n.loadingShoppingLists,
      );
    }

    if (store.listsError != null) {
      return ShoppingListStatePanel.error(
        title: l10n.couldNotLoadLists,
        message: ShoppingL10n.localizeListsError(context, store.listsError),
        onRetry: store.retryLists,
      );
    }

    if (store.lists.isEmpty) {
      return ShoppingListStatePanel.empty(
        icon: Icons.checklist_rounded,
        title: l10n.noShoppingListsYet,
        message: l10n.noShoppingListsYetMessage,
        actionLabel: l10n.createList,
        prominentAction: true,
        onAction: () => CreateShoppingListSheet.show(context),
      );
    }

    return ListView(
      padding: EdgeInsets.fromLTRB(20, 8, 20, 96 + bottomInset),
      children: <Widget>[
        BasketOptimizerEntryCard(
          title: l10n.optimizeAllLists,
          subtitle: l10n.optimizeAllListsSubtitle,
          onTap: () => context.push('/shopping/basket-optimizer'),
        ),
        const SizedBox(height: 16),
        ...store.lists.map(
          (ShoppingList list) => Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: _ShoppingListCard(
              list: list,
              onOpen: () => context.push('/shopping/list/${list.id}'),
              onDelete: () => _confirmDelete(context, store, list, l10n),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSignInRequired(BuildContext context, AppLocalizations l10n) {
    return Scaffold(
      backgroundColor: _pageBackground,
      appBar: AppBar(
        title: Text(l10n.shoppingList, style: _titleStyle),
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
        title: l10n.signInRequired,
        message: l10n.signInToSyncShoppingLists,
        onSignIn: () => context.push('/auth'),
        actionLabel: l10n.signIn,
      ),
    );
  }

  Future<void> _confirmDelete(
    BuildContext context,
    ShoppingListsStore store,
    ShoppingList list,
    AppLocalizations l10n,
  ) async {
    final bool? confirmed = await showDialog<bool>(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: Text(l10n.deleteListQuestion),
          content: Text(l10n.deleteListConfirmMessage(list.title)),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(false),
              child: Text(l10n.cancel),
            ),
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(true),
              child: Text(
                l10n.delete,
                style: const TextStyle(color: Color(0xFFB91C1C)),
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
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(ShoppingL10n.localizeError(context, error))),
      );
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
    final AppLocalizations l10n = AppLocalizations.of(context);

    return SavingorInteractiveCard(
      onTap: onOpen,
      borderRadius: BorderRadius.circular(18),
      accentTint: SavingorColors.primaryStroke,
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
                      '${l10n.receiptItemsCount(list.itemCount)}'
                      '${list.completedCount > 0 ? ' · ${l10n.purchasedSummary(list.completedCount)}' : ''}',
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                        color: SavingorColors.textSecondary,
                      ),
                    ),
                    if (list.estimatedTotal != null) ...<Widget>[
                      const SizedBox(height: 4),
                      Text(
                        l10n.estimatedShort(
                          '\$${list.estimatedTotal!.toStringAsFixed(2)}',
                        ),
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
    );
  }
}
