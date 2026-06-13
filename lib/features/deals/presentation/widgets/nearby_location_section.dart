import 'package:flutter/material.dart';

import 'package:savingor_app/core/i18n/map_l10n.dart';
import 'package:savingor_app/core/theme/savingor_design_system.dart';
import 'package:savingor_app/features/deals/data/user_location_service.dart';
import 'package:savingor_app/features/deals/domain/models/user_location_coords.dart';
import 'package:savingor_app/features/deals/presentation/widgets/nearby_radius_selector.dart';
import 'package:savingor_app/l10n/app_localizations.dart';

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
    final AppLocalizations l10n = AppLocalizations.of(context);

    return Stack(
      clipBehavior: Clip.none,
      children: <Widget>[
        Container(
          padding: const EdgeInsets.all(18),
          decoration: SavingorSurfaces.locationCard(
            context,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              _buildLocationHeader(context, l10n),
              const SizedBox(height: 12),
              _buildLocationBody(context, l10n),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 14),
                child: Divider(height: 1, color: context.savingor.border),
              ),
              Text(
                l10n.mapSearchRadius,
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                  color: context.savingor.textPrimary,
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

  Widget _buildLocationHeader(BuildContext context, AppLocalizations l10n) {
    final bool isActive =
        _isManualSelected || locationStatus == UserLocationAccessStatus.granted;

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
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                l10n.mapYourLocation,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w800,
                  color: context.savingor.textPrimary,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                l10n.mapFindGroceryStoresNearYou,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: context.savingor.textSecondary,
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
            child: Text(
              l10n.mapActive,
              style: const TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w700,
                color: SavingorColors.primaryStroke,
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildLocationBody(BuildContext context, AppLocalizations l10n) {
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
            l10n.mapCheckingLocation,
            style: SavingorAppTextStyles.bodySecondary(context, fontSize: 13),
          ),
        ],
      );
    }

    if (_isManualSelected) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            l10n.mapLocationSelected,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w700,
              color: SavingorColors.primaryStroke,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            manualLocationLabel!,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: context.savingor.textPrimary,
            ),
          ),
          const SizedBox(height: 12),
          _buildLocationActions(l10n, showUseMyLocation: true),
        ],
      );
    }

    if (locationStatus == UserLocationAccessStatus.granted && coords != null) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            l10n.mapLocationDetected,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w700,
              color: SavingorColors.primaryStroke,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            l10n.mapReadyToSearchNearby,
            style: SavingorAppTextStyles.bodySecondary(context, fontSize: 13),
          ),
          const SizedBox(height: 12),
          _buildLocationActions(l10n, showUseMyLocation: true),
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
            MapL10n.locationMessage(
              context,
              status: locationStatus,
              fallbackMessage: locationMessage,
            ),
            style: SavingorAppTextStyles.bodySecondary(context, fontSize: 13),
          ),
          const SizedBox(height: 12),
          _buildLocationActions(
            l10n,
            showUseMyLocation: true,
            isRetry: true,
          ),
        ],
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        Text(
          l10n.mapEnableLocationPrompt,
          style: SavingorAppTextStyles.bodySecondary(context, fontSize: 13),
        ),
        const SizedBox(height: 12),
        _buildLocationActions(l10n, showUseMyLocation: true),
      ],
    );
  }

  Widget _buildLocationActions(
    AppLocalizations l10n, {
    required bool showUseMyLocation,
    bool isRetry = false,
  }) {
    final String primaryLabel = isRetry ? l10n.tryAgain : l10n.mapUseMyLocation;
    final VoidCallback primaryAction =
        isRetry ? onRetryLocation : onUseMyLocation;

    return Wrap(
      spacing: 8,
      runSpacing: 8,
      crossAxisAlignment: WrapCrossAlignment.center,
      children: <Widget>[
        if (showUseMyLocation)
          FilledButton.icon(
            onPressed: primaryAction,
            icon: Icon(
              isRetry
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
          child: Text(l10n.mapEnterCityManually),
        ),
      ],
    );
  }
}
