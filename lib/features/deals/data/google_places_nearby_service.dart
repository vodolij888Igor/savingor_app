import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

import 'package:savingor_app/features/deals/data/geo_distance.dart';
import 'package:savingor_app/features/deals/data/google_places_config.dart';
import 'package:savingor_app/features/deals/domain/models/nearby_store.dart';
import 'package:savingor_app/features/deals/domain/models/nearby_store_data_source.dart';

/// Google Places API (New) nearby search for grocery stores.
class GooglePlacesNearbyService {
  GooglePlacesNearbyService({http.Client? httpClient})
      : _httpClient = httpClient ?? http.Client();

  final http.Client _httpClient;

  static const String _searchNearbyUrl =
      'https://places.googleapis.com/v1/places:searchNearby';

  static const String _fieldMask =
      'places.id,places.displayName,places.formattedAddress,places.location,places.types';

  bool get isConfigured => GooglePlacesConfig.hasApiKey;

  /// Returns empty list when unconfigured, on error, or no usable results.
  Future<List<NearbyStore>> searchNearbyGroceryStores({
    required double latitude,
    required double longitude,
    required double radiusKm,
  }) async {
    debugPrint(
      'GooglePlaces: API key present: ${GooglePlacesConfig.hasApiKey}',
    );

    if (!isConfigured) {
      debugPrint('GooglePlaces: skipping search because API key is empty');
      return const <NearbyStore>[];
    }

    try {
      final double radiusMeters = (radiusKm * 1000).clamp(500, 50000);

      debugPrint(
        'GooglePlaces: searching nearby stores '
        'lat=$latitude, lng=$longitude, radius=${radiusKm}km (${radiusMeters}m)',
      );

      final http.Response response = await _httpClient.post(
        Uri.parse(_searchNearbyUrl),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'X-Goog-Api-Key': GooglePlacesConfig.apiKey,
          'X-Goog-FieldMask': _fieldMask,
        },
        body: jsonEncode(<String, dynamic>{
          'includedTypes': <String>['supermarket', 'grocery_store'],
          'maxResultCount': 20,
          'locationRestriction': <String, dynamic>{
            'circle': <String, dynamic>{
              'center': <String, dynamic>{
                'latitude': latitude,
                'longitude': longitude,
              },
              'radius': radiusMeters,
            },
          },
        }),
      );

      debugPrint('GooglePlaces: statusCode=${response.statusCode}');
      debugPrint(
        'GooglePlaces: response body preview=${_responsePreview(response.body)}',
      );

      if (response.statusCode < 200 || response.statusCode >= 300) {
        debugPrint(
          'GooglePlaces: non-success HTTP status, returning empty list',
        );
        return const <NearbyStore>[];
      }

      final Map<String, dynamic> decoded =
          jsonDecode(response.body) as Map<String, dynamic>;
      final List<dynamic>? places = decoded['places'] as List<dynamic>?;
      if (places == null || places.isEmpty) {
        debugPrint('GooglePlaces: parsed places count=0 (none in response)');
        return const <NearbyStore>[];
      }

      final List<NearbyStore> stores = <NearbyStore>[];
      final Set<String> seenPlaceIds = <String>{};
      for (final dynamic rawPlace in places) {
        final NearbyStore? store = _mapPlace(
          rawPlace as Map<String, dynamic>,
          originLat: latitude,
          originLng: longitude,
        );
        if (store != null && seenPlaceIds.add(store.id)) {
          stores.add(store);
        }
      }

      debugPrint('GooglePlaces: parsed places count=${stores.length}');

      stores.sort(
        (NearbyStore a, NearbyStore b) =>
            a.distanceKm.compareTo(b.distanceKm),
      );

      return stores;
    } catch (error, stackTrace) {
      debugPrint('GooglePlaces: request failed with error: $error');
      debugPrint('GooglePlaces: stackTrace=$stackTrace');
      return const <NearbyStore>[];
    }
  }

  static String _responsePreview(String body) {
    if (body.length <= 500) return body;
    return '${body.substring(0, 500)}...';
  }

  NearbyStore? _mapPlace(
    Map<String, dynamic> place, {
    required double originLat,
    required double originLng,
  }) {
    final String? id = place['id'] as String?;
    final Map<String, dynamic>? displayName =
        place['displayName'] as Map<String, dynamic>?;
    final String? name = displayName?['text'] as String?;
    final Map<String, dynamic>? location =
        place['location'] as Map<String, dynamic>?;
    final double? lat = (location?['latitude'] as num?)?.toDouble();
    final double? lng = (location?['longitude'] as num?)?.toDouble();

    if (id == null || name == null || lat == null || lng == null) {
      return null;
    }

    final List<String> types = (place['types'] as List<dynamic>?)
            ?.map((dynamic type) => type.toString())
            .toList(growable: false) ??
        const <String>[];

    final double distanceKm = GeoDistance.kmBetween(
      originLat: originLat,
      originLng: originLng,
      destLat: lat,
      destLng: lng,
    );

    return NearbyStore(
      id: id,
      name: name,
      category: _categoryFromTypes(types),
      distanceKm: distanceKm,
      latitude: lat,
      longitude: lng,
      address: place['formattedAddress'] as String?,
      statusText: 'Listed on Google Places',
      dataSource: NearbyStoreDataSource.places,
    );
  }

  NearbyStoreCategory _categoryFromTypes(List<String> types) {
    if (types.contains('wholesale_club') || types.contains('warehouse_store')) {
      return NearbyStoreCategory.wholesale;
    }
    if (types.contains('supermarket')) {
      return NearbyStoreCategory.supermarket;
    }
    return NearbyStoreCategory.grocery;
  }
}
