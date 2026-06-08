import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:savingor_app/core/theme/savingor_design_system.dart';
import 'package:savingor_app/core/widgets/app_screen_states.dart';
import 'package:savingor_app/features/shopping/data/shopping_lists_store.dart';
import 'package:savingor_app/features/shopping/domain/models/shopping_list.dart';
import 'package:savingor_app/features/shopping/presentation/widgets/shopping_list_state_panel.dart';

/// Picker shown from Start Saving before opening [FinalizeShoppingTripScreen].
class SelectListToFinalizeScreen extends StatelessWidget {
  const SelectListToFinalizeScreen({super.key});

  static const Color _pageBackground = Color(0xFFFFFEFE);

  Future<void> _openFinalizeTrip(
    BuildContext context,
    ShoppingList list,
  ) async {
    if (list.lastFinalizedReceiptId != null) {
      final bool? confirmed = await showDialog<bool>(
        context: context,
        builder: (BuildContext dialogContext) {
          return AlertDialog(
            title: const Text('Create another receipt?'),
            content: const Text(
              'This list may already have a receipt. Create another receipt from purchased items?',
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
      if (confirmed != true || !context.mounted) return;
    }

    context.push('/shopping/list/${list.id}/finalize-trip');
  }

  @override
  Widget build(BuildContext context) {
    final ShoppingListsStore store = ShoppingListsProvider.of(context);
    final double bottomInset = MediaQuery.paddingOf(context).bottom;

    return AnimatedBuilder(
      animation: store,
      builder: (BuildContext context, Widget? child) {
        if (!store.isAuthenticated) {
          return Scaffold(
            backgroundColor: _pageBackground,
            appBar: _buildAppBar(context),
            body: AppSignInRequiredState(
              message: 'Sign in to finalize a shopping trip.',
              onSignIn: () => context.push('/auth'),
            ),
          );
        }

        return Scaffold(
          backgroundColor: _pageBackground,
          appBar: _buildAppBar(context),
          body: _buildBody(context, store, bottomInset),
        );
      },
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return AppBar(
      toolbarHeight: 48,
      elevation: 0,
      scrolledUnderElevation: 0,
      backgroundColor: _pageBackground,
      surfaceTintColor: Colors.transparent,
      leading: IconButton(
        icon: const Icon(
          Icons.arrow_back_ios_new_rounded,
          color: SavingorColors.darkGreen,
          size: 20,
        ),
        onPressed: () => context.pop(),
      ),
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

    final List<ShoppingList> eligibleLists = store.lists
        .where((ShoppingList list) => list.completedCount > 0)
        .toList(growable: false);

    if (eligibleLists.isEmpty) {
      return ShoppingListStatePanel.empty(
        icon: Icons.task_alt_rounded,
        title: 'No lists ready to finalize',
        message:
            'Mark items as purchased on a shopping list, then return here to create a receipt.',
        actionLabel: 'Open shopping lists',
        onAction: () => context.push('/shopping'),
      );
    }

    return ListView(
      padding: EdgeInsets.fromLTRB(20, 0, 20, 32 + bottomInset + 88),
      children: <Widget>[
        const Text(
          'Select list to finalize',
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.w800,
            color: SavingorColors.darkGreen,
            height: 1.1,
            letterSpacing: -0.4,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Choose a shopping list with purchased items.',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: SavingorColors.textSecondary.withOpacity(0.95),
            height: 1.35,
          ),
        ),
        const SizedBox(height: SavingorSpacing.xl),
        ...eligibleLists.map(
          (ShoppingList list) => Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: _FinalizeListCard(
              list: list,
              onTap: () => _openFinalizeTrip(context, list),
            ),
          ),
        ),
      ],
    );
  }
}

class _FinalizeListCard extends StatelessWidget {
  const _FinalizeListCard({
    required this.list,
    required this.onTap,
  });

  final ShoppingList list;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(18),
        child: Ink(
          decoration: shoppingListCardDecoration(),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 12, 16),
            child: Row(
              children: <Widget>[
                Container(
                  width: 46,
                  height: 46,
                  decoration: BoxDecoration(
                    color: const Color(0xFF8B6BA8).withOpacity(0.12),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: const Icon(
                    Icons.task_alt_rounded,
                    color: Color(0xFF8B6BA8),
                    size: 24,
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
                          height: 1.2,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${list.completedCount} purchased'
                        '${list.itemCount > 0 ? ' · ${list.itemCount} items total' : ''}',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                          color: SavingorColors.textSecondary.withOpacity(0.95),
                          height: 1.35,
                        ),
                      ),
                    ],
                  ),
                ),
                Icon(
                  Icons.chevron_right_rounded,
                  color: SavingorColors.textSecondary.withOpacity(0.55),
                  size: 22,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
