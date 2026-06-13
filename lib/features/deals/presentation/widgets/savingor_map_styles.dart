/// Subtle dark map style for Google Maps — tiles only; markers/logic unchanged.
abstract final class SavingorMapStyles {
  static const String dark = '''
[
  {"elementType": "geometry", "stylers": [{"color": "#1a2220"}]},
  {"elementType": "labels.text.fill", "stylers": [{"color": "#9aa9a2"}]},
  {"elementType": "labels.text.stroke", "stylers": [{"color": "#121916"}]},
  {"featureType": "administrative", "elementType": "geometry", "stylers": [{"color": "#28322e"}]},
  {"featureType": "poi", "elementType": "labels.text.fill", "stylers": [{"color": "#6b7a73"}]},
  {"featureType": "poi.park", "elementType": "geometry", "stylers": [{"color": "#1e2a24"}]},
  {"featureType": "road", "elementType": "geometry", "stylers": [{"color": "#28322e"}]},
  {"featureType": "road", "elementType": "geometry.stroke", "stylers": [{"color": "#212a27"}]},
  {"featureType": "road.highway", "elementType": "geometry", "stylers": [{"color": "#2e3a35"}]},
  {"featureType": "road.highway", "elementType": "geometry.stroke", "stylers": [{"color": "#1a2220"}]},
  {"featureType": "transit", "elementType": "geometry", "stylers": [{"color": "#212a27"}]},
  {"featureType": "water", "elementType": "geometry", "stylers": [{"color": "#0f1513"}]}
]
''';
}
