import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:savingor_app/features/receipts/domain/models/receipt.dart';
import 'package:savingor_app/features/scanner/data/receipt_store.dart';
import 'package:savingor_app/features/scanner/domain/models/monthly_receipt_scan_usage.dart';
import 'package:savingor_app/features/scanner/domain/monthly_receipt_scan_usage_service.dart';
import 'package:savingor_app/features/subscription/data/debug_subscription_override_store.dart';
import 'package:savingor_app/features/subscription/data/subscription_service.dart';

/// Combines effective subscription state with derived monthly scan usage.
class ReceiptScanAccessSnapshot {
  const ReceiptScanAccessSnapshot({
    required this.isLoadingSubscription,
    required this.isLoadingReceipts,
    required this.receiptsLoadError,
    required this.usage,
    required this.subscription,
  });

  final bool isLoadingSubscription;
  final bool isLoadingReceipts;
  final String? receiptsLoadError;
  final MonthlyReceiptScanUsage usage;
  final SubscriptionStatus subscription;

  bool get isLoading => isLoadingSubscription || isLoadingReceipts;

  bool get canStartScan =>
      !isLoading && receiptsLoadError == null && usage.canStartNewScan;

  bool get shouldShowUsageIndicator =>
      !isLoadingSubscription && receiptsLoadError == null;
}

class ReceiptScanAccessBuilder extends StatefulWidget {
  const ReceiptScanAccessBuilder({
    super.key,
    required this.builder,
  });

  final Widget Function(
      BuildContext context, ReceiptScanAccessSnapshot snapshot) builder;

  @override
  State<ReceiptScanAccessBuilder> createState() =>
      _ReceiptScanAccessBuilderState();
}

class _ReceiptScanAccessBuilderState extends State<ReceiptScanAccessBuilder> {
  static const MonthlyReceiptScanUsageService _usageService =
      MonthlyReceiptScanUsageService();
  final SubscriptionService _subscriptionService = SubscriptionService();

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

  ReceiptScanAccessSnapshot _buildSnapshot(ReceiptStore store) {
    final List<Receipt> receipts = store.receipts;
    final MonthlyReceiptScanUsage usage = _usageService.computeUsage(
      receipts: receipts,
      isPro: _subscription.hasActiveProAccess,
      userId: store.uid,
    );

    return ReceiptScanAccessSnapshot(
      isLoadingSubscription: _isLoadingSubscription,
      isLoadingReceipts: store.isLoading,
      receiptsLoadError: store.loadError,
      usage: usage,
      subscription: _subscription,
    );
  }

  @override
  Widget build(BuildContext context) {
    final ReceiptStore store = ReceiptProvider.of(context);

    return AnimatedBuilder(
      animation: store,
      builder: (BuildContext context, Widget? _) {
        return widget.builder(context, _buildSnapshot(store));
      },
    );
  }
}
