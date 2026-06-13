import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:savingor_app/core/i18n/subscription_l10n.dart';
import 'package:savingor_app/core/theme/savingor_design_system.dart';
import 'package:savingor_app/features/subscription/data/debug_subscription_override_store.dart';
import 'package:savingor_app/features/subscription/data/subscription_service.dart';
import 'package:savingor_app/features/subscription/domain/debug_subscription_override.dart';
import 'package:savingor_app/features/subscription/presentation/subscription_plan_presentation.dart';
import 'package:savingor_app/features/subscription/presentation/widgets/manage_subscription_bottom_sheet.dart';
import 'package:savingor_app/features/subscription/presentation/widgets/subscription_plan_primary_action.dart';
import 'package:savingor_app/l10n/app_localizations.dart';

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
  SubscriptionStatus _realSubscription = SubscriptionStatus.free;
  bool _isActivating = false;
  bool _isRestoring = false;
  DebugSubscriptionOverrideStore? _debugOverrideStore;

  bool get _isPro => _subscription.hasActiveProAccess;

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
      final List<SubscriptionStatus> statuses = await Future.wait(
        <Future<SubscriptionStatus>>[
          _subscriptionService.getCurrentSubscription(),
          _subscriptionService.getRealSubscription(),
        ],
      );
      if (!mounted) return;
      setState(() {
        _subscription = statuses[0];
        _realSubscription = statuses[1];
      });
    } catch (_) {
      // Keep showing Free state; purchasing will surface real errors.
    }
  }

  void _showSnack(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  void _showSubscriptionError(SubscriptionException error) {
    _showSnack(SubscriptionL10n.localizeException(context, error));
  }

  Future<void> _onStartProSubscription() async {
    if (_subscriptionService.isRevenueCatConfigured) {
      await _purchaseProMonthly();
    } else {
      await _showProviderNotConfiguredModal();
    }
  }

  Future<void> _purchaseProMonthly() async {
    setState(() => _isActivating = true);
    try {
      await _subscriptionService.purchaseProMonthly();
      if (!mounted) return;
      setState(() => _isActivating = false);
      _showSnack(AppLocalizations.of(context).proSubscriptionActivated);
      await _loadSubscription();
    } on SubscriptionException catch (e) {
      if (!mounted) return;
      setState(() => _isActivating = false);
      _showSubscriptionError(e);
    } catch (_) {
      if (!mounted) return;
      setState(() => _isActivating = false);
      _showSnack(AppLocalizations.of(context).couldNotCompletePurchase);
    }
  }

  Future<void> _showProviderNotConfiguredModal() async {
    final AppLocalizations l10n = AppLocalizations.of(context);
    final bool? confirmed = await showDialog<bool>(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          backgroundColor: context.savingor.surfacePrimary,
          surfaceTintColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(22),
          ),
          title: Text(
            l10n.subscriptionSetup,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w800,
              color: SavingorColors.darkGreen,
            ),
          ),
          content: Text(
            '${l10n.subscriptionSetupPrepared}\n\n'
            '${l10n.subscriptionSetupNotConfigured}',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: context.savingor.textSecondary,
              height: 1.45,
            ),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(false),
              style: TextButton.styleFrom(
                foregroundColor: context.savingor.textSecondary,
              ),
              child: Text(l10n.cancel),
            ),
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
              child: Text(l10n.activateProDemoForTesting),
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
      _showSnack(AppLocalizations.of(context).proDemoFallbackActivated);
      await _loadSubscription();
    } on SubscriptionException catch (e) {
      if (!mounted) return;
      setState(() => _isActivating = false);
      _showSubscriptionError(e);
    } catch (_) {
      if (!mounted) return;
      setState(() => _isActivating = false);
      _showSnack(AppLocalizations.of(context).couldNotActivateProDemo);
    }
  }

  Future<void> _onRestorePurchases() async {
    final AppLocalizations l10n = AppLocalizations.of(context);
    if (!_subscriptionService.isRevenueCatConfigured) {
      _showSnack(l10n.paymentProviderNotConfiguredSnack);
      return;
    }
    setState(() => _isRestoring = true);
    try {
      final SubscriptionStatus status =
          await _subscriptionService.restorePurchases();
      if (!mounted) return;
      setState(() => _isRestoring = false);
      await _loadSubscription();
      _showSnack(
        status.isPro ? l10n.purchaseRestored : l10n.noPurchasesFound,
      );
    } on SubscriptionException catch (e) {
      if (!mounted) return;
      setState(() => _isRestoring = false);
      _showSubscriptionError(e);
    } catch (_) {
      if (!mounted) return;
      setState(() => _isRestoring = false);
      _showSnack(l10n.couldNotRestorePurchases);
    }
  }

  Future<void> _onManageSubscription() async {
    await ManageSubscriptionBottomSheet.show(
      context,
      subscriptionService: _subscriptionService,
      realSubscription: _realSubscription,
      onSubscriptionChanged: _loadSubscription,
    );
  }

  @override
  Widget build(BuildContext context) {
    final AppLocalizations l10n = AppLocalizations.of(context);
    final double bottomSafe = MediaQuery.paddingOf(context).bottom;
    final DebugSubscriptionOverride? debugOverride = kDebugMode
        ? _debugOverrideStore?.override
        : DebugSubscriptionOverride.none;

    return Scaffold(
      backgroundColor: context.savingor.pageBackground,
      appBar: AppBar(
        toolbarHeight: 48,
        title: Text(
          l10n.plans,
          style: SavingorAppTextStyles.screenTitle(context),
        ),
        centerTitle: false,
        elevation: 0,
        scrolledUnderElevation: 0,
        backgroundColor: context.savingor.pageBackground,
        surfaceTintColor: Colors.transparent,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios_new_rounded,
            color: SavingorWorkflowTheme.appBarIcon(context),
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
                  _PlansHeroHeader(l10n: l10n),
                  if (debugOverride != null &&
                      debugOverride !=
                          DebugSubscriptionOverride.none) ...<Widget>[
                    const SizedBox(height: SavingorSpacing.sm),
                    _DebugOverrideBanner(
                      message: debugOverride == DebugSubscriptionOverride.free
                          ? l10n.debugSubscriptionOverrideFree
                          : l10n.debugSubscriptionOverridePro,
                    ),
                  ],
                  const SizedBox(height: SavingorSpacing.md),
                  _PlanSelectorRow(isPro: _isPro, l10n: l10n),
                  const SizedBox(height: SavingorSpacing.md),
                  _FreePlanCard(
                    isCurrentPlan: !_isPro,
                    l10n: l10n,
                  ),
                  const SizedBox(height: SavingorSpacing.sm),
                  _ProPlanCard(
                    isCurrentPlan: _isPro,
                    isDemoFallback: _subscription.isDemo,
                    l10n: l10n,
                  ),
                  const SizedBox(height: SavingorSpacing.md),
                  _PlanComparisonTable(l10n: l10n),
                  const SizedBox(height: SavingorSpacing.md),
                  SubscriptionPlanPrimaryAction(
                    isPro: _isPro,
                    isActivating: _isActivating,
                    onUpgrade: _onStartProSubscription,
                  ),
                  if (_isPro) ...<Widget>[
                    const SizedBox(height: SavingorSpacing.sm),
                    Center(
                      child: TextButton.icon(
                        onPressed: _onManageSubscription,
                        style: TextButton.styleFrom(
                          foregroundColor: context.savingor.textSecondary,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 14,
                            vertical: 10,
                          ),
                        ),
                        icon: const Icon(Icons.settings_outlined, size: 17),
                        label: Text(
                          l10n.manageSubscription,
                          style: const TextStyle(
                            fontSize: 13.5,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ],
                  const SizedBox(height: SavingorSpacing.xs),
                  Center(
                    child: TextButton.icon(
                      onPressed: _isRestoring ? null : _onRestorePurchases,
                      style: TextButton.styleFrom(
                        foregroundColor: context.savingor.textSecondary,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 14,
                          vertical: 10,
                        ),
                      ),
                      icon: const Icon(Icons.restore_rounded, size: 17),
                      label: Text(
                        _isRestoring ? l10n.restoring : l10n.restorePurchases,
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

class _PlansHeroHeader extends StatelessWidget {
  const _PlansHeroHeader({required this.l10n});

  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context) {
    final SavingorThemeExtension theme = context.savingor;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(22, 20, 22, 22),
      decoration: theme.isDark
          ? BoxDecoration(
              borderRadius: BorderRadius.circular(26),
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: <Color>[
                  theme.heroGradientStart,
                  theme.heroGradientMid,
                  theme.heroGradientEnd,
                ],
              ),
              border: Border.all(color: theme.accentGreen.withOpacity(0.22)),
              boxShadow: theme.cardShadow,
            )
          : BoxDecoration(
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
                padding:
                    const EdgeInsets.symmetric(horizontal: 11, vertical: 5),
                decoration: BoxDecoration(
                  color: theme.isDark
                      ? theme.surfaceElevated
                      : Colors.white.withOpacity(0.88),
                  borderRadius: BorderRadius.circular(SavingorRadius.pill),
                  border: Border.all(
                    color: theme.isDark
                        ? theme.accentGreen.withOpacity(0.35)
                        : SavingorColors.primaryStroke.withOpacity(0.3),
                  ),
                ),
                child: Text(
                  l10n.freeTodayProWhenReady,
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    color: theme.isDark
                        ? theme.brandTitle
                        : SavingorColors.darkGreen,
                    letterSpacing: 0.12,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: SavingorSpacing.md),
          Text(
            l10n.plansHeroTitle,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w800,
              color:
                  theme.isDark ? theme.textPrimary : SavingorColors.darkGreen,
              height: 1.12,
              letterSpacing: -0.2,
            ),
          ),
          const SizedBox(height: SavingorSpacing.sm),
          Text(
            l10n.plansHeroSubtitle,
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w500,
              color: theme.isDark
                  ? theme.textSecondary
                  : SavingorColors.darkGreen.withOpacity(0.7),
              height: 1.38,
            ),
          ),
        ],
      ),
    );
  }
}

class _DebugOverrideBanner extends StatelessWidget {
  const _DebugOverrideBanner({required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    final SavingorThemeExtension theme = context.savingor;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: theme.isDark ? theme.chipSurface : const Color(0xFFFFF7ED),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: theme.isDark
              ? const Color(0xFFB45309).withOpacity(0.45)
              : const Color(0xFFFED7AA),
        ),
      ),
      child: Row(
        children: <Widget>[
          Icon(
            Icons.bug_report_outlined,
            size: 18,
            color: theme.isDark
                ? const Color(0xFFFBBF24)
                : const Color(0xFFB45309),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              message,
              style: TextStyle(
                fontSize: 12.5,
                fontWeight: FontWeight.w600,
                color:
                    theme.isDark ? theme.textPrimary : const Color(0xFF92400E),
                height: 1.3,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _PlanSelectorRow extends StatelessWidget {
  const _PlanSelectorRow({
    required this.isPro,
    required this.l10n,
  });

  final bool isPro;
  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context) {
    final SavingorThemeExtension theme = context.savingor;

    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: theme.isDark ? theme.surfaceElevated : theme.surfacePrimary,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: theme.isDark
              ? theme.border.withOpacity(0.9)
              : SavingorColors.primaryStroke.withOpacity(0.15),
        ),
        boxShadow: SavingorShadows.soft(context),
      ),
      child: Row(
        children: <Widget>[
          Expanded(
            child: _SelectorChip(
              label: l10n.free,
              selected: !isPro,
            ),
          ),
          const SizedBox(width: 4),
          Expanded(
            child: _SelectorChip(
              label: l10n.pro,
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
    final SavingorThemeExtension theme = context.savingor;

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 11),
      decoration: BoxDecoration(
        color: selected
            ? (theme.isDark ? theme.accentGreen : SavingorColors.primaryGreen)
            : Colors.transparent,
        borderRadius: BorderRadius.circular(12),
        border: selected
            ? Border.all(
                color: theme.isDark
                    ? theme.accentGreen.withOpacity(0.45)
                    : SavingorColors.primaryStroke.withOpacity(0.45),
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
              ? (theme.isDark
                  ? theme.buttonLabelOnGreen
                  : SavingorColors.darkGreen)
              : theme.textSecondary,
        ),
      ),
    );
  }
}

class _FreePlanCard extends StatelessWidget {
  const _FreePlanCard({
    required this.isCurrentPlan,
    required this.l10n,
  });

  final bool isCurrentPlan;
  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context) {
    final SavingorThemeExtension theme = context.savingor;
    final List<String> features =
        SubscriptionPlanPresentation.freeIncludedFeatures(l10n);

    return _PlanCardShell(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          _PlanCardHeader(
            title: l10n.free,
            price: SubscriptionPlanPresentation.freePriceLabel(l10n),
            isCurrentPlan: isCurrentPlan,
            l10n: l10n,
          ),
          const SizedBox(height: 6),
          Text(
            l10n.planFreeSubtitle,
            style: TextStyle(
              fontSize: 13.5,
              fontWeight: FontWeight.w500,
              color: theme.textSecondary,
              height: 1.35,
            ),
          ),
          const SizedBox(height: SavingorSpacing.sm),
          Text(
            l10n.planIncludedFeaturesTitle,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w700,
              color: theme.isDark ? theme.brandTitle : SavingorColors.darkGreen,
              letterSpacing: 0.2,
            ),
          ),
          const SizedBox(height: 6),
          ...features.map(
            (String feature) => _PlanFeatureRow(label: feature),
          ),
        ],
      ),
    );
  }
}

class _ProPlanCard extends StatelessWidget {
  const _ProPlanCard({
    required this.isCurrentPlan,
    required this.isDemoFallback,
    required this.l10n,
  });

  final bool isCurrentPlan;
  final bool isDemoFallback;
  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context) {
    final SavingorThemeExtension theme = context.savingor;
    final List<String> activeFeatures =
        SubscriptionPlanPresentation.proActiveFeatures(l10n);
    final List<String> comingSoonFeatures =
        SubscriptionPlanPresentation.proComingSoonFeatures(l10n);

    return _PlanCardShell(
      highlighted: true,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          _PlanCardHeader(
            title: l10n.savingorPro,
            price: SubscriptionPlanPresentation.proPriceLabel(l10n),
            isCurrentPlan: isCurrentPlan,
            l10n: l10n,
            showBestValue: !isCurrentPlan,
          ),
          const SizedBox(height: 6),
          Text(
            l10n.planProSubtitle,
            style: TextStyle(
              fontSize: 13.5,
              fontWeight: FontWeight.w500,
              color: theme.textSecondary,
              height: 1.35,
            ),
          ),
          const SizedBox(height: SavingorSpacing.sm),
          Text(
            l10n.planProActiveFeaturesTitle,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w700,
              color: theme.isDark ? theme.brandTitle : SavingorColors.darkGreen,
              letterSpacing: 0.2,
            ),
          ),
          const SizedBox(height: 6),
          ...activeFeatures.map(
            (String feature) =>
                _PlanFeatureRow(label: feature, highlighted: true),
          ),
          const SizedBox(height: SavingorSpacing.sm),
          Text(
            l10n.planProComingSoonFeaturesTitle,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w700,
              color: theme.textSecondary,
              letterSpacing: 0.2,
            ),
          ),
          const SizedBox(height: 6),
          ...comingSoonFeatures.map(
            (String feature) => _PlanFeatureRow(
              label: feature,
              comingSoon: true,
            ),
          ),
          if (isCurrentPlan && isDemoFallback) ...<Widget>[
            const SizedBox(height: 8),
            Center(
              child: Text(
                l10n.demoFallbackActive,
                style: TextStyle(
                  fontSize: 11.5,
                  fontWeight: FontWeight.w600,
                  color: theme.textSecondary.withOpacity(0.9),
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

class _PlanCardShell extends StatelessWidget {
  const _PlanCardShell({
    required this.child,
    this.highlighted = false,
  });

  final Widget child;
  final bool highlighted;

  @override
  Widget build(BuildContext context) {
    final SavingorThemeExtension theme = context.savingor;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(18, 16, 18, 16),
      decoration: highlighted
          ? (theme.isDark
              ? BoxDecoration(
                  borderRadius: BorderRadius.circular(22),
                  color: theme.surfaceStrong,
                  border: Border.all(
                    color: theme.accentGreen.withOpacity(0.42),
                    width: 1.75,
                  ),
                  boxShadow: theme.cardShadow,
                )
              : BoxDecoration(
                  borderRadius: BorderRadius.circular(22),
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
                      color: SavingorColors.darkGreen.withOpacity(0.1),
                      blurRadius: 16,
                      offset: const Offset(0, 6),
                    ),
                  ],
                ))
          : BoxDecoration(
              color:
                  theme.isDark ? theme.surfaceElevated : theme.surfacePrimary,
              borderRadius: BorderRadius.circular(18),
              border: Border.all(
                color: theme.isDark
                    ? theme.border.withOpacity(0.9)
                    : const Color(0xFFE8EEEA),
              ),
              boxShadow: theme.isDark
                  ? theme.cardShadow
                  : <BoxShadow>[
                      BoxShadow(
                        color: SavingorColors.darkGreen.withOpacity(0.03),
                        blurRadius: 8,
                        offset: const Offset(0, 3),
                      ),
                    ],
            ),
      child: child,
    );
  }
}

class _PlanCardHeader extends StatelessWidget {
  const _PlanCardHeader({
    required this.title,
    required this.price,
    required this.isCurrentPlan,
    required this.l10n,
    this.showBestValue = false,
  });

  final String title;
  final String price;
  final bool isCurrentPlan;
  final AppLocalizations l10n;
  final bool showBestValue;

  @override
  Widget build(BuildContext context) {
    final SavingorThemeExtension theme = context.savingor;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                title,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w800,
                  color: theme.isDark
                      ? theme.textPrimary
                      : SavingorColors.darkGreen,
                  height: 1.05,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                price,
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w800,
                  color: theme.isDark
                      ? theme.brandTitle
                      : SavingorColors.darkGreen,
                  height: 1.05,
                ),
              ),
            ],
          ),
        ),
        if (isCurrentPlan)
          _PlanBadge(label: l10n.currentPlan, emphasized: true)
        else if (showBestValue)
          _PlanBadge(label: l10n.bestValue),
      ],
    );
  }
}

