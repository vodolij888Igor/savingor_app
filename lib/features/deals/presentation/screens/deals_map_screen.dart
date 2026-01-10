import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:savingor_app/features/deals/domain/models/deal.dart';
import 'package:savingor_app/features/deals/data/mock_deals.dart';
import 'package:savingor_app/features/deals/data/favorites_store.dart';
import 'package:savingor_app/core/i18n/app_strings.dart';

class DealsMapScreen extends StatefulWidget {
  const DealsMapScreen({super.key});

  @override
  State<DealsMapScreen> createState() => _DealsMapScreenState();
}

class _DealsMapScreenState extends State<DealsMapScreen> {
  final TextEditingController _controller = TextEditingController();
  String query = '';
  final Set<String> _selectedStores = <String>{};
  double _maxPriceFilter = 0.0;
  double _currentPriceFilter = 0.0;
  int _sortMode = 0;

  @override
  void initState() {
    super.initState();
    if (mockDeals.isNotEmpty) {
      _maxPriceFilter =
          mockDeals.map((d) => d.price).reduce((a, b) => a > b ? a : b);
      _currentPriceFilter = _maxPriceFilter;
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  List<Deal> get filteredDeals {
    final q = query.trim().toLowerCase();

    var list = mockDeals.where((d) {
      final matchesQuery = q.isEmpty ||
          d.title.toLowerCase().contains(q) ||
          d.store.toLowerCase().contains(q);
      final matchesStore =
          _selectedStores.isEmpty || _selectedStores.contains(d.store);
      final matchesPrice = d.price <= _currentPriceFilter;
      return matchesQuery && matchesStore && matchesPrice;
    }).toList();

    if (_sortMode == 1) {
      list.sort((a, b) => a.price.compareTo(b.price));
    } else if (_sortMode == 2) {
      list.sort((a, b) => b.price.compareTo(a.price));
    }

    return list;
  }

  @override
  Widget build(BuildContext context) {
    final deals = filteredDeals;
    final t = AppStrings.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(t.dealsMap),
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: () => _openFilterSheet(context),
            tooltip: t.filter,
          ),
        ],
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
                hintText: t.searchHint,
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
            Row(
              children: [
                Text(t.dealsCount(filteredDeals.length),
                    style: const TextStyle(fontWeight: FontWeight.w600)),
                const Spacer(),
                if (_selectedStores.isNotEmpty)
                  Text('${t.stores}: ${_selectedStores.length}',
                      style: const TextStyle(color: Colors.black54)),
                if (_selectedStores.isNotEmpty) const SizedBox(width: 12),
                Text(
                    '${t.maxPrice} \$${_currentPriceFilter.toStringAsFixed(2)}',
                    style: const TextStyle(color: Colors.black54)),
              ],
            ),
            const SizedBox(height: 12),
            Expanded(
              child: ListView.separated(
                itemCount: deals.length,
                separatorBuilder: (_, __) => const SizedBox(height: 12),
                itemBuilder: (context, index) {
                  final deal = deals[index];
                  final favorites = FavoritesProvider.of(context);
                  final isSaved = favorites.isSaved(deal.id);

                  return Card(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                    child: InkWell(
                      onTap: () => context.go('/deals/${deal.id}'),
                      borderRadius: BorderRadius.circular(12),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 12),
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
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text('\$${deal.price.toStringAsFixed(2)}',
                                    style: const TextStyle(
                                        fontWeight: FontWeight.w600)),
                                IconButton(
                                  icon: Icon(isSaved
                                      ? Icons.bookmark
                                      : Icons.bookmark_border),
                                  color: isSaved
                                      ? Theme.of(context).colorScheme.primary
                                      : null,
                                  onPressed: () {
                                    favorites.toggle(deal.id);
                                  },
                                  tooltip: isSaved ? t.removeSaved : t.saveDeal,
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            if (deals.isEmpty)
              Padding(
                padding: const EdgeInsets.only(top: 20.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.search_off, size: 64, color: Colors.grey),
                    const SizedBox(height: 8),
                    Text(t.noDealsFound,
                        style: const TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w600)),
                    const SizedBox(height: 6),
                    const Text('Try resetting filters or clearing the search.'),
                    const SizedBox(height: 12),
                    ElevatedButton(
                      onPressed: () => setState(() {
                        query = '';
                        _selectedStores.clear();
                        _currentPriceFilter = _maxPriceFilter;
                        _sortMode = 0;
                        _controller.clear();
                      }),
                      child: Text(t.resetFilters),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }

  void _openFilterSheet(BuildContext context) {
    final stores = mockDeals.map((d) => d.store).toSet().toList();
    double tempPrice = _currentPriceFilter;
    final tempSelected = Set<String>.from(_selectedStores);
    int tempSort = _sortMode;

    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      builder: (ctx) {
        return StatefulBuilder(builder: (context, setModalState) {
          return Padding(
            padding:
                EdgeInsets.only(bottom: MediaQuery.of(ctx).viewInsets.bottom),
            child: Container(
              padding: const EdgeInsets.all(16),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(AppStrings.of(context).filtersTitle,
                      style: const TextStyle(
                          fontSize: 18, fontWeight: FontWeight.w600)),
                  const SizedBox(height: 12),
                  Text(AppStrings.of(context).stores,
                      style: const TextStyle(fontWeight: FontWeight.w600)),
                  Wrap(
                    spacing: 8,
                    children: stores.map((s) {
                      final selected = tempSelected.contains(s);
                      return FilterChip(
                        label: Text(s),
                        selected: selected,
                        onSelected: (v) => setModalState(() =>
                            v ? tempSelected.add(s) : tempSelected.remove(s)),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 12),
                  Text(
                      '${AppStrings.of(context).maxPrice}: \$${tempPrice.toStringAsFixed(2)}'),
                  Slider(
                    value: tempPrice,
                    min: 0,
                    max: _maxPriceFilter,
                    onChanged: (v) => setModalState(() => tempPrice = v),
                  ),
                  const SizedBox(height: 8),
                  Text(AppStrings.of(context).sort,
                      style: const TextStyle(fontWeight: FontWeight.w600)),
                  Row(
                    children: [
                      Radio<int>(
                          value: 0,
                          groupValue: tempSort,
                          onChanged: (v) =>
                              setModalState(() => tempSort = v ?? 0)),
                      Text(AppStrings.of(context).none),
                      const SizedBox(width: 12),
                      Radio<int>(
                          value: 1,
                          groupValue: tempSort,
                          onChanged: (v) =>
                              setModalState(() => tempSort = v ?? 0)),
                      Text(AppStrings.of(context).priceLowHigh),
                      const SizedBox(width: 12),
                      Radio<int>(
                          value: 2,
                          groupValue: tempSort,
                          onChanged: (v) =>
                              setModalState(() => tempSort = v ?? 0)),
                      Text(AppStrings.of(context).priceHighLow),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton(
                        onPressed: () => setModalState(() {
                          tempSelected.clear();
                          tempPrice = _maxPriceFilter;
                          tempSort = 0;
                        }),
                        child: Text(AppStrings.of(context).resetFilters),
                      ),
                      const SizedBox(width: 8),
                      ElevatedButton(
                        onPressed: () {
                          setState(() {
                            _selectedStores
                              ..clear()
                              ..addAll(tempSelected);
                            _currentPriceFilter = tempPrice;
                            _sortMode = tempSort;
                          });
                          Navigator.of(ctx).pop();
                        },
                        child: const Text('Apply'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        });
      },
    );
  }
}
