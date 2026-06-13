import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:savingor_app/features/subscription/data/debug_subscription_override_store.dart';
import 'package:savingor_app/features/subscription/data/subscription_service.dart';

/// Builds UI from the effective subscription state (includes debug override).
class EffectiveSubscriptionBuilder extends StatefulWidget {
  const EffectiveSubscriptionBuilder({
    super.key,
    required this.builder,
  });

  final Widget Function(
    BuildContext context,
    SubscriptionStatus status,
    bool isLoading,
  ) builder;

  @override
  State<EffectiveSubscriptionBuilder> createState() =>
      _EffectiveSubscriptionBuilderState();
}

class _EffectiveSubscriptionBuilderState
    extends State<EffectiveSubscriptionBuilder> {
  final SubscriptionService _subscriptionService = SubscriptionService();

  SubscriptionStatus _subscription = SubscriptionStatus.free;
  bool _isLoading = true;
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
        _isLoading = false;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return widget.builder(context, _subscription, _isLoading);
  }
}
