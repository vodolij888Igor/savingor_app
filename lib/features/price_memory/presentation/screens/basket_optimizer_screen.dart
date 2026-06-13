import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:savingor_app/core/theme/savingor_design_system.dart';
import 'package:savingor_app/core/widgets/app_screen_states.dart';
import 'package:savingor_app/features/price_memory/data/price_memory_store.dart';
import 'package:savingor_app/features/price_memory/domain/basket_optimizer.dart';
import 'package:savingor_app/features/price_memory/domain/models/basket_optimization_result.dart';
import 'package:savingor_app/features/price_memory/domain/models/basket_optimizer_scope.dart';
import 'package:savingor_app/features/price_memory/presentation/widgets/basket_recommendation_card.dart';
import 'package:savingor_app/features/price_memory/presentation/widgets/basket_store_plan_section.dart';
import 'package:savingor_app/features/price_memory/presentation/widgets/basket_summary_card.dart';
import 'package:savingor_app/features/shopping/data/shopping_lists_store.dart';
import 'package:savingor_app/features/shopping/domain/models/global_shopping_items_snapshot.dart';
import 'package:savingor_app/features/shopping/domain/models/shopping_list_item.dart';
import 'package:savingor_app/l10n/app_localizations.dart';

/// Smart basket optimizer screen.
///
/// Pass [listId] for a single-list run; omit it for all active lists.
/// Resolves items, then delegates to [BasketOptimizer] with items + price records.
class BasketOptimizerScreen extends StatefulWidget {
  const BasketOptimizerScreen({super.key, this.listId});

  final String? listId;

  BasketOptimizerScope get scope =>
      listId != null && listId!.isNotEmpty
          ? BasketOptimizerScope.singleList
          : BasketOptimizerScope.allActiveLists;

  bool get isGlobalScope => scope == BasketOptimizerScope.allActiveLists;

  @override
  State<BasketOptimizerScreen> createState() => _BasketOptimizerScreenState();
}

class _BasketOptimizerScreenState extends State<BasketOptimizerScreen> {
  static const Color _pageBackground = Colors.white;

