import 'package:flutter/material.dart';

import 'package:savingor_app/core/theme/savingor_design_system.dart';
import 'package:savingor_app/features/deals/data/user_location_service.dart';
import 'package:savingor_app/features/deals/domain/models/user_location_coords.dart';
import 'package:savingor_app/features/deals/presentation/widgets/nearby_radius_selector.dart';

/// Location status + search radius controls for the nearby stores screen.
class NearbyLocationSection extends StatelessWidget {
  const NearbyLocationSection({
    super.key,
    required this.locationStatus,
    required this.coords,
    required this.locationMessage,
    required this.isLoadingLocation,
    this.locationDebug,
    required this.selectedRadiusKm,
    required this.radiusOptionsKm,
    required this.onUseMyLocation,
    required this.onRetryLocation,
    required this.onRadiusSelected,
  });

  final UserLocationAccessStatus locationStatus;
  final UserLocationCoords? coords;
  final String? locationMessage;
  final bool isLoadingLocation;
  final UserLocationDebugInfo? locationDebug;
  final double selectedRadiusKm;
  final List<double> radiusOptionsKm;
  final VoidCallback onUseMyLocation;
  final VoidCallback onRetryLocation;
  final ValueChanged<double> onRadiusSelected;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFF3F4F3)),
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          _buildLocationHeader(),
          const SizedBox(height: 10),
          _buildLocationBody(context),
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 14),
            child: Divider(height: 1, color: Color(0xFFEEF1EF)),
          ),
          const Text(
            'Search radius',
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w700,
              color: SavingorColors.darkGreen,
            ),
          ),
          const SizedBox(height: 10),
          NearbyRadiusSelector(
            selectedRadiusKm: selectedRadiusKm,
            radiusOptionsKm: radiusOptionsKm,
            onRadiusSelected: onRadiusSelected,
          ),
        ],
      ),
    );
  }

  Widget _buildLocationHeader() {
    return Row(
      children: <Widget>[
        Icon(
          Icons.my_location_rounded,
          size: 20,
          color: SavingorColors.primaryStroke.withOpacity(0.85),
        ),
        const SizedBox(width: 8),
        const Expanded(
          child: Text(
            'Your location',
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w700,
              color: SavingorColors.darkGreen,
            ),
          ),
        ),
        if (locationStatus == UserLocationAccessStatus.granted)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: SavingorColors.lightGreen.withOpacity(0.45),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Text(
              'Active',
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w700,
                color: SavingorColors.primaryStroke,
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildLocationBody(BuildContext context) {
    if (isLoadingLocation) {
      return Row(
        children: <Widget>[
          SizedBox(
            width: 18,
            height: 18,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              color: SavingorColors.primaryStroke.withOpacity(0.85),
            ),
          ),
          const SizedBox(width: 12),
          Text(
            'Checking location...',
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w500,
              color: SavingorColors.textSecondary.withOpacity(0.95),
            ),
          ),
        ],
      );
    }

    if (locationStatus == UserLocationAccessStatus.granted && coords != null) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          const Text(
            'Location detected',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w700,
              color: SavingorColors.primaryStroke,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Lat: ${coords!.latitudeLabel}, Lng: ${coords!.longitudeLabel}',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: SavingorColors.textSecondary.withOpacity(0.9),
            ),
          ),
          if (locationDebug?.usedLastKnownPosition == true) ...<Widget>[
            const SizedBox(height: 4),
            Text(
              'Using last known position.',
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w500,
                color: SavingorColors.textSecondary.withOpacity(0.75),
              ),
            ),
          ],
        ],
      );
    }

    if (locationStatus == UserLocationAccessStatus.permissionDenied ||
        locationStatus == UserLocationAccessStatus.serviceDisabled ||
        locationStatus == UserLocationAccessStatus.failed) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Text(
            locationMessage ?? 'Could not access your location.',
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w500,
              color: SavingorColors.darkGreen.withOpacity(0.82),
              height: 1.35,
            ),
          ),
          if (locationDebug != null) ...<Widget>[
            const SizedBox(height: 8),
            _buildDebugInfo(locationDebug!),
          ],
          const SizedBox(height: 10),
          Align(
            alignment: Alignment.centerLeft,
            child: OutlinedButton(
              onPressed: onRetryLocation,
              style: OutlinedButton.styleFrom(
                foregroundColor: SavingorColors.primaryStroke,
                side: BorderSide(
                  color: SavingorColors.primaryStroke.withOpacity(0.35),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                textStyle: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                ),
              ),
              child: const Text('Retry'),
            ),
          ),
        ],
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        Text(
          'Enable location to prepare for nearby store search.',
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w500,
            color: SavingorColors.textSecondary.withOpacity(0.95),
            height: 1.35,
          ),
        ),
        const SizedBox(height: 10),
        Align(
          alignment: Alignment.centerLeft,
          child: FilledButton.icon(
            onPressed: onUseMyLocation,
            icon: const Icon(Icons.location_searching_rounded, size: 18),
            label: const Text('Use my location'),
            style: FilledButton.styleFrom(
              backgroundColor: SavingorColors.primaryStroke,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              textStyle: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDebugInfo(UserLocationDebugInfo debug) {
    final List<String> lines = <String>[
      if (debug.serviceEnabled != null)
        'service enabled: ${debug.serviceEnabled}',
      if (debug.permissionLabel != null) 'permission: ${debug.permissionLabel}',
      if (debug.lastError != null) 'last error: ${debug.lastError}',
    ];

    if (lines.isEmpty) return const SizedBox.shrink();

    return Text(
      lines.join('\n'),
      style: TextStyle(
        fontSize: 11,
        fontWeight: FontWeight.w500,
        color: SavingorColors.textSecondary.withOpacity(0.78),
        height: 1.35,
        fontFamily: 'monospace',
      ),
    );
  }
}
