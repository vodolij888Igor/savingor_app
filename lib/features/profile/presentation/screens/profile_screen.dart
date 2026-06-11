import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:savingor_app/core/app_state.dart';
import 'package:savingor_app/core/theme/savingor_design_system.dart';
import 'package:savingor_app/core/widgets/savingor_interactive.dart';
import 'package:savingor_app/features/profile/data/user_profile_service.dart';
import 'package:savingor_app/features/subscription/data/subscription_service.dart';

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
  String? _profileError;
  SubscriptionStatus _subscription = SubscriptionStatus.free;

  static const Color _pageBackground = SavingorColors.pageWhite;
  static const Color _emailMuted = Color(0xFF64748B);
  static const double _heroRadius = 24;
  static const double _cardRadius = 22;
  static const double _buttonRadius = 18;

  static const TextStyle _cardHeadingStyle = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.w800,
    color: SavingorColors.darkGreen,
  );

  static const TextStyle _bodyMutedStyle = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w500,
    color: SavingorColors.textSecondary,
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
      _profileError = null;
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
        _profileError = 'Could not load your profile. Please try again.';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final AppState appState = AppStateProvider.of(context);
    final String appLanguage = appState.language ?? 'not set';
    final double bottomInset = MediaQuery.paddingOf(context).bottom;

    return Scaffold(
      backgroundColor: _pageBackground,
      appBar: AppBar(
        title: const Text(
          'Profile',
          style: SavingorAppTextStyles.screenTitle,
        ),
        centerTitle: false,
        elevation: 0,
        scrolledUnderElevation: 0,
        backgroundColor: _pageBackground,
        surfaceTintColor: Colors.transparent,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.fromLTRB(20, 6, 20, 28 + bottomInset + 72),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            _buildProfileHero(),
            const SizedBox(height: SavingorSpacing.lg),
            _buildSavingsSnapshotRow(appLanguage),
            const SizedBox(height: SavingorSpacing.lg),
            _headingCard(
              title: 'Account',
              trailing: _buildEditAction(context),
              child: _buildAccountSection(),
            ),
            const SizedBox(height: SavingorSpacing.lg),
            _headingCard(
              title: 'Plan & subscription',
              child: _buildPlanSection(context),
            ),
            const SizedBox(height: SavingorSpacing.lg),
            _headingCard(
              title: 'App settings',
              child: _buildAppSettingsSection(
                context,
                appState,
                appLanguage,
              ),
            ),
            const SizedBox(height: SavingorSpacing.lg),
            _headingCard(
              title: 'Savings preferences',
              child: _buildSavingsPreferencesSection(),
            ),
            const SizedBox(height: SavingorSpacing.xl),
            _buildSignOutSection(context, appState),
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

  Widget _buildProfileHero() {
    final String displayName = _profile != null && _profile!.fullName.isNotEmpty
        ? _profile!.fullName
        : 'Your account';
    final String? email =
        _profile != null && _profile!.email.isNotEmpty ? _profile!.email : null;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(24, 22, 24, 24),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(_heroRadius),
        // Symmetrical top-to-bottom gradient — no off-center shapes.
        gradient: const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: <Color>[
            Color(0xFFF2FAF4),
            Color(0xFFFAFAF5),
          ],
        ),
        border: Border.all(
          color: SavingorColors.primaryStroke.withOpacity(0.14),
          width: 0.75,
        ),
        boxShadow: const <BoxShadow>[
          BoxShadow(
            color: Color(0x0F4F9D47),
            blurRadius: 20,
            offset: Offset(0, 7),
          ),
          BoxShadow(
            color: Color(0x06000000),
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
            decoration: BoxDecoration(
              color: Colors.white,
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
                  color: SavingorColors.darkGreen,
                ),
                const SizedBox(width: 5),
                Text(
                  _subscription.isPro ? 'Pro plan' : 'Free plan',
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: SavingorColors.darkGreen,
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
                color: Colors.white,
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
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w800,
              color: Color(0xFF1F2937),
              height: 1.15,
              letterSpacing: -0.2,
            ),
          ),
          if (email != null) ...<Widget>[
            const SizedBox(height: 7),
            Text(
              email,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 13.5,
                fontWeight: FontWeight.w500,
                color: _emailMuted,
                height: 1.35,
              ),
            ),
          ],
          const SizedBox(height: 11),
          const Text(
            'Ready to save smarter today',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: SavingorColors.primaryStroke,
              letterSpacing: 0.2,
              height: 1.3,
            ),
          ),
        ],
      ),
    );
  }

  /// Readable display names for stored language codes — never show raw codes.
  static const Map<String, String> _languageDisplayNames = <String, String>{
    'en': 'English',
    'uk': 'Ukrainian',
    'ru': 'Russian',
    'es': 'Spanish',
    'de': 'German',
    'fr': 'French',
    'pl': 'Polish',
  };

  static String _languageDisplayName(String? code) {
    if (code == null) return 'English';
    final String normalized = code.trim().toLowerCase();
    if (normalized.isEmpty) return 'English';
    return _languageDisplayNames[normalized] ?? code;
  }

  // Refined accents for the status card row — color lives in the icon badge.
  static const Color _regionAccent = Color(0xFF0E8074);
  static const Color _languageAccent = Color(0xFF4F9D47);
  static const Color _appearanceAccent = Color(0xFFC8861A);

  Widget _buildSavingsSnapshotRow(String appLanguage) {
    return Row(
      children: <Widget>[
        Expanded(
          child: _snapshotChip(
            icon: Icons.public_rounded,
            label: 'Region',
            value: 'Canada',
            accent: _regionAccent,
          ),
        ),
        const SizedBox(width: SavingorSpacing.sm),
        Expanded(
          child: _snapshotChip(
            icon: Icons.translate_rounded,
            label: 'Language',
            value: _languageDisplayName(appLanguage),
            accent: _languageAccent,
          ),
        ),
        const SizedBox(width: SavingorSpacing.sm),
        Expanded(
          child: _snapshotChip(
            icon: Icons.light_mode_rounded,
            label: 'Appearance',
            value: 'Light',
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
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: const Color(0xFFE3EAE4),
          width: 0.75,
        ),
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: accent.withOpacity(0.07),
            blurRadius: 14,
            offset: const Offset(0, 5),
          ),
          const BoxShadow(
            color: Color(0x0A000000),
            blurRadius: 6,
            offset: Offset(0, 2),
          ),
        ],
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
              color: SavingorColors.textSecondary.withOpacity(0.92),
              letterSpacing: 0.2,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w800,
              color: Color(0xFF1F2937),
              height: 1.2,
              letterSpacing: -0.1,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAccountSection() {
    if (_isLoadingProfile) {
      return const Padding(
        padding: EdgeInsets.symmetric(vertical: 8),
        child: Row(
          children: <Widget>[
            SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                color: SavingorAccentColors.savings,
              ),
            ),
            SizedBox(width: 12),
            Text(
              'Loading profile...',
              style: TextStyle(
                fontSize: 14,
                color: SavingorColors.textSecondary,
              ),
            ),
          ],
        ),
      );
    }

    if (_profileError != null) {
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
          _profileError!,
          style: TextStyle(
            color: Theme.of(context).colorScheme.error,
            fontSize: 14,
            height: 1.4,
          ),
        ),
      );
    }

    if (_profile == null) {
      return const Text(
        'No profile found for this account yet.',
        style: _bodyMutedStyle,
      );
    }

    return Column(
      children: <Widget>[
        _iconInfoRow(
          icon: Icons.person_outline_rounded,
          label: 'Full name',
          value: _displayValue(_profile!.fullName),
        ),
        _rowDivider(),
        _iconInfoRow(
          icon: Icons.mail_outline_rounded,
          label: 'Email',
          value: _displayValue(_profile!.email),
        ),
        _rowDivider(),
        _iconInfoRow(
          icon: Icons.lock_outline_rounded,
          label: 'Password & security',
          value: 'Manage password',
          isLast: true,
        ),
      ],
    );
  }

  Widget _buildEditAction(BuildContext context) {
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
        child: const Padding(
          padding: EdgeInsets.symmetric(horizontal: 10, vertical: 6),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Icon(
                Icons.edit_outlined,
                size: 15,
                color: SavingorColors.darkGreen,
              ),
              SizedBox(width: 5),
              Text(
                'Edit',
                style: TextStyle(
                  fontSize: 13.5,
                  fontWeight: FontWeight.w700,
                  color: SavingorColors.darkGreen,
                  letterSpacing: 0.1,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPlanSection(BuildContext context) {
    final bool isPro = _subscription.isPro;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        Row(
          children: <Widget>[
            const Expanded(
              child: Text(
                'Current plan',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                  color: SavingorColors.textSecondary,
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: SavingorAccentColors.savings.withOpacity(0.1),
                borderRadius: BorderRadius.circular(SavingorRadius.pill),
                border: Border.all(
                  color: SavingorAccentColors.savings.withOpacity(0.25),
                ),
              ),
              child: Text(
                isPro ? 'Pro' : 'Free',
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: SavingorAccentColors.savings,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: SavingorSpacing.sm),
        Text(
          isPro ? 'Pro' : 'Free',
          style: const TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.w800,
            color: SavingorColors.textPrimary,
            height: 1.15,
          ),
        ),
        const SizedBox(height: SavingorSpacing.md),
        if (isPro) ...<Widget>[
          _subscriptionDetailRow('Status', _subscription.statusLabel),
          _subscriptionDetailRow('Provider', _subscription.providerLabel),
          _subscriptionDetailRow('Price', '\$14.99 / month'),
        ] else ...<Widget>[
          _subscriptionDetailRow('Status', 'Inactive'),
          const SizedBox(height: 2),
          const Text(
            'You are currently on the Free plan. Upgrade to Pro to unlock '
            'AI savings insights, receipt analytics, smart alerts, and '
            'spending reports.',
            style: _bodyMutedStyle,
          ),
        ],
        const SizedBox(height: SavingorSpacing.lg),
        if (isPro) ...<Widget>[
          _primaryButton(
            label: 'Manage subscription',
            onPressed: () => _showManageSubscriptionSheet(context),
          ),
          const SizedBox(height: SavingorSpacing.xs),
          SavingorInteractiveTextButton(
            onPressed: () async {
              await context.push('/subscription');
              if (mounted) _loadSubscription();
            },
            foregroundColor: SavingorColors.textSecondary,
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: const Text(
              'View plans',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ] else ...<Widget>[
          _primaryButton(
            label: 'View plans',
            onPressed: () async {
              await context.push('/subscription');
              // Plan may change on the Plans screen (demo activation).
              if (mounted) _loadSubscription();
            },
          ),
          const SizedBox(height: SavingorSpacing.xs),
          SavingorInteractiveTextButton(
            onPressed: () => _showManageSubscriptionSheet(context),
            foregroundColor: SavingorColors.textSecondary,
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: const Text(
              'Manage subscription',
              style: TextStyle(
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
    final bool isPro = _subscription.isPro;

    await showModalBottomSheet<void>(
      context: context,
      backgroundColor: Colors.white,
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
                      color: SavingorColors.border,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                const Text(
                  'Manage subscription',
                  style: TextStyle(
                    fontSize: 19,
                    fontWeight: FontWeight.w800,
                    color: SavingorColors.darkGreen,
                  ),
                ),
                const SizedBox(height: 16),
                if (isPro) ...<Widget>[
                  _subscriptionDetailRow('Plan', 'Pro'),
                  _subscriptionDetailRow('Status', _subscription.statusLabel),
                  _subscriptionDetailRow('Price', '\$14.99 / month'),
                  _subscriptionDetailRow(
                      'Provider', _subscription.providerLabel),
                  const SizedBox(height: 18),
                  if (_subscription.isRevenueCat) ...<Widget>[
                    const Text(
                      'Your subscription is managed by App Store or Google '
                      'Play. You can cancel or update it from your store '
                      'subscription settings.',
                      style: _bodyMutedStyle,
                    ),
                    const SizedBox(height: 14),
                    SizedBox(
                      width: double.infinity,
                      child: OutlinedButton(
                        onPressed: () async {
                          Navigator.of(sheetContext).pop();
                          await _openStoreSubscriptionManagement();
                        },
                        style: OutlinedButton.styleFrom(
                          foregroundColor: SavingorColors.darkGreen,
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
                        child: const Text('Manage in App Store / Google Play'),
                      ),
                    ),
                  ] else
                    SizedBox(
                      width: double.infinity,
                      child: OutlinedButton(
                        onPressed: () async {
                          Navigator.of(sheetContext).pop();
                          await _cancelProDemo();
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
                        child: const Text('Cancel Pro demo'),
                      ),
                    ),
                ] else ...<Widget>[
                  _subscriptionDetailRow('Plan', 'Free'),
                  _subscriptionDetailRow('Status', 'Inactive'),
                  const SizedBox(height: 4),
                  const Text(
                    'No active subscription.',
                    style: _bodyMutedStyle,
                  ),
                  const SizedBox(height: 18),
                  _primaryButton(
                    label: 'View plans',
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
                      await _restorePurchases();
                    },
                    style: TextButton.styleFrom(
                      foregroundColor: SavingorColors.textSecondary,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 10,
                      ),
                    ),
                    icon: const Icon(Icons.restore_rounded, size: 17),
                    label: const Text(
                      'Restore purchases',
                      style: TextStyle(
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
  Future<void> _openStoreSubscriptionManagement() async {
    final String? url = await _subscriptionService.getManagementUrl();
    if (!mounted) return;

    if (url == null) {
      await _showManagementUrlUnavailableDialog();
      return;
    }

    final bool launched = await launchUrl(
      Uri.parse(url),
      mode: LaunchMode.externalApplication,
    );
    if (!launched && mounted) {
      _showSnack('Could not open the subscription management page.');
    }
  }

  Future<void> _showManagementUrlUnavailableDialog() async {
    await showDialog<void>(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          backgroundColor: Colors.white,
          surfaceTintColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(22),
          ),
          title: const Text(
            'Management not available',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w800,
              color: SavingorColors.darkGreen,
            ),
          ),
          content: const Text(
            'Subscription management URL is not available in this test '
            'build. For RevenueCat Test Store purchases, reset the test '
            'customer in RevenueCat dashboard or use a new test user.',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: SavingorColors.textSecondary,
              height: 1.45,
            ),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(),
              style: TextButton.styleFrom(
                foregroundColor: SavingorColors.darkGreen,
              ),
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _restorePurchases() async {
    if (!_subscriptionService.isRevenueCatConfigured) {
      _showSnack('Payment provider is not configured in this local build.');
      return;
    }
    try {
      final SubscriptionStatus status =
          await _subscriptionService.restorePurchases();
      if (!mounted) return;
      setState(() => _subscription = status);
      _showSnack(
        status.isPro ? 'Purchases restored.' : 'No purchases to restore.',
      );
    } on SubscriptionException catch (e) {
      if (!mounted) return;
      _showSnack(e.message);
    } catch (_) {
      if (!mounted) return;
      _showSnack('Could not restore purchases. Please try again.');
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
              style: const TextStyle(
                fontSize: 13.5,
                fontWeight: FontWeight.w500,
                color: SavingorColors.textSecondary,
              ),
            ),
          ),
          Text(
            value,
            style: const TextStyle(
              fontSize: 14.5,
              fontWeight: FontWeight.w700,
              color: Color(0xFF1A2E24),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _cancelProDemo() async {
    try {
      await _subscriptionService.cancelProDemoFallback();
      if (!mounted) return;
      setState(() => _subscription = SubscriptionStatus.free);
      _showSnack('Pro demo cancelled. You are back on the Free plan.');
    } on SubscriptionException catch (e) {
      if (!mounted) return;
      _showSnack(e.message);
    } catch (_) {
      if (!mounted) return;
      _showSnack('Could not cancel Pro demo. Please try again.');
    }
  }

  Widget _buildAppSettingsSection(
    BuildContext context,
    AppState appState,
    String appLanguage,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        _iconInfoRow(
          icon: Icons.language_rounded,
          label: 'Language',
          value: _languageDisplayName(appLanguage),
        ),
        _rowDivider(),
        _iconInfoRow(
          icon: Icons.brightness_auto_rounded,
          label: 'Theme',
          value: 'System',
        ),
        _rowDivider(),
        _iconInfoRow(
          icon: Icons.notifications_none_rounded,
          label: 'Notifications',
          value: 'Coming soon',
          valueMuted: true,
          isLast: true,
        ),
        const SizedBox(height: SavingorSpacing.lg),
        _primaryButton(
          label: 'Change language',
          onPressed: () => context.go('/language'),
        ),
      ],
    );
  }

  Widget _buildSavingsPreferencesSection() {
    return Column(
      children: <Widget>[
        _iconInfoRow(
          icon: Icons.map_outlined,
          label: 'Region',
          value: 'Canada',
        ),
        _rowDivider(),
        _iconInfoRow(
          icon: Icons.attach_money_rounded,
          label: 'Currency',
          value: 'CAD',
        ),
        _rowDivider(),
        _iconInfoRow(
          icon: Icons.flag_outlined,
          label: 'Monthly savings goal',
          value: '\$100',
        ),
        _rowDivider(),
        _iconInfoRow(
          icon: Icons.storefront_outlined,
          label: 'Favorite stores',
          value: 'Walmart, Costco, Superstore',
          isLast: true,
        ),
      ],
    );
  }

  Widget _buildSignOutSection(BuildContext context, AppState appState) {
    return _primaryButton(
      label: 'Sign out (reset start flow)',
      onPressed: () {
        // TODO(auth): Replace full startup reset with token-only logout when
        // authentication exists; then route via [createAppRouter.redirect] only.
        appState.resetStartupFlowToBeginning();
        context.go('/mini-splash');
      },
    );
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
                child: Text(title, style: _cardHeadingStyle),
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
      decoration: SavingorSurfaces.premiumCard(radius: _cardRadius),
      child: child,
    );
  }

  Widget _rowDivider() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Divider(
        height: 1,
        thickness: 1,
        color: SavingorColors.border.withOpacity(0.5),
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
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: SavingorColors.textSecondary,
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
                        ? SavingorColors.textSecondary
                        : const Color(0xFF1A2E24),
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
