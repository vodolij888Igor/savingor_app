import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for French (`fr`).
class AppLocalizationsFr extends AppLocalizations {
  AppLocalizationsFr([String locale = 'fr']) : super(locale);

  @override
  String get appName => 'Savingor';

  @override
  String get appSubtitle => 'Offres locales et économies malines';

  @override
  String get home => 'Accueil';

  @override
  String get deals => 'Offres';

  @override
  String get receipts => 'Reçus';

  @override
  String get analytics => 'Analytique';

  @override
  String get profile => 'Profil';

  @override
  String get scanner => 'Scanner de tickets';

  @override
  String get shopping => 'Liste de courses';

  @override
  String get saved => 'Enregistrés';

  @override
  String get storesMap => 'Carte';

  @override
  String get aiAssistant => 'IA';

  @override
  String get scanReceipt => 'Scanner un reçu';

  @override
  String get dealsMap => 'Carte des offres';

  @override
  String get receiptScanner => 'Scanner de tickets';

  @override
  String get shoppingList => 'Liste de courses';

  @override
  String get mvp => 'MVP v0.1';

  @override
  String get searchHint => 'Rechercher des offres ou magasins...';

  @override
  String get filter => 'Filtre';

  @override
  String get dealsMapSubtitle => 'Affiche les offres à proximité';

  @override
  String get receiptScannerSubtitle => 'Scanner un ticket';

  @override
  String get shoppingListSubtitle => 'Liste intelligente';

