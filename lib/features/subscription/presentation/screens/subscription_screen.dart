import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:savingor_app/core/theme/savingor_design_system.dart';
import 'package:savingor_app/features/subscription/data/subscription_service.dart';

/// Pricing surface for Free and Pro plans.
///
/// TODO: Replace demo subscription activation with RevenueCat / StoreKit /
/// Google Play Billing integration before production release.
class SubscriptionScreen extends StatefulWidget {
  const SubscriptionScreen({super.key});

  @override
  State<SubscriptionScreen> createState() => _SubscriptionScreenState();
}

class _SubscriptionScreenState extends State<SubscriptionScreen> {
  final SubscriptionService _subscriptionService = SubscriptionService();

  SubscriptionStatus _subscription = SubscriptionStatus.free;
  bool _isActivating = false;
  bool _isRestoring = false;

  static const Color _pageBackground = Color(0xFFF3FAF1);

  bool get _isPro => _subscription.isPro;

  @override
  void initState() {
    super.initState();
    _loadSubscription();
  }

  Future<void> _loadSubscription() async {
    try {
      final SubscriptionStatus status =
          await _subscriptionService.getCurrentSubscription();
      if (!mounted) return;
      setState(() => _subscription = status);
    } catch (_) {
      // Keep showing Free state; purchasing will surface real errors.
    }
  }

