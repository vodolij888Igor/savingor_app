import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:savingor_app/features/subscription/domain/savingor_feature.dart';
import 'package:savingor_app/features/subscription/presentation/widgets/feature_access_gate.dart';

void main() {
  group('FeatureAccessGate', () {
    testWidgets('shows lockedBuilder for Free users on basket optimizer', (
      WidgetTester tester,
    ) async {
      var proContentBuilt = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: FeatureAccessGate(
              feature: SavingorFeature.basketOptimizer,
              isPro: false,
              lockedBuilder: (_) => const Text('locked-preview'),
              child: Builder(
                builder: (_) {
                  proContentBuilt = true;
                  return const Text('pro-content');
                },
              ),
            ),
          ),
        ),
      );

      expect(find.text('locked-preview'), findsOneWidget);
      expect(find.text('pro-content'), findsNothing);
      expect(proContentBuilt, isFalse);
    });

    testWidgets('shows child for Pro users on basket optimizer', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: FeatureAccessGate(
              feature: SavingorFeature.basketOptimizer,
              isPro: true,
              lockedBuilder: (_) => const Text('locked-preview'),
              child: const Text('pro-content'),
            ),
          ),
        ),
      );

      expect(find.text('pro-content'), findsOneWidget);
      expect(find.text('locked-preview'), findsNothing);
    });

    testWidgets('allows Free users on basic savingsOpportunities', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: FeatureAccessGate(
              feature: SavingorFeature.savingsOpportunities,
              isPro: false,
              lockedBuilder: (_) => const Text('locked-preview'),
              child: const Text('basic-content'),
            ),
          ),
        ),
      );

      expect(find.text('basic-content'), findsOneWidget);
      expect(find.text('locked-preview'), findsNothing);
    });

    testWidgets('allows Free users on basic productPriceInsights', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: FeatureAccessGate(
              feature: SavingorFeature.productPriceInsights,
              isPro: false,
              lockedBuilder: (_) => const Text('locked-preview'),
              child: const Text('basic-content'),
            ),
          ),
        ),
      );

      expect(find.text('basic-content'), findsOneWidget);
      expect(find.text('locked-preview'), findsNothing);
    });

    testWidgets('protects Pro-only premium features for Free users', (
      WidgetTester tester,
    ) async {
      for (final SavingorFeature feature in <SavingorFeature>[
        SavingorFeature.basketOptimizer,
        SavingorFeature.savingsAnalytics,
        SavingorFeature.aiSavingsAssistant,
      ]) {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: FeatureAccessGate(
                feature: feature,
                isPro: false,
                lockedBuilder: (_) => Text('locked-$feature'),
                child: Text('pro-$feature'),
              ),
            ),
          ),
        );

        expect(find.text('locked-$feature'), findsOneWidget);
        expect(find.text('pro-$feature'), findsNothing);
      }
    });

    testWidgets('allows Pro-only premium features for Pro users', (
      WidgetTester tester,
    ) async {
      for (final SavingorFeature feature in <SavingorFeature>[
        SavingorFeature.basketOptimizer,
        SavingorFeature.savingsAnalytics,
        SavingorFeature.aiSavingsAssistant,
      ]) {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: FeatureAccessGate(
                feature: feature,
                isPro: true,
                lockedBuilder: (_) => Text('locked-$feature'),
                child: Text('pro-$feature'),
              ),
            ),
          ),
        );

        expect(find.text('pro-$feature'), findsOneWidget);
        expect(find.text('locked-$feature'), findsNothing);
      }
    });
  });
}
