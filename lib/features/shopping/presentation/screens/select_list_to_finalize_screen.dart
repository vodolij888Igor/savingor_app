import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:savingor_app/core/i18n/shopping_l10n.dart';
import 'package:savingor_app/core/theme/savingor_design_system.dart';
import 'package:savingor_app/core/widgets/savingor_interactive.dart';
import 'package:savingor_app/core/widgets/app_screen_states.dart';
import 'package:savingor_app/features/shopping/data/shopping_lists_store.dart';
import 'package:savingor_app/features/shopping/domain/models/shopping_list.dart';
import 'package:savingor_app/features/shopping/presentation/widgets/shopping_list_state_panel.dart';
import 'package:savingor_app/l10n/app_localizations.dart';

/// Picker shown from Start Saving before opening [FinalizeShoppingTripScreen].
class SelectListToFinalizeScreen extends StatelessWidget {
  const SelectListToFinalizeScreen({super.key});
  Future<void> _openFinalizeTrip(
    BuildContext context,
    ShoppingList list,
    AppLocalizations l10n,
  ) async {
    if (list.lastFinalizedReceiptId != null) {
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
      if (confirmed != true || !context.mounted) return;
    }

    context.push('/shopping/list/${list.id}/finalize-trip');
  }

  @override
  Widget build(BuildContext context) {
    final AppLocalizations l10n = AppLocalizations.of(context);
    final ShoppingListsStore store = ShoppingListsProvider.of(context);
    final double bottomInset = MediaQuery.paddingOf(context).bottom;

    return AnimatedBuilder(
      animation: store,
      builder: (BuildContext context, Widget? child) {
        if (!store.isAuthenticated) {
          return Scaffold(
            backgroundColor: context.savingor.pageBackground,
            appBar: _buildAppBar(context),
            body: AppSignInRequiredState(
              title: l10n.signInRequired,
              message: l10n.signInToFinalizeTrip,
              onSignIn: () => context.push('/auth'),
              actionLabel: l10n.signIn,
            ),
          );
        }

        return Scaffold(
          backgroundColor: context.savingor.pageBackground,
          appBar: _buildAppBar(context),
          body: _buildBody(context, store, bottomInset, l10n),
        );
      },
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return AppBar(
      toolbarHeight: 48,
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
        onPressed: () => context.pop(),
      ),
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

    final List<ShoppingList> eligibleLists = store.lists
        .where((ShoppingList list) => list.completedCount > 0)
        .toList(growable: false);

    if (eligibleLists.isEmpty) {
      return ShoppingListStatePanel.empty(
        icon: Icons.task_alt_rounded,
        title: l10n.noListsReadyToFinalize,
        message: l10n.noListsReadyToFinalizeMessage,
        actionLabel: l10n.openShoppingLists,
        onAction: () => context.push('/shopping'),
      );
    }

    return ListView(
      padding: EdgeInsets.fromLTRB(20, 0, 20, 32 + bottomInset + 88),
      children: <Widget>[
        Text(
          l10n.selectListToFinalize,
          style: SavingorAppTextStyles.pageTitle(context).copyWith(
            color: SavingorWorkflowTheme.primaryText(context),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          l10n.selectListToFinalizeSubtitle,
          style: SavingorAppTextStyles.bodySecondary(context, fontSize: 16),
        ),
        const SizedBox(height: SavingorSpacing.xl),
        ...eligibleLists.map(
          (ShoppingList list) => Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: _FinalizeListCard(
              list: list,
              onTap: () => _openFinalizeTrip(context, list, l10n),
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
    final AppLocalizations l10n = AppLocalizations.of(context);

    return SavingorInteractiveCard(
      onTap: onTap,
      borderRadius: BorderRadius.circular(18),
      accentTint: const Color(0xFF8B6BA8),
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
                    ShoppingL10n.localizedShoppingListName(
                      context,
                      list.title,
                    ),
                    style: SavingorAppTextStyles.cardTitle(context).copyWith(
                      color: SavingorWorkflowTheme.primaryText(context),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    list.itemCount > 0
                        ? l10n.listFinalizeProgressSummary(
                            list.completedCount,
                            list.itemCount,
                          )
                        : l10n.purchasedSummary(list.completedCount),
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                      color: context.savingor.textSecondary.withOpacity(0.95),
                      height: 1.35,
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.chevron_right_rounded,
              color: context.savingor.textSecondary.withOpacity(0.55),
              size: 22,
            ),
          ],
        ),
      ),
    );
  }
}
