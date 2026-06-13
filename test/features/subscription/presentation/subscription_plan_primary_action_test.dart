import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:savingor_app/core/theme/savingor_design_system.dart';
import 'package:savingor_app/features/subscription/presentation/widgets/subscription_plan_primary_action.dart';
import 'package:savingor_app/l10n/app_localizations.dart';

void main() {
  Future<void> pumpAction(
    WidgetTester tester, {
    required bool isPro,
    bool isActivating = false,
    VoidCallback? onUpgrade,
  }) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: SavingorTheme.lightTheme,
        darkTheme: SavingorTheme.darkTheme,
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        locale: const Locale('en'),
        home: Scaffold(
          body: SubscriptionPlanPrimaryAction(
            isPro: isPro,
            isActivating: isActivating,
            onUpgrade: onUpgrade ?? () {},
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  group('SubscriptionPlanPrimaryAction', () {
    testWidgets('effective free state shows upgrade CTA', (
      WidgetTester tester,
    ) async {
      var upgradeTapped = false;
      await pumpAction(
        tester,
        isPro: false,
        onUpgrade: () => upgradeTapped = true,
      );

      expect(find.text('Upgrade to Savingor Pro'), findsOneWidget);
      expect(find.text('Current plan'), findsNothing);

      await tester.tap(find.text('Upgrade to Savingor Pro'));
      await tester.pumpAndSettle();
      expect(upgradeTapped, isTrue);
    });

    testWidgets('effective pro state shows current plan without upgrade CTA', (
      WidgetTester tester,
    ) async {
      await pumpAction(tester, isPro: true);

      expect(find.text('Current plan'), findsOneWidget);
      expect(find.text('Upgrade to Savingor Pro'), findsNothing);
    });
  });
}