  @override
  String dealsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count offres',
      one: '$count offre',
    );
    return '$_temp0';
  }

  @override
  String get noDealsFound => 'Aucune offre trouvée';

  @override
  String get resetFilters => 'Réinitialiser les filtres';

  @override
  String get filtersTitle => 'Filtres';

  @override
  String get stores => 'Magasins';

  @override
  String get maxPrice => 'Prix max';

  @override
  String get sort => 'Tri';

  @override
  String get none => 'Aucun';

  @override
  String get priceLowHigh => 'Prix : croissant';

  @override
  String get priceHighLow => 'Prix : décroissant';

  @override
  String get dealDetails => 'Détails de l\'offre';

  @override
  String get dealNotFound => 'Offre introuvable';

  @override
  String get saveDeal => 'Enregistrer l\'offre';

  @override
  String get removeSaved => 'Retirer des enregistrés';

  @override
  String get noSavedDeals => 'Pas encore d\'offres enregistrées';

  @override
  String get savedHint => 'Les offres enregistrées apparaîtront ici';

  @override
  String get cancel => 'Annuler';

  @override
  String get apply => 'Appliquer';

  @override
  String get save => 'Enregistrer';

  @override
  String get back => 'Retour';

  @override
  String get close => 'Fermer';

  @override
  String get signOut => 'Se déconnecter';

  @override
  String get loading => 'Chargement...';

  @override
  String get tryAgain => 'Réessayer';

  @override
  String get comingSoon => 'Bientôt';

  @override
  String get continueButton => 'Continuer';

  @override
  String get edit => 'Modifier';

  @override
  String get ok => 'OK';

  @override
  String get chooseYourLanguage => 'Choisissez votre langue';

  @override
  String get chooseLanguageSubtitle => 'Sélectionnez la langue que Savingor doit utiliser.';

  @override
  String get langSubtitleOnboarding => 'Cela aide à personnaliser votre expérience Savingor.';

  @override
  String get applyLanguage => 'Appliquer la langue';

  @override
  String welcomeBackName(String name) {
    return 'Bon retour, $name ! 👋';
  }

  @override
  String get welcomeBack => 'Bon retour ! 👋';

  @override
  String get readyToSaveSmarterToday => 'Prêt à économiser plus intelligemment aujourd\'hui ?';

  @override
  String get totalExpenses => 'Dépenses totales';

  @override
  String get trackedInSavingor => 'Suivi dans Savingor';

  @override
  String expensesTracked(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count dépenses suivies',
      one: '$count dépense suivie',
    );
    return '$_temp0';
  }

  @override
  String get startSaving => 'Commencer à économiser';

  @override
  String get startSavingHero => '✨ COMMENCER À ÉCONOMISER';

  @override
  String get thisMonth => 'Ce mois-ci';

  @override
  String get spent => 'dépensé';

  @override
  String get recorded => 'enregistré';

  @override
  String get lists => 'listes';

  @override
  String get activeDeals => 'Offres actives';

  @override
  String get estimated => 'estimé';

  @override
  String get monthlyGoal => 'Objectif mensuel';

  @override
  String get noRecentActivity => 'Aucune activité récente';

  @override
  String get expenseAdded => 'Dépense ajoutée';

  @override
  String get addExpenseToSeeHere => 'Ajoutez une dépense pour la voir ici';

  @override
  String get yourSavingsSnapshot => 'Votre aperçu des économies';

  @override
  String get thisMonthSpent => 'Dépensé ce mois-ci';

  @override
  String get potentialSavingsFound => 'Économies potentielles trouvées';

  @override
  String get productsTracked => 'Produits suivis';

  @override
  String get bestActionNow => 'Meilleure action maintenant';

  @override
  String get addMoreReceiptsForSavings => 'Ajoutez plus de reçus pour débloquer des économies personnalisées.';

  @override
  String get account => 'Compte';

  @override
  String get yourAccount => 'Votre compte';

  @override
  String get planAndSubscription => 'Forfait et abonnement';

  @override
  String get appSettings => 'Paramètres de l\'app';

  @override
  String get region => 'Région';

  @override
  String get language => 'Langue';

  @override
  String get appearance => 'Apparence';

  @override
  String get currency => 'Devise';

  @override
  String get notifications => 'Notifications';

  @override
  String get loadingProfile => 'Chargement du profil...';

  @override
  String get noProfileFound => 'Aucun profil trouvé pour ce compte pour le moment.';

  @override
  String get fullName => 'Nom complet';

  @override
  String get email => 'E-mail';

  @override
  String get passwordAndSecurity => 'Mot de passe et sécurité';

  @override
  String get managePassword => 'Gérer le mot de passe';

  @override
  String get currentPlan => 'Forfait actuel';

  @override
  String get proPlan => 'Forfait Pro';

  @override
  String get freePlan => 'Forfait gratuit';

  @override
  String get pro => 'Pro';

  @override
  String get free => 'Gratuit';

  @override
  String get status => 'Statut';

  @override
  String get provider => 'Fournisseur';

  @override
  String get price => 'Prix';

  @override
  String get priceMonthly => '14,99 \$ / mois';

  @override
  String get inactive => 'Inactif';

  @override
  String get freePlanUpgradeMessage => 'Vous êtes actuellement sur le forfait gratuit. Passez à Pro pour débloquer les conseils d\'économie IA, l\'analyse des reçus, les alertes intelligentes et les rapports de dépenses.';

  @override
  String get manageSubscription => 'Gérer l\'abonnement';

  @override
  String get viewPlans => 'Voir les forfaits';

  @override
  String get manageSettings => 'Gérer les paramètres';

  @override
  String get signOutQuestion => 'Se déconnecter ?';

  @override
  String get signOutMessage => 'Vous devrez vous reconnecter pour accéder à votre compte Savingor.';

  @override
  String get couldNotLoadProfile => 'Impossible de charger votre profil. Veuillez réessayer.';

  @override
  String get personalizeSavingor => 'Personnalisez Savingor';

  @override
  String get personalizeSavingorSubtitle => 'Choisissez l\'apparence, la langue et l\'adaptation locale de l\'application.';

  @override
  String get preferences => 'Préférences';

  @override
  String get appLanguage => 'Langue de l\'app';

  @override
  String get appearanceHelper => 'Choisissez l\'apparence de Savingor';

  @override
  String get regionHelper => 'Utilisé pour les magasins à proximité et les offres locales';

  @override
  String get currencyHelper => 'Utilisé pour les prix, budgets et rapports';

  @override
  String get smartSavingsAlerts => 'Alertes d\'économies intelligentes';

  @override
  String get smartSavingsAlertsDescription => 'Recevez des notifications sur les opportunités d\'économie, la progression du budget et les recommandations importantes.';

  @override
  String get regionCanada => 'Canada';

  @override
  String get regionUnitedStates => 'États-Unis';

  @override
  String get appearanceLight => 'Clair';

  @override
  String get appearanceDark => 'Sombre';

  @override
  String get topSavingOpportunities => 'Meilleures opportunités d\'économie';

  @override
  String get seeAll => 'Tout voir';

  @override
  String bestKnownAtStore(String amount, String store) {
    return 'Meilleur prix connu : $amount chez $store';
  }

  @override
  String latestPaidAtStore(String amount, String store) {
    return 'Dernier prix payé : $amount chez $store';
  }

  @override
  String saveUpToAmount(String amount) {
    return 'Économisez jusqu\'à $amount';
  }

  @override
  String get basedOnReceiptHistory => 'Basé sur l\'historique des reçus';

  @override
  String buyProductAtStoreNextTime(String product, String store) {
    return 'Achetez $product chez $store la prochaine fois';
  }

  @override
  String potentialSavingPerItem(String amount) {
    return 'Économie potentielle : $amount par article';
  }

  @override
  String get productBread => 'Pain';

  @override
  String get productMilk => 'Lait';

  @override
  String get delete => 'Supprimer';

  @override
  String get signIn => 'Se connecter';

  @override
  String get signInRequired => 'Connexion requise';

  @override
  String get store => 'Magasin';

  @override
  String get date => 'Date';

  @override
  String get total => 'Total';

  @override
  String get items => 'Articles';

  @override
  String get notes => 'Notes';

  @override
  String get amount => 'Montant';

  @override
  String get category => 'Catégorie';

  @override
  String get scanReceiptSubtitle => 'Scannez un ticket de caisse pour suivre vos dépenses et vos économies.';

  @override
  String get addManually => 'Ajouter manuellement';

  @override
  String recentReceipts(int count) {
    return 'Reçus récents ($count)';
  }

  @override
  String get noReceiptsYet => 'Aucun reçu pour le moment. Scannez ou ajoutez un reçu pour commencer le suivi.';

  @override
  String get deleteReceiptQuestion => 'Supprimer le reçu ?';

  @override
  String get deleteReceipt => 'Supprimer le reçu';

  @override
  String deleteReceiptConfirmMessage(String store, String total) {
    return '$store ($total) sera définitivement supprimé.';
  }

  @override
  String get loadingReceipts => 'Chargement des reçus...';

  @override
  String get couldNotLoadReceipts => 'Impossible de charger les reçus';

  @override
  String get signInToSyncReceipts => 'Enregistrez et synchronisez vos reçus avec votre compte Savingor.';

  @override
  String get chooseReceiptSource => 'Choisissez comment ajouter votre reçu';

  @override
  String freeScansUsedThisMonth(int used, int limit) {
    return '$used sur $limit scans gratuits utilisés ce mois-ci';
  }

  @override
  String freeScansRemaining(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count scans gratuits restants',
      one: '1 scan gratuit restant',
    );
    return '$_temp0';
  }

  @override
  String get noFreeScansRemainingThisMonth => 'Aucun scan gratuit restant ce mois-ci';

  @override
  String get unlimitedScansWithPro => 'Scans illimités avec Pro';

  @override
  String get loadingScanUsage => 'Vérification de l\'utilisation des scans…';

  @override
  String get monthlyScanLimitTitle => 'Limite mensuelle de scans atteinte';

  @override
  String get monthlyScanLimitDescription => 'Vous avez utilisé vos trois scans gratuits de reçus pour ce mois. Passez à Savingor Pro pour un scan illimité.';

  @override
  String get unlockUnlimitedScansWithSavingorPro => 'Débloquez les scans illimités avec Savingor Pro';

  @override
  String get monthlyScanLimitSaveBlocked => 'Vous avez atteint votre limite gratuite de scans pour ce mois. Passez à Pro pour enregistrer plus de reçus scannés.';

  @override
  String get takePhoto => 'Prendre une photo';

  @override
  String get takePhotoSubtitle => 'Utilisez votre appareil photo pour scanner un reçu';

  @override
  String get chooseFromGallery => 'Choisir dans la galerie';

  @override
  String get chooseFromGallerySubtitle => 'Sélectionnez une photo de reçu existante';

  @override
  String get scanningReceipt => 'Scan du reçu...';

  @override
  String get processingReceiptImage => 'Traitement de l\'image...';

  @override
  String get readingReceiptText => 'Lecture du texte du reçu...';

  @override
  String get couldNotScanReceipt => 'Impossible de scanner ce reçu. Essayez une autre photo.';

  @override
  String get receiptCouldNotBeParsed => 'Impossible de lire les détails clés du reçu. Vous pouvez les vérifier et les ajouter manuellement.';

  @override
  String get receiptSavedSuccessfully => 'Reçu enregistré';

  @override
  String get ocrResultPreview => 'Aperçu du résultat OCR';

  @override
  String get noTextDetected => 'Aucun texte détecté. Essayez une photo de reçu plus nette.';

  @override
  String get useThisReceipt => 'Utiliser ce reçu';

  @override
  String get noneDetected => 'Aucun élément détecté';

  @override
  String get rawOcrText => 'Texte OCR brut';

  @override
  String get itemsColon => 'Articles :';

  @override
  String get smartReceiptImprovingTitle => 'Amélioration avec GPT-5.6...';

  @override
  String get smartReceiptImprovingSubtitle => 'Seul le texte du reçu est envoyé de façon sécurisée. L’image reste sur cet appareil.';

  @override
  String get smartReceiptAiEnhanced => 'Amélioré par l’IA';

  @override
  String get smartReceiptAiEnhancedDescription => 'GPT-5.6 a structuré les détails du reçu. Vérifiez et modifiez tout avant d’enregistrer.';

  @override
  String get smartReceiptLocalParser => 'Analyse locale';

  @override
  String get smartReceiptLocalFallbackDescription => 'L’intelligence des reçus est indisponible pour le moment. Les données locales sont prêtes à être vérifiées.';

  @override
  String get smartReceiptLocalQuotaDescription => 'La limite de démonstration Smart Receipt est atteinte. Les données locales sont prêtes à être vérifiées.';

  @override
  String get smartReceiptLocalSignInDescription => 'Connectez-vous pour utiliser l’intelligence des reçus. Les données locales sont prêtes à être vérifiées.';

  @override
  String get smartReceiptReviewTitle => 'Vérifier avant d’enregistrer';

  @override
  String get smartReceiptWarningUncertain => 'Certains détails du reçu étaient incertains. Vérifiez soigneusement ces valeurs.';

  @override
  String get smartReceiptWarningTotals => 'Les totaux du reçu peuvent être incohérents. Vérifiez le sous-total, les taxes, le total et les prix.';

  @override
  String get smartReceiptWarningInvalid => 'Certaines valeurs n’ont pas pu être validées et ont été laissées vides pour vérification.';

  @override
  String get smartReceiptWarningPrivacy => 'Les identifiants privés ont été supprimés avant le traitement du texte du reçu.';

  @override
  String get smartReceiptWarningItems => 'Le reçu contient plus d’articles que Smart Receipt ne peut en traiter. Vérifiez la liste.';

  @override
  String get currencyCodeLabel => 'Code de devise';

  @override
  String get unitOptional => 'Unité (facultatif)';

  @override
  String get unitPriceOptional => 'Prix unitaire (facultatif)';

  @override
  String get lineTotal => 'Total de la ligne';

  @override
  String get addReceipt => 'Ajouter un reçu';

  @override
  String get editReceipt => 'Modifier le reçu';

  @override
  String get saveReceipt => 'Enregistrer le reçu';

  @override
  String get updateReceipt => 'Mettre à jour le reçu';

  @override
  String get storeName => 'Nom du magasin';

  @override
  String get storeAddressOptional => 'Adresse du magasin (facultatif)';

  @override
  String get purchaseDate => 'Date d\'achat';

  @override
  String get categorySummary => 'Catégorie';

  @override
  String get grocery => 'Épicerie';

  @override
  String get subtotalOptional => 'Sous-total (facultatif)';

  @override
  String get taxOptional => 'Taxe (facultatif)';

  @override
  String get receiptTotal => 'Total du reçu';

  @override
  String get autoCalculatedFromItems => 'Calculé automatiquement à partir des articles, sauf si vous modifiez ce champ.';

  @override
  String get notesOptional => 'Notes (facultatif)';

  @override
  String get addItem => 'Ajouter un article';

  @override
  String get addLineItemsHint => 'Ajoutez des lignes pour créer un enregistrement complet du reçu pour le suivi des prix.';

  @override
  String get enterStoreName => 'Entrez un nom de magasin';

  @override
  String get selectPurchaseDate => 'Sélectionnez une date d\'achat';

  @override
  String get enterTotalAmount => 'Entrez le montant total';

  @override
  String get enterValidAmount => 'Entrez un montant valide';

  @override
  String get enterValidTotalAmount => 'Entrez un montant total valide.';

  @override
  String get receiptNotFound => 'Reçu introuvable.';

  @override
  String get item => 'Article';

  @override
  String get itemName => 'Nom de l\'article';

  @override
  String get enterItemName => 'Entrez un nom d\'article';

  @override
  String get qty => 'Qté';

  @override
  String get invalidValue => 'Invalide';

  @override
  String get removeItem => 'Supprimer l\'article';

  @override
  String get categoryOptional => 'Catégorie (facultatif)';

  @override
  String get receiptDetails => 'Détails du reçu';

  @override
  String subtotalLabel(String amount) {
    return 'Sous-total : $amount';
  }

  @override
  String taxLabel(String amount) {
    return 'Taxe : $amount';
  }

  @override
  String get noItemsSaved => 'Aucun article enregistré';

  @override
  String get noLineItemsSaved => 'Aucune ligne n\'a encore été enregistrée pour ce reçu.';

  @override
  String qtyWithValue(String quantity) {
    return 'Qté $quantity';
  }

  @override
  String get couldNotDeleteReceipt => 'Impossible de supprimer le reçu. Veuillez réessayer.';

  @override
  String get saveChanges => 'Enregistrer les modifications';

  @override
  String get receiptSourceManual => 'Manuel';

  @override
  String get receiptSourceScanned => 'Scanné';

  @override
  String get receiptSourceGallery => 'Galerie';

  @override
  String get receiptSourceImported => 'Importé';

  @override
  String get receiptSourceShoppingList => 'Liste de courses';

  @override
  String get receiptSourceUnknown => 'Reçu';

  @override
  String get scanNotes => 'Notes de scan';

  @override
  String get galleryScanNotes => 'Notes de scan depuis la galerie';

  @override
  String get importNotes => 'Notes d\'import';

  @override
  String get tripNotes => 'Notes de course';

  @override
  String get couldNotLoadYourReceipts => 'Impossible de charger vos reçus. Veuillez réessayer.';

  @override
  String get signInToSaveReceipts => 'Connectez-vous pour enregistrer des reçus.';

  @override
  String get couldNotSaveReceipt => 'Impossible d\'enregistrer le reçu. Veuillez réessayer.';

  @override
  String get couldNotUpdateReceipt => 'Impossible de mettre à jour le reçu. Veuillez réessayer.';

  @override
  String get signInToUpdateReceipts => 'Connectez-vous pour mettre à jour des reçus.';

  @override
  String receiptItemsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count articles',
      one: '1 article',
      zero: '0 article',
    );
    return '$_temp0';
  }

  @override
  String get processingReceipt => 'Traitement du reçu';

  @override
  String get readingReceipt => 'Lecture du reçu';

  @override
  String get recognizingText => 'Reconnaissance du texte';

  @override
  String get receiptScannedSuccessfully => 'Reçu scanné avec succès';

  @override
  String get noTextRecognized => 'Aucun texte reconnu';

  @override
  String get couldNotReadReceipt => 'Impossible de lire ce reçu';

  @override
  String get imageTooBlurry => 'L\'image est trop floue';

  @override
  String get tryAnotherPhoto => 'Veuillez essayer une autre photo';

  @override
  String get cameraPermissionRequired => 'L\'autorisation de la caméra est requise';

  @override
  String get galleryPermissionRequired => 'L\'accès à la galerie est requis';

  @override
  String get permissionDenied => 'Autorisation refusée';

  @override
  String get openSettings => 'Ouvrir les paramètres';

  @override
  String get chooseSavingAction => 'Choisissez votre prochaine action';

  @override
  String get addGroceryExpense => 'Ajouter une dépense alimentaire';

  @override
  String get addGroceryExpenseSubtitle => 'Enregistrez un achat manuellement';

  @override
  String get createShoppingListAction => 'Créer une liste de courses';

  @override
  String get createShoppingListSubtitle => 'Planifiez vos achats à l\'avance';

  @override
  String get optimizeShoppingBasket => 'Optimiser le panier';

  @override
  String get optimizeShoppingBasketSubtitle => 'Trouvez des moyens de dépenser moins';

  @override
  String get finalizeShoppingTrip => 'Finaliser la course';

  @override
  String get finalizeShoppingTripSubtitle => 'Terminez vos achats en cours';

  @override
  String get monthlyGoalBudget => 'Objectif mensuel / Budget';

  @override
  String get monthlyGoalBudgetSubtitle => 'Définissez ou modifiez votre objectif mensuel';

  @override
  String get savingsAnalytics => 'Analyse des économies';

  @override
  String get savingsAnalyticsSubtitle => 'Consultez vos dépenses et économies';

  @override
  String get open => 'Ouvrir';

  @override
  String get expenses => 'Dépenses';

  @override
  String get addExpense => 'Ajouter une dépense';

  @override
  String get loadingExpenses => 'Chargement des dépenses...';

  @override
  String get couldNotLoadExpenses => 'Impossible de charger les dépenses';

  @override
  String get couldNotLoadYourExpenses => 'Impossible de charger vos dépenses. Veuillez réessayer.';

  @override
  String get noExpensesYet => 'Aucune dépense pour le moment';

  @override
  String get noExpensesYetMessage => 'Suivez vos achats alimentaires et reçus pour comprendre vos dépenses.';

  @override
  String get signInToSyncExpenses => 'Enregistrez et synchronisez vos dépenses avec votre compte Savingor.';

  @override
  String get deleteExpenseQuestion => 'Supprimer la dépense ?';

  @override
  String deleteExpenseConfirmMessage(String store, String amount) {
    return '« $store » ($amount) sera définitivement supprimé.';
  }

  @override
  String get saveExpense => 'Enregistrer la dépense';

  @override
  String get totalAmount => 'Montant total';

  @override
  String get signInToSaveExpenses => 'Connectez-vous pour enregistrer des dépenses.';

  @override
  String get couldNotSaveExpense => 'Impossible d\'enregistrer la dépense. Veuillez réessayer.';

  @override
  String get couldNotDeleteExpense => 'Impossible de supprimer la dépense. Veuillez réessayer.';

  @override
  String get expenseSaved => 'Dépense enregistrée.';

  @override
  String get uncategorized => 'Non catégorisé';

  @override
  String get recentExpenses => 'Dépenses récentes';

  @override
  String get noExpensesAddedYet => 'Aucune dépense ajoutée pour le moment.';

  @override
  String get pleaseEnterStoreName => 'Veuillez saisir le nom du magasin.';

  @override
  String get pleaseEnterItemName => 'Veuillez saisir le nom de l\'article.';

  @override
  String get pleaseEnterPrice => 'Veuillez saisir un prix.';

  @override
  String get pleaseEnterValidPrice => 'Veuillez saisir un prix valide.';

  @override
  String expenseCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count dépenses',
      one: '1 dépense',
      zero: '0 dépense',
    );
    return '$_temp0';
  }

  @override
  String get newShoppingList => 'Nouvelle liste de courses';

  @override
  String get newList => 'Nouvelle liste';

  @override
  String get createList => 'Créer une liste';

  @override
  String get loadingShoppingLists => 'Chargement des listes de courses...';

  @override
  String get couldNotLoadLists => 'Impossible de charger les listes';

  @override
  String get couldNotLoadYourShoppingLists => 'Impossible de charger vos listes de courses. Veuillez réessayer.';

  @override
  String get noShoppingListsYet => 'Aucune liste de courses pour le moment';

  @override
  String get noShoppingListsYetMessage => 'Créez votre première liste pour planifier vos achats et optimiser votre panier.';

  @override
  String get signInToSyncShoppingLists => 'Créez et synchronisez vos listes de courses avec votre compte Savingor.';

  @override
  String get deleteListQuestion => 'Supprimer la liste ?';

  @override
  String deleteListConfirmMessage(String title) {
    return '« $title » sera définitivement supprimé.';
  }

  @override
  String get deleteList => 'Supprimer la liste';

  @override
  String get optimizeAllLists => 'Optimiser toutes les listes';

  @override
  String get optimizeAllListsSubtitle => 'Trouvez les meilleurs magasins connus pour vos listes de courses actives';

  @override
  String get optimizeThisBasket => 'Optimiser ce panier';

  @override
  String get optimizeThisBasketSubtitle => 'Trouvez les meilleurs magasins connus pour cette liste';

  @override
  String get listNotFound => 'Liste introuvable';

  @override
  String get listNotFoundMessage => 'Cette liste de courses a peut-être été supprimée.';

  @override
  String get backToLists => 'Retour aux listes';

  @override
  String get noShoppingItemsYet => 'Aucun article pour le moment';

  @override
  String get noShoppingItemsYetMessage => 'Ajoutez des articles à cette liste pour suivre vos besoins.';

  @override
  String get shoppingListEmptyMessage => 'Créez et gérez vos listes de courses intelligentes ici.';

  @override
  String get purchased => 'Acheté';

  @override
  String get clearPurchased => 'Effacer les articles achetés';

  @override
  String get estimatedTotalLabel => 'Total estimé';

  @override
  String estimatedShort(String amount) {
    return 'Estim. $amount';
  }

  @override
  String activeCountLabel(int count) {
    return '$count actifs';
  }

  @override
  String purchasedSummary(int count) {
    return '$count achetés';
  }

  @override
  String itemsTotalSummary(int count) {
    return '$count articles au total';
  }

  @override
  String get allItemsPurchased => 'Tous les articles achetés';

  @override
  String get saveItem => 'Enregistrer l\'article';

  @override
  String get listTitle => 'Titre de la liste';

  @override
  String get enterListTitle => 'Saisissez un titre de liste';

  @override
  String get listName => 'Nom de la liste';

  @override
  String get enterListName => 'Saisissez un nom de liste';

  @override
  String get newShoppingListHint => 'Donnez un nom à votre liste. Vous pourrez ajouter des articles après sa création.';

  @override
  String get itemsOptional => 'Articles (facultatif)';

  @override
  String get addAnotherItem => 'Ajouter un autre article';

  @override
  String get storeOptional => 'Magasin (facultatif)';

  @override
  String get priceOptional => 'Prix (facultatif)';

  @override
  String get loadingListItems => 'Chargement des articles...';

  @override
  String get loadingShoppingList => 'Chargement de la liste de courses...';

  @override
  String get couldNotLoadItems => 'Impossible de charger les articles';

  @override
  String get couldNotLoadListItems => 'Impossible de charger les articles de la liste. Veuillez réessayer.';

  @override
  String get createAnotherReceiptQuestion => 'Créer un autre reçu ?';

  @override
  String get createAnotherReceiptMessage => 'Cette liste a peut-être déjà un reçu. Créer un autre reçu à partir des articles achetés ?';

  @override
  String get createReceipt => 'Créer un reçu';

  @override
  String get signInToFinalizeTrip => 'Connectez-vous pour finaliser une course.';

  @override
  String get noListsReadyToFinalize => 'Aucune liste prête à finaliser';

  @override
  String get noListsReadyToFinalizeMessage => 'Marquez les articles comme achetés sur une liste de courses, puis revenez ici pour créer un reçu.';

  @override
  String get openShoppingLists => 'Ouvrir les listes de courses';

  @override
  String get selectListToFinalize => 'Sélectionner une liste à finaliser';

  @override
  String get selectListToFinalizeSubtitle => 'Choisissez une liste de courses avec des articles achetés.';

  @override
  String get finalizeShoppingTripCardSubtitle => 'Créez un reçu à partir des articles achetés et mettez à jour votre historique de prix';

  @override
  String get done => 'Terminé';

  @override
  String get optional => 'Facultatif';

  @override
  String get somethingWentWrong => 'Une erreur s\'est produite';

  @override
  String get saving => 'Enregistrement...';

  @override
  String get loadingPurchasedItems => 'Chargement des articles achetés...';

  @override
  String get preparingPurchasedItems => 'Préparation des articles achetés...';

  @override
  String get noPurchasedItemsYet => 'Aucun article acheté pour le moment';

  @override
  String get noPurchasedItemsYetMessage => 'Cochez les articles achetés avant de créer un reçu.';

  @override
  String get backToList => 'Retour à la liste';

  @override
  String get enterStoreNameForTrip => 'Saisissez le nom du magasin pour cette course';

  @override
  String get enterStoreNameForTripSnack => 'Saisissez le nom du magasin pour cette course.';

  @override
  String creatingReceiptsPerStore(int count) {
    return 'Création de $count reçus — un par magasin.';
  }

  @override
  String get missingStoreOnItems => 'Certains articles achetés n\'ont pas de magasin. Ajoutez un magasin à chaque article avant de finaliser.';

  @override
  String get missingStore => 'Magasin manquant';

  @override
  String receiptSubtotalLabel(String amount) {
    return 'Sous-total du reçu : $amount';
  }

  @override
  String get purchasedItems => 'Articles achetés';

  @override
  String get enterReceiptTotal => 'Saisissez le total du reçu';

  @override
  String get enterValidReceiptTotal => 'Saisissez un total de reçu valide';

  @override
  String subtotalFromItemPrices(String amount) {
    return 'Sous-total des prix des articles : $amount';
  }

  @override
  String grandTotalAcrossReceipts(String amount) {
    return 'Total général sur tous les reçus : $amount';
  }

  @override
  String get saveReceipts => 'Enregistrer les reçus';

  @override
  String addValidPricesForStore(String store) {
    return 'Ajoutez des prix valides pour les articles achetés chez $store.';
  }

  @override
  String get addStoreToAllItems => 'Ajoutez un magasin à chaque article acheté avant de finaliser plusieurs reçus.';

  @override
  String get signInToCreateShoppingLists => 'Connectez-vous pour créer des listes de courses.';

  @override
  String get couldNotCreateList => 'Impossible de créer la liste. Veuillez réessayer.';

  @override
  String get couldNotDeleteList => 'Impossible de supprimer la liste. Veuillez réessayer.';

  @override
  String get couldNotAddItem => 'Impossible d\'ajouter l\'article. Veuillez réessayer.';

  @override
  String get signInToAddShoppingItems => 'Connectez-vous pour ajouter des articles à votre liste de courses.';

  @override
  String get itemNameRequired => 'Le nom de l\'article est requis.';

  @override
  String get couldNotUpdateItem => 'Impossible de mettre à jour l\'article. Veuillez réessayer.';

  @override
  String get couldNotUpdateQuantity => 'Impossible de mettre à jour la quantité. Veuillez réessayer.';

  @override
  String get couldNotRemoveItem => 'Impossible de supprimer l\'article. Veuillez réessayer.';

  @override
  String get couldNotUpdateShoppingList => 'Impossible de mettre à jour la liste de courses. Veuillez réessayer.';

  @override
  String get couldNotCompleteAction => 'Impossible de terminer l\'action. Veuillez réessayer.';

  @override
  String estimatedPrefix(String amount) {
    return 'Estimé : $amount';
  }

  @override
  String shoppingTripFinalized(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Courses finalisées. $count reçus créés.',
      one: 'Courses finalisées. 1 reçu créé.',
    );
    return '$_temp0';
  }

  @override
  String get productChicken => 'Poulet';

  @override
  String get productEggs => 'Œufs';

  @override
  String get weeklyGroceriesDefault => 'Courses de la semaine';

  @override
  String get basketSummary => 'Résumé du panier';

  @override
  String get estimatedBestTotal => 'Meilleur total estimé';

  @override
  String get basketPotentialSaving => 'Économie potentielle';

  @override
  String get itemsMatched => 'Articles correspondants';

  @override
  String get noPriceHistoryLabel => 'Sans historique de prix';

  @override
  String get activeListsIncludedLabel => 'Listes actives incluses';

  @override
  String get itemRecommendations => 'Recommandations d\'articles';

  @override
  String get bestKnownLabel => 'Meilleur prix connu';

  @override
  String get latestSeen => 'Dernier prix connu';

  @override
  String saveUpToTotal(String amount) {
    return 'Économisez jusqu\'à $amount au total';
  }

  @override
  String get noPriceHistoryYet => 'Pas encore d\'historique de prix';

  @override
  String get addReceiptsForItemRecommendations => 'Ajoutez des reçus avec cet article pour débloquer les recommandations';

  @override
  String get suggestedStorePlan => 'Plan de magasins suggéré';

  @override
  String estimatedStoreTotalLabel(String amount) {
    return 'Total estimé en magasin : $amount';
  }

  @override
  String storePlanItemLine(String itemName, String quantitySuffix, String unitPrice, String perUnit) {
    return '• $itemName$quantitySuffix — $unitPrice $perUnit';
  }

  @override
  String get perUnit => 'l\'unité';

  @override
  String get signInToOptimizeAllLists => 'Connectez-vous pour optimiser toutes vos listes de courses à partir de vos reçus.';

  @override
  String get signInToOptimizeBasket => 'Connectez-vous pour optimiser votre panier à partir de vos reçus et de votre liste de courses.';

  @override
  String get loadingAllActiveLists => 'Chargement de toutes les listes actives…';

  @override
  String get loadingBasketOptimizer => 'Chargement de l\'optimiseur de panier…';

  @override
  String get couldNotLoadShoppingList => 'Impossible de charger la liste de courses';

  @override
  String get couldNotLoadPriceHistory => 'Impossible de charger l\'historique des prix';

  @override
  String get noActiveItemsToOptimize => 'Aucun article actif à optimiser';

  @override
  String get noActiveItemsToOptimizeMessage => 'Ajoutez des articles à vos listes de courses pour élaborer un plan de magasins intelligent.';

  @override
  String get backToShopping => 'Retour aux courses';

  @override
  String get addItemsToListForOptimizer => 'Ajoutez des articles à votre liste de courses';

  @override
  String get addItemsToListForOptimizerMessage => 'Ajoutez des articles à votre liste de courses pour optimiser votre panier.';

  @override
  String get noPriceHistoryForOptimizerMessage => 'Ajoutez des reçus avec des lignes d\'articles pour que Savingor apprenne vos prix et recommande de meilleurs magasins.';

  @override
  String listFinalizeProgressSummary(int purchased, int total) {
    return 'Achetés : $purchased · Total d\'articles : $total';
  }

  @override
  String qtyWithCount(int count) {
    return 'Qté $count';
  }

  @override
  String get unitPrice => 'Prix unitaire';

  @override
  String lineTotalWithAmount(String amount) {
    return 'Total de la ligne : $amount';
  }

  @override
  String get lineTotalEmpty => 'Total de la ligne : —';

  @override
  String enterPriceForProduct(String product) {
    return 'Entrez un prix pour $product';
  }

  @override
  String enterValidPriceForProduct(String product) {
    return 'Entrez un prix valide pour $product';
  }

  @override
  String get trackMonthlyGrocerySpending => 'Suivez vos dépenses alimentaires mensuelles par rapport à votre budget.';

  @override
  String get monthlyGroceryBudget => 'Budget alimentaire mensuel';

  @override
  String get spentThisMonth => 'Dépensé ce mois-ci';

  @override
  String get overBudget => 'Budget dépassé';

  @override
  String get remaining => 'Restant';

  @override
  String get updateMonthlyBudget => 'Mettre à jour le budget mensuel';

  @override
  String get setMonthlyBudgetDescription => 'Définissez la limite de dépenses alimentaires que vous souhaitez suivre chaque mois.';

  @override
  String get monthlyBudgetAmount => 'Montant du budget mensuel';

  @override
  String get saveBudget => 'Enregistrer le budget';

  @override
  String get budgetSaved => 'Budget enregistré';

  @override
  String get enterBudgetAmount => 'Entrez un montant de budget';

  @override
  String get enterAmountGreaterThanZero => 'Entrez un montant supérieur à zéro';

  @override
  String get overview => 'Aperçu';

  @override
  String get estimatedSaved => 'Économies estimées';

  @override
  String get potentialMissed => 'Potentiellement manqué';

  @override
  String get savingsValue => 'Valeur des économies';

  @override
  String get proPayback => 'Rentabilité Pro';

  @override
  String get proPaidForItself => 'Pro s\'est rentabilisé';

  @override
  String amountOfPriceCovered(String amount, String price) {
    return '$amount sur $price couverts';
  }

  @override
  String needAmountMoreForPro(String amount) {
    return 'Encore $amount pour couvrir Pro';
  }

  @override
  String amountAfterSubscription(String amount) {
    return '+$amount après l\'abonnement';
  }

  @override
  String monthlyReturnMultiplier(String multiplier) {
    return 'Retour : ${multiplier}x ce mois-ci';
  }

  @override
  String get spendingByStore => 'Dépenses par magasin';

  @override
  String priceRecordCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count enregistrements',
      one: '1 enregistrement',
    );
    return '$_temp0';
  }

  @override
  String get recentActivity => 'Activité récente';

  @override
  String get activityTypeReceipt => 'Reçu';

  @override
  String get activityTypeManual => 'Manuel';

  @override
  String get activityManualExpense => 'Dépense manuelle';

  @override
  String activityReceiptWithItems(String source, int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count articles',
      one: '1 article',
    );
    return '$source · $_temp0';
  }

  @override
  String get recommendedActions => 'Actions recommandées';

  @override
  String get exploreDetails => 'Explorer les détails';

  @override
  String productsInPriceHistoryCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count produits dans votre historique de prix',
      one: '1 produit dans votre historique de prix',
    );
    return '$_temp0';
  }

  @override
  String get priceInsightsEmptySubtitle => 'Mémoire complète des prix à partir des lignes de vos reçus';

  @override
  String get savingsOpportunities => 'Opportunités d\'économie';

  @override
  String actionableOpportunitiesCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count opportunités à examiner',
      one: '1 opportunité à examiner',
    );
    return '$_temp0';
  }

  @override
  String get savingsOpportunitiesEmptySubtitle => 'Produits pour lesquels vous avez payé plus que le meilleur prix connu';

  @override
  String get loadingAnalytics => 'Chargement de l\'analytique…';

  @override
  String get couldNotLoadAnalytics => 'Impossible de charger l\'analytique';

  @override
  String get signInForAnalytics => 'Consultez l\'analytique des dépenses avec votre compte Savingor.';

  @override
  String get noSpendingDataYet => 'Pas encore de données de dépenses';

  @override
  String get noSpendingDataMessage => 'Ajoutez un reçu ou une dépense pour voir les totaux, la répartition par magasin et les tendances.';

  @override
  String get addMoreReceiptsForSavingsValue => 'Ajoutez plus de reçus pour calculer la valeur de vos économies.';

  @override
  String storeHasSeveralBestPrices(String store) {
    return '$store a plusieurs de vos meilleurs prix connus';
  }

  @override
  String trackedProductsLowestAtStore(int count, String store) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count produits suivis ont actuellement leur prix le plus bas connu chez $store',
      one: '1 produit suivi a actuellement son prix le plus bas connu chez $store',
    );
    return '$_temp0';
  }

  @override
  String get useStoreWhenMatchesRoute => 'Utilisez ce magasin lorsqu\'il correspond à votre itinéraire de courses';

  @override
  String recentlyPaidLatestBestKnown(String latestPrice, String latestStore, String bestPrice, String bestStore) {
    return 'Vous avez récemment payé $latestPrice chez $latestStore. Votre meilleur prix connu est $bestPrice chez $bestStore.';
  }

  @override
  String basedOnPriceRecords(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Basé sur $count enregistrements de prix',
      one: 'Basé sur 1 enregistrement de prix',
    );
    return '$_temp0';
  }

  @override
  String watchProductPrices(String product) {
    return 'Surveillez de près les prix de $product';
  }

  @override
  String knownPricesRangeFromTo(String low, String high) {
    return 'Vos prix connus vont de $low à $high.';
  }

  @override
  String priceDifferenceAmount(String amount) {
    return 'Différence de prix : $amount';
  }

  @override
  String get productPriceInsights => 'Analyse des prix des produits';

  @override
  String productsInPriceHistoryFromReceipts(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count produits dans votre historique de prix issu des reçus',
      one: '1 produit dans votre historique de prix issu des reçus',
    );
    return '$_temp0';
  }

  @override
  String get latestPriceLabel => 'Dernier';

  @override
  String get bestKnownPriceLabel => 'Meilleur connu';

  @override
  String get highestPriceLabel => 'Le plus élevé';

  @override
  String get averagePriceLabel => 'Moyenne';

  @override
  String priceAtStore(String price, String store) {
    return '$price chez $store';
  }

  @override
  String get signInForPriceMemory => 'Connectez-vous pour consulter votre mémoire des prix des produits.';

  @override
  String get loadingPriceMemory => 'Chargement de la mémoire des prix…';

  @override
  String get couldNotLoadPriceMemory => 'Impossible de charger la mémoire des prix';

  @override
  String get noPriceMemoryYet => 'Pas encore de mémoire des prix';

  @override
  String get noPriceMemoryMessage => 'Ajoutez des reçus avec des lignes d\'articles pour commencer à construire votre mémoire des prix.';

  @override
  String savingsOpportunitiesPaidMoreCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count opportunités d\'économie où vous avez payé plus que le meilleur prix connu',
      one: '1 opportunité d\'économie où vous avez payé plus que le meilleur prix connu',
    );
    return '$_temp0';
  }

  @override
  String saveUpToPerItem(String amount) {
    return 'Économisez jusqu\'à $amount par unité';
  }

  @override
  String youPaidAtStore(String amount, String store) {
    return 'Vous avez payé $amount chez $store';
  }

  @override
  String get recommendationWatchProductBeforeBuying => 'Recommandation : surveillez ce produit avant de racheter.';

  @override
  String recommendationBuyAtStoreNextTime(String store) {
    return 'Recommandation : achetez la prochaine fois chez $store.';
  }

  @override
  String get signInForSavingsOpportunities => 'Connectez-vous pour voir les opportunités d\'économie à partir de vos reçus.';

  @override
  String get loadingSavingsOpportunities => 'Chargement des opportunités d\'économie…';

  @override
  String get couldNotLoadSavingsOpportunities => 'Impossible de charger les opportunités d\'économie';

  @override
  String get noSavingsOpportunitiesYet => 'Pas encore d\'opportunités d\'économie';

  @override
  String get noSavingsOpportunitiesMessage => 'Ajoutez plus de reçus avec des lignes d\'articles pour que Savingor puisse comparer les prix entre magasins.';

  @override
  String get recordsLabel => 'Enregistrements';

  @override
  String get buyingAdvice => 'Conseil d\'achat';

  @override
  String get bestKnownPriceAdviceLabel => 'Meilleur prix connu';

  @override
  String get latestPaidAdviceLabel => 'Dernier prix payé';

  @override
  String buyItemAtStoreWhenFitsRoute(String store) {
    return 'Achetez cet article chez $store lorsque cela correspond à votre itinéraire.';
  }

  @override
  String get buyItemAtBestPriceWhenFitsRoute => 'Achetez cet article là où vous avez déjà trouvé le meilleur prix, lorsque cela correspond à votre itinéraire.';

  @override
  String get addToShoppingList => 'Ajouter à la liste de courses';

  @override
  String get priceHistory => 'Historique des prix';

  @override
  String get productHistoryTitle => 'Historique du produit';

  @override
  String get productNotFound => 'Produit introuvable.';

  @override
  String get buyingAdviceInsufficientHistory => 'Ajoutez plus de reçus avec cet article pour obtenir des conseils d\'achat plus pertinents.';

  @override
  String get buyingAdvicePaidBestPrice => 'Vous avez payé votre meilleur prix connu.';

  @override
  String get buyingAdviceNoBetterPriceYet => 'Pas encore de meilleur prix connu.';

  @override
  String quantityLabelWithCount(String count) {
    return 'Quantité : $count';
  }

  @override
  String get addedToShoppingList => 'Ajouté à la liste de courses';

  @override
  String get alreadyInShoppingList => 'Déjà dans la liste de courses';

  @override
  String get quantityUpdatedSnack => 'Quantité mise à jour';

  @override
  String get nearbyStores => 'Magasins à proximité';

  @override
  String get nearbyStoresSubtitle => 'Trouvez des épiceries près de chez vous et comparez les opportunités d\'économie.';

  @override
  String get storesNearby => 'Magasins à proximité';

  @override
  String mapStoresFoundCount(int count) {
    return '$count trouvé(s)';
  }

  @override
  String get mapStoresFootnotePlaces => 'Les magasins sont basés sur votre emplacement sélectionné et le rayon de recherche.';

  @override
  String get mapStoresFootnoteFallback => 'Affichage des épiceries dans la zone sélectionnée.';

  @override
  String get mapStoresFootnoteDefault => 'Explorez les épiceries près de l\'emplacement choisi.';

  @override
  String mapNoStoresWithinRadius(int distance) {
    return 'Aucun magasin dans un rayon de $distance km. Essayez un rayon plus large.';
  }

  @override
  String get mapPleaseEnterCityOrArea => 'Veuillez saisir une ville ou une zone.';

  @override
  String get mapCouldNotOpenDirections => 'Impossible d\'ouvrir l\'itinéraire.';

  @override
  String get mapYourLocation => 'Votre emplacement';

  @override
  String get mapFindGroceryStoresNearYou => 'Trouvez des épiceries près de chez vous';

  @override
  String get mapActive => 'Actif';

  @override
  String get mapSearchRadius => 'Rayon de recherche';

  @override
  String get mapCheckingLocation => 'Vérification de l\'emplacement...';

  @override
  String get mapLocationSelected => 'Emplacement sélectionné';

  @override
  String get mapLocationDetected => 'Emplacement détecté';

  @override
  String get mapReadyToSearchNearby => 'Prêt à rechercher des épiceries à proximité.';

  @override
  String get mapCouldNotAccessLocation => 'Impossible d\'accéder à votre emplacement.';

  @override
  String get mapEnableLocationPrompt => 'Activez la localisation pour trouver des épiceries près de chez vous.';

  @override
  String get mapUseMyLocation => 'Utiliser ma position';

  @override
  String get mapEnterCityManually => 'Saisir la ville manuellement';

  @override
  String get mapLocationServicesDisabled => 'Les services de localisation sont désactivés.';

  @override
  String get mapLocationPermissionDenied => 'Autorisation de localisation refusée.';

  @override
  String get mapCouldNotDetectLocation => 'Impossible de détecter votre emplacement. Veuillez réessayer.';

  @override
  String get mapSetYourLocation => 'Définir votre emplacement';

  @override
  String get mapSetLocationGpsOrCity => 'Utilisez le GPS ou choisissez une ville pour voir les magasins à proximité.';

  @override
  String get mapCurrentLocation => 'Emplacement actuel';

  @override
  String get directions => 'Itinéraire';

  @override
  String get mapStoreCategoryGrocery => 'Épicerie';

  @override
  String get mapStoreCategorySupermarket => 'Supermarché';

  @override
  String get mapStoreCategoryWholesale => 'Grossiste';

  @override
  String get mapNearbyStoreStatus => 'Magasin à proximité';

  @override
  String get mapListedOnGooglePlaces => 'Répertorié sur Google Places';

  @override
  String mapRadiusKm(int distance) {
    return '$distance km';
  }

  @override
  String get mapSetLocation => 'Définir l\'emplacement';

  @override
  String get mapCityOrArea => 'Ville ou zone';

  @override
  String get mapCityOrAreaExample => 'Exemple : Calgary, Cochrane, Edmonton';

  @override
  String mapMarkerSnippetWithDetail(String distance, String detail) {
    return '$distance · $detail';
  }

  @override
  String get aiSavingsAssistant => 'Assistant IA d\'économies';

  @override
  String get aiProPreviewDescription => 'Obtenez des recommandations personnalisées d\'économies sur les courses basées sur vos reçus, listes de courses, historique de dépenses et magasins locaux.';

  @override
  String get aiProBenefitPersonalizedRecommendations => 'Recommandations d\'économies personnalisées';

  @override
  String get aiProBenefitStoreComparisons => 'Comparaisons plus intelligentes des magasins et produits';

  @override
  String get aiProBenefitSpendingInsights => 'Analyses de dépenses basées sur l\'historique des reçus';

  @override
  String get aiProBenefitBudgetAnswers => 'Réponses IA sur votre budget courses';

  @override
  String get unlockWithSavingorPro => 'Débloquer avec Savingor Pro';

  @override
  String get viewProBenefits => 'Voir les avantages Pro';

  @override
  String get aiSignInPrompt => 'Connectez-vous pour poser des questions à l\'assistant IA sur vos reçus et listes de courses.';

  @override
  String get aiLoadingYourData => 'Chargement de vos données…';

  @override
  String get aiCouldNotLoadData => 'Impossible de charger vos données';

  @override
  String get aiEmptyTitle => 'Ajoutez des données pour obtenir des conseils IA';

  @override
  String get aiEmptyMessage => 'Scannez un reçu, ajoutez une dépense ou créez une liste de courses. L\'assistant analyse vos données enregistrées — pas les prix en magasin en temps réel.';

  @override
  String get aiHeroTitle => 'Votre coach IA d\'économies';

  @override
  String get aiHeroSubtitleLive => 'Posez des questions sur vos dépenses, reçus et listes de courses.';

  @override
  String get aiHeroSubtitlePreview => 'Aperçu des conseils à partir de vos données enregistrées — connectez une clé API pour des réponses en direct.';

  @override
  String get aiConfigReadyMessage => 'L\'assistant IA est prêt. Connectez une clé API pour activer les réponses en direct.';

  @override
  String get aiDataSnapshot => 'Aperçu de vos données';

  @override
  String aiReceiptCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count reçus',
      one: '1 reçu',
    );
    return '$_temp0';
  }

  @override
  String aiExpenseCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count dépenses',
      one: '1 dépense',
    );
    return '$_temp0';
  }

  @override
  String aiTotalSpendingLabel(String amount) {
    return '$amount au total';
  }

  @override
  String aiListCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count listes',
      one: '1 liste',
    );
    return '$_temp0';
  }

  @override
  String aiListEstimateLabel(String amount) {
    return '$amount est. listes';
  }

  @override
  String get aiSuggestedQuestions => 'Questions suggérées';

  @override
  String get aiSuggestSaveMoreThisWeek => 'Comment économiser davantage cette semaine ?';

  @override
  String get aiSuggestTopStore => 'Dans quel magasin je dépense le plus ?';

  @override
  String get aiSuggestAnalyzeSpending => 'Analyse mes dépenses alimentaires.';

  @override
  String get aiSuggestShoppingListPriority => 'Que devrais-je acheter en premier sur ma liste ?';

  @override
  String get aiAnalyzingYourData => 'Analyse de vos données…';

  @override
  String get aiCouldNotGetAnswer => 'Impossible d\'obtenir une réponse. Veuillez réessayer.';

  @override
  String get aiInsightsDisclaimer => 'Les conseils sont basés sur vos reçus, dépenses et listes de courses enregistrés dans Savingor — pas sur les prix ou offres en magasin en temps réel.';

  @override
  String get aiInputHintLive => 'Posez une question sur vos dépenses ou votre liste…';

  @override
  String get aiInputHintPreview => 'Saisissez une question — connectez une clé API pour des réponses en direct';

  @override
  String get aiRequestFailed => 'La requête IA a échoué. Veuillez réessayer.';

  @override
  String get aiEmptyResponse => 'L\'IA a renvoyé une réponse vide.';

  @override
  String get aiSend => 'Envoyer';

  @override
  String get editProfile => 'Modifier le profil';

  @override
  String get personalInformation => 'Informations personnelles';

  @override
  String get editProfileFullNameHint => 'Votre nom complet';

  @override
  String get emailChangesNotAvailable => 'La modification de l\'e-mail n\'est pas disponible dans cette version.';

  @override
  String get password => 'Mot de passe';

  @override
  String get passwordNeverShown => 'Pour des raisons de sécurité, votre mot de passe actuel n\'est jamais affiché.';

  @override
  String get changePassword => 'Changer le mot de passe';

  @override
  String get sendPasswordResetEmailInstead => 'Envoyer un e-mail de réinitialisation';

  @override
  String get sendingResetEmail => 'Envoi de l\'e-mail...';

  @override
  String get changesSaved => 'Modifications enregistrées';

  @override
  String get couldNotSaveChanges => 'Impossible d\'enregistrer les modifications';

  @override
  String get pleaseEnterFullName => 'Veuillez saisir votre nom complet';

  @override
  String get signInToEditProfile => 'Connectez-vous pour modifier votre profil.';

  @override
  String get passwordResetEmailSent => 'E-mail de réinitialisation envoyé';

  @override
  String get changePasswordIntro => 'Pour changer votre mot de passe dans l\'application, saisissez d\'abord votre mot de passe actuel.';

  @override
  String get currentPassword => 'Mot de passe actuel';

  @override
  String get newPassword => 'Nouveau mot de passe';

  @override
  String get confirmNewPassword => 'Confirmer le nouveau mot de passe';

  @override
  String get enterCurrentPasswordHint => 'Saisissez le mot de passe actuel';

  @override
  String get atLeast6CharactersHint => 'Au moins 6 caractères';

  @override
  String get repeatNewPasswordHint => 'Répétez le nouveau mot de passe';

  @override
  String get currentPasswordRequired => 'Le mot de passe actuel est requis';

  @override
  String get newPasswordRequired => 'Le nouveau mot de passe est requis';

  @override
  String get newPasswordMinLength => 'Le nouveau mot de passe doit contenir au moins 6 caractères';

  @override
  String get confirmNewPasswordRequired => 'Veuillez confirmer votre nouveau mot de passe';

  @override
  String get passwordsDoNotMatch => 'Les mots de passe ne correspondent pas';

  @override
  String get updatePassword => 'Mettre à jour le mot de passe';

  @override
  String get forgotCurrentPassword => 'Mot de passe actuel oublié ?';

  @override
  String get passwordResetSecureLink => 'Nous enverrons un lien sécurisé à votre e-mail pour créer un nouveau mot de passe.';

  @override
  String get passwordResetByEmailHint => 'Si vous ne vous en souvenez pas, utilisez la réinitialisation par e-mail.';

  @override
  String get sendResetEmail => 'Envoyer l\'e-mail de réinitialisation';

  @override
  String get sending => 'Envoi...';

  @override
  String get passwordUpdated => 'Mot de passe mis à jour';

  @override
  String get showPassword => 'Afficher le mot de passe';

  @override
  String get hidePassword => 'Masquer le mot de passe';

  @override
  String get signInToChangePassword => 'Connectez-vous pour changer votre mot de passe.';

  @override
  String get currentPasswordIncorrect => 'Le mot de passe actuel est incorrect';

  @override
  String get passwordTooWeak => 'Le mot de passe est trop faible';

  @override
  String get recentLoginRequired => 'Pour des raisons de sécurité, reconnectez-vous et réessayez.';

  @override
  String get tooManyAttempts => 'Trop de tentatives. Veuillez réessayer plus tard.';

  @override
  String get couldNotUpdatePassword => 'Impossible de mettre à jour le mot de passe';

  @override
  String get noEmailLinked => 'Aucun e-mail n\'est lié à ce compte.';

  @override
  String get couldNotSendResetEmail => 'Impossible d\'envoyer l\'e-mail';

  @override
  String get plans => 'Forfaits';

  @override
  String get freeTodayProWhenReady => 'Free aujourd\'hui · Pro quand vous serez prêt';

  @override
  String get saveSmarterWithAi => 'Économisez plus intelligemment avec l\'IA';

  @override
  String get unlockProFeaturesDescription => 'Débloquez les conseils IA, l\'analyse des reçus, les alertes intelligentes et des rapports de dépenses détaillés.';

  @override
  String get bestValue => 'Meilleure offre';

  @override
  String get basicDealsBrowsing => 'Consultation des offres de base';

  @override
  String get manualExpenseTracking => 'Suivi manuel des dépenses';

  @override
  String get aiPoweredToolsDescription => 'Outils IA pour des économies alimentaires plus intelligentes.';

  @override
  String get receiptAnalytics => 'Analyse des reçus';

  @override
  String get smartSavingsInsights => 'Conseils d\'économie intelligents';

  @override
  String get spendingReports => 'Rapports de dépenses';

  @override
  String get smartAlerts => 'Alertes intelligentes';

  @override
  String get startProSubscription => 'Commencer l\'abonnement Pro';

  @override
  String get restorePurchases => 'Restaurer les achats';

  @override
  String get restoring => 'Restauration...';

  @override
  String get proSubscriptionActivated => 'Abonnement activé';

  @override
  String get proDemoFallbackActivated => 'Démo Pro activée — aucun paiement réel traité.';

  @override
  String get couldNotCompletePurchase => 'Impossible de finaliser l\'achat. Veuillez réessayer.';

  @override
  String get couldNotActivateProDemo => 'Impossible d\'activer la démo Pro. Veuillez réessayer.';

  @override
  String get purchaseRestored => 'Achat restauré';

  @override
  String get noPurchasesFound => 'Aucun achat trouvé';

  @override
  String get couldNotRestorePurchases => 'Impossible de restaurer les achats';

  @override
  String get subscriptionSetup => 'Configuration de l\'abonnement';

  @override
  String get subscriptionSetupPrepared => 'Savingor Pro est prêt pour une intégration réelle des achats in-app.';

  @override
  String get subscriptionSetupNotConfigured => 'Les clés du fournisseur de paiement ou les produits du store ne sont pas configurés dans cette version.';

  @override
  String get activateProDemoForTesting => 'Activer la démo Pro pour les tests';

  @override
  String get demoFallbackActive => 'Démo active — aucun paiement réel traité.';

  @override
  String get subscriptionPlanLabel => 'Forfait';

  @override
  String pricePerMonth(String price) {
    return '$price / mois';
  }

  @override
  String get active => 'Actif';

  @override
  String get activeDemo => 'Démo active';

  @override
  String get cancelled => 'Annulé';

  @override
  String get unknown => 'Inconnu';

  @override
  String get demoMode => 'Mode démo';

  @override
  String get providerNone => 'Aucun';

  @override
  String get revenueCatLabel => 'RevenueCat';

  @override
  String get subscriptionManagedByStore => 'Votre abonnement est géré par l\'App Store ou Google Play. Vous pouvez l\'annuler ou le modifier dans les paramètres d\'abonnement du store.';

  @override
  String get manageInAppStoreGooglePlay => 'Gérer dans l\'App Store / Google Play';

  @override
  String get cancelProDemo => 'Annuler la démo Pro';

  @override
  String get noActiveSubscription => 'Aucun abonnement actif';

  @override
  String get proDemoCancelled => 'Démo Pro annulée. Vous êtes de retour sur le forfait Free.';

  @override
  String get couldNotCancelProDemo => 'Impossible d\'annuler la démo Pro. Veuillez réessayer.';

  @override
  String get couldNotOpenSubscriptionManagement => 'Impossible d\'ouvrir la page de gestion de l\'abonnement.';

  @override
  String get managementNotAvailable => 'Gestion indisponible';

  @override
  String get managementUrlUnavailableMessage => 'L\'URL de gestion de l\'abonnement n\'est pas disponible dans cette version de test. Pour les achats RevenueCat Test Store, réinitialisez le client test dans le tableau de bord RevenueCat ou utilisez un autre compte test.';

  @override
  String get paymentProviderNotConfiguredSnack => 'Le fournisseur de paiement n\'est pas configuré dans cette version locale.';

  @override
  String get purchaseCancelled => 'Achat annulé';

  @override
  String get purchaseFailed => 'Échec de l\'achat';

  @override
  String get productUnavailable => 'Produit indisponible';

  @override
  String get purchaseNotActiveYet => 'Achat terminé mais Pro n\'est pas encore actif. Essayez Restaurer les achats.';

  @override
  String get networkErrorTryAgain => 'Vérifiez votre connexion et réessayez';

  @override
  String get signInToManageSubscription => 'Connectez-vous pour gérer votre abonnement.';

  @override
  String get couldNotUpdateSubscription => 'Impossible de mettre à jour l\'abonnement. Veuillez réessayer.';

  @override
  String get debugSubscriptionTestingTitle => 'Test d\'abonnement développeur';

  @override
  String get debugSubscriptionTestingDescription => 'Prévisualisez temporairement Savingor en tant qu\'utilisateur Free ou Pro. Cela ne modifie pas l\'abonnement réel.';

  @override
  String get debugSubscriptionUseReal => 'Utiliser l\'abonnement réel';

  @override
  String get debugSubscriptionTestAsFree => 'Tester en Free';

  @override
  String get debugSubscriptionTestAsPro => 'Tester en Pro';

  @override
  String get debugSubscriptionOverrideFree => 'Remplacement de plan développeur : Free';

  @override
  String get debugSubscriptionOverridePro => 'Remplacement de plan développeur : Pro';

  @override
  String get proFeatureBasketOptimizerDescription => 'Comparez votre panier entre les magasins et trouvez des façons plus intelligentes de dépenser moins.';

  @override
  String get proFeatureBasketBenefitOptimizeAcrossStores => 'Optimisez le panier d\'achats dans les magasins à proximité';

  @override
  String get proFeatureBasketBenefitCompareTotals => 'Comparez les totaux estimés du panier';

  @override
  String get proFeatureBasketBenefitEconomicalCombination => 'Trouvez une combinaison de magasins plus économique';

  @override
  String get proFeatureBasketBenefitReduceSpending => 'Réduisez les dépenses alimentaires inutiles';

  @override
  String get proFeatureSavingsAnalyticsDescription => 'Comprenez vos tendances d\'économies, vos habitudes de dépenses et vos recommandations personnalisées.';

  @override
  String get proFeatureAnalyticsBenefitDeeperTrends => 'Consultez des tendances d\'économies plus détaillées';

  @override
  String get proFeatureAnalyticsBenefitComparePeriods => 'Comparez les périodes de dépenses';

  @override
  String get proFeatureAnalyticsBenefitTrackSavings => 'Suivez les économies estimées';

  @override
  String get proFeatureAnalyticsBenefitAdvancedRecommendations => 'Recevez des recommandations avancées';

  @override
  String get proFeatureProductPriceInsightsDescription => 'Suivez l\'historique des prix des produits et obtenez de meilleurs conseils d\'achat à partir de vos reçus.';

  @override
  String get proFeaturePriceInsightsBenefitHistory => 'Consultez l\'historique des prix du produit';

  @override
  String get proFeaturePriceInsightsBenefitCompareStores => 'Comparez les prix récents des magasins';

  @override
  String get proFeaturePriceInsightsBenefitBuyingAdvice => 'Recevez des conseils d\'achat';

  @override
  String get proFeaturePriceInsightsBenefitPurchaseTiming => 'Identifiez le bon moment pour acheter';

  @override
  String get proFeatureSavingsOpportunitiesDescription => 'Découvrez des actions d\'économie personnalisées basées sur vos achats et vos reçus.';

  @override
  String get proFeatureOpportunitiesBenefitPersonalized => 'Trouvez des façons personnalisées d\'économiser';

  @override
  String get proFeatureOpportunitiesBenefitPrioritize => 'Priorisez les actions à forte valeur';

  @override
  String get proFeatureOpportunitiesBenefitReceiptHistory => 'Utilisez les insights des reçus et de l\'historique d\'achats';

  @override
  String get proFeatureOpportunitiesBenefitBetterChoices => 'Découvrez de meilleurs magasins et produits';

  @override
  String get savingorPro => 'Savingor Pro';

  @override
  String get plansHeroTitle => 'Choisissez votre forfait Savingor';

  @override
  String get plansHeroSubtitle => 'Commencez gratuitement avec les outils essentiels. Passez à Pro quand vous êtes prêt pour une intelligence d\'économies avancée.';

  @override
  String get planFreeSubtitle => 'Outils essentiels pour suivre vos dépenses alimentaires et commencer à économiser.';

  @override
  String get planProSubtitle => 'Automatisation avancée et intelligence d\'économies personnalisée.';

  @override
  String get planFreePrice => 'CAD \$0';

  @override
  String get planProPricePerMonth => 'CAD \$14.99 / mois';

  @override
  String get upgradeToSavingorPro => 'Passer à Savingor Pro';

  @override
  String get planComparisonTitle => 'Comparer les forfaits';

  @override
  String get planIncludedFeaturesTitle => 'Fonctionnalités incluses';

  @override
  String get planProActiveFeaturesTitle => 'Fonctionnalités Pro actives';

  @override
  String get planProComingSoonFeaturesTitle => 'Fonctionnalités Pro à venir';

  @override
  String get planColumnFree => 'Free';

  @override
  String get planColumnPro => 'Pro';

  @override
  String get planAvailabilityIncluded => 'Inclus';

  @override
  String get planAvailabilityLocked => 'Verrouillé';

  @override
  String get planAvailabilityUnlimited => 'Illimité';

  @override
  String get planAvailabilityThreeScansPerMonth => '3 par mois';

  @override
  String get planFeatureGroceryDashboard => 'Tableau de bord des dépenses alimentaires';

  @override
  String get planFeatureNearbyStoreMap => 'Carte des magasins à proximité';

  @override
  String get planFeatureShoppingLists => 'Listes de courses';

  @override
  String get planFeatureManualExpenseTracking => 'Suivi manuel des dépenses';

  @override
  String get planFeatureThreeReceiptScansPerMonth => '3 scans de reçus par mois';

  @override
  String get planFeatureBasicReceiptExpenseHistory => 'Historique de base des reçus et dépenses';

  @override
  String get planFeatureBasicSavingsOpportunities => 'Opportunités d\'économies de base';

  @override
  String get planFeatureBasicProductPriceInsights => 'Insights de prix produits de base';

  @override
  String get planFeatureAppSettings => 'Langue, thème, région et devise';

  @override
  String get planFeatureUnlimitedReceiptScanning => 'Scan de reçus illimité';

  @override
  String get planFeatureBasketOptimizer => 'Optimiseur de panier';

  @override
  String get planFeatureAdvancedSavingsAnalytics => 'Analytique d\'économies avancée';

  @override
  String get planFeatureSmartPriceDropAlerts => 'Alertes intelligentes de baisse de prix';

  @override
  String get planFeatureAdvancedSpendingReports => 'Rapports de dépenses avancés';

  @override
  String get planCompareReceiptScans => 'Scans de reçus';

  @override
  String get planCompareBasicSavingsOpportunities => 'Opportunités d\'économies de base';

  @override
  String get planCompareBasicProductPriceInsights => 'Insights de prix produits de base';
}
