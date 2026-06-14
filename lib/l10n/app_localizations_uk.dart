import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Ukrainian (`uk`).
class AppLocalizationsUk extends AppLocalizations {
  AppLocalizationsUk([String locale = 'uk']) : super(locale);

  @override
  String get appName => 'Savingor';

  @override
  String get appSubtitle => 'Локальні пропозиції та розумні заощадження';

  @override
  String get home => 'Головна';

  @override
  String get deals => 'Пропозиції';

  @override
  String get receipts => 'Квитанції';

  @override
  String get analytics => 'Аналітика';

  @override
  String get profile => 'Профіль';

  @override
  String get scanner => 'Сканер квитанцій';

  @override
  String get shopping => 'Список покупок';

  @override
  String get saved => 'Збережено';

  @override
  String get storesMap => 'Карта';

  @override
  String get aiAssistant => 'ШІ';

  @override
  String get scanReceipt => 'Сканувати чек';

  @override
  String get dealsMap => 'Карта пропозицій';

  @override
  String get receiptScanner => 'Сканер квитанцій';

  @override
  String get shoppingList => 'Список покупок';

  @override
  String get mvp => 'MVP v0.1';

  @override
  String get searchHint => 'Пошук пропозицій або магазинів...';

  @override
  String get filter => 'Фільтр';

  @override
  String get dealsMapSubtitle => 'Показує найближчі пропозиції';

  @override
  String get receiptScannerSubtitle => 'Сканувати квитанцію';

  @override
  String get shoppingListSubtitle => 'Розумний список';

