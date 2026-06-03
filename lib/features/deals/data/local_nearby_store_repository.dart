import 'package:savingor_app/features/deals/domain/models/nearby_store.dart';

/// Contract for nearby store data — swap for Places API later.
abstract class NearbyStoreRepository {
  List<NearbyStore> getStoresWithinRadius(double radiusKm);
}

/// Local sample stores until Google Places integration.
class LocalNearbyStoreRepository implements NearbyStoreRepository {
  const LocalNearbyStoreRepository();

  static const List<NearbyStore> _allStores = <NearbyStore>[
    NearbyStore(
      id: 'walmart',
      name: 'Walmart',
      category: NearbyStoreCategory.supermarket,
      distanceKm: 1.2,
    ),
    NearbyStore(
      id: 'costco',
      name: 'Costco',
      category: NearbyStoreCategory.wholesale,
      distanceKm: 3.8,
    ),
    NearbyStore(
      id: 'freshco',
      name: 'FreshCo',
      category: NearbyStoreCategory.grocery,
      distanceKm: 2.1,
    ),
    NearbyStore(
      id: 'superstore',
      name: 'Real Canadian Superstore',
      category: NearbyStoreCategory.supermarket,
      distanceKm: 4.5,
    ),
    NearbyStore(
      id: 'no-frills',
      name: 'No Frills',
      category: NearbyStoreCategory.grocery,
      distanceKm: 5.2,
    ),
  ];

  @override
  List<NearbyStore> getStoresWithinRadius(double radiusKm) {
    return _allStores
        .where((NearbyStore store) => store.distanceKm <= radiusKm)
        .toList(growable: false);
  }
}
