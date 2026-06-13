import 'dart:math' as math;

import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'package:savingor_app/core/i18n/map_l10n.dart';
import 'package:savingor_app/core/theme/savingor_design_system.dart';
import 'package:savingor_app/features/deals/domain/models/nearby_store.dart';
import 'package:savingor_app/l10n/app_localizations.dart';

/// Interactive Google Map for nearby stores and the active user location.
class NearbyStoresMapCard extends StatefulWidget {
  const NearbyStoresMapCard({
    super.key,
    this.userLatitude,
    this.userLongitude,
    this.userLocationLabel,
    required this.radiusKm,
    required this.stores,
    this.onStoreMarkerTap,
  });

  final double? userLatitude;
  final double? userLongitude;
  final String? userLocationLabel;
  final double radiusKm;
  final List<NearbyStore> stores;
  final ValueChanged<NearbyStore>? onStoreMarkerTap;

  @override
  State<NearbyStoresMapCard> createState() => _NearbyStoresMapCardState();
}

class _NearbyStoresMapCardState extends State<NearbyStoresMapCard> {
  static const double _mapPaddingPx = 40;

  GoogleMapController? _mapController;
  double? _lastCameraLatitude;
  double? _lastCameraLongitude;
  double? _lastCameraRadiusKm;
  String? _lastCameraStoreSignature;

  static final Set<Factory<OneSequenceGestureRecognizer>> _mapGestureRecognizers =
      <Factory<OneSequenceGestureRecognizer>>{
    Factory<OneSequenceGestureRecognizer>(
      () => EagerGestureRecognizer(),
    ),
  };

  @override
  void didUpdateWidget(NearbyStoresMapCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    final bool locationChanged =
        oldWidget.userLatitude != widget.userLatitude ||
            oldWidget.userLongitude != widget.userLongitude;
    final bool radiusChanged = oldWidget.radiusKm != widget.radiusKm;
    final bool storesChanged =
        _storesSignature(oldWidget.stores) !=
            _storesSignature(widget.stores);

    if (locationChanged || radiusChanged || storesChanged) {
      _updateCamera(force: true);
    }
  }

  @override
  void dispose() {
    _mapController?.dispose();
    super.dispose();
  }

  static double _mapHeightFor(BuildContext context) {
    final double screenHeight = MediaQuery.sizeOf(context).height;
    if (screenHeight < 640) {
      return 260;
    }
    if (screenHeight < 780) {
      return 288;
    }
    return 300;
  }

  LatLng? get _userPosition {
    final double? latitude = widget.userLatitude;
    final double? longitude = widget.userLongitude;
    if (latitude == null || longitude == null) {
      return null;
    }
    return LatLng(latitude, longitude);
  }

  static String _storesSignature(List<NearbyStore> stores) {
    if (stores.isEmpty) {
      return '';
    }
    return stores.map((NearbyStore store) => store.id).join('|');
  }

  /// Maps search radius to a fallback zoom when bounds fitting is unavailable.
  static double zoomForRadiusKm(double radiusKm) {
    if (radiusKm <= 5) {
      return 13.25;
    }
    if (radiusKm <= 10) {
      return 12.3;
    }
    if (radiusKm <= 20) {
      return 11.25;
    }
    return 10.75;
  }

  CameraPosition get _initialCameraPosition {
    final LatLng? userPosition = _userPosition;
    if (userPosition != null) {
      return CameraPosition(
        target: userPosition,
        zoom: zoomForRadiusKm(widget.radiusKm),
      );
    }
    return const CameraPosition(
      target: LatLng(51.0447, -114.0719),
      zoom: 10,
    );
  }

