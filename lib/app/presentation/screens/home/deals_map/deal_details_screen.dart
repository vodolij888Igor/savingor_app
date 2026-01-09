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
            Text('Store: ${deal.store}', style: const TextStyle(fontSize: 16)),
            const SizedBox(height: 8),
            Text('Price: \$${deal.price.toStringAsFixed(2)}',
                style:
                    const TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
            const SizedBox(height: 16),
            const Text('Valid until: ',
                style: TextStyle(fontWeight: FontWeight.w600)),
            const SizedBox(height: 4),
            const Text('TBD (placeholder)'),
            const SizedBox(height: 12),
            const Text('Notes:', style: TextStyle(fontWeight: FontWeight.w600)),
            const SizedBox(height: 4),
            const Text('No additional notes.'),
          ],
        ),
      ),
    );
  }
}
