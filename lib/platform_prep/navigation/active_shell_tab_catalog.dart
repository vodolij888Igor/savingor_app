import 'package:savingor_app/platform_prep/modules/active_module_set.dart';
import 'package:savingor_app/platform_prep/navigation/app_module.dart';
import 'package:savingor_app/platform_prep/navigation/shell_tab_contribution.dart';

/// Collects [ShellTabContribution] metadata from active modules only.
///
/// Tabs are ordered by [ShellTabContribution.sortOrder] ascending. Equal
/// sort orders preserve active-module and declaration order.
/// Does not build UI or change runtime navigation.
class ActiveShellTabCatalog {
  /// Creates a catalog from [activeModules].
  ///
  /// Throws [StateError] when shell tab stable keys collide across modules.
  ActiveShellTabCatalog(ActiveModuleSet activeModules)
      : _tabs = List<ShellTabContribution>.unmodifiable(
          _collectValidateAndSort(activeModules),
        );

  final List<ShellTabContribution> _tabs;

  /// Shell tab contributions from active modules (unmodifiable).
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
    ActiveModuleSet activeModules,
  ) {
    final List<_IndexedTab> indexed = <_IndexedTab>[];
    final Set<String> keys = <String>{};
    int sequence = 0;

    for (final AppModule module in activeModules.modules) {
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
