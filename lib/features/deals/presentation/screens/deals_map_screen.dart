import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:savingor_app/core/theme/savingor_design_system.dart';
import 'package:savingor_app/features/deals/data/local_nearby_store_repository.dart';
import 'package:savingor_app/features/deals/data/user_location_service.dart';
import 'package:savingor_app/features/deals/domain/models/nearby_store.dart';
import 'package:savingor_app/features/deals/domain/models/user_location_coords.dart';
import 'package:savingor_app/features/deals/presentation/widgets/nearby_location_section.dart';
import 'package:savingor_app/features/deals/presentation/widgets/nearby_map_placeholder_card.dart';
import 'package:savingor_app/features/deals/presentation/widgets/nearby_store_card.dart';

/// Nearby stores map foundation — mock data until Google Maps / Places.
class DealsMapScreen extends StatefulWidget {
  const DealsMapScreen({
    super.key,
    this.repository = const LocalNearbyStoreRepository(),
    this.locationService = const UserLocationService(),
  });

  final NearbyStoreRepository repository;
  final UserLocationService locationService;

  static const List<double> radiusOptionsKm = <double>[5, 10, 20, 30];

  @override
  State<DealsMapScreen> createState() => _DealsMapScreenState();
}

class _DealsMapScreenState extends State<DealsMapScreen> {
  static const Color _pageWhite = Color(0xFFFFFEFE);

  double _selectedRadiusKm = 10;
  UserLocationAccessStatus _locationStatus = UserLocationAccessStatus.idle;
  UserLocationCoords? _coords;
  String? _locationMessage;
  UserLocationDebugInfo? _locationDebug;
  bool _isLoadingLocation = false;

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
    setState(() {
      _isLoadingLocation = false;
      _locationStatus = result.status;
      _coords = result.coords;
      _locationMessage = result.message;
      _locationDebug = result.debug;
    });
  }

  void _showDirectionsSnack() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Directions will open Google Maps in the next step.'),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final List<NearbyStore> stores =
        widget.repository.getStoresWithinRadius(_selectedRadiusKm);
    final double bottomInset = MediaQuery.paddingOf(context).bottom;

    return Scaffold(
      backgroundColor: _pageWhite,
      appBar: AppBar(
        title: const Text(
          'Nearby stores',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w800,
            color: SavingorColors.darkGreen,
          ),
        ),
        elevation: 0,
        scrolledUnderElevation: 0,
        backgroundColor: _pageWhite,
        surfaceTintColor: Colors.transparent,
        leading: context.canPop()
            ? BackButton(
                color: SavingorColors.darkGreen,
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
              'Find grocery stores near you and compare savings opportunities.',
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
              coords: _coords,
              locationMessage: _locationMessage,
              isLoadingLocation: _isLoadingLocation,
              locationDebug: _locationDebug,
              selectedRadiusKm: _selectedRadiusKm,
              radiusOptionsKm: DealsMapScreen.radiusOptionsKm,
              onUseMyLocation: _requestLocation,
              onRetryLocation: _requestLocation,
              onRadiusSelected: (double radiusKm) {
                setState(() => _selectedRadiusKm = radiusKm);
              },
            ),
            const SizedBox(height: SavingorSpacing.lg),
            const NearbyMapPlaceholderCard(),
            const SizedBox(height: SavingorSpacing.lg),
            Row(
              children: <Widget>[
                const Expanded(
                  child: Text(
                    'Stores nearby',
                    style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w800,
                      color: SavingorColors.darkGreen,
                    ),
                  ),
                ),
                Text(
                  '${stores.length} found',
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
              'Sample nearby stores. Real Google Places integration is coming next.',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: SavingorColors.textSecondary.withOpacity(0.9),
                height: 1.35,
              ),
            ),
            const SizedBox(height: SavingorSpacing.md),
            if (stores.isEmpty)
              _buildEmptyRadiusState()
            else
              ...stores.map(
                (NearbyStore store) => Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: NearbyStoreCard(
                    store: store,
                    onDirections: _showDirectionsSnack,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyRadiusState() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: SavingorColors.lightGreen.withOpacity(0.2),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Text(
        'No sample stores within ${_selectedRadiusKm.round()} km. '
        'Try a larger radius.',
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w500,
          color: SavingorColors.darkGreen.withOpacity(0.85),
          height: 1.4,
        ),
      ),
    );
  }
}
