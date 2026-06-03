/// Grocery store category for nearby store listings.
enum NearbyStoreCategory {
  grocery('Grocery'),
  supermarket('Supermarket'),
  wholesale('Wholesale');

  const NearbyStoreCategory(this.label);

  final String label;
}

/// Nearby grocery store — replace with Places API results later.
class NearbyStore {
  const NearbyStore({
    required this.id,
    required this.name,
    required this.category,
    required this.distanceKm,
    this.statusText = 'Nearby store',
  });

  final String id;
  final String name;
  final NearbyStoreCategory category;
  final double distanceKm;
  final String statusText;

  String get distanceLabel {
    if (distanceKm < 1) {
      return '${(distanceKm * 1000).round()} m';
    }
    return '${distanceKm.toStringAsFixed(1)} km';
  }
}
