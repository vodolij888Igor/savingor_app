import 'package:flutter/material.dart';
import 'package:savingor_app/core/i18n/app_strings.dart';

class ReceiptScannerScreen extends StatelessWidget {
  const ReceiptScannerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final t = AppStrings.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(t.receiptScanner),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.receipt_long, size: 72, color: Colors.grey),
              const SizedBox(height: 12),
              Text(t.receiptScanner,
                  style: const TextStyle(
                      fontSize: 18, fontWeight: FontWeight.w600)),
              const SizedBox(height: 8),
              const Text('Use this screen to scan receipts and extract offers.',
                  textAlign: TextAlign.center),
            ],
          ),
        ),
      ),
    );
  }
}
