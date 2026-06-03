import 'dart:io' show Platform;

import 'package:geolocator/geolocator.dart';

import 'package:savingor_app/features/deals/domain/models/user_location_coords.dart';

/// Result of a location permission / GPS lookup for nearby stores.
enum UserLocationAccessStatus {
  idle,
  loading,
  granted,
  permissionDenied,
  serviceDisabled,
  failed,
}

/// Temporary debug details shown when detection fails (development aid).
class UserLocationDebugInfo {
  const UserLocationDebugInfo({
    this.serviceEnabled,
    this.permissionLabel,
    this.lastError,
    this.usedLastKnownPosition = false,
  });

  final bool? serviceEnabled;
  final String? permissionLabel;
  final String? lastError;
  final bool usedLastKnownPosition;
}

class UserLocationResult {
  const UserLocationResult({
    required this.status,
    this.coords,
    this.message,
    this.debug,
  });

  final UserLocationAccessStatus status;
  final UserLocationCoords? coords;
  final String? message;
  final UserLocationDebugInfo? debug;

  bool get hasCoords => coords != null;
}

/// Wraps [Geolocator] for the nearby stores feature.
class UserLocationService {
  const UserLocationService();

  static const Duration _positionTimeout = Duration(seconds: 15);

  Future<UserLocationResult> requestCurrentLocation() async {
    bool? serviceEnabled;
    String? permissionLabel;
    String? lastError;

    try {
      serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        return UserLocationResult(
          status: UserLocationAccessStatus.serviceDisabled,
          message: 'Location services are turned off.',
          debug: UserLocationDebugInfo(
            serviceEnabled: false,
            permissionLabel: permissionLabel,
          ),
        );
      }

      LocationPermission permission = await Geolocator.checkPermission();
      permissionLabel = _permissionLabel(permission);

      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        permissionLabel = _permissionLabel(permission);
      }

      if (permission == LocationPermission.denied ||
          permission == LocationPermission.deniedForever) {
        return UserLocationResult(
          status: UserLocationAccessStatus.permissionDenied,
          message: 'Location permission denied.',
          debug: UserLocationDebugInfo(
            serviceEnabled: serviceEnabled,
            permissionLabel: permissionLabel,
          ),
        );
      }

      Position? position = await _tryGetCurrentPosition(
        onError: (String error) => lastError = error,
      );

      var usedLastKnown = false;
      if (position == null) {
        try {
          position = await Geolocator.getLastKnownPosition();
          usedLastKnown = position != null;
        } catch (error) {
          lastError = error.toString();
        }
      }

      if (position != null) {
        return UserLocationResult(
          status: UserLocationAccessStatus.granted,
          coords: UserLocationCoords(
            latitude: position.latitude,
            longitude: position.longitude,
          ),
          debug: UserLocationDebugInfo(
            serviceEnabled: serviceEnabled,
            permissionLabel: permissionLabel,
            usedLastKnownPosition: usedLastKnown,
          ),
        );
      }

      return UserLocationResult(
        status: UserLocationAccessStatus.failed,
        message: 'Could not detect your location. Please try again.',
        debug: UserLocationDebugInfo(
          serviceEnabled: serviceEnabled,
          permissionLabel: permissionLabel,
          lastError: lastError ?? 'No GPS fix or last known position.',
        ),
      );
    } on LocationServiceDisabledException catch (error) {
      return UserLocationResult(
        status: UserLocationAccessStatus.serviceDisabled,
        message: 'Location services are turned off.',
        debug: UserLocationDebugInfo(
          serviceEnabled: false,
          permissionLabel: permissionLabel,
          lastError: error.toString(),
        ),
      );
    } on PermissionDeniedException catch (error) {
      return UserLocationResult(
        status: UserLocationAccessStatus.permissionDenied,
        message: 'Location permission denied.',
        debug: UserLocationDebugInfo(
          serviceEnabled: serviceEnabled,
          permissionLabel: permissionLabel,
          lastError: error.toString(),
        ),
      );
    } catch (error) {
      return UserLocationResult(
        status: UserLocationAccessStatus.failed,
        message: 'Could not detect your location. Please try again.',
        debug: UserLocationDebugInfo(
          serviceEnabled: serviceEnabled,
          permissionLabel: permissionLabel,
          lastError: error.toString(),
        ),
      );
    }
  }

  Future<Position?> _tryGetCurrentPosition({
    required void Function(String error) onError,
  }) async {
    Position? position = await _getCurrentPosition(
      forceLocationManager: false,
      onError: onError,
    );

    if (position != null) return position;

    if (_isAndroid) {
      return _getCurrentPosition(
        forceLocationManager: true,
        onError: onError,
      );
    }

    return null;
  }

  Future<Position?> _getCurrentPosition({
    required bool forceLocationManager,
    required void Function(String error) onError,
  }) async {
    try {
      if (_isAndroid) {
        return await Geolocator.getCurrentPosition(
          locationSettings: AndroidSettings(
            accuracy: LocationAccuracy.high,
            timeLimit: _positionTimeout,
            forceLocationManager: forceLocationManager,
          ),
        );
      }

      return await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.high,
          timeLimit: _positionTimeout,
        ),
      );
    } catch (error) {
      onError(error.toString());
      return null;
    }
  }

  static bool get _isAndroid {
    try {
      return Platform.isAndroid;
    } catch (_) {
      return false;
    }
  }

  static String _permissionLabel(LocationPermission permission) {
    switch (permission) {
      case LocationPermission.always:
        return 'always';
      case LocationPermission.whileInUse:
        return 'whileInUse';
      case LocationPermission.denied:
        return 'denied';
      case LocationPermission.deniedForever:
        return 'deniedForever';
      case LocationPermission.unableToDetermine:
        return 'unableToDetermine';
    }
  }
}