  List<ShoppingListItem>? _shoppingItems;
  int? _activeListsIncluded;
  bool _isLoadingItems = true;
  String? _itemsError;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _loadShoppingItems());
  }

  Future<void> _loadShoppingItems() async {
    if (!mounted) return;

    final ShoppingListsStore shoppingStore = ShoppingListsProvider.of(context);

    if (!shoppingStore.isAuthenticated) {
      setState(() {
        _isLoadingItems = false;
        _shoppingItems = const <ShoppingListItem>[];
        _activeListsIncluded = null;
      });
      return;
    }

    setState(() {
      _isLoadingItems = true;
      _itemsError = null;
    });

    try {
      final List<ShoppingListItem> items;
      final String? listId = widget.listId;

      if (widget.isGlobalScope) {
        final GlobalShoppingItemsSnapshot snapshot =
            await shoppingStore.fetchGlobalShoppingItemsSnapshot();
        items = snapshot.uncheckedItems;
        if (!mounted) return;
        setState(() {
          _shoppingItems = items;
          _activeListsIncluded = snapshot.activeListsIncluded;
          _isLoadingItems = false;
        });
        return;
      }

      _activeListsIncluded = null;
      if (listId != null &&
          listId.isNotEmpty &&
          shoppingStore.activeListId == listId) {
        items = shoppingStore.items
            .where((ShoppingListItem item) => item.isActive)
            .toList(growable: false);
      } else if (listId != null && listId.isNotEmpty) {
        items = await shoppingStore.fetchUncheckedItemsForList(listId);
      } else {
        items = const <ShoppingListItem>[];
      }

      if (!mounted) return;
      setState(() {
        _shoppingItems = items;
        _isLoadingItems = false;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _itemsError = AppLocalizations.of(context).couldNotLoadListItems;
        _isLoadingItems = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final AppLocalizations l10n = AppLocalizations.of(context);
    final PriceMemoryStore priceStore = PriceMemoryProvider.of(context);
    final double bottomInset = MediaQuery.paddingOf(context).bottom;
    final String screenTitle = widget.isGlobalScope
        ? l10n.optimizeAllLists
        : l10n.optimizeThisBasket;

    return AnimatedBuilder(
      animation: priceStore,
      builder: (BuildContext context, Widget? _) {
        return Scaffold(
          backgroundColor: _pageBackground,
          appBar: AppBar(
            title: Text(
              screenTitle,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w800,
                color: SavingorColors.darkGreen,
              ),
            ),
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
          ),
          body: _buildBody(context, priceStore, bottomInset, l10n),
        );
      },
    );
  }

  Widget _buildBody(
    BuildContext context,
    PriceMemoryStore priceStore,
    double bottomInset,
    AppLocalizations l10n,
  ) {
    if (!priceStore.isAuthenticated) {
      return AppSignInRequiredState(
        message: widget.isGlobalScope
            ? l10n.signInToOptimizeAllLists
            : l10n.signInToOptimizeBasket,
        onSignIn: () => context.push('/auth'),
      );
    }

    if (_isLoadingItems || priceStore.isLoading) {
      return AppLoadingState(
        message: widget.isGlobalScope
            ? l10n.loadingAllActiveLists
            : l10n.loadingBasketOptimizer,
      );
    }

    if (_itemsError != null) {
      return AppErrorState(
        title: l10n.couldNotLoadShoppingList,
        message: _itemsError!,
        onRetry: _loadShoppingItems,
      );
    }

    if (priceStore.loadError != null) {
      return AppErrorState(
        title: l10n.couldNotLoadPriceHistory,
        message: priceStore.loadError!,
        onRetry: priceStore.retry,
      );
    }

    final List<ShoppingListItem> items =
        _shoppingItems ?? const <ShoppingListItem>[];

    if (items.isEmpty) {
      if (widget.isGlobalScope) {
        return AppEmptyState(
          icon: Icons.shopping_basket_outlined,
          title: l10n.noActiveItemsToOptimize,
          message: l10n.noActiveItemsToOptimizeMessage,
          actionLabel: l10n.backToShopping,
          prominentAction: true,
          onAction: () => context.pop(),
        );
      }

      return AppEmptyState(
        icon: Icons.shopping_basket_outlined,
        title: l10n.addItemsToListForOptimizer,
        message: l10n.addItemsToListForOptimizerMessage,
        actionLabel: l10n.backToList,
        prominentAction: true,
        onAction: () => context.pop(),
      );
    }

    final BasketOptimizationResult result = BasketOptimizer.optimize(
      shoppingItems: items,
      priceRecords: priceStore.records,
      activeListsIncluded: _activeListsIncluded,
    );

    if (!result.hasAnyPriceData) {
      return AppEmptyState(
        icon: Icons.receipt_long_outlined,
        title: l10n.noPriceHistoryYet,
        message: l10n.noPriceHistoryForOptimizerMessage,
        actionLabel: l10n.addReceipt,
        prominentAction: true,
        onAction: () => context.push('/scanner/create'),
      );
    }

    return ListView(
      padding: EdgeInsets.fromLTRB(20, 8, 20, 24 + bottomInset),
      children: <Widget>[
        BasketSummaryCard(result: result),
        const SizedBox(height: SavingorSpacing.xl),
        Text(
          l10n.itemRecommendations,
          style: const TextStyle(
            fontSize: 17,
            fontWeight: FontWeight.w700,
            color: SavingorColors.darkGreen,
          ),
        ),
        const SizedBox(height: 12),
        ...result.recommendations.map(
          (recommendation) => Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: BasketRecommendationCard(recommendation: recommendation),
          ),
        ),
        if (result.storePlan.isNotEmpty) ...<Widget>[
          const SizedBox(height: SavingorSpacing.md),
          BasketStorePlanSection(
            storePlan: result.storePlan,
            currency: result.currency,
          ),
        ],
      ],
    );
  }
}
