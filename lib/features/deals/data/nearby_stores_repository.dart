import 'package:flutter/foundation.dart';

import 'package:savingor_app/features/deals/data/google_places_config.dart';
import 'package:savingor_app/features/deals/data/google_places_nearby_service.dart';
import 'package:savingor_app/features/deals/data/local_nearby_store_repository.dart';
import 'package:savingor_app/features/deals/domain/models/nearby_store.dart';
import 'package:savingor_app/features/deals/domain/models/nearby_store_data_source.dart';

/// Result of loading nearby stores (Places with mock fallback).
class NearbyStoresLoadResult {
  const NearbyStoresLoadResult({
    required this.stores,
    required this.dataSource,
    required this.usedPlacesFallback,
    required this.attemptedPlaces,
  });

  final List<NearbyStore> stores;
  final NearbyStoreDataSource dataSource;
  final bool usedPlacesFallback;
  final bool attemptedPlaces;

  bool get isRealData => dataSource == NearbyStoreDataSource.places;
}

/// Tries Google Places first, then falls back to local mock stores.
class NearbyStoresRepository {
  NearbyStoresRepository({
    GooglePlacesNearbyService? placesService,
    LocalNearbyStoreRepository? mockRepository,
  })  : _placesService = placesService ?? GooglePlacesNearbyService(),
        _mockRepository = mockRepository ?? const LocalNearbyStoreRepository();

  final GooglePlacesNearbyService _placesService;
  final LocalNearbyStoreRepository _mockRepository;

  List<NearbyStore> getMockStores(
    double radiusKm, {
    String? regionId,
  }) {
    return _mockRepository.getStoresWithinRadius(
      radiusKm,
      regionId: regionId,
    );
  }

  Future<NearbyStoresLoadResult> loadStores({
    required double radiusKm,
    String? regionId,
    double? originLatitude,
    double? originLongitude,
  }) async {
    final bool hasApiKey = GooglePlacesConfig.hasApiKey;
    final bool hasOrigin = originLatitude != null && originLongitude != null;
    final bool canSearchPlaces = hasApiKey && hasOrigin;

    if (canSearchPlaces) {
      final List<NearbyStore> placesStores =
          await _placesService.searchNearbyGroceryStores(
        latitude: originLatitude,
        longitude: originLongitude,
        radiusKm: radiusKm,
      );

      if (placesStores.isNotEmpty) {
        debugPrint('NearbyStoresRepository: using live Google Places stores');
        return NearbyStoresLoadResult(
          stores: placesStores,
          dataSource: NearbyStoreDataSource.places,
          usedPlacesFallback: false,
          attemptedPlaces: true,
        );
      }

      debugPrint(
        'NearbyStoresRepository: using mock fallback because: '
        'Google Places returned no usable stores',
      );
      return NearbyStoresLoadResult(
        stores: getMockStores(radiusKm, regionId: regionId),
        dataSource: NearbyStoreDataSource.mock,
        usedPlacesFallback: true,
        attemptedPlaces: true,
      );
    }

    final String fallbackReason = !hasApiKey
        ? 'GOOGLE_PLACES_API_KEY is empty'
        : 'active location coordinates are missing';
    debugPrint(
      'NearbyStoresRepository: using mock fallback because: $fallbackReason',
    );

    return NearbyStoresLoadResult(
      stores: getMockStores(radiusKm, regionId: regionId),
      dataSource: NearbyStoreDataSource.mock,
      usedPlacesFallback: false,
      attemptedPlaces: false,
    );
  }
}
