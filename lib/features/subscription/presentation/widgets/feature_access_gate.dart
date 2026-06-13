import 'package:flutter/material.dart';

import 'package:savingor_app/features/subscription/domain/feature_access_service.dart';
import 'package:savingor_app/features/subscription/domain/savingor_feature.dart';

/// Reusable gate that shows [child] or [lockedBuilder] based on feature access.
///
/// Does not navigate, show dialogs, or embed paywall design — callers supply
/// the locked-state UI via [lockedBuilder].
class FeatureAccessGate extends StatelessWidget {
  const FeatureAccessGate({
    super.key,
    required this.feature,
    required this.isPro,
    required this.child,
    required this.lockedBuilder,
    this.accessService = const FeatureAccessService(),
  });

  final SavingorFeature feature;

  /// Active Pro access from [SubscriptionStatus.hasActiveProAccess].
  final bool isPro;

  /// Shown when [FeatureAccessService.canAccess] returns true.
  final Widget child;

  /// Shown when the feature requires Pro and the user is on the Free plan.
  final WidgetBuilder lockedBuilder;

  final FeatureAccessService accessService;

  @override
  Widget build(BuildContext context) {
    if (accessService.canAccess(feature: feature, isPro: isPro)) {
      return child;
    }
    return lockedBuilder(context);
  }
}
