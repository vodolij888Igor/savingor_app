import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:savingor_app/core/theme/savingor_design_system.dart';
import 'package:savingor_app/features/subscription/data/debug_subscription_override_store.dart';
import 'package:savingor_app/features/subscription/data/subscription_service.dart';
import 'package:savingor_app/features/subscription/domain/feature_access_service.dart';
import 'package:savingor_app/features/subscription/domain/savingor_feature.dart';
import 'package:savingor_app/features/subscription/presentation/widgets/feature_access_gate.dart';
import 'package:savingor_app/features/subscription/presentation/widgets/pro_feature_locked_preview.dart';

/// Destination-level gate: shows [ProFeatureLockedPreview] for Free users and
/// builds [proContentBuilder] only when effective Pro access is granted.
class ProFeatureScreenHost extends StatefulWidget {
  const ProFeatureScreenHost({
    super.key,
    required this.feature,
    required this.title,
    required this.proContentBuilder,
    this.leading,
    this.titleBuilder,
  });

  final SavingorFeature feature;
  final String title;
  final Widget Function(BuildContext context) proContentBuilder;
  final Widget? leading;

  /// When set, overrides [title] for the app bar (e.g. dynamic product name).
  final String Function(BuildContext context)? titleBuilder;

  @override
  State<ProFeatureScreenHost> createState() => _ProFeatureScreenHostState();
}

class _ProFeatureScreenHostState extends State<ProFeatureScreenHost> {
  final SubscriptionService _subscriptionService = SubscriptionService();
  static const FeatureAccessService _featureAccessService =
      FeatureAccessService();

  SubscriptionStatus _subscription = SubscriptionStatus.free;
  bool _isLoadingSubscription = true;
  DebugSubscriptionOverrideStore? _debugOverrideStore;

  @override
  void initState() {
    super.initState();
    _loadSubscription();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!kDebugMode) {
      return;
    }
    final DebugSubscriptionOverrideStore? store =
        DebugSubscriptionOverrideProvider.maybeOf(context);
    if (store == _debugOverrideStore) {
      return;
    }
    _debugOverrideStore?.removeListener(_onDebugOverrideChanged);
    _debugOverrideStore = store;
    _debugOverrideStore?.addListener(_onDebugOverrideChanged);
  }

  @override
  void dispose() {
    _debugOverrideStore?.removeListener(_onDebugOverrideChanged);
    super.dispose();
  }

  void _onDebugOverrideChanged() {
    _loadSubscription();
  }

  Future<void> _loadSubscription() async {
    try {
      final SubscriptionStatus status =
          await _subscriptionService.getCurrentSubscription();
      if (!mounted) return;
      setState(() {
        _subscription = status;
        _isLoadingSubscription = false;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() => _isLoadingSubscription = false);
    }
  }

  Future<void> _openPlans() async {
    await context.push('/subscription');
    if (mounted) {
      await _loadSubscription();
    }
  }

  @override
  Widget build(BuildContext context) {
    final double bottomInset = MediaQuery.paddingOf(context).bottom;

    return Scaffold(
      backgroundColor: context.savingor.pageBackground,
      appBar: AppBar(
        title: Text(
          widget.titleBuilder?.call(context) ?? widget.title,
          style: SavingorAppTextStyles.screenTitle(context),
        ),
        elevation: 0,
        scrolledUnderElevation: 0,
        backgroundColor: context.savingor.pageBackground,
        surfaceTintColor: Colors.transparent,
        leading: widget.leading ??
            IconButton(
              icon: Icon(
                Icons.arrow_back_ios_new_rounded,
                color: SavingorWorkflowTheme.appBarIcon(context),
                size: 20,
              ),
              onPressed: () => context.pop(),
            ),
      ),
      body: _buildBody(bottomInset),
    );
  }

  Widget _buildBody(double bottomInset) {
    if (_isLoadingSubscription) {
      return Center(
        child: CircularProgressIndicator(
          color: context.savingor.isDark
              ? context.savingor.accentGreen
              : SavingorColors.primaryStroke,
        ),
      );
    }

    return FeatureAccessGate(
      feature: widget.feature,
      isPro: _subscription.hasActiveProAccess,
      accessService: _featureAccessService,
      lockedBuilder: (BuildContext context) {
        return ProFeatureLockedPreview(
          feature: widget.feature,
          bottomInset: bottomInset,
          onOpenPlans: _openPlans,
        );
      },
      child: widget.proContentBuilder(context),
    );
  }
}
