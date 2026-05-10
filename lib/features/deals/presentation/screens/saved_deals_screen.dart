import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:savingor_app/core/i18n/app_strings.dart';
import 'package:savingor_app/features/deals/data/mock_deals.dart';
import 'package:savingor_app/features/deals/domain/models/deal.dart';
import 'package:savingor_app/features/deals/data/favorites_store.dart';

class SavedDealsScreen extends StatelessWidget {
  const SavedDealsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final store = FavoritesProvider.of(context);
    final saved =
        mockDeals.where((d) => store.savedIds.contains(d.id)).toList();
    final t = AppStrings.of(context);

    return Scaffold(
      appBar: AppBar(title: Text(t.saved)),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: saved.isEmpty
            ? Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.favorite_border,
                        size: 72, color: Colors.grey),
                    const SizedBox(height: 12),
                    Text(t.noSavedDeals,
                        style: const TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w600)),
                    const SizedBox(height: 8),
                    Text(t.savedHint),
                  ],
                ),
              )
            : ListView.separated(
                itemCount: saved.length,
                separatorBuilder: (_, __) => const SizedBox(height: 12),
                itemBuilder: (context, index) {
                  final Deal deal = saved[index];
                  final isSaved = store.isSaved(deal.id);
                  return Card(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                    child: ListTile(
                      title: Text(deal.title,
                          style: const TextStyle(fontWeight: FontWeight.w600)),
                      subtitle: Text(deal.store),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text('\$${deal.price.toStringAsFixed(2)}',
                              style:
                                  const TextStyle(fontWeight: FontWeight.w600)),
                          const SizedBox(width: 8),
                          IconButton(
                            icon: Icon(isSaved
                                ? Icons.favorite
                                : Icons.favorite_border),
                            color: isSaved
                                ? Theme.of(context).colorScheme.primary
                                : null,
                            onPressed: () => store.toggle(deal.id),
                            tooltip: isSaved ? t.removeSaved : t.saveDeal,
                          ),
                        ],
                      ),
                      onTap: () => context.go('/deals/${deal.id}'),
                    ),
                  );
                },
              ),
      ),
    );
  }
}
