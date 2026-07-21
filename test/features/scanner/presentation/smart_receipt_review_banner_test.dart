import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:savingor_app/features/scanner/domain/models/smart_receipt.dart';
import 'package:savingor_app/features/scanner/presentation/widgets/smart_receipt_review_banner.dart';
import 'package:savingor_app/l10n/app_localizations.dart';

void main() {
  testWidgets('shows AI provenance and readable grouped warnings',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      _app(
        const SmartReceiptReviewBanner(
          provenance: SmartReceiptProvenance.aiEnhanced,
          warningCodes: <String>[
            'UNCERTAIN_TAX',
            'SUBTOTAL_TAX_TOTAL_MISMATCH',
            'IDENTIFIERS_REDACTED',
          ],
        ),
      ),
    );

    expect(find.text('AI enhanced'), findsOneWidget);
    expect(find.text('Review before saving'), findsOneWidget);
    expect(find.textContaining('receipt details were unclear'), findsOneWidget);
    expect(find.textContaining('totals may not add up'), findsOneWidget);
    expect(find.textContaining('Private identifiers'), findsOneWidget);
    expect(find.textContaining('UNCERTAIN_TAX'), findsNothing);
  });

  testWidgets('shows friendly local quota fallback',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      _app(
        const SmartReceiptReviewBanner(
          provenance: SmartReceiptProvenance.localParser,
          fallbackReason: SmartReceiptFailureKind.quota,
        ),
      ),
    );

    expect(find.text('Local parser'), findsOneWidget);
    expect(find.textContaining('demo limit was reached'), findsOneWidget);
  });
}

Widget _app(Widget child) {
  return MaterialApp(
    localizationsDelegates: const <LocalizationsDelegate<dynamic>>[
      AppLocalizations.delegate,
      GlobalMaterialLocalizations.delegate,
      GlobalWidgetsLocalizations.delegate,
      GlobalCupertinoLocalizations.delegate,
    ],
    supportedLocales: const <Locale>[Locale('en')],
    home: Scaffold(body: child),
  );
}
