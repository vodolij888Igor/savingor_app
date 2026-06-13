import 'package:flutter/material.dart';

import 'package:savingor_app/core/i18n/map_l10n.dart';
import 'package:savingor_app/core/theme/savingor_design_system.dart';
import 'package:savingor_app/features/deals/domain/models/nearby_store.dart';
import 'package:savingor_app/l10n/app_localizations.dart';

/// Bottom sheet with store details and directions from a map marker tap.
class SelectedStoreBottomSheet extends StatelessWidget {
  const SelectedStoreBottomSheet({
    super.key,
    required this.store,
    required this.onDirections,
  });

  final NearbyStore store;
  final VoidCallback onDirections;

  static Future<void> show(
    BuildContext context, {
    required NearbyStore store,
    required VoidCallback onDirections,
  }) {
    return showModalBottomSheet<void>(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (BuildContext context) => SelectedStoreBottomSheet(
        store: store,
        onDirections: onDirections,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final AppLocalizations l10n = AppLocalizations.of(context);
    final double bottomInset = MediaQuery.paddingOf(context).bottom;

    return Padding(
      padding: EdgeInsets.fromLTRB(20, 16, 20, 20 + bottomInset),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Center(
            child: Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: const Color(0xFFE0E4E1),
                borderRadius: BorderRadius.circular(999),
              ),
            ),
          ),
          const SizedBox(height: 16),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                width: 48,
                height: 48,
                decoration: SavingorSurfaces.accentIconBlock(
                  accent: SavingorAccentColors.map,
                ),
                child: const Icon(
                  Icons.storefront_rounded,
                  color: SavingorAccentColors.map,
                  size: 24,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      store.name,
                      style: SavingorAppTextStyles.cardTitle.copyWith(
                        fontSize: 18,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      MapL10n.storeCategoryLabel(context, store.category),
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: SavingorColors.textSecondary.withOpacity(0.95),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(
                  color: SavingorAccentColors.map.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  store.distanceLabel,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: SavingorAccentColors.map,
                  ),
                ),
              ),
            ],
          ),
          if (store.hasAddress) ...<Widget>[
            const SizedBox(height: 14),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Icon(
                  Icons.location_on_outlined,
                  size: 18,
                  color: SavingorAccentColors.map.withOpacity(0.85),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    store.displayAddress!,
                    style: SavingorAppTextStyles.bodySecondary(fontSize: 13),
                  ),
                ),
              ],
            ),
          ],
          if (store.isRealData) ...<Widget>[
            const SizedBox(height: 10),
            Text(
              MapL10n.localizedStoreStatusText(context, store.statusText),
              style: SavingorAppTextStyles.bodySecondary(fontSize: 12),
            ),
          ],
          const SizedBox(height: 18),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed: onDirections,
              icon: const Icon(Icons.directions_rounded, size: 18),
              label: Text(l10n.directions),
              style: OutlinedButton.styleFrom(
                foregroundColor: SavingorAccentColors.map,
                side: BorderSide(
                  color: SavingorAccentColors.map.withOpacity(0.35),
                ),
                padding: const EdgeInsets.symmetric(vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                textStyle: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
