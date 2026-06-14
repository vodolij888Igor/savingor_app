import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Spanish Castilian (`es`).
class AppLocalizationsEs extends AppLocalizations {
  AppLocalizationsEs([String locale = 'es']) : super(locale);

  @override
  String get appName => 'Savingor';

  @override
  String get appSubtitle => 'Ofertas locales y ahorro inteligente';

  @override
  String get home => 'Inicio';

  @override
  String get deals => 'Ofertas';

  @override
  String get receipts => 'Recibos';

  @override
  String get analytics => 'Análisis';

  @override
  String get profile => 'Perfil';

  @override
  String get scanner => 'Escáner de tickets';

  @override
  String get shopping => 'Lista de compras';

  @override
  String get saved => 'Guardados';

  @override
  String get storesMap => 'Mapa';

  @override
  String get aiAssistant => 'IA';

  @override
  String get scanReceipt => 'Escanear recibo';

  @override
  String get dealsMap => 'Mapa de ofertas';

  @override
  String get receiptScanner => 'Escáner de tickets';

  @override
  String get shoppingList => 'Lista de compras';

  @override
  String get mvp => 'MVP v0.1';

  @override
  String get searchHint => 'Buscar ofertas o tiendas...';

  @override
  String get filter => 'Filtro';

  @override
  String get dealsMapSubtitle => 'Muestra ofertas cercanas';

  @override
  String get receiptScannerSubtitle => 'Escanear ticket';

  @override
  String get shoppingListSubtitle => 'Lista inteligente';

