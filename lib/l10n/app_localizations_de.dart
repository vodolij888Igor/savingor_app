import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for German (`de`).
class AppLocalizationsDe extends AppLocalizations {
  AppLocalizationsDe([String locale = 'de']) : super(locale);

  @override
  String get appName => 'Savingor';

  @override
  String get appSubtitle => 'Lokale Angebote und smartes Sparen';

  @override
  String get home => 'Start';

  @override
  String get deals => 'Angebote';

  @override
  String get receipts => 'Belege';

  @override
  String get analytics => 'Analyse';

  @override
  String get profile => 'Profil';

  @override
  String get scanner => 'Belegscanner';

  @override
  String get shopping => 'Einkaufsliste';

  @override
  String get saved => 'Gespeichert';

  @override
  String get storesMap => 'Karte';

  @override
  String get aiAssistant => 'KI';

  @override
  String get scanReceipt => 'Beleg scannen';

  @override
  String get dealsMap => 'Angebotskarte';

  @override
  String get receiptScanner => 'Belegscanner';

  @override
  String get shoppingList => 'Einkaufsliste';

  @override
  String get mvp => 'MVP v0.1';

  @override
  String get searchHint => 'Angebote oder Geschäfte suchen...';

  @override
  String get filter => 'Filter';

  @override
  String get dealsMapSubtitle => 'Zeigt Angebote in der Nähe';

  @override
  String get receiptScannerSubtitle => 'Beleg scannen';

  @override
  String get shoppingListSubtitle => 'Smarte Liste';

