import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appName => 'Savingor';

  @override
  String get appSubtitle => 'Local offers and smart savings';

  @override
  String get home => 'Home';

  @override
  String get deals => 'Deals';

  @override
  String get receipts => 'Receipts';

  @override
  String get analytics => 'Analytics';

  @override
  String get profile => 'Profile';

  @override
  String get scanner => 'Receipt scanner';

  @override
  String get shopping => 'Shopping list';

  @override
  String get saved => 'Saved';

  @override
  String get storesMap => 'Map';

  @override
  String get aiAssistant => 'AI';

  @override
  String get scanReceipt => 'Scan receipt';

  @override
  String get dealsMap => 'Deals map';

  @override
  String get receiptScanner => 'Receipt scanner';

  @override
  String get shoppingList => 'Shopping list';

  @override
  String get mvp => 'MVP v0.1';

  @override
  String get searchHint => 'Search deals or stores...';

  @override
  String get filter => 'Filter';

  @override
  String get dealsMapSubtitle => 'Shows nearby deals';

  @override
  String get receiptScannerSubtitle => 'Scan a receipt';

  @override
  String get shoppingListSubtitle => 'Smart list';

  @override
  String dealsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count deals',
      one: '1 deal',
    );
    return '$_temp0';
  }

  @override
  String get noDealsFound => 'No deals found';

  @override
  String get resetFilters => 'Reset filters';

  @override
  String get filtersTitle => 'Filters';

  @override
  String get stores => 'Stores';

  @override
  String get maxPrice => 'Max price';

  @override
  String get sort => 'Sort';

  @override
  String get none => 'None';

  @override
  String get priceLowHigh => 'Price: low to high';

  @override
  String get priceHighLow => 'Price: high to low';

  @override
  String get dealDetails => 'Deal details';

  @override
  String get dealNotFound => 'Deal not found';

  @override
  String get saveDeal => 'Save deal';

  @override
  String get removeSaved => 'Remove saved';

  @override
  String get noSavedDeals => 'No saved deals yet';

  @override
  String get savedHint => 'Saved deals will appear here';

  @override
  String get cancel => 'Cancel';

  @override
  String get apply => 'Apply';

  @override
  String get save => 'Save';

  @override
  String get back => 'Back';

  @override
  String get close => 'Close';

  @override
  String get signOut => 'Sign out';

  @override
  String get loading => 'Loading...';

  @override
  String get tryAgain => 'Try again';

  @override
  String get comingSoon => 'Coming soon';

  @override
  String get continueButton => 'Continue';

  @override
  String get edit => 'Edit';

  @override
  String get ok => 'OK';

  @override
  String get chooseYourLanguage => 'Choose your language';

  @override
  String get chooseLanguageSubtitle =>
      'Select the language you want Savingor to use.';

  @override
  String get langSubtitleOnboarding =>
      'This helps personalize your Savingor experience.';

  @override
  String get applyLanguage => 'Apply language';

  @override
  String welcomeBackName(String name) {
    return 'Welcome back, $name! 👋';
  }

  @override
  String get welcomeBack => 'Welcome back! 👋';

  @override
  String get readyToSaveSmarterToday => 'Ready to save smarter today?';

  @override
  String get totalExpenses => 'Total expenses';

  @override
  String get trackedInSavingor => 'Tracked in Savingor';

  @override
  String expensesTracked(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count expenses tracked',
      one: '1 expense tracked',
    );
    return '$_temp0';
  }

  @override
  String get startSaving => 'Start saving';

  @override
  String get startSavingHero => '✨ START SAVING';

  @override
  String get thisMonth => 'This month';

  @override
  String get spent => 'spent';

  @override
  String get recorded => 'recorded';

  @override
  String get lists => 'lists';

  @override
  String get activeDeals => 'Active deals';

  @override
  String get estimated => 'estimated';

  @override
  String get monthlyGoal => 'Monthly goal';

  @override
  String get noRecentActivity => 'No recent activity';

  @override
  String get expenseAdded => 'Expense added';

  @override
  String get addExpenseToSeeHere => 'Add an expense to see it here';

  @override
  String get yourSavingsSnapshot => 'Your savings snapshot';

  @override
  String get thisMonthSpent => 'This month spent';

  @override
  String get potentialSavingsFound => 'Potential savings found';

  @override
  String get productsTracked => 'Products tracked';

  @override
  String get bestActionNow => 'Best action now';

  @override
  String get addMoreReceiptsForSavings =>
      'Add more receipts to unlock personalized savings.';

  @override
  String get account => 'Account';

  @override
  String get yourAccount => 'Your account';

  @override
  String get planAndSubscription => 'Plan & subscription';

  @override
  String get appSettings => 'App settings';

  @override
  String get region => 'Region';

  @override
  String get language => 'Language';

  @override
  String get appearance => 'Appearance';

  @override
  String get currency => 'Currency';

  @override
  String get notifications => 'Notifications';

  @override
  String get loadingProfile => 'Loading profile...';

  @override
  String get noProfileFound => 'No profile found for this account yet.';

  @override
  String get fullName => 'Full name';

  @override
  String get email => 'Email';

  @override
  String get passwordAndSecurity => 'Password & security';

  @override
  String get managePassword => 'Manage password';

  @override
  String get currentPlan => 'Current plan';

  @override
  String get proPlan => 'Pro plan';

  @override
  String get freePlan => 'Free plan';

  @override
  String get pro => 'Pro';

  @override
  String get free => 'Free';

  @override
  String get status => 'Status';

  @override
  String get provider => 'Provider';

  @override
  String get price => 'Price';

  @override
  String get priceMonthly => '\$14.99 / month';

  @override
  String get inactive => 'Inactive';

  @override
  String get freePlanUpgradeMessage =>
      'You are currently on the Free plan. Upgrade to Pro to unlock AI savings insights, receipt analytics, smart alerts, and spending reports.';

  @override
  String get manageSubscription => 'Manage subscription';

  @override
  String get viewPlans => 'View plans';

  @override
  String get manageSettings => 'Manage settings';

  @override
  String get signOutQuestion => 'Sign out?';

  @override
  String get signOutMessage =>
      'You will need to sign in again to access your Savingor account.';

  @override
  String get couldNotLoadProfile =>
      'Could not load your profile. Please try again.';

  @override
  String get personalizeSavingor => 'Personalize Savingor';

  @override
  String get personalizeSavingorSubtitle =>
      'Choose how the app looks, communicates, and adapts to your location.';

  @override
  String get preferences => 'Preferences';

  @override
  String get appLanguage => 'App language';

  @override
  String get appearanceHelper => 'Choose how Savingor looks';

  @override
  String get regionHelper => 'Used for nearby stores and local deals';

  @override
  String get currencyHelper => 'Used for prices, budgets, and reports';

  @override
  String get smartSavingsAlerts => 'Smart savings alerts';

  @override
  String get smartSavingsAlertsDescription =>
      'Get notified about savings opportunities, budget progress, and important recommendations.';

  @override
  String get regionCanada => 'Canada';

  @override
  String get regionUnitedStates => 'United States';

  @override
  String get appearanceLight => 'Light';

  @override
  String get appearanceDark => 'Dark';

  @override
  String get topSavingOpportunities => 'Top saving opportunities';

  @override
  String get seeAll => 'See all';

  @override
  String bestKnownAtStore(String amount, String store) {
    return 'Best known: $amount at $store';
  }

  @override
  String latestPaidAtStore(String amount, String store) {
    return 'Latest paid: $amount at $store';
  }

  @override
  String saveUpToAmount(String amount) {
    return 'Save up to $amount';
  }

  @override
  String get basedOnReceiptHistory => 'Based on receipt history';

  @override
  String buyProductAtStoreNextTime(String product, String store) {
    return 'Buy $product at $store next time';
  }

  @override
  String potentialSavingPerItem(String amount) {
    return 'Potential saving: $amount per item';
  }

  @override
  String get productBread => 'Bread';

  @override
  String get productMilk => 'Milk';

  @override
  String get delete => 'Delete';

  @override
  String get signIn => 'Sign in';

  @override
  String get signInRequired => 'Sign in required';

  @override
  String get store => 'Store';

  @override
  String get date => 'Date';

  @override
  String get total => 'Total';

  @override
  String get items => 'Items';

  @override
  String get notes => 'Notes';

  @override
  String get amount => 'Amount';

  @override
  String get category => 'Category';

  @override
  String get scanReceiptSubtitle =>
      'Scan a grocery receipt to track expenses and savings.';

  @override
  String get addManually => 'Add manually';

  @override
  String recentReceipts(int count) {
    return 'Recent receipts ($count)';
  }

  @override
  String get noReceiptsYet =>
      'No receipts yet. Scan or add one to start tracking.';

  @override
  String get deleteReceiptQuestion => 'Delete receipt?';

  @override
  String get deleteReceipt => 'Delete receipt';

  @override
  String deleteReceiptConfirmMessage(String store, String total) {
    return '$store ($total) will be permanently removed.';
  }

  @override
  String get loadingReceipts => 'Loading receipts...';

  @override
  String get couldNotLoadReceipts => 'Could not load receipts';

  @override
  String get signInToSyncReceipts =>
      'Save and sync your receipts with your Savingor account.';

  @override
  String get chooseReceiptSource => 'Choose how you want to add your receipt.';

  @override
  String get takePhoto => 'Take a photo';

  @override
  String get takePhotoSubtitle => 'Use your camera to scan a receipt.';

  @override
  String get chooseFromGallery => 'Choose from gallery';

  @override
  String get chooseFromGallerySubtitle => 'Select an existing receipt photo.';

  @override
  String get scanningReceipt => 'Scanning receipt...';

  @override
  String get couldNotScanReceipt =>
      'Could not scan this receipt. Try another photo.';

  @override
  String get ocrResultPreview => 'OCR result preview';

  @override
  String get noTextDetected => 'No text detected. Try a clearer receipt photo.';

  @override
  String get useThisReceipt => 'Use this receipt';

  @override
  String get noneDetected => 'None detected';

  @override
  String get rawOcrText => 'Raw OCR text';

  @override
  String get itemsColon => 'Items:';

  @override
  String get addReceipt => 'Add receipt';

  @override
  String get editReceipt => 'Edit receipt';

  @override
  String get saveReceipt => 'Save receipt';

  @override
  String get updateReceipt => 'Update receipt';

  @override
  String get storeName => 'Store name';

  @override
  String get storeAddressOptional => 'Store address (optional)';

  @override
  String get purchaseDate => 'Purchase date';

  @override
  String get categorySummary => 'Category summary';

  @override
  String get grocery => 'Grocery';

  @override
  String get subtotalOptional => 'Subtotal (optional)';

  @override
  String get taxOptional => 'Tax (optional)';

  @override
  String get receiptTotal => 'Receipt total';

  @override
  String get autoCalculatedFromItems =>
      'Auto-calculated from items unless you edit this field.';

  @override
  String get notesOptional => 'Notes (optional)';

  @override
  String get addItem => 'Add item';

  @override
  String get addLineItemsHint =>
      'Add line items to build a real receipt record for price tracking later.';

  @override
  String get enterStoreName => 'Enter a store name';

  @override
  String get selectPurchaseDate => 'Select a purchase date';

  @override
  String get enterTotalAmount => 'Enter the total amount';

  @override
  String get enterValidAmount => 'Enter a valid amount';

  @override
  String get enterValidTotalAmount => 'Enter a valid total amount.';

  @override
  String get receiptNotFound => 'Receipt not found.';

  @override
  String get item => 'Item';

  @override
  String get itemName => 'Item name';

  @override
  String get enterItemName => 'Enter an item name';

  @override
  String get qty => 'Qty';

  @override
  String get invalidValue => 'Invalid';

  @override
  String get removeItem => 'Remove item';

  @override
  String get categoryOptional => 'Category (optional)';

  @override
  String get receiptDetails => 'Receipt details';

  @override
  String subtotalLabel(String amount) {
    return 'Subtotal: $amount';
  }

  @override
  String taxLabel(String amount) {
    return 'Tax: $amount';
  }

  @override
  String get noItemsSaved => 'No items saved';

  @override
  String get noLineItemsSaved =>
      'No line items were saved for this receipt yet.';

  @override
  String qtyWithValue(String quantity) {
    return 'Qty $quantity';
  }

  @override
  String get couldNotDeleteReceipt =>
      'Could not delete the receipt. Please try again.';

  @override
  String get saveChanges => 'Save changes';

  @override
  String get receiptSourceManual => 'Manual';

  @override
  String get receiptSourceScanned => 'Scanned';

  @override
  String get receiptSourceGallery => 'Gallery';

  @override
  String get receiptSourceImported => 'Imported';

  @override
  String get receiptSourceShoppingList => 'Shopping list';

  @override
  String get receiptSourceUnknown => 'Receipt';

  @override
  String get scanNotes => 'Scan notes';

  @override
  String get galleryScanNotes => 'Gallery scan notes';

  @override
  String get importNotes => 'Import notes';

  @override
  String get tripNotes => 'Trip notes';

  @override
  String get couldNotLoadYourReceipts =>
      'Could not load your receipts. Please try again.';

  @override
  String get signInToSaveReceipts => 'Sign in to save receipts.';

  @override
  String get couldNotSaveReceipt =>
      'Could not save the receipt. Please try again.';

  @override
  String get couldNotUpdateReceipt =>
      'Could not update the receipt. Please try again.';

  @override
  String get signInToUpdateReceipts => 'Sign in to update receipts.';

  @override
  String receiptItemsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count items',
      one: '1 item',
      zero: '0 items',
    );
    return '$_temp0';
  }

  @override
  String get processingReceipt => 'Processing receipt';

  @override
  String get readingReceipt => 'Reading receipt';

  @override
  String get recognizingText => 'Recognizing text';

  @override
  String get receiptScannedSuccessfully => 'Receipt scanned successfully';

  @override
  String get noTextRecognized => 'No text recognized';

  @override
  String get couldNotReadReceipt => 'Could not read this receipt';

  @override
  String get imageTooBlurry => 'Image is too blurry';

  @override
  String get tryAnotherPhoto => 'Please try another photo';

  @override
  String get cameraPermissionRequired => 'Camera permission is required';

  @override
  String get galleryPermissionRequired => 'Gallery access is required';

  @override
  String get permissionDenied => 'Permission denied';

  @override
  String get openSettings => 'Open settings';

  @override
  String get chooseSavingAction => 'Choose what you want to do';

  @override
  String get addGroceryExpense => 'Add grocery expense';

  @override
  String get addGroceryExpenseSubtitle => 'Record a purchase manually';

  @override
  String get createShoppingListAction => 'Create shopping list';

  @override
  String get createShoppingListSubtitle => 'Plan what you need before shopping';

  @override
  String get optimizeShoppingBasket => 'Optimize shopping basket';

  @override
  String get optimizeShoppingBasketSubtitle =>
      'Find opportunities to spend less';

  @override
  String get finalizeShoppingTrip => 'Finalize shopping trip';

  @override
  String get finalizeShoppingTripSubtitle => 'Complete your shopping activity';

  @override
  String get monthlyGoalBudget => 'Monthly goal / Budget';

  @override
  String get monthlyGoalBudgetSubtitle => 'Set or update your monthly target';

  @override
  String get savingsAnalytics => 'Savings analytics';

  @override
  String get savingsAnalyticsSubtitle => 'Review your savings and spending';

  @override
  String get open => 'Open';

  @override
  String get expenses => 'Expenses';

  @override
  String get addExpense => 'Add expense';

  @override
  String get loadingExpenses => 'Loading expenses...';

  @override
  String get couldNotLoadExpenses => 'Could not load expenses';

  @override
  String get couldNotLoadYourExpenses =>
      'Could not load your expenses. Please try again.';

  @override
  String get noExpensesYet => 'No expenses yet';

  @override
  String get noExpensesYetMessage =>
      'Track grocery purchases and receipts to understand your spending.';

  @override
  String get signInToSyncExpenses =>
      'Save and sync your expenses with your Savingor account.';

  @override
  String get deleteExpenseQuestion => 'Delete expense?';

  @override
  String deleteExpenseConfirmMessage(String store, String amount) {
    return '\"$store\" ($amount) will be permanently removed.';
  }

  @override
  String get saveExpense => 'Save expense';

  @override
  String get totalAmount => 'Total amount';

  @override
  String get signInToSaveExpenses => 'Sign in to save expenses.';

  @override
  String get couldNotSaveExpense =>
      'Could not save the expense. Please try again.';

  @override
  String get couldNotDeleteExpense =>
      'Could not delete the expense. Please try again.';

  @override
  String get expenseSaved => 'Expense saved.';

  @override
  String get uncategorized => 'Uncategorized';

  @override
  String get recentExpenses => 'Recent expenses';

  @override
  String get noExpensesAddedYet => 'No expenses added yet.';

  @override
  String get pleaseEnterStoreName => 'Please enter a store name.';

  @override
  String get pleaseEnterItemName => 'Please enter an item name.';

  @override
  String get pleaseEnterPrice => 'Please enter a price.';

  @override
  String get pleaseEnterValidPrice => 'Please enter a valid price.';

  @override
  String expenseCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count expenses',
      one: '1 expense',
      zero: '0 expenses',
    );
    return '$_temp0';
  }

  @override
  String get newShoppingList => 'New shopping list';

  @override
  String get newList => 'New list';

  @override
  String get createList => 'Create list';

  @override
  String get loadingShoppingLists => 'Loading shopping lists...';

  @override
  String get couldNotLoadLists => 'Could not load lists';

  @override
  String get couldNotLoadYourShoppingLists =>
      'Could not load your shopping lists. Please try again.';

  @override
  String get noShoppingListsYet => 'No shopping lists yet';

  @override
  String get noShoppingListsYetMessage =>
      'Create your first list to plan purchases and optimize your basket.';

  @override
  String get signInToSyncShoppingLists =>
      'Create and sync shopping lists with your Savingor account.';

  @override
  String get deleteListQuestion => 'Delete list?';

  @override
  String deleteListConfirmMessage(String title) {
    return '\"$title\" will be permanently removed.';
  }

  @override
  String get deleteList => 'Delete list';

  @override
  String get optimizeAllLists => 'Optimize all lists';

  @override
  String get optimizeAllListsSubtitle =>
      'Find the best known stores across your active shopping lists';

  @override
  String get optimizeThisBasket => 'Optimize this basket';

  @override
  String get optimizeThisBasketSubtitle =>
      'Find the best known stores for this list';

  @override
  String get listNotFound => 'List not found';

  @override
  String get listNotFoundMessage => 'This shopping list may have been deleted.';

  @override
  String get backToLists => 'Back to lists';

  @override
  String get noShoppingItemsYet => 'No items yet';

  @override
  String get noShoppingItemsYetMessage =>
      'Add items to this list to track what you need.';

  @override
  String get shoppingListEmptyMessage =>
      'Create and manage your smart shopping lists here.';

  @override
  String get purchased => 'Purchased';

  @override
  String get clearPurchased => 'Clear purchased';

  @override
  String get estimatedTotalLabel => 'Estimated total';

  @override
  String estimatedShort(String amount) {
    return 'Est. $amount';
  }

  @override
  String activeCountLabel(int count) {
    return '$count active';
  }

  @override
  String purchasedSummary(int count) {
    return '$count purchased';
  }

  @override
  String itemsTotalSummary(int count) {
    return '$count items total';
  }

  @override
  String get allItemsPurchased => 'All items purchased';

  @override
  String get saveItem => 'Save item';

  @override
  String get listTitle => 'List title';

  @override
  String get enterListTitle => 'Enter a list title';

  @override
  String get listName => 'List name';

  @override
  String get enterListName => 'Enter a list name';

  @override
  String get newShoppingListHint =>
      'Give your list a name. You can add items after creating it.';

  @override
  String get itemsOptional => 'Items (optional)';

  @override
  String get addAnotherItem => 'Add another item';

  @override
  String get storeOptional => 'Store (optional)';

  @override
  String get priceOptional => 'Price (optional)';

  @override
  String get loadingListItems => 'Loading list items...';

  @override
  String get loadingShoppingList => 'Loading shopping list...';

  @override
  String get couldNotLoadItems => 'Could not load items';

  @override
  String get couldNotLoadListItems =>
      'Could not load list items. Please try again.';

  @override
  String get createAnotherReceiptQuestion => 'Create another receipt?';

  @override
  String get createAnotherReceiptMessage =>
      'This list may already have a receipt. Create another receipt from purchased items?';

  @override
  String get createReceipt => 'Create receipt';

  @override
  String get signInToFinalizeTrip => 'Sign in to finalize a shopping trip.';

  @override
  String get noListsReadyToFinalize => 'No lists ready to finalize';

  @override
  String get noListsReadyToFinalizeMessage =>
      'Mark items as purchased on a shopping list, then return here to create a receipt.';

  @override
  String get openShoppingLists => 'Open shopping lists';

  @override
  String get selectListToFinalize => 'Select list to finalize';

  @override
  String get selectListToFinalizeSubtitle =>
      'Choose a shopping list with purchased items.';

  @override
  String get finalizeShoppingTripCardSubtitle =>
      'Create a receipt from purchased items and update your price history';

  @override
  String get done => 'Done';

  @override
  String get optional => 'Optional';

  @override
  String get somethingWentWrong => 'Something went wrong';

  @override
  String get saving => 'Saving...';

  @override
  String get loadingPurchasedItems => 'Loading purchased items...';

  @override
  String get preparingPurchasedItems => 'Preparing purchased items...';

  @override
  String get noPurchasedItemsYet => 'No purchased items yet';

  @override
  String get noPurchasedItemsYetMessage =>
      'Check off items you bought before creating a receipt.';

  @override
  String get backToList => 'Back to list';

  @override
  String get enterStoreNameForTrip => 'Enter the store name for this trip';

  @override
  String get enterStoreNameForTripSnack =>
      'Enter the store name for this trip.';

  @override
  String creatingReceiptsPerStore(int count) {
    return 'Creating $count receipts — one per store.';
  }

  @override
  String get missingStoreOnItems =>
      'Some purchased items are missing a store. Add a store on each item before finalizing.';

  @override
  String get missingStore => 'Missing store';

  @override
  String receiptSubtotalLabel(String amount) {
    return 'Receipt subtotal: $amount';
  }

  @override
  String get purchasedItems => 'Purchased items';

  @override
  String get enterReceiptTotal => 'Enter the receipt total';

  @override
  String get enterValidReceiptTotal => 'Enter a valid receipt total';

  @override
  String subtotalFromItemPrices(String amount) {
    return 'Subtotal from item prices: $amount';
  }

  @override
  String grandTotalAcrossReceipts(String amount) {
    return 'Grand total across receipts: $amount';
  }

  @override
  String get saveReceipts => 'Save receipts';

  @override
  String addValidPricesForStore(String store) {
    return 'Add valid prices for purchased items at $store.';
  }

  @override
  String get addStoreToAllItems =>
      'Add a store to every purchased item before finalizing multiple receipts.';

  @override
  String get signInToCreateShoppingLists => 'Sign in to create shopping lists.';

  @override
  String get couldNotCreateList =>
      'Could not create the list. Please try again.';

  @override
  String get couldNotDeleteList =>
      'Could not delete the list. Please try again.';

  @override
  String get couldNotAddItem => 'Could not add the item. Please try again.';

  @override
  String get signInToAddShoppingItems =>
      'Sign in to add items to your shopping list.';

  @override
  String get itemNameRequired => 'Item name is required.';

  @override
  String get couldNotUpdateItem =>
      'Could not update the item. Please try again.';

  @override
  String get couldNotUpdateQuantity =>
      'Could not update quantity. Please try again.';

  @override
  String get couldNotRemoveItem =>
      'Could not remove the item. Please try again.';

  @override
  String get couldNotUpdateShoppingList =>
      'Could not update the shopping list. Please try again.';

  @override
  String get couldNotCompleteAction =>
      'Could not complete the action. Please try again.';

  @override
  String estimatedPrefix(String amount) {
    return 'Estimated: $amount';
  }

  @override
  String shoppingTripFinalized(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Shopping trip finalized. $count receipts created.',
      one: 'Shopping trip finalized. 1 receipt created.',
    );
    return '$_temp0';
  }

  @override
  String get productChicken => 'Chicken';

  @override
  String get productEggs => 'Eggs';

  @override
  String get weeklyGroceriesDefault => 'Weekly groceries';

  @override
  String get basketSummary => 'Basket summary';

  @override
  String get estimatedBestTotal => 'Estimated best total';

  @override
  String get basketPotentialSaving => 'Potential saving';

  @override
  String get itemsMatched => 'Items matched';

  @override
  String get noPriceHistoryLabel => 'No price history';

  @override
  String get activeListsIncludedLabel => 'Active lists included';

  @override
  String get itemRecommendations => 'Item recommendations';

  @override
  String get bestKnownLabel => 'Best known';

  @override
  String get latestSeen => 'Latest seen';

  @override
  String saveUpToTotal(String amount) {
    return 'Save up to $amount total';
  }

  @override
  String get noPriceHistoryYet => 'No price history yet';

  @override
  String get addReceiptsForItemRecommendations =>
      'Add receipts with this item to unlock recommendations.';

  @override
  String get suggestedStorePlan => 'Suggested store plan';

  @override
  String estimatedStoreTotalLabel(String amount) {
    return 'Estimated store total: $amount';
  }

  @override
  String storePlanItemLine(String itemName, String quantitySuffix,
      String unitPrice, String perUnit) {
    return '• $itemName$quantitySuffix — $unitPrice $perUnit';
  }

  @override
  String get perUnit => 'each';

  @override
  String get signInToOptimizeAllLists =>
      'Sign in to optimize all your shopping lists from your receipts.';

  @override
  String get signInToOptimizeBasket =>
      'Sign in to optimize your basket from your receipts and shopping list.';

  @override
  String get loadingAllActiveLists => 'Loading all active lists…';

  @override
  String get loadingBasketOptimizer => 'Loading basket optimizer…';

  @override
  String get couldNotLoadShoppingList => 'Could not load shopping list';

  @override
  String get couldNotLoadPriceHistory => 'Could not load price history';

  @override
  String get noActiveItemsToOptimize => 'No active items to optimize';

  @override
  String get noActiveItemsToOptimizeMessage =>
      'Add items to your shopping lists to build a smart store plan.';

  @override
  String get backToShopping => 'Back to shopping';

  @override
  String get addItemsToListForOptimizer => 'Add items to your shopping list';

  @override
  String get addItemsToListForOptimizerMessage =>
      'Add items to your shopping list to optimize your basket.';

  @override
  String get noPriceHistoryForOptimizerMessage =>
      'Add receipts with line items so Savingor can learn your prices and recommend better stores.';

  @override
  String listFinalizeProgressSummary(int purchased, int total) {
    return 'Purchased: $purchased · Total items: $total';
  }

  @override
  String qtyWithCount(int count) {
    return 'Qty $count';
  }

  @override
  String get unitPrice => 'Unit price';

  @override
  String lineTotalWithAmount(String amount) {
    return 'Line total: $amount';
  }

  @override
  String get lineTotalEmpty => 'Line total: —';

  @override
  String enterPriceForProduct(String product) {
    return 'Enter a price for $product';
  }

  @override
  String enterValidPriceForProduct(String product) {
    return 'Enter a valid price for $product';
  }

  @override
  String get trackMonthlyGrocerySpending =>
      'Track your monthly grocery spending against your budget.';

  @override
  String get monthlyGroceryBudget => 'Monthly grocery budget';

  @override
  String get spentThisMonth => 'Spent this month';

  @override
  String get overBudget => 'Over budget';

  @override
  String get remaining => 'Remaining';

  @override
  String get updateMonthlyBudget => 'Update monthly budget';

  @override
  String get setMonthlyBudgetDescription =>
      'Set the grocery spending limit you want to track each month.';

  @override
  String get monthlyBudgetAmount => 'Monthly budget amount';

  @override
  String get saveBudget => 'Save budget';

  @override
  String get budgetSaved => 'Budget saved';

  @override
  String get enterBudgetAmount => 'Enter a budget amount';

  @override
  String get enterAmountGreaterThanZero => 'Enter an amount greater than zero';

  @override
  String get overview => 'Overview';

  @override
  String get estimatedSaved => 'Estimated saved';

  @override
  String get potentialMissed => 'Potential missed';

  @override
  String get savingsValue => 'Savings value';

  @override
  String get proPayback => 'Pro payback';

  @override
  String get proPaidForItself => 'Pro paid for itself';

  @override
  String amountOfPriceCovered(String amount, String price) {
    return '$amount of $price covered';
  }

  @override
  String needAmountMoreForPro(String amount) {
    return 'Need $amount more to cover Pro';
  }

  @override
  String amountAfterSubscription(String amount) {
    return '+$amount after subscription';
  }

  @override
  String monthlyReturnMultiplier(String multiplier) {
    return 'Return: ${multiplier}x this month';
  }

  @override
  String get spendingByStore => 'Spending by store';

  @override
  String priceRecordCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count records',
      one: '1 record',
    );
    return '$_temp0';
  }

  @override
  String get recentActivity => 'Recent activity';

  @override
  String get activityTypeReceipt => 'Receipt';

  @override
  String get activityTypeManual => 'Manual';

  @override
  String get activityManualExpense => 'Manual expense';

  @override
  String activityReceiptWithItems(String source, int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count items',
      one: '1 item',
    );
    return '$source · $_temp0';
  }

  @override
  String get recommendedActions => 'Recommended actions';

  @override
  String get exploreDetails => 'Explore details';

  @override
  String productsInPriceHistoryCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count products in your price history',
      one: '1 product in your price history',
    );
    return '$_temp0';
  }

  @override
  String get priceInsightsEmptySubtitle =>
      'Full price memory from your receipt line items';

  @override
  String get savingsOpportunities => 'Savings opportunities';

  @override
  String actionableOpportunitiesCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count actionable opportunities to review',
      one: '1 actionable opportunity to review',
    );
    return '$_temp0';
  }

  @override
  String get savingsOpportunitiesEmptySubtitle =>
      'Products where you paid more than the best known price';

  @override
  String get loadingAnalytics => 'Loading analytics…';

  @override
  String get couldNotLoadAnalytics => 'Could not load analytics';

  @override
  String get signInForAnalytics =>
      'View spending analytics with your Savingor account.';

  @override
  String get noSpendingDataYet => 'No spending data yet';

  @override
  String get noSpendingDataMessage =>
      'Add a receipt or expense to see spending totals, store breakdowns, and trends.';

  @override
  String get addMoreReceiptsForSavingsValue =>
      'Add more receipts to calculate your savings value.';

  @override
  String storeHasSeveralBestPrices(String store) {
    return '$store has several of your best known prices';
  }

  @override
  String trackedProductsLowestAtStore(int count, String store) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other:
          '$count tracked products currently have their lowest known price at $store',
      one: '1 tracked product currently has its lowest known price at $store',
    );
    return '$_temp0';
  }

  @override
  String get useStoreWhenMatchesRoute =>
      'Use this store when it matches your shopping route';

  @override
  String recentlyPaidLatestBestKnown(String latestPrice, String latestStore,
      String bestPrice, String bestStore) {
    return 'You recently paid $latestPrice at $latestStore. Your best known price is $bestPrice at $bestStore.';
  }

  @override
  String basedOnPriceRecords(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Based on $count price records',
      one: 'Based on 1 price record',
    );
    return '$_temp0';
  }

  @override
  String watchProductPrices(String product) {
    return 'Watch $product prices closely';
  }

  @override
  String knownPricesRangeFromTo(String low, String high) {
    return 'Your known prices range from $low to $high.';
  }

  @override
  String priceDifferenceAmount(String amount) {
    return 'Price difference: $amount';
  }

  @override
  String get productPriceInsights => 'Product price insights';

  @override
  String productsInPriceHistoryFromReceipts(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count products in your price history from receipts',
      one: '1 product in your price history from receipts',
    );
    return '$_temp0';
  }

  @override
  String get latestPriceLabel => 'Latest';

  @override
  String get bestKnownPriceLabel => 'Best known';

  @override
  String get highestPriceLabel => 'Highest';

  @override
  String get averagePriceLabel => 'Average';

  @override
  String priceAtStore(String price, String store) {
    return '$price at $store';
  }

  @override
  String get signInForPriceMemory =>
      'Sign in to view your product price memory.';

  @override
  String get loadingPriceMemory => 'Loading price memory…';

  @override
  String get couldNotLoadPriceMemory => 'Could not load price memory';

  @override
  String get noPriceMemoryYet => 'No price memory yet';

  @override
  String get noPriceMemoryMessage =>
      'Add receipts with line items to start building your price memory.';

  @override
  String savingsOpportunitiesPaidMoreCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other:
          '$count actionable opportunities where you paid more than the best known price',
      one:
          '1 actionable opportunity where you paid more than the best known price',
    );
    return '$_temp0';
  }

  @override
  String saveUpToPerItem(String amount) {
    return 'Save up to $amount per item';
  }

  @override
  String youPaidAtStore(String amount, String store) {
    return 'You paid $amount at $store';
  }

  @override
  String get recommendationWatchProductBeforeBuying =>
      'Recommendation: Watch this product before buying again.';

  @override
  String recommendationBuyAtStoreNextTime(String store) {
    return 'Recommendation: Buy at $store next time.';
  }

  @override
  String get signInForSavingsOpportunities =>
      'Sign in to see savings opportunities from your receipts.';

  @override
  String get loadingSavingsOpportunities => 'Loading savings opportunities…';

  @override
  String get couldNotLoadSavingsOpportunities =>
      'Could not load savings opportunities';

  @override
  String get noSavingsOpportunitiesYet => 'No savings opportunities yet';

  @override
  String get noSavingsOpportunitiesMessage =>
      'Add more receipts with line items so Savingor can compare prices across stores.';

  @override
  String get recordsLabel => 'Records';

  @override
  String get buyingAdvice => 'Buying advice';

  @override
  String get bestKnownPriceAdviceLabel => 'Best known price';

  @override
  String get latestPaidAdviceLabel => 'Latest paid';

  @override
  String buyItemAtStoreWhenFitsRoute(String store) {
    return 'Buy this item at $store when it fits your shopping route.';
  }

  @override
  String get buyItemAtBestPriceWhenFitsRoute =>
      'Buy this item where you previously found the best price when it fits your shopping route.';

  @override
  String get addToShoppingList => 'Add to shopping list';

  @override
  String get priceHistory => 'Price history';

  @override
  String get productHistoryTitle => 'Product history';

  @override
  String get productNotFound => 'Product not found.';

  @override
  String get buyingAdviceInsufficientHistory =>
      'Add more receipts with this item to unlock smarter buying advice.';

  @override
  String get buyingAdvicePaidBestPrice => 'You paid your best known price.';

  @override
  String get buyingAdviceNoBetterPriceYet => 'No better known price yet.';

  @override
  String quantityLabelWithCount(String count) {
    return 'Qty $count';
  }

  @override
  String get addedToShoppingList => 'Added to shopping list';

  @override
  String get alreadyInShoppingList => 'Already in shopping list';

  @override
  String get quantityUpdatedSnack => 'Quantity updated';

  @override
  String get nearbyStores => 'Nearby stores';

  @override
  String get nearbyStoresSubtitle =>
      'Find grocery stores near you and compare savings opportunities.';

  @override
  String get storesNearby => 'Stores nearby';

  @override
  String mapStoresFoundCount(int count) {
    return '$count found';
  }

  @override
  String get mapStoresFootnotePlaces =>
      'Stores are based on your selected location and search radius.';

  @override
  String get mapStoresFootnoteFallback =>
      'Showing grocery stores based on your selected area.';

  @override
  String get mapStoresFootnoteDefault =>
      'Explore grocery stores near your chosen location.';

  @override
  String mapNoStoresWithinRadius(int distance) {
    return 'No stores within $distance km. Try a larger radius.';
  }

  @override
  String get mapPleaseEnterCityOrArea => 'Please enter a city or area.';

  @override
  String get mapCouldNotOpenDirections => 'Could not open directions.';

  @override
  String get mapYourLocation => 'Your location';

  @override
  String get mapFindGroceryStoresNearYou => 'Find grocery stores near you';

  @override
  String get mapActive => 'Active';

  @override
  String get mapSearchRadius => 'Search radius';

  @override
  String get mapCheckingLocation => 'Checking location...';

  @override
  String get mapLocationSelected => 'Location selected';

  @override
  String get mapLocationDetected => 'Location detected';

  @override
  String get mapReadyToSearchNearby => 'Ready to search nearby grocery stores.';

  @override
  String get mapCouldNotAccessLocation => 'Could not access your location.';

  @override
  String get mapEnableLocationPrompt =>
      'Enable location to find grocery stores near you.';

  @override
  String get mapUseMyLocation => 'Use my location';

  @override
  String get mapEnterCityManually => 'Enter city manually';

  @override
  String get mapLocationServicesDisabled => 'Location services are turned off.';

  @override
  String get mapLocationPermissionDenied => 'Location permission denied.';

  @override
  String get mapCouldNotDetectLocation =>
      'Could not detect your location. Please try again.';

  @override
  String get mapSetYourLocation => 'Set your location';

  @override
  String get mapSetLocationGpsOrCity =>
      'Use GPS or choose a city to view nearby stores.';

  @override
  String get mapCurrentLocation => 'Current location';

  @override
  String get directions => 'Directions';

  @override
  String get mapStoreCategoryGrocery => 'Grocery';

  @override
  String get mapStoreCategorySupermarket => 'Supermarket';

  @override
  String get mapStoreCategoryWholesale => 'Wholesale';

  @override
  String get mapNearbyStoreStatus => 'Nearby store';

  @override
  String get mapListedOnGooglePlaces => 'Listed on Google Places';

  @override
  String mapRadiusKm(int distance) {
    return '$distance km';
  }

  @override
  String get mapSetLocation => 'Set location';

  @override
  String get mapCityOrArea => 'City or area';

  @override
  String get mapCityOrAreaExample => 'Example: Calgary, Cochrane, Edmonton';

  @override
  String mapMarkerSnippetWithDetail(String distance, String detail) {
    return '$distance · $detail';
  }

  @override
  String get aiSavingsAssistant => 'AI Savings Assistant';

  @override
  String get aiSignInPrompt =>
      'Sign in to ask the AI assistant about your receipts and shopping lists.';

  @override
  String get aiLoadingYourData => 'Loading your data…';

  @override
  String get aiCouldNotLoadData => 'Could not load your data';

  @override
  String get aiEmptyTitle => 'Add data to get AI insights';

  @override
  String get aiEmptyMessage =>
      'Scan a receipt, add an expense, or create a shopping list. The assistant analyzes your saved data — not live store prices.';

  @override
  String get aiHeroTitle => 'Your AI savings coach';

  @override
  String get aiHeroSubtitleLive =>
      'Ask about spending, receipts, and shopping lists.';

  @override
  String get aiHeroSubtitlePreview =>
      'Preview insights from your saved data — connect an API key for live answers.';

  @override
  String get aiConfigReadyMessage =>
      'AI assistant is ready. Connect an API key to enable live answers.';

  @override
  String get aiDataSnapshot => 'Your data snapshot';

  @override
  String aiReceiptCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count receipts',
      one: '1 receipt',
    );
    return '$_temp0';
  }

  @override
  String aiExpenseCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count expenses',
      one: '1 expense',
    );
    return '$_temp0';
  }

  @override
  String aiTotalSpendingLabel(String amount) {
    return '$amount total';
  }

  @override
  String aiListCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count lists',
      one: '1 list',
    );
    return '$_temp0';
  }

  @override
  String aiListEstimateLabel(String amount) {
    return '$amount list est.';
  }

  @override
  String get aiSuggestedQuestions => 'Suggested questions';

  @override
  String get aiSuggestSaveMoreThisWeek =>
      'How can I save more money this week?';

  @override
  String get aiSuggestTopStore => 'Which store do I spend the most at?';

  @override
  String get aiSuggestAnalyzeSpending => 'Analyze my grocery spending.';

  @override
  String get aiSuggestShoppingListPriority =>
      'What should I buy first from my shopping list?';

  @override
  String get aiAnalyzingYourData => 'Analyzing your data…';

  @override
  String get aiCouldNotGetAnswer =>
      'Could not get an answer. Please try again.';

  @override
  String get aiInsightsDisclaimer =>
      'Insights are based on your saved receipts, expenses, and shopping lists in Savingor — not live store prices or deals.';

  @override
  String get aiInputHintLive => 'Ask about your spending or shopping list…';

  @override
  String get aiInputHintPreview =>
      'Type a question — connect an API key for live answers';

  @override
  String get aiRequestFailed => 'AI request failed. Please try again.';

  @override
  String get aiEmptyResponse => 'AI returned an empty response.';

  @override
  String get aiSend => 'Send';

  @override
  String get editProfile => 'Edit profile';

  @override
  String get personalInformation => 'Personal information';

  @override
  String get editProfileFullNameHint => 'Your full name';

  @override
  String get emailChangesNotAvailable =>
      'Email changes are not available in this version.';

  @override
  String get password => 'Password';

  @override
  String get passwordNeverShown =>
      'For security, your current password is never shown.';

  @override
  String get changePassword => 'Change password';

  @override
  String get sendPasswordResetEmailInstead =>
      'Send password reset email instead';

  @override
  String get sendingResetEmail => 'Sending reset email...';

  @override
  String get changesSaved => 'Changes saved';

  @override
  String get couldNotSaveChanges => 'Could not save changes';

  @override
  String get pleaseEnterFullName => 'Please enter your full name';

  @override
  String get signInToEditProfile => 'Sign in to edit your profile.';

  @override
  String get passwordResetEmailSent => 'Reset email sent';

  @override
  String get changePasswordIntro =>
      'To change your password inside the app, enter your current password first.';

  @override
  String get currentPassword => 'Current password';

  @override
  String get newPassword => 'New password';

  @override
  String get confirmNewPassword => 'Confirm new password';

  @override
  String get enterCurrentPasswordHint => 'Enter current password';

  @override
  String get atLeast6CharactersHint => 'At least 6 characters';

  @override
  String get repeatNewPasswordHint => 'Repeat new password';

  @override
  String get currentPasswordRequired => 'Current password is required';

  @override
  String get newPasswordRequired => 'New password is required';

  @override
  String get newPasswordMinLength =>
      'New password must be at least 6 characters';

  @override
  String get confirmNewPasswordRequired => 'Please confirm your new password';

  @override
  String get passwordsDoNotMatch => 'Passwords do not match';

  @override
  String get updatePassword => 'Update password';

  @override
  String get forgotCurrentPassword => 'Forgot your current password?';

  @override
  String get passwordResetSecureLink =>
      'We\'ll send a secure reset link to your email so you can create a new password.';

  @override
  String get passwordResetByEmailHint =>
      'If you don\'t remember it, use password reset by email.';

  @override
  String get sendResetEmail => 'Send reset email';

  @override
  String get sending => 'Sending...';

  @override
  String get passwordUpdated => 'Password updated';

  @override
  String get showPassword => 'Show password';

  @override
  String get hidePassword => 'Hide password';

  @override
  String get signInToChangePassword =>
      'You need to be signed in to change your password.';

  @override
  String get currentPasswordIncorrect => 'Current password is incorrect';

  @override
  String get passwordTooWeak => 'Password is too weak';

  @override
  String get recentLoginRequired =>
      'For security, please sign in again and retry.';

  @override
  String get tooManyAttempts => 'Too many attempts. Please try again later.';

  @override
  String get couldNotUpdatePassword => 'Could not update password';

  @override
  String get noEmailLinked => 'No email is linked to this account.';

  @override
  String get couldNotSendResetEmail => 'Could not send reset email';

  @override
  String get plans => 'Plans';

  @override
  String get freeTodayProWhenReady => 'Free today · Pro when ready';

  @override
  String get saveSmarterWithAi => 'Save smarter with AI';

  @override
  String get unlockProFeaturesDescription =>
      'Unlock AI savings insights, receipt analytics, smart alerts, and deeper spending reports.';

  @override
  String get bestValue => 'Best value';

  @override
  String get basicDealsBrowsing => 'Basic deals browsing';

  @override
  String get manualExpenseTracking => 'Manual expense tracking';

  @override
  String get aiPoweredToolsDescription =>
      'AI-powered tools for smarter grocery savings.';

  @override
  String get receiptAnalytics => 'Receipt analytics';

  @override
  String get smartSavingsInsights => 'Smart savings insights';

  @override
  String get spendingReports => 'Spending reports';

  @override
  String get smartAlerts => 'Smart alerts';

  @override
  String get startProSubscription => 'Start Pro subscription';

  @override
  String get restorePurchases => 'Restore purchases';

  @override
  String get restoring => 'Restoring...';

  @override
  String get proSubscriptionActivated => 'Subscription activated';

  @override
  String get proDemoFallbackActivated =>
      'Pro demo activated — no real payment processed.';

  @override
  String get couldNotCompletePurchase =>
      'Could not complete the purchase. Please try again.';

  @override
  String get couldNotActivateProDemo =>
      'Could not activate Pro demo. Please try again.';

  @override
  String get purchaseRestored => 'Purchase restored';

  @override
  String get noPurchasesFound => 'No purchases found';

  @override
  String get couldNotRestorePurchases => 'Could not restore purchases';

  @override
  String get subscriptionSetup => 'Subscription setup';

  @override
  String get subscriptionSetupPrepared =>
      'Savingor Pro is prepared for real in-app subscription integration.';

  @override
  String get subscriptionSetupNotConfigured =>
      'Payment provider keys or store products are not configured in this build.';

  @override
  String get activateProDemoForTesting => 'Activate Pro demo for testing';

  @override
  String get demoFallbackActive =>
      'Demo fallback active — no real payment processed.';

  @override
  String get subscriptionPlanLabel => 'Plan';

  @override
  String pricePerMonth(String price) {
    return '$price / month';
  }

  @override
  String get active => 'Active';

  @override
  String get activeDemo => 'Active demo';

  @override
  String get cancelled => 'Cancelled';

  @override
  String get unknown => 'Unknown';

  @override
  String get demoMode => 'Demo mode';

  @override
  String get providerNone => 'None';

  @override
  String get revenueCatLabel => 'RevenueCat';

  @override
  String get subscriptionManagedByStore =>
      'Your subscription is managed by App Store or Google Play. You can cancel or update it from your store subscription settings.';

  @override
  String get manageInAppStoreGooglePlay => 'Manage in App Store / Google Play';

  @override
  String get cancelProDemo => 'Cancel Pro demo';

  @override
  String get noActiveSubscription => 'No active subscription';

  @override
  String get proDemoCancelled =>
      'Pro demo cancelled. You are back on the Free plan.';

  @override
  String get couldNotCancelProDemo =>
      'Could not cancel Pro demo. Please try again.';

  @override
  String get couldNotOpenSubscriptionManagement =>
      'Could not open the subscription management page.';

  @override
  String get managementNotAvailable => 'Management not available';

  @override
  String get managementUrlUnavailableMessage =>
      'Subscription management URL is not available in this test build. For RevenueCat Test Store purchases, reset the test customer in the RevenueCat dashboard or use a new test user.';

  @override
  String get paymentProviderNotConfiguredSnack =>
      'Payment provider is not configured in this local build.';

  @override
  String get purchaseCancelled => 'Purchase cancelled';

  @override
  String get purchaseFailed => 'Purchase failed';

  @override
  String get productUnavailable => 'Product unavailable';

  @override
  String get purchaseNotActiveYet =>
      'Purchase completed but Pro is not active yet. Try Restore purchases.';

  @override
  String get networkErrorTryAgain => 'Check your connection and try again';

  @override
  String get signInToManageSubscription =>
      'You need to be signed in to manage your subscription.';

  @override
  String get couldNotUpdateSubscription =>
      'Could not update your subscription. Please try again.';
}
