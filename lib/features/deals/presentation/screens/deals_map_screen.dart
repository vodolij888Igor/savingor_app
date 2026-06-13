import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:savingor_app/core/i18n/map_l10n.dart';
import 'package:savingor_app/core/theme/savingor_design_system.dart';
import 'package:savingor_app/features/deals/data/map_directions_launcher.dart';
import 'package:savingor_app/features/deals/data/nearby_stores_repository.dart';
import 'package:savingor_app/features/deals/data/user_location_service.dart';
import 'package:savingor_app/features/deals/domain/models/manual_location_selection.dart';
import 'package:savingor_app/features/deals/domain/models/nearby_store.dart';
import 'package:savingor_app/features/deals/domain/models/nearby_store_data_source.dart';
import 'package:savingor_app/features/deals/domain/models/user_location_coords.dart';
import 'package:savingor_app/features/deals/presentation/widgets/manual_location_sheet.dart';
import 'package:savingor_app/features/deals/presentation/widgets/nearby_location_section.dart';
import 'package:savingor_app/features/deals/presentation/widgets/nearby_stores_map_card.dart';
import 'package:savingor_app/features/deals/presentation/widgets/nearby_store_card.dart';
import 'package:savingor_app/features/deals/presentation/widgets/selected_store_bottom_sheet.dart';
import 'package:savingor_app/l10n/app_localizations.dart';

/// Nearby stores map foundation — mock data until Google Maps / Places.
class DealsMapScreen extends StatefulWidget {
  DealsMapScreen({
    super.key,
    NearbyStoresRepository? repository,
    this.locationService = const UserLocationService(),
    this.directionsLauncher = const MapDirectionsLauncher(),
  }) : repository = repository ?? NearbyStoresRepository();

  final NearbyStoresRepository repository;
  final UserLocationService locationService;
  final MapDirectionsLauncher directionsLauncher;

  static const List<double> radiusOptionsKm = <double>[5, 10, 20, 30];

  @override
  State<DealsMapScreen> createState() => _DealsMapScreenState();
}

class _DealsMapScreenState extends State<DealsMapScreen> {
  static const Color _pageWhite = SavingorColors.pageWhite;

  double _selectedRadiusKm = 10;
  NearbyActiveLocation? _activeLocation;
  UserLocationAccessStatus _locationStatus = UserLocationAccessStatus.idle;
  String? _locationMessage;
  UserLocationDebugInfo? _locationDebug;
  bool _isLoadingLocation = false;

  List<NearbyStore> _stores = <NearbyStore>[];
  bool _isLoadingStores = true;
  NearbyStoreDataSource _storeDataSource = NearbyStoreDataSource.mock;
  bool _usedPlacesFallback = false;

  @override
  void initState() {
    super.initState();
    _loadStores();
  }

  UserLocationCoords? get _displayCoords {
    if (_activeLocation != null &&
        (_activeLocation!.latitude != 0 || _activeLocation!.longitude != 0)) {
      return _activeLocation!.coords;
    }
    return null;
  }

  String? get _manualLocationLabel {
    if (_activeLocation?.source == NearbyLocationSource.manual) {
      return _activeLocation!.displayName;
    }
    return null;
  }

  Future<void> _loadStores() async {
    setState(() => _isLoadingStores = true);

    final NearbyStoresLoadResult result = await widget.repository.loadStores(
      radiusKm: _selectedRadiusKm,
      regionId: _activeLocation?.regionId,
      originLatitude: _displayCoords?.latitude,
      originLongitude: _displayCoords?.longitude,
    );

    if (!mounted) return;
    setState(() {
      _stores = result.stores;
      _storeDataSource = result.dataSource;
      _usedPlacesFallback = result.usedPlacesFallback;
      _isLoadingStores = false;
    });
  }

  Future<void> _requestLocation() async {
    if (_isLoadingLocation) return;

    setState(() {
      _isLoadingLocation = true;
      _locationMessage = null;
      _locationDebug = null;
    });

    final UserLocationResult result =
        await widget.locationService.requestCurrentLocation();

    if (!mounted) return;

    NearbyActiveLocation? nextActive;
    if (result.status == UserLocationAccessStatus.granted &&
        result.coords != null) {
      nextActive = NearbyActiveLocation(
        displayName: 'Current location',
        latitude: result.coords!.latitude,
        longitude: result.coords!.longitude,
        source: NearbyLocationSource.gps,
        regionId: null,
      );
    }

    setState(() {
      _isLoadingLocation = false;
      _locationStatus = result.status;
      _activeLocation = nextActive;
      _locationMessage = result.message;
      _locationDebug = result.debug;
    });

    await _loadStores();
  }

