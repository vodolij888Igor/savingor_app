import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:savingor_app/core/app_settings_options.dart';
import 'package:savingor_app/core/app_state.dart';
import 'package:savingor_app/core/i18n/app_settings_l10n.dart';
import 'package:savingor_app/core/i18n/subscription_l10n.dart';
import 'package:savingor_app/core/theme/savingor_design_system.dart';
import 'package:savingor_app/core/widgets/savingor_interactive.dart';
import 'package:savingor_app/features/profile/data/user_profile_service.dart';
import 'package:savingor_app/features/subscription/data/subscription_service.dart';
import 'package:savingor_app/l10n/app_localizations.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final UserProfileService _userProfileService = UserProfileService();
  final SubscriptionService _subscriptionService = SubscriptionService();

  bool _isLoadingProfile = true;
  UserProfile? _profile;
  bool _profileLoadFailed = false;
  SubscriptionStatus _subscription = SubscriptionStatus.free;
  static const double _heroRadius = 24;
  static const double _cardRadius = 22;
  static const double _buttonRadius = 18;

  static const TextStyle _cardHeadingStyle = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.w800,
  );

  TextStyle _cardHeadingStyleFor(BuildContext context) =>
      _cardHeadingStyle.copyWith(
        color: context.savingor.brandHeading,
      );

  TextStyle _bodyMutedStyle(BuildContext context) => TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w500,
        color: context.savingor.textSecondary,
        height: 1.45,
      );

  @override
  void initState() {
    super.initState();
    _loadProfile();
    _loadSubscription();
  }

  Future<void> _loadSubscription() async {
    try {
      final SubscriptionStatus status =
          await _subscriptionService.getCurrentSubscription();
      if (!mounted) return;
      setState(() => _subscription = status);
    } catch (_) {
      // Keep last known state; the plan block degrades to Free display.
    }
  }

  Future<void> _loadProfile() async {
    setState(() {
      _isLoadingProfile = true;
      _profileLoadFailed = false;
    });

    try {
      final UserProfile? profile =
          await _userProfileService.fetchCurrentUserProfile();
      if (!mounted) return;
      setState(() {
        _profile = profile;
        _isLoadingProfile = false;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _profile = null;
        _isLoadingProfile = false;
        _profileLoadFailed = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final AppState appState = AppStateProvider.of(context);
    final AppLocalizations l10n = AppLocalizations.of(context);
    final double bottomInset = MediaQuery.paddingOf(context).bottom;

    return Scaffold(
      backgroundColor: context.savingor.pageBackground,
      appBar: AppBar(
        title: Text(
          l10n.profile,
          style: SavingorAppTextStyles.screenTitle(context),
        ),
        centerTitle: false,
        elevation: 0,
        scrolledUnderElevation: 0,
        backgroundColor: context.savingor.pageBackground,
        surfaceTintColor: Colors.transparent,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.fromLTRB(20, 6, 20, 28 + bottomInset + 72),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            _buildProfileHero(l10n),
            const SizedBox(height: SavingorSpacing.lg),
            _buildSavingsSnapshotRow(context, appState, l10n),
            const SizedBox(height: SavingorSpacing.lg),
            _headingCard(
              title: l10n.account,
              trailing: _buildEditAction(context, l10n),
              child: _buildAccountSection(l10n),
            ),
            const SizedBox(height: SavingorSpacing.lg),
            _headingCard(
              title: l10n.planAndSubscription,
              child: _buildPlanSection(context, l10n),
            ),
            const SizedBox(height: SavingorSpacing.lg),
            _headingCard(
              title: l10n.appSettings,
              child: _buildAppSettingsSection(context, appState, l10n),
            ),
            const SizedBox(height: SavingorSpacing.xl),
            _buildSignOutSection(context, appState, l10n),
          ],
        ),
      ),
    );
  }

  void _showSnack(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  Widget _primaryButton({
    required String label,
    required VoidCallback? onPressed,
  }) {
    return SavingorInteractiveFilledButton(
      onPressed: onPressed,
      width: double.infinity,
      borderRadius: BorderRadius.circular(_buttonRadius),
      child: Text(label),
    );
  }

  Widget _buildProfileHero(AppLocalizations l10n) {
    final String displayName = _profile != null && _profile!.fullName.isNotEmpty
        ? _profile!.fullName
        : l10n.yourAccount;
    final String? email =
        _profile != null && _profile!.email.isNotEmpty ? _profile!.email : null;
    final SavingorThemeExtension theme = context.savingor;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(24, 22, 24, 24),
      decoration: SavingorSurfaces.tabHeroCard(context, radius: _heroRadius),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
            decoration: BoxDecoration(
              color: context.savingor.surfacePrimary,
              borderRadius: BorderRadius.circular(SavingorRadius.pill),
              border: Border.all(
                color: SavingorColors.primaryStroke.withOpacity(0.28),
                width: 0.75,
              ),
              boxShadow: const <BoxShadow>[
                BoxShadow(
                  color: Color(0x0A4F9D47),
                  blurRadius: 6,
                  offset: Offset(0, 2),
                ),
              ],
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Icon(
                  _subscription.isPro
                      ? Icons.workspace_premium_rounded
                      : Icons.workspace_premium_outlined,
                  size: 14,
                  color: theme.brandTitle,
                ),
                const SizedBox(width: 5),
                Text(
                  _subscription.isPro ? l10n.proPlan : l10n.freePlan,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: theme.brandTitle,
                    letterSpacing: 0.15,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          // Initials avatar placeholder — soft glow + thin ring.
          Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              boxShadow: <BoxShadow>[
                BoxShadow(
                  color: SavingorColors.primaryStroke.withOpacity(0.22),
                  blurRadius: 18,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            child: Container(
              padding: const EdgeInsets.all(3),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: context.savingor.surfacePrimary,
                border: Border.all(
                  color: SavingorColors.primaryStroke.withOpacity(0.18),
                  width: 0.75,
                ),
              ),
              child: Container(
                width: 80,
                height: 80,
                alignment: Alignment.center,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: <Color>[
                      Color(0xFF8FD183),
                      Color(0xFF6FBE62),
                    ],
                  ),
                ),
                child: Text(
                  _initialsFor(displayName),
                  style: const TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.w800,
                    color: SavingorColors.deepGreen,
                    letterSpacing: 0.5,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 20),
          Text(
            displayName,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w800,
              color: context.savingor.textPrimary,
              height: 1.15,
              letterSpacing: -0.2,
            ),
          ),
          if (email != null) ...<Widget>[
            const SizedBox(height: 7),
            Text(
              email,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 13.5,
                fontWeight: FontWeight.w500,
                color: theme.textSecondary,
                height: 1.35,
              ),
            ),
          ],
          const SizedBox(height: 11),
          Text(
            l10n.readyToSaveSmarterToday,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: theme.brandTitle,
              letterSpacing: 0.2,
              height: 1.3,
            ),
          ),
        ],
      ),
    );
  }

  // Refined accents for the status card row — color lives in the icon badge.
  static const Color _regionAccent = Color(0xFF0E8074);
  static const Color _languageAccent = Color(0xFF4F9D47);
  static const Color _appearanceAccent = Color(0xFFC8861A);

  Widget _buildSavingsSnapshotRow(
    BuildContext context,
    AppState appState,
    AppLocalizations l10n,
  ) {
    return Row(
      children: <Widget>[
        Expanded(
          child: _snapshotChip(
            icon: Icons.public_rounded,
            label: l10n.region,
            value: AppSettingsL10n.regionLabel(context, appState.region),
            accent: _regionAccent,
          ),
        ),
        const SizedBox(width: SavingorSpacing.sm),
        Expanded(
          child: _snapshotChip(
            icon: Icons.translate_rounded,
            label: l10n.language,
            value: AppSettingsOptions.languageNativeName(appState.language),
            accent: _languageAccent,
          ),
        ),
        const SizedBox(width: SavingorSpacing.sm),
        Expanded(
          child: _snapshotChip(
            icon: Icons.light_mode_rounded,
            label: l10n.appearance,
            value:
                AppSettingsL10n.appearanceLabel(context, appState.appearance),
            accent: _appearanceAccent,
          ),
        ),
      ],
    );
  }

  Widget _snapshotChip({
    required IconData icon,
    required String label,
    required String value,
    required Color accent,
  }) {
    final SavingorThemeExtension theme = context.savingor;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 16),
      decoration: BoxDecoration(
        color: theme.isDark ? theme.surfaceElevated : theme.surfacePrimary,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: theme.border,
          width: 0.75,
        ),
        boxShadow: theme.cardShadow,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Icon(icon, size: 28, color: accent),
          const SizedBox(height: 10),
          Text(
            label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: context.savingor.textSecondary.withOpacity(0.92),
              letterSpacing: 0.2,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w800,
              color: context.savingor.textPrimary,
              height: 1.2,
              letterSpacing: -0.1,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAccountSection(AppLocalizations l10n) {
    if (_isLoadingProfile) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Row(
          children: <Widget>[
            const SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                color: SavingorAccentColors.savings,
              ),
            ),
            const SizedBox(width: 12),
            Text(
              l10n.loadingProfile,
              style: TextStyle(
                fontSize: 14,
                color: context.savingor.textSecondary,
              ),
            ),
          ],
        ),
      );
    }

    if (_profileLoadFailed) {
      return Container(
        width: double.infinity,
        padding: const EdgeInsets.all(SavingorSpacing.md),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.error.withOpacity(0.06),
          borderRadius: BorderRadius.circular(SavingorRadius.md),
          border: Border.all(
            color: Theme.of(context).colorScheme.error.withOpacity(0.22),
          ),
        ),
        child: Text(
          l10n.couldNotLoadProfile,
          style: TextStyle(
            color: Theme.of(context).colorScheme.error,
            fontSize: 14,
            height: 1.4,
          ),
        ),
      );
    }

    if (_profile == null) {
      return Text(
        l10n.noProfileFound,
        style: _bodyMutedStyle(context),
      );
    }

    return Column(
      children: <Widget>[
        _iconInfoRow(
          icon: Icons.person_outline_rounded,
          label: l10n.fullName,
          value: _displayValue(_profile!.fullName),
        ),
        _rowDivider(),
        _iconInfoRow(
          icon: Icons.mail_outline_rounded,
          label: l10n.email,
          value: _displayValue(_profile!.email),
        ),
        _rowDivider(),
        _iconInfoRow(
          icon: Icons.lock_outline_rounded,
          label: l10n.passwordAndSecurity,
          value: l10n.managePassword,
          isLast: true,
        ),
      ],
    );
  }

  Widget _buildEditAction(BuildContext context, AppLocalizations l10n) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () async {
          await context.push('/profile/edit');
          if (mounted) {
            _loadProfile();
          }
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Icon(
                Icons.edit_outlined,
                size: 15,
                color: context.savingor.brandTitle,
              ),
              const SizedBox(width: 5),
              Text(
                l10n.edit,
                style: TextStyle(
                  fontSize: 13.5,
                  fontWeight: FontWeight.w700,
                  color: context.savingor.brandTitle,
                  letterSpacing: 0.1,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPlanSection(BuildContext context, AppLocalizations l10n) {
    final bool isPro = _subscription.isPro;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        Row(
          children: <Widget>[
            Expanded(
              child: Text(
                l10n.currentPlan,
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                  color: context.savingor.textSecondary,
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: context.savingor.isDark
                    ? context.savingor.selectedHighlight
                    : SavingorAccentColors.savings.withOpacity(0.1),
                borderRadius: BorderRadius.circular(SavingorRadius.pill),
                border: Border.all(
                  color: context.savingor.isDark
                      ? context.savingor.accentGreen.withOpacity(0.35)
                      : SavingorAccentColors.savings.withOpacity(0.25),
                ),
              ),
              child: Text(
                isPro ? l10n.pro : l10n.free,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: context.savingor.isDark
                      ? context.savingor.brandTitle
                      : SavingorAccentColors.savings,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: SavingorSpacing.sm),
        Text(
          isPro ? l10n.pro : l10n.free,
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.w800,
            color: context.savingor.textPrimary,
            height: 1.15,
          ),
        ),
        const SizedBox(height: SavingorSpacing.md),
        if (isPro) ...<Widget>[
          _subscriptionDetailRow(
            l10n.status,
            SubscriptionL10n.statusLabelFromL10n(l10n, _subscription.status),
          ),
          _subscriptionDetailRow(
            l10n.provider,
            SubscriptionL10n.providerLabel(context, _subscription.provider),
          ),
          _subscriptionDetailRow(
            l10n.price,
            SubscriptionL10n.formatPricePerMonth(context, _subscription),
          ),
        ] else ...<Widget>[
          _subscriptionDetailRow(l10n.status, l10n.inactive),
          const SizedBox(height: 2),
          Text(
            l10n.freePlanUpgradeMessage,
            style: _bodyMutedStyle(context),
          ),
        ],
        const SizedBox(height: SavingorSpacing.lg),
        if (isPro) ...<Widget>[
          _primaryButton(
            label: l10n.manageSubscription,
            onPressed: () => _showManageSubscriptionSheet(context),
          ),
          const SizedBox(height: SavingorSpacing.xs),
          SavingorInteractiveTextButton(
            onPressed: () async {
              await context.push('/subscription');
              if (mounted) _loadSubscription();
            },
            foregroundColor: context.savingor.textSecondary,
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Text(
              l10n.viewPlans,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ] else ...<Widget>[
          _primaryButton(
            label: l10n.viewPlans,
            onPressed: () async {
              await context.push('/subscription');
              // Plan may change on the Plans screen (demo activation).
              if (mounted) _loadSubscription();
            },
          ),
          const SizedBox(height: SavingorSpacing.xs),
          SavingorInteractiveTextButton(
            onPressed: () => _showManageSubscriptionSheet(context),
            foregroundColor: context.savingor.textSecondary,
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Text(
              l10n.manageSubscription,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ],
    );
  }

  Future<void> _showManageSubscriptionSheet(BuildContext context) async {
    final AppLocalizations l10n = AppLocalizations.of(context);
    final bool isPro = _subscription.isPro;

    await showModalBottomSheet<void>(
      context: context,
      backgroundColor: context.savingor.isDark
          ? context.savingor.surfaceStrong
          : context.savingor.surfacePrimary,
      isScrollControlled: true,
      useSafeArea: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(26)),
      ),
      builder: (BuildContext sheetContext) {
        final double bottomSafe = MediaQuery.paddingOf(sheetContext).bottom;
        return SafeArea(
          top: false,
          child: SingleChildScrollView(
            padding: EdgeInsets.fromLTRB(24, 18, 24, 28 + bottomSafe),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Center(
                  child: Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: context.savingor.border,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  l10n.manageSubscription,
                  style: TextStyle(
                    fontSize: 19,
                    fontWeight: FontWeight.w800,
                    color: context.savingor.brandTitle,
                  ),
                ),
                const SizedBox(height: 16),
                if (isPro) ...<Widget>[
                  _subscriptionDetailRow(
                    l10n.subscriptionPlanLabel,
                    SubscriptionL10n.planLabel(context, _subscription.plan),
                  ),
                  _subscriptionDetailRow(
                    l10n.status,
                    SubscriptionL10n.statusLabelFromL10n(
                      l10n,
                      _subscription.status,
                    ),
                  ),
                  _subscriptionDetailRow(
                    l10n.price,
                    SubscriptionL10n.formatPricePerMonth(
                        context, _subscription),
                  ),
                  _subscriptionDetailRow(
                    l10n.provider,
                    SubscriptionL10n.providerLabel(
                        context, _subscription.provider),
                  ),
                  const SizedBox(height: 18),
                  if (_subscription.isRevenueCat) ...<Widget>[
                    Text(
                      l10n.subscriptionManagedByStore,
                      style: _bodyMutedStyle(context),
                    ),
                    const SizedBox(height: 14),
                    SizedBox(
                      width: double.infinity,
                      child: OutlinedButton(
                        onPressed: () async {
                          Navigator.of(sheetContext).pop();
                          await _openStoreSubscriptionManagement(l10n);
                        },
                        style: OutlinedButton.styleFrom(
                          foregroundColor: context.savingor.brandHeading,
                          side: BorderSide(
                            color:
                                SavingorColors.primaryStroke.withOpacity(0.45),
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          textStyle: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        child: Text(l10n.manageInAppStoreGooglePlay),
                      ),
                    ),
                  ] else
                    SizedBox(
                      width: double.infinity,
                      child: OutlinedButton(
                        onPressed: () async {
                          Navigator.of(sheetContext).pop();
                          await _cancelProDemo(l10n);
                        },
                        style: OutlinedButton.styleFrom(
                          foregroundColor: const Color(0xFFB45309),
                          side: const BorderSide(color: Color(0xFFE7D4B5)),
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          textStyle: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        child: Text(l10n.cancelProDemo),
                      ),
                    ),
                ] else ...<Widget>[
                  _subscriptionDetailRow(
                    l10n.subscriptionPlanLabel,
                    l10n.free,
                  ),
                  _subscriptionDetailRow(
                    l10n.status,
                    l10n.inactive,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    l10n.noActiveSubscription,
                    style: _bodyMutedStyle(context),
                  ),
                  const SizedBox(height: 18),
                  _primaryButton(
                    label: l10n.viewPlans,
                    onPressed: () async {
                      Navigator.of(sheetContext).pop();
                      await context.push('/subscription');
                      if (mounted) _loadSubscription();
                    },
                  ),
                ],
                const SizedBox(height: 6),
                Center(
                  child: TextButton.icon(
                    onPressed: () async {
                      Navigator.of(sheetContext).pop();
                      await _restorePurchases(l10n);
                    },
                    style: TextButton.styleFrom(
                      foregroundColor: context.savingor.textSecondary,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 10,
                      ),
                    ),
                    icon: const Icon(Icons.restore_rounded, size: 17),
                    label: Text(
                      l10n.restorePurchases,
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
    );
  }

  /// Opens the store subscription management page (App Store / Google Play)
  /// via the RevenueCat management URL. Real subscriptions are cancelled in
  /// the store — never by editing the Firestore mirror.
  Future<void> _openStoreSubscriptionManagement(AppLocalizations l10n) async {
    final String? url = await _subscriptionService.getManagementUrl();
    if (!mounted) return;

    if (url == null) {
      await _showManagementUrlUnavailableDialog(l10n);
      return;
    }

    final bool launched = await launchUrl(
      Uri.parse(url),
      mode: LaunchMode.externalApplication,
    );
    if (!launched && mounted) {
      _showSnack(l10n.couldNotOpenSubscriptionManagement);
    }
  }

  Future<void> _showManagementUrlUnavailableDialog(
    AppLocalizations l10n,
  ) async {
    await showDialog<void>(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          backgroundColor: context.savingor.surfacePrimary,
          surfaceTintColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(22),
          ),
          title: Text(
            l10n.managementNotAvailable,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w800,
              color: context.savingor.brandTitle,
            ),
          ),
          content: Text(
            l10n.managementUrlUnavailableMessage,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: context.savingor.textSecondary,
              height: 1.45,
            ),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(),
              style: TextButton.styleFrom(
                foregroundColor: context.savingor.brandHeading,
              ),
              child: Text(l10n.ok),
            ),
          ],
        );
      },
    );
  }

  Future<void> _restorePurchases(AppLocalizations l10n) async {
    if (!_subscriptionService.isRevenueCatConfigured) {
      _showSnack(l10n.paymentProviderNotConfiguredSnack);
      return;
    }
    try {
      final SubscriptionStatus status =
          await _subscriptionService.restorePurchases();
      if (!mounted) return;
      setState(() => _subscription = status);
      _showSnack(
        status.isPro ? l10n.purchaseRestored : l10n.noPurchasesFound,
      );
    } on SubscriptionException catch (e) {
      if (!mounted) return;
      _showSnack(SubscriptionL10n.localizeException(context, e));
    } catch (_) {
      if (!mounted) return;
      _showSnack(l10n.couldNotRestorePurchases);
    }
  }

  Widget _subscriptionDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        children: <Widget>[
          Expanded(
            child: Text(
              label,
              style: TextStyle(
                fontSize: 13.5,
                fontWeight: FontWeight.w500,
                color: context.savingor.textSecondary,
              ),
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: 14.5,
              fontWeight: FontWeight.w700,
              color: context.savingor.textPrimary,
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _cancelProDemo(AppLocalizations l10n) async {
    try {
      await _subscriptionService.cancelProDemoFallback();
      if (!mounted) return;
      setState(() => _subscription = SubscriptionStatus.free);
      _showSnack(l10n.proDemoCancelled);
    } on SubscriptionException catch (e) {
      if (!mounted) return;
      _showSnack(SubscriptionL10n.localizeException(context, e));
    } catch (_) {
      if (!mounted) return;
      _showSnack(l10n.couldNotCancelProDemo);
    }
  }

  Widget _buildAppSettingsSection(
    BuildContext context,
    AppState appState,
    AppLocalizations l10n,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        _iconInfoRow(
          icon: Icons.language_rounded,
          label: l10n.language,
          value: AppSettingsOptions.languageNativeName(appState.language),
        ),
        _rowDivider(),
        _iconInfoRow(
          icon: Icons.light_mode_rounded,
          label: l10n.appearance,
          value: AppSettingsL10n.appearanceLabel(context, appState.appearance),
        ),
        _rowDivider(),
        _iconInfoRow(
          icon: Icons.map_outlined,
          label: l10n.region,
          value: AppSettingsL10n.regionLabel(context, appState.region),
        ),
        _rowDivider(),
        _iconInfoRow(
          icon: Icons.attach_money_rounded,
          label: l10n.currency,
          value: appState.currency,
        ),
        _rowDivider(),
        _iconInfoRow(
          icon: Icons.notifications_none_rounded,
          label: l10n.notifications,
          value: l10n.comingSoon,
          valueMuted: true,
          isLast: true,
        ),
        const SizedBox(height: SavingorSpacing.lg),
        _primaryButton(
          label: l10n.manageSettings,
          onPressed: () => context.push('/profile/settings'),
        ),
      ],
    );
  }

  static const Color _signOutRed = Color(0xFFB42318);

  Widget _buildSignOutSection(
    BuildContext context,
    AppState appState,
    AppLocalizations l10n,
  ) {
    return OutlinedButton(
      onPressed: () => _confirmSignOut(context, appState, l10n),
      style: OutlinedButton.styleFrom(
        foregroundColor: _signOutRed,
        backgroundColor: context.savingor.isDark
            ? context.savingor.surfaceElevated
            : context.savingor.surfacePrimary,
        minimumSize: const Size.fromHeight(52),
        side: BorderSide(
          color: context.savingor.isDark
              ? context.savingor.destructive.withOpacity(0.45)
              : const Color(0xFFE8C7C2),
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(_buttonRadius),
        ),
        textStyle: const TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.w700,
          letterSpacing: 0.1,
        ),
      ),
      child: Text(l10n.signOut),
    );
  }

  Future<void> _confirmSignOut(
    BuildContext context,
    AppState appState,
    AppLocalizations l10n,
  ) async {
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
            l10n.signOutQuestion,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w800,
              color: context.savingor.brandTitle,
            ),
          ),
          content: Text(
            l10n.signOutMessage,
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
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(true),
              style: TextButton.styleFrom(foregroundColor: _signOutRed),
              child: Text(l10n.signOut),
            ),
          ],
        );
      },
    );

    if (confirmed != true || !mounted) return;

    // TODO(auth): Replace full startup reset with token-only logout when
    // authentication exists; then route via [createAppRouter.redirect] only.
    appState.resetStartupFlowToBeginning();
    if (mounted) {
      this.context.go('/mini-splash');
    }
  }

  Widget _headingCard({
    required String title,
    required Widget child,
    Widget? trailing,
  }) {
    return _cardShell(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            children: <Widget>[
              Expanded(
                child: Text(title, style: _cardHeadingStyleFor(context)),
              ),
              if (trailing != null) trailing,
            ],
          ),
          const SizedBox(height: SavingorSpacing.lg),
          child,
        ],
      ),
    );
  }

  Widget _cardShell({required Widget child}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 20),
      decoration: SavingorSurfaces.premiumCard(context, radius: _cardRadius),
      child: child,
    );
  }

  Widget _rowDivider() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Divider(
        height: 1,
        thickness: 1,
        color: context.savingor.border.withOpacity(0.5),
      ),
    );
  }

  Widget _iconInfoRow({
    required IconData icon,
    required String label,
    required String value,
    bool isLast = false,
    bool valueMuted = false,
  }) {
    return Padding(
      padding: EdgeInsets.only(bottom: isLast ? 0 : 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            width: 36,
            height: 36,
            decoration: SavingorSurfaces.accentIconBlock(
              accent: SavingorAccentColors.savings,
              radius: 12,
            ),
            child: Icon(
              icon,
              size: 18,
              color: SavingorAccentColors.savings,
            ),
          ),
          const SizedBox(width: SavingorSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: context.savingor.textSecondary,
                    height: 1.3,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: valueMuted
                        ? context.savingor.textSecondary
                        : context.savingor.textPrimary,
                    height: 1.35,
                    fontStyle: valueMuted ? FontStyle.italic : FontStyle.normal,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _initialsFor(String name) {
    final List<String> parts = name
        .trim()
        .split(RegExp(r'\s+'))
        .where((String part) => part.isNotEmpty)
        .toList();
    if (parts.isEmpty) {
      return '?';
    }
    if (parts.length == 1) {
      return parts.first[0].toUpperCase();
    }
    return '${parts.first[0]}${parts.last[0]}'.toUpperCase();
  }

  String _displayValue(String value) {
    if (value.isEmpty) {
      return '\u2014';
    }
    return value;
  }
}
