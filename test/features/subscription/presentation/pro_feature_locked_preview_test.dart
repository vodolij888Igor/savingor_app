import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:savingor_app/core/theme/savingor_design_system.dart';
import 'package:savingor_app/features/subscription/domain/savingor_feature.dart';
import 'package:savingor_app/features/subscription/presentation/widgets/pro_feature_locked_preview.dart';
import 'package:savingor_app/l10n/app_localizations.dart';

void main() {
  Future<void> pumpLockedPreview(
    WidgetTester tester, {
    required SavingorFeature feature,
    VoidCallback? onOpenPlans,
  }) async {
    final GoRouter router = GoRouter(
      routes: <RouteBase>[
        GoRoute(
          path: '/',
          builder: (BuildContext context, GoRouterState state) {
            return Scaffold(
              body: ProFeatureLockedPreview(
                feature: feature,
                bottomInset: 0,
                onOpenPlans: onOpenPlans,
              ),
            );
          },
        ),
        GoRoute(
          path: '/subscription',
          builder: (BuildContext context, GoRouterState state) {
            return const Scaffold(body: Text('subscription-screen'));
          },
        ),
      ],
    );

    await tester.pumpWidget(
      MaterialApp.router(
        theme: SavingorTheme.lightTheme,
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        locale: const Locale('en'),
        routerConfig: router,
      ),
    );
    await tester.pumpAndSettle();
  }

  group('ProFeatureLockedPreview', () {
    testWidgets('shows unlock CTA for basket optimizer', (
      WidgetTester tester,
    ) async {
      await pumpLockedPreview(
        tester,
        feature: SavingorFeature.basketOptimizer,
      );

      expect(find.text('Unlock with Savingor Pro'), findsOneWidget);
      expect(find.text('View Pro benefits'), findsOneWidget);
      expect(find.text('Pro'), findsWidgets);
    });

    testWidgets('primary CTA navigates to subscription route', (
      WidgetTester tester,
    ) async {
      await pumpLockedPreview(
        tester,
        feature: SavingorFeature.basketOptimizer,
      );

      await tester.tap(find.text('Unlock with Savingor Pro'));
      await tester.pumpAndSettle();

      expect(find.text('subscription-screen'), findsOneWidget);
    });

    testWidgets('secondary CTA navigates to subscription route', (
      WidgetTester tester,
    ) async {
      await pumpLockedPreview(
        tester,
        feature: SavingorFeature.savingsAnalytics,
      );

      await tester.tap(find.text('View Pro benefits'));
      await tester.pumpAndSettle();

      expect(find.text('subscription-screen'), findsOneWidget);
    });

    testWidgets('uses onOpenPlans callback when provided', (
      WidgetTester tester,
    ) async {
      var plansOpened = false;

      await pumpLockedPreview(
        tester,
        feature: SavingorFeature.advancedPriceIntelligence,
        onOpenPlans: () => plansOpened = true,
      );

      await tester.tap(find.text('Unlock with Savingor Pro'));
      await tester.pump();

      expect(plansOpened, isTrue);
      expect(find.text('subscription-screen'), findsNothing);
    });
  });
}
