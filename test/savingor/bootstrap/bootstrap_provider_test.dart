import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:savingor_app/core/app_state.dart';
import 'package:savingor_app/main.dart';
import 'package:savingor_app/platform_prep/navigation/module_id.dart';
import 'package:savingor_app/savingor/bootstrap/bootstrap_provider.dart';
import 'package:savingor_app/savingor/modules/groceries/groceries_module.dart';
import 'package:savingor_app/savingor/modules/module_loader.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('PlatformBootstrapProvider runtime composition', () {
    testWidgets('exposes the module loader', (WidgetTester tester) async {
      late ModuleLoader loader;

      await tester.pumpWidget(
        PlatformBootstrapProvider(
          child: Builder(
            builder: (BuildContext context) {
              loader = PlatformBootstrapProvider.of(context).moduleLoader;
              return const SizedBox.shrink();
            },
          ),
        ),
      );

      expect(loader, isNotNull);
      expect(loader.moduleCount, equals(1));
    });

    testWidgets('runtime composition sees exactly one module',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        PlatformBootstrapProvider(
          child: Builder(
            builder: (BuildContext context) {
              final ModuleLoader loader =
                  PlatformBootstrapProvider.of(context).moduleLoader;
              expect(loader.moduleCount, equals(1));
              expect(loader.modules, hasLength(1));
              return const SizedBox.shrink();
            },
          ),
        ),
      );
    });

    testWidgets('Groceries is present', (WidgetTester tester) async {
      await tester.pumpWidget(
        PlatformBootstrapProvider(
          child: Builder(
            builder: (BuildContext context) {
              final ModuleLoader loader =
                  PlatformBootstrapProvider.of(context).moduleLoader;
              assertRegisteredModulesReady(loader);
              expect(loader.contains(ModuleId('groceries')), isTrue);
              expect(loader.get(ModuleId('groceries')), same(groceriesModule));
              return const SizedBox.shrink();
            },
          ),
        ),
      );
    });

    testWidgets('MyApp still builds with bootstrap provider',
        (WidgetTester tester) async {
      SharedPreferences.setMockInitialValues(<String, Object>{});
      final AppState appState = AppState(await SharedPreferences.getInstance());
      appState.hydrateFromDisk();

      final GoRouter router = GoRouter(
        initialLocation: '/',
        routes: <RouteBase>[
          GoRoute(
            path: '/',
            builder: (BuildContext context, GoRouterState state) {
              return const SizedBox.shrink();
            },
          ),
        ],
      );

      await tester.pumpWidget(
        PlatformBootstrapProvider(
          child: AppStateProvider(
            notifier: appState,
            child: MyApp(router: router),
          ),
        ),
      );

      expect(find.byType(MyApp), findsOneWidget);
      expect(find.byType(MaterialApp), findsOneWidget);
    });
  });
}
