import 'package:flutter/material.dart';
import 'package:savingor_app/core/i18n/app_strings.dart';

import 'package:savingor_app/features/deals/domain/models/deal.dart';
import 'package:savingor_app/features/deals/data/favorites_store.dart';

class DealDetailsScreen extends StatelessWidget {
  final Deal deal;

  const DealDetailsScreen({super.key, required this.deal});

  @override
  Widget build(BuildContext context) {
    final favorites = FavoritesProvider.of(context);
    final isSaved = favorites.isSaved(deal.id);
    final t = AppStrings.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(t.dealDetails),
        actions: [
          IconButton(
            icon: Icon(isSaved ? Icons.favorite : Icons.favorite_border),
            onPressed: () {
              favorites.toggle(deal.id);
            },
            tooltip: isSaved ? t.removeSaved : t.saveDeal,
          ),
        ],
      ),
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
            Text('${t.dealDetails}:',
                style: const TextStyle(fontWeight: FontWeight.w600)),
            const SizedBox(height: 4),
            const Text('TBD (placeholder)'),
            const SizedBox(height: 12),
            const Text('Notes:', style: TextStyle(fontWeight: FontWeight.w600)),
            const SizedBox(height: 4),
            const Text('No additional notes.'),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: () {
                favorites.toggle(deal.id);
              },
              icon: Icon(isSaved ? Icons.delete : Icons.favorite_border),
              label: Text(isSaved ? t.removeSaved : t.saveDeal),
            ),
          ],
        ),
      ),
    );
  }
}
