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
        child: Text('Receipt Scanner Screen'),
      ),
    );
  }
}
