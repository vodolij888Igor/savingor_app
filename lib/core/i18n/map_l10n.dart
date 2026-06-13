import 'package:flutter/widgets.dart';

import 'package:savingor_app/features/deals/data/user_location_service.dart';
import 'package:savingor_app/features/deals/domain/models/manual_location_selection.dart';
import 'package:savingor_app/features/deals/domain/models/nearby_store.dart';
import 'package:savingor_app/l10n/app_localizations.dart';

/// Display-time localization for the nearby stores map feature.
abstract final class MapL10n {
  static String storeCategoryLabel(
    BuildContext context,
    NearbyStoreCategory category,
  ) {
    final AppLocalizations l10n = AppLocalizations.of(context);
    return switch (category) {
      NearbyStoreCategory.grocery => l10n.mapStoreCategoryGrocery,
      NearbyStoreCategory.supermarket => l10n.mapStoreCategorySupermarket,
      NearbyStoreCategory.wholesale => l10n.mapStoreCategoryWholesale,
    };
  }

  static String localizedStoreStatusText(
      BuildContext context, String statusText) {
    final AppLocalizations l10n = AppLocalizations.of(context);
    return switch (statusText) {
      'Nearby store' => l10n.mapNearbyStoreStatus,
      'Listed on Google Places' => l10n.mapListedOnGooglePlaces,
      _ => statusText,
    };
  }

  static String locationMessage(
    BuildContext context, {
    required UserLocationAccessStatus status,
    String? fallbackMessage,
  }) {
    final AppLocalizations l10n = AppLocalizations.of(context);
    if (fallbackMessage != null && fallbackMessage.isNotEmpty) {
      return switch (fallbackMessage) {
        'Location services are turned off.' => l10n.mapLocationServicesDisabled,
        'Location permission denied.' => l10n.mapLocationPermissionDenied,
        'Could not detect your location. Please try again.' =>
          l10n.mapCouldNotDetectLocation,
        _ => fallbackMessage,
      };
    }

    return switch (status) {
      UserLocationAccessStatus.serviceDisabled =>
        l10n.mapLocationServicesDisabled,
      UserLocationAccessStatus.permissionDenied =>
        l10n.mapLocationPermissionDenied,
      UserLocationAccessStatus.failed => l10n.mapCouldNotDetectLocation,
      _ => l10n.mapCouldNotAccessLocation,
    };
  }

  static String activeLocationDisplayName(
    BuildContext context,
    NearbyActiveLocation? location,
  ) {
    if (location == null) {
      return '';
    }
    if (location.source == NearbyLocationSource.gps) {
      return AppLocalizations.of(context).mapCurrentLocation;
    }
    return location.displayName;
  }

  static String markerInfoWindowSnippet(
    BuildContext context,
    NearbyStore store,
  ) {
    final AppLocalizations l10n = AppLocalizations.of(context);
    final String distance = store.distanceLabel;
    if (store.hasAddress) {
      return l10n.mapMarkerSnippetWithDetail(distance, store.displayAddress!);
    }
    return l10n.mapMarkerSnippetWithDetail(
      distance,
      storeCategoryLabel(context, store.category),
    );
  }
}
