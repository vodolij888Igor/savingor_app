import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../domain/models/deal.dart';
import '../../../../data/mock/mock_deals.dart';

class DealsMapScreen extends StatefulWidget {
  const DealsMapScreen({super.key});

  @override
  State<DealsMapScreen> createState() => _DealsMapScreenState();
}

class _DealsMapScreenState extends State<DealsMapScreen> {
  final TextEditingController _controller = TextEditingController();
  String query = '';

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  List<Deal> get filteredDeals {
    final q = query.trim().toLowerCase();
    if (q.isEmpty) return mockDeals;

    return mockDeals.where((d) {
      return d.title.toLowerCase().contains(q) ||
          d.store.toLowerCase().contains(q);
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final deals = filteredDeals;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Deals Map'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: _controller,
              autofocus: false,
              textInputAction: TextInputAction.search,
              onChanged: (value) => setState(() => query = value),
              onSubmitted: (_) => FocusScope.of(context).unfocus(),
              decoration: InputDecoration(
                hintText: 'Search deals or stores...',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: query.isEmpty
                    ? null
                    : IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          setState(() => query = '');
                          _controller.clear();
                          FocusScope.of(context).unfocus();
                        },
                      ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
            const SizedBox(height: 12),
            Expanded(
              child: ListView.separated(
                itemCount: deals.length,
                separatorBuilder: (_, __) => const SizedBox(height: 12),
                itemBuilder: (context, index) {
                  final deal = deals[index];
                  return Card(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                    child: InkWell(
                      onTap: () => context.go('/deals/${deal.id}'),
                      borderRadius: BorderRadius.circular(12),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 12,
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(deal.title,
                                      style: const TextStyle(
                                          fontWeight: FontWeight.w600)),
                                  const SizedBox(height: 4),
                                  Text(deal.store,
                                      style: const TextStyle(
                                          color: Colors.black54)),
                                ],
                              ),
                            ),
                            Text('\$${deal.price.toStringAsFixed(2)}',
                                style: const TextStyle(
                                    fontWeight: FontWeight.w600)),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
