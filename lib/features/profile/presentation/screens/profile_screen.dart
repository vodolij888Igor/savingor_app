import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:savingor_app/core/app_state.dart';
import 'package:savingor_app/core/theme/savingor_design_system.dart';
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

  static const Color _pageBackground = Color(0xFFF8FCF7);
  static const Color _emailMuted = Color(0xFF6B8574);
  static const double _heroRadius = 24;
  static const double _cardRadius = 22;
  static const double _buttonRadius = 18;

  static const TextStyle _screenTitleStyle = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.w700,
    color: SavingorColors.darkGreen,
    letterSpacing: 0.2,
    height: 1.15,
  );

  static const TextStyle _sectionTitleStyle = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w700,
    color: SavingorColors.darkGreen,
    letterSpacing: 1.1,
    height: 1.2,
  );

  static const TextStyle _cardHeadingStyle = TextStyle(
    fontSize: 17,
    fontWeight: FontWeight.w700,
    color: SavingorColors.darkGreen,
    letterSpacing: 0.1,
    height: 1.2,
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

    return Scaffold(
      backgroundColor: _pageBackground,
      appBar: AppBar(
        title: const Text('Profile', style: _screenTitleStyle),
        centerTitle: false,
        elevation: 0,
        scrolledUnderElevation: 0,
        backgroundColor: _pageBackground,
        surfaceTintColor: Colors.transparent,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20, 6, 20, 32),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            _buildProfileHeader(),
            const SizedBox(height: 18),
            _sectionCard(
              title: 'ACCOUNT',
              child: _buildAccountSection(),
            ),
            const SizedBox(height: 18),
            _headingCard(
              title: 'Plan & subscription',
              child: _buildPlanSection(),
            ),
            const SizedBox(height: 18),
            _headingCard(
              title: 'App settings',
              child: _buildAppSettingsSection(
                context,
                appState,
                appLanguage,
              ),
            ),
            const SizedBox(height: 18),
            _headingCard(
              title: 'Savings preferences',
              child: _buildSavingsPreferencesSection(),
            ),
            const SizedBox(height: 18),
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

  Widget _buildProfileHeader() {
    final String displayName = _profile != null && _profile!.fullName.isNotEmpty
        ? _profile!.fullName
        : 'Your account';
    final String? subtitle = _profile != null && _profile!.email.isNotEmpty
        ? _profile!.email
        : null;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(24, 28, 24, 28),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(_heroRadius),
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: <Color>[
            Color(0xFFFFFFFF),
            Color(0xFFF2FAF0),
          ],
        ),
        border: Border.all(
          color: const Color(0xFFE3EFE0),
        ),
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: SavingorColors.darkGreen.withOpacity(0.07),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        children: <Widget>[
          DecoratedBox(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: Colors.white,
                width: 3,
              ),
              boxShadow: <BoxShadow>[
                BoxShadow(
                  color: SavingorColors.darkGreen.withOpacity(0.1),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: CircleAvatar(
              radius: 40,
              backgroundColor: SavingorColors.lightGreen,
              foregroundColor: SavingorColors.darkGreen,
              child: Text(
                _initialsFor(displayName),
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w700,
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
              fontSize: 23,
              fontWeight: FontWeight.w700,
              color: SavingorColors.darkGreen,
              height: 1.2,
              letterSpacing: 0.15,
            ),
          ),
          if (subtitle != null) ...<Widget>[
            const SizedBox(height: 8),
            Text(
              subtitle,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: _emailMuted,
                height: 1.35,
              ),
            ),
          ],
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
                color: SavingorColors.darkGreen,
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
        padding: const EdgeInsets.symmetric(
          horizontal: SavingorSpacing.md,
          vertical: SavingorSpacing.md,
        ),
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
        style: TextStyle(
          fontSize: 14,
          color: SavingorColors.textSecondary,
          height: 1.4,
        ),
      );
    }

    return Column(
      children: <Widget>[
        _infoRow('Full name', _displayValue(_profile!.fullName)),
        _rowDivider(),
        _infoRow('Email', _displayValue(_profile!.email)),
        _rowDivider(),
        _infoRow(
          'Selected language',
          _displayValue(_profile!.selectedLanguage),
          isLast: true,
        ),
      ],
    );
  }

  Widget _buildPlanSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            const Expanded(
              child: Text(
                'Current plan',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: SavingorColors.textSecondary,
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: SavingorColors.lightGreen,
                borderRadius: BorderRadius.circular(SavingorRadius.pill),
                border: Border.all(
                  color: SavingorColors.primaryStroke.withOpacity(0.35),
                ),
              ),
              child: const Text(
                'Free',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: SavingorColors.darkGreen,
                  letterSpacing: 0.2,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: SavingorSpacing.sm),
        const Text(
          'Free',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w700,
            color: SavingorColors.darkGreen,
            height: 1.2,
          ),
        ),
        const SizedBox(height: SavingorSpacing.md),
        const Text(
          'Upgrade later for AI savings insights, receipt analytics, '
          'and smart alerts.',
          style: _bodyMutedStyle,
        ),
        const SizedBox(height: SavingorSpacing.lg),
        SizedBox(
          width: double.infinity,
          height: 48,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              elevation: 0,
              shadowColor: Colors.transparent,
              surfaceTintColor: Colors.transparent,
              backgroundColor: SavingorColors.primaryGreen,
              foregroundColor: SavingorColors.darkGreen,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(_buttonRadius),
                side: const BorderSide(
                  color: SavingorColors.primaryStroke,
                  width: 1,
                ),
              ),
              textStyle: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w700,
              ),
            ),
            onPressed: () => _showSnack(
              'Subscription plans will be available soon.',
            ),
            child: const Text('View plans'),
          ),
        ),
        const SizedBox(height: SavingorSpacing.sm),
        TextButton(
          onPressed: () => _showSnack(
            'Subscription management will be available soon.',
          ),
          style: TextButton.styleFrom(
            foregroundColor: SavingorColors.darkGreen,
            padding: const EdgeInsets.symmetric(vertical: 8),
            textStyle: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
          child: const Text('Manage subscription'),
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
        _infoRow('Language', appLanguage),
        _rowDivider(),
        _infoRow('Theme', 'System'),
        _rowDivider(),
        _infoRow('Notifications', 'Coming soon', valueMuted: true),
        const SizedBox(height: SavingorSpacing.lg),
        SizedBox(
          width: double.infinity,
          height: 52,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              elevation: 0,
              shadowColor: Colors.transparent,
              surfaceTintColor: Colors.transparent,
              backgroundColor: SavingorColors.primaryGreen,
              foregroundColor: SavingorColors.darkGreen,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(_buttonRadius),
                side: const BorderSide(
                  color: SavingorColors.primaryStroke,
                  width: 1,
                ),
              ),
              textStyle: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                letterSpacing: 0.15,
              ),
            ),
            onPressed: () => context.go('/language'),
            child: const Text('Change language'),
          ),
        ),
      ],
    );
  }

  Widget _buildSavingsPreferencesSection() {
    return Column(
      children: <Widget>[
        _infoRow('Region', 'Canada'),
        _rowDivider(),
        _infoRow('Currency', 'CAD'),
        _rowDivider(),
        _infoRow('Monthly savings goal', '\$100'),
        _rowDivider(),
        _infoRow(
          'Favorite stores',
          'Walmart, Costco, Superstore',
          isLast: true,
        ),
      ],
    );
  }

  Widget _buildSignOutSection(BuildContext context, AppState appState) {
    return SizedBox(
      width: double.infinity,
      height: 50,
      child: OutlinedButton(
        style: OutlinedButton.styleFrom(
          elevation: 0,
          backgroundColor: Colors.white,
          foregroundColor: _emailMuted,
          side: BorderSide(
            color: SavingorColors.border.withOpacity(0.85),
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(_buttonRadius),
          ),
          textStyle: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.1,
          ),
        ),
        onPressed: () {
          // TODO(auth): Replace full startup reset with token-only logout when
          // authentication exists; then route via [createAppRouter.redirect] only.
          appState.resetStartupFlowToBeginning();
          context.go('/mini-splash');
        },
        child: const Text('Sign out (reset start flow)'),
      ),
    );
  }

  Widget _sectionCard({
    required String title,
    required Widget child,
  }) {
    return _cardShell(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(title, style: _sectionTitleStyle),
          const SizedBox(height: SavingorSpacing.lg),
          child,
        ],
      ),
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
      padding: const EdgeInsets.fromLTRB(22, 22, 22, 22),
      decoration: BoxDecoration(
        color: SavingorColors.card,
        borderRadius: BorderRadius.circular(_cardRadius),
        border: Border.all(
          color: const Color(0xFFE8EEEA),
        ),
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: SavingorColors.darkGreen.withOpacity(0.05),
            blurRadius: 14,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: child,
    );
  }

  Widget _rowDivider() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Divider(
        height: 1,
        thickness: 1,
        color: SavingorColors.border.withOpacity(0.55),
      ),
    );
  }

  Widget _infoRow(
    String label,
    String value, {
    bool isLast = false,
    bool valueMuted = false,
  }) {
    return Padding(
      padding: EdgeInsets.only(bottom: isLast ? 0 : 2),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Expanded(
            flex: 2,
            child: Text(
              label,
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: SavingorColors.textSecondary,
                height: 1.4,
                letterSpacing: 0.1,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            flex: 3,
            child: Text(
              value,
              textAlign: TextAlign.end,
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w600,
                color: valueMuted
                    ? SavingorColors.textSecondary
                    : const Color(0xFF1F2937),
                height: 1.35,
                fontStyle:
                    valueMuted ? FontStyle.italic : FontStyle.normal,
              ),
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
