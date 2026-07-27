import 'package:flutter_test/flutter_test.dart';
import 'package:savingor_app/savingor/modules/groceries/groceries_flags.dart';
import 'package:savingor_app/savingor/modules/groceries/groceries_module.dart';

void main() {
  group('GroceriesModule', () {
    test('module id is groceries', () {
      expect(groceriesModule.id.value, equals('groceries'));
    });

    test('feature flag key is vertical.groceries.enabled', () {
      expect(
        GroceriesFlags.verticalEnabled.value,
        equals('vertical.groceries.enabled'),
      );
    });

    test('route metadata exists for core grocery paths', () {
      expect(groceriesModule.routeContributions, isNotEmpty);

      final Set<String> paths =
          groceriesModule.routeContributions.map((route) => route.path).toSet();

      expect(paths, contains('/deals'));
      expect(paths, contains('/scanner'));
      expect(paths, contains('/nearby-stores'));
      expect(paths, contains('/shopping'));
      expect(paths, contains('/ai-assistant'));
      expect(paths, contains('/profile'));
    });

    test('shell tabs describe the five grocery main tabs', () {
      expect(groceriesModule.shellTabs, hasLength(5));

      expect(
        groceriesModule.shellTabs.map((tab) => tab.key).toList(),
        <String>[
          'home',
          'nearby-stores',
          'scanner',
          'ai-assistant',
          'profile',
        ],
      );
      expect(
        groceriesModule.shellTabs.map((tab) => tab.routePath).toList(),
        <String>[
          '/deals',
          '/nearby-stores',
          '/scanner',
          '/ai-assistant',
          '/profile',
        ],
      );
      expect(
        groceriesModule.shellTabs.map((tab) => tab.sortOrder).toList(),
        <int>[0, 1, 2, 3, 4],
      );
    });

    test('module collections are immutable', () {
      expect(
        () => groceriesModule.routeContributions.add(
          groceriesModule.routeContributions.first,
        ),
        throwsUnsupportedError,
      );
      expect(
        () => groceriesModule.shellTabs.add(groceriesModule.shellTabs.first),
        throwsUnsupportedError,
      );
    });
  });
}
