import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:savingor_app/core/theme/savingor_design_system.dart';
import 'package:savingor_app/core/widgets/savingor_interactive.dart';
import 'package:savingor_app/features/profile/data/user_profile_service.dart';
import 'package:savingor_app/features/profile/presentation/screens/change_password_screen.dart';

/// Internal Edit profile screen — full name editing and password reset email.
/// Opened from the Profile Account section; no bottom navigation here.
class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final UserProfileService _profileService = UserProfileService();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();

  bool _isLoading = true;
  bool _isSaving = false;
  bool _isSendingReset = false;
  String? _loadError;
  String _email = '';

  static const Color _pageBackground = SavingorColors.pageWhite;
  static const Color _titleCharcoal = Color(0xFF1F2937);

  static const TextStyle _sectionHeadingStyle = TextStyle(
    fontSize: 17,
    fontWeight: FontWeight.w800,
    color: SavingorColors.darkGreen,
  );

  static const TextStyle _fieldLabelStyle = TextStyle(
    fontSize: 12.5,
    fontWeight: FontWeight.w600,
    color: SavingorColors.textSecondary,
  );

  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  Future<void> _loadProfile() async {
    setState(() {
      _isLoading = true;
      _loadError = null;
    });

    try {
      final UserProfile? profile =
          await _profileService.fetchCurrentUserProfile();
      if (!mounted) return;
      if (profile == null) {
        setState(() {
          _isLoading = false;
          _loadError = 'Sign in to edit your profile.';
        });
        return;
      }
      setState(() {
        _nameController.text = profile.fullName;
        _email = profile.email;
        _isLoading = false;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _isLoading = false;
        _loadError = 'Could not load your profile. Please try again.';
      });
    }
  }

  Future<void> _saveChanges() async {
    if (_isSaving) return;
    if (!(_formKey.currentState?.validate() ?? false)) return;

    setState(() => _isSaving = true);

    try {
      await _profileService.updateFullName(_nameController.text);
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Profile updated.')),
      );
      context.pop(true);
    } on UserProfileException catch (e) {
      if (!mounted) return;
      setState(() => _isSaving = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.message)),
      );
    } catch (_) {
      if (!mounted) return;
      setState(() => _isSaving = false);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Could not save your changes. Please try again.')),
      );
    }
  }

  Future<void> _sendPasswordReset() async {
    if (_isSendingReset) return;
    setState(() => _isSendingReset = true);

    try {
      await _profileService.sendPasswordResetEmail();
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Password reset email sent.')),
      );
    } on UserProfileException catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.message)),
      );
    } catch (_) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Could not send the reset email. Please try again.')),
      );
    } finally {
      if (mounted) {
        setState(() => _isSendingReset = false);
      }
    }
  }

  void _goBack() {
    if (context.canPop()) {
      context.pop();
    } else {
      context.go('/profile');
    }
  }

  @override
  Widget build(BuildContext context) {
    final double bottomInset = MediaQuery.paddingOf(context).bottom;

    return Scaffold(
      backgroundColor: _pageBackground,
      appBar: AppBar(
        title: const Text(
          'Edit profile',
          style: SavingorAppTextStyles.screenTitle,
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
          onPressed: _goBack,
        ),
      ),
      body: _buildBody(bottomInset),
    );
  }

  Widget _buildBody(double bottomInset) {
    if (_isLoading) {
      return const Center(
        child: CircularProgressIndicator(
          color: SavingorColors.primaryStroke,
        ),
      );
    }

    if (_loadError != null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Text(
                _loadError!,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: SavingorColors.textSecondary,
                  height: 1.4,
                ),
              ),
              const SizedBox(height: 16),
              OutlinedButton(
                onPressed: _loadProfile,
                style: SavingorButtonStyles.secondaryOutlined(),
                child: const Text('Try again'),
              ),
            ],
          ),
        ),
      );
    }

    return SingleChildScrollView(
      padding: EdgeInsets.fromLTRB(20, 8, 20, 28 + bottomInset),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            _sectionCard(
              title: 'Personal information',
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  const Text('Full name', style: _fieldLabelStyle),
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: _nameController,
                    enabled: !_isSaving,
                    textCapitalization: TextCapitalization.words,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: _titleCharcoal,
                    ),
                    decoration: _fieldDecoration(hint: 'Your full name'),
                    validator: (String? value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Please enter your full name';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  const Text('Email', style: _fieldLabelStyle),
                  const SizedBox(height: 8),
                  TextFormField(
                    initialValue: _email,
                    enabled: false,
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: SavingorColors.textSecondary.withOpacity(0.9),
                    ),
                    decoration: _fieldDecoration(
                      fillColor: const Color(0xFFF6F7F6),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Email changes are not available in this version.',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: SavingorColors.textSecondary.withOpacity(0.85),
                      height: 1.35,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: SavingorSpacing.lg),
            _sectionCard(
              title: 'Password & security',
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  const Text('Password', style: _fieldLabelStyle),
                  const SizedBox(height: 6),
                  const Text(
                    '••••••••••',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: _titleCharcoal,
                      letterSpacing: 2,
                      height: 1.2,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'For security, your current password is never shown.',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: SavingorColors.textSecondary.withOpacity(0.85),
                      height: 1.35,
                    ),
                  ),
                  const SizedBox(height: 14),
                  OutlinedButton.icon(
                    // Navigator.push (not go_router path) so this can never
                    // hit "Page Not Found"; the pushed page covers the shell,
                    // so no bottom navigation is shown.
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute<void>(
                          builder: (BuildContext context) =>
                              const ChangePasswordScreen(),
                        ),
                      );
                    },
                    style: SavingorButtonStyles.secondaryOutlined(),
                    icon: const Icon(Icons.lock_outline_rounded, size: 19),
                    label: const Text('Change password'),
                  ),
                  const SizedBox(height: 4),
                  TextButton(
                    onPressed: _isSendingReset ? null : _sendPasswordReset,
                    style: TextButton.styleFrom(
                      foregroundColor: SavingorColors.darkGreen,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 8,
                      ),
                    ),
                    child: Text(
                      _isSendingReset
                          ? 'Sending reset email...'
                          : 'Send password reset email instead',
                      style: const TextStyle(
                        fontSize: 12.5,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 0.1,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: SavingorSpacing.xl),
            SavingorInteractiveFilledButton(
              onPressed: _isSaving ? null : _saveChanges,
              width: double.infinity,
              borderRadius: BorderRadius.circular(18),
              child: _isSaving
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: SavingorColors.darkGreen,
                      ),
                    )
                  : const Text('Save changes'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _sectionCard({required String title, required Widget child}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(20, 18, 20, 20),
      decoration: SavingorSurfaces.premiumCard(radius: 22),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(title, style: _sectionHeadingStyle),
          const SizedBox(height: SavingorSpacing.lg),
          child,
        ],
      ),
    );
  }

  InputDecoration _fieldDecoration({String? hint, Color? fillColor}) {
    return InputDecoration(
      hintText: hint,
      hintStyle: TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w500,
        color: SavingorColors.textSecondary.withOpacity(0.7),
      ),
      filled: true,
      fillColor: fillColor ?? Colors.white,
      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 13),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide(color: SavingorColors.border.withOpacity(0.9)),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide(color: SavingorColors.border.withOpacity(0.9)),
      ),
      disabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide(color: SavingorColors.border.withOpacity(0.6)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide(
          color: SavingorColors.primaryStroke.withOpacity(0.55),
          width: 1.25,
        ),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: Color(0xFFC45A5A)),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: Color(0xFFC45A5A), width: 1.25),
      ),
    );
  }
}