  @override
  String dealsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Angebote',
      one: '$count Angebot',
    );
    return '$_temp0';
  }

  @override
  String get noDealsFound => 'Keine Angebote gefunden';

  @override
  String get resetFilters => 'Filter zurücksetzen';

  @override
  String get filtersTitle => 'Filter';

  @override
  String get stores => 'Geschäfte';

  @override
  String get maxPrice => 'Max. Preis';

  @override
  String get sort => 'Sortierung';

  @override
  String get none => 'Keine';

  @override
  String get priceLowHigh => 'Preis: aufsteigend';

  @override
  String get priceHighLow => 'Preis: absteigend';

  @override
  String get dealDetails => 'Angebotsdetails';

  @override
  String get dealNotFound => 'Angebot nicht gefunden';

  @override
  String get saveDeal => 'Angebot speichern';

  @override
  String get removeSaved => 'Aus Gespeichert entfernen';

  @override
  String get noSavedDeals => 'Noch keine gespeicherten Angebote';

  @override
  String get savedHint => 'Gespeicherte Angebote erscheinen hier';

  @override
  String get cancel => 'Abbrechen';

  @override
  String get apply => 'Anwenden';

  @override
  String get save => 'Speichern';

  @override
  String get back => 'Zurück';

  @override
  String get close => 'Schließen';

  @override
  String get signOut => 'Abmelden';

  @override
  String get loading => 'Wird geladen...';

  @override
  String get tryAgain => 'Erneut versuchen';

  @override
  String get comingSoon => 'Demnächst';

  @override
  String get continueButton => 'Weiter';

  @override
  String get edit => 'Bearbeiten';

  @override
  String get ok => 'OK';

  @override
  String get chooseYourLanguage => 'Sprache wählen';

  @override
  String get chooseLanguageSubtitle => 'Wählen Sie die Sprache, die Savingor verwenden soll.';

  @override
  String get langSubtitleOnboarding => 'Das hilft, Ihr Savingor-Erlebnis zu personalisieren.';

  @override
  String get applyLanguage => 'Sprache anwenden';

  @override
  String welcomeBackName(String name) {
    return 'Willkommen zurück, $name! 👋';
  }

  @override
  String get welcomeBack => 'Willkommen zurück! 👋';

  @override
  String get readyToSaveSmarterToday => 'Bereit, heute smarter zu sparen?';

  @override
  String get totalExpenses => 'Gesamtausgaben';

  @override
  String get trackedInSavingor => 'In Savingor erfasst';

  @override
  String expensesTracked(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Ausgaben erfasst',
      one: '$count Ausgabe erfasst',
    );
    return '$_temp0';
  }

  @override
  String get startSaving => 'Sparen starten';

  @override
  String get startSavingHero => '✨ SPAREN STARTEN';

  @override
  String get thisMonth => 'Diesen Monat';

  @override
  String get spent => 'ausgegeben';

  @override
  String get recorded => 'erfasst';

  @override
  String get lists => 'Listen';

  @override
  String get activeDeals => 'Aktive Angebote';

  @override
  String get estimated => 'geschätzt';

  @override
  String get monthlyGoal => 'Monatsziel';

  @override
  String get noRecentActivity => 'Keine kürzliche Aktivität';

  @override
  String get expenseAdded => 'Ausgabe hinzugefügt';

  @override
  String get addExpenseToSeeHere => 'Fügen Sie eine Ausgabe hinzu, um sie hier zu sehen';

  @override
  String get yourSavingsSnapshot => 'Ihr Sparüberblick';

  @override
  String get thisMonthSpent => 'Diesen Monat ausgegeben';

  @override
  String get potentialSavingsFound => 'Potenzielle Ersparnisse gefunden';

  @override
  String get productsTracked => 'Verfolgte Produkte';

  @override
  String get bestActionNow => 'Beste Aktion jetzt';

  @override
  String get addMoreReceiptsForSavings => 'Fügen Sie mehr Belege hinzu, um personalisierte Ersparnisse freizuschalten.';

  @override
  String get account => 'Konto';

  @override
  String get yourAccount => 'Ihr Konto';

  @override
  String get planAndSubscription => 'Plan & Abo';

  @override
  String get appSettings => 'App-Einstellungen';

  @override
  String get region => 'Region';

  @override
  String get language => 'Sprache';

  @override
  String get appearance => 'Erscheinungsbild';

  @override
  String get currency => 'Währung';

  @override
  String get notifications => 'Benachrichtigungen';

  @override
  String get loadingProfile => 'Profil wird geladen...';

  @override
  String get noProfileFound => 'Für dieses Konto wurde noch kein Profil gefunden.';

  @override
  String get fullName => 'Vollständiger Name';

  @override
  String get email => 'E-Mail';

  @override
  String get passwordAndSecurity => 'Passwort & Sicherheit';

  @override
  String get managePassword => 'Passwort verwalten';

  @override
  String get currentPlan => 'Aktueller Plan';

  @override
  String get proPlan => 'Pro-Plan';

  @override
  String get freePlan => 'Kostenloser Plan';

  @override
  String get pro => 'Pro';

  @override
  String get free => 'Kostenlos';

  @override
  String get status => 'Status';

  @override
  String get provider => 'Anbieter';

  @override
  String get price => 'Preis';

  @override
  String get priceMonthly => '14,99 \$ / Monat';

  @override
  String get inactive => 'Inaktiv';

  @override
  String get freePlanUpgradeMessage => 'Sie nutzen derzeit den kostenlosen Plan. Upgraden Sie auf Pro für KI-Spartipps, Beleganalysen, smarte Alerts und Ausgabenberichte.';

  @override
  String get manageSubscription => 'Abo verwalten';

  @override
  String get viewPlans => 'Pläne ansehen';

  @override
  String get manageSettings => 'Einstellungen verwalten';

  @override
  String get signOutQuestion => 'Abmelden?';

  @override
  String get signOutMessage => 'Sie müssen sich erneut anmelden, um auf Ihr Savingor-Konto zuzugreifen.';

  @override
  String get couldNotLoadProfile => 'Profil konnte nicht geladen werden. Bitte erneut versuchen.';

  @override
  String get personalizeSavingor => 'Savingor personalisieren';

  @override
  String get personalizeSavingorSubtitle => 'Wählen Sie, wie die App aussieht, kommuniziert und sich an Ihren Standort anpasst.';

  @override
  String get preferences => 'Einstellungen';

  @override
  String get appLanguage => 'App-Sprache';

  @override
  String get appearanceHelper => 'Wählen Sie das Erscheinungsbild von Savingor';

  @override
  String get regionHelper => 'Für nahegelegene Geschäfte und lokale Angebote';

  @override
  String get currencyHelper => 'Für Preise, Budgets und Berichte';

  @override
  String get smartSavingsAlerts => 'Smarte Spar-Alerts';

  @override
  String get smartSavingsAlertsDescription => 'Erhalten Sie Benachrichtigungen zu Spar-Chancen, Budgetfortschritt und wichtigen Empfehlungen.';

  @override
  String get regionCanada => 'Kanada';

  @override
  String get regionUnitedStates => 'Vereinigte Staaten';

  @override
  String get appearanceLight => 'Hell';

  @override
  String get appearanceDark => 'Dunkel';

  @override
  String get topSavingOpportunities => 'Top-Spar-Chancen';

  @override
  String get seeAll => 'Alle anzeigen';

  @override
  String bestKnownAtStore(String amount, String store) {
    return 'Bester bekannter Preis: $amount bei $store';
  }

  @override
  String latestPaidAtStore(String amount, String store) {
    return 'Zuletzt gezahlt: $amount bei $store';
  }

  @override
  String saveUpToAmount(String amount) {
    return 'Sparen Sie bis zu $amount';
  }

  @override
  String get basedOnReceiptHistory => 'Basierend auf Belegverlauf';

  @override
  String buyProductAtStoreNextTime(String product, String store) {
    return 'Kaufen Sie $product beim nächsten Mal bei $store';
  }

  @override
  String potentialSavingPerItem(String amount) {
    return 'Potenzielle Ersparnis: $amount pro Artikel';
  }

  @override
  String get productBread => 'Brot';

  @override
  String get productMilk => 'Milch';

  @override
  String get delete => 'Löschen';

  @override
  String get signIn => 'Anmelden';

  @override
  String get signInRequired => 'Anmeldung erforderlich';

  @override
  String get store => 'Geschäft';

  @override
  String get date => 'Datum';

  @override
  String get total => 'Gesamt';

  @override
  String get items => 'Artikel';

  @override
  String get notes => 'Notizen';

  @override
  String get amount => 'Betrag';

  @override
  String get category => 'Kategorie';

  @override
  String get scanReceiptSubtitle => 'Scannen Sie einen Lebensmittelbeleg, um Ausgaben und Ersparnisse zu verfolgen.';

  @override
  String get addManually => 'Manuell hinzufügen';

  @override
  String recentReceipts(int count) {
    return 'Letzte Belege ($count)';
  }

  @override
  String get noReceiptsYet => 'Noch keine Belege. Scannen oder fügen Sie einen Beleg hinzu, um mit der Verfolgung zu beginnen.';

  @override
  String get deleteReceiptQuestion => 'Beleg löschen?';

  @override
  String get deleteReceipt => 'Beleg löschen';

  @override
  String deleteReceiptConfirmMessage(String store, String total) {
    return '$store ($total) wird dauerhaft entfernt.';
  }

  @override
  String get loadingReceipts => 'Belege werden geladen...';

  @override
  String get couldNotLoadReceipts => 'Belege konnten nicht geladen werden';

  @override
  String get signInToSyncReceipts => 'Speichern und synchronisieren Sie Ihre Belege mit Ihrem Savingor-Konto.';

  @override
  String get chooseReceiptSource => 'Wählen Sie, wie Sie Ihren Beleg hinzufügen möchten';

  @override
  String freeScansUsedThisMonth(int used, int limit) {
    return '$used von $limit kostenlosen Scans diesen Monat genutzt';
  }

  @override
  String freeScansRemaining(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count kostenlose Scans verbleibend',
      one: '1 kostenloser Scan verbleibend',
    );
    return '$_temp0';
  }

  @override
  String get noFreeScansRemainingThisMonth => 'Keine kostenlosen Scans mehr in diesem Monat';

  @override
  String get unlimitedScansWithPro => 'Unbegrenzte Scans mit Pro';

  @override
  String get loadingScanUsage => 'Scan-Nutzung wird geprüft…';

  @override
  String get monthlyScanLimitTitle => 'Monatliches Scan-Limit erreicht';

  @override
  String get monthlyScanLimitDescription => 'Sie haben alle drei kostenlosen Beleg-Scans für diesen Monat genutzt. Upgraden Sie auf Savingor Pro für unbegrenztes Scannen.';

  @override
  String get unlockUnlimitedScansWithSavingorPro => 'Unbegrenzte Scans mit Savingor Pro freischalten';

  @override
  String get monthlyScanLimitSaveBlocked => 'Sie haben Ihr kostenloses Scan-Limit für diesen Monat erreicht. Upgraden Sie auf Pro, um weitere gescannte Belege zu speichern.';

  @override
  String get takePhoto => 'Foto aufnehmen';

  @override
  String get takePhotoSubtitle => 'Verwenden Sie Ihre Kamera, um einen Beleg zu scannen';

  @override
  String get chooseFromGallery => 'Aus Galerie wählen';

  @override
  String get chooseFromGallerySubtitle => 'Wählen Sie ein vorhandenes Belegfoto';

  @override
  String get scanningReceipt => 'Beleg wird gescannt...';

  @override
  String get couldNotScanReceipt => 'Dieser Beleg konnte nicht gescannt werden. Versuchen Sie ein anderes Foto.';

  @override
  String get ocrResultPreview => 'OCR-Ergebnisvorschau';

  @override
  String get noTextDetected => 'Kein Text erkannt. Versuchen Sie ein klareres Belegfoto.';

  @override
  String get useThisReceipt => 'Diesen Beleg verwenden';

  @override
  String get noneDetected => 'Nichts erkannt';

  @override
  String get rawOcrText => 'Roher OCR-Text';

  @override
  String get itemsColon => 'Artikel:';

  @override
  String get addReceipt => 'Beleg hinzufügen';

  @override
  String get editReceipt => 'Beleg bearbeiten';

  @override
  String get saveReceipt => 'Beleg speichern';

  @override
  String get updateReceipt => 'Beleg aktualisieren';

  @override
  String get storeName => 'Geschäftsname';

  @override
  String get storeAddressOptional => 'Geschäftsadresse (optional)';

  @override
  String get purchaseDate => 'Kaufdatum';

  @override
  String get categorySummary => 'Kategorie';

  @override
  String get grocery => 'Lebensmittel';

  @override
  String get subtotalOptional => 'Zwischensumme (optional)';

  @override
  String get taxOptional => 'Steuer (optional)';

  @override
  String get receiptTotal => 'Belegsumme';

  @override
  String get autoCalculatedFromItems => 'Automatisch aus Artikeln berechnet, sofern Sie dieses Feld nicht bearbeiten.';

  @override
  String get notesOptional => 'Notizen (optional)';

  @override
  String get addItem => 'Artikel hinzufügen';

  @override
  String get addLineItemsHint => 'Fügen Sie Positionen hinzu, um einen vollständigen Beleg für die spätere Preisverfolgung zu erstellen.';

  @override
  String get enterStoreName => 'Geben Sie einen Geschäftsnamen ein';

  @override
  String get selectPurchaseDate => 'Wählen Sie ein Kaufdatum';

  @override
  String get enterTotalAmount => 'Geben Sie den Gesamtbetrag ein';

  @override
  String get enterValidAmount => 'Geben Sie einen gültigen Betrag ein';

  @override
  String get enterValidTotalAmount => 'Geben Sie einen gültigen Gesamtbetrag ein.';

  @override
  String get receiptNotFound => 'Beleg nicht gefunden.';

  @override
  String get item => 'Artikel';

  @override
  String get itemName => 'Artikelname';

  @override
  String get enterItemName => 'Geben Sie einen Artikelnamen ein';

  @override
  String get qty => 'Menge';

  @override
  String get invalidValue => 'Ungültig';

  @override
  String get removeItem => 'Artikel entfernen';

  @override
  String get categoryOptional => 'Kategorie (optional)';

  @override
  String get receiptDetails => 'Belegdetails';

  @override
  String subtotalLabel(String amount) {
    return 'Zwischensumme: $amount';
  }

  @override
  String taxLabel(String amount) {
    return 'Steuer: $amount';
  }

  @override
  String get noItemsSaved => 'Keine Artikel gespeichert';

  @override
  String get noLineItemsSaved => 'Für diesen Beleg wurden noch keine Positionen gespeichert.';

  @override
  String qtyWithValue(String quantity) {
    return 'Menge $quantity';
  }

  @override
  String get couldNotDeleteReceipt => 'Beleg konnte nicht gelöscht werden. Bitte versuchen Sie es erneut.';

  @override
  String get saveChanges => 'Änderungen speichern';

  @override
  String get receiptSourceManual => 'Manuell';

  @override
  String get receiptSourceScanned => 'Gescannt';

  @override
  String get receiptSourceGallery => 'Galerie';

  @override
  String get receiptSourceImported => 'Importiert';

  @override
  String get receiptSourceShoppingList => 'Einkaufsliste';

  @override
  String get receiptSourceUnknown => 'Beleg';

  @override
  String get scanNotes => 'Scan-Notizen';

  @override
  String get galleryScanNotes => 'Galerie-Scan-Notizen';

  @override
  String get importNotes => 'Import-Notizen';

  @override
  String get tripNotes => 'Einkaufs-Notizen';

  @override
  String get couldNotLoadYourReceipts => 'Ihre Belege konnten nicht geladen werden. Bitte versuchen Sie es erneut.';

  @override
  String get signInToSaveReceipts => 'Melden Sie sich an, um Belege zu speichern.';

  @override
  String get couldNotSaveReceipt => 'Beleg konnte nicht gespeichert werden. Bitte versuchen Sie es erneut.';

  @override
  String get couldNotUpdateReceipt => 'Beleg konnte nicht aktualisiert werden. Bitte versuchen Sie es erneut.';

  @override
  String get signInToUpdateReceipts => 'Melden Sie sich an, um Belege zu aktualisieren.';

  @override
  String receiptItemsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Artikel',
      one: '1 Artikel',
      zero: '0 Artikel',
    );
    return '$_temp0';
  }

  @override
  String get processingReceipt => 'Beleg wird verarbeitet';

  @override
  String get readingReceipt => 'Beleg wird gelesen';

  @override
  String get recognizingText => 'Texterkennung';

  @override
  String get receiptScannedSuccessfully => 'Beleg erfolgreich gescannt';

  @override
  String get noTextRecognized => 'Kein Text erkannt';

  @override
  String get couldNotReadReceipt => 'Dieser Beleg konnte nicht gelesen werden';

  @override
  String get imageTooBlurry => 'Das Bild ist zu unscharf';

  @override
  String get tryAnotherPhoto => 'Bitte versuchen Sie ein anderes Foto';

  @override
  String get cameraPermissionRequired => 'Kameraberechtigung erforderlich';

  @override
  String get galleryPermissionRequired => 'Galeriezugriff erforderlich';

  @override
  String get permissionDenied => 'Berechtigung verweigert';

  @override
  String get openSettings => 'Einstellungen öffnen';

  @override
  String get chooseSavingAction => 'Wählen Sie Ihre nächste Aktion';

  @override
  String get addGroceryExpense => 'Lebensmittelausgabe hinzufügen';

  @override
  String get addGroceryExpenseSubtitle => 'Erfassen Sie einen Einkauf manuell';

  @override
  String get createShoppingListAction => 'Einkaufsliste erstellen';

  @override
  String get createShoppingListSubtitle => 'Planen Sie Ihre Einkäufe im Voraus';

  @override
  String get optimizeShoppingBasket => 'Einkaufswagen optimieren';

  @override
  String get optimizeShoppingBasketSubtitle => 'Finden Sie Möglichkeiten, weniger auszugeben';

  @override
  String get finalizeShoppingTrip => 'Einkauf abschließen';

  @override
  String get finalizeShoppingTripSubtitle => 'Schließen Sie Ihren laufenden Einkauf ab';

  @override
  String get monthlyGoalBudget => 'Monatsziel / Budget';

  @override
  String get monthlyGoalBudgetSubtitle => 'Legen Sie Ihr Monatsziel fest oder ändern Sie es';

  @override
  String get savingsAnalytics => 'Sparanalyse';

  @override
  String get savingsAnalyticsSubtitle => 'Überprüfen Sie Ihre Ausgaben und Ersparnisse';

  @override
  String get open => 'Öffnen';

  @override
  String get expenses => 'Ausgaben';

  @override
  String get addExpense => 'Ausgabe hinzufügen';

  @override
  String get loadingExpenses => 'Ausgaben werden geladen...';

  @override
  String get couldNotLoadExpenses => 'Ausgaben konnten nicht geladen werden';

  @override
  String get couldNotLoadYourExpenses => 'Ihre Ausgaben konnten nicht geladen werden. Bitte erneut versuchen.';

  @override
  String get noExpensesYet => 'Noch keine Ausgaben';

  @override
  String get noExpensesYetMessage => 'Verfolgen Sie Lebensmitteleinkäufe und Belege, um Ihre Ausgaben zu verstehen.';

  @override
  String get signInToSyncExpenses => 'Speichern und synchronisieren Sie Ihre Ausgaben mit Ihrem Savingor-Konto.';

  @override
  String get deleteExpenseQuestion => 'Ausgabe löschen?';

  @override
  String deleteExpenseConfirmMessage(String store, String amount) {
    return '„$store“ ($amount) wird dauerhaft entfernt.';
  }

  @override
  String get saveExpense => 'Ausgabe speichern';

  @override
  String get totalAmount => 'Gesamtbetrag';

  @override
  String get signInToSaveExpenses => 'Melden Sie sich an, um Ausgaben zu speichern.';

  @override
  String get couldNotSaveExpense => 'Ausgabe konnte nicht gespeichert werden. Bitte erneut versuchen.';

  @override
  String get couldNotDeleteExpense => 'Ausgabe konnte nicht gelöscht werden. Bitte erneut versuchen.';

  @override
  String get expenseSaved => 'Ausgabe gespeichert.';

  @override
  String get uncategorized => 'Nicht kategorisiert';

  @override
  String get recentExpenses => 'Letzte Ausgaben';

  @override
  String get noExpensesAddedYet => 'Noch keine Ausgaben hinzugefügt.';

  @override
  String get pleaseEnterStoreName => 'Bitte geben Sie einen Geschäftsnamen ein.';

  @override
  String get pleaseEnterItemName => 'Bitte geben Sie einen Artikelnamen ein.';

  @override
  String get pleaseEnterPrice => 'Bitte geben Sie einen Preis ein.';

  @override
  String get pleaseEnterValidPrice => 'Bitte geben Sie einen gültigen Preis ein.';

  @override
  String expenseCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Ausgaben',
      one: '1 Ausgabe',
      zero: '0 Ausgaben',
    );
    return '$_temp0';
  }

  @override
  String get newShoppingList => 'Neue Einkaufsliste';

  @override
  String get newList => 'Neue Liste';

  @override
  String get createList => 'Liste erstellen';

  @override
  String get loadingShoppingLists => 'Einkaufslisten werden geladen...';

  @override
  String get couldNotLoadLists => 'Listen konnten nicht geladen werden';

  @override
  String get couldNotLoadYourShoppingLists => 'Ihre Einkaufslisten konnten nicht geladen werden. Bitte erneut versuchen.';

  @override
  String get noShoppingListsYet => 'Noch keine Einkaufslisten';

  @override
  String get noShoppingListsYetMessage => 'Erstellen Sie Ihre erste Liste, um Einkäufe zu planen und Ihren Warenkorb zu optimieren.';

  @override
  String get signInToSyncShoppingLists => 'Erstellen und synchronisieren Sie Einkaufslisten mit Ihrem Savingor-Konto.';

  @override
  String get deleteListQuestion => 'Liste löschen?';

  @override
  String deleteListConfirmMessage(String title) {
    return '„$title“ wird dauerhaft entfernt.';
  }

  @override
  String get deleteList => 'Liste löschen';

  @override
  String get optimizeAllLists => 'Alle Listen optimieren';

  @override
  String get optimizeAllListsSubtitle => 'Finden Sie die besten bekannten Geschäfte für Ihre aktiven Einkaufslisten';

  @override
  String get optimizeThisBasket => 'Diesen Warenkorb optimieren';

  @override
  String get optimizeThisBasketSubtitle => 'Finden Sie die besten bekannten Geschäfte für diese Liste';

  @override
  String get listNotFound => 'Liste nicht gefunden';

  @override
  String get listNotFoundMessage => 'Diese Einkaufsliste wurde möglicherweise gelöscht.';

  @override
  String get backToLists => 'Zurück zu den Listen';

  @override
  String get noShoppingItemsYet => 'Noch keine Artikel';

  @override
  String get noShoppingItemsYetMessage => 'Fügen Sie Artikel zu dieser Liste hinzu, um Ihre Bedürfnisse zu verfolgen.';

  @override
  String get shoppingListEmptyMessage => 'Erstellen und verwalten Sie hier Ihre smarten Einkaufslisten.';

  @override
  String get purchased => 'Gekauft';

  @override
  String get clearPurchased => 'Gekaufte löschen';

  @override
  String get estimatedTotalLabel => 'Geschätzte Summe';

  @override
  String estimatedShort(String amount) {
    return 'Gesch. $amount';
  }

  @override
  String activeCountLabel(int count) {
    return '$count aktiv';
  }

  @override
  String purchasedSummary(int count) {
    return '$count gekauft';
  }

  @override
  String itemsTotalSummary(int count) {
    return '$count Artikel insgesamt';
  }

  @override
  String get allItemsPurchased => 'Alle Artikel gekauft';

  @override
  String get saveItem => 'Artikel speichern';

  @override
  String get listTitle => 'Listentitel';

  @override
  String get enterListTitle => 'Geben Sie einen Listentitel ein';

  @override
  String get listName => 'Listenname';

  @override
  String get enterListName => 'Geben Sie einen Listennamen ein';

  @override
  String get newShoppingListHint => 'Geben Sie Ihrer Liste einen Namen. Artikel können Sie nach dem Erstellen hinzufügen.';

  @override
  String get itemsOptional => 'Artikel (optional)';

  @override
  String get addAnotherItem => 'Weiteren Artikel hinzufügen';

  @override
  String get storeOptional => 'Geschäft (optional)';

  @override
  String get priceOptional => 'Preis (optional)';

  @override
  String get loadingListItems => 'Artikel werden geladen...';

  @override
  String get loadingShoppingList => 'Einkaufsliste wird geladen...';

  @override
  String get couldNotLoadItems => 'Artikel konnten nicht geladen werden';

  @override
  String get couldNotLoadListItems => 'Listenartikel konnten nicht geladen werden. Bitte erneut versuchen.';

  @override
  String get createAnotherReceiptQuestion => 'Weiteren Beleg erstellen?';

  @override
  String get createAnotherReceiptMessage => 'Diese Liste hat möglicherweise bereits einen Beleg. Einen weiteren Beleg aus gekauften Artikeln erstellen?';

  @override
  String get createReceipt => 'Beleg erstellen';

  @override
  String get signInToFinalizeTrip => 'Melden Sie sich an, um einen Einkauf abzuschließen.';

  @override
  String get noListsReadyToFinalize => 'Keine Listen zum Abschließen bereit';

  @override
  String get noListsReadyToFinalizeMessage => 'Markieren Sie Artikel auf einer Einkaufsliste als gekauft und kehren Sie dann hierher zurück, um einen Beleg zu erstellen.';

  @override
  String get openShoppingLists => 'Einkaufslisten öffnen';

  @override
  String get selectListToFinalize => 'Liste zum Abschließen auswählen';

  @override
  String get selectListToFinalizeSubtitle => 'Wählen Sie eine Einkaufsliste mit gekauften Artikeln.';

  @override
  String get finalizeShoppingTripCardSubtitle => 'Erstellen Sie einen Beleg aus gekauften Artikeln und aktualisieren Sie Ihre Preishistorie';

  @override
  String get done => 'Fertig';

  @override
  String get optional => 'Optional';

  @override
  String get somethingWentWrong => 'Etwas ist schiefgelaufen';

  @override
  String get saving => 'Wird gespeichert...';

  @override
  String get loadingPurchasedItems => 'Gekaufte Artikel werden geladen...';

  @override
  String get preparingPurchasedItems => 'Gekaufte Artikel werden vorbereitet...';

  @override
  String get noPurchasedItemsYet => 'Noch keine gekauften Artikel';

  @override
  String get noPurchasedItemsYetMessage => 'Markieren Sie Artikel als gekauft, bevor Sie einen Beleg erstellen.';

  @override
  String get backToList => 'Zurück zur Liste';

  @override
  String get enterStoreNameForTrip => 'Geben Sie den Geschäftsnamen für diesen Einkauf ein';

  @override
  String get enterStoreNameForTripSnack => 'Geben Sie den Geschäftsnamen für diesen Einkauf ein.';

  @override
  String creatingReceiptsPerStore(int count) {
    return '$count Belege werden erstellt — einer pro Geschäft.';
  }

  @override
  String get missingStoreOnItems => 'Bei einigen gekauften Artikeln fehlt ein Geschäft. Fügen Sie jedem Artikel ein Geschäft hinzu, bevor Sie abschließen.';

  @override
  String get missingStore => 'Geschäft fehlt';

  @override
  String receiptSubtotalLabel(String amount) {
    return 'Beleg-Zwischensumme: $amount';
  }

  @override
  String get purchasedItems => 'Gekaufte Artikel';

  @override
  String get enterReceiptTotal => 'Geben Sie den Beleggesamtbetrag ein';

  @override
  String get enterValidReceiptTotal => 'Geben Sie einen gültigen Beleggesamtbetrag ein';

  @override
  String subtotalFromItemPrices(String amount) {
    return 'Zwischensumme aus Artikelpreisen: $amount';
  }

  @override
  String grandTotalAcrossReceipts(String amount) {
    return 'Gesamtsumme über alle Belege: $amount';
  }

  @override
  String get saveReceipts => 'Belege speichern';

  @override
  String addValidPricesForStore(String store) {
    return 'Fügen Sie gültige Preise für gekaufte Artikel bei $store hinzu.';
  }

  @override
  String get addStoreToAllItems => 'Fügen Sie jedem gekauften Artikel ein Geschäft hinzu, bevor Sie mehrere Belege erstellen.';

  @override
  String get signInToCreateShoppingLists => 'Melden Sie sich an, um Einkaufslisten zu erstellen.';

  @override
  String get couldNotCreateList => 'Liste konnte nicht erstellt werden. Bitte erneut versuchen.';

  @override
  String get couldNotDeleteList => 'Liste konnte nicht gelöscht werden. Bitte erneut versuchen.';

  @override
  String get couldNotAddItem => 'Artikel konnte nicht hinzugefügt werden. Bitte erneut versuchen.';

  @override
  String get signInToAddShoppingItems => 'Melden Sie sich an, um Artikel zu Ihrer Einkaufsliste hinzuzufügen.';

  @override
  String get itemNameRequired => 'Artikelname ist erforderlich.';

  @override
  String get couldNotUpdateItem => 'Artikel konnte nicht aktualisiert werden. Bitte erneut versuchen.';

  @override
  String get couldNotUpdateQuantity => 'Menge konnte nicht aktualisiert werden. Bitte erneut versuchen.';

  @override
  String get couldNotRemoveItem => 'Artikel konnte nicht entfernt werden. Bitte erneut versuchen.';

  @override
  String get couldNotUpdateShoppingList => 'Einkaufsliste konnte nicht aktualisiert werden. Bitte erneut versuchen.';

  @override
  String get couldNotCompleteAction => 'Aktion konnte nicht abgeschlossen werden. Bitte erneut versuchen.';

  @override
  String estimatedPrefix(String amount) {
    return 'Geschätzt: $amount';
  }

  @override
  String shoppingTripFinalized(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Einkauf abgeschlossen. $count Belege erstellt.',
      one: 'Einkauf abgeschlossen. 1 Beleg erstellt.',
    );
    return '$_temp0';
  }

  @override
  String get productChicken => 'Hähnchen';

  @override
  String get productEggs => 'Eier';

  @override
  String get weeklyGroceriesDefault => 'Wöchentlicher Einkauf';

  @override
  String get basketSummary => 'Warenkorbübersicht';

  @override
  String get estimatedBestTotal => 'Geschätzte bestmögliche Summe';

  @override
  String get basketPotentialSaving => 'Potenzielle Ersparnis';

  @override
  String get itemsMatched => 'Artikel zugeordnet';

  @override
  String get noPriceHistoryLabel => 'Keine Preishistorie';

  @override
  String get activeListsIncludedLabel => 'Aktive Listen einbezogen';

  @override
  String get itemRecommendations => 'Artikelempfehlungen';

  @override
  String get bestKnownLabel => 'Bester bekannter Preis';

  @override
  String get latestSeen => 'Zuletzt gesehen';

  @override
  String saveUpToTotal(String amount) {
    return 'Sparen Sie insgesamt bis zu $amount';
  }

  @override
  String get noPriceHistoryYet => 'Noch keine Preishistorie';

  @override
  String get addReceiptsForItemRecommendations => 'Fügen Sie Belege mit diesem Artikel hinzu, um Empfehlungen freizuschalten';

  @override
  String get suggestedStorePlan => 'Vorgeschlagener Einkaufsplan';

  @override
  String estimatedStoreTotalLabel(String amount) {
    return 'Geschätzte Summe im Geschäft: $amount';
  }

  @override
  String storePlanItemLine(String itemName, String quantitySuffix, String unitPrice, String perUnit) {
    return '• $itemName$quantitySuffix — $unitPrice $perUnit';
  }

  @override
  String get perUnit => 'pro Stück';

  @override
  String get signInToOptimizeAllLists => 'Melden Sie sich an, um alle Ihre Einkaufslisten anhand Ihrer Belege zu optimieren.';

  @override
  String get signInToOptimizeBasket => 'Melden Sie sich an, um Ihren Warenkorb anhand Ihrer Belege und Einkaufsliste zu optimieren.';

  @override
  String get loadingAllActiveLists => 'Alle aktiven Listen werden geladen…';

  @override
  String get loadingBasketOptimizer => 'Warenkorb-Optimierer wird geladen…';

  @override
  String get couldNotLoadShoppingList => 'Einkaufsliste konnte nicht geladen werden';

  @override
  String get couldNotLoadPriceHistory => 'Preishistorie konnte nicht geladen werden';

  @override
  String get noActiveItemsToOptimize => 'Keine aktiven Artikel zum Optimieren';

  @override
  String get noActiveItemsToOptimizeMessage => 'Fügen Sie Artikel zu Ihren Einkaufslisten hinzu, um einen smarten Einkaufsplan zu erstellen.';

  @override
  String get backToShopping => 'Zurück zum Einkauf';

  @override
  String get addItemsToListForOptimizer => 'Artikel zur Einkaufsliste hinzufügen';

  @override
  String get addItemsToListForOptimizerMessage => 'Fügen Sie Artikel zu Ihrer Einkaufsliste hinzu, um Ihren Warenkorb zu optimieren.';

  @override
  String get noPriceHistoryForOptimizerMessage => 'Fügen Sie Belege mit Positionen hinzu, damit Savingor Ihre Preise lernt und bessere Geschäfte empfehlen kann.';

  @override
  String listFinalizeProgressSummary(int purchased, int total) {
    return 'Gekauft: $purchased · Artikel gesamt: $total';
  }

  @override
  String qtyWithCount(int count) {
    return 'Menge $count';
  }

  @override
  String get unitPrice => 'Stückpreis';

  @override
  String lineTotalWithAmount(String amount) {
    return 'Zeilensumme: $amount';
  }

  @override
  String get lineTotalEmpty => 'Zeilensumme: —';

  @override
  String enterPriceForProduct(String product) {
    return 'Geben Sie einen Preis für $product ein';
  }

  @override
  String enterValidPriceForProduct(String product) {
    return 'Geben Sie einen gültigen Preis für $product ein';
  }

  @override
  String get trackMonthlyGrocerySpending => 'Verfolgen Sie Ihre monatlichen Lebensmittelausgaben im Vergleich zu Ihrem Budget.';

  @override
  String get monthlyGroceryBudget => 'Monatliches Lebensmittelbudget';

  @override
  String get spentThisMonth => 'Diesen Monat ausgegeben';

  @override
  String get overBudget => 'Budget überschritten';

  @override
  String get remaining => 'Verbleibend';

  @override
  String get updateMonthlyBudget => 'Monatsbudget aktualisieren';

  @override
  String get setMonthlyBudgetDescription => 'Legen Sie das monatliche Ausgabenlimit für Lebensmittel fest, das Sie verfolgen möchten.';

  @override
  String get monthlyBudgetAmount => 'Monatlicher Budgetbetrag';

  @override
  String get saveBudget => 'Budget speichern';

  @override
  String get budgetSaved => 'Budget gespeichert';

  @override
  String get enterBudgetAmount => 'Geben Sie einen Budgetbetrag ein';

  @override
  String get enterAmountGreaterThanZero => 'Geben Sie einen Betrag größer als null ein';

  @override
  String get overview => 'Überblick';

  @override
  String get estimatedSaved => 'Geschätzt gespart';

  @override
  String get potentialMissed => 'Potenziell verpasst';

  @override
  String get savingsValue => 'Sparwert';

  @override
  String get proPayback => 'Pro-Amortisation';

  @override
  String get proPaidForItself => 'Pro hat sich amortisiert';

  @override
  String amountOfPriceCovered(String amount, String price) {
    return '$amount von $price gedeckt';
  }

  @override
  String needAmountMoreForPro(String amount) {
    return 'Noch $amount, um Pro zu decken';
  }

  @override
  String amountAfterSubscription(String amount) {
    return '+$amount nach dem Abo';
  }

  @override
  String monthlyReturnMultiplier(String multiplier) {
    return 'Rendite: ${multiplier}x diesen Monat';
  }

  @override
  String get spendingByStore => 'Ausgaben nach Geschäft';

  @override
  String priceRecordCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Einträge',
      one: '1 Eintrag',
    );
    return '$_temp0';
  }

  @override
  String get recentActivity => 'Letzte Aktivität';

  @override
  String get activityTypeReceipt => 'Beleg';

  @override
  String get activityTypeManual => 'Manuell';

  @override
  String get activityManualExpense => 'Manuelle Ausgabe';

  @override
  String activityReceiptWithItems(String source, int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Artikel',
      one: '1 Artikel',
    );
    return '$source · $_temp0';
  }

  @override
  String get recommendedActions => 'Empfohlene Aktionen';

  @override
  String get exploreDetails => 'Details ansehen';

  @override
  String productsInPriceHistoryCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Produkte in Ihrer Preishistorie',
      one: '1 Produkt in Ihrer Preishistorie',
    );
    return '$_temp0';
  }

  @override
  String get priceInsightsEmptySubtitle => 'Vollständiger Preisspeicher aus Ihren Belegpositionen';

  @override
  String get savingsOpportunities => 'Spar-Chancen';

  @override
  String actionableOpportunitiesCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count umsetzbare Chancen zum Prüfen',
      one: '1 umsetzbare Chance zum Prüfen',
    );
    return '$_temp0';
  }

  @override
  String get savingsOpportunitiesEmptySubtitle => 'Produkte, für die Sie mehr als den besten bekannten Preis gezahlt haben';

  @override
  String get loadingAnalytics => 'Analyse wird geladen…';

  @override
  String get couldNotLoadAnalytics => 'Analyse konnte nicht geladen werden';

  @override
  String get signInForAnalytics => 'Sehen Sie Ausgabenanalysen mit Ihrem Savingor-Konto ein.';

  @override
  String get noSpendingDataYet => 'Noch keine Ausgabendaten';

  @override
  String get noSpendingDataMessage => 'Fügen Sie einen Beleg oder eine Ausgabe hinzu, um Ausgabensummen, Aufschlüsselungen nach Geschäft und Trends zu sehen.';

  @override
  String get addMoreReceiptsForSavingsValue => 'Fügen Sie mehr Belege hinzu, um Ihren Sparwert zu berechnen.';

  @override
  String storeHasSeveralBestPrices(String store) {
    return '$store hat mehrere Ihrer besten bekannten Preise';
  }

  @override
  String trackedProductsLowestAtStore(int count, String store) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count verfolgte Produkte haben derzeit ihren niedrigsten bekannten Preis bei $store',
      one: '1 verfolgtes Produkt hat derzeit seinen niedrigsten bekannten Preis bei $store',
    );
    return '$_temp0';
  }

  @override
  String get useStoreWhenMatchesRoute => 'Nutzen Sie dieses Geschäft, wenn es zu Ihrer Einkaufsroute passt';

  @override
  String recentlyPaidLatestBestKnown(String latestPrice, String latestStore, String bestPrice, String bestStore) {
    return 'Sie haben kürzlich $latestPrice bei $latestStore gezahlt. Ihr bester bekannter Preis ist $bestPrice bei $bestStore.';
  }

  @override
  String basedOnPriceRecords(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Basierend auf $count Preiseinträgen',
      one: 'Basierend auf 1 Preiseintrag',
    );
    return '$_temp0';
  }

  @override
  String watchProductPrices(String product) {
    return 'Beobachten Sie die Preise für $product genau';
  }

  @override
  String knownPricesRangeFromTo(String low, String high) {
    return 'Ihre bekannten Preise reichen von $low bis $high.';
  }

  @override
  String priceDifferenceAmount(String amount) {
    return 'Preisdifferenz: $amount';
  }

  @override
  String get productPriceInsights => 'Produktpreis-Einblicke';

  @override
  String productsInPriceHistoryFromReceipts(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Produkte in Ihrer Preishistorie aus Belegen',
      one: '1 Produkt in Ihrer Preishistorie aus Belegen',
    );
    return '$_temp0';
  }

  @override
  String get latestPriceLabel => 'Zuletzt';

  @override
  String get bestKnownPriceLabel => 'Bester bekannter';

  @override
  String get highestPriceLabel => 'Höchster';

  @override
  String get averagePriceLabel => 'Durchschnitt';

  @override
  String priceAtStore(String price, String store) {
    return '$price bei $store';
  }

  @override
  String get signInForPriceMemory => 'Melden Sie sich an, um Ihren Produktpreisspeicher anzusehen.';

  @override
  String get loadingPriceMemory => 'Preisspeicher wird geladen…';

  @override
  String get couldNotLoadPriceMemory => 'Preisspeicher konnte nicht geladen werden';

  @override
  String get noPriceMemoryYet => 'Noch kein Preisspeicher';

  @override
  String get noPriceMemoryMessage => 'Fügen Sie Belege mit Positionen hinzu, um Ihren Preisspeicher aufzubauen.';

  @override
  String savingsOpportunitiesPaidMoreCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Sparmöglichkeiten, bei denen Sie mehr als den besten bekannten Preis gezahlt haben',
      one: '1 Sparmöglichkeit, bei der Sie mehr als den besten bekannten Preis gezahlt haben',
    );
    return '$_temp0';
  }

  @override
  String saveUpToPerItem(String amount) {
    return 'Sparen Sie bis zu $amount pro Einheit';
  }

  @override
  String youPaidAtStore(String amount, String store) {
    return 'Sie haben $amount bei $store gezahlt';
  }

  @override
  String get recommendationWatchProductBeforeBuying => 'Empfehlung: Beobachten Sie dieses Produkt vor dem nächsten Kauf.';

  @override
  String recommendationBuyAtStoreNextTime(String store) {
    return 'Empfehlung: Kaufen Sie beim nächsten Mal bei $store.';
  }

  @override
  String get signInForSavingsOpportunities => 'Melden Sie sich an, um Sparmöglichkeiten aus Ihren Belegen zu sehen.';

  @override
  String get loadingSavingsOpportunities => 'Sparmöglichkeiten werden geladen…';

  @override
  String get couldNotLoadSavingsOpportunities => 'Sparmöglichkeiten konnten nicht geladen werden';

  @override
  String get noSavingsOpportunitiesYet => 'Noch keine Sparmöglichkeiten';

  @override
  String get noSavingsOpportunitiesMessage => 'Fügen Sie mehr Belege mit Positionen hinzu, damit Savingor Preise zwischen Geschäften vergleichen kann.';

  @override
  String get recordsLabel => 'Einträge';

  @override
  String get buyingAdvice => 'Kauftipp';

  @override
  String get bestKnownPriceAdviceLabel => 'Bester bekannter Preis';

  @override
  String get latestPaidAdviceLabel => 'Zuletzt gezahlter Preis';

  @override
  String buyItemAtStoreWhenFitsRoute(String store) {
    return 'Kaufen Sie diesen Artikel bei $store, wenn es zu Ihrer Route passt.';
  }

  @override
  String get buyItemAtBestPriceWhenFitsRoute => 'Kaufen Sie diesen Artikel dort, wo Sie zuvor den besten Preis gefunden haben, wenn es zu Ihrer Route passt.';

  @override
  String get addToShoppingList => 'Zur Einkaufsliste hinzufügen';

  @override
  String get priceHistory => 'Preishistorie';

  @override
  String get productHistoryTitle => 'Produkthistorie';

  @override
  String get productNotFound => 'Produkt nicht gefunden.';

  @override
  String get buyingAdviceInsufficientHistory => 'Fügen Sie mehr Belege mit diesem Artikel hinzu, um intelligentere Kauftipps freizuschalten.';

  @override
  String get buyingAdvicePaidBestPrice => 'Sie haben Ihren besten bekannten Preis gezahlt.';

  @override
  String get buyingAdviceNoBetterPriceYet => 'Noch kein besserer bekannter Preis.';

  @override
  String quantityLabelWithCount(String count) {
    return 'Menge: $count';
  }

  @override
  String get addedToShoppingList => 'Zur Einkaufsliste hinzugefügt';

  @override
  String get alreadyInShoppingList => 'Bereits in der Einkaufsliste';

  @override
  String get quantityUpdatedSnack => 'Menge aktualisiert';

  @override
  String get nearbyStores => 'Geschäfte in der Nähe';

  @override
  String get nearbyStoresSubtitle => 'Finden Sie Lebensmittelgeschäfte in Ihrer Nähe und vergleichen Sie Sparmöglichkeiten.';

  @override
  String get storesNearby => 'Geschäfte in der Nähe';

  @override
  String mapStoresFoundCount(int count) {
    return '$count gefunden';
  }

  @override
  String get mapStoresFootnotePlaces => 'Geschäfte basieren auf Ihrem gewählten Standort und Suchradius.';

  @override
  String get mapStoresFootnoteFallback => 'Lebensmittelgeschäfte in Ihrem gewählten Gebiet werden angezeigt.';

  @override
  String get mapStoresFootnoteDefault => 'Entdecken Sie Lebensmittelgeschäfte in der Nähe Ihres gewählten Standorts.';

  @override
  String mapNoStoresWithinRadius(int distance) {
    return 'Keine Geschäfte im Umkreis von $distance km. Versuchen Sie einen größeren Radius.';
  }

  @override
  String get mapPleaseEnterCityOrArea => 'Bitte geben Sie eine Stadt oder ein Gebiet ein.';

  @override
  String get mapCouldNotOpenDirections => 'Route konnte nicht geöffnet werden.';

  @override
  String get mapYourLocation => 'Ihr Standort';

  @override
  String get mapFindGroceryStoresNearYou => 'Finden Sie Lebensmittelgeschäfte in Ihrer Nähe';

  @override
  String get mapActive => 'Aktiv';

  @override
  String get mapSearchRadius => 'Suchradius';

  @override
  String get mapCheckingLocation => 'Standort wird geprüft...';

  @override
  String get mapLocationSelected => 'Standort ausgewählt';

  @override
  String get mapLocationDetected => 'Standort erkannt';

  @override
  String get mapReadyToSearchNearby => 'Bereit, Lebensmittelgeschäfte in der Nähe zu suchen.';

  @override
  String get mapCouldNotAccessLocation => 'Zugriff auf Ihren Standort nicht möglich.';

  @override
  String get mapEnableLocationPrompt => 'Aktivieren Sie den Standort, um Lebensmittelgeschäfte in Ihrer Nähe zu finden.';

  @override
  String get mapUseMyLocation => 'Meinen Standort verwenden';

  @override
  String get mapEnterCityManually => 'Stadt manuell eingeben';

  @override
  String get mapLocationServicesDisabled => 'Standortdienste sind deaktiviert.';

  @override
  String get mapLocationPermissionDenied => 'Standortberechtigung verweigert.';

  @override
  String get mapCouldNotDetectLocation => 'Ihr Standort konnte nicht ermittelt werden. Bitte versuchen Sie es erneut.';

  @override
  String get mapSetYourLocation => 'Standort festlegen';

  @override
  String get mapSetLocationGpsOrCity => 'Verwenden Sie GPS oder wählen Sie eine Stadt, um nahegelegene Geschäfte anzuzeigen.';

  @override
  String get mapCurrentLocation => 'Aktueller Standort';

  @override
  String get directions => 'Route';

  @override
  String get mapStoreCategoryGrocery => 'Lebensmittel';

  @override
  String get mapStoreCategorySupermarket => 'Supermarkt';

  @override
  String get mapStoreCategoryWholesale => 'Großhandel';

  @override
  String get mapNearbyStoreStatus => 'Geschäft in der Nähe';

  @override
  String get mapListedOnGooglePlaces => 'In Google Places gelistet';

  @override
  String mapRadiusKm(int distance) {
    return '$distance km';
  }

  @override
  String get mapSetLocation => 'Standort festlegen';

  @override
  String get mapCityOrArea => 'Stadt oder Gebiet';

  @override
  String get mapCityOrAreaExample => 'Beispiel: Calgary, Cochrane, Edmonton';

  @override
  String mapMarkerSnippetWithDetail(String distance, String detail) {
    return '$distance · $detail';
  }

  @override
  String get aiSavingsAssistant => 'KI-Sparassistent';

  @override
  String get aiProPreviewDescription => 'Erhalten Sie personalisierte Spartipps für Lebensmittel basierend auf Ihren Belegen, Einkaufslisten, Ausgabenhistorie und lokalen Geschäften.';

  @override
  String get aiProBenefitPersonalizedRecommendations => 'Personalisierte Spar-Empfehlungen';

  @override
  String get aiProBenefitStoreComparisons => 'Intelligentere Vergleiche von Geschäften und Produkten';

  @override
  String get aiProBenefitSpendingInsights => 'Ausgaben-Einblicke basierend auf Belegverlauf';

  @override
  String get aiProBenefitBudgetAnswers => 'KI-Antworten zu Ihrem Lebensmittelbudget';

  @override
  String get unlockWithSavingorPro => 'Mit Savingor Pro freischalten';

  @override
  String get viewProBenefits => 'Pro-Vorteile ansehen';

  @override
  String get aiSignInPrompt => 'Melden Sie sich an, um den KI-Assistenten zu Belegen und Einkaufslisten zu befragen.';

  @override
  String get aiLoadingYourData => 'Ihre Daten werden geladen…';

  @override
  String get aiCouldNotLoadData => 'Ihre Daten konnten nicht geladen werden';

  @override
  String get aiEmptyTitle => 'Daten hinzufügen für KI-Einblicke';

  @override
  String get aiEmptyMessage => 'Scannen Sie einen Beleg, fügen Sie eine Ausgabe hinzu oder erstellen Sie eine Einkaufsliste. Der Assistent analysiert gespeicherte Daten — keine Live-Preise im Geschäft.';

  @override
  String get aiHeroTitle => 'Ihr KI-Sparcoach';

  @override
  String get aiHeroSubtitleLive => 'Fragen Sie zu Ausgaben, Belegen und Einkaufslisten.';

  @override
  String get aiHeroSubtitlePreview => 'Vorschau-Einblicke aus gespeicherten Daten — verbinden Sie einen API-Schlüssel für Live-Antworten.';

  @override
  String get aiConfigReadyMessage => 'Der KI-Assistent ist bereit. Verbinden Sie einen API-Schlüssel, um Live-Antworten zu aktivieren.';

  @override
  String get aiDataSnapshot => 'Ihr Datenüberblick';

  @override
  String aiReceiptCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Belege',
      one: '1 Beleg',
    );
    return '$_temp0';
  }

  @override
  String aiExpenseCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Ausgaben',
      one: '1 Ausgabe',
    );
    return '$_temp0';
  }

  @override
  String aiTotalSpendingLabel(String amount) {
    return '$amount gesamt';
  }

  @override
  String aiListCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Listen',
      one: '1 Liste',
    );
    return '$_temp0';
  }

  @override
  String aiListEstimateLabel(String amount) {
    return '$amount Listen-Schätzung';
  }

  @override
  String get aiSuggestedQuestions => 'Vorgeschlagene Fragen';

  @override
  String get aiSuggestSaveMoreThisWeek => 'Wie kann ich diese Woche mehr sparen?';

  @override
  String get aiSuggestTopStore => 'In welchem Geschäft gebe ich am meisten aus?';

  @override
  String get aiSuggestAnalyzeSpending => 'Analysiere meine Lebensmittelausgaben.';

  @override
  String get aiSuggestShoppingListPriority => 'Was soll ich zuerst von meiner Einkaufsliste kaufen?';

  @override
  String get aiAnalyzingYourData => 'Ihre Daten werden analysiert…';

  @override
  String get aiCouldNotGetAnswer => 'Antwort konnte nicht abgerufen werden. Bitte versuchen Sie es erneut.';

  @override
  String get aiInsightsDisclaimer => 'Einblicke basieren auf gespeicherten Belegen, Ausgaben und Einkaufslisten in Savingor — nicht auf Live-Preisen oder Angeboten im Geschäft.';

  @override
  String get aiInputHintLive => 'Fragen Sie zu Ausgaben oder Ihrer Einkaufsliste…';

  @override
  String get aiInputHintPreview => 'Frage eingeben — API-Schlüssel für Live-Antworten verbinden';

  @override
  String get aiRequestFailed => 'KI-Anfrage fehlgeschlagen. Bitte versuchen Sie es erneut.';

  @override
  String get aiEmptyResponse => 'Die KI hat eine leere Antwort zurückgegeben.';

  @override
  String get aiSend => 'Senden';

  @override
  String get editProfile => 'Profil bearbeiten';

  @override
  String get personalInformation => 'Persönliche Informationen';

  @override
  String get editProfileFullNameHint => 'Ihr vollständiger Name';

  @override
  String get emailChangesNotAvailable => 'E-Mail-Änderungen sind in dieser Version nicht verfügbar.';

  @override
  String get password => 'Passwort';

  @override
  String get passwordNeverShown => 'Aus Sicherheitsgründen wird Ihr aktuelles Passwort nie angezeigt.';

  @override
  String get changePassword => 'Passwort ändern';

  @override
  String get sendPasswordResetEmailInstead => 'Passwort-Zurücksetzungs-E-Mail senden';

  @override
  String get sendingResetEmail => 'E-Mail wird gesendet...';

  @override
  String get changesSaved => 'Änderungen gespeichert';

  @override
  String get couldNotSaveChanges => 'Änderungen konnten nicht gespeichert werden';

  @override
  String get pleaseEnterFullName => 'Bitte geben Sie Ihren vollständigen Namen ein';

  @override
  String get signInToEditProfile => 'Melden Sie sich an, um Ihr Profil zu bearbeiten.';

  @override
  String get passwordResetEmailSent => 'Zurücksetzungs-E-Mail gesendet';

  @override
  String get changePasswordIntro => 'Um Ihr Passwort in der App zu ändern, geben Sie zuerst Ihr aktuelles Passwort ein.';

  @override
  String get currentPassword => 'Aktuelles Passwort';

  @override
  String get newPassword => 'Neues Passwort';

  @override
  String get confirmNewPassword => 'Neues Passwort bestätigen';

  @override
  String get enterCurrentPasswordHint => 'Aktuelles Passwort eingeben';

  @override
  String get atLeast6CharactersHint => 'Mindestens 6 Zeichen';

  @override
  String get repeatNewPasswordHint => 'Neues Passwort wiederholen';

  @override
  String get currentPasswordRequired => 'Aktuelles Passwort ist erforderlich';

  @override
  String get newPasswordRequired => 'Neues Passwort ist erforderlich';

  @override
  String get newPasswordMinLength => 'Das neue Passwort muss mindestens 6 Zeichen haben';

  @override
  String get confirmNewPasswordRequired => 'Bitte bestätigen Sie Ihr neues Passwort';

  @override
  String get passwordsDoNotMatch => 'Passwörter stimmen nicht überein';

  @override
  String get updatePassword => 'Passwort aktualisieren';

  @override
  String get forgotCurrentPassword => 'Aktuelles Passwort vergessen?';

  @override
  String get passwordResetSecureLink => 'Wir senden einen sicheren Link an Ihre E-Mail, damit Sie ein neues Passwort erstellen können.';

  @override
  String get passwordResetByEmailHint => 'Wenn Sie es nicht wissen, nutzen Sie die Passwort-Zurücksetzung per E-Mail.';

  @override
  String get sendResetEmail => 'Zurücksetzungs-E-Mail senden';

  @override
  String get sending => 'Wird gesendet...';

  @override
  String get passwordUpdated => 'Passwort aktualisiert';

  @override
  String get showPassword => 'Passwort anzeigen';

  @override
  String get hidePassword => 'Passwort ausblenden';

  @override
  String get signInToChangePassword => 'Melden Sie sich an, um Ihr Passwort zu ändern.';

  @override
  String get currentPasswordIncorrect => 'Aktuelles Passwort ist falsch';

  @override
  String get passwordTooWeak => 'Passwort ist zu schwach';

  @override
  String get recentLoginRequired => 'Aus Sicherheitsgründen melden Sie sich erneut an und versuchen Sie es noch einmal.';

  @override
  String get tooManyAttempts => 'Zu viele Versuche. Bitte versuchen Sie es später erneut.';

  @override
  String get couldNotUpdatePassword => 'Passwort konnte nicht aktualisiert werden';

  @override
  String get noEmailLinked => 'Mit diesem Konto ist keine E-Mail verknüpft.';

  @override
  String get couldNotSendResetEmail => 'E-Mail konnte nicht gesendet werden';

  @override
  String get plans => 'Tarife';

  @override
  String get freeTodayProWhenReady => 'Free heute · Pro, wenn Sie bereit sind';

  @override
  String get saveSmarterWithAi => 'Sparen Sie smarter mit KI';

  @override
  String get unlockProFeaturesDescription => 'Schalten Sie KI-Spartipps, Beleganalysen, smarte Benachrichtigungen und detaillierte Ausgabenberichte frei.';

  @override
  String get bestValue => 'Bestes Angebot';

  @override
  String get basicDealsBrowsing => 'Grundlegende Angebotsübersicht';

  @override
  String get manualExpenseTracking => 'Manuelle Ausgabenverfolgung';

  @override
  String get aiPoweredToolsDescription => 'KI-gestützte Tools für smartere Lebensmittelersparnisse.';

  @override
  String get receiptAnalytics => 'Beleganalyse';

  @override
  String get smartSavingsInsights => 'Intelligente Spartipps';

  @override
  String get spendingReports => 'Ausgabenberichte';

  @override
  String get smartAlerts => 'Smarte Benachrichtigungen';

  @override
  String get startProSubscription => 'Pro-Abo starten';

  @override
  String get restorePurchases => 'Käufe wiederherstellen';

  @override
  String get restoring => 'Wird wiederhergestellt...';

  @override
  String get proSubscriptionActivated => 'Abonnement aktiviert';

  @override
  String get proDemoFallbackActivated => 'Pro-Demo aktiviert — keine echte Zahlung verarbeitet.';

  @override
  String get couldNotCompletePurchase => 'Kauf konnte nicht abgeschlossen werden. Bitte versuchen Sie es erneut.';

  @override
  String get couldNotActivateProDemo => 'Pro-Demo konnte nicht aktiviert werden. Bitte versuchen Sie es erneut.';

  @override
  String get purchaseRestored => 'Kauf wiederhergestellt';

  @override
  String get noPurchasesFound => 'Keine Käufe gefunden';

  @override
  String get couldNotRestorePurchases => 'Käufe konnten nicht wiederhergestellt werden';

  @override
  String get subscriptionSetup => 'Abonnement-Einrichtung';

  @override
  String get subscriptionSetupPrepared => 'Savingor Pro ist für die echte In-App-Abonnement-Integration vorbereitet.';

  @override
  String get subscriptionSetupNotConfigured => 'Zahlungsanbieter-Schlüssel oder Store-Produkte sind in dieser Version nicht konfiguriert.';

  @override
  String get activateProDemoForTesting => 'Pro-Demo zum Testen aktivieren';

  @override
  String get demoFallbackActive => 'Demo aktiv — keine echte Zahlung verarbeitet.';

  @override
  String get subscriptionPlanLabel => 'Tarif';

  @override
  String pricePerMonth(String price) {
    return '$price / Monat';
  }

  @override
  String get active => 'Aktiv';

  @override
  String get activeDemo => 'Aktive Demo';

  @override
  String get cancelled => 'Gekündigt';

  @override
  String get unknown => 'Unbekannt';

  @override
  String get demoMode => 'Demomodus';

  @override
  String get providerNone => 'Keiner';

  @override
  String get revenueCatLabel => 'RevenueCat';

  @override
  String get subscriptionManagedByStore => 'Ihr Abonnement wird vom App Store oder Google Play verwaltet. Sie können es in den Abonnementeinstellungen des Stores kündigen oder ändern.';

  @override
  String get manageInAppStoreGooglePlay => 'Im App Store / Google Play verwalten';

  @override
  String get cancelProDemo => 'Pro-Demo kündigen';

  @override
  String get noActiveSubscription => 'Kein aktives Abonnement';

  @override
  String get proDemoCancelled => 'Pro-Demo gekündigt. Sie sind wieder im Free-Tarif.';

  @override
  String get couldNotCancelProDemo => 'Pro-Demo konnte nicht gekündigt werden. Bitte versuchen Sie es erneut.';

  @override
  String get couldNotOpenSubscriptionManagement => 'Abonnement-Verwaltungsseite konnte nicht geöffnet werden.';

  @override
  String get managementNotAvailable => 'Verwaltung nicht verfügbar';

  @override
  String get managementUrlUnavailableMessage => 'Die Abonnement-Verwaltungs-URL ist in dieser Testversion nicht verfügbar. Setzen Sie für RevenueCat Test Store-Käufe den Testkunden im RevenueCat-Dashboard zurück oder verwenden Sie ein neues Testkonto.';

  @override
  String get paymentProviderNotConfiguredSnack => 'Zahlungsanbieter ist in dieser lokalen Version nicht konfiguriert.';

  @override
  String get purchaseCancelled => 'Kauf abgebrochen';

  @override
  String get purchaseFailed => 'Kauf fehlgeschlagen';

  @override
  String get productUnavailable => 'Produkt nicht verfügbar';

  @override
  String get purchaseNotActiveYet => 'Kauf abgeschlossen, aber Pro ist noch nicht aktiv. Versuchen Sie Käufe wiederherstellen.';

  @override
  String get networkErrorTryAgain => 'Überprüfen Sie Ihre Verbindung und versuchen Sie es erneut';

  @override
  String get signInToManageSubscription => 'Melden Sie sich an, um Ihr Abonnement zu verwalten.';

  @override
  String get couldNotUpdateSubscription => 'Abonnement konnte nicht aktualisiert werden. Bitte versuchen Sie es erneut.';

  @override
  String get debugSubscriptionTestingTitle => 'Entwickler-Abonnementtest';

  @override
  String get debugSubscriptionTestingDescription => 'Savingor vorübergehend als Free- oder Pro-Nutzer ansehen. Dies ändert das echte Abonnement nicht.';

  @override
  String get debugSubscriptionUseReal => 'Echtes Abonnement verwenden';

  @override
  String get debugSubscriptionTestAsFree => 'Als Free testen';

  @override
  String get debugSubscriptionTestAsPro => 'Als Pro testen';

  @override
  String get debugSubscriptionOverrideFree => 'Entwickler-Planüberschreibung: Free';

  @override
  String get debugSubscriptionOverridePro => 'Entwickler-Planüberschreibung: Pro';

  @override
  String get proFeatureBasketOptimizerDescription => 'Vergleichen Sie Ihren Einkaufskorb über Geschäfte hinweg und finden Sie intelligentere Wege, weniger auszugeben.';

  @override
  String get proFeatureBasketBenefitOptimizeAcrossStores => 'Optimieren Sie den Einkaufskorb in nahegelegenen Geschäften';

  @override
  String get proFeatureBasketBenefitCompareTotals => 'Vergleichen Sie geschätzte Korbsummen';

  @override
  String get proFeatureBasketBenefitEconomicalCombination => 'Finden Sie eine wirtschaftlichere Geschäftskombination';

  @override
  String get proFeatureBasketBenefitReduceSpending => 'Reduzieren Sie unnötige Lebensmittelausgaben';

  @override
  String get proFeatureSavingsAnalyticsDescription => 'Verstehen Sie Spar-Trends, Ausgabenmuster und personalisierte Empfehlungen.';

  @override
  String get proFeatureAnalyticsBenefitDeeperTrends => 'Tiefere Spar-Trends ansehen';

  @override
  String get proFeatureAnalyticsBenefitComparePeriods => 'Ausgabenperioden vergleichen';

  @override
  String get proFeatureAnalyticsBenefitTrackSavings => 'Geschätzte Ersparnisse verfolgen';

  @override
  String get proFeatureAnalyticsBenefitAdvancedRecommendations => 'Erweiterte Empfehlungen erhalten';

  @override
  String get proFeatureProductPriceInsightsDescription => 'Verfolgen Sie Produktpreisverläufe und erhalten Sie intelligentere Kaufberatung aus Ihren Belegen.';

  @override
  String get proFeaturePriceInsightsBenefitHistory => 'Produktpreisverlauf ansehen';

  @override
  String get proFeaturePriceInsightsBenefitCompareStores => 'Aktuelle Geschäftspreise vergleichen';

  @override
  String get proFeaturePriceInsightsBenefitBuyingAdvice => 'Kaufberatung erhalten';

  @override
  String get proFeaturePriceInsightsBenefitPurchaseTiming => 'Günstigen Kaufzeitpunkt erkennen';

  @override
  String get proFeatureSavingsOpportunitiesDescription => 'Entdecken Sie personalisierte Sparaktionen basierend auf Einkaufs- und Belegverlauf.';

  @override
  String get proFeatureOpportunitiesBenefitPersonalized => 'Personalisierte Sparwege finden';

  @override
  String get proFeatureOpportunitiesBenefitPrioritize => 'Hochwertige Aktionen priorisieren';

  @override
  String get proFeatureOpportunitiesBenefitReceiptHistory => 'Beleg- und Einkaufshistorie nutzen';

  @override
  String get proFeatureOpportunitiesBenefitBetterChoices => 'Bessere Geschäfte und Produkte entdecken';

  @override
  String get savingorPro => 'Savingor Pro';

  @override
  String get plansHeroTitle => 'Wählen Sie Ihren Savingor-Plan';

  @override
  String get plansHeroSubtitle => 'Starten Sie kostenlos mit wichtigen Lebensmittel-Tools. Upgraden Sie auf Pro, wenn Sie erweiterte Spar-Intelligenz wünschen.';

  @override
  String get planFreeSubtitle => 'Wichtige Tools zum Verfolgen von Lebensmittelausgaben und zum Sparen.';

  @override
  String get planProSubtitle => 'Erweiterte Automatisierung und personalisierte Spar-Intelligenz.';

  @override
  String get planFreePrice => 'CAD \$0';

  @override
  String get planProPricePerMonth => 'CAD \$14.99 / Monat';

  @override
  String get upgradeToSavingorPro => 'Auf Savingor Pro upgraden';

  @override
  String get planComparisonTitle => 'Pläne vergleichen';

  @override
  String get planIncludedFeaturesTitle => 'Enthaltene Funktionen';

  @override
  String get planProActiveFeaturesTitle => 'Aktive Pro-Funktionen';

  @override
  String get planProComingSoonFeaturesTitle => 'Zukünftige Pro-Funktionen';

  @override
  String get planColumnFree => 'Free';

  @override
  String get planColumnPro => 'Pro';

  @override
  String get planAvailabilityIncluded => 'Enthalten';

  @override
  String get planAvailabilityLocked => 'Gesperrt';

  @override
  String get planAvailabilityUnlimited => 'Unbegrenzt';

  @override
  String get planAvailabilityThreeScansPerMonth => '3 pro Monat';

  @override
  String get planFeatureGroceryDashboard => 'Lebensmittel-Ausgaben-Dashboard';

  @override
  String get planFeatureNearbyStoreMap => 'Karte nahegelegener Geschäfte';

  @override
  String get planFeatureShoppingLists => 'Einkaufslisten';

  @override
  String get planFeatureManualExpenseTracking => 'Manuelle Ausgabenverfolgung';

  @override
  String get planFeatureThreeReceiptScansPerMonth => '3 Beleg-Scans pro Monat';

  @override
  String get planFeatureBasicReceiptExpenseHistory => 'Basis-Beleg- und Ausgabenverlauf';

  @override
  String get planFeatureBasicSavingsOpportunities => 'Basis-Spar-Chancen';

  @override
  String get planFeatureBasicProductPriceInsights => 'Basis-Produktpreis-Insights';

  @override
  String get planFeatureAppSettings => 'Sprache, Design, Region und Währung';

  @override
  String get planFeatureUnlimitedReceiptScanning => 'Unbegrenztes Beleg-Scannen';

  @override
  String get planFeatureBasketOptimizer => 'Warenkorb-Optimierer';

  @override
  String get planFeatureAdvancedSavingsAnalytics => 'Erweiterte Spar-Analytik';

  @override
  String get planFeatureSmartPriceDropAlerts => 'Intelligente Preissenkungs-Alerts';

  @override
  String get planFeatureAdvancedSpendingReports => 'Erweiterte Ausgabenberichte';

  @override
  String get planCompareReceiptScans => 'Beleg-Scans';

  @override
  String get planCompareBasicSavingsOpportunities => 'Basis-Spar-Chancen';

  @override
  String get planCompareBasicProductPriceInsights => 'Basis-Produktpreis-Insights';
}
