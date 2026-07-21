import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'app/router/app_router.dart';
import 'package:savingor_app/core/theme/savingor_design_system.dart';
import 'package:savingor_app/features/deals/data/favorites_store.dart';
import 'package:savingor_app/core/app_state.dart';
import 'package:savingor_app/features/shopping/data/shopping_list_store.dart';
import 'package:savingor_app/features/shopping/data/shopping_lists_store.dart';
import 'package:savingor_app/features/expenses/data/expense_store.dart';
import 'package:savingor_app/features/expenses/data/expenses_store.dart';
import 'package:savingor_app/features/scanner/data/receipt_store.dart';
import 'package:savingor_app/features/scanner/presentation/smart_receipt_provider.dart';
import 'package:savingor_app/features/price_memory/data/price_memory_store.dart';
import 'package:savingor_app/features/ai_assistant/data/ai_savings_assistant_provider.dart';
import 'package:savingor_app/features/subscription/data/subscription_service.dart';
import 'package:savingor_app/features/subscription/data/debug_subscription_override_store.dart';
import 'package:savingor_app/l10n/app_localizations.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  // Safe no-op when RevenueCat keys are not supplied (local demo builds).
  final String? signedInUid = FirebaseAuth.instance.currentUser?.uid;
  if (signedInUid != null) {
    await SubscriptionService().configureRevenueCat(appUserId: signedInUid);
  }

  final prefs = await SharedPreferences.getInstance();
  final appState = AppState(prefs);
  appState.hydrateFromDisk();

  final DebugSubscriptionOverrideStore debugSubscriptionOverride =
      DebugSubscriptionOverrideStore(prefs);
  debugSubscriptionOverride.hydrateFromDisk();
  SubscriptionService.bindDebugOverrideStore(debugSubscriptionOverride);

  final favorites = FavoritesStore();
  await favorites.init();
  final shopping = ShoppingListStore();
  final shoppingLists = ShoppingListsStore();
  final expenses = ExpenseStore();
  final firestoreExpenses = ExpensesStore();
  final receipts = ReceiptStore();
  final priceMemory = PriceMemoryStore();
  final aiAssistantService = createDefaultAiSavingsAssistantService();
  final smartReceiptRepository = createDefaultSmartReceiptRepository();

  final GoRouter router = createAppRouter(appState: appState);

  runApp(
    AppStateProvider(
      notifier: appState,
      child: DebugSubscriptionOverrideProvider(
        notifier: debugSubscriptionOverride,
        child: AiSavingsAssistantProvider(
          service: aiAssistantService,
          child: SmartReceiptProvider(
            repository: smartReceiptRepository,
            child: ExpensesProvider(
              notifier: firestoreExpenses,
              child: ReceiptProvider(
                notifier: receipts,
                child: PriceMemoryProvider(
                  notifier: priceMemory,
                  child: ExpenseProvider(
                    notifier: expenses,
                    child: ShoppingListsProvider(
                      notifier: shoppingLists,
                      child: ShoppingListProvider(
                        notifier: shopping,
                        child: FavoritesProvider(
                          notifier: favorites,
                          child: MyApp(router: router),
                        ),
                      ),
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

  static const List<Locale> _supportedLocales = <Locale>[
    Locale('en'),
    Locale('uk'),
    Locale('ru'),
    Locale('fr'),
    Locale('de'),
    Locale('es'),
  ];

  @override
  Widget build(BuildContext context) {
    final AppState appState = AppStateProvider.of(context);

    return ListenableBuilder(
      listenable: appState,
      builder: (BuildContext context, Widget? child) {
        final String languageCode = appState.language ?? 'en';
        final ThemeMode themeMode =
            SavingorTheme.themeModeForAppearance(appState.appearance);
        SavingorTheme.applySystemUiOverlay(themeMode);

        return AnnotatedRegion<SystemUiOverlayStyle>(
          value: SavingorTheme.systemUiOverlayStyle(themeMode),
          child: MaterialApp.router(
            debugShowCheckedModeBanner: false,
            title: 'Savingor',
            theme: SavingorTheme.lightTheme,
            darkTheme: SavingorTheme.darkTheme,
            themeMode: themeMode,
            routerConfig: router,
            locale: Locale(languageCode),
            supportedLocales: _supportedLocales,
            localizationsDelegates: const <LocalizationsDelegate<dynamic>>[
              AppLocalizations.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            localeResolutionCallback:
                (Locale? locale, Iterable<Locale> supportedLocales) {
              if (locale == null) {
                return const Locale('en');
              }
              for (final Locale supported in supportedLocales) {
                if (supported.languageCode == locale.languageCode) {
                  return supported;
                }
              }
              return const Locale('en');
            },
          ),
        );
      },
    );
  }
}
