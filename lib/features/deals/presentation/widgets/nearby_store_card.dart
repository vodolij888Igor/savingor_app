import 'package:flutter/material.dart';

import 'package:savingor_app/core/i18n/map_l10n.dart';
import 'package:savingor_app/core/theme/savingor_design_system.dart';
import 'package:savingor_app/core/widgets/savingor_interactive.dart';
import 'package:savingor_app/features/deals/domain/models/nearby_store.dart';
import 'package:savingor_app/l10n/app_localizations.dart';

class NearbyStoreCard extends StatelessWidget {
  const NearbyStoreCard({
    super.key,
    required this.store,
    required this.onDirections,
  });

  final NearbyStore store;
  final VoidCallback onDirections;

  @override
  Widget build(BuildContext context) {
    final AppLocalizations l10n = AppLocalizations.of(context);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: SavingorSurfaces.premiumCard(context, radius: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                width: 44,
                height: 44,
                decoration: SavingorSurfaces.accentIconBlock(
                  accent: SavingorAccentColors.map,
                  radius: 12,
                ),
                child: const Icon(
                  Icons.storefront_rounded,
                  color: SavingorAccentColors.map,
                  size: 22,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      store.name,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: context.savingor.textPrimary,
                        height: 1.2,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      MapL10n.storeCategoryLabel(context, store.category),
                      style: SavingorAppTextStyles.bodySecondary(context,
                          fontSize: 12),
                    ),
                    if (store.hasAddress) ...<Widget>[
                      const SizedBox(height: 4),
                      Text(
                        store.displayAddress!,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: SavingorAppTextStyles.bodySecondary(context,
                            fontSize: 12),
                      ),
                    ],
                  ],
                ),
              ),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                decoration: BoxDecoration(
                  color: SavingorAccentColors.map.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(SavingorRadius.pill),
                  border: Border.all(
                    color: SavingorAccentColors.map.withOpacity(0.25),
                  ),
                ),
                child: Text(
                  store.distanceLabel,
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: SavingorAccentColors.map,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            MapL10n.localizedStoreStatusText(context, store.statusText),
            style: SavingorAppTextStyles.bodySecondary(context, fontSize: 12),
          ),
          const SizedBox(height: 12),
          Align(
            alignment: Alignment.centerRight,
            child: SavingorInteractiveOutlinedButton(
              onPressed: onDirections,
              accentTint: SavingorAccentColors.map,
              foregroundColor: SavingorColors.primaryStroke,
              borderColor: SavingorAccentColors.map.withOpacity(0.45),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Text(l10n.directions),
            ),
          ),
        ],
      ),
    );
  }
}