class _PlanBadge extends StatelessWidget {
  const _PlanBadge({
    required this.label,
    this.emphasized = false,
  });

  final String label;
  final bool emphasized;

  @override
  Widget build(BuildContext context) {
    final SavingorThemeExtension theme = context.savingor;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: emphasized
            ? (theme.isDark ? theme.chipSurface : const Color(0xFFF3F4F6))
            : (theme.isDark ? theme.accentGreen : SavingorColors.primaryGreen),
        borderRadius: BorderRadius.circular(SavingorRadius.pill),
        border: Border.all(
          color: emphasized
              ? (theme.isDark
                  ? theme.border.withOpacity(0.85)
                  : const Color(0xFFE5E7EB))
              : (theme.isDark
                  ? theme.accentGreen.withOpacity(0.45)
                  : SavingorColors.primaryStroke.withOpacity(0.5)),
        ),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w700,
          color: emphasized
              ? theme.textSecondary
              : (theme.isDark
                  ? theme.buttonLabelOnGreen
                  : SavingorColors.darkGreen),
          letterSpacing: 0.15,
        ),
      ),
    );
  }
}

class _PlanFeatureRow extends StatelessWidget {
  const _PlanFeatureRow({
    required this.label,
    this.highlighted = false,
    this.comingSoon = false,
  });