  void _showSnack(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  Future<void> _onStartProSubscription() async {
    if (_subscriptionService.isRevenueCatConfigured) {
      await _purchaseProMonthly();
    } else {
      await _showProviderNotConfiguredModal();
    }
  }

  /// Real store purchase via RevenueCat (entitlement is the source of truth).
  Future<void> _purchaseProMonthly() async {
    setState(() => _isActivating = true);
    try {
      await _subscriptionService.purchaseProMonthly();
      if (!mounted) return;
      setState(() => _isActivating = false);
      _showSnack('Pro subscription activated.');
      await _loadSubscription();
    } on SubscriptionException catch (e) {
      if (!mounted) return;
      setState(() => _isActivating = false);
      _showSnack(e.message);
    } catch (_) {
      if (!mounted) return;
      setState(() => _isActivating = false);
      _showSnack('Could not complete the purchase. Please try again.');
    }
  }

  /// Shown when RevenueCat keys/products are not configured in this build.
  Future<void> _showProviderNotConfiguredModal() async {
    final bool? confirmed = await showDialog<bool>(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          backgroundColor: Colors.white,
          surfaceTintColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(22),
          ),
          title: const Text(
            'Subscription provider not configured',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w800,
              color: SavingorColors.darkGreen,
            ),
          ),
          content: const Text(
            'Savingor Pro is prepared for RevenueCat-powered Apple and '
            'Google in-app subscriptions. This local portfolio build does '
            'not include RevenueCat keys or store products yet.',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: SavingorColors.textSecondary,
              height: 1.45,
            ),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(false),
              style: TextButton.styleFrom(
                foregroundColor: SavingorColors.textSecondary,
              ),
              child: const Text('Cancel'),
            ),
            // Clearly secondary: demo fallback is for local testing only.
            OutlinedButton(
              onPressed: () => Navigator.of(dialogContext).pop(true),
              style: OutlinedButton.styleFrom(
                foregroundColor: SavingorColors.darkGreen,
                side: BorderSide(
                  color: SavingorColors.primaryStroke.withOpacity(0.5),
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
                textStyle: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                ),
              ),
              child: const Text('Activate Pro demo for testing'),
            ),
          ],
        );
      },
    );

    if (confirmed != true || !mounted) return;
    await _activateProDemoFallback();
  }

  Future<void> _activateProDemoFallback() async {
    setState(() => _isActivating = true);
    try {
      await _subscriptionService.activateProDemoFallback();
      if (!mounted) return;
      setState(() => _isActivating = false);
      _showSnack('Pro demo fallback activated — no real payment processed.');
      await _loadSubscription();
    } on SubscriptionException catch (e) {
      if (!mounted) return;
      setState(() => _isActivating = false);
      _showSnack(e.message);
    } catch (_) {
      if (!mounted) return;
      setState(() => _isActivating = false);
      _showSnack('Could not activate Pro demo. Please try again.');
    }
  }

  Future<void> _onRestorePurchases() async {
    if (!_subscriptionService.isRevenueCatConfigured) {
      _showSnack('Payment provider is not configured in this local build.');
      return;
    }
    setState(() => _isRestoring = true);
    try {
      final SubscriptionStatus status =
          await _subscriptionService.restorePurchases();
      if (!mounted) return;
      setState(() {
        _subscription = status;
        _isRestoring = false;
      });
      _showSnack(
        status.isPro ? 'Purchases restored.' : 'No purchases to restore.',
      );
    } on SubscriptionException catch (e) {
      if (!mounted) return;
      setState(() => _isRestoring = false);
      _showSnack(e.message);
    } catch (_) {
      if (!mounted) return;
      setState(() => _isRestoring = false);
      _showSnack('Could not restore purchases. Please try again.');
    }
  }

  @override
  Widget build(BuildContext context) {
    final double bottomSafe = MediaQuery.paddingOf(context).bottom;

    return Scaffold(
      backgroundColor: _pageBackground,
      appBar: AppBar(
        toolbarHeight: 48,
        title: const Text(
          'Plans',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w700,
            color: SavingorColors.darkGreen,
            letterSpacing: 0.15,
          ),
        ),
        centerTitle: false,
        elevation: 0,
        scrolledUnderElevation: 0,
        backgroundColor: _pageBackground,
        surfaceTintColor: Colors.transparent,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_new_rounded,
            color: SavingorColors.darkGreen,
            size: 20,
          ),
          onPressed: () => context.pop(),
        ),
      ),
      body: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints viewport) {
          return SingleChildScrollView(
            padding: EdgeInsets.fromLTRB(20, 4, 20, 12 + bottomSafe),
            child: ConstrainedBox(
              constraints: BoxConstraints(minHeight: viewport.maxHeight - 4),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  const _ProHeroHeader(),
                  const SizedBox(height: SavingorSpacing.md),
                  _PlanSelectorRow(isPro: _isPro),
                  const SizedBox(height: SavingorSpacing.md),
                  _FreeCompactCard(isCurrentPlan: !_isPro),
                  const SizedBox(height: SavingorSpacing.sm),
                  _ProMainCard(
                    isCurrentPlan: _isPro,
                    isDemoFallback: _subscription.isDemo,
                    isActivating: _isActivating,
                    onUpgrade: _onStartProSubscription,
                  ),
                  const SizedBox(height: SavingorSpacing.sm),
                  Center(
                    child: TextButton.icon(
                      onPressed: _isRestoring ? null : _onRestorePurchases,
                      style: TextButton.styleFrom(
                        foregroundColor: SavingorColors.textSecondary,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 14,
                          vertical: 10,
                        ),
                      ),
                      icon: const Icon(Icons.restore_rounded, size: 17),
                      label: Text(
                        _isRestoring ? 'Restoring...' : 'Restore purchases',
                        style: const TextStyle(
                          fontSize: 13.5,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class _ProHeroHeader extends StatelessWidget {
  const _ProHeroHeader();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(22, 20, 22, 22),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(26),
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: <Color>[
            Color(0xFFDAEFD4),
            Color(0xFFEEF8EB),
            Color(0xFFFFFFFF),
          ],
          stops: <double>[0.0, 0.42, 1.0],
        ),
        border: Border.all(
          color: SavingorColors.primaryStroke.withOpacity(0.28),
        ),
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: SavingorColors.darkGreen.withOpacity(0.1),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            children: <Widget>[
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 5),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.88),
                  borderRadius: BorderRadius.circular(SavingorRadius.pill),
                  border: Border.all(
                    color: SavingorColors.primaryStroke.withOpacity(0.3),
                  ),
                ),
                child: const Text(
                  'Free today • Pro when ready',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    color: SavingorColors.darkGreen,
                    letterSpacing: 0.12,
                  ),
                ),
              ),
              const Spacer(),
              Icon(
                Icons.auto_awesome_rounded,
                size: 22,
                color: SavingorColors.darkGreen.withOpacity(0.55),
              ),
            ],
          ),
          const SizedBox(height: SavingorSpacing.md),
          const Text(
            'Savingor Pro',
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w700,
              color: SavingorColors.primaryStroke,
              letterSpacing: 1.2,
              height: 1.2,
            ),
          ),
          const SizedBox(height: 6),
          const Text(
            'Save smarter with AI',
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.w800,
              color: SavingorColors.darkGreen,
              height: 1.08,
              letterSpacing: -0.2,
            ),
          ),
          const SizedBox(height: SavingorSpacing.sm),
          Text(
            'Unlock AI savings insights, receipt analytics, smart alerts, '
            'and deeper spending reports.',
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w500,
              color: SavingorColors.darkGreen.withOpacity(0.7),
              height: 1.38,
            ),
          ),
        ],
      ),
    );
  }
}