  @override
  String dealsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count пропозиції',
      many: '$count пропозицій',
      few: '$count пропозиції',
      one: '$count пропозиція',
    );
    return '$_temp0';
  }

  @override
  String get noDealsFound => 'Пропозицій не знайдено';

  @override
  String get resetFilters => 'Скинути фільтри';

  @override
  String get filtersTitle => 'Фільтри';

  @override
  String get stores => 'Магазини';

  @override
  String get maxPrice => 'Макс. ціна';

  @override
  String get sort => 'Сортування';

  @override
  String get none => 'Без';

  @override
  String get priceLowHigh => 'Ціна: зростання';

  @override
  String get priceHighLow => 'Ціна: спадання';

  @override
  String get dealDetails => 'Деталі пропозиції';

  @override
  String get dealNotFound => 'Пропозицію не знайдено';

  @override
  String get saveDeal => 'Зберегти пропозицію';

  @override
  String get removeSaved => 'Прибрати збережене';

  @override
  String get noSavedDeals => 'Поки немає збережених пропозицій';

  @override
  String get savedHint => 'Збережені пропозиції відображатимуться тут';

  @override
  String get cancel => 'Скасувати';

  @override
  String get apply => 'Застосувати';

  @override
  String get save => 'Зберегти';

  @override
  String get back => 'Назад';

  @override
  String get close => 'Закрити';

  @override
  String get signOut => 'Вийти';

  @override
  String get loading => 'Завантаження...';

  @override
  String get tryAgain => 'Спробувати знову';

  @override
  String get comingSoon => 'Незабаром';

  @override
  String get continueButton => 'Продовжити';

  @override
  String get edit => 'Редагувати';

  @override
  String get ok => 'OK';

  @override
  String get chooseYourLanguage => 'Оберіть мову';

  @override
  String get chooseLanguageSubtitle => 'Виберіть мову, якою Savingor має працювати.';

  @override
  String get langSubtitleOnboarding => 'Це допоможе персоналізувати ваш досвід у Savingor.';

  @override
  String get applyLanguage => 'Застосувати мову';

  @override
  String welcomeBackName(String name) {
    return 'З поверненням, $name! 👋';
  }

  @override
  String get welcomeBack => 'З поверненням! 👋';

  @override
  String get readyToSaveSmarterToday => 'Готові економити розумніше сьогодні?';

  @override
  String get totalExpenses => 'Загальні витрати';

  @override
  String get trackedInSavingor => 'Відстежено в Savingor';

  @override
  String expensesTracked(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count витрати відстежено',
      many: '$count витрат відстежено',
      few: '$count витрати відстежено',
      one: '$count витрату відстежено',
    );
    return '$_temp0';
  }

  @override
  String get startSaving => 'Почати економити';

  @override
  String get startSavingHero => '✨ ПОЧАТИ ЕКОНОМИТИ';

  @override
  String get thisMonth => 'Цього місяця';

  @override
  String get spent => 'витрачено';

  @override
  String get recorded => 'записано';

  @override
  String get lists => 'списки';

  @override
  String get activeDeals => 'Активні пропозиції';

  @override
  String get estimated => 'оцінено';

  @override
  String get monthlyGoal => 'Місячна ціль';

  @override
  String get noRecentActivity => 'Немає недавньої активності';

  @override
  String get expenseAdded => 'Витрату додано';

  @override
  String get addExpenseToSeeHere => 'Додайте витрату, щоб побачити її тут';

  @override
  String get yourSavingsSnapshot => 'Ваш знімок заощаджень';

  @override
  String get thisMonthSpent => 'Витрачено цього місяця';

  @override
  String get potentialSavingsFound => 'Знайдено потенційні заощадження';

  @override
  String get productsTracked => 'Відстежувані товари';

  @override
  String get bestActionNow => 'Найкраща дія зараз';

  @override
  String get addMoreReceiptsForSavings => 'Додайте більше чеків, щоб отримати персональні поради щодо економії.';

  @override
  String get account => 'Обліковий запис';

  @override
  String get yourAccount => 'Ваш обліковий запис';

  @override
  String get planAndSubscription => 'План і підписка';

  @override
  String get appSettings => 'Налаштування застосунку';

  @override
  String get region => 'Регіон';

  @override
  String get language => 'Мова';

  @override
  String get appearance => 'Оформлення';

  @override
  String get currency => 'Валюта';

  @override
  String get notifications => 'Сповіщення';

  @override
  String get loadingProfile => 'Завантаження профілю...';

  @override
  String get noProfileFound => 'Профіль для цього облікового запису ще не знайдено.';

  @override
  String get fullName => 'Повне ім\'я';

  @override
  String get email => 'Електронна пошта';

  @override
  String get passwordAndSecurity => 'Пароль і безпека';

  @override
  String get managePassword => 'Керувати паролем';

  @override
  String get currentPlan => 'Поточний план';

  @override
  String get proPlan => 'Pro-план';

  @override
  String get freePlan => 'Безкоштовний план';

  @override
  String get pro => 'Pro';

  @override
  String get free => 'Безкоштовно';

  @override
  String get status => 'Статус';

  @override
  String get provider => 'Провайдер';

  @override
  String get price => 'Ціна';

  @override
  String get priceMonthly => '14,99 \$ / місяць';

  @override
  String get inactive => 'Неактивна';

  @override
  String get freePlanUpgradeMessage => 'Зараз у вас безкоштовний план. Перейдіть на Pro, щоб отримати ШІ-поради щодо економії, аналітику чеків, розумні сповіщення та звіти про витрати.';

  @override
  String get manageSubscription => 'Керувати підпискою';

  @override
  String get viewPlans => 'Переглянути плани';

  @override
  String get manageSettings => 'Керувати налаштуваннями';

  @override
  String get signOutQuestion => 'Вийти?';

  @override
  String get signOutMessage => 'Щоб знову отримати доступ до облікового запису Savingor, потрібно увійти.';

  @override
  String get couldNotLoadProfile => 'Не вдалося завантажити профіль. Спробуйте ще раз.';

  @override
  String get personalizeSavingor => 'Персоналізуйте Savingor';

  @override
  String get personalizeSavingorSubtitle => 'Оберіть, як застосунок виглядає, спілкується та адаптується до вашого місцезнаходження.';

  @override
  String get preferences => 'Налаштування';

  @override
  String get appLanguage => 'Мова застосунку';

  @override
  String get appearanceHelper => 'Оберіть, як виглядатиме Savingor';

  @override
  String get regionHelper => 'Використовується для пошуку магазинів поруч і місцевих пропозицій';

  @override
  String get currencyHelper => 'Використовується для цін, бюджетів і звітів';

  @override
  String get smartSavingsAlerts => 'Розумні сповіщення про економію';

  @override
  String get smartSavingsAlertsDescription => 'Отримуйте сповіщення про можливості економії, прогрес бюджету та важливі рекомендації.';

  @override
  String get regionCanada => 'Канада';

  @override
  String get regionUnitedStates => 'Сполучені Штати';

  @override
  String get appearanceLight => 'Світла';

  @override
  String get appearanceDark => 'Темна';

  @override
  String get topSavingOpportunities => 'Найкращі можливості для економії';

  @override
  String get seeAll => 'Переглянути всі';

  @override
  String bestKnownAtStore(String amount, String store) {
    return 'Найкраща відома ціна: $amount у $store';
  }

  @override
  String latestPaidAtStore(String amount, String store) {
    return 'Остання сплачена ціна: $amount у $store';
  }

  @override
  String saveUpToAmount(String amount) {
    return 'Можна заощадити до $amount';
  }

  @override
  String get basedOnReceiptHistory => 'На основі історії чеків';

  @override
  String buyProductAtStoreNextTime(String product, String store) {
    return 'Наступного разу купіть $product у $store';
  }

  @override
  String potentialSavingPerItem(String amount) {
    return 'Потенційна економія: $amount за одиницю';
  }

  @override
  String get productBread => 'Хліб';

  @override
  String get productMilk => 'Молоко';

  @override
  String get delete => 'Видалити';

  @override
  String get signIn => 'Увійти';

  @override
  String get signInRequired => 'Потрібен вхід';

  @override
  String get store => 'Магазин';

  @override
  String get date => 'Дата';

  @override
  String get total => 'Разом';

  @override
  String get items => 'Товари';

  @override
  String get notes => 'Примітки';

  @override
  String get amount => 'Сума';

  @override
  String get category => 'Категорія';

  @override
  String get scanReceiptSubtitle => 'Відскануйте продуктовий чек, щоб відстежувати витрати та заощадження.';

  @override
  String get addManually => 'Додати вручну';

  @override
  String recentReceipts(int count) {
    return 'Останні чеки ($count)';
  }

  @override
  String get noReceiptsYet => 'Чеків поки немає. Відскануйте або додайте чек, щоб почати відстеження.';

  @override
  String get deleteReceiptQuestion => 'Видалити чек?';

  @override
  String get deleteReceipt => 'Видалити чек';

  @override
  String deleteReceiptConfirmMessage(String store, String total) {
    return '$store ($total) буде остаточно видалено.';
  }

  @override
  String get loadingReceipts => 'Завантаження чеків...';

  @override
  String get couldNotLoadReceipts => 'Не вдалося завантажити чеки';

  @override
  String get signInToSyncReceipts => 'Зберігайте та синхронізуйте чеки зі своїм обліковим записом Savingor.';

  @override
  String get chooseReceiptSource => 'Оберіть, як додати чек';

  @override
  String freeScansUsedThisMonth(int used, int limit) {
    return '$used з $limit безкоштовних сканувань використано цього місяця';
  }

  @override
  String freeScansRemaining(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count безкоштовних сканувань залишилось',
      many: '$count безкоштовних сканувань залишилось',
      few: '$count безкоштовні сканування залишилось',
      one: '$count безкоштовне сканування залишилось',
    );
    return '$_temp0';
  }

  @override
  String get noFreeScansRemainingThisMonth => 'Безкоштовні сканування на цей місяць вичерпано';

  @override
  String get unlimitedScansWithPro => 'Необмежене сканування з Pro';

  @override
  String get loadingScanUsage => 'Перевірка використання сканувань…';

  @override
  String get monthlyScanLimitTitle => 'Досягнуто місячного ліміту сканувань';

  @override
  String get monthlyScanLimitDescription => 'Ви використали всі три безкоштовні сканування чеків цього місяця. Оновіться до Savingor Pro для необмеженого сканування.';

  @override
  String get unlockUnlimitedScansWithSavingorPro => 'Розблокуйте необмежене сканування з Savingor Pro';

  @override
  String get monthlyScanLimitSaveBlocked => 'Ви досягли безкоштовного ліміту сканувань на цей місяць. Оновіться до Pro, щоб зберігати більше відсканованих чеків.';

  @override
  String get takePhoto => 'Зробити фото';

  @override
  String get takePhotoSubtitle => 'Використайте камеру, щоб відсканувати чек';

  @override
  String get chooseFromGallery => 'Обрати з галереї';

  @override
  String get chooseFromGallerySubtitle => 'Оберіть наявне фото чека';

  @override
  String get scanningReceipt => 'Сканування чека...';

  @override
  String get processingReceiptImage => 'Обробка зображення...';

  @override
  String get readingReceiptText => 'Читання тексту чека...';

  @override
  String get couldNotScanReceipt => 'Не вдалося відсканувати цей чек. Спробуйте інше фото.';

  @override
  String get receiptCouldNotBeParsed => 'Не вдалося розпізнати ключові дані чека. Ви можете переглянути та додати їх вручну.';

  @override
  String get receiptSavedSuccessfully => 'Чек збережено';

  @override
  String get ocrResultPreview => 'Попередній перегляд OCR';

  @override
  String get noTextDetected => 'Текст не виявлено. Спробуйте чіткіше фото чека.';

  @override
  String get useThisReceipt => 'Використати цей чек';

  @override
  String get noneDetected => 'Нічого не виявлено';

  @override
  String get rawOcrText => 'Необроблений текст OCR';

  @override
  String get itemsColon => 'Товари:';

  @override
  String get addReceipt => 'Додати чек';

  @override
  String get editReceipt => 'Редагувати чек';

  @override
  String get saveReceipt => 'Зберегти чек';

  @override
  String get updateReceipt => 'Оновити чек';

  @override
  String get storeName => 'Назва магазину';

  @override
  String get storeAddressOptional => 'Адреса магазину (необов\'язково)';

  @override
  String get purchaseDate => 'Дата покупки';

  @override
  String get categorySummary => 'Категорія';

  @override
  String get grocery => 'Продукти';

  @override
  String get subtotalOptional => 'Проміжний підсумок (необов\'язково)';

  @override
  String get taxOptional => 'Податок (необов\'язково)';

  @override
  String get receiptTotal => 'Сума чека';

  @override
  String get autoCalculatedFromItems => 'Автоматично розраховується з товарів, якщо ви не зміните це поле.';

  @override
  String get notesOptional => 'Примітки (необов\'язково)';

  @override
  String get addItem => 'Додати товар';

  @override
  String get addLineItemsHint => 'Додайте позиції, щоб створити повний запис чека для подальшого відстеження цін.';

  @override
  String get enterStoreName => 'Введіть назву магазину';

  @override
  String get selectPurchaseDate => 'Оберіть дату покупки';

  @override
  String get enterTotalAmount => 'Введіть загальну суму';

  @override
  String get enterValidAmount => 'Введіть коректну суму';

  @override
  String get enterValidTotalAmount => 'Введіть коректну загальну суму.';

  @override
  String get receiptNotFound => 'Чек не знайдено.';

  @override
  String get item => 'Товар';

  @override
  String get itemName => 'Назва товару';

  @override
  String get enterItemName => 'Введіть назву товару';

  @override
  String get qty => 'К-сть';

  @override
  String get invalidValue => 'Некоректно';

  @override
  String get removeItem => 'Видалити товар';

  @override
  String get categoryOptional => 'Категорія (необов\'язково)';

  @override
  String get receiptDetails => 'Деталі чека';

  @override
  String subtotalLabel(String amount) {
    return 'Проміжний підсумок: $amount';
  }

  @override
  String taxLabel(String amount) {
    return 'Податок: $amount';
  }

  @override
  String get noItemsSaved => 'Товари не збережено';

  @override
  String get noLineItemsSaved => 'Для цього чека ще не збережено жодної позиції.';

  @override
  String qtyWithValue(String quantity) {
    return 'К-сть $quantity';
  }

  @override
  String get couldNotDeleteReceipt => 'Не вдалося видалити чек. Спробуйте ще раз.';

  @override
  String get saveChanges => 'Зберегти зміни';

  @override
  String get receiptSourceManual => 'Вручну';

  @override
  String get receiptSourceScanned => 'Відскановано';

  @override
  String get receiptSourceGallery => 'Галерея';

  @override
  String get receiptSourceImported => 'Імпортовано';

  @override
  String get receiptSourceShoppingList => 'Список покупок';

  @override
  String get receiptSourceUnknown => 'Чек';

  @override
  String get scanNotes => 'Примітки сканування';

  @override
  String get galleryScanNotes => 'Примітки сканування з галереї';

  @override
  String get importNotes => 'Примітки імпорту';

  @override
  String get tripNotes => 'Примітки поїздки';

  @override
  String get couldNotLoadYourReceipts => 'Не вдалося завантажити ваші чеки. Спробуйте ще раз.';

  @override
  String get signInToSaveReceipts => 'Увійдіть, щоб зберігати чеки.';

  @override
  String get couldNotSaveReceipt => 'Не вдалося зберегти чек. Спробуйте ще раз.';

  @override
  String get couldNotUpdateReceipt => 'Не вдалося оновити чек. Спробуйте ще раз.';

  @override
  String get signInToUpdateReceipts => 'Увійдіть, щоб оновлювати чеки.';

  @override
  String receiptItemsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count товарів',
      many: '$count товарів',
      few: '$count товари',
      one: '1 товар',
      zero: '0 товарів',
    );
    return '$_temp0';
  }

  @override
  String get processingReceipt => 'Обробка чека';

  @override
  String get readingReceipt => 'Зчитування чека';

  @override
  String get recognizingText => 'Розпізнавання тексту';

  @override
  String get receiptScannedSuccessfully => 'Чек успішно відскановано';

  @override
  String get noTextRecognized => 'Текст не розпізнано';

  @override
  String get couldNotReadReceipt => 'Не вдалося прочитати цей чек';

  @override
  String get imageTooBlurry => 'Зображення надто розмите';

  @override
  String get tryAnotherPhoto => 'Спробуйте інше фото';

  @override
  String get cameraPermissionRequired => 'Потрібен доступ до камери';

  @override
  String get galleryPermissionRequired => 'Потрібен доступ до галереї';

  @override
  String get permissionDenied => 'Доступ заборонено';

  @override
  String get openSettings => 'Відкрити налаштування';

  @override
  String get chooseSavingAction => 'Оберіть наступну дію';

  @override
  String get addGroceryExpense => 'Додати витрату на продукти';

  @override
  String get addGroceryExpenseSubtitle => 'Запишіть покупку вручну';

  @override
  String get createShoppingListAction => 'Створити список покупок';

  @override
  String get createShoppingListSubtitle => 'Сплануйте покупки заздалегідь';

  @override
  String get optimizeShoppingBasket => 'Оптимізувати кошик';

  @override
  String get optimizeShoppingBasketSubtitle => 'Знайдіть можливості витрачати менше';

  @override
  String get finalizeShoppingTrip => 'Завершити похід до магазину';

  @override
  String get finalizeShoppingTripSubtitle => 'Завершіть поточні покупки';

  @override
  String get monthlyGoalBudget => 'Місячна ціль / Бюджет';

  @override
  String get monthlyGoalBudgetSubtitle => 'Установіть або змініть місячну ціль';

  @override
  String get savingsAnalytics => 'Аналітика заощаджень';

  @override
  String get savingsAnalyticsSubtitle => 'Перегляньте витрати та заощадження';

  @override
  String get open => 'Відкрити';

  @override
  String get expenses => 'Витрати';

  @override
  String get addExpense => 'Додати витрату';

  @override
  String get loadingExpenses => 'Завантаження витрат...';

  @override
  String get couldNotLoadExpenses => 'Не вдалося завантажити витрати';

  @override
  String get couldNotLoadYourExpenses => 'Не вдалося завантажити ваші витрати. Спробуйте ще раз.';

  @override
  String get noExpensesYet => 'Витрат поки немає';

  @override
  String get noExpensesYetMessage => 'Відстежуйте покупки продуктів і чеки, щоб розуміти свої витрати.';

  @override
  String get signInToSyncExpenses => 'Зберігайте та синхронізуйте витрати зі своїм обліковим записом Savingor.';

  @override
  String get deleteExpenseQuestion => 'Видалити витрату?';

  @override
  String deleteExpenseConfirmMessage(String store, String amount) {
    return '«$store» ($amount) буде остаточно видалено.';
  }

  @override
  String get saveExpense => 'Зберегти витрату';

  @override
  String get totalAmount => 'Загальна сума';

  @override
  String get signInToSaveExpenses => 'Увійдіть, щоб зберігати витрати.';

  @override
  String get couldNotSaveExpense => 'Не вдалося зберегти витрату. Спробуйте ще раз.';

  @override
  String get couldNotDeleteExpense => 'Не вдалося видалити витрату. Спробуйте ще раз.';

  @override
  String get expenseSaved => 'Витрату збережено.';

  @override
  String get uncategorized => 'Без категорії';

  @override
  String get recentExpenses => 'Останні витрати';

  @override
  String get noExpensesAddedYet => 'Витрат ще не додано.';

  @override
  String get pleaseEnterStoreName => 'Будь ласка, введіть назву магазину.';

  @override
  String get pleaseEnterItemName => 'Будь ласка, введіть назву товару.';

  @override
  String get pleaseEnterPrice => 'Будь ласка, введіть ціну.';

  @override
  String get pleaseEnterValidPrice => 'Будь ласка, введіть коректну ціну.';

  @override
  String expenseCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count витрат',
      many: '$count витрат',
      few: '$count витрати',
      one: '1 витрата',
      zero: '0 витрат',
    );
    return '$_temp0';
  }

  @override
  String get newShoppingList => 'Новий список покупок';

  @override
  String get newList => 'Новий список';

  @override
  String get createList => 'Створити список';

  @override
  String get loadingShoppingLists => 'Завантаження списків покупок...';

  @override
  String get couldNotLoadLists => 'Не вдалося завантажити списки';

  @override
  String get couldNotLoadYourShoppingLists => 'Не вдалося завантажити ваші списки покупок. Спробуйте ще раз.';

  @override
  String get noShoppingListsYet => 'Списків покупок поки немає';

  @override
  String get noShoppingListsYetMessage => 'Створіть перший список, щоб планувати покупки та оптимізувати кошик.';

  @override
  String get signInToSyncShoppingLists => 'Створюйте та синхронізуйте списки покупок зі своїм обліковим записом Savingor.';

  @override
  String get deleteListQuestion => 'Видалити список?';

  @override
  String deleteListConfirmMessage(String title) {
    return '«$title» буде остаточно видалено.';
  }

  @override
  String get deleteList => 'Видалити список';

  @override
  String get optimizeAllLists => 'Оптимізувати всі списки';

  @override
  String get optimizeAllListsSubtitle => 'Знайдіть найкращі відомі магазини для ваших активних списків покупок';

  @override
  String get optimizeThisBasket => 'Оптимізувати цей кошик';

  @override
  String get optimizeThisBasketSubtitle => 'Знайдіть найкращі відомі магазини для цього списку';

  @override
  String get listNotFound => 'Список не знайдено';

  @override
  String get listNotFoundMessage => 'Цей список покупок, можливо, було видалено.';

  @override
  String get backToLists => 'Назад до списків';

  @override
  String get noShoppingItemsYet => 'Товарів поки немає';

  @override
  String get noShoppingItemsYetMessage => 'Додайте товари до цього списку, щоб відстежувати потреби.';

  @override
  String get shoppingListEmptyMessage => 'Створюйте та керуйте розумними списками покупок тут.';

  @override
  String get purchased => 'Придбано';

  @override
  String get clearPurchased => 'Очистити придбані';

  @override
  String get estimatedTotalLabel => 'Орієнтовна сума';

  @override
  String estimatedShort(String amount) {
    return 'Орієнт. $amount';
  }

  @override
  String activeCountLabel(int count) {
    return '$count активних';
  }

  @override
  String purchasedSummary(int count) {
    return '$count придбано';
  }

  @override
  String itemsTotalSummary(int count) {
    return '$count товарів загалом';
  }

  @override
  String get allItemsPurchased => 'Усі товари придбано';

  @override
  String get saveItem => 'Зберегти товар';

  @override
  String get listTitle => 'Назва списку';

  @override
  String get enterListTitle => 'Введіть назву списку';

  @override
  String get listName => 'Назва списку';

  @override
  String get enterListName => 'Введіть назву списку';

  @override
  String get newShoppingListHint => 'Дайте назву списку. Товари можна додати після створення.';

  @override
  String get itemsOptional => 'Товари (необов\'язково)';

  @override
  String get addAnotherItem => 'Додати ще один товар';

  @override
  String get storeOptional => 'Магазин (необов\'язково)';

  @override
  String get priceOptional => 'Ціна (необов\'язково)';

  @override
  String get loadingListItems => 'Завантаження товарів...';

  @override
  String get loadingShoppingList => 'Завантаження списку покупок...';

  @override
  String get couldNotLoadItems => 'Не вдалося завантажити товари';

  @override
  String get couldNotLoadListItems => 'Не вдалося завантажити товари списку. Спробуйте ще раз.';

  @override
  String get createAnotherReceiptQuestion => 'Створити ще один чек?';

  @override
  String get createAnotherReceiptMessage => 'У цього списку вже може бути чек. Створити ще один чек із придбаних товарів?';

  @override
  String get createReceipt => 'Створити чек';

  @override
  String get signInToFinalizeTrip => 'Увійдіть, щоб завершити похід до магазину.';

  @override
  String get noListsReadyToFinalize => 'Немає списків для завершення';

  @override
  String get noListsReadyToFinalizeMessage => 'Позначте товари як придбані у списку покупок, потім поверніться сюди, щоб створити чек.';

  @override
  String get openShoppingLists => 'Відкрити списки покупок';

  @override
  String get selectListToFinalize => 'Оберіть список для завершення';

  @override
  String get selectListToFinalizeSubtitle => 'Оберіть список покупок із придбаними товарами.';

  @override
  String get finalizeShoppingTripCardSubtitle => 'Створіть чек із придбаних товарів і оновіть історію цін';

  @override
  String get done => 'Готово';

  @override
  String get optional => 'Необов\'язково';

  @override
  String get somethingWentWrong => 'Щось пішло не так';

  @override
  String get saving => 'Збереження...';

  @override
  String get loadingPurchasedItems => 'Завантаження придбаних товарів...';

  @override
  String get preparingPurchasedItems => 'Підготовка придбаних товарів...';

  @override
  String get noPurchasedItemsYet => 'Придбаних товарів поки немає';

  @override
  String get noPurchasedItemsYetMessage => 'Позначте товари як придбані перед створенням чека.';

  @override
  String get backToList => 'Назад до списку';

  @override
  String get enterStoreNameForTrip => 'Введіть назву магазину для цього походу';

  @override
  String get enterStoreNameForTripSnack => 'Введіть назву магазину для цього походу.';

  @override
  String creatingReceiptsPerStore(int count) {
    return 'Створення $count чеків — по одному на магазин.';
  }

  @override
  String get missingStoreOnItems => 'Деяким придбаним товарам не вказано магазин. Додайте магазин для кожного товару перед завершенням.';

  @override
  String get missingStore => 'Магазин не вказано';

  @override
  String receiptSubtotalLabel(String amount) {
    return 'Проміжна сума чека: $amount';
  }

  @override
  String get purchasedItems => 'Придбані товари';

  @override
  String get enterReceiptTotal => 'Введіть суму чека';

  @override
  String get enterValidReceiptTotal => 'Введіть коректну суму чека';

  @override
  String subtotalFromItemPrices(String amount) {
    return 'Проміжний підсумок з цін товарів: $amount';
  }

  @override
  String grandTotalAcrossReceipts(String amount) {
    return 'Загальна сума всіх чеків: $amount';
  }

  @override
  String get saveReceipts => 'Зберегти чеки';

  @override
  String addValidPricesForStore(String store) {
    return 'Додайте коректні ціни для придбаних товарів у $store.';
  }

  @override
  String get addStoreToAllItems => 'Додайте магазин для кожного придбаного товару перед створенням кількох чеків.';

  @override
  String get signInToCreateShoppingLists => 'Увійдіть, щоб створювати списки покупок.';

  @override
  String get couldNotCreateList => 'Не вдалося створити список. Спробуйте ще раз.';

  @override
  String get couldNotDeleteList => 'Не вдалося видалити список. Спробуйте ще раз.';

  @override
  String get couldNotAddItem => 'Не вдалося додати товар. Спробуйте ще раз.';

  @override
  String get signInToAddShoppingItems => 'Увійдіть, щоб додавати товари до списку покупок.';

  @override
  String get itemNameRequired => 'Потрібна назва товару.';

  @override
  String get couldNotUpdateItem => 'Не вдалося оновити товар. Спробуйте ще раз.';

  @override
  String get couldNotUpdateQuantity => 'Не вдалося оновити кількість. Спробуйте ще раз.';

  @override
  String get couldNotRemoveItem => 'Не вдалося видалити товар. Спробуйте ще раз.';

  @override
  String get couldNotUpdateShoppingList => 'Не вдалося оновити список покупок. Спробуйте ще раз.';

  @override
  String get couldNotCompleteAction => 'Не вдалося виконати дію. Спробуйте ще раз.';

  @override
  String estimatedPrefix(String amount) {
    return 'Орієнтовно: $amount';
  }

  @override
  String shoppingTripFinalized(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Похід до магазину завершено. Створено $count чеків.',
      many: 'Похід до магазину завершено. Створено $count чеків.',
      few: 'Похід до магазину завершено. Створено $count чеки.',
      one: 'Похід до магазину завершено. Створено $count чек.',
    );
    return '$_temp0';
  }

  @override
  String get productChicken => 'Курятина';

  @override
  String get productEggs => 'Яйця';

  @override
  String get weeklyGroceriesDefault => 'Щотижневі покупки';

  @override
  String get basketSummary => 'Підсумок кошика';

  @override
  String get estimatedBestTotal => 'Найкраща орієнтовна сума';

  @override
  String get basketPotentialSaving => 'Потенційна економія';

  @override
  String get itemsMatched => 'Зіставлено товарів';

  @override
  String get noPriceHistoryLabel => 'Без історії цін';

  @override
  String get activeListsIncludedLabel => 'Активних списків враховано';

  @override
  String get itemRecommendations => 'Рекомендації щодо товарів';

  @override
  String get bestKnownLabel => 'Найкраща відома';

  @override
  String get latestSeen => 'Остання відома ціна';

  @override
  String saveUpToTotal(String amount) {
    return 'Можна заощадити до $amount загалом';
  }

  @override
  String get noPriceHistoryYet => 'Історії цін поки немає';

  @override
  String get addReceiptsForItemRecommendations => 'Додайте чеки з цим товаром, щоб отримати рекомендації';

  @override
  String get suggestedStorePlan => 'Рекомендований план магазинів';

  @override
  String estimatedStoreTotalLabel(String amount) {
    return 'Орієнтовна сума в магазині: $amount';
  }

  @override
  String storePlanItemLine(String itemName, String quantitySuffix, String unitPrice, String perUnit) {
    return '• $itemName$quantitySuffix — $unitPrice $perUnit';
  }

  @override
  String get perUnit => 'за одиницю';

  @override
  String get signInToOptimizeAllLists => 'Увійдіть, щоб оптимізувати всі ваші списки покупок на основі чеків.';

  @override
  String get signInToOptimizeBasket => 'Увійдіть, щоб оптимізувати кошик на основі чеків і списку покупок.';

  @override
  String get loadingAllActiveLists => 'Завантаження всіх активних списків…';

  @override
  String get loadingBasketOptimizer => 'Завантаження оптимізатора кошика…';

  @override
  String get couldNotLoadShoppingList => 'Не вдалося завантажити список покупок';

  @override
  String get couldNotLoadPriceHistory => 'Не вдалося завантажити історію цін';

  @override
  String get noActiveItemsToOptimize => 'Немає активних товарів для оптимізації';

  @override
  String get noActiveItemsToOptimizeMessage => 'Додайте товари до списків покупок, щоб скласти розумний план магазинів.';

  @override
  String get backToShopping => 'Назад до покупок';

  @override
  String get addItemsToListForOptimizer => 'Додайте товари до списку покупок';

  @override
  String get addItemsToListForOptimizerMessage => 'Додайте товари до списку покупок, щоб оптимізувати кошик.';

  @override
  String get noPriceHistoryForOptimizerMessage => 'Додайте чеки з позиціями, щоб Savingor міг дізнатися ваші ціни та рекомендувати кращі магазини.';

  @override
  String listFinalizeProgressSummary(int purchased, int total) {
    return 'Придбано: $purchased · Усього товарів: $total';
  }

  @override
  String qtyWithCount(int count) {
    return 'К-сть $count';
  }

  @override
  String get unitPrice => 'Ціна за одиницю';

  @override
  String lineTotalWithAmount(String amount) {
    return 'Сума за товар: $amount';
  }

  @override
  String get lineTotalEmpty => 'Сума за товар: —';

  @override
  String enterPriceForProduct(String product) {
    return 'Введіть ціну для $product';
  }

  @override
  String enterValidPriceForProduct(String product) {
    return 'Введіть коректну ціну для $product';
  }

  @override
  String get trackMonthlyGrocerySpending => 'Контролюйте місячні витрати на продукти відповідно до бюджету';

  @override
  String get monthlyGroceryBudget => 'Місячний бюджет на продукти';

  @override
  String get spentThisMonth => 'Витрачено цього місяця';

  @override
  String get overBudget => 'Перевищення бюджету';

  @override
  String get remaining => 'Залишок';

  @override
  String get updateMonthlyBudget => 'Оновити місячний бюджет';

  @override
  String get setMonthlyBudgetDescription => 'Установіть місячний ліміт витрат на продукти';

  @override
  String get monthlyBudgetAmount => 'Сума місячного бюджету';

  @override
  String get saveBudget => 'Зберегти бюджет';

  @override
  String get budgetSaved => 'Бюджет збережено';

  @override
  String get enterBudgetAmount => 'Введіть суму бюджету';

  @override
  String get enterAmountGreaterThanZero => 'Введіть суму більше нуля';

  @override
  String get overview => 'Огляд';

  @override
  String get estimatedSaved => 'Орієнтовно заощаджено';

  @override
  String get potentialMissed => 'Потенційно втрачено';

  @override
  String get savingsValue => 'Цінність заощаджень';

  @override
  String get proPayback => 'Окупність Pro';

  @override
  String get proPaidForItself => 'Pro окупився';

  @override
  String amountOfPriceCovered(String amount, String price) {
    return 'Покрито $amount із $price';
  }

  @override
  String needAmountMoreForPro(String amount) {
    return 'Ще $amount, щоб окупити Pro';
  }

  @override
  String amountAfterSubscription(String amount) {
    return '+$amount після підписки';
  }

  @override
  String monthlyReturnMultiplier(String multiplier) {
    return 'Повернення: ${multiplier}x цього місяця';
  }

  @override
  String get spendingByStore => 'Витрати за магазинами';

  @override
  String priceRecordCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count записів',
      many: '$count записів',
      few: '$count записи',
      one: '$count запис',
    );
    return '$_temp0';
  }

  @override
  String get recentActivity => 'Остання активність';

  @override
  String get activityTypeReceipt => 'Чек';

  @override
  String get activityTypeManual => 'Вручну';

  @override
  String get activityManualExpense => 'Ручна витрата';

  @override
  String activityReceiptWithItems(String source, int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count товарів',
      many: '$count товарів',
      few: '$count товари',
      one: '1 товар',
    );
    return '$source · $_temp0';
  }

  @override
  String get recommendedActions => 'Рекомендовані дії';

  @override
  String get exploreDetails => 'Переглянути деталі';

  @override
  String productsInPriceHistoryCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count товарів у вашій історії цін',
      many: '$count товарів у вашій історії цін',
      few: '$count товари у вашій історії цін',
      one: '1 товар у вашій історії цін',
    );
    return '$_temp0';
  }

  @override
  String get priceInsightsEmptySubtitle => 'Повна пам\'ять цін з позицій ваших чеків';

  @override
  String get savingsOpportunities => 'Можливості для економії';

  @override
  String actionableOpportunitiesCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count можливостей для перегляду',
      many: '$count можливостей для перегляду',
      few: '$count можливості для перегляду',
      one: '1 можливість для перегляду',
    );
    return '$_temp0';
  }

  @override
  String get savingsOpportunitiesEmptySubtitle => 'Товари, за які ви заплатили більше найкращої відомої ціни';

  @override
  String get loadingAnalytics => 'Завантаження аналітики…';

  @override
  String get couldNotLoadAnalytics => 'Не вдалося завантажити аналітику';

  @override
  String get signInForAnalytics => 'Переглядайте аналітику витрат зі своїм обліковим записом Savingor.';

  @override
  String get noSpendingDataYet => 'Даних про витрати поки немає';

  @override
  String get noSpendingDataMessage => 'Додайте чек або витрату, щоб побачити підсумки витрат, розбивку за магазинами та тенденції.';

  @override
  String get addMoreReceiptsForSavingsValue => 'Додайте більше чеків, щоб розрахувати цінність ваших заощаджень.';

  @override
  String storeHasSeveralBestPrices(String store) {
    return 'У магазині $store є кілька ваших найкращих відомих цін';
  }

  @override
  String trackedProductsLowestAtStore(int count, String store) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count відстежуваних товарів мають найнижчу відому ціну в $store',
      many: '$count відстежуваних товарів мають найнижчу відому ціну в $store',
      few: '$count відстежувані товари мають найнижчу відому ціну в $store',
      one: '1 відстежуваний товар має найнижчу відому ціну в $store',
    );
    return '$_temp0';
  }

  @override
  String get useStoreWhenMatchesRoute => 'Обирайте цей магазин, коли він відповідає вашому маршруту';

  @override
  String recentlyPaidLatestBestKnown(String latestPrice, String latestStore, String bestPrice, String bestStore) {
    return 'Нещодавно ви заплатили $latestPrice у $latestStore. Найкраща відома ціна — $bestPrice у $bestStore';
  }

  @override
  String basedOnPriceRecords(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'На основі $count записів ціни',
      many: 'На основі $count записів ціни',
      few: 'На основі $count записів ціни',
      one: 'На основі 1 запису ціни',
    );
    return '$_temp0';
  }

  @override
  String watchProductPrices(String product) {
    return 'Слідкуйте за цінами на $product';
  }

  @override
  String knownPricesRangeFromTo(String low, String high) {
    return 'Ваші відомі ціни коливаються від $low до $high.';
  }

  @override
  String priceDifferenceAmount(String amount) {
    return 'Різниця в ціні: $amount';
  }

  @override
  String get productPriceInsights => 'Аналіз цін на товари';

  @override
  String productsInPriceHistoryFromReceipts(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count товарів у вашій історії цін з чеків',
      many: '$count товарів у вашій історії цін з чеків',
      few: '$count товари у вашій історії цін з чеків',
      one: '1 товар у вашій історії цін з чеків',
    );
    return '$_temp0';
  }

  @override
  String get latestPriceLabel => 'Остання ціна';

  @override
  String get bestKnownPriceLabel => 'Найкраща відома ціна';

  @override
  String get highestPriceLabel => 'Найвища ціна';

  @override
  String get averagePriceLabel => 'Середня ціна';

  @override
  String priceAtStore(String price, String store) {
    return '$price у $store';
  }

  @override
  String get signInForPriceMemory => 'Увійдіть, щоб переглянути пам\'ять цін на товари.';

  @override
  String get loadingPriceMemory => 'Завантаження пам\'яті цін…';

  @override
  String get couldNotLoadPriceMemory => 'Не вдалося завантажити пам\'ять цін';

  @override
  String get noPriceMemoryYet => 'Пам\'яті цін поки немає';

  @override
  String get noPriceMemoryMessage => 'Додайте чеки з позиціями, щоб почати формувати пам\'ять цін.';

  @override
  String savingsOpportunitiesPaidMoreCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count можливостей для економії, де ви заплатили більше за найкращу відому ціну',
      many: '$count можливостей для економії, де ви заплатили більше за найкращу відому ціну',
      few: '$count можливості для економії, де ви заплатили більше за найкращу відому ціну',
      one: '$count можливість для економії, де ви заплатили більше за найкращу відому ціну',
    );
    return '$_temp0';
  }

  @override
  String saveUpToPerItem(String amount) {
    return 'Можна заощадити до $amount за одиницю';
  }

  @override
  String youPaidAtStore(String amount, String store) {
    return 'Ви заплатили $amount у магазині $store';
  }

  @override
  String get recommendationWatchProductBeforeBuying => 'Рекомендація: перевірте ціну цього товару перед наступною покупкою.';

  @override
  String recommendationBuyAtStoreNextTime(String store) {
    return 'Рекомендація: наступного разу придбайте цей товар у магазині $store.';
  }

  @override
  String get signInForSavingsOpportunities => 'Увійдіть, щоб переглянути можливості для економії з ваших чеків.';

  @override
  String get loadingSavingsOpportunities => 'Завантаження можливостей для економії…';

  @override
  String get couldNotLoadSavingsOpportunities => 'Не вдалося завантажити можливості для економії';

  @override
  String get noSavingsOpportunitiesYet => 'Можливостей для економії поки немає';

  @override
  String get noSavingsOpportunitiesMessage => 'Додайте більше чеків з позиціями, щоб Savingor міг порівнювати ціни в різних магазинах.';

  @override
  String get recordsLabel => 'Записи';

  @override
  String get buyingAdvice => 'Порада щодо покупки';

  @override
  String get bestKnownPriceAdviceLabel => 'Найкраща відома ціна';

  @override
  String get latestPaidAdviceLabel => 'Остання сплачена ціна';

  @override
  String buyItemAtStoreWhenFitsRoute(String store) {
    return 'Купуйте цей товар у магазині $store, коли це відповідає вашому маршруту.';
  }

  @override
  String get buyItemAtBestPriceWhenFitsRoute => 'Купуйте цей товар там, де раніше знайшли найкращу ціну, коли це відповідає вашому маршруту.';

  @override
  String get addToShoppingList => 'Додати до списку покупок';

  @override
  String get priceHistory => 'Історія цін';

  @override
  String get productHistoryTitle => 'Історія товару';

  @override
  String get productNotFound => 'Товар не знайдено.';

  @override
  String get buyingAdviceInsufficientHistory => 'Додайте більше чеків з цим товаром, щоб отримати розумніші поради щодо покупок.';

  @override
  String get buyingAdvicePaidBestPrice => 'Ви заплатили свою найкращу відому ціну.';

  @override
  String get buyingAdviceNoBetterPriceYet => 'Кращої відомої ціни поки немає.';

  @override
  String quantityLabelWithCount(String count) {
    return 'Кількість: $count';
  }

  @override
  String get addedToShoppingList => 'Додано до списку покупок';

  @override
  String get alreadyInShoppingList => 'Уже у списку покупок';

  @override
  String get quantityUpdatedSnack => 'Кількість оновлено';

  @override
  String get nearbyStores => 'Магазини поруч';

  @override
  String get nearbyStoresSubtitle => 'Знайдіть продуктові магазини поруч і порівняйте можливості для економії.';

  @override
  String get storesNearby => 'Магазини поблизу';

  @override
  String mapStoresFoundCount(int count) {
    return 'Знайдено: $count';
  }

  @override
  String get mapStoresFootnotePlaces => 'Магазини відображаються на основі обраного місця та радіусу пошуку.';

  @override
  String get mapStoresFootnoteFallback => 'Показано продуктові магазини в обраному регіоні.';

  @override
  String get mapStoresFootnoteDefault => 'Перегляньте продуктові магазини поруч із обраним місцем.';

  @override
  String mapNoStoresWithinRadius(int distance) {
    return 'Немає магазинів у радіусі $distance км. Спробуйте збільшити радіус.';
  }

  @override
  String get mapPleaseEnterCityOrArea => 'Введіть місто або район.';

  @override
  String get mapCouldNotOpenDirections => 'Не вдалося відкрити маршрут.';

  @override
  String get mapYourLocation => 'Ваше місцезнаходження';

  @override
  String get mapFindGroceryStoresNearYou => 'Знайдіть продуктові магазини поруч';

  @override
  String get mapActive => 'Активно';

  @override
  String get mapSearchRadius => 'Радіус пошуку';

  @override
  String get mapCheckingLocation => 'Перевірка місцезнаходження...';

  @override
  String get mapLocationSelected => 'Місце обрано';

  @override
  String get mapLocationDetected => 'Місце визначено';

  @override
  String get mapReadyToSearchNearby => 'Готово до пошуку продуктових магазинів поруч.';

  @override
  String get mapCouldNotAccessLocation => 'Не вдалося отримати доступ до вашого місцезнаходження.';

  @override
  String get mapEnableLocationPrompt => 'Увімкніть геолокацію, щоб знайти продуктові магазини поруч.';

  @override
  String get mapUseMyLocation => 'Використати моє місцезнаходження';

  @override
  String get mapEnterCityManually => 'Ввести місто вручну';

  @override
  String get mapLocationServicesDisabled => 'Служби геолокації вимкнено.';

  @override
  String get mapLocationPermissionDenied => 'Доступ до геолокації заборонено.';

  @override
  String get mapCouldNotDetectLocation => 'Не вдалося визначити ваше місцезнаходження. Спробуйте ще раз.';

  @override
  String get mapSetYourLocation => 'Вкажіть своє місцезнаходження';

  @override
  String get mapSetLocationGpsOrCity => 'Використайте GPS або оберіть місто, щоб переглянути магазини поруч.';

  @override
  String get mapCurrentLocation => 'Поточне місцезнаходження';

  @override
  String get directions => 'Маршрут';

  @override
  String get mapStoreCategoryGrocery => 'Продуктовий';

  @override
  String get mapStoreCategorySupermarket => 'Супермаркет';

  @override
  String get mapStoreCategoryWholesale => 'Оптовий';

  @override
  String get mapNearbyStoreStatus => 'Магазин поруч';

  @override
  String get mapListedOnGooglePlaces => 'З Google Places';

  @override
  String mapRadiusKm(int distance) {
    return '$distance km';
  }

  @override
  String get mapSetLocation => 'Вказати місцезнаходження';

  @override
  String get mapCityOrArea => 'Місто або район';

  @override
  String get mapCityOrAreaExample => 'Приклад: Calgary, Cochrane, Edmonton';

  @override
  String mapMarkerSnippetWithDetail(String distance, String detail) {
    return '$distance · $detail';
  }

  @override
  String get aiSavingsAssistant => 'AI-помічник з економії';

  @override
  String get aiProPreviewDescription => 'Отримуйте персональні рекомендації щодо економії на продуктах на основі ваших чеків, списків покупок, історії витрат і локальних магазинів.';

  @override
  String get aiProBenefitPersonalizedRecommendations => 'Персональні рекомендації щодо економії';

  @override
  String get aiProBenefitStoreComparisons => 'Розумніше порівняння магазинів і товарів';

  @override
  String get aiProBenefitSpendingInsights => 'Аналітика витрат на основі історії чеків';

  @override
  String get aiProBenefitBudgetAnswers => 'Відповіді AI про ваш бюджет на продукти';

  @override
  String get unlockWithSavingorPro => 'Розблокувати з Savingor Pro';

  @override
  String get viewProBenefits => 'Переглянути переваги Pro';

  @override
  String get aiSignInPrompt => 'Увійдіть, щоб ставити запитання AI-помічнику про ваші чеки та списки покупок.';

  @override
  String get aiLoadingYourData => 'Завантаження ваших даних…';

  @override
  String get aiCouldNotLoadData => 'Не вдалося завантажити ваші дані';

  @override
  String get aiEmptyTitle => 'Додайте дані для AI-підказок';

  @override
  String get aiEmptyMessage => 'Відскануйте чек, додайте витрату або створіть список покупок. Помічник аналізує збережені дані — не актуальні ціни в магазинах.';

  @override
  String get aiHeroTitle => 'Ваш AI-тренер з економії';

  @override
  String get aiHeroSubtitleLive => 'Запитуйте про витрати, чеки та списки покупок.';

  @override
  String get aiHeroSubtitlePreview => 'Переглядайте підказки на основі збережених даних — підключіть API-ключ для живих відповідей.';

  @override
  String get aiConfigReadyMessage => 'AI-помічник готовий. Підключіть API-ключ, щоб увімкнути живі відповіді.';

  @override
  String get aiDataSnapshot => 'Знімок ваших даних';

  @override
  String aiReceiptCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count чеків',
      many: '$count чеків',
      few: '$count чеки',
      one: '$count чек',
    );
    return '$_temp0';
  }

  @override
  String aiExpenseCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count витрат',
      many: '$count витрат',
      few: '$count витрати',
      one: '$count витрата',
    );
    return '$_temp0';
  }

  @override
  String aiTotalSpendingLabel(String amount) {
    return '$amount загалом';
  }

  @override
  String aiListCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count списків',
      many: '$count списків',
      few: '$count списки',
      one: '$count список',
    );
    return '$_temp0';
  }

  @override
  String aiListEstimateLabel(String amount) {
    return '$amount оцінка списків';
  }

  @override
  String get aiSuggestedQuestions => 'Запропоновані запитання';

  @override
  String get aiSuggestSaveMoreThisWeek => 'Як мені більше заощадити цього тижня?';

  @override
  String get aiSuggestTopStore => 'У якому магазині я витрачаю найбільше?';

  @override
  String get aiSuggestAnalyzeSpending => 'Проаналізуй мої витрати на продукти.';

  @override
  String get aiSuggestShoppingListPriority => 'Що мені купити спочатку зі списку покупок?';

  @override
  String get aiAnalyzingYourData => 'Аналіз ваших даних…';

  @override
  String get aiCouldNotGetAnswer => 'Не вдалося отримати відповідь. Спробуйте ще раз.';

  @override
  String get aiInsightsDisclaimer => 'Підказки базуються на збережених чеках, витратах і списках покупок у Savingor — не на актуальних цінах чи акціях у магазинах.';

  @override
  String get aiInputHintLive => 'Запитайте про витрати або список покупок…';

  @override
  String get aiInputHintPreview => 'Введіть запитання — підключіть API-ключ для живих відповідей';

  @override
  String get aiRequestFailed => 'Запит до AI не вдався. Спробуйте ще раз.';

  @override
  String get aiEmptyResponse => 'AI повернув порожню відповідь.';

  @override
  String get aiSend => 'Надіслати';

  @override
  String get editProfile => 'Редагувати профіль';

  @override
  String get personalInformation => 'Особиста інформація';

  @override
  String get editProfileFullNameHint => 'Ваше повне ім\'я';

  @override
  String get emailChangesNotAvailable => 'Зміна електронної пошти поки недоступна.';

  @override
  String get password => 'Пароль';

  @override
  String get passwordNeverShown => 'З міркувань безпеки поточний пароль не відображається.';

  @override
  String get changePassword => 'Змінити пароль';

  @override
  String get sendPasswordResetEmailInstead => 'Надіслати лист для скидання пароля';

  @override
  String get sendingResetEmail => 'Надсилання листа...';

  @override
  String get changesSaved => 'Зміни збережено';

  @override
  String get couldNotSaveChanges => 'Не вдалося зберегти зміни';

  @override
  String get pleaseEnterFullName => 'Введіть повне ім\'я';

  @override
  String get signInToEditProfile => 'Увійдіть, щоб редагувати профіль.';

  @override
  String get passwordResetEmailSent => 'Лист для скидання пароля надіслано';

  @override
  String get changePasswordIntro => 'Щоб змінити пароль у застосунку, спочатку введіть поточний пароль.';

  @override
  String get currentPassword => 'Поточний пароль';

  @override
  String get newPassword => 'Новий пароль';

  @override
  String get confirmNewPassword => 'Підтвердьте новий пароль';

  @override
  String get enterCurrentPasswordHint => 'Введіть поточний пароль';

  @override
  String get atLeast6CharactersHint => 'Щонайменше 6 символів';

  @override
  String get repeatNewPasswordHint => 'Повторіть новий пароль';

  @override
  String get currentPasswordRequired => 'Поточний пароль обов\'язковий';

  @override
  String get newPasswordRequired => 'Новий пароль обов\'язковий';

  @override
  String get newPasswordMinLength => 'Новий пароль має містити щонайменше 6 символів';

  @override
  String get confirmNewPasswordRequired => 'Підтвердьте новий пароль';

  @override
  String get passwordsDoNotMatch => 'Паролі не збігаються';

  @override
  String get updatePassword => 'Оновити пароль';

  @override
  String get forgotCurrentPassword => 'Забули поточний пароль?';

  @override
  String get passwordResetSecureLink => 'Ми надішлемо на вашу електронну пошту безпечне посилання для створення нового пароля.';

  @override
  String get passwordResetByEmailHint => 'Якщо ви його не пам\'ятаєте, скористайтеся скиданням пароля через електронну пошту.';

  @override
  String get sendResetEmail => 'Надіслати лист для скидання';

  @override
  String get sending => 'Надсилання...';

  @override
  String get passwordUpdated => 'Пароль оновлено';

  @override
  String get showPassword => 'Показати пароль';

  @override
  String get hidePassword => 'Приховати пароль';

  @override
  String get signInToChangePassword => 'Увійдіть, щоб змінити пароль.';

  @override
  String get currentPasswordIncorrect => 'Поточний пароль неправильний';

  @override
  String get passwordTooWeak => 'Пароль надто слабкий';

  @override
  String get recentLoginRequired => 'З міркувань безпеки увійдіть знову та повторіть спробу.';

  @override
  String get tooManyAttempts => 'Забагато спроб. Спробуйте пізніше.';

  @override
  String get couldNotUpdatePassword => 'Не вдалося оновити пароль';

  @override
  String get noEmailLinked => 'До цього облікового запису не прив\'язано електронну пошту.';

  @override
  String get couldNotSendResetEmail => 'Не вдалося надіслати лист';

  @override
  String get plans => 'Тарифні плани';

  @override
  String get freeTodayProWhenReady => 'Free сьогодні · Pro, коли будете готові';

  @override
  String get saveSmarterWithAi => 'Заощаджуйте розумніше з AI';

  @override
  String get unlockProFeaturesDescription => 'Отримайте AI-рекомендації, аналітику чеків, розумні сповіщення та детальні звіти про витрати.';

  @override
  String get bestValue => 'Найкраща пропозиція';

  @override
  String get basicDealsBrowsing => 'Перегляд базових пропозицій';

  @override
  String get manualExpenseTracking => 'Ручний облік витрат';

  @override
  String get aiPoweredToolsDescription => 'AI-інструменти для розумнішої економії на продуктах.';

  @override
  String get receiptAnalytics => 'Аналітика чеків';

  @override
  String get smartSavingsInsights => 'Розумні рекомендації для економії';

  @override
  String get spendingReports => 'Звіти про витрати';

  @override
  String get smartAlerts => 'Розумні сповіщення';

  @override
  String get startProSubscription => 'Оформити підписку Pro';

  @override
  String get restorePurchases => 'Відновити покупки';

  @override
  String get restoring => 'Відновлення...';

  @override
  String get proSubscriptionActivated => 'Підписку Pro активовано';

  @override
  String get proDemoFallbackActivated => 'Демоверсію Pro активовано — реальний платіж не оброблено.';

  @override
  String get couldNotCompletePurchase => 'Не вдалося виконати покупку. Спробуйте ще раз.';

  @override
  String get couldNotActivateProDemo => 'Не вдалося активувати демоверсію Pro. Спробуйте ще раз.';

  @override
  String get purchaseRestored => 'Покупку відновлено';

  @override
  String get noPurchasesFound => 'Покупок для відновлення не знайдено';

  @override
  String get couldNotRestorePurchases => 'Не вдалося відновити покупки';

  @override
  String get subscriptionSetup => 'Налаштування підписки';

  @override
  String get subscriptionSetupPrepared => 'Savingor Pro підготовлено до справжньої інтеграції покупок у застосунку.';

  @override
  String get subscriptionSetupNotConfigured => 'У цій збірці ще не налаштовані ключі платіжного провайдера або продукти магазину.';

  @override
  String get activateProDemoForTesting => 'Активувати демоверсію Pro для тестування';

  @override
  String get demoFallbackActive => 'Активна демоверсія — реальний платіж не оброблено.';

  @override
  String get subscriptionPlanLabel => 'План';

  @override
  String pricePerMonth(String price) {
    return '$price / місяць';
  }

  @override
  String get active => 'Активна';

  @override
  String get activeDemo => 'Активна демоверсія';

  @override
  String get cancelled => 'Скасовано';

  @override
  String get unknown => 'Невідомо';

  @override
  String get demoMode => 'Деморежим';

  @override
  String get providerNone => 'Немає';

  @override
  String get revenueCatLabel => 'RevenueCat';

  @override
  String get subscriptionManagedByStore => 'Підпискою керує App Store або Google Play. Скасувати або змінити підписку можна в налаштуваннях магазину.';

  @override
  String get manageInAppStoreGooglePlay => 'Керувати в App Store / Google Play';

  @override
  String get cancelProDemo => 'Скасувати демоверсію Pro';

  @override
  String get noActiveSubscription => 'Активної підписки немає';

  @override
  String get proDemoCancelled => 'Демоверсію Pro скасовано. Ви знову на плані Free.';

  @override
  String get couldNotCancelProDemo => 'Не вдалося скасувати демоверсію Pro. Спробуйте ще раз.';

  @override
  String get couldNotOpenSubscriptionManagement => 'Не вдалося відкрити сторінку керування підпискою.';

  @override
  String get managementNotAvailable => 'Керування недоступне';

  @override
  String get managementUrlUnavailableMessage => 'Посилання для керування підпискою недоступне в цій тестовій збірці. Для покупок RevenueCat Test Store скиньте тестового користувача в панелі RevenueCat або скористайтеся іншим тестовим обліковим записом.';

  @override
  String get paymentProviderNotConfiguredSnack => 'Платіжний провайдер не налаштовано в цій локальній збірці.';

  @override
  String get purchaseCancelled => 'Покупку скасовано';

  @override
  String get purchaseFailed => 'Не вдалося виконати покупку';

  @override
  String get productUnavailable => 'Продукт недоступний';

  @override
  String get purchaseNotActiveYet => 'Покупку завершено, але Pro ще не активовано. Спробуйте відновити покупки.';

  @override
  String get networkErrorTryAgain => 'Перевірте підключення до інтернету та повторіть спробу';

  @override
  String get signInToManageSubscription => 'Увійдіть, щоб керувати підпискою.';

  @override
  String get couldNotUpdateSubscription => 'Не вдалося оновити підписку. Спробуйте ще раз.';

  @override
  String get debugSubscriptionTestingTitle => 'Тестування підписки (для розробників)';

  @override
  String get debugSubscriptionTestingDescription => 'Тимчасово переглядайте Savingor як Free або Pro користувач. Це не змінює реальну підписку.';

  @override
  String get debugSubscriptionUseReal => 'Використовувати реальну підписку';

  @override
  String get debugSubscriptionTestAsFree => 'Тестувати як Free';

  @override
  String get debugSubscriptionTestAsPro => 'Тестувати як Pro';

  @override
  String get debugSubscriptionOverrideFree => 'Перевизначення плану (розробник): Free';

  @override
  String get debugSubscriptionOverridePro => 'Перевизначення плану (розробник): Pro';

  @override
  String get proFeatureBasketOptimizerDescription => 'Порівнюйте кошик покупок між магазинами та знаходьте розумніші способи витрачати менше.';

  @override
  String get proFeatureBasketBenefitOptimizeAcrossStores => 'Оптимізуйте кошик покупок у найближчих магазинах';

  @override
  String get proFeatureBasketBenefitCompareTotals => 'Порівнюйте орієнтовні суми кошика';

  @override
  String get proFeatureBasketBenefitEconomicalCombination => 'Знайдіть економнішу комбінацію магазинів';

  @override
  String get proFeatureBasketBenefitReduceSpending => 'Зменшіть зайві витрати на продукти';

  @override
  String get proFeatureSavingsAnalyticsDescription => 'Розумійте тренди заощаджень, моделі витрат і персональні рекомендації.';

  @override
  String get proFeatureAnalyticsBenefitDeeperTrends => 'Переглядайте глибші тренди заощаджень';

  @override
  String get proFeatureAnalyticsBenefitComparePeriods => 'Порівнюйте періоди витрат';

  @override
  String get proFeatureAnalyticsBenefitTrackSavings => 'Відстежуйте орієнтовні заощадження';

  @override
  String get proFeatureAnalyticsBenefitAdvancedRecommendations => 'Отримуйте розширені рекомендації';

  @override
  String get proFeatureProductPriceInsightsDescription => 'Відстежуйте історію цін на товари та отримуйте розумніші поради щодо покупок з чеків.';

  @override
  String get proFeaturePriceInsightsBenefitHistory => 'Переглядайте історію цін на товар';

  @override
  String get proFeaturePriceInsightsBenefitCompareStores => 'Порівнюйте недавні ціни в магазинах';

  @override
  String get proFeaturePriceInsightsBenefitBuyingAdvice => 'Отримуйте поради щодо покупок';

  @override
  String get proFeaturePriceInsightsBenefitPurchaseTiming => 'Визначайте вигідний час для покупки';

  @override
  String get proFeatureSavingsOpportunitiesDescription => 'Відкривайте персональні способи економії на основі історії покупок і чеків.';

  @override
  String get proFeatureOpportunitiesBenefitPersonalized => 'Знаходьте персональні способи заощадити';

  @override
  String get proFeatureOpportunitiesBenefitPrioritize => 'Пріоритезуйте дії з найбільшою цінністю';

  @override
  String get proFeatureOpportunitiesBenefitReceiptHistory => 'Використовуйте insights з чеків і історії покупок';

  @override
  String get proFeatureOpportunitiesBenefitBetterChoices => 'Відкривайте кращі магазини та товари';

  @override
  String get savingorPro => 'Savingor Pro';

  @override
  String get plansHeroTitle => 'Оберіть свій план Savingor';

  @override
  String get plansHeroSubtitle => 'Почніть безкоштовно з базових інструментів для продуктів. Перейдіть на Pro, коли будете готові до розширеної аналітики економії.';

  @override
  String get planFreeSubtitle => 'Необхідні інструменти для обліку витрат на продукти та початку економії.';

  @override
  String get planProSubtitle => 'Розширена автоматизація та персоналізована аналітика економії.';

  @override
  String get planFreePrice => 'CAD \$0';

  @override
  String get planProPricePerMonth => 'CAD \$14.99 / місяць';

  @override
  String get upgradeToSavingorPro => 'Перейти на Savingor Pro';

  @override
  String get planComparisonTitle => 'Порівняти плани';

  @override
  String get planIncludedFeaturesTitle => 'Включені функції';

  @override
  String get planProActiveFeaturesTitle => 'Активні функції Pro';

  @override
  String get planProComingSoonFeaturesTitle => 'Майбутні функції Pro';

  @override
  String get planColumnFree => 'Free';

  @override
  String get planColumnPro => 'Pro';

  @override
  String get planAvailabilityIncluded => 'Включено';

  @override
  String get planAvailabilityLocked => 'Заблоковано';

  @override
  String get planAvailabilityUnlimited => 'Безліміт';

  @override
  String get planAvailabilityThreeScansPerMonth => '3 на місяць';

  @override
  String get planFeatureGroceryDashboard => 'Панель витрат на продукти';

  @override
  String get planFeatureNearbyStoreMap => 'Карта магазинів поруч';

  @override
  String get planFeatureShoppingLists => 'Списки покупок';

  @override
  String get planFeatureManualExpenseTracking => 'Ручний облік витрат';

  @override
  String get planFeatureThreeReceiptScansPerMonth => '3 сканування чеків на місяць';

  @override
  String get planFeatureBasicReceiptExpenseHistory => 'Базова історія чеків і витрат';

  @override
  String get planFeatureBasicSavingsOpportunities => 'Базові можливості економії';

  @override
  String get planFeatureBasicProductPriceInsights => 'Базові insights цін на товари';

  @override
  String get planFeatureAppSettings => 'Мова, тема, регіон і валюта';

  @override
  String get planFeatureUnlimitedReceiptScanning => 'Безлімітне сканування чеків';

  @override
  String get planFeatureBasketOptimizer => 'Оптимізатор кошика';

  @override
  String get planFeatureAdvancedSavingsAnalytics => 'Розширена аналітика економії';

  @override
  String get planFeatureSmartPriceDropAlerts => 'Розумні сповіщення про зниження цін';

  @override
  String get planFeatureAdvancedSpendingReports => 'Розширені звіти про витрати';

  @override
  String get planCompareReceiptScans => 'Сканування чеків';

  @override
  String get planCompareBasicSavingsOpportunities => 'Базові можливості економії';

  @override
  String get planCompareBasicProductPriceInsights => 'Базові insights цін на товари';
}
