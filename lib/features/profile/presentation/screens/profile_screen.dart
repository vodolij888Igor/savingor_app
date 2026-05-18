import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:savingor_app/core/app_state.dart';
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
      appBar: AppBar(title: const Text('Profile')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            const Text(
              'Account',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 12),
            if (_isLoadingProfile)
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 8),
                child: Row(
                  children: <Widget>[
                    SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    ),
                    SizedBox(width: 12),
                    Text('Loading profile...'),
                  ],
                ),
              )
            else if (_profileError != null)
              Text(
                _profileError!,
                style: TextStyle(
                  color: Theme.of(context).colorScheme.error,
                  fontSize: 14,
                ),
              )
            else if (_profile == null)
              const Text(
                'No profile found for this account yet.',
                style: TextStyle(fontSize: 14),
              )
            else ...<Widget>[
              Text(
                'Full name: ${_displayValue(_profile!.fullName)}',
                style: const TextStyle(fontSize: 15),
              ),
              const SizedBox(height: 8),
              Text(
                'Email: ${_displayValue(_profile!.email)}',
                style: const TextStyle(fontSize: 15),
              ),
              const SizedBox(height: 8),
              Text(
                'Selected language: ${_displayValue(_profile!.selectedLanguage)}',
                style: const TextStyle(fontSize: 15),
              ),
            ],
            const SizedBox(height: 24),
            const Text(
              'App',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 12),
            Text('Language: $appLanguage'),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: () => context.go('/language'),
              child: const Text('Change language'),
            ),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: () {
                // TODO(auth): Replace full startup reset with token-only logout when
                // authentication exists; then route via [createAppRouter.redirect] only.
                appState.resetStartupFlowToBeginning();
                context.go('/mini-splash');
              },
              child: const Text('Sign out (reset start flow)'),
            ),
          ],
        ),
      ),
    );
  }

  String _displayValue(String value) {
    if (value.isEmpty) {
      return '—';
    }
    return value;
  }
}
