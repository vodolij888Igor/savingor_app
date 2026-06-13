import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:savingor_app/core/i18n/profile_l10n.dart';
import 'package:savingor_app/core/theme/savingor_design_system.dart';
import 'package:savingor_app/core/widgets/savingor_interactive.dart';
import 'package:savingor_app/features/profile/data/user_profile_service.dart';
import 'package:savingor_app/features/profile/presentation/screens/change_password_screen.dart';
import 'package:savingor_app/l10n/app_localizations.dart';

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
  String? _loadErrorKey;
  String _email = '';
  static const Color _titleCharcoal = Color(0xFF1F2937);

  static TextStyle _sectionHeadingStyle(BuildContext context) => TextStyle(
        fontSize: 17,
        fontWeight: FontWeight.w800,
        color: context.savingor.isDark
            ? context.savingor.textPrimary
            : SavingorColors.darkGreen,
      );

  TextStyle _fieldLabelStyle(BuildContext context) => TextStyle(
        fontSize: 12.5,
        fontWeight: FontWeight.w600,
        color: context.savingor.textSecondary,
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
      _loadErrorKey = null;
    });

    try {
      final UserProfile? profile =
          await _profileService.fetchCurrentUserProfile();
      if (!mounted) return;
      if (profile == null) {
        setState(() {
          _isLoading = false;
          _loadErrorKey = 'signIn';
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
        _loadErrorKey = 'load';
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
        SnackBar(content: Text(AppLocalizations.of(context).changesSaved)),
      );
      context.pop(true);
    } on UserProfileException catch (e) {
      if (!mounted) return;
      setState(() => _isSaving = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(ProfileL10n.localizeException(context, e))),
      );
    } catch (_) {
      if (!mounted) return;
      setState(() => _isSaving = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(AppLocalizations.of(context).couldNotSaveChanges),
        ),
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
        SnackBar(
          content: Text(AppLocalizations.of(context).passwordResetEmailSent),
        ),
      );
    } on UserProfileException catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(ProfileL10n.localizeException(context, e))),
      );
    } catch (_) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(AppLocalizations.of(context).couldNotSendResetEmail),
        ),
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

  String? _loadErrorMessage(AppLocalizations l10n) {
    return switch (_loadErrorKey) {
      'signIn' => l10n.signInToEditProfile,
      'load' => l10n.couldNotLoadProfile,
      _ => null,
    };
  }

  @override
  Widget build(BuildContext context) {
    final AppLocalizations l10n = AppLocalizations.of(context);
    final double bottomInset = MediaQuery.paddingOf(context).bottom;

    return Scaffold(
      backgroundColor: context.savingor.pageBackground,
      appBar: AppBar(
        title: Text(
          l10n.editProfile,
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
          onPressed: _goBack,
        ),
      ),
      body: _buildBody(l10n, bottomInset),
    );
  }

  Widget _buildBody(AppLocalizations l10n, double bottomInset) {
    if (_isLoading) {
      return Center(
        child: CircularProgressIndicator(
          color: context.savingor.isDark
              ? context.savingor.accentGreen
              : SavingorColors.primaryStroke,
        ),
      );
    }

    final String? loadError = _loadErrorMessage(l10n);
    if (loadError != null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Text(
                loadError,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: context.savingor.textSecondary,
                  height: 1.4,
                ),
              ),
              const SizedBox(height: 16),
              OutlinedButton(
                onPressed: _loadProfile,
                style: SavingorButtonStyles.secondaryOutlined(context),
                child: Text(l10n.tryAgain),
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
              title: l10n.personalInformation,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(l10n.fullName, style: _fieldLabelStyle(context)),
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: _nameController,
                    enabled: !_isSaving,
                    textCapitalization: TextCapitalization.words,
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: context.savingor.isDark
                          ? context.savingor.textPrimary
                          : _titleCharcoal,
                    ),
                    decoration: _fieldDecoration(
                      hint: l10n.editProfileFullNameHint,
                    ),
                    validator: (String? value) {
                      if (value == null || value.trim().isEmpty) {
                        return l10n.pleaseEnterFullName;
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  Text(l10n.email, style: _fieldLabelStyle(context)),
                  const SizedBox(height: 8),
                  TextFormField(
                    initialValue: _email,
                    enabled: false,
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: context.savingor.textSecondary.withOpacity(0.9),
                    ),
                    decoration: _fieldDecoration(
                      fillColor: context.savingor.isDark
                          ? context.savingor.inputFillDisabled
                          : const Color(0xFFF6F7F6),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    l10n.emailChangesNotAvailable,
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: context.savingor.textSecondary.withOpacity(0.85),
                      height: 1.35,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: SavingorSpacing.lg),
            _sectionCard(
              title: l10n.passwordAndSecurity,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(l10n.password, style: _fieldLabelStyle(context)),
                  const SizedBox(height: 6),
                  Text(
                    '••••••••••',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: context.savingor.isDark
                          ? context.savingor.textPrimary
                          : _titleCharcoal,
                      letterSpacing: 2,
                      height: 1.2,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    l10n.passwordNeverShown,
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: context.savingor.textSecondary.withOpacity(0.85),
                      height: 1.35,
                    ),
                  ),
                  const SizedBox(height: 14),
                  OutlinedButton.icon(
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute<void>(
                          builder: (BuildContext context) =>
                              const ChangePasswordScreen(),
                        ),
                      );
                    },
                    style:
                        SavingorButtonStyles.secondaryOutlined(context).merge(
                      ButtonStyle(
                        backgroundColor: WidgetStatePropertyAll<Color>(
                          context.savingor.isDark
                              ? context.savingor.surfaceElevated
                              : context.savingor.surfacePrimary,
                        ),
                      ),
                    ),
                    icon: const Icon(Icons.lock_outline_rounded, size: 19),
                    label: Text(l10n.changePassword),
                  ),
                  const SizedBox(height: 4),
                  TextButton(
                    onPressed: _isSendingReset ? null : _sendPasswordReset,
                    style: TextButton.styleFrom(
                      foregroundColor: context.savingor.isDark
                          ? context.savingor.brandTitle
                          : SavingorColors.darkGreen,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 8,
                      ),
                    ),
                    child: Text(
                      _isSendingReset
                          ? l10n.sendingResetEmail
                          : l10n.sendPasswordResetEmailInstead,
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
                  ? SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: context.savingor.isDark
                            ? context.savingor.buttonLabelOnGreen
                            : SavingorColors.darkGreen,
                      ),
                    )
                  : Text(l10n.saveChanges),
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
      decoration: SavingorSurfaces.premiumCard(context, radius: 22),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(title, style: _sectionHeadingStyle(context)),
          const SizedBox(height: SavingorSpacing.lg),
          child,
        ],
      ),
    );
  }

  InputDecoration _fieldDecoration({String? hint, Color? fillColor}) {
    final SavingorThemeExtension theme = context.savingor;
    final Color focusColor = theme.isDark
        ? theme.accentGreen
        : SavingorColors.primaryStroke.withOpacity(0.55);

    return InputDecoration(
      hintText: hint,
      hintStyle: TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w500,
        color: theme.textSecondary.withOpacity(0.7),
      ),
      filled: true,
      fillColor: fillColor ?? (theme.isDark ? theme.inputFill : Colors.white),
      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 13),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide(color: theme.border.withOpacity(0.9)),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide(color: theme.border.withOpacity(0.9)),
      ),
      disabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide(color: theme.border.withOpacity(0.6)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide(
          color: focusColor,
          width: 1.25,
        ),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide(
          color: theme.isDark ? theme.error : const Color(0xFFC45A5A),
        ),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide(
          color: theme.isDark ? theme.error : const Color(0xFFC45A5A),
          width: 1.25,
        ),
      ),
    );
  }
}