  Set<Marker> _buildMarkers(BuildContext context) {
    final AppLocalizations l10n = AppLocalizations.of(context);
    final Set<Marker> markers = <Marker>{};
    final LatLng? userPosition = _userPosition;

    if (userPosition != null) {
      markers.add(
        Marker(
          markerId: const MarkerId('user_location'),
          position: userPosition,
          icon: BitmapDescriptor.defaultMarkerWithHue(
            BitmapDescriptor.hueGreen,
          ),
          infoWindow: InfoWindow(
            title: widget.userLocationLabel?.isNotEmpty == true
                ? widget.userLocationLabel!
                : l10n.mapYourLocation,
          ),
        ),
      );
    }

    for (final NearbyStore store in widget.stores) {
      if (!store.hasCoordinates) {
        continue;
      }
      markers.add(
        Marker(
          markerId: MarkerId('store_${store.id}'),
          position: LatLng(store.latitude!, store.longitude!),
          icon: BitmapDescriptor.defaultMarkerWithHue(
            BitmapDescriptor.hueRed,
          ),
          infoWindow: InfoWindow(
            title: store.name,
            snippet: MapL10n.markerInfoWindowSnippet(context, store),
          ),
          onTap: () => _handleStoreMarkerTap(store),
        ),
      );
    }

    return markers;
  }

  Future<void> _handleStoreMarkerTap(NearbyStore store) async {
    await _focusOnStore(store);
    widget.onStoreMarkerTap?.call(store);
  }

