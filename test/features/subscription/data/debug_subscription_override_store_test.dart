import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:savingor_app/features/subscription/data/debug_subscription_override_store.dart';
import 'package:savingor_app/features/subscription/domain/debug_subscription_override.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('DebugSubscriptionOverrideStore', () {
    late SharedPreferences prefs;
    late DebugSubscriptionOverrideStore store;

    setUp(() async {
      SharedPreferences.setMockInitialValues(<String, Object>{});
      prefs = await SharedPreferences.getInstance();
      store = DebugSubscriptionOverrideStore(prefs);
      store.hydrateFromDisk();
    });

    test('defaults to none override', () {
      expect(store.override, DebugSubscriptionOverride.none);
      expect(store.isOverrideActive, isFalse);
    });

    test('Free override persists locally without touching other keys',
        () async {
      var notified = false;
      store.addListener(() => notified = true);

      await store.setOverride(DebugSubscriptionOverride.free);

      expect(store.override, DebugSubscriptionOverride.free);
      expect(store.isOverrideActive, isTrue);
      expect(
        prefs.getString(DebugSubscriptionOverrideStorage.preferenceKey),
        'free',
      );
      expect(notified, isTrue);
    });

    test('Pro override persists locally', () async {
      await store.setOverride(DebugSubscriptionOverride.pro);

      expect(store.override, DebugSubscriptionOverride.pro);
      expect(
        prefs.getString(DebugSubscriptionOverrideStorage.preferenceKey),
        'pro',
      );
    });

    test('clearing override removes preference and notifies listeners',
        () async {
      await store.setOverride(DebugSubscriptionOverride.pro);
      var notifyCount = 0;
      store.addListener(() => notifyCount++);

      await store.setOverride(DebugSubscriptionOverride.none);

      expect(store.override, DebugSubscriptionOverride.none);
      expect(prefs.containsKey(DebugSubscriptionOverrideStorage.preferenceKey),
          isFalse);
      expect(notifyCount, 1);
    });

    test('hydrates persisted override from SharedPreferences', () async {
      await prefs.setString(
        DebugSubscriptionOverrideStorage.preferenceKey,
        'pro',
      );

      final DebugSubscriptionOverrideStore reloaded =
          DebugSubscriptionOverrideStore(prefs);
      reloaded.hydrateFromDisk();

      expect(reloaded.override, DebugSubscriptionOverride.pro);
    });
  });
}
