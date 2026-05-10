import 'package:flutter/material.dart';

import 'app/router/app_router.dart';
import 'package:savingor_app/core/theme/savingor_design_system.dart';
import 'package:savingor_app/features/deals/data/favorites_store.dart';
import 'package:savingor_app/core/i18n/app_strings.dart';
import 'package:savingor_app/core/i18n/uk.dart';
import 'package:savingor_app/core/app_state.dart';
import 'package:savingor_app/features/shopping/data/shopping_list_store.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final favorites = FavoritesStore();
  await favorites.init();
  final appState = AppState();
  final shopping = ShoppingListStore();

  runApp(
    AppStateProvider(
      notifier: appState,
      child: ShoppingListProvider(
        notifier: shopping,
        child: FavoritesProvider(
          notifier: favorites,
          child: Builder(builder: (context) {
            final state = AppStateProvider.of(context);
            final strings = (state.language == 'uk' || state.language == null)
                ? ukStrings
                : <String, String>{};
            return AppLocalizations(strings: strings, child: const MyApp());
          }),
        ),
      ),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      title: 'Savingor',
      theme: SavingorTheme.lightTheme,
      routerConfig: appRouter,
    );
  }
}
