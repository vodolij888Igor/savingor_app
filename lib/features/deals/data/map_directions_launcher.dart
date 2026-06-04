import 'dart:io' show Platform;

import 'package:url_launcher/url_launcher.dart';

import 'package:savingor_app/features/deals/domain/models/nearby_store.dart';
import 'package:savingor_app/features/deals/domain/models/user_location_coords.dart';

/// Opens external map apps for turn-by-turn or destination navigation.
class MapDirectionsLauncher {
  const MapDirectionsLauncher();

  Future<bool> openDirections(
    NearbyStore store, {
    UserLocationCoords? origin,
  }) async {
    final List<Uri> candidates = _candidateUris(store, origin: origin);

    for (final Uri uri in candidates) {
      if (await _tryLaunch(uri)) {
        return true;
      }
    }

    return false;
  }

  List<Uri> _candidateUris(
    NearbyStore store, {
    UserLocationCoords? origin,
  }) {
    final String? originQuery = origin != null
        ? '${origin.latitude},${origin.longitude}'
        : null;

    if (store.hasCoordinates) {
      final double lat = store.latitude!;
      final double lng = store.longitude!;
      final String destQuery = '$lat,$lng';
      final String encodedLabel = Uri.encodeComponent(store.name);

      if (originQuery != null) {
        if (_isIOS) {
          return <Uri>[
            Uri.parse(
              'https://maps.apple.com/?saddr=$originQuery&daddr=$destQuery',
            ),
            Uri.parse(
              'https://www.google.com/maps/dir/?api=1'
              '&origin=$originQuery&destination=$destQuery',
            ),
          ];
        }

        return <Uri>[
          Uri.parse(
            'https://www.google.com/maps/dir/?api=1'
            '&origin=$originQuery&destination=$destQuery',
          ),
          Uri.parse('geo:0,0?q=$destQuery($encodedLabel)'),
        ];
      }

      if (_isIOS) {
        return <Uri>[
          Uri.parse('https://maps.apple.com/?daddr=$destQuery&q=$encodedLabel'),
          Uri.parse(
            'https://www.google.com/maps/dir/?api=1&destination=$destQuery',
          ),
        ];
      }

      if (_isAndroid) {
        return <Uri>[
          Uri.parse('google.navigation:q=$destQuery'),
          Uri.parse('geo:0,0?q=$destQuery($encodedLabel)'),
          Uri.parse(
            'https://www.google.com/maps/dir/?api=1&destination=$destQuery',
          ),
        ];
      }

      return <Uri>[
        Uri.parse(
          'https://www.google.com/maps/dir/?api=1&destination=$destQuery',
        ),
      ];
    }

    final String destQuery =
        Uri.encodeComponent(store.address ?? store.name);

    if (originQuery != null) {
      if (_isIOS) {
        return <Uri>[
          Uri.parse(
            'https://maps.apple.com/?saddr=$originQuery&daddr=$destQuery',
          ),
          Uri.parse(
            'https://www.google.com/maps/dir/?api=1'
            '&origin=$originQuery&destination=$destQuery',
          ),
        ];
      }

      return <Uri>[
        Uri.parse(
          'https://www.google.com/maps/dir/?api=1'
          '&origin=$originQuery&destination=$destQuery',
        ),
      ];
    }

    if (_isIOS) {
      return <Uri>[
        Uri.parse('https://maps.apple.com/?daddr=$destQuery'),
        Uri.parse('https://www.google.com/maps/dir/?api=1&destination=$destQuery'),
      ];
    }

    return <Uri>[
      Uri.parse('geo:0,0?q=$destQuery'),
      Uri.parse('https://www.google.com/maps/dir/?api=1&destination=$destQuery'),
    ];
  }

  Future<bool> _tryLaunch(Uri uri) async {
    try {
      final bool canLaunch = await canLaunchUrl(uri);
      if (!canLaunch) return false;

      return launchUrl(uri, mode: LaunchMode.externalApplication);
    } catch (_) {
      return false;
    }
  }

  bool get _isAndroid {
    try {
      return Platform.isAndroid;
    } catch (_) {
      return false;
    }
  }

  bool get _isIOS {
    try {
      return Platform.isIOS;
    } catch (_) {
      return false;
    }
  }
}