  Future<void> _enterCityManually() async {
    final String? input = await ManualLocationSheet.show(context);
    if (input == null || !mounted) return;

    final String trimmed = input.trim();
    if (trimmed.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(AppLocalizations.of(context).mapPleaseEnterCityOrArea),
        ),
      );
      return;
    }

    final ManualLocationSelection? selection =
        ManualLocationResolver.resolve(trimmed);
    if (selection == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(AppLocalizations.of(context).mapPleaseEnterCityOrArea),
        ),
      );
      return;
    }

    setState(() {
      _activeLocation = selection.toActiveLocation();
      _locationStatus = UserLocationAccessStatus.idle;
      _locationMessage = null;
      _locationDebug = null;
    });

    await _loadStores();
  }

  Future<void> _openDirections(NearbyStore store) async {
    final UserLocationCoords? origin = _displayCoords;

    final bool opened = await widget.directionsLauncher.openDirections(
      store,
      origin: origin,
    );

    if (!mounted) return;
    if (!opened) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(AppLocalizations.of(context).mapCouldNotOpenDirections),
        ),
      );
    }
  }

  Future<void> _onStoreMarkerTap(NearbyStore store) async {
    await SelectedStoreBottomSheet.show(
      context,
      store: store,
      onDirections: () {
        Navigator.of(context).pop();
        _openDirections(store);
      },
    );
  }

  String _storesFootnote(AppLocalizations l10n) {
    if (_storeDataSource == NearbyStoreDataSource.places) {
      return l10n.mapStoresFootnotePlaces;
    }
    if (_usedPlacesFallback) {
      return l10n.mapStoresFootnoteFallback;
    }
    return l10n.mapStoresFootnoteDefault;
  }

  @override
  Widget build(BuildContext context) {
    final AppLocalizations l10n = AppLocalizations.of(context);
    final double bottomInset = MediaQuery.paddingOf(context).bottom;

    return Scaffold(
      backgroundColor: _pageWhite,
      appBar: AppBar(
        title: Text(
          l10n.nearbyStores,
          style: SavingorAppTextStyles.screenTitle,
        ),
        elevation: 0,
        scrolledUnderElevation: 0,
        backgroundColor: _pageWhite,
        surfaceTintColor: Colors.transparent,
        leading: context.canPop()
            ? BackButton(
                color: SavingorColors.textPrimary,
                onPressed: () => context.pop(),
              )
            : null,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.fromLTRB(20, 8, 20, 24 + bottomInset),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Text(
              l10n.nearbyStoresSubtitle,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: SavingorColors.textSecondary.withOpacity(0.95),
                height: 1.4,
              ),
            ),
            const SizedBox(height: SavingorSpacing.lg),
            NearbyLocationSection(
              locationStatus: _locationStatus,
              coords: _displayCoords,
              locationMessage: _locationMessage,
              isLoadingLocation: _isLoadingLocation,
              locationDebug: _locationDebug,
              manualLocationLabel: _manualLocationLabel,
              selectedRadiusKm: _selectedRadiusKm,
              radiusOptionsKm: DealsMapScreen.radiusOptionsKm,
              onUseMyLocation: _requestLocation,
              onRetryLocation: _requestLocation,
              onEnterCityManually: _enterCityManually,
              onRadiusSelected: (double radiusKm) {
                setState(() => _selectedRadiusKm = radiusKm);
                _loadStores();
              },
            ),
            const SizedBox(height: SavingorSpacing.lg),
            NearbyStoresMapCard(
              userLatitude: _displayCoords?.latitude,
              userLongitude: _displayCoords?.longitude,
              userLocationLabel: MapL10n.activeLocationDisplayName(
                context,
                _activeLocation,
              ),
              radiusKm: _selectedRadiusKm,
              stores: _stores,
              onStoreMarkerTap: _onStoreMarkerTap,
            ),
            const SizedBox(height: SavingorSpacing.lg),
            Row(
              children: <Widget>[
                Expanded(
                  child: Text(
                    l10n.storesNearby,
                    style: SavingorAppTextStyles.sectionTitle,
                  ),
                ),
                Text(
                  _isLoadingStores
                      ? '…'
                      : l10n.mapStoresFoundCount(_stores.length),
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: SavingorColors.textSecondary.withOpacity(0.9),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 6),
            Text(
              _storesFootnote(l10n),
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: SavingorColors.textSecondary.withOpacity(0.9),
                height: 1.35,
              ),
            ),
            const SizedBox(height: SavingorSpacing.md),
            if (_isLoadingStores)
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 24),
                child: Center(
                  child: CircularProgressIndicator(
                    color: SavingorColors.primaryStroke,
                  ),
                ),
              )
            else if (_stores.isEmpty)
              _buildEmptyRadiusState(l10n)
            else
              ..._stores.map(
                (NearbyStore store) => Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: NearbyStoreCard(
                    store: store,
                    onDirections: () => _openDirections(store),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyRadiusState(AppLocalizations l10n) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: SavingorSurfaces.premiumCard(radius: 16),
      child: Text(
        l10n.mapNoStoresWithinRadius(_selectedRadiusKm.round()),
        textAlign: TextAlign.center,
        style: SavingorAppTextStyles.bodySecondary(fontSize: 13),
      ),
    );
  }
}
