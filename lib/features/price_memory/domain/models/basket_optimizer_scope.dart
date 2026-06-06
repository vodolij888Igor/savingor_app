/// How the optimizer resolves shopping items before calling [BasketOptimizer].
///
/// UI/routing concern only — domain logic stays in [BasketOptimizer].
enum BasketOptimizerScope {
  /// Unchecked items from a single shopping list.
  singleList,

  /// Unchecked items merged from all active shopping lists.
  allActiveLists,
}
