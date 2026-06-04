import 'package:savingor_app/features/deals/domain/models/user_location_coords.dart';

/// How the active nearby-store origin was chosen.
enum NearbyLocationSource {
  gps,
  manual,
}

/// Active routing/search origin for the Nearby Stores screen.
class NearbyActiveLocation {
  const NearbyActiveLocation({
    required this.displayName,
    required this.latitude,
    required this.longitude,
    required this.source,
    this.regionId,
  });

  final String displayName;
  final double latitude;
  final double longitude;
  final NearbyLocationSource source;
  final String? regionId;

  bool get hasCoordinates => latitude != 0 || longitude != 0;

  UserLocationCoords get coords => UserLocationCoords(
        latitude: latitude,
        longitude: longitude,
      );
}

/// User-picked city/area when GPS is unavailable or inaccurate.
class ManualLocationSelection {
  const ManualLocationSelection({
    required this.displayName,
    this.coords,
    this.regionId,
  });

  final String displayName;
  final UserLocationCoords? coords;
  final String? regionId;

  bool get hasCoordinates => coords != null;

  NearbyActiveLocation? toActiveLocation() {
    if (!hasCoordinates) {
      return NearbyActiveLocation(
        displayName: displayName,
        latitude: 0,
        longitude: 0,
        source: NearbyLocationSource.manual,
        regionId: regionId,
      );
    }

    return NearbyActiveLocation(
      displayName: displayName,
      latitude: coords!.latitude,
      longitude: coords!.longitude,
      source: NearbyLocationSource.manual,
      regionId: regionId,
    );
  }
}

/// Known Alberta cities for development / manual fallback.
class KnownCityLocation {
  const KnownCityLocation({
    required this.regionId,
    required this.matchKeys,
    required this.displayName,
    required this.latitude,
    required this.longitude,
  });

  final String regionId;
  final List<String> matchKeys;
  final String displayName;
  final double latitude;
  final double longitude;

  UserLocationCoords get coords => UserLocationCoords(
        latitude: latitude,
        longitude: longitude,
      );

  static const List<KnownCityLocation> catalog = <KnownCityLocation>[
    KnownCityLocation(
      regionId: 'calgary',
      matchKeys: <String>['calgary'],
      displayName: 'Calgary, AB',
      latitude: 51.0447,
      longitude: -114.0719,
    ),
    KnownCityLocation(
      regionId: 'cochrane',
      matchKeys: <String>['cochrane'],
      displayName: 'Cochrane, AB',
      latitude: 51.1890,
      longitude: -114.4670,
    ),
    KnownCityLocation(
      regionId: 'edmonton',
      matchKeys: <String>['edmonton'],
      displayName: 'Edmonton, AB',
      latitude: 53.5461,
      longitude: -113.4938,
    ),
  ];

  static String? regionIdForDisplayName(String displayName) {
    for (final KnownCityLocation city in catalog) {
      if (city.displayName == displayName) {
        return city.regionId;
      }
    }
    return null;
  }
}

/// Resolves manual city input to a display label and optional coordinates.
abstract final class ManualLocationResolver {
  static ManualLocationSelection? resolve(String input) {
    final String trimmed = input.trim();
    if (trimmed.isEmpty) return null;

    final String normalized = trimmed.toLowerCase();

    for (final KnownCityLocation city in KnownCityLocation.catalog) {
      for (final String key in city.matchKeys) {
        if (normalized == key || normalized.startsWith('$key,')) {
          return ManualLocationSelection(
            displayName: city.displayName,
            coords: city.coords,
            regionId: city.regionId,
          );
        }
      }
    }

    return ManualLocationSelection(
      displayName: trimmed,
      coords: null,
      regionId: null,
    );
  }
}
