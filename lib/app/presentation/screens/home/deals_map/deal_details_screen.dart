import 'package:flutter/material.dart';
import '../../../../domain/models/deal.dart';

class DealDetailsScreen extends StatelessWidget {
  final Deal deal;

  const DealDetailsScreen({super.key, required this.deal});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Deal Details')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(deal.title, style: Theme.of(context).textTheme.headlineSmall),
            const SizedBox(height: 8),
            Text('Store: ${deal.store}'),
            const SizedBox(height: 8),
            Text('Price: \$${deal.price.toStringAsFixed(2)}'),
          ],
        ),
      ),
    );
  }
}