  final String label;
  final bool highlighted;
  final bool comingSoon;

  @override
  Widget build(BuildContext context) {
    final AppLocalizations l10n = AppLocalizations.of(context);
    final SavingorThemeExtension theme = context.savingor;

    return Padding(
      padding: const EdgeInsets.only(bottom: 5),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          if (comingSoon)
            Icon(
              Icons.schedule_rounded,
              size: 15,
              color: theme.textSecondary.withOpacity(0.85),
            )
          else
            Icon(
              Icons.check_rounded,
              size: 15,
              color: highlighted
                  ? (theme.isDark
                      ? theme.brandTitle
                      : SavingorColors.primaryStroke.withOpacity(0.85))
                  : theme.textSecondary.withOpacity(0.85),
            ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              label,
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w500,
                color: comingSoon
                    ? theme.textSecondary
                    : (theme.isDark
                        ? theme.textPrimary
                        : const Color(0xFF1A2E24)),
                height: 1.25,
              ),
            ),
          ),
          if (comingSoon)
            Padding(
              padding: const EdgeInsets.only(left: 6),
              child: Text(
                l10n.comingSoon,
                style: TextStyle(
                  fontSize: 10.5,
                  fontWeight: FontWeight.w700,
                  color: theme.isDark
                      ? theme.textSecondary
                      : const Color(0xFF6B7280),
                  letterSpacing: 0.15,
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _PlanComparisonTable extends StatelessWidget {
  const _PlanComparisonTable({required this.l10n});

  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context) {
    final SavingorThemeExtension theme = context.savingor;
    final List<PlanComparisonRow> rows =
        SubscriptionPlanPresentation.comparisonRows(l10n);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 14),
      decoration: BoxDecoration(
        color: theme.isDark ? theme.surfaceElevated : theme.surfacePrimary,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: theme.isDark
              ? theme.border.withOpacity(0.9)
              : const Color(0xFFE8EEEA),
        ),
        boxShadow:
            theme.isDark ? theme.cardShadow : SavingorShadows.soft(context),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            l10n.planComparisonTitle,
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w800,
              color:
                  theme.isDark ? theme.textPrimary : SavingorColors.darkGreen,
            ),
          ),
          const SizedBox(height: 10),
          Row(
            children: <Widget>[
              const Expanded(flex: 5, child: SizedBox()),
              Expanded(
                flex: 3,
                child: Text(
                  l10n.planColumnFree,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    color: theme.textSecondary,
                  ),
                ),
              ),
              Expanded(
                flex: 3,
                child: Text(
                  l10n.planColumnPro,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    color: theme.isDark
                        ? theme.brandTitle
                        : SavingorColors.primaryStroke,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          ...rows.map(
            (PlanComparisonRow row) => _ComparisonRow(row: row, l10n: l10n),
          ),
        ],
      ),
    );
  }
}

