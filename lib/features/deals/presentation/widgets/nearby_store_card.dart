import 'package:flutter/material.dart';

import 'package:savingor_app/core/theme/savingor_design_system.dart';
import 'package:savingor_app/features/deals/domain/models/nearby_store.dart';

class NearbyStoreCard extends StatelessWidget {
  const NearbyStoreCard({
    super.key,
    required this.store,
    required this.onDirections,
  });

  final NearbyStore store;
  final VoidCallback onDirections;

  static const Color _airyBorder = Color(0xFFF3F4F3);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: _airyBorder, width: 0.5),
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: SavingorColors.lightGreen.withOpacity(0.45),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.storefront_rounded,
                  color: SavingorColors.primaryStroke,
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
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: SavingorColors.darkGreen,
                        height: 1.2,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      store.category.label,
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: SavingorColors.textSecondary.withOpacity(0.9),
                      ),
                    ),
                  ],
                ),
              ),
              Text(
                store.distanceLabel,
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  color: SavingorColors.primaryStroke,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            store.statusText,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: SavingorColors.darkGreen.withOpacity(0.72),
            ),
          ),
          const SizedBox(height: 12),
          Align(
            alignment: Alignment.centerRight,
            child: OutlinedButton(
              onPressed: onDirections,
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
              child: const Text('Directions'),
            ),
          ),
        ],
      ),
    );
  }
}
