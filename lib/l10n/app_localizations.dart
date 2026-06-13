import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_de.dart';
import 'app_localizations_en.dart';
import 'app_localizations_es.dart';
import 'app_localizations_fr.dart';
import 'app_localizations_ru.dart';
import 'app_localizations_uk.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
      : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('de'),
    Locale('en'),
    Locale('es'),
    Locale('fr'),
    Locale('ru'),
    Locale('uk')
  ];

  /// No description provided for @appName.
  ///
  /// In en, this message translates to:
  /// **'Savingor'**
  String get appName;

  /// No description provided for @appSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Local offers and smart savings'**
  String get appSubtitle;

  /// No description provided for @home.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get home;

  /// No description provided for @deals.
  ///
  /// In en, this message translates to:
  /// **'Deals'**
  String get deals;

  /// No description provided for @receipts.
  ///
  /// In en, this message translates to:
  /// **'Receipts'**
  String get receipts;

  /// No description provided for @analytics.
  ///
  /// In en, this message translates to:
  /// **'Analytics'**
  String get analytics;

  /// No description provided for @profile.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get profile;

  /// No description provided for @scanner.
  ///
  /// In en, this message translates to:
  /// **'Receipt scanner'**
  String get scanner;

  /// No description provided for @shopping.
  ///
  /// In en, this message translates to:
  /// **'Shopping list'**
  String get shopping;

  /// No description provided for @saved.
  ///
  /// In en, this message translates to:
  /// **'Saved'**
  String get saved;

  /// No description provided for @storesMap.
  ///
  /// In en, this message translates to:
  /// **'Map'**
  String get storesMap;

  /// No description provided for @aiAssistant.
  ///
  /// In en, this message translates to:
  /// **'AI'**
  String get aiAssistant;

  /// No description provided for @scanReceipt.
  ///
  /// In en, this message translates to:
  /// **'Scan receipt'**
  String get scanReceipt;

  /// No description provided for @dealsMap.
  ///
  /// In en, this message translates to:
  /// **'Deals map'**
  String get dealsMap;

  /// No description provided for @receiptScanner.
  ///
  /// In en, this message translates to:
  /// **'Receipt scanner'**
  String get receiptScanner;

  /// No description provided for @shoppingList.
  ///
  /// In en, this message translates to:
  /// **'Shopping list'**
  String get shoppingList;

  /// No description provided for @mvp.
  ///
  /// In en, this message translates to:
  /// **'MVP v0.1'**
  String get mvp;

  /// No description provided for @searchHint.
  ///
  /// In en, this message translates to:
  /// **'Search deals or stores...'**
  String get searchHint;

  /// No description provided for @filter.
  ///
  /// In en, this message translates to:
  /// **'Filter'**
  String get filter;

  /// No description provided for @dealsMapSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Shows nearby deals'**
  String get dealsMapSubtitle;

  /// No description provided for @receiptScannerSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Scan a receipt'**
  String get receiptScannerSubtitle;

  /// No description provided for @shoppingListSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Smart list'**
  String get shoppingListSubtitle;

  /// No description provided for @dealsCount.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 deal} other{{count} deals}}'**
  String dealsCount(int count);

  /// No description provided for @noDealsFound.
  ///
  /// In en, this message translates to:
  /// **'No deals found'**
  String get noDealsFound;

  /// No description provided for @resetFilters.
  ///
  /// In en, this message translates to:
  /// **'Reset filters'**
  String get resetFilters;

  /// No description provided for @filtersTitle.
  ///
  /// In en, this message translates to:
  /// **'Filters'**
  String get filtersTitle;

  /// No description provided for @stores.
  ///
  /// In en, this message translates to:
  /// **'Stores'**
  String get stores;

  /// No description provided for @maxPrice.
  ///
  /// In en, this message translates to:
  /// **'Max price'**
  String get maxPrice;

  /// No description provided for @sort.
  ///
  /// In en, this message translates to:
  /// **'Sort'**
  String get sort;

  /// No description provided for @none.
  ///
  /// In en, this message translates to:
  /// **'None'**
  String get none;

  /// No description provided for @priceLowHigh.
  ///
  /// In en, this message translates to:
  /// **'Price: low to high'**
  String get priceLowHigh;

  /// No description provided for @priceHighLow.
  ///
  /// In en, this message translates to:
  /// **'Price: high to low'**
  String get priceHighLow;

  /// No description provided for @dealDetails.
  ///
  /// In en, this message translates to:
  /// **'Deal details'**
  String get dealDetails;

  /// No description provided for @dealNotFound.
  ///
  /// In en, this message translates to:
  /// **'Deal not found'**
  String get dealNotFound;

  /// No description provided for @saveDeal.
  ///
  /// In en, this message translates to:
  /// **'Save deal'**
  String get saveDeal;

  /// No description provided for @removeSaved.
  ///
  /// In en, this message translates to:
  /// **'Remove saved'**
  String get removeSaved;

  /// No description provided for @noSavedDeals.
  ///
  /// In en, this message translates to:
  /// **'No saved deals yet'**
  String get noSavedDeals;

  /// No description provided for @savedHint.
  ///
  /// In en, this message translates to:
  /// **'Saved deals will appear here'**
  String get savedHint;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @apply.
  ///
  /// In en, this message translates to:
  /// **'Apply'**
  String get apply;

  /// No description provided for @save.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get save;

  /// No description provided for @back.
  ///
  /// In en, this message translates to:
  /// **'Back'**
  String get back;

  /// No description provided for @close.
  ///
  /// In en, this message translates to:
  /// **'Close'**
  String get close;

  /// No description provided for @signOut.
  ///
  /// In en, this message translates to:
  /// **'Sign out'**
  String get signOut;

  /// No description provided for @loading.
  ///
  /// In en, this message translates to:
  /// **'Loading...'**
  String get loading;

  /// No description provided for @tryAgain.
  ///
  /// In en, this message translates to:
  /// **'Try again'**
  String get tryAgain;

  /// No description provided for @comingSoon.
  ///
  /// In en, this message translates to:
  /// **'Coming soon'**
  String get comingSoon;

  /// No description provided for @continueButton.
  ///
  /// In en, this message translates to:
  /// **'Continue'**
  String get continueButton;

  /// No description provided for @edit.
  ///
  /// In en, this message translates to:
  /// **'Edit'**
  String get edit;

  /// No description provided for @ok.
  ///
  /// In en, this message translates to:
  /// **'OK'**
  String get ok;

  /// No description provided for @chooseYourLanguage.
  ///
  /// In en, this message translates to:
  /// **'Choose your language'**
  String get chooseYourLanguage;

  /// No description provided for @chooseLanguageSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Select the language you want Savingor to use.'**
  String get chooseLanguageSubtitle;

  /// No description provided for @langSubtitleOnboarding.
  ///
  /// In en, this message translates to:
  /// **'This helps personalize your Savingor experience.'**
  String get langSubtitleOnboarding;

  /// No description provided for @applyLanguage.
  ///
  /// In en, this message translates to:
  /// **'Apply language'**
  String get applyLanguage;

  /// No description provided for @welcomeBackName.
  ///
  /// In en, this message translates to:
  /// **'Welcome back, {name}! 👋'**
  String welcomeBackName(String name);

  /// No description provided for @welcomeBack.
  ///
  /// In en, this message translates to:
  /// **'Welcome back! 👋'**
  String get welcomeBack;

  /// No description provided for @readyToSaveSmarterToday.
  ///
  /// In en, this message translates to:
  /// **'Ready to save smarter today?'**
  String get readyToSaveSmarterToday;

  /// No description provided for @totalExpenses.
  ///
  /// In en, this message translates to:
  /// **'Total expenses'**
  String get totalExpenses;

  /// No description provided for @trackedInSavingor.
  ///
  /// In en, this message translates to:
  /// **'Tracked in Savingor'**
  String get trackedInSavingor;

  /// No description provided for @expensesTracked.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 expense tracked} other{{count} expenses tracked}}'**
  String expensesTracked(int count);

  /// No description provided for @startSaving.
  ///
  /// In en, this message translates to:
  /// **'Start saving'**
  String get startSaving;

  /// No description provided for @startSavingHero.
  ///
  /// In en, this message translates to:
  /// **'✨ START SAVING'**
  String get startSavingHero;

  /// No description provided for @thisMonth.
  ///
  /// In en, this message translates to:
  /// **'This month'**
  String get thisMonth;

  /// No description provided for @spent.
  ///
  /// In en, this message translates to:
  /// **'spent'**
  String get spent;

  /// No description provided for @recorded.
  ///
  /// In en, this message translates to:
  /// **'recorded'**
  String get recorded;

  /// No description provided for @lists.
  ///
  /// In en, this message translates to:
  /// **'lists'**
  String get lists;

  /// No description provided for @activeDeals.
  ///
  /// In en, this message translates to:
  /// **'Active deals'**
  String get activeDeals;

  /// No description provided for @estimated.
  ///
  /// In en, this message translates to:
  /// **'estimated'**
  String get estimated;

  /// No description provided for @monthlyGoal.
  ///
  /// In en, this message translates to:
  /// **'Monthly goal'**
  String get monthlyGoal;

  /// No description provided for @noRecentActivity.
  ///
  /// In en, this message translates to:
  /// **'No recent activity'**
  String get noRecentActivity;

  /// No description provided for @expenseAdded.
  ///
  /// In en, this message translates to:
  /// **'Expense added'**
  String get expenseAdded;

  /// No description provided for @addExpenseToSeeHere.
  ///
  /// In en, this message translates to:
  /// **'Add an expense to see it here'**
  String get addExpenseToSeeHere;

  /// No description provided for @yourSavingsSnapshot.
  ///
  /// In en, this message translates to:
  /// **'Your savings snapshot'**
  String get yourSavingsSnapshot;

  /// No description provided for @thisMonthSpent.
  ///
  /// In en, this message translates to:
  /// **'This month spent'**
  String get thisMonthSpent;

  /// No description provided for @potentialSavingsFound.
  ///
  /// In en, this message translates to:
  /// **'Potential savings found'**
  String get potentialSavingsFound;

  /// No description provided for @productsTracked.
  ///
  /// In en, this message translates to:
  /// **'Products tracked'**
  String get productsTracked;

  /// No description provided for @bestActionNow.
  ///
  /// In en, this message translates to:
  /// **'Best action now'**
  String get bestActionNow;

  /// No description provided for @addMoreReceiptsForSavings.
  ///
  /// In en, this message translates to:
  /// **'Add more receipts to unlock personalized savings.'**
  String get addMoreReceiptsForSavings;

  /// No description provided for @account.
  ///
  /// In en, this message translates to:
  /// **'Account'**
  String get account;

  /// No description provided for @yourAccount.
  ///
  /// In en, this message translates to:
  /// **'Your account'**
  String get yourAccount;

  /// No description provided for @planAndSubscription.
  ///
  /// In en, this message translates to:
  /// **'Plan & subscription'**
  String get planAndSubscription;

  /// No description provided for @appSettings.
  ///
  /// In en, this message translates to:
  /// **'App settings'**
  String get appSettings;

  /// No description provided for @region.
  ///
  /// In en, this message translates to:
  /// **'Region'**
  String get region;

  /// No description provided for @language.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language;

  /// No description provided for @appearance.
  ///
  /// In en, this message translates to:
  /// **'Appearance'**
  String get appearance;

  /// No description provided for @currency.
  ///
  /// In en, this message translates to:
  /// **'Currency'**
  String get currency;

  /// No description provided for @notifications.
  ///
  /// In en, this message translates to:
  /// **'Notifications'**
  String get notifications;

  /// No description provided for @loadingProfile.
  ///
  /// In en, this message translates to:
  /// **'Loading profile...'**
  String get loadingProfile;

  /// No description provided for @noProfileFound.
  ///
  /// In en, this message translates to:
  /// **'No profile found for this account yet.'**
  String get noProfileFound;

  /// No description provided for @fullName.
  ///
  /// In en, this message translates to:
  /// **'Full name'**
  String get fullName;

  /// No description provided for @email.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get email;

  /// No description provided for @passwordAndSecurity.
  ///
  /// In en, this message translates to:
  /// **'Password & security'**
  String get passwordAndSecurity;

  /// No description provided for @managePassword.
  ///
  /// In en, this message translates to:
  /// **'Manage password'**
  String get managePassword;

  /// No description provided for @currentPlan.
  ///
  /// In en, this message translates to:
  /// **'Current plan'**
  String get currentPlan;

  /// No description provided for @proPlan.
  ///
  /// In en, this message translates to:
  /// **'Pro plan'**
  String get proPlan;

  /// No description provided for @freePlan.
  ///
  /// In en, this message translates to:
  /// **'Free plan'**
  String get freePlan;

  /// No description provided for @pro.
  ///
  /// In en, this message translates to:
  /// **'Pro'**
  String get pro;

  /// No description provided for @free.
  ///
  /// In en, this message translates to:
  /// **'Free'**
  String get free;

  /// No description provided for @status.
  ///
  /// In en, this message translates to:
  /// **'Status'**
  String get status;

  /// No description provided for @provider.
  ///
  /// In en, this message translates to:
  /// **'Provider'**
  String get provider;

  /// No description provided for @price.
  ///
  /// In en, this message translates to:
  /// **'Price'**
  String get price;

  /// No description provided for @priceMonthly.
  ///
  /// In en, this message translates to:
  /// **'\$14.99 / month'**
  String get priceMonthly;

  /// No description provided for @inactive.
  ///
  /// In en, this message translates to:
  /// **'Inactive'**
  String get inactive;

  /// No description provided for @freePlanUpgradeMessage.
  ///
  /// In en, this message translates to:
  /// **'You are currently on the Free plan. Upgrade to Pro to unlock AI savings insights, receipt analytics, smart alerts, and spending reports.'**
  String get freePlanUpgradeMessage;

  /// No description provided for @manageSubscription.
  ///
  /// In en, this message translates to:
  /// **'Manage subscription'**
  String get manageSubscription;

  /// No description provided for @viewPlans.
  ///
  /// In en, this message translates to:
  /// **'View plans'**
  String get viewPlans;

  /// No description provided for @manageSettings.
  ///
  /// In en, this message translates to:
  /// **'Manage settings'**
  String get manageSettings;

  /// No description provided for @signOutQuestion.
  ///
  /// In en, this message translates to:
  /// **'Sign out?'**
  String get signOutQuestion;

  /// No description provided for @signOutMessage.
  ///
  /// In en, this message translates to:
  /// **'You will need to sign in again to access your Savingor account.'**
  String get signOutMessage;

  /// No description provided for @couldNotLoadProfile.
  ///
  /// In en, this message translates to:
  /// **'Could not load your profile. Please try again.'**
  String get couldNotLoadProfile;

  /// No description provided for @personalizeSavingor.
  ///
  /// In en, this message translates to:
  /// **'Personalize Savingor'**
  String get personalizeSavingor;

  /// No description provided for @personalizeSavingorSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Choose how the app looks, communicates, and adapts to your location.'**
  String get personalizeSavingorSubtitle;

  /// No description provided for @preferences.
  ///
  /// In en, this message translates to:
  /// **'Preferences'**
  String get preferences;

  /// No description provided for @appLanguage.
  ///
  /// In en, this message translates to:
  /// **'App language'**
  String get appLanguage;

  /// No description provided for @appearanceHelper.
  ///
  /// In en, this message translates to:
  /// **'Choose how Savingor looks'**
  String get appearanceHelper;

  /// No description provided for @regionHelper.
  ///
  /// In en, this message translates to:
  /// **'Used for nearby stores and local deals'**
  String get regionHelper;

  /// No description provided for @currencyHelper.
  ///
  /// In en, this message translates to:
  /// **'Used for prices, budgets, and reports'**
  String get currencyHelper;

  /// No description provided for @smartSavingsAlerts.
  ///
  /// In en, this message translates to:
  /// **'Smart savings alerts'**
  String get smartSavingsAlerts;

  /// No description provided for @smartSavingsAlertsDescription.
  ///
  /// In en, this message translates to:
  /// **'Get notified about savings opportunities, budget progress, and important recommendations.'**
  String get smartSavingsAlertsDescription;

  /// No description provided for @regionCanada.
  ///
  /// In en, this message translates to:
  /// **'Canada'**
  String get regionCanada;

  /// No description provided for @regionUnitedStates.
  ///
  /// In en, this message translates to:
  /// **'United States'**
  String get regionUnitedStates;

  /// No description provided for @appearanceLight.
  ///
  /// In en, this message translates to:
  /// **'Light'**
  String get appearanceLight;

  /// No description provided for @appearanceDark.
  ///
  /// In en, this message translates to:
  /// **'Dark'**
  String get appearanceDark;

  /// No description provided for @topSavingOpportunities.
  ///
  /// In en, this message translates to:
  /// **'Top saving opportunities'**
  String get topSavingOpportunities;

  /// No description provided for @seeAll.
  ///
  /// In en, this message translates to:
  /// **'See all'**
  String get seeAll;

  /// No description provided for @bestKnownAtStore.
  ///
  /// In en, this message translates to:
  /// **'Best known: {amount} at {store}'**
  String bestKnownAtStore(String amount, String store);

  /// No description provided for @latestPaidAtStore.
  ///
  /// In en, this message translates to:
  /// **'Latest paid: {amount} at {store}'**
  String latestPaidAtStore(String amount, String store);

  /// No description provided for @saveUpToAmount.
  ///
  /// In en, this message translates to:
  /// **'Save up to {amount}'**
  String saveUpToAmount(String amount);

  /// No description provided for @basedOnReceiptHistory.
  ///
  /// In en, this message translates to:
  /// **'Based on receipt history'**
  String get basedOnReceiptHistory;

  /// No description provided for @buyProductAtStoreNextTime.
  ///
  /// In en, this message translates to:
  /// **'Buy {product} at {store} next time'**
  String buyProductAtStoreNextTime(String product, String store);

  /// No description provided for @potentialSavingPerItem.
  ///
  /// In en, this message translates to:
  /// **'Potential saving: {amount} per item'**
  String potentialSavingPerItem(String amount);

  /// No description provided for @productBread.
  ///
  /// In en, this message translates to:
  /// **'Bread'**
  String get productBread;

  /// No description provided for @productMilk.
  ///
  /// In en, this message translates to:
  /// **'Milk'**
  String get productMilk;

  /// No description provided for @delete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get delete;

  /// No description provided for @signIn.
  ///
  /// In en, this message translates to:
  /// **'Sign in'**
  String get signIn;

  /// No description provided for @signInRequired.
  ///
  /// In en, this message translates to:
  /// **'Sign in required'**
  String get signInRequired;

  /// No description provided for @store.
  ///
  /// In en, this message translates to:
  /// **'Store'**
  String get store;

  /// No description provided for @date.
  ///
  /// In en, this message translates to:
  /// **'Date'**
  String get date;

  /// No description provided for @total.
  ///
  /// In en, this message translates to:
  /// **'Total'**
  String get total;

  /// No description provided for @items.
  ///
  /// In en, this message translates to:
  /// **'Items'**
  String get items;

  /// No description provided for @notes.
  ///
  /// In en, this message translates to:
  /// **'Notes'**
  String get notes;

  /// No description provided for @amount.
  ///
  /// In en, this message translates to:
  /// **'Amount'**
  String get amount;

  /// No description provided for @category.
  ///
  /// In en, this message translates to:
  /// **'Category'**
  String get category;

  /// No description provided for @scanReceiptSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Scan a grocery receipt to track expenses and savings.'**
  String get scanReceiptSubtitle;

  /// No description provided for @addManually.
  ///
  /// In en, this message translates to:
  /// **'Add manually'**
  String get addManually;

  /// No description provided for @recentReceipts.
  ///
  /// In en, this message translates to:
  /// **'Recent receipts ({count})'**
  String recentReceipts(int count);

  /// No description provided for @noReceiptsYet.
  ///
  /// In en, this message translates to:
  /// **'No receipts yet. Scan or add one to start tracking.'**
  String get noReceiptsYet;

  /// No description provided for @deleteReceiptQuestion.
  ///
  /// In en, this message translates to:
  /// **'Delete receipt?'**
  String get deleteReceiptQuestion;

  /// No description provided for @deleteReceipt.
  ///
  /// In en, this message translates to:
  /// **'Delete receipt'**
  String get deleteReceipt;

  /// No description provided for @deleteReceiptConfirmMessage.
  ///
  /// In en, this message translates to:
  /// **'{store} ({total}) will be permanently removed.'**
  String deleteReceiptConfirmMessage(String store, String total);

  /// No description provided for @loadingReceipts.
  ///
  /// In en, this message translates to:
  /// **'Loading receipts...'**
  String get loadingReceipts;

  /// No description provided for @couldNotLoadReceipts.
  ///
  /// In en, this message translates to:
  /// **'Could not load receipts'**
  String get couldNotLoadReceipts;

  /// No description provided for @signInToSyncReceipts.
  ///
  /// In en, this message translates to:
  /// **'Save and sync your receipts with your Savingor account.'**
  String get signInToSyncReceipts;

  /// No description provided for @chooseReceiptSource.
  ///
  /// In en, this message translates to:
  /// **'Choose how you want to add your receipt.'**
  String get chooseReceiptSource;

  /// No description provided for @takePhoto.
  ///
  /// In en, this message translates to:
  /// **'Take a photo'**
  String get takePhoto;

  /// No description provided for @takePhotoSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Use your camera to scan a receipt.'**
  String get takePhotoSubtitle;

  /// No description provided for @chooseFromGallery.
  ///
  /// In en, this message translates to:
  /// **'Choose from gallery'**
  String get chooseFromGallery;

  /// No description provided for @chooseFromGallerySubtitle.
  ///
  /// In en, this message translates to:
  /// **'Select an existing receipt photo.'**
  String get chooseFromGallerySubtitle;

  /// No description provided for @scanningReceipt.
  ///
  /// In en, this message translates to:
  /// **'Scanning receipt...'**
  String get scanningReceipt;

  /// No description provided for @couldNotScanReceipt.
  ///
  /// In en, this message translates to:
  /// **'Could not scan this receipt. Try another photo.'**
  String get couldNotScanReceipt;

  /// No description provided for @ocrResultPreview.
  ///
  /// In en, this message translates to:
  /// **'OCR result preview'**
  String get ocrResultPreview;

  /// No description provided for @noTextDetected.
  ///
  /// In en, this message translates to:
  /// **'No text detected. Try a clearer receipt photo.'**
  String get noTextDetected;

  /// No description provided for @useThisReceipt.
  ///
  /// In en, this message translates to:
  /// **'Use this receipt'**
  String get useThisReceipt;

  /// No description provided for @noneDetected.
  ///
  /// In en, this message translates to:
  /// **'None detected'**
  String get noneDetected;

  /// No description provided for @rawOcrText.
  ///
  /// In en, this message translates to:
  /// **'Raw OCR text'**
  String get rawOcrText;

  /// No description provided for @itemsColon.
  ///
  /// In en, this message translates to:
  /// **'Items:'**
  String get itemsColon;

  /// No description provided for @addReceipt.
  ///
  /// In en, this message translates to:
  /// **'Add receipt'**
  String get addReceipt;

  /// No description provided for @editReceipt.
  ///
  /// In en, this message translates to:
  /// **'Edit receipt'**
  String get editReceipt;

  /// No description provided for @saveReceipt.
  ///
  /// In en, this message translates to:
  /// **'Save receipt'**
  String get saveReceipt;

  /// No description provided for @updateReceipt.
  ///
  /// In en, this message translates to:
  /// **'Update receipt'**
  String get updateReceipt;

  /// No description provided for @storeName.
  ///
  /// In en, this message translates to:
  /// **'Store name'**
  String get storeName;

  /// No description provided for @storeAddressOptional.
  ///
  /// In en, this message translates to:
  /// **'Store address (optional)'**
  String get storeAddressOptional;

  /// No description provided for @purchaseDate.
  ///
  /// In en, this message translates to:
  /// **'Purchase date'**
  String get purchaseDate;

  /// No description provided for @categorySummary.
  ///
  /// In en, this message translates to:
  /// **'Category summary'**
  String get categorySummary;

  /// No description provided for @grocery.
  ///
  /// In en, this message translates to:
  /// **'Grocery'**
  String get grocery;

  /// No description provided for @subtotalOptional.
  ///
  /// In en, this message translates to:
  /// **'Subtotal (optional)'**
  String get subtotalOptional;

  /// No description provided for @taxOptional.
  ///
  /// In en, this message translates to:
  /// **'Tax (optional)'**
  String get taxOptional;

  /// No description provided for @receiptTotal.
  ///
  /// In en, this message translates to:
  /// **'Receipt total'**
  String get receiptTotal;

  /// No description provided for @autoCalculatedFromItems.
  ///
  /// In en, this message translates to:
  /// **'Auto-calculated from items unless you edit this field.'**
  String get autoCalculatedFromItems;

  /// No description provided for @notesOptional.
  ///
  /// In en, this message translates to:
  /// **'Notes (optional)'**
  String get notesOptional;

  /// No description provided for @addItem.
  ///
  /// In en, this message translates to:
  /// **'Add item'**
  String get addItem;

  /// No description provided for @addLineItemsHint.
  ///
  /// In en, this message translates to:
  /// **'Add line items to build a real receipt record for price tracking later.'**
  String get addLineItemsHint;

  /// No description provided for @enterStoreName.
  ///
  /// In en, this message translates to:
  /// **'Enter a store name'**
  String get enterStoreName;

  /// No description provided for @selectPurchaseDate.
  ///
  /// In en, this message translates to:
  /// **'Select a purchase date'**
  String get selectPurchaseDate;

  /// No description provided for @enterTotalAmount.
  ///
  /// In en, this message translates to:
  /// **'Enter the total amount'**
  String get enterTotalAmount;

  /// No description provided for @enterValidAmount.
  ///
  /// In en, this message translates to:
  /// **'Enter a valid amount'**
  String get enterValidAmount;

  /// No description provided for @enterValidTotalAmount.
  ///
  /// In en, this message translates to:
  /// **'Enter a valid total amount.'**
  String get enterValidTotalAmount;

  /// No description provided for @receiptNotFound.
  ///
  /// In en, this message translates to:
  /// **'Receipt not found.'**
  String get receiptNotFound;

  /// No description provided for @item.
  ///
  /// In en, this message translates to:
  /// **'Item'**
  String get item;

  /// No description provided for @itemName.
  ///
  /// In en, this message translates to:
  /// **'Item name'**
  String get itemName;

  /// No description provided for @enterItemName.
  ///
  /// In en, this message translates to:
  /// **'Enter an item name'**
  String get enterItemName;

  /// No description provided for @qty.
  ///
  /// In en, this message translates to:
  /// **'Qty'**
  String get qty;

  /// No description provided for @invalidValue.
  ///
  /// In en, this message translates to:
  /// **'Invalid'**
  String get invalidValue;

  /// No description provided for @removeItem.
  ///
  /// In en, this message translates to:
  /// **'Remove item'**
  String get removeItem;

  /// No description provided for @categoryOptional.
  ///
  /// In en, this message translates to:
  /// **'Category (optional)'**
  String get categoryOptional;

  /// No description provided for @receiptDetails.
  ///
  /// In en, this message translates to:
  /// **'Receipt details'**
  String get receiptDetails;

  /// No description provided for @subtotalLabel.
  ///
  /// In en, this message translates to:
  /// **'Subtotal: {amount}'**
  String subtotalLabel(String amount);

  /// No description provided for @taxLabel.
  ///
  /// In en, this message translates to:
  /// **'Tax: {amount}'**
  String taxLabel(String amount);

  /// No description provided for @noItemsSaved.
  ///
  /// In en, this message translates to:
  /// **'No items saved'**
  String get noItemsSaved;

  /// No description provided for @noLineItemsSaved.
  ///
  /// In en, this message translates to:
  /// **'No line items were saved for this receipt yet.'**
  String get noLineItemsSaved;

  /// No description provided for @qtyWithValue.
  ///
  /// In en, this message translates to:
  /// **'Qty {quantity}'**
  String qtyWithValue(String quantity);

  /// No description provided for @couldNotDeleteReceipt.
  ///
  /// In en, this message translates to:
  /// **'Could not delete the receipt. Please try again.'**
  String get couldNotDeleteReceipt;

  /// No description provided for @saveChanges.
  ///
  /// In en, this message translates to:
  /// **'Save changes'**
  String get saveChanges;

  /// No description provided for @receiptSourceManual.
  ///
  /// In en, this message translates to:
  /// **'Manual'**
  String get receiptSourceManual;

  /// No description provided for @receiptSourceScanned.
  ///
  /// In en, this message translates to:
  /// **'Scanned'**
  String get receiptSourceScanned;

  /// No description provided for @receiptSourceGallery.
  ///
  /// In en, this message translates to:
  /// **'Gallery'**
  String get receiptSourceGallery;

  /// No description provided for @receiptSourceImported.
  ///
  /// In en, this message translates to:
  /// **'Imported'**
  String get receiptSourceImported;

  /// No description provided for @receiptSourceShoppingList.
  ///
  /// In en, this message translates to:
  /// **'Shopping list'**
  String get receiptSourceShoppingList;

  /// No description provided for @receiptSourceUnknown.
  ///
  /// In en, this message translates to:
  /// **'Receipt'**
  String get receiptSourceUnknown;

  /// No description provided for @scanNotes.
  ///
  /// In en, this message translates to:
  /// **'Scan notes'**
  String get scanNotes;

  /// No description provided for @galleryScanNotes.
  ///
  /// In en, this message translates to:
  /// **'Gallery scan notes'**
  String get galleryScanNotes;

  /// No description provided for @importNotes.
  ///
  /// In en, this message translates to:
  /// **'Import notes'**
  String get importNotes;

  /// No description provided for @tripNotes.
  ///
  /// In en, this message translates to:
  /// **'Trip notes'**
  String get tripNotes;

  /// No description provided for @couldNotLoadYourReceipts.
  ///
  /// In en, this message translates to:
  /// **'Could not load your receipts. Please try again.'**
  String get couldNotLoadYourReceipts;

  /// No description provided for @signInToSaveReceipts.
  ///
  /// In en, this message translates to:
  /// **'Sign in to save receipts.'**
  String get signInToSaveReceipts;

  /// No description provided for @couldNotSaveReceipt.
  ///
  /// In en, this message translates to:
  /// **'Could not save the receipt. Please try again.'**
  String get couldNotSaveReceipt;

  /// No description provided for @couldNotUpdateReceipt.
  ///
  /// In en, this message translates to:
  /// **'Could not update the receipt. Please try again.'**
  String get couldNotUpdateReceipt;

  /// No description provided for @signInToUpdateReceipts.
  ///
  /// In en, this message translates to:
  /// **'Sign in to update receipts.'**
  String get signInToUpdateReceipts;

  /// No description provided for @receiptItemsCount.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =0{0 items} =1{1 item} other{{count} items}}'**
  String receiptItemsCount(int count);

  /// No description provided for @processingReceipt.
  ///
  /// In en, this message translates to:
  /// **'Processing receipt'**
  String get processingReceipt;

  /// No description provided for @readingReceipt.
  ///
  /// In en, this message translates to:
  /// **'Reading receipt'**
  String get readingReceipt;

  /// No description provided for @recognizingText.
  ///
  /// In en, this message translates to:
  /// **'Recognizing text'**
  String get recognizingText;

  /// No description provided for @receiptScannedSuccessfully.
  ///
  /// In en, this message translates to:
  /// **'Receipt scanned successfully'**
  String get receiptScannedSuccessfully;

  /// No description provided for @noTextRecognized.
  ///
  /// In en, this message translates to:
  /// **'No text recognized'**
  String get noTextRecognized;

  /// No description provided for @couldNotReadReceipt.
  ///
  /// In en, this message translates to:
  /// **'Could not read this receipt'**
  String get couldNotReadReceipt;

  /// No description provided for @imageTooBlurry.
  ///
  /// In en, this message translates to:
  /// **'Image is too blurry'**
  String get imageTooBlurry;

  /// No description provided for @tryAnotherPhoto.
  ///
  /// In en, this message translates to:
  /// **'Please try another photo'**
  String get tryAnotherPhoto;

  /// No description provided for @cameraPermissionRequired.
  ///
  /// In en, this message translates to:
  /// **'Camera permission is required'**
  String get cameraPermissionRequired;

  /// No description provided for @galleryPermissionRequired.
  ///
  /// In en, this message translates to:
  /// **'Gallery access is required'**
  String get galleryPermissionRequired;

  /// No description provided for @permissionDenied.
  ///
  /// In en, this message translates to:
  /// **'Permission denied'**
  String get permissionDenied;

  /// No description provided for @openSettings.
  ///
  /// In en, this message translates to:
  /// **'Open settings'**
  String get openSettings;

  /// No description provided for @chooseSavingAction.
  ///
  /// In en, this message translates to:
  /// **'Choose what you want to do'**
  String get chooseSavingAction;

  /// No description provided for @addGroceryExpense.
  ///
  /// In en, this message translates to:
  /// **'Add grocery expense'**
  String get addGroceryExpense;

  /// No description provided for @addGroceryExpenseSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Record a purchase manually'**
  String get addGroceryExpenseSubtitle;

  /// No description provided for @createShoppingListAction.
  ///
  /// In en, this message translates to:
  /// **'Create shopping list'**
  String get createShoppingListAction;

  /// No description provided for @createShoppingListSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Plan what you need before shopping'**
  String get createShoppingListSubtitle;

  /// No description provided for @optimizeShoppingBasket.
  ///
  /// In en, this message translates to:
  /// **'Optimize shopping basket'**
  String get optimizeShoppingBasket;

  /// No description provided for @optimizeShoppingBasketSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Find opportunities to spend less'**
  String get optimizeShoppingBasketSubtitle;

  /// No description provided for @finalizeShoppingTrip.
  ///
  /// In en, this message translates to:
  /// **'Finalize shopping trip'**
  String get finalizeShoppingTrip;

  /// No description provided for @finalizeShoppingTripSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Complete your shopping activity'**
  String get finalizeShoppingTripSubtitle;

  /// No description provided for @monthlyGoalBudget.
  ///
  /// In en, this message translates to:
  /// **'Monthly goal / Budget'**
  String get monthlyGoalBudget;

  /// No description provided for @monthlyGoalBudgetSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Set or update your monthly target'**
  String get monthlyGoalBudgetSubtitle;

  /// No description provided for @savingsAnalytics.
  ///
  /// In en, this message translates to:
  /// **'Savings analytics'**
  String get savingsAnalytics;

  /// No description provided for @savingsAnalyticsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Review your savings and spending'**
  String get savingsAnalyticsSubtitle;

  /// No description provided for @open.
  ///
  /// In en, this message translates to:
  /// **'Open'**
  String get open;

  /// No description provided for @expenses.
  ///
  /// In en, this message translates to:
  /// **'Expenses'**
  String get expenses;

  /// No description provided for @addExpense.
  ///
  /// In en, this message translates to:
  /// **'Add expense'**
  String get addExpense;

  /// No description provided for @loadingExpenses.
  ///
  /// In en, this message translates to:
  /// **'Loading expenses...'**
  String get loadingExpenses;

  /// No description provided for @couldNotLoadExpenses.
  ///
  /// In en, this message translates to:
  /// **'Could not load expenses'**
  String get couldNotLoadExpenses;

  /// No description provided for @couldNotLoadYourExpenses.
  ///
  /// In en, this message translates to:
  /// **'Could not load your expenses. Please try again.'**
  String get couldNotLoadYourExpenses;

  /// No description provided for @noExpensesYet.
  ///
  /// In en, this message translates to:
  /// **'No expenses yet'**
  String get noExpensesYet;

  /// No description provided for @noExpensesYetMessage.
  ///
  /// In en, this message translates to:
  /// **'Track grocery purchases and receipts to understand your spending.'**
  String get noExpensesYetMessage;

  /// No description provided for @signInToSyncExpenses.
  ///
  /// In en, this message translates to:
  /// **'Save and sync your expenses with your Savingor account.'**
  String get signInToSyncExpenses;

  /// No description provided for @deleteExpenseQuestion.
  ///
  /// In en, this message translates to:
  /// **'Delete expense?'**
  String get deleteExpenseQuestion;

  /// No description provided for @deleteExpenseConfirmMessage.
  ///
  /// In en, this message translates to:
  /// **'\"{store}\" ({amount}) will be permanently removed.'**
  String deleteExpenseConfirmMessage(String store, String amount);

  /// No description provided for @saveExpense.
  ///
  /// In en, this message translates to:
  /// **'Save expense'**
  String get saveExpense;

  /// No description provided for @totalAmount.
  ///
  /// In en, this message translates to:
  /// **'Total amount'**
  String get totalAmount;

  /// No description provided for @signInToSaveExpenses.
  ///
  /// In en, this message translates to:
  /// **'Sign in to save expenses.'**
  String get signInToSaveExpenses;

  /// No description provided for @couldNotSaveExpense.
  ///
  /// In en, this message translates to:
  /// **'Could not save the expense. Please try again.'**
  String get couldNotSaveExpense;

  /// No description provided for @couldNotDeleteExpense.
  ///
  /// In en, this message translates to:
  /// **'Could not delete the expense. Please try again.'**
  String get couldNotDeleteExpense;

  /// No description provided for @expenseSaved.
  ///
  /// In en, this message translates to:
  /// **'Expense saved.'**
  String get expenseSaved;

  /// No description provided for @uncategorized.
  ///
  /// In en, this message translates to:
  /// **'Uncategorized'**
  String get uncategorized;

  /// No description provided for @recentExpenses.
  ///
  /// In en, this message translates to:
  /// **'Recent expenses'**
  String get recentExpenses;

  /// No description provided for @noExpensesAddedYet.
  ///
  /// In en, this message translates to:
  /// **'No expenses added yet.'**
  String get noExpensesAddedYet;

  /// No description provided for @pleaseEnterStoreName.
  ///
  /// In en, this message translates to:
  /// **'Please enter a store name.'**
  String get pleaseEnterStoreName;

  /// No description provided for @pleaseEnterItemName.
  ///
  /// In en, this message translates to:
  /// **'Please enter an item name.'**
  String get pleaseEnterItemName;

  /// No description provided for @pleaseEnterPrice.
  ///
  /// In en, this message translates to:
  /// **'Please enter a price.'**
  String get pleaseEnterPrice;

  /// No description provided for @pleaseEnterValidPrice.
  ///
  /// In en, this message translates to:
  /// **'Please enter a valid price.'**
  String get pleaseEnterValidPrice;

  /// No description provided for @expenseCount.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =0{0 expenses} =1{1 expense} other{{count} expenses}}'**
  String expenseCount(int count);

  /// No description provided for @newShoppingList.
  ///
  /// In en, this message translates to:
  /// **'New shopping list'**
  String get newShoppingList;

  /// No description provided for @newList.
  ///
  /// In en, this message translates to:
  /// **'New list'**
  String get newList;

  /// No description provided for @createList.
  ///
  /// In en, this message translates to:
  /// **'Create list'**
  String get createList;

  /// No description provided for @loadingShoppingLists.
  ///
  /// In en, this message translates to:
  /// **'Loading shopping lists...'**
  String get loadingShoppingLists;

  /// No description provided for @couldNotLoadLists.
  ///
  /// In en, this message translates to:
  /// **'Could not load lists'**
  String get couldNotLoadLists;

  /// No description provided for @couldNotLoadYourShoppingLists.
  ///
  /// In en, this message translates to:
  /// **'Could not load your shopping lists. Please try again.'**
  String get couldNotLoadYourShoppingLists;

  /// No description provided for @noShoppingListsYet.
  ///
  /// In en, this message translates to:
  /// **'No shopping lists yet'**
  String get noShoppingListsYet;

  /// No description provided for @noShoppingListsYetMessage.
  ///
  /// In en, this message translates to:
  /// **'Create your first list to plan purchases and optimize your basket.'**
  String get noShoppingListsYetMessage;

  /// No description provided for @signInToSyncShoppingLists.
  ///
  /// In en, this message translates to:
  /// **'Create and sync shopping lists with your Savingor account.'**
  String get signInToSyncShoppingLists;

  /// No description provided for @deleteListQuestion.
  ///
  /// In en, this message translates to:
  /// **'Delete list?'**
  String get deleteListQuestion;

  /// No description provided for @deleteListConfirmMessage.
  ///
  /// In en, this message translates to:
  /// **'\"{title}\" will be permanently removed.'**
  String deleteListConfirmMessage(String title);

  /// No description provided for @deleteList.
  ///
  /// In en, this message translates to:
  /// **'Delete list'**
  String get deleteList;

  /// No description provided for @optimizeAllLists.
  ///
  /// In en, this message translates to:
  /// **'Optimize all lists'**
  String get optimizeAllLists;

  /// No description provided for @optimizeAllListsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Find the best known stores across your active shopping lists'**
  String get optimizeAllListsSubtitle;

  /// No description provided for @optimizeThisBasket.
  ///
  /// In en, this message translates to:
  /// **'Optimize this basket'**
  String get optimizeThisBasket;

  /// No description provided for @optimizeThisBasketSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Find the best known stores for this list'**
  String get optimizeThisBasketSubtitle;

  /// No description provided for @listNotFound.
  ///
  /// In en, this message translates to:
  /// **'List not found'**
  String get listNotFound;

  /// No description provided for @listNotFoundMessage.
  ///
  /// In en, this message translates to:
  /// **'This shopping list may have been deleted.'**
  String get listNotFoundMessage;

  /// No description provided for @backToLists.
  ///
  /// In en, this message translates to:
  /// **'Back to lists'**
  String get backToLists;

  /// No description provided for @noShoppingItemsYet.
  ///
  /// In en, this message translates to:
  /// **'No items yet'**
  String get noShoppingItemsYet;

  /// No description provided for @noShoppingItemsYetMessage.
  ///
  /// In en, this message translates to:
  /// **'Add items to this list to track what you need.'**
  String get noShoppingItemsYetMessage;

  /// No description provided for @shoppingListEmptyMessage.
  ///
  /// In en, this message translates to:
  /// **'Create and manage your smart shopping lists here.'**
  String get shoppingListEmptyMessage;

  /// No description provided for @purchased.
  ///
  /// In en, this message translates to:
  /// **'Purchased'**
  String get purchased;

  /// No description provided for @clearPurchased.
  ///
  /// In en, this message translates to:
  /// **'Clear purchased'**
  String get clearPurchased;

  /// No description provided for @estimatedTotalLabel.
  ///
  /// In en, this message translates to:
  /// **'Estimated total'**
  String get estimatedTotalLabel;

  /// No description provided for @estimatedShort.
  ///
  /// In en, this message translates to:
  /// **'Est. {amount}'**
  String estimatedShort(String amount);

  /// No description provided for @activeCountLabel.
  ///
  /// In en, this message translates to:
  /// **'{count} active'**
  String activeCountLabel(int count);

  /// No description provided for @purchasedSummary.
  ///
  /// In en, this message translates to:
  /// **'{count} purchased'**
  String purchasedSummary(int count);

  /// No description provided for @itemsTotalSummary.
  ///
  /// In en, this message translates to:
  /// **'{count} items total'**
  String itemsTotalSummary(int count);

  /// No description provided for @allItemsPurchased.
  ///
  /// In en, this message translates to:
  /// **'All items purchased'**
  String get allItemsPurchased;

  /// No description provided for @saveItem.
  ///
  /// In en, this message translates to:
  /// **'Save item'**
  String get saveItem;

  /// No description provided for @listTitle.
  ///
  /// In en, this message translates to:
  /// **'List title'**
  String get listTitle;

  /// No description provided for @enterListTitle.
  ///
  /// In en, this message translates to:
  /// **'Enter a list title'**
  String get enterListTitle;

  /// No description provided for @listName.
  ///
  /// In en, this message translates to:
  /// **'List name'**
  String get listName;

  /// No description provided for @enterListName.
  ///
  /// In en, this message translates to:
  /// **'Enter a list name'**
  String get enterListName;

  /// No description provided for @newShoppingListHint.
  ///
  /// In en, this message translates to:
  /// **'Give your list a name. You can add items after creating it.'**
  String get newShoppingListHint;

  /// No description provided for @itemsOptional.
  ///
  /// In en, this message translates to:
  /// **'Items (optional)'**
  String get itemsOptional;

  /// No description provided for @addAnotherItem.
  ///
  /// In en, this message translates to:
  /// **'Add another item'**
  String get addAnotherItem;

  /// No description provided for @storeOptional.
  ///
  /// In en, this message translates to:
  /// **'Store (optional)'**
  String get storeOptional;

  /// No description provided for @priceOptional.
  ///
  /// In en, this message translates to:
  /// **'Price (optional)'**
  String get priceOptional;

  /// No description provided for @loadingListItems.
  ///
  /// In en, this message translates to:
  /// **'Loading list items...'**
  String get loadingListItems;

  /// No description provided for @loadingShoppingList.
  ///
  /// In en, this message translates to:
  /// **'Loading shopping list...'**
  String get loadingShoppingList;

  /// No description provided for @couldNotLoadItems.
  ///
  /// In en, this message translates to:
  /// **'Could not load items'**
  String get couldNotLoadItems;

  /// No description provided for @couldNotLoadListItems.
  ///
  /// In en, this message translates to:
  /// **'Could not load list items. Please try again.'**
  String get couldNotLoadListItems;

  /// No description provided for @createAnotherReceiptQuestion.
  ///
  /// In en, this message translates to:
  /// **'Create another receipt?'**
  String get createAnotherReceiptQuestion;

  /// No description provided for @createAnotherReceiptMessage.
  ///
  /// In en, this message translates to:
  /// **'This list may already have a receipt. Create another receipt from purchased items?'**
  String get createAnotherReceiptMessage;

  /// No description provided for @createReceipt.
  ///
  /// In en, this message translates to:
  /// **'Create receipt'**
  String get createReceipt;

  /// No description provided for @signInToFinalizeTrip.
  ///
  /// In en, this message translates to:
  /// **'Sign in to finalize a shopping trip.'**
  String get signInToFinalizeTrip;

  /// No description provided for @noListsReadyToFinalize.
  ///
  /// In en, this message translates to:
  /// **'No lists ready to finalize'**
  String get noListsReadyToFinalize;

  /// No description provided for @noListsReadyToFinalizeMessage.
  ///
  /// In en, this message translates to:
  /// **'Mark items as purchased on a shopping list, then return here to create a receipt.'**
  String get noListsReadyToFinalizeMessage;

  /// No description provided for @openShoppingLists.
  ///
  /// In en, this message translates to:
  /// **'Open shopping lists'**
  String get openShoppingLists;

  /// No description provided for @selectListToFinalize.
  ///
  /// In en, this message translates to:
  /// **'Select list to finalize'**
  String get selectListToFinalize;

  /// No description provided for @selectListToFinalizeSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Choose a shopping list with purchased items.'**
  String get selectListToFinalizeSubtitle;

  /// No description provided for @finalizeShoppingTripCardSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Create a receipt from purchased items and update your price history'**
  String get finalizeShoppingTripCardSubtitle;

  /// No description provided for @done.
  ///
  /// In en, this message translates to:
  /// **'Done'**
  String get done;

  /// No description provided for @optional.
  ///
  /// In en, this message translates to:
  /// **'Optional'**
  String get optional;

  /// No description provided for @somethingWentWrong.
  ///
  /// In en, this message translates to:
  /// **'Something went wrong'**
  String get somethingWentWrong;

  /// No description provided for @saving.
  ///
  /// In en, this message translates to:
  /// **'Saving...'**
  String get saving;

  /// No description provided for @loadingPurchasedItems.
  ///
  /// In en, this message translates to:
  /// **'Loading purchased items...'**
  String get loadingPurchasedItems;

  /// No description provided for @preparingPurchasedItems.
  ///
  /// In en, this message translates to:
  /// **'Preparing purchased items...'**
  String get preparingPurchasedItems;

  /// No description provided for @noPurchasedItemsYet.
  ///
  /// In en, this message translates to:
  /// **'No purchased items yet'**
  String get noPurchasedItemsYet;

  /// No description provided for @noPurchasedItemsYetMessage.
  ///
  /// In en, this message translates to:
  /// **'Check off items you bought before creating a receipt.'**
  String get noPurchasedItemsYetMessage;

  /// No description provided for @backToList.
  ///
  /// In en, this message translates to:
  /// **'Back to list'**
  String get backToList;

  /// No description provided for @enterStoreNameForTrip.
  ///
  /// In en, this message translates to:
  /// **'Enter the store name for this trip'**
  String get enterStoreNameForTrip;

  /// No description provided for @enterStoreNameForTripSnack.
  ///
  /// In en, this message translates to:
  /// **'Enter the store name for this trip.'**
  String get enterStoreNameForTripSnack;

  /// No description provided for @creatingReceiptsPerStore.
  ///
  /// In en, this message translates to:
  /// **'Creating {count} receipts — one per store.'**
  String creatingReceiptsPerStore(int count);

  /// No description provided for @missingStoreOnItems.
  ///
  /// In en, this message translates to:
  /// **'Some purchased items are missing a store. Add a store on each item before finalizing.'**
  String get missingStoreOnItems;

  /// No description provided for @missingStore.
  ///
  /// In en, this message translates to:
  /// **'Missing store'**
  String get missingStore;

  /// No description provided for @receiptSubtotalLabel.
  ///
  /// In en, this message translates to:
  /// **'Receipt subtotal: {amount}'**
  String receiptSubtotalLabel(String amount);

  /// No description provided for @purchasedItems.
  ///
  /// In en, this message translates to:
  /// **'Purchased items'**
  String get purchasedItems;

  /// No description provided for @enterReceiptTotal.
  ///
  /// In en, this message translates to:
  /// **'Enter the receipt total'**
  String get enterReceiptTotal;

  /// No description provided for @enterValidReceiptTotal.
  ///
  /// In en, this message translates to:
  /// **'Enter a valid receipt total'**
  String get enterValidReceiptTotal;

  /// No description provided for @subtotalFromItemPrices.
  ///
  /// In en, this message translates to:
  /// **'Subtotal from item prices: {amount}'**
  String subtotalFromItemPrices(String amount);

  /// No description provided for @grandTotalAcrossReceipts.
  ///
  /// In en, this message translates to:
  /// **'Grand total across receipts: {amount}'**
  String grandTotalAcrossReceipts(String amount);

  /// No description provided for @saveReceipts.
  ///
  /// In en, this message translates to:
  /// **'Save receipts'**
  String get saveReceipts;

  /// No description provided for @addValidPricesForStore.
  ///
  /// In en, this message translates to:
  /// **'Add valid prices for purchased items at {store}.'**
  String addValidPricesForStore(String store);

  /// No description provided for @addStoreToAllItems.
  ///
  /// In en, this message translates to:
  /// **'Add a store to every purchased item before finalizing multiple receipts.'**
  String get addStoreToAllItems;

  /// No description provided for @signInToCreateShoppingLists.
  ///
  /// In en, this message translates to:
  /// **'Sign in to create shopping lists.'**
  String get signInToCreateShoppingLists;

  /// No description provided for @couldNotCreateList.
  ///
  /// In en, this message translates to:
  /// **'Could not create the list. Please try again.'**
  String get couldNotCreateList;

  /// No description provided for @couldNotDeleteList.
  ///
  /// In en, this message translates to:
  /// **'Could not delete the list. Please try again.'**
  String get couldNotDeleteList;

  /// No description provided for @couldNotAddItem.
  ///
  /// In en, this message translates to:
  /// **'Could not add the item. Please try again.'**
  String get couldNotAddItem;

  /// No description provided for @signInToAddShoppingItems.
  ///
  /// In en, this message translates to:
  /// **'Sign in to add items to your shopping list.'**
  String get signInToAddShoppingItems;

  /// No description provided for @itemNameRequired.
  ///
  /// In en, this message translates to:
  /// **'Item name is required.'**
  String get itemNameRequired;

  /// No description provided for @couldNotUpdateItem.
  ///
  /// In en, this message translates to:
  /// **'Could not update the item. Please try again.'**
  String get couldNotUpdateItem;

  /// No description provided for @couldNotUpdateQuantity.
  ///
  /// In en, this message translates to:
  /// **'Could not update quantity. Please try again.'**
  String get couldNotUpdateQuantity;

  /// No description provided for @couldNotRemoveItem.
  ///
  /// In en, this message translates to:
  /// **'Could not remove the item. Please try again.'**
  String get couldNotRemoveItem;

  /// No description provided for @couldNotUpdateShoppingList.
  ///
  /// In en, this message translates to:
  /// **'Could not update the shopping list. Please try again.'**
  String get couldNotUpdateShoppingList;

  /// No description provided for @couldNotCompleteAction.
  ///
  /// In en, this message translates to:
  /// **'Could not complete the action. Please try again.'**
  String get couldNotCompleteAction;

  /// No description provided for @estimatedPrefix.
  ///
  /// In en, this message translates to:
  /// **'Estimated: {amount}'**
  String estimatedPrefix(String amount);

  /// No description provided for @shoppingTripFinalized.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{Shopping trip finalized. 1 receipt created.} other{Shopping trip finalized. {count} receipts created.}}'**
  String shoppingTripFinalized(int count);

  /// No description provided for @productChicken.
  ///
  /// In en, this message translates to:
  /// **'Chicken'**
  String get productChicken;

  /// No description provided for @productEggs.
  ///
  /// In en, this message translates to:
  /// **'Eggs'**
  String get productEggs;

  /// No description provided for @weeklyGroceriesDefault.
  ///
  /// In en, this message translates to:
  /// **'Weekly groceries'**
  String get weeklyGroceriesDefault;

  /// No description provided for @basketSummary.
  ///
  /// In en, this message translates to:
  /// **'Basket summary'**
  String get basketSummary;

  /// No description provided for @estimatedBestTotal.
  ///
  /// In en, this message translates to:
  /// **'Estimated best total'**
  String get estimatedBestTotal;

  /// No description provided for @basketPotentialSaving.
  ///
  /// In en, this message translates to:
  /// **'Potential saving'**
  String get basketPotentialSaving;

  /// No description provided for @itemsMatched.
  ///
  /// In en, this message translates to:
  /// **'Items matched'**
  String get itemsMatched;

  /// No description provided for @noPriceHistoryLabel.
  ///
  /// In en, this message translates to:
  /// **'No price history'**
  String get noPriceHistoryLabel;

  /// No description provided for @activeListsIncludedLabel.
  ///
  /// In en, this message translates to:
  /// **'Active lists included'**
  String get activeListsIncludedLabel;

  /// No description provided for @itemRecommendations.
  ///
  /// In en, this message translates to:
  /// **'Item recommendations'**
  String get itemRecommendations;

  /// No description provided for @bestKnownLabel.
  ///
  /// In en, this message translates to:
  /// **'Best known'**
  String get bestKnownLabel;

  /// No description provided for @latestSeen.
  ///
  /// In en, this message translates to:
  /// **'Latest seen'**
  String get latestSeen;

  /// No description provided for @saveUpToTotal.
  ///
  /// In en, this message translates to:
  /// **'Save up to {amount} total'**
  String saveUpToTotal(String amount);

  /// No description provided for @noPriceHistoryYet.
  ///
  /// In en, this message translates to:
  /// **'No price history yet'**
  String get noPriceHistoryYet;

  /// No description provided for @addReceiptsForItemRecommendations.
  ///
  /// In en, this message translates to:
  /// **'Add receipts with this item to unlock recommendations.'**
  String get addReceiptsForItemRecommendations;

  /// No description provided for @suggestedStorePlan.
  ///
  /// In en, this message translates to:
  /// **'Suggested store plan'**
  String get suggestedStorePlan;

  /// No description provided for @estimatedStoreTotalLabel.
  ///
  /// In en, this message translates to:
  /// **'Estimated store total: {amount}'**
  String estimatedStoreTotalLabel(String amount);

  /// No description provided for @storePlanItemLine.
  ///
  /// In en, this message translates to:
  /// **'• {itemName}{quantitySuffix} — {unitPrice} {perUnit}'**
  String storePlanItemLine(
      String itemName, String quantitySuffix, String unitPrice, String perUnit);

  /// No description provided for @perUnit.
  ///
  /// In en, this message translates to:
  /// **'each'**
  String get perUnit;

  /// No description provided for @signInToOptimizeAllLists.
  ///
  /// In en, this message translates to:
  /// **'Sign in to optimize all your shopping lists from your receipts.'**
  String get signInToOptimizeAllLists;

  /// No description provided for @signInToOptimizeBasket.
  ///
  /// In en, this message translates to:
  /// **'Sign in to optimize your basket from your receipts and shopping list.'**
  String get signInToOptimizeBasket;

  /// No description provided for @loadingAllActiveLists.
  ///
  /// In en, this message translates to:
  /// **'Loading all active lists…'**
  String get loadingAllActiveLists;

  /// No description provided for @loadingBasketOptimizer.
  ///
  /// In en, this message translates to:
  /// **'Loading basket optimizer…'**
  String get loadingBasketOptimizer;

  /// No description provided for @couldNotLoadShoppingList.
  ///
  /// In en, this message translates to:
  /// **'Could not load shopping list'**
  String get couldNotLoadShoppingList;

  /// No description provided for @couldNotLoadPriceHistory.
  ///
  /// In en, this message translates to:
  /// **'Could not load price history'**
  String get couldNotLoadPriceHistory;

  /// No description provided for @noActiveItemsToOptimize.
  ///
  /// In en, this message translates to:
  /// **'No active items to optimize'**
  String get noActiveItemsToOptimize;

  /// No description provided for @noActiveItemsToOptimizeMessage.
  ///
  /// In en, this message translates to:
  /// **'Add items to your shopping lists to build a smart store plan.'**
  String get noActiveItemsToOptimizeMessage;

  /// No description provided for @backToShopping.
  ///
  /// In en, this message translates to:
  /// **'Back to shopping'**
  String get backToShopping;

  /// No description provided for @addItemsToListForOptimizer.
  ///
  /// In en, this message translates to:
  /// **'Add items to your shopping list'**
  String get addItemsToListForOptimizer;

  /// No description provided for @addItemsToListForOptimizerMessage.
  ///
  /// In en, this message translates to:
  /// **'Add items to your shopping list to optimize your basket.'**
  String get addItemsToListForOptimizerMessage;

  /// No description provided for @noPriceHistoryForOptimizerMessage.
  ///
  /// In en, this message translates to:
  /// **'Add receipts with line items so Savingor can learn your prices and recommend better stores.'**
  String get noPriceHistoryForOptimizerMessage;

  /// No description provided for @listFinalizeProgressSummary.
  ///
  /// In en, this message translates to:
  /// **'Purchased: {purchased} · Total items: {total}'**
  String listFinalizeProgressSummary(int purchased, int total);

  /// No description provided for @qtyWithCount.
  ///
  /// In en, this message translates to:
  /// **'Qty {count}'**
  String qtyWithCount(int count);

  /// No description provided for @unitPrice.
  ///
  /// In en, this message translates to:
  /// **'Unit price'**
  String get unitPrice;

  /// No description provided for @lineTotalWithAmount.
  ///
  /// In en, this message translates to:
  /// **'Line total: {amount}'**
  String lineTotalWithAmount(String amount);

  /// No description provided for @lineTotalEmpty.
  ///
  /// In en, this message translates to:
  /// **'Line total: —'**
  String get lineTotalEmpty;

  /// No description provided for @enterPriceForProduct.
  ///
  /// In en, this message translates to:
  /// **'Enter a price for {product}'**
  String enterPriceForProduct(String product);

  /// No description provided for @enterValidPriceForProduct.
  ///
  /// In en, this message translates to:
  /// **'Enter a valid price for {product}'**
  String enterValidPriceForProduct(String product);

  /// No description provided for @trackMonthlyGrocerySpending.
  ///
  /// In en, this message translates to:
  /// **'Track your monthly grocery spending against your budget.'**
  String get trackMonthlyGrocerySpending;

  /// No description provided for @monthlyGroceryBudget.
  ///
  /// In en, this message translates to:
  /// **'Monthly grocery budget'**
  String get monthlyGroceryBudget;

  /// No description provided for @spentThisMonth.
  ///
  /// In en, this message translates to:
  /// **'Spent this month'**
  String get spentThisMonth;

  /// No description provided for @overBudget.
  ///
  /// In en, this message translates to:
  /// **'Over budget'**
  String get overBudget;

  /// No description provided for @remaining.
  ///
  /// In en, this message translates to:
  /// **'Remaining'**
  String get remaining;

  /// No description provided for @updateMonthlyBudget.
  ///
  /// In en, this message translates to:
  /// **'Update monthly budget'**
  String get updateMonthlyBudget;

  /// No description provided for @setMonthlyBudgetDescription.
  ///
  /// In en, this message translates to:
  /// **'Set the grocery spending limit you want to track each month.'**
  String get setMonthlyBudgetDescription;

  /// No description provided for @monthlyBudgetAmount.
  ///
  /// In en, this message translates to:
  /// **'Monthly budget amount'**
  String get monthlyBudgetAmount;

  /// No description provided for @saveBudget.
  ///
  /// In en, this message translates to:
  /// **'Save budget'**
  String get saveBudget;

  /// No description provided for @budgetSaved.
  ///
  /// In en, this message translates to:
  /// **'Budget saved'**
  String get budgetSaved;

  /// No description provided for @enterBudgetAmount.
  ///
  /// In en, this message translates to:
  /// **'Enter a budget amount'**
  String get enterBudgetAmount;

  /// No description provided for @enterAmountGreaterThanZero.
  ///
  /// In en, this message translates to:
  /// **'Enter an amount greater than zero'**
  String get enterAmountGreaterThanZero;

  /// No description provided for @overview.
  ///
  /// In en, this message translates to:
  /// **'Overview'**
  String get overview;

  /// No description provided for @estimatedSaved.
  ///
  /// In en, this message translates to:
  /// **'Estimated saved'**
  String get estimatedSaved;

  /// No description provided for @potentialMissed.
  ///
  /// In en, this message translates to:
  /// **'Potential missed'**
  String get potentialMissed;

  /// No description provided for @savingsValue.
  ///
  /// In en, this message translates to:
  /// **'Savings value'**
  String get savingsValue;

  /// No description provided for @proPayback.
  ///
  /// In en, this message translates to:
  /// **'Pro payback'**
  String get proPayback;

  /// No description provided for @proPaidForItself.
  ///
  /// In en, this message translates to:
  /// **'Pro paid for itself'**
  String get proPaidForItself;

  /// No description provided for @amountOfPriceCovered.
  ///
  /// In en, this message translates to:
  /// **'{amount} of {price} covered'**
  String amountOfPriceCovered(String amount, String price);

  /// No description provided for @needAmountMoreForPro.
  ///
  /// In en, this message translates to:
  /// **'Need {amount} more to cover Pro'**
  String needAmountMoreForPro(String amount);

  /// No description provided for @amountAfterSubscription.
  ///
  /// In en, this message translates to:
  /// **'+{amount} after subscription'**
  String amountAfterSubscription(String amount);

  /// No description provided for @monthlyReturnMultiplier.
  ///
  /// In en, this message translates to:
  /// **'Return: {multiplier}x this month'**
  String monthlyReturnMultiplier(String multiplier);

  /// No description provided for @spendingByStore.
  ///
  /// In en, this message translates to:
  /// **'Spending by store'**
  String get spendingByStore;

  /// No description provided for @priceRecordCount.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 record} other{{count} records}}'**
  String priceRecordCount(int count);

  /// No description provided for @recentActivity.
  ///
  /// In en, this message translates to:
  /// **'Recent activity'**
  String get recentActivity;

  /// No description provided for @activityTypeReceipt.
  ///
  /// In en, this message translates to:
  /// **'Receipt'**
  String get activityTypeReceipt;

  /// No description provided for @activityTypeManual.
  ///
  /// In en, this message translates to:
  /// **'Manual'**
  String get activityTypeManual;

  /// No description provided for @activityManualExpense.
  ///
  /// In en, this message translates to:
  /// **'Manual expense'**
  String get activityManualExpense;

  /// No description provided for @activityReceiptWithItems.
  ///
  /// In en, this message translates to:
  /// **'{source} · {count, plural, =1{1 item} other{{count} items}}'**
  String activityReceiptWithItems(String source, int count);

  /// No description provided for @recommendedActions.
  ///
  /// In en, this message translates to:
  /// **'Recommended actions'**
  String get recommendedActions;

  /// No description provided for @exploreDetails.
  ///
  /// In en, this message translates to:
  /// **'Explore details'**
  String get exploreDetails;

  /// No description provided for @productsInPriceHistoryCount.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 product in your price history} other{{count} products in your price history}}'**
  String productsInPriceHistoryCount(int count);

  /// No description provided for @priceInsightsEmptySubtitle.
  ///
  /// In en, this message translates to:
  /// **'Full price memory from your receipt line items'**
  String get priceInsightsEmptySubtitle;

  /// No description provided for @savingsOpportunities.
  ///
  /// In en, this message translates to:
  /// **'Savings opportunities'**
  String get savingsOpportunities;

  /// No description provided for @actionableOpportunitiesCount.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 actionable opportunity to review} other{{count} actionable opportunities to review}}'**
  String actionableOpportunitiesCount(int count);

  /// No description provided for @savingsOpportunitiesEmptySubtitle.
  ///
  /// In en, this message translates to:
  /// **'Products where you paid more than the best known price'**
  String get savingsOpportunitiesEmptySubtitle;

  /// No description provided for @loadingAnalytics.
  ///
  /// In en, this message translates to:
  /// **'Loading analytics…'**
  String get loadingAnalytics;

  /// No description provided for @couldNotLoadAnalytics.
  ///
  /// In en, this message translates to:
  /// **'Could not load analytics'**
  String get couldNotLoadAnalytics;

  /// No description provided for @signInForAnalytics.
  ///
  /// In en, this message translates to:
  /// **'View spending analytics with your Savingor account.'**
  String get signInForAnalytics;

  /// No description provided for @noSpendingDataYet.
  ///
  /// In en, this message translates to:
  /// **'No spending data yet'**
  String get noSpendingDataYet;

  /// No description provided for @noSpendingDataMessage.
  ///
  /// In en, this message translates to:
  /// **'Add a receipt or expense to see spending totals, store breakdowns, and trends.'**
  String get noSpendingDataMessage;

  /// No description provided for @addMoreReceiptsForSavingsValue.
  ///
  /// In en, this message translates to:
  /// **'Add more receipts to calculate your savings value.'**
  String get addMoreReceiptsForSavingsValue;

  /// No description provided for @storeHasSeveralBestPrices.
  ///
  /// In en, this message translates to:
  /// **'{store} has several of your best known prices'**
  String storeHasSeveralBestPrices(String store);

  /// No description provided for @trackedProductsLowestAtStore.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 tracked product currently has its lowest known price at {store}} other{{count} tracked products currently have their lowest known price at {store}}}'**
  String trackedProductsLowestAtStore(int count, String store);

  /// No description provided for @useStoreWhenMatchesRoute.
  ///
  /// In en, this message translates to:
  /// **'Use this store when it matches your shopping route'**
  String get useStoreWhenMatchesRoute;

  /// No description provided for @recentlyPaidLatestBestKnown.
  ///
  /// In en, this message translates to:
  /// **'You recently paid {latestPrice} at {latestStore}. Your best known price is {bestPrice} at {bestStore}.'**
  String recentlyPaidLatestBestKnown(String latestPrice, String latestStore,
      String bestPrice, String bestStore);

  /// No description provided for @basedOnPriceRecords.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{Based on 1 price record} other{Based on {count} price records}}'**
  String basedOnPriceRecords(int count);

  /// No description provided for @watchProductPrices.
  ///
  /// In en, this message translates to:
  /// **'Watch {product} prices closely'**
  String watchProductPrices(String product);

  /// No description provided for @knownPricesRangeFromTo.
  ///
  /// In en, this message translates to:
  /// **'Your known prices range from {low} to {high}.'**
  String knownPricesRangeFromTo(String low, String high);

  /// No description provided for @priceDifferenceAmount.
  ///
  /// In en, this message translates to:
  /// **'Price difference: {amount}'**
  String priceDifferenceAmount(String amount);

  /// No description provided for @productPriceInsights.
  ///
  /// In en, this message translates to:
  /// **'Product price insights'**
  String get productPriceInsights;

  /// No description provided for @productsInPriceHistoryFromReceipts.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 product in your price history from receipts} other{{count} products in your price history from receipts}}'**
  String productsInPriceHistoryFromReceipts(int count);

  /// No description provided for @latestPriceLabel.
  ///
  /// In en, this message translates to:
  /// **'Latest'**
  String get latestPriceLabel;

  /// No description provided for @bestKnownPriceLabel.
  ///
  /// In en, this message translates to:
  /// **'Best known'**
  String get bestKnownPriceLabel;

  /// No description provided for @highestPriceLabel.
  ///
  /// In en, this message translates to:
  /// **'Highest'**
  String get highestPriceLabel;

  /// No description provided for @averagePriceLabel.
  ///
  /// In en, this message translates to:
  /// **'Average'**
  String get averagePriceLabel;

  /// No description provided for @priceAtStore.
  ///
  /// In en, this message translates to:
  /// **'{price} at {store}'**
  String priceAtStore(String price, String store);

  /// No description provided for @signInForPriceMemory.
  ///
  /// In en, this message translates to:
  /// **'Sign in to view your product price memory.'**
  String get signInForPriceMemory;

  /// No description provided for @loadingPriceMemory.
  ///
  /// In en, this message translates to:
  /// **'Loading price memory…'**
  String get loadingPriceMemory;

  /// No description provided for @couldNotLoadPriceMemory.
  ///
  /// In en, this message translates to:
  /// **'Could not load price memory'**
  String get couldNotLoadPriceMemory;

  /// No description provided for @noPriceMemoryYet.
  ///
  /// In en, this message translates to:
  /// **'No price memory yet'**
  String get noPriceMemoryYet;

  /// No description provided for @noPriceMemoryMessage.
  ///
  /// In en, this message translates to:
  /// **'Add receipts with line items to start building your price memory.'**
  String get noPriceMemoryMessage;

  /// No description provided for @savingsOpportunitiesPaidMoreCount.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 actionable opportunity where you paid more than the best known price} other{{count} actionable opportunities where you paid more than the best known price}}'**
  String savingsOpportunitiesPaidMoreCount(int count);

  /// No description provided for @saveUpToPerItem.
  ///
  /// In en, this message translates to:
  /// **'Save up to {amount} per item'**
  String saveUpToPerItem(String amount);

  /// No description provided for @youPaidAtStore.
  ///
  /// In en, this message translates to:
  /// **'You paid {amount} at {store}'**
  String youPaidAtStore(String amount, String store);

  /// No description provided for @recommendationWatchProductBeforeBuying.
  ///
  /// In en, this message translates to:
  /// **'Recommendation: Watch this product before buying again.'**
  String get recommendationWatchProductBeforeBuying;

  /// No description provided for @recommendationBuyAtStoreNextTime.
  ///
  /// In en, this message translates to:
  /// **'Recommendation: Buy at {store} next time.'**
  String recommendationBuyAtStoreNextTime(String store);

  /// No description provided for @signInForSavingsOpportunities.
  ///
  /// In en, this message translates to:
  /// **'Sign in to see savings opportunities from your receipts.'**
  String get signInForSavingsOpportunities;

  /// No description provided for @loadingSavingsOpportunities.
  ///
  /// In en, this message translates to:
  /// **'Loading savings opportunities…'**
  String get loadingSavingsOpportunities;

  /// No description provided for @couldNotLoadSavingsOpportunities.
  ///
  /// In en, this message translates to:
  /// **'Could not load savings opportunities'**
  String get couldNotLoadSavingsOpportunities;

  /// No description provided for @noSavingsOpportunitiesYet.
  ///
  /// In en, this message translates to:
  /// **'No savings opportunities yet'**
  String get noSavingsOpportunitiesYet;

  /// No description provided for @noSavingsOpportunitiesMessage.
  ///
  /// In en, this message translates to:
  /// **'Add more receipts with line items so Savingor can compare prices across stores.'**
  String get noSavingsOpportunitiesMessage;

  /// No description provided for @recordsLabel.
  ///
  /// In en, this message translates to:
  /// **'Records'**
  String get recordsLabel;

  /// No description provided for @buyingAdvice.
  ///
  /// In en, this message translates to:
  /// **'Buying advice'**
  String get buyingAdvice;

  /// No description provided for @bestKnownPriceAdviceLabel.
  ///
  /// In en, this message translates to:
  /// **'Best known price'**
  String get bestKnownPriceAdviceLabel;

  /// No description provided for @latestPaidAdviceLabel.
  ///
  /// In en, this message translates to:
  /// **'Latest paid'**
  String get latestPaidAdviceLabel;

  /// No description provided for @buyItemAtStoreWhenFitsRoute.
  ///
  /// In en, this message translates to:
  /// **'Buy this item at {store} when it fits your shopping route.'**
  String buyItemAtStoreWhenFitsRoute(String store);

  /// No description provided for @buyItemAtBestPriceWhenFitsRoute.
  ///
  /// In en, this message translates to:
  /// **'Buy this item where you previously found the best price when it fits your shopping route.'**
  String get buyItemAtBestPriceWhenFitsRoute;

  /// No description provided for @addToShoppingList.
  ///
  /// In en, this message translates to:
  /// **'Add to shopping list'**
  String get addToShoppingList;

  /// No description provided for @priceHistory.
  ///
  /// In en, this message translates to:
  /// **'Price history'**
  String get priceHistory;

  /// No description provided for @productHistoryTitle.
  ///
  /// In en, this message translates to:
  /// **'Product history'**
  String get productHistoryTitle;

  /// No description provided for @productNotFound.
  ///
  /// In en, this message translates to:
  /// **'Product not found.'**
  String get productNotFound;

  /// No description provided for @buyingAdviceInsufficientHistory.
  ///
  /// In en, this message translates to:
  /// **'Add more receipts with this item to unlock smarter buying advice.'**
  String get buyingAdviceInsufficientHistory;

  /// No description provided for @buyingAdvicePaidBestPrice.
  ///
  /// In en, this message translates to:
  /// **'You paid your best known price.'**
  String get buyingAdvicePaidBestPrice;

  /// No description provided for @buyingAdviceNoBetterPriceYet.
  ///
  /// In en, this message translates to:
  /// **'No better known price yet.'**
  String get buyingAdviceNoBetterPriceYet;

  /// No description provided for @quantityLabelWithCount.
  ///
  /// In en, this message translates to:
  /// **'Qty {count}'**
  String quantityLabelWithCount(String count);

  /// No description provided for @addedToShoppingList.
  ///
  /// In en, this message translates to:
  /// **'Added to shopping list'**
  String get addedToShoppingList;

  /// No description provided for @alreadyInShoppingList.
  ///
  /// In en, this message translates to:
  /// **'Already in shopping list'**
  String get alreadyInShoppingList;

  /// No description provided for @quantityUpdatedSnack.
  ///
  /// In en, this message translates to:
  /// **'Quantity updated'**
  String get quantityUpdatedSnack;

  /// No description provided for @nearbyStores.
  ///
  /// In en, this message translates to:
  /// **'Nearby stores'**
  String get nearbyStores;

  /// No description provided for @nearbyStoresSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Find grocery stores near you and compare savings opportunities.'**
  String get nearbyStoresSubtitle;

  /// No description provided for @storesNearby.
  ///
  /// In en, this message translates to:
  /// **'Stores nearby'**
  String get storesNearby;

  /// No description provided for @mapStoresFoundCount.
  ///
  /// In en, this message translates to:
  /// **'{count} found'**
  String mapStoresFoundCount(int count);

  /// No description provided for @mapStoresFootnotePlaces.
  ///
  /// In en, this message translates to:
  /// **'Stores are based on your selected location and search radius.'**
  String get mapStoresFootnotePlaces;

  /// No description provided for @mapStoresFootnoteFallback.
  ///
  /// In en, this message translates to:
  /// **'Showing grocery stores based on your selected area.'**
  String get mapStoresFootnoteFallback;

  /// No description provided for @mapStoresFootnoteDefault.
  ///
  /// In en, this message translates to:
  /// **'Explore grocery stores near your chosen location.'**
  String get mapStoresFootnoteDefault;

  /// No description provided for @mapNoStoresWithinRadius.
  ///
  /// In en, this message translates to:
  /// **'No stores within {distance} km. Try a larger radius.'**
  String mapNoStoresWithinRadius(int distance);

  /// No description provided for @mapPleaseEnterCityOrArea.
  ///
  /// In en, this message translates to:
  /// **'Please enter a city or area.'**
  String get mapPleaseEnterCityOrArea;

  /// No description provided for @mapCouldNotOpenDirections.
  ///
  /// In en, this message translates to:
  /// **'Could not open directions.'**
  String get mapCouldNotOpenDirections;

  /// No description provided for @mapYourLocation.
  ///
  /// In en, this message translates to:
  /// **'Your location'**
  String get mapYourLocation;

  /// No description provided for @mapFindGroceryStoresNearYou.
  ///
  /// In en, this message translates to:
  /// **'Find grocery stores near you'**
  String get mapFindGroceryStoresNearYou;

  /// No description provided for @mapActive.
  ///
  /// In en, this message translates to:
  /// **'Active'**
  String get mapActive;

  /// No description provided for @mapSearchRadius.
  ///
  /// In en, this message translates to:
  /// **'Search radius'**
  String get mapSearchRadius;

  /// No description provided for @mapCheckingLocation.
  ///
  /// In en, this message translates to:
  /// **'Checking location...'**
  String get mapCheckingLocation;

  /// No description provided for @mapLocationSelected.
  ///
  /// In en, this message translates to:
  /// **'Location selected'**
  String get mapLocationSelected;

  /// No description provided for @mapLocationDetected.
  ///
  /// In en, this message translates to:
  /// **'Location detected'**
  String get mapLocationDetected;

  /// No description provided for @mapReadyToSearchNearby.
  ///
  /// In en, this message translates to:
  /// **'Ready to search nearby grocery stores.'**
  String get mapReadyToSearchNearby;

  /// No description provided for @mapCouldNotAccessLocation.
  ///
  /// In en, this message translates to:
  /// **'Could not access your location.'**
  String get mapCouldNotAccessLocation;

  /// No description provided for @mapEnableLocationPrompt.
  ///
  /// In en, this message translates to:
  /// **'Enable location to find grocery stores near you.'**
  String get mapEnableLocationPrompt;

  /// No description provided for @mapUseMyLocation.
  ///
  /// In en, this message translates to:
  /// **'Use my location'**
  String get mapUseMyLocation;

  /// No description provided for @mapEnterCityManually.
  ///
  /// In en, this message translates to:
  /// **'Enter city manually'**
  String get mapEnterCityManually;

  /// No description provided for @mapLocationServicesDisabled.
  ///
  /// In en, this message translates to:
  /// **'Location services are turned off.'**
  String get mapLocationServicesDisabled;

  /// No description provided for @mapLocationPermissionDenied.
  ///
  /// In en, this message translates to:
  /// **'Location permission denied.'**
  String get mapLocationPermissionDenied;

  /// No description provided for @mapCouldNotDetectLocation.
  ///
  /// In en, this message translates to:
  /// **'Could not detect your location. Please try again.'**
  String get mapCouldNotDetectLocation;

  /// No description provided for @mapSetYourLocation.
  ///
  /// In en, this message translates to:
  /// **'Set your location'**
  String get mapSetYourLocation;

  /// No description provided for @mapSetLocationGpsOrCity.
  ///
  /// In en, this message translates to:
  /// **'Use GPS or choose a city to view nearby stores.'**
  String get mapSetLocationGpsOrCity;

  /// No description provided for @mapCurrentLocation.
  ///
  /// In en, this message translates to:
  /// **'Current location'**
  String get mapCurrentLocation;

  /// No description provided for @directions.
  ///
  /// In en, this message translates to:
  /// **'Directions'**
  String get directions;

  /// No description provided for @mapStoreCategoryGrocery.
  ///
  /// In en, this message translates to:
  /// **'Grocery'**
  String get mapStoreCategoryGrocery;

  /// No description provided for @mapStoreCategorySupermarket.
  ///
  /// In en, this message translates to:
  /// **'Supermarket'**
  String get mapStoreCategorySupermarket;

  /// No description provided for @mapStoreCategoryWholesale.
  ///
  /// In en, this message translates to:
  /// **'Wholesale'**
  String get mapStoreCategoryWholesale;

  /// No description provided for @mapNearbyStoreStatus.
  ///
  /// In en, this message translates to:
  /// **'Nearby store'**
  String get mapNearbyStoreStatus;

  /// No description provided for @mapListedOnGooglePlaces.
  ///
  /// In en, this message translates to:
  /// **'Listed on Google Places'**
  String get mapListedOnGooglePlaces;

  /// No description provided for @mapRadiusKm.
  ///
  /// In en, this message translates to:
  /// **'{distance} km'**
  String mapRadiusKm(int distance);

  /// No description provided for @mapSetLocation.
  ///
  /// In en, this message translates to:
  /// **'Set location'**
  String get mapSetLocation;

  /// No description provided for @mapCityOrArea.
  ///
  /// In en, this message translates to:
  /// **'City or area'**
  String get mapCityOrArea;

  /// No description provided for @mapCityOrAreaExample.
  ///
  /// In en, this message translates to:
  /// **'Example: Calgary, Cochrane, Edmonton'**
  String get mapCityOrAreaExample;

  /// No description provided for @mapMarkerSnippetWithDetail.
  ///
  /// In en, this message translates to:
  /// **'{distance} · {detail}'**
  String mapMarkerSnippetWithDetail(String distance, String detail);

  /// No description provided for @aiSavingsAssistant.
  ///
  /// In en, this message translates to:
  /// **'AI Savings Assistant'**
  String get aiSavingsAssistant;

  /// No description provided for @aiSignInPrompt.
  ///
  /// In en, this message translates to:
  /// **'Sign in to ask the AI assistant about your receipts and shopping lists.'**
  String get aiSignInPrompt;

  /// No description provided for @aiLoadingYourData.
  ///
  /// In en, this message translates to:
  /// **'Loading your data…'**
  String get aiLoadingYourData;

  /// No description provided for @aiCouldNotLoadData.
  ///
  /// In en, this message translates to:
  /// **'Could not load your data'**
  String get aiCouldNotLoadData;

  /// No description provided for @aiEmptyTitle.
  ///
  /// In en, this message translates to:
  /// **'Add data to get AI insights'**
  String get aiEmptyTitle;

  /// No description provided for @aiEmptyMessage.
  ///
  /// In en, this message translates to:
  /// **'Scan a receipt, add an expense, or create a shopping list. The assistant analyzes your saved data — not live store prices.'**
  String get aiEmptyMessage;

  /// No description provided for @aiHeroTitle.
  ///
  /// In en, this message translates to:
  /// **'Your AI savings coach'**
  String get aiHeroTitle;

  /// No description provided for @aiHeroSubtitleLive.
  ///
  /// In en, this message translates to:
  /// **'Ask about spending, receipts, and shopping lists.'**
  String get aiHeroSubtitleLive;

  /// No description provided for @aiHeroSubtitlePreview.
  ///
  /// In en, this message translates to:
  /// **'Preview insights from your saved data — connect an API key for live answers.'**
  String get aiHeroSubtitlePreview;

  /// No description provided for @aiConfigReadyMessage.
  ///
  /// In en, this message translates to:
  /// **'AI assistant is ready. Connect an API key to enable live answers.'**
  String get aiConfigReadyMessage;

  /// No description provided for @aiDataSnapshot.
  ///
  /// In en, this message translates to:
  /// **'Your data snapshot'**
  String get aiDataSnapshot;

  /// No description provided for @aiReceiptCount.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 receipt} other{{count} receipts}}'**
  String aiReceiptCount(int count);

  /// No description provided for @aiExpenseCount.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 expense} other{{count} expenses}}'**
  String aiExpenseCount(int count);

  /// No description provided for @aiTotalSpendingLabel.
  ///
  /// In en, this message translates to:
  /// **'{amount} total'**
  String aiTotalSpendingLabel(String amount);

  /// No description provided for @aiListCount.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 list} other{{count} lists}}'**
  String aiListCount(int count);

  /// No description provided for @aiListEstimateLabel.
  ///
  /// In en, this message translates to:
  /// **'{amount} list est.'**
  String aiListEstimateLabel(String amount);

  /// No description provided for @aiSuggestedQuestions.
  ///
  /// In en, this message translates to:
  /// **'Suggested questions'**
  String get aiSuggestedQuestions;

  /// No description provided for @aiSuggestSaveMoreThisWeek.
  ///
  /// In en, this message translates to:
  /// **'How can I save more money this week?'**
  String get aiSuggestSaveMoreThisWeek;

  /// No description provided for @aiSuggestTopStore.
  ///
  /// In en, this message translates to:
  /// **'Which store do I spend the most at?'**
  String get aiSuggestTopStore;

  /// No description provided for @aiSuggestAnalyzeSpending.
  ///
  /// In en, this message translates to:
  /// **'Analyze my grocery spending.'**
  String get aiSuggestAnalyzeSpending;

  /// No description provided for @aiSuggestShoppingListPriority.
  ///
  /// In en, this message translates to:
  /// **'What should I buy first from my shopping list?'**
  String get aiSuggestShoppingListPriority;

  /// No description provided for @aiAnalyzingYourData.
  ///
  /// In en, this message translates to:
  /// **'Analyzing your data…'**
  String get aiAnalyzingYourData;

  /// No description provided for @aiCouldNotGetAnswer.
  ///
  /// In en, this message translates to:
  /// **'Could not get an answer. Please try again.'**
  String get aiCouldNotGetAnswer;

  /// No description provided for @aiInsightsDisclaimer.
  ///
  /// In en, this message translates to:
  /// **'Insights are based on your saved receipts, expenses, and shopping lists in Savingor — not live store prices or deals.'**
  String get aiInsightsDisclaimer;

  /// No description provided for @aiInputHintLive.
  ///
  /// In en, this message translates to:
  /// **'Ask about your spending or shopping list…'**
  String get aiInputHintLive;

  /// No description provided for @aiInputHintPreview.
  ///
  /// In en, this message translates to:
  /// **'Type a question — connect an API key for live answers'**
  String get aiInputHintPreview;

  /// No description provided for @aiRequestFailed.
  ///
  /// In en, this message translates to:
  /// **'AI request failed. Please try again.'**
  String get aiRequestFailed;

  /// No description provided for @aiEmptyResponse.
  ///
  /// In en, this message translates to:
  /// **'AI returned an empty response.'**
  String get aiEmptyResponse;

  /// No description provided for @aiSend.
  ///
  /// In en, this message translates to:
  /// **'Send'**
  String get aiSend;

  /// No description provided for @editProfile.
  ///
  /// In en, this message translates to:
  /// **'Edit profile'**
  String get editProfile;

  /// No description provided for @personalInformation.
  ///
  /// In en, this message translates to:
  /// **'Personal information'**
  String get personalInformation;

  /// No description provided for @editProfileFullNameHint.
  ///
  /// In en, this message translates to:
  /// **'Your full name'**
  String get editProfileFullNameHint;

  /// No description provided for @emailChangesNotAvailable.
  ///
  /// In en, this message translates to:
  /// **'Email changes are not available in this version.'**
  String get emailChangesNotAvailable;

  /// No description provided for @password.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get password;

  /// No description provided for @passwordNeverShown.
  ///
  /// In en, this message translates to:
  /// **'For security, your current password is never shown.'**
  String get passwordNeverShown;

  /// No description provided for @changePassword.
  ///
  /// In en, this message translates to:
  /// **'Change password'**
  String get changePassword;

  /// No description provided for @sendPasswordResetEmailInstead.
  ///
  /// In en, this message translates to:
  /// **'Send password reset email instead'**
  String get sendPasswordResetEmailInstead;

  /// No description provided for @sendingResetEmail.
  ///
  /// In en, this message translates to:
  /// **'Sending reset email...'**
  String get sendingResetEmail;

  /// No description provided for @changesSaved.
  ///
  /// In en, this message translates to:
  /// **'Changes saved'**
  String get changesSaved;

  /// No description provided for @couldNotSaveChanges.
  ///
  /// In en, this message translates to:
  /// **'Could not save changes'**
  String get couldNotSaveChanges;

  /// No description provided for @pleaseEnterFullName.
  ///
  /// In en, this message translates to:
  /// **'Please enter your full name'**
  String get pleaseEnterFullName;

  /// No description provided for @signInToEditProfile.
  ///
  /// In en, this message translates to:
  /// **'Sign in to edit your profile.'**
  String get signInToEditProfile;

  /// No description provided for @passwordResetEmailSent.
  ///
  /// In en, this message translates to:
  /// **'Reset email sent'**
  String get passwordResetEmailSent;

  /// No description provided for @changePasswordIntro.
  ///
  /// In en, this message translates to:
  /// **'To change your password inside the app, enter your current password first.'**
  String get changePasswordIntro;

  /// No description provided for @currentPassword.
  ///
  /// In en, this message translates to:
  /// **'Current password'**
  String get currentPassword;

  /// No description provided for @newPassword.
  ///
  /// In en, this message translates to:
  /// **'New password'**
  String get newPassword;

  /// No description provided for @confirmNewPassword.
  ///
  /// In en, this message translates to:
  /// **'Confirm new password'**
  String get confirmNewPassword;

  /// No description provided for @enterCurrentPasswordHint.
  ///
  /// In en, this message translates to:
  /// **'Enter current password'**
  String get enterCurrentPasswordHint;

  /// No description provided for @atLeast6CharactersHint.
  ///
  /// In en, this message translates to:
  /// **'At least 6 characters'**
  String get atLeast6CharactersHint;

  /// No description provided for @repeatNewPasswordHint.
  ///
  /// In en, this message translates to:
  /// **'Repeat new password'**
  String get repeatNewPasswordHint;

  /// No description provided for @currentPasswordRequired.
  ///
  /// In en, this message translates to:
  /// **'Current password is required'**
  String get currentPasswordRequired;

  /// No description provided for @newPasswordRequired.
  ///
  /// In en, this message translates to:
  /// **'New password is required'**
  String get newPasswordRequired;

  /// No description provided for @newPasswordMinLength.
  ///
  /// In en, this message translates to:
  /// **'New password must be at least 6 characters'**
  String get newPasswordMinLength;

  /// No description provided for @confirmNewPasswordRequired.
  ///
  /// In en, this message translates to:
  /// **'Please confirm your new password'**
  String get confirmNewPasswordRequired;

  /// No description provided for @passwordsDoNotMatch.
  ///
  /// In en, this message translates to:
  /// **'Passwords do not match'**
  String get passwordsDoNotMatch;

  /// No description provided for @updatePassword.
  ///
  /// In en, this message translates to:
  /// **'Update password'**
  String get updatePassword;

  /// No description provided for @forgotCurrentPassword.
  ///
  /// In en, this message translates to:
  /// **'Forgot your current password?'**
  String get forgotCurrentPassword;

  /// No description provided for @passwordResetSecureLink.
  ///
  /// In en, this message translates to:
  /// **'We\'ll send a secure reset link to your email so you can create a new password.'**
  String get passwordResetSecureLink;

  /// No description provided for @passwordResetByEmailHint.
  ///
  /// In en, this message translates to:
  /// **'If you don\'t remember it, use password reset by email.'**
  String get passwordResetByEmailHint;

  /// No description provided for @sendResetEmail.
  ///
  /// In en, this message translates to:
  /// **'Send reset email'**
  String get sendResetEmail;

  /// No description provided for @sending.
  ///
  /// In en, this message translates to:
  /// **'Sending...'**
  String get sending;

  /// No description provided for @passwordUpdated.
  ///
  /// In en, this message translates to:
  /// **'Password updated'**
  String get passwordUpdated;

  /// No description provided for @showPassword.
  ///
  /// In en, this message translates to:
  /// **'Show password'**
  String get showPassword;

  /// No description provided for @hidePassword.
  ///
  /// In en, this message translates to:
  /// **'Hide password'**
  String get hidePassword;

  /// No description provided for @signInToChangePassword.
  ///
  /// In en, this message translates to:
  /// **'You need to be signed in to change your password.'**
  String get signInToChangePassword;

  /// No description provided for @currentPasswordIncorrect.
  ///
  /// In en, this message translates to:
  /// **'Current password is incorrect'**
  String get currentPasswordIncorrect;

  /// No description provided for @passwordTooWeak.
  ///
  /// In en, this message translates to:
  /// **'Password is too weak'**
  String get passwordTooWeak;

  /// No description provided for @recentLoginRequired.
  ///
  /// In en, this message translates to:
  /// **'For security, please sign in again and retry.'**
  String get recentLoginRequired;

  /// No description provided for @tooManyAttempts.
  ///
  /// In en, this message translates to:
  /// **'Too many attempts. Please try again later.'**
  String get tooManyAttempts;

  /// No description provided for @couldNotUpdatePassword.
  ///
  /// In en, this message translates to:
  /// **'Could not update password'**
  String get couldNotUpdatePassword;

  /// No description provided for @noEmailLinked.
  ///
  /// In en, this message translates to:
  /// **'No email is linked to this account.'**
  String get noEmailLinked;

  /// No description provided for @couldNotSendResetEmail.
  ///
  /// In en, this message translates to:
  /// **'Could not send reset email'**
  String get couldNotSendResetEmail;

  /// No description provided for @plans.
  ///
  /// In en, this message translates to:
  /// **'Plans'**
  String get plans;

  /// No description provided for @freeTodayProWhenReady.
  ///
  /// In en, this message translates to:
  /// **'Free today · Pro when ready'**
  String get freeTodayProWhenReady;

  /// No description provided for @saveSmarterWithAi.
  ///
  /// In en, this message translates to:
  /// **'Save smarter with AI'**
  String get saveSmarterWithAi;

  /// No description provided for @unlockProFeaturesDescription.
  ///
  /// In en, this message translates to:
  /// **'Unlock AI savings insights, receipt analytics, smart alerts, and deeper spending reports.'**
  String get unlockProFeaturesDescription;

  /// No description provided for @bestValue.
  ///
  /// In en, this message translates to:
  /// **'Best value'**
  String get bestValue;

  /// No description provided for @basicDealsBrowsing.
  ///
  /// In en, this message translates to:
  /// **'Basic deals browsing'**
  String get basicDealsBrowsing;

  /// No description provided for @manualExpenseTracking.
  ///
  /// In en, this message translates to:
  /// **'Manual expense tracking'**
  String get manualExpenseTracking;

  /// No description provided for @aiPoweredToolsDescription.
  ///
  /// In en, this message translates to:
  /// **'AI-powered tools for smarter grocery savings.'**
  String get aiPoweredToolsDescription;

  /// No description provided for @receiptAnalytics.
  ///
  /// In en, this message translates to:
  /// **'Receipt analytics'**
  String get receiptAnalytics;

  /// No description provided for @smartSavingsInsights.
  ///
  /// In en, this message translates to:
  /// **'Smart savings insights'**
  String get smartSavingsInsights;

  /// No description provided for @spendingReports.
  ///
  /// In en, this message translates to:
  /// **'Spending reports'**
  String get spendingReports;

  /// No description provided for @smartAlerts.
  ///
  /// In en, this message translates to:
  /// **'Smart alerts'**
  String get smartAlerts;

  /// No description provided for @startProSubscription.
  ///
  /// In en, this message translates to:
  /// **'Start Pro subscription'**
  String get startProSubscription;

  /// No description provided for @restorePurchases.
  ///
  /// In en, this message translates to:
  /// **'Restore purchases'**
  String get restorePurchases;

  /// No description provided for @restoring.
  ///
  /// In en, this message translates to:
  /// **'Restoring...'**
  String get restoring;

  /// No description provided for @proSubscriptionActivated.
  ///
  /// In en, this message translates to:
  /// **'Subscription activated'**
  String get proSubscriptionActivated;

  /// No description provided for @proDemoFallbackActivated.
  ///
  /// In en, this message translates to:
  /// **'Pro demo activated — no real payment processed.'**
  String get proDemoFallbackActivated;

  /// No description provided for @couldNotCompletePurchase.
  ///
  /// In en, this message translates to:
  /// **'Could not complete the purchase. Please try again.'**
  String get couldNotCompletePurchase;

  /// No description provided for @couldNotActivateProDemo.
  ///
  /// In en, this message translates to:
  /// **'Could not activate Pro demo. Please try again.'**
  String get couldNotActivateProDemo;

  /// No description provided for @purchaseRestored.
  ///
  /// In en, this message translates to:
  /// **'Purchase restored'**
  String get purchaseRestored;

  /// No description provided for @noPurchasesFound.
  ///
  /// In en, this message translates to:
  /// **'No purchases found'**
  String get noPurchasesFound;

  /// No description provided for @couldNotRestorePurchases.
  ///
  /// In en, this message translates to:
  /// **'Could not restore purchases'**
  String get couldNotRestorePurchases;

  /// No description provided for @subscriptionSetup.
  ///
  /// In en, this message translates to:
  /// **'Subscription setup'**
  String get subscriptionSetup;

  /// No description provided for @subscriptionSetupPrepared.
  ///
  /// In en, this message translates to:
  /// **'Savingor Pro is prepared for real in-app subscription integration.'**
  String get subscriptionSetupPrepared;

  /// No description provided for @subscriptionSetupNotConfigured.
  ///
  /// In en, this message translates to:
  /// **'Payment provider keys or store products are not configured in this build.'**
  String get subscriptionSetupNotConfigured;

  /// No description provided for @activateProDemoForTesting.
  ///
  /// In en, this message translates to:
  /// **'Activate Pro demo for testing'**
  String get activateProDemoForTesting;

  /// No description provided for @demoFallbackActive.
  ///
  /// In en, this message translates to:
  /// **'Demo fallback active — no real payment processed.'**
  String get demoFallbackActive;

  /// No description provided for @subscriptionPlanLabel.
  ///
  /// In en, this message translates to:
  /// **'Plan'**
  String get subscriptionPlanLabel;

  /// No description provided for @pricePerMonth.
  ///
  /// In en, this message translates to:
  /// **'{price} / month'**
  String pricePerMonth(String price);

  /// No description provided for @active.
  ///
  /// In en, this message translates to:
  /// **'Active'**
  String get active;

  /// No description provided for @activeDemo.
  ///
  /// In en, this message translates to:
  /// **'Active demo'**
  String get activeDemo;

  /// No description provided for @cancelled.
  ///
  /// In en, this message translates to:
  /// **'Cancelled'**
  String get cancelled;

  /// No description provided for @unknown.
  ///
  /// In en, this message translates to:
  /// **'Unknown'**
  String get unknown;

  /// No description provided for @demoMode.
  ///
  /// In en, this message translates to:
  /// **'Demo mode'**
  String get demoMode;

  /// No description provided for @providerNone.
  ///
  /// In en, this message translates to:
  /// **'None'**
  String get providerNone;

  /// No description provided for @revenueCatLabel.
  ///
  /// In en, this message translates to:
  /// **'RevenueCat'**
  String get revenueCatLabel;

  /// No description provided for @subscriptionManagedByStore.
  ///
  /// In en, this message translates to:
  /// **'Your subscription is managed by App Store or Google Play. You can cancel or update it from your store subscription settings.'**
  String get subscriptionManagedByStore;

  /// No description provided for @manageInAppStoreGooglePlay.
  ///
  /// In en, this message translates to:
  /// **'Manage in App Store / Google Play'**
  String get manageInAppStoreGooglePlay;

  /// No description provided for @cancelProDemo.
  ///
  /// In en, this message translates to:
  /// **'Cancel Pro demo'**
  String get cancelProDemo;

  /// No description provided for @noActiveSubscription.
  ///
  /// In en, this message translates to:
  /// **'No active subscription'**
  String get noActiveSubscription;

  /// No description provided for @proDemoCancelled.
  ///
  /// In en, this message translates to:
  /// **'Pro demo cancelled. You are back on the Free plan.'**
  String get proDemoCancelled;

  /// No description provided for @couldNotCancelProDemo.
  ///
  /// In en, this message translates to:
  /// **'Could not cancel Pro demo. Please try again.'**
  String get couldNotCancelProDemo;

  /// No description provided for @couldNotOpenSubscriptionManagement.
  ///
  /// In en, this message translates to:
  /// **'Could not open the subscription management page.'**
  String get couldNotOpenSubscriptionManagement;

  /// No description provided for @managementNotAvailable.
  ///
  /// In en, this message translates to:
  /// **'Management not available'**
  String get managementNotAvailable;

  /// No description provided for @managementUrlUnavailableMessage.
  ///
  /// In en, this message translates to:
  /// **'Subscription management URL is not available in this test build. For RevenueCat Test Store purchases, reset the test customer in the RevenueCat dashboard or use a new test user.'**
  String get managementUrlUnavailableMessage;

  /// No description provided for @paymentProviderNotConfiguredSnack.
  ///
  /// In en, this message translates to:
  /// **'Payment provider is not configured in this local build.'**
  String get paymentProviderNotConfiguredSnack;

  /// No description provided for @purchaseCancelled.
  ///
  /// In en, this message translates to:
  /// **'Purchase cancelled'**
  String get purchaseCancelled;

  /// No description provided for @purchaseFailed.
  ///
  /// In en, this message translates to:
  /// **'Purchase failed'**
  String get purchaseFailed;

  /// No description provided for @productUnavailable.
  ///
  /// In en, this message translates to:
  /// **'Product unavailable'**
  String get productUnavailable;

  /// No description provided for @purchaseNotActiveYet.
  ///
  /// In en, this message translates to:
  /// **'Purchase completed but Pro is not active yet. Try Restore purchases.'**
  String get purchaseNotActiveYet;

  /// No description provided for @networkErrorTryAgain.
  ///
  /// In en, this message translates to:
  /// **'Check your connection and try again'**
  String get networkErrorTryAgain;

  /// No description provided for @signInToManageSubscription.
  ///
  /// In en, this message translates to:
  /// **'You need to be signed in to manage your subscription.'**
  String get signInToManageSubscription;

  /// No description provided for @couldNotUpdateSubscription.
  ///
  /// In en, this message translates to:
  /// **'Could not update your subscription. Please try again.'**
  String get couldNotUpdateSubscription;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>[
        'de',
        'en',
        'es',
        'fr',
        'ru',
        'uk'
      ].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'de':
      return AppLocalizationsDe();
    case 'en':
      return AppLocalizationsEn();
    case 'es':
      return AppLocalizationsEs();
    case 'fr':
      return AppLocalizationsFr();
    case 'ru':
      return AppLocalizationsRu();
    case 'uk':
      return AppLocalizationsUk();
  }

  throw FlutterError(
      'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
      'an issue with the localizations generation tool. Please file an issue '
      'on GitHub with a reproducible sample app and the gen-l10n configuration '
      'that was used.');
}
