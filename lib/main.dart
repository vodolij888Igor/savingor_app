import 'package:flutter/material.dart';

import 'app/router/app_router.dart';
import 'package:savingor_app/features/deals/data/favorites_store.dart';
import 'package:savingor_app/core/i18n/app_strings.dart';
import 'package:savingor_app/core/i18n/uk.dart';
import 'package:savingor_app/core/app_state.dart';

void main() {
  final favorites = FavoritesStore();
  final appState = AppState();

  runApp(
    AppStateProvider(
      notifier: appState,
      child: FavoritesProvider(
        notifier: favorites,
        child: Builder(builder: (context) {
          final state = AppStateProvider.of(context);
          final strings = (state.language == 'uk' || state.language == null) ? ukStrings : <String, String>{};
          return AppLocalizations(strings: strings, child: const MyApp());
        }),
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
      title: 'SavingGo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.teal),
        useMaterial3: true,
      ),
      routerConfig: appRouter,
    );
  }
}
