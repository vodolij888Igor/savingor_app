import 'package:savingor_app/platform_prep/navigation/app_module.dart';
import 'package:savingor_app/platform_prep/navigation/shell_tab_contribution.dart';
import 'package:savingor_app/savingor/modules/module_loader.dart';

/// Collects [ShellTabContribution] metadata from every registered module.
///
/// Tabs are ordered by [ShellTabContribution.sortOrder] ascending. Equal
/// sort orders preserve module registration and declaration order.
/// Does not build UI, evaluate feature flags, or change runtime navigation.
class ShellTabCatalog {
  /// Creates a catalog from [loader].
  ///
  /// Throws [StateError] when shell tab stable keys collide across modules.
  ShellTabCatalog(ModuleLoader loader)
      : _tabs = List<ShellTabContribution>.unmodifiable(
          _collectValidateAndSort(loader),
        );

  final List<ShellTabContribution> _tabs;

  /// Shell tab contributions in sorted order (unmodifiable).
  List<ShellTabContribution> get tabs => _tabs;

  /// Number of collected shell tabs.
  int get tabCount => _tabs.length;

  /// Whether any contribution uses [stableKey].
  bool containsStableKey(String stableKey) {
    return findByStableKey(stableKey) != null;
  }

  /// Returns the tab with [stableKey], or `null` if none is present.
  ShellTabContribution? findByStableKey(String stableKey) {
    for (final ShellTabContribution tab in _tabs) {
      if (tab.key == stableKey) {
        return tab;
      }
    }
    return null;
  }

  static List<ShellTabContribution> _collectValidateAndSort(
    ModuleLoader loader,
  ) {
    final List<_IndexedTab> indexed = <_IndexedTab>[];
    final Set<String> keys = <String>{};
    int sequence = 0;

    for (final AppModule module in loader.modules) {
      for (final ShellTabContribution tab in module.shellTabs) {
        if (!keys.add(tab.key)) {
          throw StateError('Duplicate shell tab key: "${tab.key}"');
        }
        indexed.add(_IndexedTab(tab: tab, sequence: sequence));
        sequence += 1;
      }
    }

    indexed.sort((_IndexedTab a, _IndexedTab b) {
      final int byOrder = a.tab.sortOrder.compareTo(b.tab.sortOrder);
      if (byOrder != 0) {
        return byOrder;
      }
      return a.sequence.compareTo(b.sequence);
    });

    return indexed.map((_IndexedTab item) => item.tab).toList(growable: false);
  }
}

class _IndexedTab {
  const _IndexedTab({required this.tab, required this.sequence});

  final ShellTabContribution tab;
  final int sequence;
}
