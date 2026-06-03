/// Current device coordinates from GPS / location services.
class UserLocationCoords {
  const UserLocationCoords({
    required this.latitude,
    required this.longitude,
  });

  final double latitude;
  final double longitude;

  String get latitudeLabel => latitude.toStringAsFixed(5);

  String get longitudeLabel => longitude.toStringAsFixed(5);
}