  Future<void> _focusOnStore(NearbyStore store) async {
    final GoogleMapController? controller = _mapController;
    if (controller == null || !store.hasCoordinates) {
      return;
    }

    final double zoom = await controller.getZoomLevel();
    await controller.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(
          target: LatLng(store.latitude!, store.longitude!),
          zoom: zoom,
        ),
      ),
    );
  }

  Set<Circle> _buildCircles() {
    final LatLng? userPosition = _userPosition;
    if (userPosition == null) {
      return const <Circle>{};
    }

    return <Circle>{
      Circle(
        circleId: const CircleId('search_radius'),
        center: userPosition,
        radius: widget.radiusKm * 1000,
        fillColor: SavingorColors.primaryStroke.withOpacity(0.16),
        strokeColor: SavingorColors.primaryStroke.withOpacity(0.78),
        strokeWidth: 3,
      ),
    };
  }

  LatLngBounds? _computeSearchBounds(LatLng userPosition) {
    double minLat = userPosition.latitude;
    double maxLat = userPosition.latitude;
    double minLng = userPosition.longitude;
    double maxLng = userPosition.longitude;

    void include(LatLng point) {
      minLat = math.min(minLat, point.latitude);
      maxLat = math.max(maxLat, point.latitude);
      minLng = math.min(minLng, point.longitude);
      maxLng = math.max(maxLng, point.longitude);
    }

    for (final NearbyStore store in widget.stores) {
      if (!store.hasCoordinates) {
        continue;
      }
      include(LatLng(store.latitude!, store.longitude!));
    }

    final double radiusMeters = widget.radiusKm * 1000;
    final double latDelta = radiusMeters / 111320;
    final double lngDelta = radiusMeters /
        (111320 * math.cos(userPosition.latitude * math.pi / 180));

    include(LatLng(userPosition.latitude + latDelta, userPosition.longitude));
    include(LatLng(userPosition.latitude - latDelta, userPosition.longitude));
    include(LatLng(userPosition.latitude, userPosition.longitude + lngDelta));
    include(LatLng(userPosition.latitude, userPosition.longitude - lngDelta));

    const double minSpan = 0.002;
    if ((maxLat - minLat).abs() < minSpan) {
      final double midLat = (minLat + maxLat) / 2;
      minLat = midLat - minSpan / 2;
      maxLat = midLat + minSpan / 2;
    }
    if ((maxLng - minLng).abs() < minSpan) {
      final double midLng = (minLng + maxLng) / 2;
      minLng = midLng - minSpan / 2;
      maxLng = midLng + minSpan / 2;
    }

    return LatLngBounds(
      southwest: LatLng(minLat, minLng),
      northeast: LatLng(maxLat, maxLng),
    );
  }

  bool _shouldSkipCameraUpdate(LatLng userPosition, {required bool force}) {
    if (force) {
      return false;
    }
    return _lastCameraLatitude == userPosition.latitude &&
        _lastCameraLongitude == userPosition.longitude &&
        _lastCameraRadiusKm == widget.radiusKm &&
        _lastCameraStoreSignature == _storesSignature(widget.stores);
  }

  Future<void> _updateCamera({bool force = false}) async {
    final GoogleMapController? controller = _mapController;
    final LatLng? userPosition = _userPosition;
    if (controller == null || userPosition == null) {
      return;
    }
    if (_shouldSkipCameraUpdate(userPosition, force: force)) {
      return;
    }

    _lastCameraLatitude = userPosition.latitude;
    _lastCameraLongitude = userPosition.longitude;
    _lastCameraRadiusKm = widget.radiusKm;
    _lastCameraStoreSignature = _storesSignature(widget.stores);

    final LatLngBounds bounds = _computeSearchBounds(userPosition)!;
    try {
      await controller.animateCamera(
        CameraUpdate.newLatLngBounds(bounds, _mapPaddingPx),
      );
      return;
    } catch (_) {
      // Bounds can be invalid on some platforms; fall back to radius zoom.
    }

    await controller.animateCamera(
      CameraUpdate.newLatLngZoom(
        userPosition,
        zoomForRadiusKm(widget.radiusKm),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final double mapHeight = _mapHeightFor(context);

    return Container(
      height: mapHeight,
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: SavingorColors.primaryStroke.withOpacity(0.12),
        ),
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: _userPosition == null
          ? _buildLocationPrompt(context)
          : GoogleMap(
              initialCameraPosition: _initialCameraPosition,
              markers: _buildMarkers(context),
              circles: _buildCircles(),
              gestureRecognizers: _mapGestureRecognizers,
              onMapCreated: (GoogleMapController controller) {
                _mapController = controller;
                _updateCamera(force: true);
              },
              myLocationButtonEnabled: false,
              zoomControlsEnabled: false,
              mapToolbarEnabled: false,
              compassEnabled: false,
              tiltGesturesEnabled: false,
              rotateGesturesEnabled: false,
              scrollGesturesEnabled: true,
              zoomGesturesEnabled: true,
            ),
    );
  }

  Widget _buildLocationPrompt(BuildContext context) {
    final AppLocalizations l10n = AppLocalizations.of(context);

    return Stack(
      fit: StackFit.expand,
      children: <Widget>[
        const DecoratedBox(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: <Color>[
                Color(0xFFECFDF5),
                Color(0xFFD1FAE5),
                Color(0xFFE6FFFA),
              ],
            ),
          ),
        ),
        CustomPaint(
          painter: _MapPatternPainter(
            color: SavingorAccentColors.map.withOpacity(0.08),
          ),
        ),
        Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Container(
                  width: 56,
                  height: 56,
                  decoration: SavingorSurfaces.accentIconBlock(
                    accent: SavingorAccentColors.map,
                    radius: 16,
                  ),
                  child: const Icon(
                    Icons.map_outlined,
                    size: 28,
                    color: SavingorAccentColors.map,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  l10n.mapSetYourLocation,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                    color: SavingorColors.darkGreen,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  l10n.mapSetLocationGpsOrCity,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: SavingorColors.textSecondary.withOpacity(0.95),
                    height: 1.35,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _MapPatternPainter extends CustomPainter {
  _MapPatternPainter({required this.color});

  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final Paint dotPaint = Paint()..color = color;
    const double step = 28;
    for (double x = 0; x < size.width; x += step) {
      for (double y = 0; y < size.height; y += step) {
        canvas.drawCircle(Offset(x + 6, y + 6), 1.5, dotPaint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant _MapPatternPainter oldDelegate) {
    return oldDelegate.color != color;
  }
}