class _ComparisonRow extends StatelessWidget {
  const _ComparisonRow({
    required this.row,
    required this.l10n,
  });

  final PlanComparisonRow row;
  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context) {
    final SavingorThemeExtension theme = context.savingor;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Expanded(
            flex: 5,
            child: Text(
              row.featureLabel,
              style: TextStyle(
                fontSize: 12.5,
                fontWeight: FontWeight.w600,
                color:
                    theme.isDark ? theme.textPrimary : const Color(0xFF1A2E24),
                height: 1.25,
              ),
            ),
          ),
          Expanded(
            flex: 3,
            child: _ComparisonCell(
              label: SubscriptionPlanPresentation.availabilityLabel(
                l10n,
                row.freeAvailability,
              ),
              availability: row.freeAvailability,
            ),
          ),
          Expanded(
            flex: 3,
            child: _ComparisonCell(
              label: SubscriptionPlanPresentation.availabilityLabel(
                l10n,
                row.proAvailability,
              ),
              availability: row.proAvailability,
              emphasized: true,
            ),
          ),
        ],
      ),
    );
  }
}

class _ComparisonCell extends StatelessWidget {
  const _ComparisonCell({
    required this.label,
    required this.availability,
    this.emphasized = false,
  });

  final String label;
  final PlanComparisonAvailability availability;
  final bool emphasized;

  @override
  Widget build(BuildContext context) {
    final SavingorThemeExtension theme = context.savingor;
    final bool isLocked = availability == PlanComparisonAvailability.locked;
    final bool isPositive =
        availability == PlanComparisonAvailability.included ||
            availability == PlanComparisonAvailability.unlimited;

    return Text(
      label,
      textAlign: TextAlign.center,
      style: TextStyle(
        fontSize: 11.5,
        fontWeight: FontWeight.w700,
        color: isLocked
            ? theme.textSecondary.withOpacity(0.75)
            : (emphasized && isPositive
                ? (theme.isDark
                    ? theme.brandTitle
                    : SavingorColors.primaryStroke)
                : theme.textSecondary),
        height: 1.2,
      ),
    );
  }
}
