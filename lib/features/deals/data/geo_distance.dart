import 'dart:math' as math;

/// Approximate distance between two coordinates in kilometres.
abstract final class GeoDistance {
  static double kmBetween({
    required double originLat,
    required double originLng,
    required double destLat,
    required double destLng,
  }) {
    const double earthRadiusKm = 6371.0;
    final double dLat = _toRadians(destLat - originLat);
    final double dLng = _toRadians(destLng - originLng);
    final double a = math.sin(dLat / 2) * math.sin(dLat / 2) +
        math.cos(_toRadians(originLat)) *
            math.cos(_toRadians(destLat)) *
            math.sin(dLng / 2) *
            math.sin(dLng / 2);
    final double c = 2 * math.atan2(math.sqrt(a), math.sqrt(1 - a));
    return earthRadiusKm * c;
  }

  static double _toRadians(double degrees) => degrees * math.pi / 180.0;
}
