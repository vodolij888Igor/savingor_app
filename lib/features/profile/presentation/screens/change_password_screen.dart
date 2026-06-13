import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:savingor_app/core/i18n/profile_l10n.dart';
import 'package:savingor_app/core/theme/savingor_design_system.dart';
import 'package:savingor_app/core/widgets/savingor_interactive.dart';
import 'package:savingor_app/features/profile/data/user_profile_service.dart';
import 'package:savingor_app/l10n/app_localizations.dart';

/// Secure password change: re-authenticates with the current password before
/// calling FirebaseAuth updatePassword. Passwords are never stored or logged.
class ChangePasswordScreen extends StatefulWidget {
  const ChangePasswordScreen({super.key});

  @override
  State<ChangePasswordScreen> createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  final UserProfileService _profileService = UserProfileService();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final TextEditingController _currentPasswordController =
      TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  bool _obscureCurrent = true;
  bool _obscureNew = true;
  bool _obscureConfirm = true;

  bool _isSubmitting = false;
  bool _isSendingReset = false;

  static const Color _pageBackground = SavingorColors.pageWhite;
  static const Color _titleCharcoal = Color(0xFF1F2937);

  static const TextStyle _fieldLabelStyle = TextStyle(
    fontSize: 12.5,
    fontWeight: FontWeight.w600,
    color: SavingorColors.textSecondary,
  );

