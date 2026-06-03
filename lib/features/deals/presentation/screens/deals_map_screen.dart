import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:savingor_app/core/theme/savingor_design_system.dart';
import 'package:savingor_app/features/deals/data/local_nearby_store_repository.dart';
import 'package:savingor_app/features/deals/domain/models/nearby_store.dart';
import 'package:savingor_app/features/deals/presentation/widgets/nearby_map_placeholder_card.dart';
import 'package:savingor_app/features/deals/presentation/widgets/nearby_radius_selector.dart';
import 'package:savingor_app/features/deals/presentation/widgets/nearby_store_card.dart';

/// Nearby stores map foundation — mock data until Google Maps / Places.
class DealsMapScreen extends StatefulWidget {
  const DealsMapScreen({
    super.key,
    this.repository = const LocalNearbyStoreRepository(),
  });

  final NearbyStoreRepository repository;

  static const List<double> radiusOptionsKm = <double>[5, 10, 20, 30];

  @override
  State<DealsMapScreen> createState() => _DealsMapScreenState();
}

class _DealsMapScreenState extends State<DealsMapScreen> {
  static const Color _pageWhite = Color(0xFFFFFEFE);

  double _selectedRadiusKm = 10;

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
            _buildLocationSection(),
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

  Widget _buildLocationSection() {
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            children: <Widget>[
              Icon(
                Icons.my_location_rounded,
                size: 20,
                color: SavingorColors.primaryStroke.withOpacity(0.85),
              ),
              const SizedBox(width: 8),
              const Expanded(
                child: Text(
                  'Search radius',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: SavingorColors.darkGreen,
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: SavingorColors.lightGreen.withOpacity(0.35),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  'Sample area',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: SavingorColors.darkGreen.withOpacity(0.8),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            'Location services will be enabled in a future update.',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: SavingorColors.textSecondary.withOpacity(0.9),
              height: 1.3,
            ),
          ),
          const SizedBox(height: 12),
          NearbyRadiusSelector(
            selectedRadiusKm: _selectedRadiusKm,
            radiusOptionsKm: DealsMapScreen.radiusOptionsKm,
            onRadiusSelected: (double radiusKm) {
              setState(() => _selectedRadiusKm = radiusKm);
            },
          ),
        ],
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
