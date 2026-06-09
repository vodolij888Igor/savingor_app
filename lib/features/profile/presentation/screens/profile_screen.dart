import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:savingor_app/core/app_state.dart';
import 'package:savingor_app/core/theme/savingor_design_system.dart';
import 'package:savingor_app/core/widgets/savingor_interactive.dart';
import 'package:savingor_app/features/profile/data/user_profile_service.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final UserProfileService _userProfileService = UserProfileService();

  bool _isLoadingProfile = true;
  UserProfile? _profile;
  String? _profileError;

  static const Color _pageBackground = SavingorColors.pageWhite;
  static const Color _emailMuted = Color(0xFF64748B);
  static const double _heroRadius = 28;
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
    final String? email = _profile != null && _profile!.email.isNotEmpty
        ? _profile!.email
        : null;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(24, 28, 24, 26),
      decoration: SavingorSurfaces.profileHero(radius: _heroRadius),
      child: Column(
        children: <Widget>[
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.85),
              borderRadius: BorderRadius.circular(SavingorRadius.pill),
              border: Border.all(
                color: SavingorColors.primaryStroke.withOpacity(0.35),
              ),
            ),
            child: const Text(
              'Free plan',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w700,
                color: SavingorColors.primaryStroke,
                letterSpacing: 0.15,
              ),
            ),
          ),
          const SizedBox(height: SavingorSpacing.lg),
          DecoratedBox(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: Colors.white, width: 3),
              boxShadow: <BoxShadow>[
                BoxShadow(
                  color: SavingorColors.primaryStroke.withOpacity(0.22),
                  blurRadius: 16,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            child: CircleAvatar(
              radius: 44,
              backgroundColor: SavingorColors.primaryGreen,
              foregroundColor: SavingorColors.deepGreen,
              child: Text(
                _initialsFor(displayName),
                style: const TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 0.3,
                ),
              ),
            ),
          ),
          const SizedBox(height: SavingorSpacing.lg),
          Text(
            displayName,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 26,
              fontWeight: FontWeight.w800,
              color: SavingorColors.deepGreen,
              height: 1.15,
              letterSpacing: 0.1,
            ),
          ),
          if (email != null) ...<Widget>[
            const SizedBox(height: 8),
            Text(
              email,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: _emailMuted,
                height: 1.35,
              ),
            ),
          ],
          const SizedBox(height: SavingorSpacing.md),
          const Text(
            'Ready to save smarter today',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: SavingorColors.textSecondary,
              letterSpacing: 0.2,
              height: 1.3,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSavingsSnapshotRow(String appLanguage) {
    return Row(
      children: <Widget>[
        Expanded(
          child: _snapshotChip(
            icon: Icons.map_outlined,
            label: 'Region',
            value: 'Canada',
            accent: SavingorAccentColors.map,
          ),
        ),
        const SizedBox(width: SavingorSpacing.sm),
        Expanded(
          child: _snapshotChip(
            icon: Icons.translate_rounded,
            label: 'Language',
            value: appLanguage,
            accent: SavingorAccentColors.savings,
          ),
        ),
        const SizedBox(width: SavingorSpacing.sm),
        Expanded(
          child: _snapshotChip(
            icon: Icons.brightness_auto_rounded,
            label: 'Theme',
            value: 'System',
            accent: SavingorAccentColors.budget,
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
      padding: const EdgeInsets.symmetric(
        horizontal: SavingorSpacing.sm,
        vertical: SavingorSpacing.md + 2,
      ),
      decoration: SavingorSurfaces.premiumCard(radius: 16),
      child: Column(
        children: <Widget>[
          Container(
            width: 34,
            height: 34,
            decoration: SavingorSurfaces.accentIconBlock(
              accent: accent,
              radius: 10,
            ),
            child: Icon(icon, size: 18, color: accent),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: SavingorAppTextStyles.bodySecondary(fontSize: 11),
          ),
          const SizedBox(height: 2),
          Text(
            value,
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w700,
              color: SavingorColors.textPrimary,
              height: 1.2,
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
          icon: Icons.translate_rounded,
          label: 'Selected language',
          value: _displayValue(_profile!.selectedLanguage),
          isLast: true,
        ),
      ],
    );
  }

  Widget _buildPlanSection(BuildContext context) {
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
              child: const Text(
                'Free',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: SavingorAccentColors.savings,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: SavingorSpacing.sm),
        const Text(
          'Free',
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.w800,
            color: SavingorColors.textPrimary,
            height: 1.15,
          ),
        ),
        const SizedBox(height: SavingorSpacing.md),
        const Text(
          'Upgrade to unlock AI savings insights, receipt analytics, '
          'and smart alerts.',
          style: _bodyMutedStyle,
        ),
        const SizedBox(height: SavingorSpacing.lg),
        _primaryButton(
          label: 'View plans',
          onPressed: () => context.push('/subscription'),
        ),
        const SizedBox(height: SavingorSpacing.xs),
        SavingorInteractiveTextButton(
          onPressed: () => _showSnack(
            'Subscription management will be available soon.',
          ),
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
    );
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
          value: appLanguage,
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
  }) {
    return _cardShell(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(title, style: _cardHeadingStyle),
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
                    fontStyle:
                        valueMuted ? FontStyle.italic : FontStyle.normal,
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
