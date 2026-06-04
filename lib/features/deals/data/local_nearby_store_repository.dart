import 'package:savingor_app/features/deals/domain/models/nearby_store.dart';

/// Contract for nearby store data — swap for Places API later.
abstract class NearbyStoreRepository {
  List<NearbyStore> getStoresWithinRadius(
    double radiusKm, {
    String? regionId,
  });
}

/// Local sample stores until Google Places integration.
class LocalNearbyStoreRepository implements NearbyStoreRepository {
  const LocalNearbyStoreRepository();

  static const List<NearbyStore> _calgaryStores = <NearbyStore>[
    NearbyStore(
      id: 'calgary-walmart',
      name: 'Walmart Supercentre',
      category: NearbyStoreCategory.supermarket,
      distanceKm: 1.2,
      latitude: 50.9738,
      longitude: -114.0712,
      address: '8180 Macleod Tr SE, Calgary, AB',
    ),
    NearbyStore(
      id: 'calgary-costco',
      name: 'Costco',
      category: NearbyStoreCategory.wholesale,
      distanceKm: 3.8,
      latitude: 50.9979,
      longitude: -114.0428,
      address: '99 Heritage Gate SE, Calgary, AB',
    ),
    NearbyStore(
      id: 'calgary-freshco',
      name: 'FreshCo',
      category: NearbyStoreCategory.grocery,
      distanceKm: 2.1,
      latitude: 51.0374,
      longitude: -113.9852,
      address: '3330 17 Ave SE, Calgary, AB',
    ),
    NearbyStore(
      id: 'calgary-superstore',
      name: 'Real Canadian Superstore',
      category: NearbyStoreCategory.supermarket,
      distanceKm: 4.5,
      latitude: 50.9336,
      longitude: -113.9595,
      address: '4310 130 Ave SE, Calgary, AB',
    ),
    NearbyStore(
      id: 'calgary-no-frills',
      name: 'No Frills',
      category: NearbyStoreCategory.grocery,
      distanceKm: 5.2,
      latitude: 51.0424,
      longitude: -113.9938,
      address: '515 28 St SE, Calgary, AB',
    ),
  ];

  static const List<NearbyStore> _cochraneStores = <NearbyStore>[
    NearbyStore(
      id: 'cochrane-walmart',
      name: 'Walmart Supercentre',
      category: NearbyStoreCategory.supermarket,
      distanceKm: 1.4,
      latitude: 51.1875,
      longitude: -114.4678,
      address: '100 Grande Blvd, Cochrane, AB',
    ),
    NearbyStore(
      id: 'cochrane-save-on',
      name: 'Save-On-Foods',
      category: NearbyStoreCategory.supermarket,
      distanceKm: 1.8,
      latitude: 51.1910,
      longitude: -114.4720,
      address: '100 Sunset Dr, Cochrane, AB',
    ),
    NearbyStore(
      id: 'cochrane-safeway',
      name: 'Safeway',
      category: NearbyStoreCategory.grocery,
      distanceKm: 2.3,
      latitude: 51.1895,
      longitude: -114.4605,
      address: '510 Centre Ave, Cochrane, AB',
    ),
    NearbyStore(
      id: 'cochrane-no-frills',
      name: 'No Frills',
      category: NearbyStoreCategory.grocery,
      distanceKm: 3.1,
      latitude: 51.1858,
      longitude: -114.4550,
      address: '20 River Heights Dr, Cochrane, AB',
    ),
  ];

  static const List<NearbyStore> _edmontonStores = <NearbyStore>[
    NearbyStore(
      id: 'edmonton-walmart',
      name: 'Walmart Supercentre',
      category: NearbyStoreCategory.supermarket,
      distanceKm: 1.5,
      latitude: 53.4975,
      longitude: -113.4930,
      address: '775 Tamarack Way NW, Edmonton, AB',
    ),
    NearbyStore(
      id: 'edmonton-costco',
      name: 'Costco',
      category: NearbyStoreCategory.wholesale,
      distanceKm: 3.6,
      latitude: 53.4510,
      longitude: -113.4885,
      address: '12450 149 St NW, Edmonton, AB',
    ),
    NearbyStore(
      id: 'edmonton-superstore',
      name: 'Real Canadian Superstore',
      category: NearbyStoreCategory.supermarket,
      distanceKm: 2.4,
      latitude: 53.5180,
      longitude: -113.5120,
      address: '9910 39 Ave NW, Edmonton, AB',
    ),
    NearbyStore(
      id: 'edmonton-no-frills',
      name: 'No Frills',
      category: NearbyStoreCategory.grocery,
      distanceKm: 4.8,
      latitude: 53.5590,
      longitude: -113.4560,
      address: '9538 76 Ave NW, Edmonton, AB',
    ),
    NearbyStore(
      id: 'edmonton-freshco',
      name: 'FreshCo',
      category: NearbyStoreCategory.grocery,
      distanceKm: 2.9,
      latitude: 53.5320,
      longitude: -113.4780,
      address: '10404 51 Ave NW, Edmonton, AB',
    ),
  ];

  static const Map<String, List<NearbyStore>> _storesByRegion =
      <String, List<NearbyStore>>{
    'calgary': _calgaryStores,
    'cochrane': _cochraneStores,
    'edmonton': _edmontonStores,
  };

  @override
  List<NearbyStore> getStoresWithinRadius(
    double radiusKm, {
    String? regionId,
  }) {
    final List<NearbyStore> stores =
        _storesByRegion[regionId] ?? _calgaryStores;

    return stores
        .where((NearbyStore store) => store.distanceKm <= radiusKm)
        .toList(growable: false);
  }
}
