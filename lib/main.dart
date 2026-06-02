import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'app/router/app_router.dart';
import 'package:savingor_app/core/theme/savingor_design_system.dart';
import 'package:savingor_app/features/deals/data/favorites_store.dart';
import 'package:savingor_app/core/i18n/app_strings.dart';
import 'package:savingor_app/core/i18n/app_locale_maps.dart';
import 'package:savingor_app/core/app_state.dart';
import 'package:savingor_app/features/shopping/data/shopping_list_store.dart';
import 'package:savingor_app/features/shopping/data/shopping_lists_store.dart';
import 'package:savingor_app/features/expenses/data/expense_store.dart';
import 'package:savingor_app/features/expenses/data/expenses_store.dart';
import 'package:savingor_app/features/scanner/data/receipt_store.dart';
import 'package:savingor_app/features/ai_assistant/data/ai_savings_assistant_provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  final prefs = await SharedPreferences.getInstance();
  final appState = AppState(prefs);
  appState.hydrateFromDisk();

  final favorites = FavoritesStore();
  await favorites.init();
  final shopping = ShoppingListStore();
  final shoppingLists = ShoppingListsStore();
  final expenses = ExpenseStore();
  final firestoreExpenses = ExpensesStore();
  final receipts = ReceiptStore();
  final aiAssistantService = createDefaultAiSavingsAssistantService();

  final GoRouter router = createAppRouter(appState: appState);

  runApp(
    AppStateProvider(
      notifier: appState,
      child: AiSavingsAssistantProvider(
        service: aiAssistantService,
        child: ExpensesProvider(
          notifier: firestoreExpenses,
          child: ReceiptProvider(
            notifier: receipts,
            child: ExpenseProvider(
              notifier: expenses,
              child: ShoppingListsProvider(
                notifier: shoppingLists,
                child: ShoppingListProvider(
                  notifier: shopping,
                  child: FavoritesProvider(
                    notifier: favorites,
                    child: Builder(
                      builder: (context) {
                        final state = AppStateProvider.of(context);
                        final strings =
                            appStringsMapForLocale(state.language);
                        return AppLocalizations(
                          strings: strings,
                          child: MyApp(router: router),
                        );
                      },
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key, required this.router});

  final GoRouter router;

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      title: 'Savingor',
      theme: SavingorTheme.lightTheme,
      routerConfig: router,
    );
  }
}
