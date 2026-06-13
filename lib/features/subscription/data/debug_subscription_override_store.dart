import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:savingor_app/features/subscription/domain/debug_subscription_override.dart';

/// Persists a local debug subscription override (SharedPreferences only).
///
/// In release builds [override] is always [DebugSubscriptionOverride.none] and
/// [setOverride] is a no-op.
class DebugSubscriptionOverrideStore extends ChangeNotifier {
  DebugSubscriptionOverrideStore(this._prefs);

  final SharedPreferences _prefs;

  DebugSubscriptionOverride _override = DebugSubscriptionOverride.none;

  /// Active debug override, or [DebugSubscriptionOverride.none] in release.
  DebugSubscriptionOverride get override {
    if (!kDebugMode) {
      return DebugSubscriptionOverride.none;
    }
    return _override;
  }

  bool get isOverrideActive =>
      kDebugMode && _override != DebugSubscriptionOverride.none;

  void hydrateFromDisk() {
    if (!kDebugMode) {
      _override = DebugSubscriptionOverride.none;
      return;
    }
    _override = DebugSubscriptionOverrideStorage.fromStorage(
      _prefs.getString(DebugSubscriptionOverrideStorage.preferenceKey),
    );
  }

  Future<void> setOverride(DebugSubscriptionOverride value) async {
    if (!kDebugMode) {
      return;
    }

    _override = value;
    if (value == DebugSubscriptionOverride.none) {
      await _prefs.remove(DebugSubscriptionOverrideStorage.preferenceKey);
    } else {
      await _prefs.setString(
        DebugSubscriptionOverrideStorage.preferenceKey,
        value.storageValue,
      );
    }
    notifyListeners();
  }
}

class DebugSubscriptionOverrideProvider
    extends InheritedNotifier<DebugSubscriptionOverrideStore> {
  const DebugSubscriptionOverrideProvider({
    super.key,
    required DebugSubscriptionOverrideStore notifier,
    required super.child,
  }) : super(notifier: notifier);

  static DebugSubscriptionOverrideStore of(BuildContext context) {
    final DebugSubscriptionOverrideProvider? provider =
        context.dependOnInheritedWidgetOfExactType<
            DebugSubscriptionOverrideProvider>();
    assert(
      provider != null,
      'DebugSubscriptionOverrideProvider not found in widget tree',
    );
    return provider!.notifier!;
  }

  static DebugSubscriptionOverrideStore? maybeOf(BuildContext context) {
    return context
        .dependOnInheritedWidgetOfExactType<DebugSubscriptionOverrideProvider>()
        ?.notifier;
  }
}