  @override
  String dealsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count ofertas',
      one: '$count oferta',
    );
    return '$_temp0';
  }

  @override
  String get noDealsFound => 'No se encontraron ofertas';

  @override
  String get resetFilters => 'Restablecer filtros';

  @override
  String get filtersTitle => 'Filtros';

  @override
  String get stores => 'Tiendas';

  @override
  String get maxPrice => 'Precio máx.';

  @override
  String get sort => 'Orden';

  @override
  String get none => 'Ninguno';

  @override
  String get priceLowHigh => 'Precio: menor a mayor';

  @override
  String get priceHighLow => 'Precio: mayor a menor';

  @override
  String get dealDetails => 'Detalles de la oferta';

  @override
  String get dealNotFound => 'Oferta no encontrada';

  @override
  String get saveDeal => 'Guardar oferta';

  @override
  String get removeSaved => 'Quitar de guardados';

  @override
  String get noSavedDeals => 'Aún no hay ofertas guardadas';

  @override
  String get savedHint => 'Las ofertas guardadas aparecerán aquí';

  @override
  String get cancel => 'Cancelar';

  @override
  String get apply => 'Aplicar';

  @override
  String get save => 'Guardar';

  @override
  String get back => 'Atrás';

  @override
  String get close => 'Cerrar';

  @override
  String get signOut => 'Cerrar sesión';

  @override
  String get loading => 'Cargando...';

  @override
  String get tryAgain => 'Reintentar';

  @override
  String get comingSoon => 'Próximamente';

  @override
  String get continueButton => 'Continuar';

  @override
  String get edit => 'Editar';

  @override
  String get ok => 'OK';

  @override
  String get chooseYourLanguage => 'Elige tu idioma';

  @override
  String get chooseLanguageSubtitle => 'Selecciona el idioma que Savingor debe usar.';

  @override
  String get langSubtitleOnboarding => 'Esto ayuda a personalizar tu experiencia en Savingor.';

  @override
  String get applyLanguage => 'Aplicar idioma';

  @override
  String welcomeBackName(String name) {
    return '¡Bienvenido de nuevo, $name! 👋';
  }

  @override
  String get welcomeBack => '¡Bienvenido de nuevo! 👋';

  @override
  String get readyToSaveSmarterToday => '¿Listo para ahorrar de forma más inteligente hoy?';

  @override
  String get totalExpenses => 'Gastos totales';

  @override
  String get trackedInSavingor => 'Registrado en Savingor';

  @override
  String expensesTracked(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count gastos registrados',
      one: '$count gasto registrado',
    );
    return '$_temp0';
  }

  @override
  String get startSaving => 'Empezar a ahorrar';

  @override
  String get startSavingHero => '✨ EMPEZAR A AHORRAR';

  @override
  String get thisMonth => 'Este mes';

  @override
  String get spent => 'gastado';

  @override
  String get recorded => 'registrado';

  @override
  String get lists => 'listas';

  @override
  String get activeDeals => 'Ofertas activas';

  @override
  String get estimated => 'estimado';

  @override
  String get monthlyGoal => 'Meta mensual';

  @override
  String get noRecentActivity => 'Sin actividad reciente';

  @override
  String get expenseAdded => 'Gasto añadido';

  @override
  String get addExpenseToSeeHere => 'Añade un gasto para verlo aquí';

  @override
  String get yourSavingsSnapshot => 'Tu resumen de ahorros';

  @override
  String get thisMonthSpent => 'Gastado este mes';

  @override
  String get potentialSavingsFound => 'Ahorros potenciales encontrados';

  @override
  String get productsTracked => 'Productos registrados';

  @override
  String get bestActionNow => 'Mejor acción ahora';

  @override
  String get addMoreReceiptsForSavings => 'Añade más recibos para desbloquear ahorros personalizados.';

  @override
  String get account => 'Cuenta';

  @override
  String get yourAccount => 'Tu cuenta';

  @override
  String get planAndSubscription => 'Plan y suscripción';

  @override
  String get appSettings => 'Ajustes de la app';

  @override
  String get region => 'Región';

  @override
  String get language => 'Idioma';

  @override
  String get appearance => 'Apariencia';

  @override
  String get currency => 'Moneda';

  @override
  String get notifications => 'Notificaciones';

  @override
  String get loadingProfile => 'Cargando perfil...';

  @override
  String get noProfileFound => 'Aún no se encontró un perfil para esta cuenta.';

  @override
  String get fullName => 'Nombre completo';

  @override
  String get email => 'Correo electrónico';

  @override
  String get passwordAndSecurity => 'Contraseña y seguridad';

  @override
  String get managePassword => 'Gestionar contraseña';

  @override
  String get currentPlan => 'Plan actual';

  @override
  String get proPlan => 'Plan Pro';

  @override
  String get freePlan => 'Plan gratuito';

  @override
  String get pro => 'Pro';

  @override
  String get free => 'Gratis';

  @override
  String get status => 'Estado';

  @override
  String get provider => 'Proveedor';

  @override
  String get price => 'Precio';

  @override
  String get priceMonthly => '14,99 \$ / mes';

  @override
  String get inactive => 'Inactivo';

  @override
  String get freePlanUpgradeMessage => 'Actualmente tienes el plan gratuito. Pasa a Pro para desbloquear consejos de ahorro con IA, análisis de recibos, alertas inteligentes e informes de gastos.';

  @override
  String get manageSubscription => 'Gestionar suscripción';

  @override
  String get viewPlans => 'Ver planes';

  @override
  String get manageSettings => 'Gestionar ajustes';

  @override
  String get signOutQuestion => '¿Cerrar sesión?';

  @override
  String get signOutMessage => 'Tendrás que iniciar sesión de nuevo para acceder a tu cuenta de Savingor.';

  @override
  String get couldNotLoadProfile => 'No se pudo cargar tu perfil. Inténtalo de nuevo.';

  @override
  String get personalizeSavingor => 'Personaliza Savingor';

  @override
  String get personalizeSavingorSubtitle => 'Elige cómo se ve la app, cómo se comunica y cómo se adapta a tu ubicación.';

  @override
  String get preferences => 'Preferencias';

  @override
  String get appLanguage => 'Idioma de la app';

  @override
  String get appearanceHelper => 'Elige cómo se ve Savingor';

  @override
  String get regionHelper => 'Se usa para tiendas cercanas y ofertas locales';

  @override
  String get currencyHelper => 'Se usa para precios, presupuestos e informes';

  @override
  String get smartSavingsAlerts => 'Alertas inteligentes de ahorro';

  @override
  String get smartSavingsAlertsDescription => 'Recibe notificaciones sobre oportunidades de ahorro, progreso del presupuesto y recomendaciones importantes.';

  @override
  String get regionCanada => 'Canadá';

  @override
  String get regionUnitedStates => 'Estados Unidos';

  @override
  String get appearanceLight => 'Claro';

  @override
  String get appearanceDark => 'Oscuro';

  @override
  String get topSavingOpportunities => 'Mejores oportunidades de ahorro';

  @override
  String get seeAll => 'Ver todo';

  @override
  String bestKnownAtStore(String amount, String store) {
    return 'Mejor precio conocido: $amount en $store';
  }

  @override
  String latestPaidAtStore(String amount, String store) {
    return 'Último precio pagado: $amount en $store';
  }

  @override
  String saveUpToAmount(String amount) {
    return 'Ahorra hasta $amount';
  }

  @override
  String get basedOnReceiptHistory => 'Basado en el historial de recibos';

  @override
  String buyProductAtStoreNextTime(String product, String store) {
    return 'Compra $product en $store la próxima vez';
  }

  @override
  String potentialSavingPerItem(String amount) {
    return 'Ahorro potencial: $amount por artículo';
  }

  @override
  String get productBread => 'Pan';

  @override
  String get productMilk => 'Leche';

  @override
  String get delete => 'Eliminar';

  @override
  String get signIn => 'Iniciar sesión';

  @override
  String get signInRequired => 'Inicio de sesión requerido';

  @override
  String get store => 'Tienda';

  @override
  String get date => 'Fecha';

  @override
  String get total => 'Total';

  @override
  String get items => 'Artículos';

  @override
  String get notes => 'Notas';

  @override
  String get amount => 'Importe';

  @override
  String get category => 'Categoría';

  @override
  String get scanReceiptSubtitle => 'Escanea un ticket de la compra para hacer seguimiento de gastos y ahorros.';

  @override
  String get addManually => 'Añadir manualmente';

  @override
  String recentReceipts(int count) {
    return 'Recibos recientes ($count)';
  }

  @override
  String get noReceiptsYet => 'Aún no hay recibos. Escanea o añade uno para empezar el seguimiento.';

  @override
  String get deleteReceiptQuestion => '¿Eliminar recibo?';

  @override
  String get deleteReceipt => 'Eliminar recibo';

  @override
  String deleteReceiptConfirmMessage(String store, String total) {
    return '$store ($total) se eliminará permanentemente.';
  }

  @override
  String get loadingReceipts => 'Cargando recibos...';

  @override
  String get couldNotLoadReceipts => 'No se pudieron cargar los recibos';

  @override
  String get signInToSyncReceipts => 'Guarda y sincroniza tus recibos con tu cuenta de Savingor.';

  @override
  String get chooseReceiptSource => 'Elige cómo añadir tu recibo';

  @override
  String freeScansUsedThisMonth(int used, int limit) {
    return '$used de $limit escaneos gratuitos usados este mes';
  }

  @override
  String freeScansRemaining(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count escaneos gratuitos restantes',
      one: '1 escaneo gratuito restante',
    );
    return '$_temp0';
  }

  @override
  String get noFreeScansRemainingThisMonth => 'No quedan escaneos gratuitos este mes';

  @override
  String get unlimitedScansWithPro => 'Escaneos ilimitados con Pro';

  @override
  String get loadingScanUsage => 'Comprobando uso de escaneos…';

  @override
  String get monthlyScanLimitTitle => 'Límite mensual de escaneos alcanzado';

  @override
  String get monthlyScanLimitDescription => 'Has usado los tres escaneos gratuitos de recibos de este mes. Actualiza a Savingor Pro para escaneos ilimitados.';

  @override
  String get unlockUnlimitedScansWithSavingorPro => 'Desbloquea escaneos ilimitados con Savingor Pro';

  @override
  String get monthlyScanLimitSaveBlocked => 'Has alcanzado tu límite gratuito de escaneos este mes. Actualiza a Pro para guardar más recibos escaneados.';

  @override
  String get takePhoto => 'Tomar una foto';

  @override
  String get takePhotoSubtitle => 'Usa tu cámara para escanear un recibo';

  @override
  String get chooseFromGallery => 'Elegir de la galería';

  @override
  String get chooseFromGallerySubtitle => 'Selecciona una foto de recibo existente';

  @override
  String get scanningReceipt => 'Escaneando recibo...';

  @override
  String get processingReceiptImage => 'Procesando imagen...';

  @override
  String get readingReceiptText => 'Leyendo texto del recibo...';

  @override
  String get couldNotScanReceipt => 'No se pudo escanear este recibo. Prueba con otra foto.';

  @override
  String get receiptCouldNotBeParsed => 'No pudimos leer los detalles clave del recibo. Puedes revisarlos y añadirlos manualmente.';

  @override
  String get receiptSavedSuccessfully => 'Recibo guardado';

  @override
  String get ocrResultPreview => 'Vista previa del resultado OCR';

  @override
  String get noTextDetected => 'No se detectó texto. Prueba con una foto de recibo más clara.';

  @override
  String get useThisReceipt => 'Usar este recibo';

  @override
  String get noneDetected => 'Nada detectado';

  @override
  String get rawOcrText => 'Texto OCR sin procesar';

  @override
  String get itemsColon => 'Artículos:';

  @override
  String get addReceipt => 'Añadir recibo';

  @override
  String get editReceipt => 'Editar recibo';

  @override
  String get saveReceipt => 'Guardar recibo';

  @override
  String get updateReceipt => 'Actualizar recibo';

  @override
  String get storeName => 'Nombre de la tienda';

  @override
  String get storeAddressOptional => 'Dirección de la tienda (opcional)';

  @override
  String get purchaseDate => 'Fecha de compra';

  @override
  String get categorySummary => 'Categoría';

  @override
  String get grocery => 'Comestibles';

  @override
  String get subtotalOptional => 'Subtotal (opcional)';

  @override
  String get taxOptional => 'Impuesto (opcional)';

  @override
  String get receiptTotal => 'Total del recibo';

  @override
  String get autoCalculatedFromItems => 'Calculado automáticamente a partir de los artículos, salvo que edites este campo.';

  @override
  String get notesOptional => 'Notas (opcional)';

  @override
  String get addItem => 'Añadir artículo';

  @override
  String get addLineItemsHint => 'Añade líneas para crear un registro completo del recibo para el seguimiento de precios.';

  @override
  String get enterStoreName => 'Introduce un nombre de tienda';

  @override
  String get selectPurchaseDate => 'Selecciona una fecha de compra';

  @override
  String get enterTotalAmount => 'Introduce el importe total';

  @override
  String get enterValidAmount => 'Introduce un importe válido';

  @override
  String get enterValidTotalAmount => 'Introduce un importe total válido.';

  @override
  String get receiptNotFound => 'Recibo no encontrado.';

  @override
  String get item => 'Artículo';

  @override
  String get itemName => 'Nombre del artículo';

  @override
  String get enterItemName => 'Introduce un nombre de artículo';

  @override
  String get qty => 'Cant.';

  @override
  String get invalidValue => 'No válido';

  @override
  String get removeItem => 'Eliminar artículo';

  @override
  String get categoryOptional => 'Categoría (opcional)';

  @override
  String get receiptDetails => 'Detalles del recibo';

  @override
  String subtotalLabel(String amount) {
    return 'Subtotal: $amount';
  }

  @override
  String taxLabel(String amount) {
    return 'Impuesto: $amount';
  }

  @override
  String get noItemsSaved => 'Sin artículos guardados';

  @override
  String get noLineItemsSaved => 'Aún no se han guardado líneas para este recibo.';

  @override
  String qtyWithValue(String quantity) {
    return 'Cant. $quantity';
  }

  @override
  String get couldNotDeleteReceipt => 'No se pudo eliminar el recibo. Inténtalo de nuevo.';

  @override
  String get saveChanges => 'Guardar cambios';

  @override
  String get receiptSourceManual => 'Manual';

  @override
  String get receiptSourceScanned => 'Escaneado';

  @override
  String get receiptSourceGallery => 'Galería';

  @override
  String get receiptSourceImported => 'Importado';

  @override
  String get receiptSourceShoppingList => 'Lista de compras';

  @override
  String get receiptSourceUnknown => 'Recibo';

  @override
  String get scanNotes => 'Notas del escaneo';

  @override
  String get galleryScanNotes => 'Notas del escaneo desde galería';

  @override
  String get importNotes => 'Notas de importación';

  @override
  String get tripNotes => 'Notas del viaje';

  @override
  String get couldNotLoadYourReceipts => 'No se pudieron cargar tus recibos. Inténtalo de nuevo.';

  @override
  String get signInToSaveReceipts => 'Inicia sesión para guardar recibos.';

  @override
  String get couldNotSaveReceipt => 'No se pudo guardar el recibo. Inténtalo de nuevo.';

  @override
  String get couldNotUpdateReceipt => 'No se pudo actualizar el recibo. Inténtalo de nuevo.';

  @override
  String get signInToUpdateReceipts => 'Inicia sesión para actualizar recibos.';

  @override
  String receiptItemsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count artículos',
      one: '1 artículo',
      zero: '0 artículos',
    );
    return '$_temp0';
  }

  @override
  String get processingReceipt => 'Procesando recibo';

  @override
  String get readingReceipt => 'Leyendo recibo';

  @override
  String get recognizingText => 'Reconociendo texto';

  @override
  String get receiptScannedSuccessfully => 'Recibo escaneado correctamente';

  @override
  String get noTextRecognized => 'No se reconoció texto';

  @override
  String get couldNotReadReceipt => 'No se pudo leer este recibo';

  @override
  String get imageTooBlurry => 'La imagen está demasiado borrosa';

  @override
  String get tryAnotherPhoto => 'Prueba con otra foto';

  @override
  String get cameraPermissionRequired => 'Se requiere permiso de cámara';

  @override
  String get galleryPermissionRequired => 'Se requiere acceso a la galería';

  @override
  String get permissionDenied => 'Permiso denegado';

  @override
  String get openSettings => 'Abrir ajustes';

  @override
  String get chooseSavingAction => 'Elige qué quieres hacer';

  @override
  String get addGroceryExpense => 'Añadir gasto de supermercado';

  @override
  String get addGroceryExpenseSubtitle => 'Registra una compra manualmente';

  @override
  String get createShoppingListAction => 'Crear lista de la compra';

  @override
  String get createShoppingListSubtitle => 'Planifica lo que necesitas antes de ir de compras';

  @override
  String get optimizeShoppingBasket => 'Optimizar la cesta';

  @override
  String get optimizeShoppingBasketSubtitle => 'Encuentra oportunidades para gastar menos';

  @override
  String get finalizeShoppingTrip => 'Finalizar la compra';

  @override
  String get finalizeShoppingTripSubtitle => 'Completa tu actividad de compra';

  @override
  String get monthlyGoalBudget => 'Meta mensual / Presupuesto';

  @override
  String get monthlyGoalBudgetSubtitle => 'Establece o actualiza tu objetivo mensual';

  @override
  String get savingsAnalytics => 'Análisis de ahorros';

  @override
  String get savingsAnalyticsSubtitle => 'Revisa tus ahorros y gastos';

  @override
  String get open => 'Abrir';

  @override
  String get expenses => 'Gastos';

  @override
  String get addExpense => 'Añadir gasto';

  @override
  String get loadingExpenses => 'Cargando gastos...';

  @override
  String get couldNotLoadExpenses => 'No se pudieron cargar los gastos';

  @override
  String get couldNotLoadYourExpenses => 'No se pudieron cargar tus gastos. Inténtalo de nuevo.';

  @override
  String get noExpensesYet => 'Aún no hay gastos';

  @override
  String get noExpensesYetMessage => 'Registra compras de supermercado y recibos para entender tus gastos.';

  @override
  String get signInToSyncExpenses => 'Guarda y sincroniza tus gastos con tu cuenta de Savingor.';

  @override
  String get deleteExpenseQuestion => '¿Eliminar gasto?';

  @override
  String deleteExpenseConfirmMessage(String store, String amount) {
    return '«$store» ($amount) se eliminará permanentemente.';
  }

  @override
  String get saveExpense => 'Guardar gasto';

  @override
  String get totalAmount => 'Importe total';

  @override
  String get signInToSaveExpenses => 'Inicia sesión para guardar gastos.';

  @override
  String get couldNotSaveExpense => 'No se pudo guardar el gasto. Inténtalo de nuevo.';

  @override
  String get couldNotDeleteExpense => 'No se pudo eliminar el gasto. Inténtalo de nuevo.';

  @override
  String get expenseSaved => 'Gasto guardado.';

  @override
  String get uncategorized => 'Sin categoría';

  @override
  String get recentExpenses => 'Gastos recientes';

  @override
  String get noExpensesAddedYet => 'Aún no se han añadido gastos.';

  @override
  String get pleaseEnterStoreName => 'Introduce el nombre de la tienda.';

  @override
  String get pleaseEnterItemName => 'Introduce el nombre del artículo.';

  @override
  String get pleaseEnterPrice => 'Introduce un precio.';

  @override
  String get pleaseEnterValidPrice => 'Introduce un precio válido.';

  @override
  String expenseCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count gastos',
      one: '1 gasto',
      zero: '0 gastos',
    );
    return '$_temp0';
  }

  @override
  String get newShoppingList => 'Nueva lista de la compra';

  @override
  String get newList => 'Nueva lista';

  @override
  String get createList => 'Crear lista';

  @override
  String get loadingShoppingLists => 'Cargando listas de la compra...';

  @override
  String get couldNotLoadLists => 'No se pudieron cargar las listas';

  @override
  String get couldNotLoadYourShoppingLists => 'No se pudieron cargar tus listas de la compra. Inténtalo de nuevo.';

  @override
  String get noShoppingListsYet => 'Aún no hay listas de la compra';

  @override
  String get noShoppingListsYetMessage => 'Crea tu primera lista para planificar compras y optimizar tu cesta.';

  @override
  String get signInToSyncShoppingLists => 'Crea y sincroniza listas de la compra con tu cuenta de Savingor.';

  @override
  String get deleteListQuestion => '¿Eliminar lista?';

  @override
  String deleteListConfirmMessage(String title) {
    return '«$title» se eliminará permanentemente.';
  }

  @override
  String get deleteList => 'Eliminar lista';

  @override
  String get optimizeAllLists => 'Optimizar todas las listas';

  @override
  String get optimizeAllListsSubtitle => 'Encuentra las mejores tiendas conocidas en tus listas de la compra activas';

  @override
  String get optimizeThisBasket => 'Optimizar esta cesta';

  @override
  String get optimizeThisBasketSubtitle => 'Encuentra las mejores tiendas conocidas para esta lista';

  @override
  String get listNotFound => 'Lista no encontrada';

  @override
  String get listNotFoundMessage => 'Es posible que esta lista de la compra haya sido eliminada.';

  @override
  String get backToLists => 'Volver a las listas';

  @override
  String get noShoppingItemsYet => 'Aún no hay artículos';

  @override
  String get noShoppingItemsYetMessage => 'Añade artículos a esta lista para hacer seguimiento de lo que necesitas.';

  @override
  String get shoppingListEmptyMessage => 'Crea y gestiona tus listas de la compra inteligentes aquí.';

  @override
  String get purchased => 'Comprado';

  @override
  String get clearPurchased => 'Borrar comprados';

  @override
  String get estimatedTotalLabel => 'Total estimado';

  @override
  String estimatedShort(String amount) {
    return 'Estim. $amount';
  }

  @override
  String activeCountLabel(int count) {
    return '$count activos';
  }

  @override
  String purchasedSummary(int count) {
    return '$count comprados';
  }

  @override
  String itemsTotalSummary(int count) {
    return '$count artículos en total';
  }

  @override
  String get allItemsPurchased => 'Todos los artículos comprados';

  @override
  String get saveItem => 'Guardar artículo';

  @override
  String get listTitle => 'Título de la lista';

  @override
  String get enterListTitle => 'Introduce un título para la lista';

  @override
  String get listName => 'Nombre de la lista';

  @override
  String get enterListName => 'Introduce un nombre para la lista';

  @override
  String get newShoppingListHint => 'Ponle un nombre a tu lista. Puedes añadir artículos después de crearla.';

  @override
  String get itemsOptional => 'Artículos (opcional)';

  @override
  String get addAnotherItem => 'Añadir otro artículo';

  @override
  String get storeOptional => 'Tienda (opcional)';

  @override
  String get priceOptional => 'Precio (opcional)';

  @override
  String get loadingListItems => 'Cargando artículos...';

  @override
  String get loadingShoppingList => 'Cargando lista de la compra...';

  @override
  String get couldNotLoadItems => 'No se pudieron cargar los artículos';

  @override
  String get couldNotLoadListItems => 'No se pudieron cargar los artículos de la lista. Inténtalo de nuevo.';

  @override
  String get createAnotherReceiptQuestion => '¿Crear otro recibo?';

  @override
  String get createAnotherReceiptMessage => 'Esta lista ya puede tener un recibo. ¿Crear otro recibo a partir de los artículos comprados?';

  @override
  String get createReceipt => 'Crear recibo';

  @override
  String get signInToFinalizeTrip => 'Inicia sesión para finalizar una compra.';

  @override
  String get noListsReadyToFinalize => 'No hay listas listas para finalizar';

  @override
  String get noListsReadyToFinalizeMessage => 'Marca artículos como comprados en una lista de la compra y vuelve aquí para crear un recibo.';

  @override
  String get openShoppingLists => 'Abrir listas de la compra';

  @override
  String get selectListToFinalize => 'Seleccionar lista para finalizar';

  @override
  String get selectListToFinalizeSubtitle => 'Elige una lista de la compra con artículos comprados.';

  @override
  String get finalizeShoppingTripCardSubtitle => 'Crea un recibo a partir de los artículos comprados y actualiza tu historial de precios';

  @override
  String get done => 'Hecho';

  @override
  String get optional => 'Opcional';

  @override
  String get somethingWentWrong => 'Algo salió mal';

  @override
  String get saving => 'Guardando...';

  @override
  String get loadingPurchasedItems => 'Cargando artículos comprados...';

  @override
  String get preparingPurchasedItems => 'Preparando artículos comprados...';

  @override
  String get noPurchasedItemsYet => 'Aún no hay artículos comprados';

  @override
  String get noPurchasedItemsYetMessage => 'Marca los artículos que compraste antes de crear un recibo.';

  @override
  String get backToList => 'Volver a la lista';

  @override
  String get enterStoreNameForTrip => 'Introduce el nombre de la tienda para esta compra';

  @override
  String get enterStoreNameForTripSnack => 'Introduce el nombre de la tienda para esta compra.';

  @override
  String creatingReceiptsPerStore(int count) {
    return 'Creando $count recibos — uno por tienda.';
  }

  @override
  String get missingStoreOnItems => 'A algunos artículos comprados les falta una tienda. Añade una tienda a cada artículo antes de finalizar.';

  @override
  String get missingStore => 'Tienda no indicada';

  @override
  String receiptSubtotalLabel(String amount) {
    return 'Subtotal del recibo: $amount';
  }

  @override
  String get purchasedItems => 'Artículos comprados';

  @override
  String get enterReceiptTotal => 'Introduce el total del recibo';

  @override
  String get enterValidReceiptTotal => 'Introduce un total de recibo válido';

  @override
  String subtotalFromItemPrices(String amount) {
    return 'Subtotal de precios de artículos: $amount';
  }

  @override
  String grandTotalAcrossReceipts(String amount) {
    return 'Total general de todos los recibos: $amount';
  }

  @override
  String get saveReceipts => 'Guardar recibos';

  @override
  String addValidPricesForStore(String store) {
    return 'Añade precios válidos para los artículos comprados en $store.';
  }

  @override
  String get addStoreToAllItems => 'Añade una tienda a cada artículo comprado antes de finalizar varios recibos.';

  @override
  String get signInToCreateShoppingLists => 'Inicia sesión para crear listas de la compra.';

  @override
  String get couldNotCreateList => 'No se pudo crear la lista. Inténtalo de nuevo.';

  @override
  String get couldNotDeleteList => 'No se pudo eliminar la lista. Inténtalo de nuevo.';

  @override
  String get couldNotAddItem => 'No se pudo añadir el artículo. Inténtalo de nuevo.';

  @override
  String get signInToAddShoppingItems => 'Inicia sesión para añadir artículos a tu lista de la compra.';

  @override
  String get itemNameRequired => 'El nombre del artículo es obligatorio.';

  @override
  String get couldNotUpdateItem => 'No se pudo actualizar el artículo. Inténtalo de nuevo.';

  @override
  String get couldNotUpdateQuantity => 'No se pudo actualizar la cantidad. Inténtalo de nuevo.';

  @override
  String get couldNotRemoveItem => 'No se pudo eliminar el artículo. Inténtalo de nuevo.';

  @override
  String get couldNotUpdateShoppingList => 'No se pudo actualizar la lista de la compra. Inténtalo de nuevo.';

  @override
  String get couldNotCompleteAction => 'No se pudo completar la acción. Inténtalo de nuevo.';

  @override
  String estimatedPrefix(String amount) {
    return 'Estimado: $amount';
  }

  @override
  String shoppingTripFinalized(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Compra finalizada. $count recibos creados.',
      one: 'Compra finalizada. 1 recibo creado.',
    );
    return '$_temp0';
  }

  @override
  String get productChicken => 'Pollo';

  @override
  String get productEggs => 'Huevos';

  @override
  String get weeklyGroceriesDefault => 'Compras semanales';

  @override
  String get basketSummary => 'Resumen de la cesta';

  @override
  String get estimatedBestTotal => 'Mejor total estimado';

  @override
  String get basketPotentialSaving => 'Ahorro potencial';

  @override
  String get itemsMatched => 'Artículos coincidentes';

  @override
  String get noPriceHistoryLabel => 'Sin historial de precios';

  @override
  String get activeListsIncludedLabel => 'Listas activas incluidas';

  @override
  String get itemRecommendations => 'Recomendaciones de artículos';

  @override
  String get bestKnownLabel => 'Mejor precio conocido';

  @override
  String get latestSeen => 'Último visto';

  @override
  String saveUpToTotal(String amount) {
    return 'Ahorra hasta $amount en total';
  }

  @override
  String get noPriceHistoryYet => 'Aún no hay historial de precios';

  @override
  String get addReceiptsForItemRecommendations => 'Añade recibos con este artículo para desbloquear recomendaciones';

  @override
  String get suggestedStorePlan => 'Plan de tiendas sugerido';

  @override
  String estimatedStoreTotalLabel(String amount) {
    return 'Total estimado en tienda: $amount';
  }

  @override
  String storePlanItemLine(String itemName, String quantitySuffix, String unitPrice, String perUnit) {
    return '• $itemName$quantitySuffix — $unitPrice $perUnit';
  }

  @override
  String get perUnit => 'c/u';

  @override
  String get signInToOptimizeAllLists => 'Inicia sesión para optimizar todas tus listas de la compra a partir de tus recibos.';

  @override
  String get signInToOptimizeBasket => 'Inicia sesión para optimizar tu cesta a partir de tus recibos y lista de la compra.';

  @override
  String get loadingAllActiveLists => 'Cargando todas las listas activas…';

  @override
  String get loadingBasketOptimizer => 'Cargando optimizador de cesta…';

  @override
  String get couldNotLoadShoppingList => 'No se pudo cargar la lista de la compra';

  @override
  String get couldNotLoadPriceHistory => 'No se pudo cargar el historial de precios';

  @override
  String get noActiveItemsToOptimize => 'No hay artículos activos para optimizar';

  @override
  String get noActiveItemsToOptimizeMessage => 'Añade artículos a tus listas de la compra para crear un plan de tiendas inteligente.';

  @override
  String get backToShopping => 'Volver a la compra';

  @override
  String get addItemsToListForOptimizer => 'Añade artículos a tu lista de la compra';

  @override
  String get addItemsToListForOptimizerMessage => 'Añade artículos a tu lista de la compra para optimizar tu cesta.';

  @override
  String get noPriceHistoryForOptimizerMessage => 'Añade recibos con líneas de artículos para que Savingor aprenda tus precios y recomiende mejores tiendas.';

  @override
  String listFinalizeProgressSummary(int purchased, int total) {
    return 'Comprados: $purchased · Total de artículos: $total';
  }

  @override
  String qtyWithCount(int count) {
    return 'Cant. $count';
  }

  @override
  String get unitPrice => 'Precio unitario';

  @override
  String lineTotalWithAmount(String amount) {
    return 'Total de línea: $amount';
  }

  @override
  String get lineTotalEmpty => 'Total de línea: —';

  @override
  String enterPriceForProduct(String product) {
    return 'Introduce un precio para $product';
  }

  @override
  String enterValidPriceForProduct(String product) {
    return 'Introduce un precio válido para $product';
  }

  @override
  String get trackMonthlyGrocerySpending => 'Controla tus gastos mensuales en comestibles según tu presupuesto.';

  @override
  String get monthlyGroceryBudget => 'Presupuesto mensual de comestibles';

  @override
  String get spentThisMonth => 'Gastado este mes';

  @override
  String get overBudget => 'Presupuesto superado';

  @override
  String get remaining => 'Restante';

  @override
  String get updateMonthlyBudget => 'Actualizar presupuesto mensual';

  @override
  String get setMonthlyBudgetDescription => 'Establece el límite de gasto en comestibles que quieres controlar cada mes.';

  @override
  String get monthlyBudgetAmount => 'Importe del presupuesto mensual';

  @override
  String get saveBudget => 'Guardar presupuesto';

  @override
  String get budgetSaved => 'Presupuesto guardado';

  @override
  String get enterBudgetAmount => 'Introduce un importe de presupuesto';

  @override
  String get enterAmountGreaterThanZero => 'Introduce un importe mayor que cero';

  @override
  String get overview => 'Resumen';

  @override
  String get estimatedSaved => 'Ahorro estimado';

  @override
  String get potentialMissed => 'Potencialmente perdido';

  @override
  String get savingsValue => 'Valor del ahorro';

  @override
  String get proPayback => 'Rentabilidad Pro';

  @override
  String get proPaidForItself => 'Pro se amortizó';

  @override
  String amountOfPriceCovered(String amount, String price) {
    return '$amount de $price cubiertos';
  }

  @override
  String needAmountMoreForPro(String amount) {
    return 'Faltan $amount para cubrir Pro';
  }

  @override
  String amountAfterSubscription(String amount) {
    return '+$amount después de la suscripción';
  }

  @override
  String monthlyReturnMultiplier(String multiplier) {
    return 'Retorno: ${multiplier}x este mes';
  }

  @override
  String get spendingByStore => 'Gastos por tienda';

  @override
  String priceRecordCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count registros',
      one: '1 registro',
    );
    return '$_temp0';
  }

  @override
  String get recentActivity => 'Actividad reciente';

  @override
  String get activityTypeReceipt => 'Recibo';

  @override
  String get activityTypeManual => 'Manual';

  @override
  String get activityManualExpense => 'Gasto manual';

  @override
  String activityReceiptWithItems(String source, int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count artículos',
      one: '1 artículo',
    );
    return '$source · $_temp0';
  }

  @override
  String get recommendedActions => 'Acciones recomendadas';

  @override
  String get exploreDetails => 'Ver detalles';

  @override
  String productsInPriceHistoryCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count productos en tu historial de precios',
      one: '1 producto en tu historial de precios',
    );
    return '$_temp0';
  }

  @override
  String get priceInsightsEmptySubtitle => 'Memoria completa de precios de las líneas de tus recibos';

  @override
  String get savingsOpportunities => 'Oportunidades de ahorro';

  @override
  String actionableOpportunitiesCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count oportunidades accionables para revisar',
      one: '1 oportunidad accionable para revisar',
    );
    return '$_temp0';
  }

  @override
  String get savingsOpportunitiesEmptySubtitle => 'Productos por los que pagaste más que el mejor precio conocido';

  @override
  String get loadingAnalytics => 'Cargando análisis…';

  @override
  String get couldNotLoadAnalytics => 'No se pudo cargar el análisis';

  @override
  String get signInForAnalytics => 'Consulta el análisis de gastos con tu cuenta de Savingor.';

  @override
  String get noSpendingDataYet => 'Aún no hay datos de gastos';

  @override
  String get noSpendingDataMessage => 'Añade un recibo o gasto para ver totales, desglose por tienda y tendencias.';

  @override
  String get addMoreReceiptsForSavingsValue => 'Añade más recibos para calcular el valor de tu ahorro.';

  @override
  String storeHasSeveralBestPrices(String store) {
    return '$store tiene varios de tus mejores precios conocidos';
  }

  @override
  String trackedProductsLowestAtStore(int count, String store) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count productos registrados tienen actualmente su precio más bajo conocido en $store',
      one: '1 producto registrado tiene actualmente su precio más bajo conocido en $store',
    );
    return '$_temp0';
  }

  @override
  String get useStoreWhenMatchesRoute => 'Usa esta tienda cuando coincida con tu ruta de compras';

  @override
  String recentlyPaidLatestBestKnown(String latestPrice, String latestStore, String bestPrice, String bestStore) {
    return 'Recientemente pagaste $latestPrice en $latestStore. Tu mejor precio conocido es $bestPrice en $bestStore.';
  }

  @override
  String basedOnPriceRecords(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Basado en $count registros de precio',
      one: 'Basado en 1 registro de precio',
    );
    return '$_temp0';
  }

  @override
  String watchProductPrices(String product) {
    return 'Vigila de cerca los precios de $product';
  }

  @override
  String knownPricesRangeFromTo(String low, String high) {
    return 'Tus precios conocidos van de $low a $high.';
  }

  @override
  String priceDifferenceAmount(String amount) {
    return 'Diferencia de precio: $amount';
  }

  @override
  String get productPriceInsights => 'Análisis de precios de productos';

  @override
  String productsInPriceHistoryFromReceipts(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count productos en tu historial de precios de recibos',
      one: '1 producto en tu historial de precios de recibos',
    );
    return '$_temp0';
  }

  @override
  String get latestPriceLabel => 'Último';

  @override
  String get bestKnownPriceLabel => 'Mejor conocido';

  @override
  String get highestPriceLabel => 'Más alto';

  @override
  String get averagePriceLabel => 'Promedio';

  @override
  String priceAtStore(String price, String store) {
    return '$price en $store';
  }

  @override
  String get signInForPriceMemory => 'Inicia sesión para ver tu memoria de precios de productos.';

  @override
  String get loadingPriceMemory => 'Cargando memoria de precios…';

  @override
  String get couldNotLoadPriceMemory => 'No se pudo cargar la memoria de precios';

  @override
  String get noPriceMemoryYet => 'Aún no hay memoria de precios';

  @override
  String get noPriceMemoryMessage => 'Añade recibos con líneas de artículos para empezar a construir tu memoria de precios.';

  @override
  String savingsOpportunitiesPaidMoreCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count oportunidades de ahorro donde pagaste más que el mejor precio conocido',
      one: '1 oportunidad de ahorro donde pagaste más que el mejor precio conocido',
    );
    return '$_temp0';
  }

  @override
  String saveUpToPerItem(String amount) {
    return 'Ahorra hasta $amount por unidad';
  }

  @override
  String youPaidAtStore(String amount, String store) {
    return 'Pagaste $amount en $store';
  }

  @override
  String get recommendationWatchProductBeforeBuying => 'Recomendación: vigila este producto antes de volver a comprarlo.';

  @override
  String recommendationBuyAtStoreNextTime(String store) {
    return 'Recomendación: compra la próxima vez en $store.';
  }

  @override
  String get signInForSavingsOpportunities => 'Inicia sesión para ver oportunidades de ahorro a partir de tus recibos.';

  @override
  String get loadingSavingsOpportunities => 'Cargando oportunidades de ahorro…';

  @override
  String get couldNotLoadSavingsOpportunities => 'No se pudieron cargar las oportunidades de ahorro';

  @override
  String get noSavingsOpportunitiesYet => 'Aún no hay oportunidades de ahorro';

  @override
  String get noSavingsOpportunitiesMessage => 'Añade más recibos con líneas de artículos para que Savingor pueda comparar precios entre tiendas.';

  @override
  String get recordsLabel => 'Registros';

  @override
  String get buyingAdvice => 'Consejo de compra';

  @override
  String get bestKnownPriceAdviceLabel => 'Mejor precio conocido';

  @override
  String get latestPaidAdviceLabel => 'Último precio pagado';

  @override
  String buyItemAtStoreWhenFitsRoute(String store) {
    return 'Compra este artículo en $store cuando encaje con tu ruta.';
  }

  @override
  String get buyItemAtBestPriceWhenFitsRoute => 'Compra este artículo donde antes encontraste el mejor precio, cuando encaje con tu ruta.';

  @override
  String get addToShoppingList => 'Añadir a la lista de compras';

  @override
  String get priceHistory => 'Historial de precios';

  @override
  String get productHistoryTitle => 'Historial del producto';

  @override
  String get productNotFound => 'Producto no encontrado.';

  @override
  String get buyingAdviceInsufficientHistory => 'Añade más recibos con este artículo para obtener consejos de compra más inteligentes.';

  @override
  String get buyingAdvicePaidBestPrice => 'Pagaste tu mejor precio conocido.';

  @override
  String get buyingAdviceNoBetterPriceYet => 'Aún no hay un mejor precio conocido.';

  @override
  String quantityLabelWithCount(String count) {
    return 'Cantidad: $count';
  }

  @override
  String get addedToShoppingList => 'Añadido a la lista de compras';

  @override
  String get alreadyInShoppingList => 'Ya está en la lista de compras';

  @override
  String get quantityUpdatedSnack => 'Cantidad actualizada';

  @override
  String get nearbyStores => 'Tiendas cercanas';

  @override
  String get nearbyStoresSubtitle => 'Encuentra supermercados cerca de ti y compara oportunidades de ahorro.';

  @override
  String get storesNearby => 'Tiendas cercanas';

  @override
  String mapStoresFoundCount(int count) {
    return '$count encontradas';
  }

  @override
  String get mapStoresFootnotePlaces => 'Las tiendas se basan en tu ubicación seleccionada y el radio de búsqueda.';

  @override
  String get mapStoresFootnoteFallback => 'Mostrando supermercados en el área seleccionada.';

  @override
  String get mapStoresFootnoteDefault => 'Explora supermercados cerca de la ubicación elegida.';

  @override
  String mapNoStoresWithinRadius(int distance) {
    return 'No hay tiendas en un radio de $distance km. Prueba con un radio mayor.';
  }

  @override
  String get mapPleaseEnterCityOrArea => 'Introduce una ciudad o zona.';

  @override
  String get mapCouldNotOpenDirections => 'No se pudo abrir la ruta.';

  @override
  String get mapYourLocation => 'Tu ubicación';

  @override
  String get mapFindGroceryStoresNearYou => 'Encuentra supermercados cerca de ti';

  @override
  String get mapActive => 'Activo';

  @override
  String get mapSearchRadius => 'Radio de búsqueda';

  @override
  String get mapCheckingLocation => 'Comprobando ubicación...';

  @override
  String get mapLocationSelected => 'Ubicación seleccionada';

  @override
  String get mapLocationDetected => 'Ubicación detectada';

  @override
  String get mapReadyToSearchNearby => 'Listo para buscar supermercados cercanos.';

  @override
  String get mapCouldNotAccessLocation => 'No se pudo acceder a tu ubicación.';

  @override
  String get mapEnableLocationPrompt => 'Activa la ubicación para encontrar supermercados cerca de ti.';

  @override
  String get mapUseMyLocation => 'Usar mi ubicación';

  @override
  String get mapEnterCityManually => 'Introducir ciudad manualmente';

  @override
  String get mapLocationServicesDisabled => 'Los servicios de ubicación están desactivados.';

  @override
  String get mapLocationPermissionDenied => 'Permiso de ubicación denegado.';

  @override
  String get mapCouldNotDetectLocation => 'No se pudo detectar tu ubicación. Inténtalo de nuevo.';

  @override
  String get mapSetYourLocation => 'Establece tu ubicación';

  @override
  String get mapSetLocationGpsOrCity => 'Usa el GPS o elige una ciudad para ver tiendas cercanas.';

  @override
  String get mapCurrentLocation => 'Ubicación actual';

  @override
  String get directions => 'Ruta';

  @override
  String get mapStoreCategoryGrocery => 'Supermercado';

  @override
  String get mapStoreCategorySupermarket => 'Hipermercado';

  @override
  String get mapStoreCategoryWholesale => 'Mayorista';

  @override
  String get mapNearbyStoreStatus => 'Tienda cercana';

  @override
  String get mapListedOnGooglePlaces => 'Listado en Google Places';

  @override
  String mapRadiusKm(int distance) {
    return '$distance km';
  }

  @override
  String get mapSetLocation => 'Establecer ubicación';

  @override
  String get mapCityOrArea => 'Ciudad o zona';

  @override
  String get mapCityOrAreaExample => 'Ejemplo: Calgary, Cochrane, Edmonton';

  @override
  String mapMarkerSnippetWithDetail(String distance, String detail) {
    return '$distance · $detail';
  }

  @override
  String get aiSavingsAssistant => 'Asistente IA de ahorro';

  @override
  String get aiProPreviewDescription => 'Obtén recomendaciones personalizadas de ahorro en comestibles basadas en tus recibos, listas de compras, historial de gastos y tiendas locales.';

  @override
  String get aiProBenefitPersonalizedRecommendations => 'Recomendaciones personalizadas de ahorro';

  @override
  String get aiProBenefitStoreComparisons => 'Comparaciones más inteligentes de tiendas y productos';

  @override
  String get aiProBenefitSpendingInsights => 'Información de gastos basada en el historial de recibos';

  @override
  String get aiProBenefitBudgetAnswers => 'Respuestas de IA sobre tu presupuesto de comestibles';

  @override
  String get unlockWithSavingorPro => 'Desbloquear con Savingor Pro';

  @override
  String get viewProBenefits => 'Ver beneficios Pro';

  @override
  String get aiSignInPrompt => 'Inicia sesión para preguntar al asistente IA sobre tus recibos y listas de compras.';

  @override
  String get aiLoadingYourData => 'Cargando tus datos…';

  @override
  String get aiCouldNotLoadData => 'No se pudieron cargar tus datos';

  @override
  String get aiEmptyTitle => 'Añade datos para obtener consejos de IA';

  @override
  String get aiEmptyMessage => 'Escanea un recibo, añade un gasto o crea una lista de compras. El asistente analiza tus datos guardados — no precios en tienda en tiempo real.';

  @override
  String get aiHeroTitle => 'Tu coach de ahorro con IA';

  @override
  String get aiHeroSubtitleLive => 'Pregunta sobre gastos, recibos y listas de compras.';

  @override
  String get aiHeroSubtitlePreview => 'Vista previa de consejos a partir de tus datos guardados — conecta una clave API para respuestas en vivo.';

  @override
  String get aiConfigReadyMessage => 'El asistente IA está listo. Conecta una clave API para activar respuestas en vivo.';

  @override
  String get aiDataSnapshot => 'Resumen de tus datos';

  @override
  String aiReceiptCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count recibos',
      one: '1 recibo',
    );
    return '$_temp0';
  }

  @override
  String aiExpenseCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count gastos',
      one: '1 gasto',
    );
    return '$_temp0';
  }

  @override
  String aiTotalSpendingLabel(String amount) {
    return '$amount en total';
  }

  @override
  String aiListCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count listas',
      one: '1 lista',
    );
    return '$_temp0';
  }

  @override
  String aiListEstimateLabel(String amount) {
    return '$amount est. listas';
  }

  @override
  String get aiSuggestedQuestions => 'Preguntas sugeridas';

  @override
  String get aiSuggestSaveMoreThisWeek => '¿Cómo puedo ahorrar más esta semana?';

  @override
  String get aiSuggestTopStore => '¿En qué tienda gasto más?';

  @override
  String get aiSuggestAnalyzeSpending => 'Analiza mis gastos en comestibles.';

  @override
  String get aiSuggestShoppingListPriority => '¿Qué debería comprar primero de mi lista?';

  @override
  String get aiAnalyzingYourData => 'Analizando tus datos…';

  @override
  String get aiCouldNotGetAnswer => 'No se pudo obtener una respuesta. Inténtalo de nuevo.';

  @override
  String get aiInsightsDisclaimer => 'Los consejos se basan en tus recibos, gastos y listas de compras guardados en Savingor — no en precios u ofertas en tienda en tiempo real.';

  @override
  String get aiInputHintLive => 'Pregunta sobre tus gastos o tu lista de compras…';

  @override
  String get aiInputHintPreview => 'Escribe una pregunta — conecta una clave API para respuestas en vivo';

  @override
  String get aiRequestFailed => 'La solicitud de IA falló. Inténtalo de nuevo.';

  @override
  String get aiEmptyResponse => 'La IA devolvió una respuesta vacía.';

  @override
  String get aiSend => 'Enviar';

  @override
  String get editProfile => 'Editar perfil';

  @override
  String get personalInformation => 'Información personal';

  @override
  String get editProfileFullNameHint => 'Tu nombre completo';

  @override
  String get emailChangesNotAvailable => 'Los cambios de correo electrónico no están disponibles en esta versión.';

  @override
  String get password => 'Contraseña';

  @override
  String get passwordNeverShown => 'Por seguridad, tu contraseña actual nunca se muestra.';

  @override
  String get changePassword => 'Cambiar contraseña';

  @override
  String get sendPasswordResetEmailInstead => 'Enviar correo de restablecimiento de contraseña';

  @override
  String get sendingResetEmail => 'Enviando correo...';

  @override
  String get changesSaved => 'Cambios guardados';

  @override
  String get couldNotSaveChanges => 'No se pudieron guardar los cambios';

  @override
  String get pleaseEnterFullName => 'Introduce tu nombre completo';

  @override
  String get signInToEditProfile => 'Inicia sesión para editar tu perfil.';

  @override
  String get passwordResetEmailSent => 'Correo de restablecimiento enviado';

  @override
  String get changePasswordIntro => 'Para cambiar tu contraseña en la app, introduce primero tu contraseña actual.';

  @override
  String get currentPassword => 'Contraseña actual';

  @override
  String get newPassword => 'Nueva contraseña';

  @override
  String get confirmNewPassword => 'Confirmar nueva contraseña';

  @override
  String get enterCurrentPasswordHint => 'Introduce la contraseña actual';

  @override
  String get atLeast6CharactersHint => 'Al menos 6 caracteres';

  @override
  String get repeatNewPasswordHint => 'Repite la nueva contraseña';

  @override
  String get currentPasswordRequired => 'La contraseña actual es obligatoria';

  @override
  String get newPasswordRequired => 'La nueva contraseña es obligatoria';

  @override
  String get newPasswordMinLength => 'La nueva contraseña debe tener al menos 6 caracteres';

  @override
  String get confirmNewPasswordRequired => 'Confirma tu nueva contraseña';

  @override
  String get passwordsDoNotMatch => 'Las contraseñas no coinciden';

  @override
  String get updatePassword => 'Actualizar contraseña';

  @override
  String get forgotCurrentPassword => '¿Olvidaste tu contraseña actual?';

  @override
  String get passwordResetSecureLink => 'Enviaremos un enlace seguro a tu correo para que puedas crear una nueva contraseña.';

  @override
  String get passwordResetByEmailHint => 'Si no la recuerdas, usa el restablecimiento por correo electrónico.';

  @override
  String get sendResetEmail => 'Enviar correo de restablecimiento';

  @override
  String get sending => 'Enviando...';

  @override
  String get passwordUpdated => 'Contraseña actualizada';

  @override
  String get showPassword => 'Mostrar contraseña';

  @override
  String get hidePassword => 'Ocultar contraseña';

  @override
  String get signInToChangePassword => 'Inicia sesión para cambiar tu contraseña.';

  @override
  String get currentPasswordIncorrect => 'La contraseña actual es incorrecta';

  @override
  String get passwordTooWeak => 'La contraseña es demasiado débil';

  @override
  String get recentLoginRequired => 'Por seguridad, inicia sesión de nuevo e inténtalo otra vez.';

  @override
  String get tooManyAttempts => 'Demasiados intentos. Inténtalo más tarde.';

  @override
  String get couldNotUpdatePassword => 'No se pudo actualizar la contraseña';

  @override
  String get noEmailLinked => 'No hay un correo vinculado a esta cuenta.';

  @override
  String get couldNotSendResetEmail => 'No se pudo enviar el correo';

  @override
  String get plans => 'Planes';

  @override
  String get freeTodayProWhenReady => 'Free hoy · Pro cuando estés listo';

  @override
  String get saveSmarterWithAi => 'Ahorra de forma más inteligente con IA';

  @override
  String get unlockProFeaturesDescription => 'Desbloquea consejos de ahorro con IA, análisis de recibos, alertas inteligentes e informes de gastos detallados.';

  @override
  String get bestValue => 'Mejor valor';

  @override
  String get basicDealsBrowsing => 'Exploración básica de ofertas';

  @override
  String get manualExpenseTracking => 'Seguimiento manual de gastos';

  @override
  String get aiPoweredToolsDescription => 'Herramientas con IA para ahorrar más en comestibles.';

  @override
  String get receiptAnalytics => 'Análisis de recibos';

  @override
  String get smartSavingsInsights => 'Consejos inteligentes de ahorro';

  @override
  String get spendingReports => 'Informes de gastos';

  @override
  String get smartAlerts => 'Alertas inteligentes';

  @override
  String get startProSubscription => 'Iniciar suscripción Pro';

  @override
  String get restorePurchases => 'Restaurar compras';

  @override
  String get restoring => 'Restaurando...';

  @override
  String get proSubscriptionActivated => 'Suscripción activada';

  @override
  String get proDemoFallbackActivated => 'Demo Pro activada — no se procesó ningún pago real.';

  @override
  String get couldNotCompletePurchase => 'No se pudo completar la compra. Inténtalo de nuevo.';

  @override
  String get couldNotActivateProDemo => 'No se pudo activar la demo Pro. Inténtalo de nuevo.';

  @override
  String get purchaseRestored => 'Compra restaurada';

  @override
  String get noPurchasesFound => 'No se encontraron compras';

  @override
  String get couldNotRestorePurchases => 'No se pudieron restaurar las compras';

  @override
  String get subscriptionSetup => 'Configuración de suscripción';

  @override
  String get subscriptionSetupPrepared => 'Savingor Pro está preparado para la integración real de compras in-app.';

  @override
  String get subscriptionSetupNotConfigured => 'Las claves del proveedor de pago o los productos de la tienda no están configurados en esta versión.';

  @override
  String get activateProDemoForTesting => 'Activar demo Pro para pruebas';

  @override
  String get demoFallbackActive => 'Demo activa — no se procesó ningún pago real.';

  @override
  String get subscriptionPlanLabel => 'Plan';

  @override
  String pricePerMonth(String price) {
    return '$price / mes';
  }

  @override
  String get active => 'Activa';

  @override
  String get activeDemo => 'Demo activa';

  @override
  String get cancelled => 'Cancelada';

  @override
  String get unknown => 'Desconocido';

  @override
  String get demoMode => 'Modo demo';

  @override
  String get providerNone => 'Ninguno';

  @override
  String get revenueCatLabel => 'RevenueCat';

  @override
  String get subscriptionManagedByStore => 'Tu suscripción la gestiona App Store o Google Play. Puedes cancelarla o modificarla en los ajustes de suscripción de la tienda.';

  @override
  String get manageInAppStoreGooglePlay => 'Gestionar en App Store / Google Play';

  @override
  String get cancelProDemo => 'Cancelar demo Pro';

  @override
  String get noActiveSubscription => 'No hay suscripción activa';

  @override
  String get proDemoCancelled => 'Demo Pro cancelada. Has vuelto al plan Free.';

  @override
  String get couldNotCancelProDemo => 'No se pudo cancelar la demo Pro. Inténtalo de nuevo.';

  @override
  String get couldNotOpenSubscriptionManagement => 'No se pudo abrir la página de gestión de suscripción.';

  @override
  String get managementNotAvailable => 'Gestión no disponible';

  @override
  String get managementUrlUnavailableMessage => 'La URL de gestión de suscripción no está disponible en esta versión de prueba. Para compras de RevenueCat Test Store, restablece el cliente de prueba en el panel de RevenueCat o usa otra cuenta de prueba.';

  @override
  String get paymentProviderNotConfiguredSnack => 'El proveedor de pago no está configurado en esta versión local.';

  @override
  String get purchaseCancelled => 'Compra cancelada';

  @override
  String get purchaseFailed => 'Compra fallida';

  @override
  String get productUnavailable => 'Producto no disponible';

  @override
  String get purchaseNotActiveYet => 'Compra completada pero Pro aún no está activo. Prueba Restaurar compras.';

  @override
  String get networkErrorTryAgain => 'Comprueba tu conexión e inténtalo de nuevo';

  @override
  String get signInToManageSubscription => 'Inicia sesión para gestionar tu suscripción.';

  @override
  String get couldNotUpdateSubscription => 'No se pudo actualizar la suscripción. Inténtalo de nuevo.';

  @override
  String get debugSubscriptionTestingTitle => 'Prueba de suscripción para desarrolladores';

  @override
  String get debugSubscriptionTestingDescription => 'Previsualiza Savingor temporalmente como usuario Free o Pro. Esto no cambia la suscripción real.';

  @override
  String get debugSubscriptionUseReal => 'Usar suscripción real';

  @override
  String get debugSubscriptionTestAsFree => 'Probar como Free';

  @override
  String get debugSubscriptionTestAsPro => 'Probar como Pro';

  @override
  String get debugSubscriptionOverrideFree => 'Anulación de plan (desarrollador): Free';

  @override
  String get debugSubscriptionOverridePro => 'Anulación de plan (desarrollador): Pro';

  @override
  String get proFeatureBasketOptimizerDescription => 'Compara tu cesta entre tiendas y encuentra formas más inteligentes de gastar menos.';

  @override
  String get proFeatureBasketBenefitOptimizeAcrossStores => 'Optimiza la cesta de compras en tiendas cercanas';

  @override
  String get proFeatureBasketBenefitCompareTotals => 'Compara totales estimados de la cesta';

  @override
  String get proFeatureBasketBenefitEconomicalCombination => 'Encuentra una combinación de tiendas más económica';

  @override
  String get proFeatureBasketBenefitReduceSpending => 'Reduce gastos innecesarios en comestibles';

  @override
  String get proFeatureSavingsAnalyticsDescription => 'Comprende tus tendencias de ahorro, patrones de gasto y recomendaciones personalizadas.';

  @override
  String get proFeatureAnalyticsBenefitDeeperTrends => 'Consulta tendencias de ahorro más profundas';

  @override
  String get proFeatureAnalyticsBenefitComparePeriods => 'Compara periodos de gasto';

  @override
  String get proFeatureAnalyticsBenefitTrackSavings => 'Sigue los ahorros estimados';

  @override
  String get proFeatureAnalyticsBenefitAdvancedRecommendations => 'Recibe recomendaciones avanzadas';

  @override
  String get proFeatureProductPriceInsightsDescription => 'Sigue el historial de precios de productos y obtén consejos de compra más inteligentes de tus recibos.';

  @override
  String get proFeaturePriceInsightsBenefitHistory => 'Consulta el historial de precios del producto';

  @override
  String get proFeaturePriceInsightsBenefitCompareStores => 'Compara precios recientes en tiendas';

  @override
  String get proFeaturePriceInsightsBenefitBuyingAdvice => 'Recibe consejos de compra';

  @override
  String get proFeaturePriceInsightsBenefitPurchaseTiming => 'Identifica el mejor momento para comprar';

  @override
  String get proFeatureSavingsOpportunitiesDescription => 'Descubre acciones de ahorro personalizadas basadas en tu historial de compras y recibos.';

  @override
  String get proFeatureOpportunitiesBenefitPersonalized => 'Encuentra formas personalizadas de ahorrar';

  @override
  String get proFeatureOpportunitiesBenefitPrioritize => 'Prioriza acciones de alto valor';

  @override
  String get proFeatureOpportunitiesBenefitReceiptHistory => 'Usa insights de recibos e historial de compras';

  @override
  String get proFeatureOpportunitiesBenefitBetterChoices => 'Descubre mejores tiendas y productos';

  @override
  String get savingorPro => 'Savingor Pro';

  @override
  String get plansHeroTitle => 'Elige tu plan Savingor';

  @override
  String get plansHeroSubtitle => 'Empieza gratis con herramientas esenciales. Actualiza a Pro cuando quieras inteligencia avanzada de ahorro.';

  @override
  String get planFreeSubtitle => 'Herramientas esenciales para controlar el gasto en comida y empezar a ahorrar.';

  @override
  String get planProSubtitle => 'Automatización avanzada e inteligencia personalizada de ahorro.';

  @override
  String get planFreePrice => 'CAD \$0';

  @override
  String get planProPricePerMonth => 'CAD \$14.99 / mes';

  @override
  String get upgradeToSavingorPro => 'Actualizar a Savingor Pro';

  @override
  String get planComparisonTitle => 'Comparar planes';

  @override
  String get planIncludedFeaturesTitle => 'Funciones incluidas';

  @override
  String get planProActiveFeaturesTitle => 'Funciones Pro activas';

  @override
  String get planProComingSoonFeaturesTitle => 'Funciones Pro futuras';

  @override
  String get planColumnFree => 'Free';

  @override
  String get planColumnPro => 'Pro';

  @override
  String get planAvailabilityIncluded => 'Incluido';

  @override
  String get planAvailabilityLocked => 'Bloqueado';

  @override
  String get planAvailabilityUnlimited => 'Ilimitado';

  @override
  String get planAvailabilityThreeScansPerMonth => '3 al mes';

  @override
  String get planFeatureGroceryDashboard => 'Panel de gasto en comida';

  @override
  String get planFeatureNearbyStoreMap => 'Mapa de tiendas cercanas';

  @override
  String get planFeatureShoppingLists => 'Listas de compra';

  @override
  String get planFeatureManualExpenseTracking => 'Seguimiento manual de gastos';

  @override
  String get planFeatureThreeReceiptScansPerMonth => '3 escaneos de recibos al mes';

  @override
  String get planFeatureBasicReceiptExpenseHistory => 'Historial básico de recibos y gastos';

  @override
  String get planFeatureBasicSavingsOpportunities => 'Oportunidades básicas de ahorro';

  @override
  String get planFeatureBasicProductPriceInsights => 'Insights básicos de precios de productos';

  @override
  String get planFeatureAppSettings => 'Idioma, tema, región y moneda';

  @override
  String get planFeatureUnlimitedReceiptScanning => 'Escaneo ilimitado de recibos';

  @override
  String get planFeatureBasketOptimizer => 'Optimizador de cesta';

  @override
  String get planFeatureAdvancedSavingsAnalytics => 'Analítica avanzada de ahorro';

  @override
  String get planFeatureSmartPriceDropAlerts => 'Alertas inteligentes de bajada de precio';

  @override
  String get planFeatureAdvancedSpendingReports => 'Informes avanzados de gasto';

  @override
  String get planCompareReceiptScans => 'Escaneos de recibos';

  @override
  String get planCompareBasicSavingsOpportunities => 'Oportunidades básicas de ahorro';

  @override
  String get planCompareBasicProductPriceInsights => 'Insights básicos de precios de productos';
}
