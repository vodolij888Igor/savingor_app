import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:savingor_app/core/app_state.dart';
import 'package:savingor_app/core/theme/savingor_design_system.dart';
import 'package:savingor_app/features/receipts/domain/models/receipt_item.dart';
import 'package:savingor_app/features/receipts/domain/models/receipt_source.dart';
import 'package:savingor_app/features/scanner/domain/models/smart_receipt.dart';
import 'package:savingor_app/features/scanner/presentation/screens/create_receipt_screen.dart';
import 'package:savingor_app/l10n/app_localizations.dart';

void main() {
  testWidgets('AI draft stays editable and is not automatically saved',
      (WidgetTester tester) async {
    tester.view.physicalSize = const Size(1000, 3000);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    SharedPreferences.setMockInitialValues(<String, Object>{});
    final AppState appState = AppState(await SharedPreferences.getInstance());
    appState.hydrateFromDisk();

    await tester.pumpWidget(
      AppStateProvider(
        notifier: appState,
        child: MaterialApp(
          theme: SavingorTheme.lightTheme,
          localizationsDelegates: const <LocalizationsDelegate<dynamic>>[
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: const <Locale>[Locale('en')],
          home: CreateReceiptScreen(
            initialStoreName: 'Market',
            initialDate: DateTime(2026, 6, 12),
            initialCurrency: 'CAD',
            initialCategory: 'Grocery',
            initialSubtotal: 10,
            initialTax: 1.30,
            initialTotal: 11.30,
            initialSource: ReceiptSource.gallery,
            initialOcrRawText: 'Market\nMilk 4.50',
            initialItems: const <ReceiptItem>[
              ReceiptItem(
                id: 'smart_receipt_item_0',
                name: 'Milk',
                quantity: 2,
                unit: 'L',
                unitPrice: 2.25,
                totalPrice: 4.50,
                category: 'Dairy',
              ),
            ],
            smartReceiptProvenance: SmartReceiptProvenance.aiEnhanced,
            smartReceiptWarningCodes: const <String>['UNCERTAIN_TAX'],
          ),
        ),
      ),
    );
    await tester.pump();

    expect(find.text('AI enhanced'), findsOneWidget);
    expect(_text(tester, 'Store name'), 'Market');
    expect(_text(tester, 'Currency code'), 'CAD');
    expect(_text(tester, 'Purchase date'), '2026-06-12');
    expect(_text(tester, 'Subtotal (optional)'), '10.00');
    expect(_text(tester, 'Tax (optional)'), '1.30');
    expect(_text(tester, 'Receipt total'), '11.30');
    expect(_text(tester, 'Item name'), 'Milk');
    expect(_text(tester, 'Qty'), '2');
    expect(_text(tester, 'Unit (optional)'), 'L');
    expect(_text(tester, 'Unit price (optional)'), '2.25');
    expect(_text(tester, 'Line total'), '4.50');
    expect(_text(tester, 'Category (optional)'), 'Dairy');

    await tester.enterText(_field('Store name'), 'Edited Market');
    await tester.enterText(_field('Currency code'), 'USD');
    await tester.enterText(_field('Item name'), 'Edited Milk');
    await tester.enterText(_field('Unit (optional)'), 'each');
    await tester.enterText(_field('Line total'), '5.25');

    expect(_text(tester, 'Store name'), 'Edited Market');
    expect(_text(tester, 'Currency code'), 'USD');
    expect(_text(tester, 'Item name'), 'Edited Milk');
    expect(_text(tester, 'Unit (optional)'), 'each');
    expect(_text(tester, 'Line total'), '5.25');
    expect(tester.takeException(), isNull);
    // There is deliberately no ReceiptProvider in this widget tree. Pumping
    // and editing succeeds because persistence is reached only by Save.
  });
}

Finder _field(String label) {
  return find.widgetWithText(TextFormField, label);
}

String _text(WidgetTester tester, String label) {
  return tester.widget<TextFormField>(_field(label)).controller!.text;
}
