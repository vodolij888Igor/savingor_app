import 'package:flutter/material.dart';

class ReceiptScannerScreen extends StatelessWidget {
  const ReceiptScannerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Receipt Scanner'),
      ),
      body: const Center(
        child: Padding(
          padding: EdgeInsets.all(24.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.receipt_long, size: 72, color: Colors.grey),
              SizedBox(height: 12),
              Text('Receipt Scanner',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
              SizedBox(height: 8),
              Text('Use this screen to scan receipts and extract offers.',
                  textAlign: TextAlign.center),
            ],
          ),
        ),
      ),
    );
  }
}