  @override
  void dispose() {
    _currentPasswordController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _updatePassword() async {
    if (_isSubmitting) return;
    if (!(_formKey.currentState?.validate() ?? false)) return;

    FocusScope.of(context).unfocus();
    setState(() => _isSubmitting = true);

    try {
      await _profileService.changePassword(
        currentPassword: _currentPasswordController.text,
        newPassword: _newPasswordController.text,
      );
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(AppLocalizations.of(context).passwordUpdated)),
      );
      Navigator.of(context).pop();
    } on UserProfileException catch (e) {
      if (!mounted) return;
      setState(() => _isSubmitting = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(ProfileL10n.localizeException(context, e))),
      );
    } catch (_) {
      if (!mounted) return;
      setState(() => _isSubmitting = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(AppLocalizations.of(context).couldNotUpdatePassword),
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
    final NavigatorState navigator = Navigator.of(context);
    if (navigator.canPop()) {
      navigator.pop();
    } else {
      context.go('/profile');
    }
  }

  @override
  Widget build(BuildContext context) {
    final AppLocalizations l10n = AppLocalizations.of(context);
    final double bottomInset = MediaQuery.paddingOf(context).bottom;

    return Scaffold(
      backgroundColor: _pageBackground,
      appBar: AppBar(
        title: Text(
          l10n.changePassword,
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
      body: SingleChildScrollView(
        padding: EdgeInsets.fromLTRB(20, 8, 20, 28 + bottomInset),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Container(
                width: double.infinity,
                padding: const EdgeInsets.fromLTRB(20, 18, 20, 20),
                decoration: SavingorSurfaces.premiumCard(radius: 22),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      l10n.changePasswordIntro,
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                        color: SavingorColors.textSecondary,
                        height: 1.4,
                      ),
                    ),
                    const SizedBox(height: 18),
                    Text(l10n.currentPassword, style: _fieldLabelStyle),
                    const SizedBox(height: 8),
                    _passwordField(
                      l10n: l10n,
                      controller: _currentPasswordController,
                      obscure: _obscureCurrent,
                      onToggleObscure: () =>
                          setState(() => _obscureCurrent = !_obscureCurrent),
                      hint: l10n.enterCurrentPasswordHint,
                      validator: (String? value) {
                        if (value == null || value.trim().isEmpty) {
                          return l10n.currentPasswordRequired;
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    Text(l10n.newPassword, style: _fieldLabelStyle),
                    const SizedBox(height: 8),
                    _passwordField(
                      l10n: l10n,
                      controller: _newPasswordController,
                      obscure: _obscureNew,
                      onToggleObscure: () =>
                          setState(() => _obscureNew = !_obscureNew),
                      hint: l10n.atLeast6CharactersHint,
                      validator: (String? value) {
                        final String trimmed = value?.trim() ?? '';
                        if (trimmed.isEmpty) {
                          return l10n.newPasswordRequired;
                        }
                        if (trimmed.length < 6) {
                          return l10n.newPasswordMinLength;
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    Text(l10n.confirmNewPassword, style: _fieldLabelStyle),
                    const SizedBox(height: 8),
                    _passwordField(
                      l10n: l10n,
                      controller: _confirmPasswordController,
                      obscure: _obscureConfirm,
                      onToggleObscure: () =>
                          setState(() => _obscureConfirm = !_obscureConfirm),
                      hint: l10n.repeatNewPasswordHint,
                      validator: (String? value) {
                        final String trimmed = value?.trim() ?? '';
                        if (trimmed.isEmpty) {
                          return l10n.confirmNewPasswordRequired;
                        }
                        if (trimmed != _newPasswordController.text.trim()) {
                          return l10n.passwordsDoNotMatch;
                        }
                        return null;
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(height: SavingorSpacing.xl),
              SavingorInteractiveFilledButton(
                onPressed: _isSubmitting ? null : _updatePassword,
                width: double.infinity,
                borderRadius: BorderRadius.circular(18),
                child: _isSubmitting
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: SavingorColors.darkGreen,
                        ),
                      )
                    : Text(l10n.updatePassword),
              ),
              const SizedBox(height: SavingorSpacing.xl),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.fromLTRB(18, 16, 18, 18),
                decoration: BoxDecoration(
                  color: const Color(0xFFFCFDFC),
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(
                    color: SavingorColors.border.withOpacity(0.8),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      l10n.forgotCurrentPassword,
                      style: const TextStyle(
                        fontSize: 14.5,
                        fontWeight: FontWeight.w700,
                        color: _titleCharcoal,
                        height: 1.25,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      l10n.passwordResetSecureLink,
                      style: const TextStyle(
                        fontSize: 12.5,
                        fontWeight: FontWeight.w500,
                        color: SavingorColors.textSecondary,
                        height: 1.4,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      l10n.passwordResetByEmailHint,
                      style: TextStyle(
                        fontSize: 12.5,
                        fontWeight: FontWeight.w500,
                        color: SavingorColors.textSecondary.withOpacity(0.85),
                        height: 1.4,
                      ),
                    ),
                    const SizedBox(height: 12),
                    OutlinedButton.icon(
                      onPressed: _isSendingReset ? null : _sendPasswordReset,
                      style: SavingorButtonStyles.secondaryOutlined(),
                      icon: _isSendingReset
                          ? const SizedBox(
                              width: 15,
                              height: 15,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: SavingorColors.darkGreen,
                              ),
                            )
                          : const Icon(Icons.mark_email_read_outlined, size: 18),
                      label: Text(
                        _isSendingReset ? l10n.sending : l10n.sendResetEmail,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _passwordField({
    required AppLocalizations l10n,
    required TextEditingController controller,
    required bool obscure,
    required VoidCallback onToggleObscure,
    required String hint,
    required String? Function(String?) validator,
  }) {
    return TextFormField(
      controller: controller,
      obscureText: obscure,
      enabled: !_isSubmitting,
      autocorrect: false,
      enableSuggestions: false,
      style: const TextStyle(
        fontSize: 15,
        fontWeight: FontWeight.w600,
        color: _titleCharcoal,
      ),
      decoration: _fieldDecoration(hint: hint).copyWith(
        suffixIcon: IconButton(
          onPressed: onToggleObscure,
          tooltip: obscure ? l10n.showPassword : l10n.hidePassword,
          icon: Icon(
            obscure
                ? Icons.visibility_outlined
                : Icons.visibility_off_outlined,
            size: 20,
            color: SavingorColors.textSecondary.withOpacity(0.8),
          ),
        ),
      ),
      validator: validator,
    );
  }

  InputDecoration _fieldDecoration({String? hint}) {
    return InputDecoration(
      hintText: hint,
      hintStyle: TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w500,
        color: SavingorColors.textSecondary.withOpacity(0.7),
      ),
      filled: true,
      fillColor: Colors.white,
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
