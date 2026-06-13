import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Russian (`ru`).
class AppLocalizationsRu extends AppLocalizations {
  AppLocalizationsRu([String locale = 'ru']) : super(locale);

  @override
  String get appName => 'Savingor';

  @override
  String get appSubtitle => 'Локальные предложения и умная экономия';

  @override
  String get home => 'Главная';

  @override
  String get deals => 'Предложения';

  @override
  String get receipts => 'Чеки';

  @override
  String get analytics => 'Аналитика';

  @override
  String get profile => 'Профиль';

  @override
  String get scanner => 'Сканер чеков';

  @override
  String get shopping => 'Список покупок';

  @override
  String get saved => 'Избранное';

  @override
  String get storesMap => 'Карта';

  @override
  String get aiAssistant => 'ИИ';

  @override
  String get scanReceipt => 'Сканировать чек';

  @override
  String get dealsMap => 'Карта предложений';

  @override
  String get receiptScanner => 'Сканер чеков';

  @override
  String get shoppingList => 'Список покупок';

  @override
  String get mvp => 'MVP v0.1';

  @override
  String get searchHint => 'Поиск предложений или магазинов...';

  @override
  String get filter => 'Фильтр';

  @override
  String get dealsMapSubtitle => 'Показывает ближайшие предложения';

  @override
  String get receiptScannerSubtitle => 'Сканировать чек';

  @override
  String get shoppingListSubtitle => 'Умный список';