/// Visual segmented row reflecting the user's current plan.
class _PlanSelectorRow extends StatelessWidget {
  const _PlanSelectorRow({required this.isPro});

  final bool isPro;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: SavingorColors.primaryStroke.withOpacity(0.15),
        ),
        boxShadow: SavingorShadows.soft,
      ),
      child: Row(
        children: <Widget>[
          Expanded(
            child: _SelectorChip(
              label: 'Free',
              selected: !isPro,
            ),
          ),
          const SizedBox(width: 4),
          Expanded(
            child: _SelectorChip(
              label: 'Pro',
              selected: isPro,
            ),
          ),
        ],
      ),
    );
  }
}

class _SelectorChip extends StatelessWidget {
  const _SelectorChip({
    required this.label,
    required this.selected,
  });

  final String label;
  final bool selected;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 11),
      decoration: BoxDecoration(
        color: selected ? SavingorColors.primaryGreen : Colors.transparent,
        borderRadius: BorderRadius.circular(12),
        border: selected
            ? Border.all(
                color: SavingorColors.primaryStroke.withOpacity(0.45),
              )
            : null,
      ),
      alignment: Alignment.center,
      child: Text(
        label,
        style: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w700,
          color: selected
              ? SavingorColors.darkGreen
              : SavingorColors.textSecondary,
        ),
      ),
    );
  }
}

class _FreeCompactCard extends StatelessWidget {
  const _FreeCompactCard({required this.isCurrentPlan});

  final bool isCurrentPlan;

