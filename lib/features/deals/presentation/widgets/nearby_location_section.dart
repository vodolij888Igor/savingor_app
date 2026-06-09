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
    this.manualLocationLabel,
    required this.selectedRadiusKm,
    required this.radiusOptionsKm,
    required this.onUseMyLocation,
    required this.onRetryLocation,
    required this.onEnterCityManually,
    required this.onRadiusSelected,
  });

  final UserLocationAccessStatus locationStatus;
  final UserLocationCoords? coords;
  final String? locationMessage;
  final bool isLoadingLocation;
  final UserLocationDebugInfo? locationDebug;
  final String? manualLocationLabel;
  final double selectedRadiusKm;
  final List<double> radiusOptionsKm;
  final VoidCallback onUseMyLocation;
  final VoidCallback onRetryLocation;
  final VoidCallback onEnterCityManually;
  final ValueChanged<double> onRadiusSelected;

  bool get _isManualSelected =>
      manualLocationLabel != null && manualLocationLabel!.isNotEmpty;

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: <Widget>[
        Container(
          padding: const EdgeInsets.all(18),
          decoration: SavingorSurfaces.locationCard(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              _buildLocationHeader(),
              const SizedBox(height: 12),
              _buildLocationBody(context),
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 14),
                child: Divider(height: 1, color: SavingorColors.border),
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
        ),
        Positioned(
          top: -6,
          right: 14,
          child: Icon(
            Icons.location_on_rounded,
            size: 28,
            color: SavingorAccentColors.map.withOpacity(0.18),
          ),
        ),
      ],
    );
  }

  Widget _buildLocationHeader() {
    final bool isActive = _isManualSelected ||
        locationStatus == UserLocationAccessStatus.granted;

    return Row(
      children: <Widget>[
        Container(
          width: 40,
          height: 40,
          decoration: SavingorSurfaces.accentIconBlock(
            accent: SavingorAccentColors.map,
            radius: 12,
          ),
          child: const Icon(
            Icons.pin_drop_rounded,
            size: 22,
            color: SavingorAccentColors.map,
          ),
        ),
        const SizedBox(width: 12),
        const Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                'Your location',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w800,
                  color: SavingorColors.darkGreen,
                ),
              ),
              SizedBox(height: 2),
              Text(
                'Find grocery stores near you',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: SavingorColors.textSecondary,
                ),
              ),
            ],
          ),
        ),
        if (isActive)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: SavingorColors.primaryGreen.withOpacity(0.15),
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
            style: SavingorAppTextStyles.bodySecondary(fontSize: 13),
          ),
        ],
      );
    }

    if (_isManualSelected) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          const Text(
            'Location selected',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w700,
              color: SavingorColors.primaryStroke,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            manualLocationLabel!,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: SavingorColors.textPrimary,
            ),
          ),
          const SizedBox(height: 12),
          _buildLocationActions(showUseMyLocation: true),
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
            'Ready to search nearby grocery stores.',
            style: SavingorAppTextStyles.bodySecondary(fontSize: 13),
          ),
          const SizedBox(height: 12),
          _buildLocationActions(showUseMyLocation: true),
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
            style: SavingorAppTextStyles.bodySecondary(fontSize: 13),
          ),
          const SizedBox(height: 12),
          _buildLocationActions(showUseMyLocation: true, primaryLabel: 'Retry'),
        ],
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        Text(
          'Enable location to find grocery stores near you.',
          style: SavingorAppTextStyles.bodySecondary(fontSize: 13),
        ),
        const SizedBox(height: 12),
        _buildLocationActions(showUseMyLocation: true),
      ],
    );
  }

  Widget _buildLocationActions({
    required bool showUseMyLocation,
    String primaryLabel = 'Use my location',
  }) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      crossAxisAlignment: WrapCrossAlignment.center,
      children: <Widget>[
        if (showUseMyLocation)
          FilledButton.icon(
            onPressed:
                primaryLabel == 'Retry' ? onRetryLocation : onUseMyLocation,
            icon: Icon(
              primaryLabel == 'Retry'
                  ? Icons.refresh_rounded
                  : Icons.location_searching_rounded,
              size: 18,
            ),
            label: Text(primaryLabel),
            style: FilledButton.styleFrom(
              backgroundColor: SavingorColors.primaryGreen,
              foregroundColor: SavingorColors.deepGreen,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
                side: const BorderSide(color: SavingorColors.primaryStroke),
              ),
              textStyle: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        OutlinedButton(
          onPressed: onEnterCityManually,
          style: OutlinedButton.styleFrom(
            foregroundColor: SavingorColors.primaryStroke,
            side: BorderSide(
              color: SavingorAccentColors.map.withOpacity(0.4),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            textStyle: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w700,
            ),
          ),
          child: const Text('Enter city manually'),
        ),
      ],
    );
  }
}