  @override
  String dealsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count предложения',
      many: '$count предложений',
      few: '$count предложения',
      one: '$count предложение',
    );
    return '$_temp0';
  }

  @override
  String get noDealsFound => 'Предложений не найдено';

  @override
  String get resetFilters => 'Сбросить фильтры';

  @override
  String get filtersTitle => 'Фильтры';

  @override
  String get stores => 'Магазины';

  @override
  String get maxPrice => 'Макс. цена';

  @override
  String get sort => 'Сортировка';

  @override
  String get none => 'Нет';

  @override
  String get priceLowHigh => 'Цена: по возрастанию';

  @override
  String get priceHighLow => 'Цена: по убыванию';

  @override
  String get dealDetails => 'Детали предложения';

  @override
  String get dealNotFound => 'Предложение не найдено';

  @override
  String get saveDeal => 'Сохранить';

  @override
  String get removeSaved => 'Убрать из избранного';

  @override
  String get noSavedDeals => 'Пока нет сохранённых предложений';

  @override
  String get savedHint => 'Сохранённые предложения появятся здесь';

  @override
  String get cancel => 'Отмена';

  @override
  String get apply => 'Применить';

  @override
  String get save => 'Сохранить';

  @override
  String get back => 'Назад';

  @override
  String get close => 'Закрыть';

  @override
  String get signOut => 'Выйти';

  @override
  String get loading => 'Загрузка...';

  @override
  String get tryAgain => 'Повторить';

  @override
  String get comingSoon => 'Скоро';

  @override
  String get continueButton => 'Продолжить';

  @override
  String get edit => 'Изменить';

  @override
  String get ok => 'OK';

  @override
  String get chooseYourLanguage => 'Выберите язык';

  @override
  String get chooseLanguageSubtitle => 'Выберите язык, на котором Savingor будет работать.';

  @override
  String get langSubtitleOnboarding => 'Это поможет персонализировать ваш опыт в Savingor.';

  @override
  String get applyLanguage => 'Применить язык';

  @override
  String welcomeBackName(String name) {
    return 'С возвращением, $name! 👋';
  }

  @override
  String get welcomeBack => 'С возвращением! 👋';

  @override
  String get readyToSaveSmarterToday => 'Готовы экономить умнее сегодня?';

  @override
  String get totalExpenses => 'Общие расходы';

  @override
  String get trackedInSavingor => 'Отслеживается в Savingor';

  @override
  String expensesTracked(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count расхода отслеживается',
      many: '$count расходов отслеживается',
      few: '$count расхода отслеживается',
      one: '$count расход отслеживается',
    );
    return '$_temp0';
  }

  @override
  String get startSaving => 'Начать экономить';

  @override
  String get startSavingHero => '✨ НАЧАТЬ ЭКОНОМИТЬ';

  @override
  String get thisMonth => 'В этом месяце';

  @override
  String get spent => 'потрачено';

  @override
  String get recorded => 'записано';

  @override
  String get lists => 'списки';

  @override
  String get activeDeals => 'Активные предложения';

  @override
  String get estimated => 'оценено';

  @override
  String get monthlyGoal => 'Месячная цель';

  @override
  String get noRecentActivity => 'Нет недавней активности';

  @override
  String get expenseAdded => 'Расход добавлен';

  @override
  String get addExpenseToSeeHere => 'Добавьте расход, чтобы увидеть его здесь';

  @override
  String get yourSavingsSnapshot => 'Ваш обзор экономии';

  @override
  String get thisMonthSpent => 'Потрачено в этом месяце';

  @override
  String get potentialSavingsFound => 'Найдена потенциальная экономия';

  @override
  String get productsTracked => 'Отслеживаемые товары';

  @override
  String get bestActionNow => 'Лучшее действие сейчас';

  @override
  String get addMoreReceiptsForSavings => 'Добавьте больше чеков, чтобы получить персональные советы по экономии.';

  @override
  String get account => 'Аккаунт';

  @override
  String get yourAccount => 'Ваш аккаунт';

  @override
  String get planAndSubscription => 'План и подписка';

  @override
  String get appSettings => 'Настройки приложения';

  @override
  String get region => 'Регион';

  @override
  String get language => 'Язык';

  @override
  String get appearance => 'Оформление';

  @override
  String get currency => 'Валюта';

  @override
  String get notifications => 'Уведомления';

  @override
  String get loadingProfile => 'Загрузка профиля...';

  @override
  String get noProfileFound => 'Профиль для этого аккаунта пока не найден.';

  @override
  String get fullName => 'Полное имя';

  @override
  String get email => 'Электронная почта';

  @override
  String get passwordAndSecurity => 'Пароль и безопасность';

  @override
  String get managePassword => 'Управление паролем';

  @override
  String get currentPlan => 'Текущий план';

  @override
  String get proPlan => 'Pro-план';

  @override
  String get freePlan => 'Бесплатный план';

  @override
  String get pro => 'Pro';

  @override
  String get free => 'Бесплатно';

  @override
  String get status => 'Статус';

  @override
  String get provider => 'Провайдер';

  @override
  String get price => 'Цена';

  @override
  String get priceMonthly => '14,99 \$ / месяц';

  @override
  String get inactive => 'Неактивна';

  @override
  String get freePlanUpgradeMessage => 'Сейчас у вас бесплатный план. Перейдите на Pro, чтобы получить ИИ-советы по экономии, аналитику чеков, умные уведомления и отчёты о расходах.';

  @override
  String get manageSubscription => 'Управлять подпиской';

  @override
  String get viewPlans => 'Посмотреть планы';

  @override
  String get manageSettings => 'Управлять настройками';

  @override
  String get signOutQuestion => 'Выйти?';

  @override
  String get signOutMessage => 'Чтобы снова получить доступ к аккаунту Savingor, нужно войти.';

  @override
  String get couldNotLoadProfile => 'Не удалось загрузить профиль. Попробуйте снова.';

  @override
  String get personalizeSavingor => 'Персонализируйте Savingor';

  @override
  String get personalizeSavingorSubtitle => 'Выберите, как приложение выглядит, общается и адаптируется к вашему местоположению.';

  @override
  String get preferences => 'Настройки';

  @override
  String get appLanguage => 'Язык приложения';

  @override
  String get appearanceHelper => 'Выберите, как выглядит Savingor';

  @override
  String get regionHelper => 'Используется для магазинов рядом и локальных предложений';

  @override
  String get currencyHelper => 'Используется для цен, бюджетов и отчётов';

  @override
  String get smartSavingsAlerts => 'Умные уведомления об экономии';

  @override
  String get smartSavingsAlertsDescription => 'Получайте уведомления о возможностях экономии, прогрессе бюджета и важных рекомендациях.';

  @override
  String get regionCanada => 'Канада';

  @override
  String get regionUnitedStates => 'США';

  @override
  String get appearanceLight => 'Светлая';

  @override
  String get appearanceDark => 'Тёмная';

  @override
  String get topSavingOpportunities => 'Лучшие возможности для экономии';

  @override
  String get seeAll => 'Смотреть все';

  @override
  String bestKnownAtStore(String amount, String store) {
    return 'Лучшая известная цена: $amount в $store';
  }

  @override
  String latestPaidAtStore(String amount, String store) {
    return 'Последняя оплаченная цена: $amount в $store';
  }

  @override
  String saveUpToAmount(String amount) {
    return 'Можно сэкономить до $amount';
  }

  @override
  String get basedOnReceiptHistory => 'На основе истории чеков';

  @override
  String buyProductAtStoreNextTime(String product, String store) {
    return 'В следующий раз купите $product в $store';
  }

  @override
  String potentialSavingPerItem(String amount) {
    return 'Потенциальная экономия: $amount за единицу';
  }

  @override
  String get productBread => 'Хлеб';

  @override
  String get productMilk => 'Молоко';

  @override
  String get delete => 'Удалить';

  @override
  String get signIn => 'Войти';

  @override
  String get signInRequired => 'Требуется вход';

  @override
  String get store => 'Магазин';

  @override
  String get date => 'Дата';

  @override
  String get total => 'Итого';

  @override
  String get items => 'Товары';

  @override
  String get notes => 'Заметки';

  @override
  String get amount => 'Сумма';

  @override
  String get category => 'Категория';

  @override
  String get scanReceiptSubtitle => 'Отсканируйте продуктовый чек, чтобы отслеживать расходы и экономию.';

  @override
  String get addManually => 'Добавить вручную';

  @override
  String recentReceipts(int count) {
    return 'Последние чеки ($count)';
  }

  @override
  String get noReceiptsYet => 'Чеков пока нет. Отсканируйте или добавьте чек, чтобы начать отслеживание.';

  @override
  String get deleteReceiptQuestion => 'Удалить чек?';

  @override
  String get deleteReceipt => 'Удалить чек';

  @override
  String deleteReceiptConfirmMessage(String store, String total) {
    return '$store ($total) будет удалён безвозвратно.';
  }

  @override
  String get loadingReceipts => 'Загрузка чеков...';

  @override
  String get couldNotLoadReceipts => 'Не удалось загрузить чеки';

  @override
  String get signInToSyncReceipts => 'Сохраняйте и синхронизируйте чеки с вашей учётной записью Savingor.';

  @override
  String get chooseReceiptSource => 'Выберите, как добавить чек';

  @override
  String freeScansUsedThisMonth(int used, int limit) {
    return '$used из $limit бесплатных сканирований использовано в этом месяце';
  }

  @override
  String freeScansRemaining(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Осталось $count бесплатных сканирований',
      many: 'Осталось $count бесплатных сканирований',
      few: 'Осталось $count бесплатных сканирования',
      one: 'Осталось $count бесплатное сканирование',
    );
    return '$_temp0';
  }

  @override
  String get noFreeScansRemainingThisMonth => 'Бесплатные сканирования на этот месяц исчерпаны';

  @override
  String get unlimitedScansWithPro => 'Неограниченное сканирование с Pro';

  @override
  String get loadingScanUsage => 'Проверка использования сканирований…';

  @override
  String get monthlyScanLimitTitle => 'Достигнут месячный лимит сканирований';

  @override
  String get monthlyScanLimitDescription => 'Вы использовали все три бесплатных сканирования чеков в этом месяце. Перейдите на Savingor Pro для неограниченного сканирования.';

  @override
  String get unlockUnlimitedScansWithSavingorPro => 'Разблокируйте неограниченное сканирование с Savingor Pro';

  @override
  String get monthlyScanLimitSaveBlocked => 'Вы достигли бесплатного лимита сканирований на этот месяц. Перейдите на Pro, чтобы сохранять больше отсканированных чеков.';

  @override
  String get takePhoto => 'Сделать фото';

  @override
  String get takePhotoSubtitle => 'Используйте камеру, чтобы отсканировать чек';

  @override
  String get chooseFromGallery => 'Выбрать из галереи';

  @override
  String get chooseFromGallerySubtitle => 'Выберите существующее фото чека';

  @override
  String get scanningReceipt => 'Сканирование чека...';

  @override
  String get couldNotScanReceipt => 'Не удалось отсканировать этот чек. Попробуйте другое фото.';

  @override
  String get ocrResultPreview => 'Предпросмотр OCR';

  @override
  String get noTextDetected => 'Текст не обнаружен. Попробуйте более чёткое фото чека.';

  @override
  String get useThisReceipt => 'Использовать этот чек';

  @override
  String get noneDetected => 'Ничего не обнаружено';

  @override
  String get rawOcrText => 'Необработанный текст OCR';

  @override
  String get itemsColon => 'Товары:';

  @override
  String get addReceipt => 'Добавить чек';

  @override
  String get editReceipt => 'Редактировать чек';

  @override
  String get saveReceipt => 'Сохранить чек';

  @override
  String get updateReceipt => 'Обновить чек';

  @override
  String get storeName => 'Название магазина';

  @override
  String get storeAddressOptional => 'Адрес магазина (необязательно)';

  @override
  String get purchaseDate => 'Дата покупки';

  @override
  String get categorySummary => 'Категория';

  @override
  String get grocery => 'Продукты';

  @override
  String get subtotalOptional => 'Промежуточный итог (необязательно)';

  @override
  String get taxOptional => 'Налог (необязательно)';

  @override
  String get receiptTotal => 'Сумма чека';

  @override
  String get autoCalculatedFromItems => 'Автоматически рассчитывается из товаров, если вы не измените это поле.';

  @override
  String get notesOptional => 'Заметки (необязательно)';

  @override
  String get addItem => 'Добавить товар';

  @override
  String get addLineItemsHint => 'Добавьте позиции, чтобы создать полную запись чека для дальнейшего отслеживания цен.';

  @override
  String get enterStoreName => 'Введите название магазина';

  @override
  String get selectPurchaseDate => 'Выберите дату покупки';

  @override
  String get enterTotalAmount => 'Введите общую сумму';

  @override
  String get enterValidAmount => 'Введите корректную сумму';

  @override
  String get enterValidTotalAmount => 'Введите корректную общую сумму.';

  @override
  String get receiptNotFound => 'Чек не найден.';

  @override
  String get item => 'Товар';

  @override
  String get itemName => 'Название товара';

  @override
  String get enterItemName => 'Введите название товара';

  @override
  String get qty => 'Кол-во';

  @override
  String get invalidValue => 'Некорректно';

  @override
  String get removeItem => 'Удалить товар';

  @override
  String get categoryOptional => 'Категория (необязательно)';

  @override
  String get receiptDetails => 'Детали чека';

  @override
  String subtotalLabel(String amount) {
    return 'Промежуточный итог: $amount';
  }

  @override
  String taxLabel(String amount) {
    return 'Налог: $amount';
  }

  @override
  String get noItemsSaved => 'Товары не сохранены';

  @override
  String get noLineItemsSaved => 'Для этого чека ещё не сохранено ни одной позиции.';

  @override
  String qtyWithValue(String quantity) {
    return 'Кол-во $quantity';
  }

  @override
  String get couldNotDeleteReceipt => 'Не удалось удалить чек. Попробуйте ещё раз.';

  @override
  String get saveChanges => 'Сохранить изменения';

  @override
  String get receiptSourceManual => 'Вручную';

  @override
  String get receiptSourceScanned => 'Отсканировано';

  @override
  String get receiptSourceGallery => 'Галерея';

  @override
  String get receiptSourceImported => 'Импортировано';

  @override
  String get receiptSourceShoppingList => 'Список покупок';

  @override
  String get receiptSourceUnknown => 'Чек';

  @override
  String get scanNotes => 'Заметки сканирования';

  @override
  String get galleryScanNotes => 'Заметки сканирования из галереи';

  @override
  String get importNotes => 'Заметки импорта';

  @override
  String get tripNotes => 'Заметки поездки';

  @override
  String get couldNotLoadYourReceipts => 'Не удалось загрузить ваши чеки. Попробуйте ещё раз.';

  @override
  String get signInToSaveReceipts => 'Войдите, чтобы сохранять чеки.';

  @override
  String get couldNotSaveReceipt => 'Не удалось сохранить чек. Попробуйте ещё раз.';

  @override
  String get couldNotUpdateReceipt => 'Не удалось обновить чек. Попробуйте ещё раз.';

  @override
  String get signInToUpdateReceipts => 'Войдите, чтобы обновлять чеки.';

  @override
  String receiptItemsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count товаров',
      many: '$count товаров',
      few: '$count товара',
      one: '1 товар',
      zero: '0 товаров',
    );
    return '$_temp0';
  }

  @override
  String get processingReceipt => 'Обработка чека';

  @override
  String get readingReceipt => 'Считывание чека';

  @override
  String get recognizingText => 'Распознавание текста';

  @override
  String get receiptScannedSuccessfully => 'Чек успешно отсканирован';

  @override
  String get noTextRecognized => 'Текст не распознан';

  @override
  String get couldNotReadReceipt => 'Не удалось прочитать этот чек';

  @override
  String get imageTooBlurry => 'Изображение слишком размыто';

  @override
  String get tryAnotherPhoto => 'Попробуйте другое фото';

  @override
  String get cameraPermissionRequired => 'Требуется доступ к камере';

  @override
  String get galleryPermissionRequired => 'Требуется доступ к галерее';

  @override
  String get permissionDenied => 'Доступ запрещён';

  @override
  String get openSettings => 'Открыть настройки';

  @override
  String get chooseSavingAction => 'Выберите следующее действие';

  @override
  String get addGroceryExpense => 'Добавить расход на продукты';

  @override
  String get addGroceryExpenseSubtitle => 'Запишите покупку вручную';

  @override
  String get createShoppingListAction => 'Создать список покупок';

  @override
  String get createShoppingListSubtitle => 'Спланируйте покупки заранее';

  @override
  String get optimizeShoppingBasket => 'Оптимизировать корзину';

  @override
  String get optimizeShoppingBasketSubtitle => 'Найдите возможности тратить меньше';

  @override
  String get finalizeShoppingTrip => 'Завершить поход в магазин';

  @override
  String get finalizeShoppingTripSubtitle => 'Завершите текущие покупки';

  @override
  String get monthlyGoalBudget => 'Месячная цель / Бюджет';

  @override
  String get monthlyGoalBudgetSubtitle => 'Установите или измените месячную цель';

  @override
  String get savingsAnalytics => 'Аналитика экономии';

  @override
  String get savingsAnalyticsSubtitle => 'Просмотрите расходы и экономию';

  @override
  String get open => 'Открыть';

  @override
  String get expenses => 'Расходы';

  @override
  String get addExpense => 'Добавить расход';

  @override
  String get loadingExpenses => 'Загрузка расходов...';

  @override
  String get couldNotLoadExpenses => 'Не удалось загрузить расходы';

  @override
  String get couldNotLoadYourExpenses => 'Не удалось загрузить ваши расходы. Попробуйте ещё раз.';

  @override
  String get noExpensesYet => 'Расходов пока нет';

  @override
  String get noExpensesYetMessage => 'Отслеживайте покупки продуктов и чеки, чтобы понимать свои расходы.';

  @override
  String get signInToSyncExpenses => 'Сохраняйте и синхронизируйте расходы с вашей учётной записью Savingor.';

  @override
  String get deleteExpenseQuestion => 'Удалить расход?';

  @override
  String deleteExpenseConfirmMessage(String store, String amount) {
    return '«$store» ($amount) будет удалён безвозвратно.';
  }

  @override
  String get saveExpense => 'Сохранить расход';

  @override
  String get totalAmount => 'Общая сумма';

  @override
  String get signInToSaveExpenses => 'Войдите, чтобы сохранять расходы.';

  @override
  String get couldNotSaveExpense => 'Не удалось сохранить расход. Попробуйте ещё раз.';

  @override
  String get couldNotDeleteExpense => 'Не удалось удалить расход. Попробуйте ещё раз.';

  @override
  String get expenseSaved => 'Расход сохранён.';

  @override
  String get uncategorized => 'Без категории';

  @override
  String get recentExpenses => 'Последние расходы';

  @override
  String get noExpensesAddedYet => 'Расходы ещё не добавлены.';

  @override
  String get pleaseEnterStoreName => 'Пожалуйста, введите название магазина.';

  @override
  String get pleaseEnterItemName => 'Пожалуйста, введите название товара.';

  @override
  String get pleaseEnterPrice => 'Пожалуйста, введите цену.';

  @override
  String get pleaseEnterValidPrice => 'Пожалуйста, введите корректную цену.';

  @override
  String expenseCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count расходов',
      many: '$count расходов',
      few: '$count расхода',
      one: '1 расход',
      zero: '0 расходов',
    );
    return '$_temp0';
  }

  @override
  String get newShoppingList => 'Новый список покупок';

  @override
  String get newList => 'Новый список';

  @override
  String get createList => 'Создать список';

  @override
  String get loadingShoppingLists => 'Загрузка списков покупок...';

  @override
  String get couldNotLoadLists => 'Не удалось загрузить списки';

  @override
  String get couldNotLoadYourShoppingLists => 'Не удалось загрузить ваши списки покупок. Попробуйте ещё раз.';

  @override
  String get noShoppingListsYet => 'Списков покупок пока нет';

  @override
  String get noShoppingListsYetMessage => 'Создайте первый список, чтобы планировать покупки и оптимизировать корзину.';

  @override
  String get signInToSyncShoppingLists => 'Создавайте и синхронизируйте списки покупок с вашей учётной записью Savingor.';

  @override
  String get deleteListQuestion => 'Удалить список?';

  @override
  String deleteListConfirmMessage(String title) {
    return '«$title» будет удалён безвозвратно.';
  }

  @override
  String get deleteList => 'Удалить список';

  @override
  String get optimizeAllLists => 'Оптимизировать все списки';

  @override
  String get optimizeAllListsSubtitle => 'Найдите лучшие известные магазины для ваших активных списков покупок';

  @override
  String get optimizeThisBasket => 'Оптимизировать эту корзину';

  @override
  String get optimizeThisBasketSubtitle => 'Найдите лучшие известные магазины для этого списка';

  @override
  String get listNotFound => 'Список не найден';

  @override
  String get listNotFoundMessage => 'Этот список покупок, возможно, был удалён.';

  @override
  String get backToLists => 'Назад к спискам';

  @override
  String get noShoppingItemsYet => 'Товаров пока нет';

  @override
  String get noShoppingItemsYetMessage => 'Добавьте товары в этот список, чтобы отслеживать потребности.';

  @override
  String get shoppingListEmptyMessage => 'Создавайте и управляйте умными списками покупок здесь.';

  @override
  String get purchased => 'Куплено';

  @override
  String get clearPurchased => 'Очистить купленные';

  @override
  String get estimatedTotalLabel => 'Ориентировочная сумма';

  @override
  String estimatedShort(String amount) {
    return 'Ориент. $amount';
  }

  @override
  String activeCountLabel(int count) {
    return '$count активных';
  }

  @override
  String purchasedSummary(int count) {
    return '$count куплено';
  }

  @override
  String itemsTotalSummary(int count) {
    return '$count товаров всего';
  }

  @override
  String get allItemsPurchased => 'Все товары куплены';

  @override
  String get saveItem => 'Сохранить товар';

  @override
  String get listTitle => 'Название списка';

  @override
  String get enterListTitle => 'Введите название списка';

  @override
  String get listName => 'Название списка';

  @override
  String get enterListName => 'Введите название списка';

  @override
  String get newShoppingListHint => 'Дайте название списку. Товары можно добавить после создания.';

  @override
  String get itemsOptional => 'Товары (необязательно)';

  @override
  String get addAnotherItem => 'Добавить ещё один товар';

  @override
  String get storeOptional => 'Магазин (необязательно)';

  @override
  String get priceOptional => 'Цена (необязательно)';

  @override
  String get loadingListItems => 'Загрузка товаров...';

  @override
  String get loadingShoppingList => 'Загрузка списка покупок...';

  @override
  String get couldNotLoadItems => 'Не удалось загрузить товары';

  @override
  String get couldNotLoadListItems => 'Не удалось загрузить товары списка. Попробуйте ещё раз.';

  @override
  String get createAnotherReceiptQuestion => 'Создать ещё один чек?';

  @override
  String get createAnotherReceiptMessage => 'У этого списка уже может быть чек. Создать ещё один чек из купленных товаров?';

  @override
  String get createReceipt => 'Создать чек';

  @override
  String get signInToFinalizeTrip => 'Войдите, чтобы завершить поход в магазин.';

  @override
  String get noListsReadyToFinalize => 'Нет списков для завершения';

  @override
  String get noListsReadyToFinalizeMessage => 'Отметьте товары как купленные в списке покупок, затем вернитесь сюда, чтобы создать чек.';

  @override
  String get openShoppingLists => 'Открыть списки покупок';

  @override
  String get selectListToFinalize => 'Выберите список для завершения';

  @override
  String get selectListToFinalizeSubtitle => 'Выберите список покупок с купленными товарами.';

  @override
  String get finalizeShoppingTripCardSubtitle => 'Создайте чек из купленных товаров и обновите историю цен';

  @override
  String get done => 'Готово';

  @override
  String get optional => 'Необязательно';

  @override
  String get somethingWentWrong => 'Что-то пошло не так';

  @override
  String get saving => 'Сохранение...';

  @override
  String get loadingPurchasedItems => 'Загрузка купленных товаров...';

  @override
  String get preparingPurchasedItems => 'Подготовка купленных товаров...';

  @override
  String get noPurchasedItemsYet => 'Купленных товаров пока нет';

  @override
  String get noPurchasedItemsYetMessage => 'Отметьте товары как купленные перед созданием чека.';

  @override
  String get backToList => 'Назад к списку';

  @override
  String get enterStoreNameForTrip => 'Введите название магазина для этой поездки';

  @override
  String get enterStoreNameForTripSnack => 'Введите название магазина для этой поездки.';

  @override
  String creatingReceiptsPerStore(int count) {
    return 'Создание $count чеков — по одному на магазин.';
  }

  @override
  String get missingStoreOnItems => 'У некоторых купленных товаров не указан магазин. Добавьте магазин для каждого товара перед завершением.';

  @override
  String get missingStore => 'Магазин не указан';

  @override
  String receiptSubtotalLabel(String amount) {
    return 'Промежуточный итог чека: $amount';
  }

  @override
  String get purchasedItems => 'Купленные товары';

  @override
  String get enterReceiptTotal => 'Введите сумму чека';

  @override
  String get enterValidReceiptTotal => 'Введите корректную сумму чека';

  @override
  String subtotalFromItemPrices(String amount) {
    return 'Промежуточный итог из цен товаров: $amount';
  }

  @override
  String grandTotalAcrossReceipts(String amount) {
    return 'Общая сумма по всем чекам: $amount';
  }

  @override
  String get saveReceipts => 'Сохранить чеки';

  @override
  String addValidPricesForStore(String store) {
    return 'Добавьте корректные цены для купленных товаров в $store.';
  }

  @override
  String get addStoreToAllItems => 'Добавьте магазин для каждого купленного товара перед созданием нескольких чеков.';

  @override
  String get signInToCreateShoppingLists => 'Войдите, чтобы создавать списки покупок.';

  @override
  String get couldNotCreateList => 'Не удалось создать список. Попробуйте ещё раз.';

  @override
  String get couldNotDeleteList => 'Не удалось удалить список. Попробуйте ещё раз.';

  @override
  String get couldNotAddItem => 'Не удалось добавить товар. Попробуйте ещё раз.';

  @override
  String get signInToAddShoppingItems => 'Войдите, чтобы добавлять товары в список покупок.';

  @override
  String get itemNameRequired => 'Требуется название товара.';

  @override
  String get couldNotUpdateItem => 'Не удалось обновить товар. Попробуйте ещё раз.';

  @override
  String get couldNotUpdateQuantity => 'Не удалось обновить количество. Попробуйте ещё раз.';

  @override
  String get couldNotRemoveItem => 'Не удалось удалить товар. Попробуйте ещё раз.';

  @override
  String get couldNotUpdateShoppingList => 'Не удалось обновить список покупок. Попробуйте ещё раз.';

  @override
  String get couldNotCompleteAction => 'Не удалось выполнить действие. Попробуйте ещё раз.';

  @override
  String estimatedPrefix(String amount) {
    return 'Ориентировочно: $amount';
  }

  @override
  String shoppingTripFinalized(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Поход в магазин завершён. Создано $count чеков.',
      many: 'Поход в магазин завершён. Создано $count чеков.',
      few: 'Поход в магазин завершён. Создано $count чека.',
      one: 'Поход в магазин завершён. Создан $count чек.',
    );
    return '$_temp0';
  }

  @override
  String get productChicken => 'Курица';

  @override
  String get productEggs => 'Яйца';

  @override
  String get weeklyGroceriesDefault => 'Еженедельные покупки';

  @override
  String get basketSummary => 'Итог корзины';

  @override
  String get estimatedBestTotal => 'Лучшая ориентировочная сумма';

  @override
  String get basketPotentialSaving => 'Потенциальная экономия';

  @override
  String get itemsMatched => 'Сопоставлено товаров';

  @override
  String get noPriceHistoryLabel => 'Без истории цен';

  @override
  String get activeListsIncludedLabel => 'Активных списков учтено';

  @override
  String get itemRecommendations => 'Рекомендации по товарам';

  @override
  String get bestKnownLabel => 'Лучшая известная цена';

  @override
  String get latestSeen => 'Последняя известная цена';

  @override
  String saveUpToTotal(String amount) {
    return 'Можно сэкономить до $amount в общей сложности';
  }

  @override
  String get noPriceHistoryYet => 'Истории цен пока нет';

  @override
  String get addReceiptsForItemRecommendations => 'Добавьте чеки с этим товаром, чтобы получить рекомендации';

  @override
  String get suggestedStorePlan => 'Рекомендуемый план магазинов';

  @override
  String estimatedStoreTotalLabel(String amount) {
    return 'Ориентировочная сумма в магазине: $amount';
  }

  @override
  String storePlanItemLine(String itemName, String quantitySuffix, String unitPrice, String perUnit) {
    return '• $itemName$quantitySuffix — $unitPrice $perUnit';
  }

  @override
  String get perUnit => 'за единицу';

  @override
  String get signInToOptimizeAllLists => 'Войдите, чтобы оптимизировать все ваши списки покупок на основе чеков.';

  @override
  String get signInToOptimizeBasket => 'Войдите, чтобы оптимизировать корзину на основе чеков и списка покупок.';

  @override
  String get loadingAllActiveLists => 'Загрузка всех активных списков…';

  @override
  String get loadingBasketOptimizer => 'Загрузка оптимизатора корзины…';

  @override
  String get couldNotLoadShoppingList => 'Не удалось загрузить список покупок';

  @override
  String get couldNotLoadPriceHistory => 'Не удалось загрузить историю цен';

  @override
  String get noActiveItemsToOptimize => 'Нет активных товаров для оптимизации';

  @override
  String get noActiveItemsToOptimizeMessage => 'Добавьте товары в списки покупок, чтобы составить умный план магазинов.';

  @override
  String get backToShopping => 'Назад к покупкам';

  @override
  String get addItemsToListForOptimizer => 'Добавьте товары в список покупок';

  @override
  String get addItemsToListForOptimizerMessage => 'Добавьте товары в список покупок, чтобы оптимизировать корзину.';

  @override
  String get noPriceHistoryForOptimizerMessage => 'Добавьте чеки с позициями, чтобы Savingor узнал ваши цены и рекомендовал лучшие магазины.';

  @override
  String listFinalizeProgressSummary(int purchased, int total) {
    return 'Куплено: $purchased · Всего товаров: $total';
  }

  @override
  String qtyWithCount(int count) {
    return 'Кол-во $count';
  }

  @override
  String get unitPrice => 'Цена за единицу';

  @override
  String lineTotalWithAmount(String amount) {
    return 'Сумма за товар: $amount';
  }

  @override
  String get lineTotalEmpty => 'Сумма за товар: —';

  @override
  String enterPriceForProduct(String product) {
    return 'Введите цену для $product';
  }

  @override
  String enterValidPriceForProduct(String product) {
    return 'Введите корректную цену для $product';
  }

  @override
  String get trackMonthlyGrocerySpending => 'Контролируйте ежемесячные расходы на продукты в рамках бюджета';

  @override
  String get monthlyGroceryBudget => 'Ежемесячный бюджет на продукты';

  @override
  String get spentThisMonth => 'Потрачено в этом месяце';

  @override
  String get overBudget => 'Превышение бюджета';

  @override
  String get remaining => 'Остаток';

  @override
  String get updateMonthlyBudget => 'Обновить ежемесячный бюджет';

  @override
  String get setMonthlyBudgetDescription => 'Установите ежемесячный лимит расходов на продукты';

  @override
  String get monthlyBudgetAmount => 'Сумма ежемесячного бюджета';

  @override
  String get saveBudget => 'Сохранить бюджет';

  @override
  String get budgetSaved => 'Бюджет сохранён';

  @override
  String get enterBudgetAmount => 'Введите сумму бюджета';

  @override
  String get enterAmountGreaterThanZero => 'Введите сумму больше нуля';

  @override
  String get overview => 'Обзор';

  @override
  String get estimatedSaved => 'Ориентировочно сэкономлено';

  @override
  String get potentialMissed => 'Потенциально упущено';

  @override
  String get savingsValue => 'Ценность экономии';

  @override
  String get proPayback => 'Окупаемость Pro';

  @override
  String get proPaidForItself => 'Pro окупился';

  @override
  String amountOfPriceCovered(String amount, String price) {
    return 'Покрыто $amount из $price';
  }

  @override
  String needAmountMoreForPro(String amount) {
    return 'Ещё $amount, чтобы окупить Pro';
  }

  @override
  String amountAfterSubscription(String amount) {
    return '+$amount после подписки';
  }

  @override
  String monthlyReturnMultiplier(String multiplier) {
    return 'Возврат: ${multiplier}x в этом месяце';
  }

  @override
  String get spendingByStore => 'Расходы по магазинам';

  @override
  String priceRecordCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count записей',
      many: '$count записей',
      few: '$count записи',
      one: '$count запись',
    );
    return '$_temp0';
  }

  @override
  String get recentActivity => 'Последняя активность';

  @override
  String get activityTypeReceipt => 'Чек';

  @override
  String get activityTypeManual => 'Вручную';

  @override
  String get activityManualExpense => 'Ручной расход';

  @override
  String activityReceiptWithItems(String source, int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count товаров',
      many: '$count товаров',
      few: '$count товара',
      one: '1 товар',
    );
    return '$source · $_temp0';
  }

  @override
  String get recommendedActions => 'Рекомендуемые действия';

  @override
  String get exploreDetails => 'Посмотреть детали';

  @override
  String productsInPriceHistoryCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count товаров в вашей истории цен',
      many: '$count товаров в вашей истории цен',
      few: '$count товара в вашей истории цен',
      one: '1 товар в вашей истории цен',
    );
    return '$_temp0';
  }

  @override
  String get priceInsightsEmptySubtitle => 'Полная память цен из позиций ваших чеков';

  @override
  String get savingsOpportunities => 'Возможности для экономии';

  @override
  String actionableOpportunitiesCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count возможностей для просмотра',
      many: '$count возможностей для просмотра',
      few: '$count возможности для просмотра',
      one: '1 возможность для просмотра',
    );
    return '$_temp0';
  }

  @override
  String get savingsOpportunitiesEmptySubtitle => 'Товары, за которые вы заплатили больше лучшей известной цены';

  @override
  String get loadingAnalytics => 'Загрузка аналитики…';

  @override
  String get couldNotLoadAnalytics => 'Не удалось загрузить аналитику';

  @override
  String get signInForAnalytics => 'Просматривайте аналитику расходов с вашей учётной записью Savingor.';

  @override
  String get noSpendingDataYet => 'Данных о расходах пока нет';

  @override
  String get noSpendingDataMessage => 'Добавьте чек или расход, чтобы увидеть итоги расходов, разбивку по магазинам и тенденции.';

  @override
  String get addMoreReceiptsForSavingsValue => 'Добавьте больше чеков, чтобы рассчитать ценность вашей экономии.';

  @override
  String storeHasSeveralBestPrices(String store) {
    return 'В магазине $store есть несколько ваших лучших известных цен';
  }

  @override
  String trackedProductsLowestAtStore(int count, String store) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count отслеживаемых товаров имеют самую низкую известную цену в $store',
      many: '$count отслеживаемых товаров имеют самую низкую известную цену в $store',
      few: '$count отслеживаемых товара имеют самую низкую известную цену в $store',
      one: '1 отслеживаемый товар имеет самую низкую известную цену в $store',
    );
    return '$_temp0';
  }

  @override
  String get useStoreWhenMatchesRoute => 'Выбирайте этот магазин, когда он соответствует вашему маршруту';

  @override
  String recentlyPaidLatestBestKnown(String latestPrice, String latestStore, String bestPrice, String bestStore) {
    return 'Недавно вы заплатили $latestPrice в $latestStore. Лучшая известная цена — $bestPrice в $bestStore';
  }

  @override
  String basedOnPriceRecords(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'На основе $count записей цены',
      many: 'На основе $count записей цены',
      few: 'На основе $count записей цены',
      one: 'На основе 1 записи цены',
    );
    return '$_temp0';
  }

  @override
  String watchProductPrices(String product) {
    return 'Следите за ценами на $product';
  }

  @override
  String knownPricesRangeFromTo(String low, String high) {
    return 'Ваши известные цены колеблются от $low до $high.';
  }

  @override
  String priceDifferenceAmount(String amount) {
    return 'Разница в цене: $amount';
  }

  @override
  String get productPriceInsights => 'Анализ цен на товары';

  @override
  String productsInPriceHistoryFromReceipts(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count товаров в вашей истории цен из чеков',
      many: '$count товаров в вашей истории цен из чеков',
      few: '$count товара в вашей истории цен из чеков',
      one: '1 товар в вашей истории цен из чеков',
    );
    return '$_temp0';
  }

  @override
  String get latestPriceLabel => 'Последняя цена';

  @override
  String get bestKnownPriceLabel => 'Лучшая известная цена';

  @override
  String get highestPriceLabel => 'Самая высокая цена';

  @override
  String get averagePriceLabel => 'Средняя цена';

  @override
  String priceAtStore(String price, String store) {
    return '$price в $store';
  }

  @override
  String get signInForPriceMemory => 'Войдите, чтобы просмотреть память цен на товары.';

  @override
  String get loadingPriceMemory => 'Загрузка памяти цен…';

  @override
  String get couldNotLoadPriceMemory => 'Не удалось загрузить память цен';

  @override
  String get noPriceMemoryYet => 'Памяти цен пока нет';

  @override
  String get noPriceMemoryMessage => 'Добавьте чеки с позициями, чтобы начать формировать память цен.';

  @override
  String savingsOpportunitiesPaidMoreCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count возможностей для экономии, где вы заплатили больше лучшей известной цены',
      many: '$count возможностей для экономии, где вы заплатили больше лучшей известной цены',
      few: '$count возможности для экономии, где вы заплатили больше лучшей известной цены',
      one: '$count возможность для экономии, где вы заплатили больше лучшей известной цены',
    );
    return '$_temp0';
  }

  @override
  String saveUpToPerItem(String amount) {
    return 'Можно сэкономить до $amount за единицу';
  }

  @override
  String youPaidAtStore(String amount, String store) {
    return 'Вы заплатили $amount в магазине $store';
  }

  @override
  String get recommendationWatchProductBeforeBuying => 'Рекомендация: проверьте цену этого товара перед следующей покупкой.';

  @override
  String recommendationBuyAtStoreNextTime(String store) {
    return 'Рекомендация: в следующий раз купите этот товар в магазине $store.';
  }

  @override
  String get signInForSavingsOpportunities => 'Войдите, чтобы просмотреть возможности для экономии по вашим чекам.';

  @override
  String get loadingSavingsOpportunities => 'Загрузка возможностей для экономии…';

  @override
  String get couldNotLoadSavingsOpportunities => 'Не удалось загрузить возможности для экономии';

  @override
  String get noSavingsOpportunitiesYet => 'Возможностей для экономии пока нет';

  @override
  String get noSavingsOpportunitiesMessage => 'Добавьте больше чеков с позициями, чтобы Savingor мог сравнивать цены в разных магазинах.';

  @override
  String get recordsLabel => 'Записи';

  @override
  String get buyingAdvice => 'Совет по покупке';

  @override
  String get bestKnownPriceAdviceLabel => 'Лучшая известная цена';

  @override
  String get latestPaidAdviceLabel => 'Последняя оплаченная цена';

  @override
  String buyItemAtStoreWhenFitsRoute(String store) {
    return 'Покупайте этот товар в магазине $store, когда это соответствует вашему маршруту.';
  }

  @override
  String get buyItemAtBestPriceWhenFitsRoute => 'Покупайте этот товар там, где раньше нашли лучшую цену, когда это соответствует вашему маршруту.';

  @override
  String get addToShoppingList => 'Добавить в список покупок';

  @override
  String get priceHistory => 'История цен';

  @override
  String get productHistoryTitle => 'История товара';

  @override
  String get productNotFound => 'Товар не найден.';

  @override
  String get buyingAdviceInsufficientHistory => 'Добавьте больше чеков с этим товаром, чтобы получить более умные советы по покупкам.';

  @override
  String get buyingAdvicePaidBestPrice => 'Вы заплатили свою лучшую известную цену.';

  @override
  String get buyingAdviceNoBetterPriceYet => 'Лучшей известной цены пока нет.';

  @override
  String quantityLabelWithCount(String count) {
    return 'Количество: $count';
  }

  @override
  String get addedToShoppingList => 'Добавлено в список покупок';

  @override
  String get alreadyInShoppingList => 'Уже в списке покупок';

  @override
  String get quantityUpdatedSnack => 'Количество обновлено';

  @override
  String get nearbyStores => 'Магазины рядом';

  @override
  String get nearbyStoresSubtitle => 'Найдите продуктовые магазины рядом и сравните возможности для экономии.';

  @override
  String get storesNearby => 'Магазины поблизости';

  @override
  String mapStoresFoundCount(int count) {
    return 'Найдено: $count';
  }

  @override
  String get mapStoresFootnotePlaces => 'Магазины отображаются на основе выбранного места и радиуса поиска.';

  @override
  String get mapStoresFootnoteFallback => 'Показаны продуктовые магазины в выбранном регионе.';

  @override
  String get mapStoresFootnoteDefault => 'Изучите продуктовые магазины рядом с выбранным местом.';

  @override
  String mapNoStoresWithinRadius(int distance) {
    return 'Нет магазинов в радиусе $distance км. Попробуйте увеличить радиус.';
  }

  @override
  String get mapPleaseEnterCityOrArea => 'Введите город или район.';

  @override
  String get mapCouldNotOpenDirections => 'Не удалось открыть маршрут.';

  @override
  String get mapYourLocation => 'Ваше местоположение';

  @override
  String get mapFindGroceryStoresNearYou => 'Найдите продуктовые магазины рядом';

  @override
  String get mapActive => 'Активно';

  @override
  String get mapSearchRadius => 'Радиус поиска';

  @override
  String get mapCheckingLocation => 'Проверка местоположения...';

  @override
  String get mapLocationSelected => 'Место выбрано';

  @override
  String get mapLocationDetected => 'Местоположение определено';

  @override
  String get mapReadyToSearchNearby => 'Готово к поиску продуктовых магазинов рядом.';

  @override
  String get mapCouldNotAccessLocation => 'Не удалось получить доступ к вашему местоположению.';

  @override
  String get mapEnableLocationPrompt => 'Включите геолокацию, чтобы найти продуктовые магазины рядом.';

  @override
  String get mapUseMyLocation => 'Использовать моё местоположение';

  @override
  String get mapEnterCityManually => 'Ввести город вручную';

  @override
  String get mapLocationServicesDisabled => 'Службы геолокации отключены.';

  @override
  String get mapLocationPermissionDenied => 'Доступ к геолокации запрещён.';

  @override
  String get mapCouldNotDetectLocation => 'Не удалось определить ваше местоположение. Попробуйте ещё раз.';

  @override
  String get mapSetYourLocation => 'Укажите своё местоположение';

  @override
  String get mapSetLocationGpsOrCity => 'Используйте GPS или выберите город, чтобы просмотреть магазины рядом.';

  @override
  String get mapCurrentLocation => 'Текущее местоположение';

  @override
  String get directions => 'Маршрут';

  @override
  String get mapStoreCategoryGrocery => 'Продуктовый';

  @override
  String get mapStoreCategorySupermarket => 'Супермаркет';

  @override
  String get mapStoreCategoryWholesale => 'Оптовый';

  @override
  String get mapNearbyStoreStatus => 'Магазин рядом';

  @override
  String get mapListedOnGooglePlaces => 'Из Google Places';

  @override
  String mapRadiusKm(int distance) {
    return '$distance km';
  }

  @override
  String get mapSetLocation => 'Указать местоположение';

  @override
  String get mapCityOrArea => 'Город или район';

  @override
  String get mapCityOrAreaExample => 'Пример: Calgary, Cochrane, Edmonton';

  @override
  String mapMarkerSnippetWithDetail(String distance, String detail) {
    return '$distance · $detail';
  }

  @override
  String get aiSavingsAssistant => 'AI-помощник по экономии';

  @override
  String get aiProPreviewDescription => 'Получайте персональные рекомендации по экономии на продуктах на основе ваших чеков, списков покупок, истории расходов и локальных магазинов.';

  @override
  String get aiProBenefitPersonalizedRecommendations => 'Персональные рекомендации по экономии';

  @override
  String get aiProBenefitStoreComparisons => 'Более умное сравнение магазинов и товаров';

  @override
  String get aiProBenefitSpendingInsights => 'Аналитика расходов на основе истории чеков';

  @override
  String get aiProBenefitBudgetAnswers => 'Ответы AI о вашем бюджете на продукты';

  @override
  String get unlockWithSavingorPro => 'Разблокировать с Savingor Pro';

  @override
  String get viewProBenefits => 'Посмотреть преимущества Pro';

  @override
  String get aiSignInPrompt => 'Войдите, чтобы задавать вопросы AI-помощнику о ваших чеках и списках покупок.';

  @override
  String get aiLoadingYourData => 'Загрузка ваших данных…';

  @override
  String get aiCouldNotLoadData => 'Не удалось загрузить ваши данные';

  @override
  String get aiEmptyTitle => 'Добавьте данные для AI-подсказок';

  @override
  String get aiEmptyMessage => 'Отсканируйте чек, добавьте расход или создайте список покупок. Помощник анализирует сохранённые данные — не актуальные цены в магазинах.';

  @override
  String get aiHeroTitle => 'Ваш AI-тренер по экономии';

  @override
  String get aiHeroSubtitleLive => 'Спрашивайте о расходах, чеках и списках покупок.';

  @override
  String get aiHeroSubtitlePreview => 'Просматривайте подсказки на основе сохранённых данных — подключите API-ключ для живых ответов.';

  @override
  String get aiConfigReadyMessage => 'AI-помощник готов. Подключите API-ключ, чтобы включить живые ответы.';

  @override
  String get aiDataSnapshot => 'Снимок ваших данных';

  @override
  String aiReceiptCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count чеков',
      many: '$count чеков',
      few: '$count чека',
      one: '$count чек',
    );
    return '$_temp0';
  }

  @override
  String aiExpenseCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count расходов',
      many: '$count расходов',
      few: '$count расхода',
      one: '$count расход',
    );
    return '$_temp0';
  }

  @override
  String aiTotalSpendingLabel(String amount) {
    return '$amount всего';
  }

  @override
  String aiListCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count списков',
      many: '$count списков',
      few: '$count списка',
      one: '$count список',
    );
    return '$_temp0';
  }

  @override
  String aiListEstimateLabel(String amount) {
    return '$amount оценка списков';
  }

  @override
  String get aiSuggestedQuestions => 'Предложенные вопросы';

  @override
  String get aiSuggestSaveMoreThisWeek => 'Как мне больше сэкономить на этой неделе?';

  @override
  String get aiSuggestTopStore => 'В каком магазине я трачу больше всего?';

  @override
  String get aiSuggestAnalyzeSpending => 'Проанализируй мои расходы на продукты.';

  @override
  String get aiSuggestShoppingListPriority => 'Что мне купить в первую очередь из списка покупок?';

  @override
  String get aiAnalyzingYourData => 'Анализ ваших данных…';

  @override
  String get aiCouldNotGetAnswer => 'Не удалось получить ответ. Попробуйте ещё раз.';

  @override
  String get aiInsightsDisclaimer => 'Подсказки основаны на сохранённых чеках, расходах и списках покупок в Savingor — не на актуальных ценах или акциях в магазинах.';

  @override
  String get aiInputHintLive => 'Спросите о расходах или списке покупок…';

  @override
  String get aiInputHintPreview => 'Введите вопрос — подключите API-ключ для живых ответов';

  @override
  String get aiRequestFailed => 'Запрос к AI не удался. Попробуйте ещё раз.';

  @override
  String get aiEmptyResponse => 'AI вернул пустой ответ.';

  @override
  String get aiSend => 'Отправить';

  @override
  String get editProfile => 'Редактировать профиль';

  @override
  String get personalInformation => 'Личная информация';

  @override
  String get editProfileFullNameHint => 'Ваше полное имя';

  @override
  String get emailChangesNotAvailable => 'Изменение электронной почты пока недоступно.';

  @override
  String get password => 'Пароль';

  @override
  String get passwordNeverShown => 'В целях безопасности текущий пароль не отображается.';

  @override
  String get changePassword => 'Изменить пароль';

  @override
  String get sendPasswordResetEmailInstead => 'Отправить письмо для сброса пароля';

  @override
  String get sendingResetEmail => 'Отправка письма...';

  @override
  String get changesSaved => 'Изменения сохранены';

  @override
  String get couldNotSaveChanges => 'Не удалось сохранить изменения';

  @override
  String get pleaseEnterFullName => 'Введите полное имя';

  @override
  String get signInToEditProfile => 'Войдите, чтобы редактировать профиль.';

  @override
  String get passwordResetEmailSent => 'Письмо для сброса пароля отправлено';

  @override
  String get changePasswordIntro => 'Чтобы изменить пароль в приложении, сначала введите текущий пароль.';

  @override
  String get currentPassword => 'Текущий пароль';

  @override
  String get newPassword => 'Новый пароль';

  @override
  String get confirmNewPassword => 'Подтвердите новый пароль';

  @override
  String get enterCurrentPasswordHint => 'Введите текущий пароль';

  @override
  String get atLeast6CharactersHint => 'Не менее 6 символов';

  @override
  String get repeatNewPasswordHint => 'Повторите новый пароль';

  @override
  String get currentPasswordRequired => 'Требуется текущий пароль';

  @override
  String get newPasswordRequired => 'Требуется новый пароль';

  @override
  String get newPasswordMinLength => 'Новый пароль должен содержать не менее 6 символов';

  @override
  String get confirmNewPasswordRequired => 'Подтвердите новый пароль';

  @override
  String get passwordsDoNotMatch => 'Пароли не совпадают';

  @override
  String get updatePassword => 'Обновить пароль';

  @override
  String get forgotCurrentPassword => 'Забыли текущий пароль?';

  @override
  String get passwordResetSecureLink => 'Мы отправим на вашу электронную почту безопасную ссылку для создания нового пароля.';

  @override
  String get passwordResetByEmailHint => 'Если вы его не помните, используйте сброс пароля по электронной почте.';

  @override
  String get sendResetEmail => 'Отправить письмо для сброса';

  @override
  String get sending => 'Отправка...';

  @override
  String get passwordUpdated => 'Пароль обновлён';

  @override
  String get showPassword => 'Показать пароль';

  @override
  String get hidePassword => 'Скрыть пароль';

  @override
  String get signInToChangePassword => 'Войдите, чтобы изменить пароль.';

  @override
  String get currentPasswordIncorrect => 'Текущий пароль неверный';

  @override
  String get passwordTooWeak => 'Пароль слишком слабый';

  @override
  String get recentLoginRequired => 'В целях безопасности войдите снова и повторите попытку.';

  @override
  String get tooManyAttempts => 'Слишком много попыток. Попробуйте позже.';

  @override
  String get couldNotUpdatePassword => 'Не удалось обновить пароль';

  @override
  String get noEmailLinked => 'К этой учётной записи не привязана электронная почта.';

  @override
  String get couldNotSendResetEmail => 'Не удалось отправить письмо';

  @override
  String get plans => 'Тарифные планы';

  @override
  String get freeTodayProWhenReady => 'Free сегодня · Pro, когда будете готовы';

  @override
  String get saveSmarterWithAi => 'Экономьте умнее с AI';

  @override
  String get unlockProFeaturesDescription => 'Получите AI-рекомендации, аналитику чеков, умные уведомления и подробные отчёты о расходах.';

  @override
  String get bestValue => 'Лучшее предложение';

  @override
  String get basicDealsBrowsing => 'Просмотр базовых предложений';

  @override
  String get manualExpenseTracking => 'Ручной учёт расходов';

  @override
  String get aiPoweredToolsDescription => 'AI-инструменты для более умной экономии на продуктах.';

  @override
  String get receiptAnalytics => 'Аналитика чеков';

  @override
  String get smartSavingsInsights => 'Умные рекомендации для экономии';

  @override
  String get spendingReports => 'Отчёты о расходах';

  @override
  String get smartAlerts => 'Умные уведомления';

  @override
  String get startProSubscription => 'Оформить подписку Pro';

  @override
  String get restorePurchases => 'Восстановить покупки';

  @override
  String get restoring => 'Восстановление...';

  @override
  String get proSubscriptionActivated => 'Подписка Pro активирована';

  @override
  String get proDemoFallbackActivated => 'Демоверсия Pro активирована — реальный платёж не обработан.';

  @override
  String get couldNotCompletePurchase => 'Не удалось выполнить покупку. Попробуйте ещё раз.';

  @override
  String get couldNotActivateProDemo => 'Не удалось активировать демоверсию Pro. Попробуйте ещё раз.';

  @override
  String get purchaseRestored => 'Покупка восстановлена';

  @override
  String get noPurchasesFound => 'Покупок для восстановления не найдено';

  @override
  String get couldNotRestorePurchases => 'Не удалось восстановить покупки';

  @override
  String get subscriptionSetup => 'Настройка подписки';

  @override
  String get subscriptionSetupPrepared => 'Savingor Pro подготовлен к реальной интеграции покупок в приложении.';

  @override
  String get subscriptionSetupNotConfigured => 'В этой сборке ещё не настроены ключи платёжного провайдера или продукты магазина.';

  @override
  String get activateProDemoForTesting => 'Активировать демоверсию Pro для тестирования';

  @override
  String get demoFallbackActive => 'Активна демоверсия — реальный платёж не обработан.';

  @override
  String get subscriptionPlanLabel => 'План';

  @override
  String pricePerMonth(String price) {
    return '$price / месяц';
  }

  @override
  String get active => 'Активна';

  @override
  String get activeDemo => 'Активная демоверсия';

  @override
  String get cancelled => 'Отменена';

  @override
  String get unknown => 'Неизвестно';

  @override
  String get demoMode => 'Деморежим';

  @override
  String get providerNone => 'Нет';

  @override
  String get revenueCatLabel => 'RevenueCat';

  @override
  String get subscriptionManagedByStore => 'Подпиской управляет App Store или Google Play. Отменить или изменить подписку можно в настройках магазина.';

  @override
  String get manageInAppStoreGooglePlay => 'Управлять в App Store / Google Play';

  @override
  String get cancelProDemo => 'Отменить демоверсию Pro';

  @override
  String get noActiveSubscription => 'Активной подписки нет';

  @override
  String get proDemoCancelled => 'Демоверсия Pro отменена. Вы снова на плане Free.';

  @override
  String get couldNotCancelProDemo => 'Не удалось отменить демоверсию Pro. Попробуйте ещё раз.';

  @override
  String get couldNotOpenSubscriptionManagement => 'Не удалось открыть страницу управления подпиской.';

  @override
  String get managementNotAvailable => 'Управление недоступно';

  @override
  String get managementUrlUnavailableMessage => 'Ссылка для управления подпиской недоступна в этой тестовой сборке. Для покупок RevenueCat Test Store сбросьте тестового пользователя в панели RevenueCat или используйте другую тестовую учётную запись.';

  @override
  String get paymentProviderNotConfiguredSnack => 'Платёжный провайдер не настроен в этой локальной сборке.';

  @override
  String get purchaseCancelled => 'Покупка отменена';

  @override
  String get purchaseFailed => 'Не удалось выполнить покупку';

  @override
  String get productUnavailable => 'Продукт недоступен';

  @override
  String get purchaseNotActiveYet => 'Покупка завершена, но Pro ещё не активирован. Попробуйте восстановить покупки.';

  @override
  String get networkErrorTryAgain => 'Проверьте подключение к интернету и повторите попытку';

  @override
  String get signInToManageSubscription => 'Войдите, чтобы управлять подпиской.';

  @override
  String get couldNotUpdateSubscription => 'Не удалось обновить подписку. Попробуйте ещё раз.';

  @override
  String get debugSubscriptionTestingTitle => 'Тестирование подписки (для разработчиков)';

  @override
  String get debugSubscriptionTestingDescription => 'Временно просматривайте Savingor как Free или Pro пользователь. Это не изменяет реальную подписку.';

  @override
  String get debugSubscriptionUseReal => 'Использовать реальную подписку';

  @override
  String get debugSubscriptionTestAsFree => 'Тестировать как Free';

  @override
  String get debugSubscriptionTestAsPro => 'Тестировать как Pro';

  @override
  String get debugSubscriptionOverrideFree => 'Переопределение плана (разработчик): Free';

  @override
  String get debugSubscriptionOverridePro => 'Переопределение плана (разработчик): Pro';

  @override
  String get proFeatureBasketOptimizerDescription => 'Сравнивайте корзину покупок между магазинами и находите более умные способы тратить меньше.';

  @override
  String get proFeatureBasketBenefitOptimizeAcrossStores => 'Оптимизируйте корзину покупок в ближайших магазинах';

  @override
  String get proFeatureBasketBenefitCompareTotals => 'Сравнивайте ориентировочные суммы корзины';

  @override
  String get proFeatureBasketBenefitEconomicalCombination => 'Найдите более экономичную комбинацию магазинов';

  @override
  String get proFeatureBasketBenefitReduceSpending => 'Сократите лишние расходы на продукты';

  @override
  String get proFeatureSavingsAnalyticsDescription => 'Понимайте тренды экономии, модели расходов и персональные рекомендации.';

  @override
  String get proFeatureAnalyticsBenefitDeeperTrends => 'Просматривайте более глубокие тренды экономии';

  @override
  String get proFeatureAnalyticsBenefitComparePeriods => 'Сравнивайте периоды расходов';

  @override
  String get proFeatureAnalyticsBenefitTrackSavings => 'Отслеживайте ориентировочную экономию';

  @override
  String get proFeatureAnalyticsBenefitAdvancedRecommendations => 'Получайте расширенные рекомендации';

  @override
  String get proFeatureProductPriceInsightsDescription => 'Отслеживайте историю цен на товары и получайте более умные советы по покупкам из чеков.';

  @override
  String get proFeaturePriceInsightsBenefitHistory => 'Просматривайте историю цен на товар';

  @override
  String get proFeaturePriceInsightsBenefitCompareStores => 'Сравнивайте недавние цены в магазинах';

  @override
  String get proFeaturePriceInsightsBenefitBuyingAdvice => 'Получайте советы по покупкам';

  @override
  String get proFeaturePriceInsightsBenefitPurchaseTiming => 'Определяйте выгодное время для покупки';

  @override
  String get proFeatureSavingsOpportunitiesDescription => 'Открывайте персональные способы экономии на основе истории покупок и чеков.';

  @override
  String get proFeatureOpportunitiesBenefitPersonalized => 'Находите персональные способы сэкономить';

  @override
  String get proFeatureOpportunitiesBenefitPrioritize => 'Приоритизируйте действия с наибольшей ценностью';

  @override
  String get proFeatureOpportunitiesBenefitReceiptHistory => 'Используйте insights из чеков и истории покупок';

  @override
  String get proFeatureOpportunitiesBenefitBetterChoices => 'Открывайте лучшие магазины и товары';

  @override
  String get savingorPro => 'Savingor Pro';

  @override
  String get plansHeroTitle => 'Выберите свой план Savingor';

  @override
  String get plansHeroSubtitle => 'Начните бесплатно с базовых инструментов для продуктов. Перейдите на Pro, когда будете готовы к расширенной аналитике экономии.';

  @override
  String get planFreeSubtitle => 'Необходимые инструменты для учёта расходов на продукты и начала экономии.';

  @override
  String get planProSubtitle => 'Расширенная автоматизация и персонализированная аналитика экономии.';

  @override
  String get planFreePrice => 'CAD \$0';

  @override
  String get planProPricePerMonth => 'CAD \$14.99 / месяц';

  @override
  String get upgradeToSavingorPro => 'Перейти на Savingor Pro';

  @override
  String get planComparisonTitle => 'Сравнить планы';

  @override
  String get planIncludedFeaturesTitle => 'Включённые функции';

  @override
  String get planProActiveFeaturesTitle => 'Активные функции Pro';

  @override
  String get planProComingSoonFeaturesTitle => 'Будущие функции Pro';

  @override
  String get planColumnFree => 'Free';

  @override
  String get planColumnPro => 'Pro';

  @override
  String get planAvailabilityIncluded => 'Включено';

  @override
  String get planAvailabilityLocked => 'Заблокировано';

  @override
  String get planAvailabilityUnlimited => 'Безлимит';

  @override
  String get planAvailabilityThreeScansPerMonth => '3 в месяц';

  @override
  String get planFeatureGroceryDashboard => 'Панель расходов на продукты';

  @override
  String get planFeatureNearbyStoreMap => 'Карта магазинов рядом';

  @override
  String get planFeatureShoppingLists => 'Списки покупок';

  @override
  String get planFeatureManualExpenseTracking => 'Ручной учёт расходов';

  @override
  String get planFeatureThreeReceiptScansPerMonth => '3 сканирования чеков в месяц';

  @override
  String get planFeatureBasicReceiptExpenseHistory => 'Базовая история чеков и расходов';

  @override
  String get planFeatureBasicSavingsOpportunities => 'Базовые возможности экономии';

  @override
  String get planFeatureBasicProductPriceInsights => 'Базовые insights цен на товары';

  @override
  String get planFeatureAppSettings => 'Язык, тема, регион и валюта';

  @override
  String get planFeatureUnlimitedReceiptScanning => 'Безлимитное сканирование чеков';

  @override
  String get planFeatureBasketOptimizer => 'Оптимизатор корзины';

  @override
  String get planFeatureAdvancedSavingsAnalytics => 'Расширенная аналитика экономии';

  @override
  String get planFeatureSmartPriceDropAlerts => 'Умные уведомления о снижении цен';

  @override
  String get planFeatureAdvancedSpendingReports => 'Расширенные отчёты о расходах';

  @override
  String get planCompareReceiptScans => 'Сканирование чеков';

  @override
  String get planCompareBasicSavingsOpportunities => 'Базовые возможности экономии';

  @override
  String get planCompareBasicProductPriceInsights => 'Базовые insights цен на товары';
}
