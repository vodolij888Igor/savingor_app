import 'package:flutter/material.dart';

import 'package:savingor_app/features/subscription/domain/feature_access_service.dart';
import 'package:savingor_app/features/subscription/domain/savingor_feature.dart';
import 'package:savingor_app/features/subscription/presentation/widgets/effective_subscription_builder.dart';
import 'package:savingor_app/features/subscription/presentation/widgets/pro_feature_badge.dart';

/// Shows [ProFeatureBadge] on [child] when the user lacks access to [feature].
class ProFeatureBadgeIfLocked extends StatelessWidget {
  const ProFeatureBadgeIfLocked({
    super.key,
    required this.feature,
    required this.child,
  });

  final SavingorFeature feature;
  final Widget child;

  static const FeatureAccessService _accessService = FeatureAccessService();

  @override
  Widget build(BuildContext context) {
    return EffectiveSubscriptionBuilder(
      builder: (
        BuildContext context,
        status,
        bool isLoading,
      ) {
        final bool showBadge = !isLoading &&
            !_accessService.canAccessForStatus(
              feature: feature,
              status: status,
            );

        if (!showBadge) {
          return child;
        }

        return Stack(
          clipBehavior: Clip.none,
          children: <Widget>[
            child,
            const Positioned(
              top: 12,
              right: 12,
              child: ProFeatureBadge(),
            ),
          ],
        );
      },
    );
  }
}