  static const List<String> _features = <String>[
    'Basic deals browsing',
    'Shopping list',
    'Manual expense tracking',
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFFE8EEEA)),
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: SavingorColors.darkGreen.withOpacity(0.03),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              const Text(
                'Free',
                style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w700,
                  color: SavingorColors.darkGreen,
                ),
              ),
              const SizedBox(width: SavingorSpacing.sm),
              const Text(
                '\$0',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                  color: SavingorColors.textSecondary,
                ),
              ),
              const Spacer(),
              if (isCurrentPlan)
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF3F4F6),
                    borderRadius: BorderRadius.circular(SavingorRadius.pill),
                    border: Border.all(color: const Color(0xFFE5E7EB)),
                  ),
                  child: const Text(
                    'Current plan',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: SavingorColors.textSecondary,
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: SavingorSpacing.sm),
          ..._features.map(
            (String feature) => Padding(
              padding: const EdgeInsets.only(bottom: 4),
              child: Row(
                children: <Widget>[
                  Icon(
                    Icons.check_rounded,
                    size: 14,
                    color: SavingorColors.primaryStroke.withOpacity(0.8),
                  ),
                  const SizedBox(width: 6),
                  Text(
                    feature,
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: SavingorColors.textSecondary,
                      height: 1.2,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ProMainCard extends StatelessWidget {
  const _ProMainCard({
    required this.isCurrentPlan,
    required this.isDemoFallback,
    required this.isActivating,
    required this.onUpgrade,
  });

  final bool isCurrentPlan;
  final bool isDemoFallback;
  final bool isActivating;
  final VoidCallback onUpgrade;

  static const List<String> _features = <String>[
    'AI Savings Assistant',
    'Receipt analytics',
    'Smart savings insights',
    'Spending reports',
    'Smart alerts',
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(20, 18, 20, 18),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: <Color>[
            Color(0xFFE4F3DE),
            Color(0xFFF4FBF1),
            Color(0xFFFFFFFF),
          ],
          stops: <double>[0.0, 0.35, 1.0],
        ),
        border: Border.all(
          color: SavingorColors.primaryStroke.withOpacity(0.55),
          width: 1.75,
        ),
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: SavingorColors.darkGreen.withOpacity(0.14),
            blurRadius: 22,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              const Expanded(
                child: Text(
                  'Pro',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w800,
                    color: SavingorColors.darkGreen,
                    height: 1.05,
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 5),
                decoration: BoxDecoration(
                  color: SavingorColors.primaryGreen,
                  borderRadius: BorderRadius.circular(SavingorRadius.pill),
                  border: Border.all(
                    color: SavingorColors.primaryStroke.withOpacity(0.5),
                  ),
                  boxShadow: <BoxShadow>[
                    BoxShadow(
                      color: SavingorColors.darkGreen.withOpacity(0.08),
                      blurRadius: 8,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: Text(
                  isCurrentPlan ? 'Current plan' : 'Best value',
                  style: const TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w800,
                    color: SavingorColors.darkGreen,
                    letterSpacing: 0.25,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          const Text.rich(
            TextSpan(
              style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.w800,
                color: SavingorColors.darkGreen,
                height: 1.05,
              ),
              children: <TextSpan>[
                TextSpan(text: '\$14.99'),
                TextSpan(
                  text: ' / month',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: SavingorColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: SavingorSpacing.sm),
          const Text(
            'AI-powered tools for smarter grocery savings.',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: SavingorColors.textSecondary,
              height: 1.35,
            ),
          ),
          const SizedBox(height: SavingorSpacing.md),
          ..._features.map(
            (String feature) => Padding(
              padding: const EdgeInsets.only(bottom: 6),
              child: Row(
                children: <Widget>[
                  Container(
                    width: 22,
                    height: 22,
                    decoration: BoxDecoration(
                      color: SavingorColors.primaryGreen.withOpacity(0.65),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.check_rounded,
                      size: 14,
                      color: SavingorColors.darkGreen,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      feature,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF1A2E24),
                        height: 1.25,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: SavingorSpacing.md),
          SizedBox(
            width: double.infinity,
            height: 52,
            child: isCurrentPlan
                ? OutlinedButton.icon(
                    onPressed: null,
                    style: OutlinedButton.styleFrom(
                      disabledForegroundColor: SavingorColors.darkGreen,
                      backgroundColor: Colors.white.withOpacity(0.6),
                      side: BorderSide(
                        color: SavingorColors.primaryStroke.withOpacity(0.5),
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18),
                      ),
                      textStyle: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    icon: const Icon(
                      Icons.check_circle_rounded,
                      size: 20,
                      color: SavingorColors.primaryStroke,
                    ),
                    label: const Text('Current plan'),
                  )
                : ElevatedButton(
                    onPressed: isActivating ? null : onUpgrade,
                    style: ElevatedButton.styleFrom(
                      elevation: 0,
                      shadowColor: Colors.transparent,
                      surfaceTintColor: Colors.transparent,
                      backgroundColor: SavingorColors.primaryGreen,
                      foregroundColor: SavingorColors.darkGreen,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18),
                        side: const BorderSide(
                          color: SavingorColors.primaryStroke,
                          width: 1,
                        ),
                      ),
                      textStyle: const TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 0.1,
                      ),
                    ),
                    child: isActivating
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: SavingorColors.darkGreen,
                            ),
                          )
                        : const Text('Start Pro subscription'),
                  ),
          ),
          if (isCurrentPlan && isDemoFallback) ...<Widget>[
            const SizedBox(height: 8),
            Center(
              child: Text(
                'Demo fallback active — no real payment processed.',
                style: TextStyle(
                  fontSize: 11.5,
                  fontWeight: FontWeight.w600,
                  color: SavingorColors.textSecondary.withOpacity(0.9),
                  letterSpacing: 0.1,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
