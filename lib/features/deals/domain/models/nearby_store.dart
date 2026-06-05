import 'package:savingor_app/features/deals/domain/models/nearby_store_data_source.dart';

/// Grocery store category for nearby store listings.
enum NearbyStoreCategory {
  grocery('Grocery'),
  supermarket('Supermarket'),
  wholesale('Wholesale');

  const NearbyStoreCategory(this.label);

  final String label;
}

/// Nearby grocery store from mock data or Google Places.
class NearbyStore {
  const NearbyStore({
    required this.id,
    required this.name,
    required this.category,
    required this.distanceKm,
    this.latitude,
    this.longitude,
    this.address,
    this.statusText = 'Nearby store',
    this.dataSource = NearbyStoreDataSource.mock,
  });

  final String id;
  final String name;
  final NearbyStoreCategory category;
  final double distanceKm;
  final double? latitude;
  final double? longitude;
  final String? address;
  final String statusText;
  final NearbyStoreDataSource dataSource;

  bool get hasCoordinates => latitude != null && longitude != null;

  bool get isRealData => dataSource == NearbyStoreDataSource.places;

  bool get hasAddress => address != null && address!.trim().isNotEmpty;

  String? get displayAddress => hasAddress ? address!.trim() : null;

  String get mapInfoWindowSnippet {
    if (hasAddress) {
      return '$distanceLabel · $address';
    }
    return '$distanceLabel · ${category.label}';
  }

  String get distanceLabel {
    if (distanceKm < 1) {
      return '${(distanceKm * 1000).round()} m';
    }
    return '${distanceKm.toStringAsFixed(1)} km';
  }
}
