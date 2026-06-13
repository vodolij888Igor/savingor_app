import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';

import 'package:savingor_app/core/app_state.dart';
import 'package:savingor_app/core/i18n/startup_flow_strings.dart';
import 'package:savingor_app/core/theme/savingor_design_system.dart';
import 'package:savingor_app/features/auth/data/auth_service.dart';

// TODO(auth-routing): When a real session exists, gate [GoRouter.redirect] so a valid
// session opens the shell directly and only unauthenticated users see this screen.
// Keep guest / social flows explicit; do not treat placeholder login as authenticated.

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  static const String _backgroundAsset = 'assets/images/auth_screen_bg.png';

  /// Caps the form on tablets / large displays so it never stretches edge to
  /// edge; mobile renders well below this cap and uses the full width.
  static const double _maxFormWidth = 460;

  final TextEditingController _fullName = TextEditingController();
  final TextEditingController _email = TextEditingController();
  final TextEditingController _password = TextEditingController();
  final TextEditingController _confirmPassword = TextEditingController();
  final AuthService _authService = AuthService();

  bool _isLoading = false;
  bool _isCreateMode = false;
  String? _errorMessage;

  @override
  void dispose() {
    _fullName.dispose();
    _email.dispose();
    _password.dispose();
    _confirmPassword.dispose();
    super.dispose();
  }

  /// Guest entry stays available as a function so existing flows that hand off
  /// to the deals shell without sign-in keep working. The primary auth UI no
  /// longer surfaces it; reintroduce via overflow / settings when needed.
  // ignore: unused_element
  void _continueAsGuest() {
    context.go('/deals');
  }

  void _toggleAuthMode() {
    setState(() {
      _isCreateMode = !_isCreateMode;
      _errorMessage = null;
    });
  }

  String? _validateLogin() {
    if (_email.text.trim().isEmpty) {
      return 'Please enter your email.';
    }
    if (_password.text.isEmpty) {
      return 'Please enter your password.';
    }
    return null;
  }

  String? _validateCreateAccount() {
    if (_fullName.text.trim().isEmpty) {
      return 'Please enter your full name.';
    }
    if (_email.text.trim().isEmpty) {
      return 'Please enter your email.';
    }
    if (_password.text.isEmpty) {
      return 'Please enter your password.';
    }
    if (_confirmPassword.text.isEmpty) {
      return 'Please confirm your password.';
    }
    if (_password.text.length < 6) {
      return 'Password must be at least 6 characters.';
    }
    if (_password.text != _confirmPassword.text) {
      return 'Passwords do not match.';
    }
    return null;
  }

  Future<void> _submitAuth() async {
    final String? validationError =
        _isCreateMode ? _validateCreateAccount() : _validateLogin();
    if (validationError != null) {
      setState(() => _errorMessage = validationError);
      return;
    }

    final String email = _email.text.trim();
    final String password = _password.text;

    FocusScope.of(context).unfocus();
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      if (_isCreateMode) {
        final AppState appState = AppStateProvider.of(context);
        await _authService.createUserWithEmailAndPassword(
          email: email,
          password: password,
          fullName: _fullName.text.trim(),
          selectedLanguage: appState.language ?? 'en',
        );
      } else {
        await _authService.signInWithEmailAndPassword(
          email: email,
          password: password,
        );
      }
      if (!mounted) return;
      context.go('/deals');
    } on AuthServiceException catch (e) {
      if (!mounted) return;
      setState(() => _errorMessage = e.message);
    } catch (_) {
      if (!mounted) return;
      setState(
        () => _errorMessage = AuthService.messageForCode('unknown'),
      );
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  /// Reusable input decoration for the email and password fields — translucent
  /// fill plays nicely on top of the frosted auth card.
  InputDecoration _fieldDecoration({
    required String hint,
    required IconData icon,
  }) {
    final OutlineInputBorder base = OutlineInputBorder(
      borderRadius: BorderRadius.circular(SavingorRadius.lg),
      borderSide: BorderSide.none,
    );
    return InputDecoration(
      hintText: hint,
      prefixIcon: Icon(
        icon,
        color: SavingorColors.darkGreen.withOpacity(0.78),
      ),
      filled: true,
      fillColor: Colors.white.withOpacity(0.72),
      isDense: true,
      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
      border: base,
      enabledBorder: base.copyWith(
        borderSide: BorderSide(
          color: SavingorColors.border.withOpacity(0.7),
          width: 1,
        ),
      ),
      focusedBorder: base.copyWith(
        borderSide: const BorderSide(
          color: SavingorColors.primaryStroke,
          width: 1.5,
        ),
      ),
      hintStyle: TextStyle(
        color: SavingorColors.textSecondary.withOpacity(0.95),
      ),
    );
  }

  List<Widget> _buildAuthFields(BuildContext context) {
    final String emailHint = StartupFlowStrings.tr(context, 'auth_email');
    final String passwordHint = StartupFlowStrings.tr(context, 'auth_password');

    if (!_isCreateMode) {
      return <Widget>[
        TextField(
          controller: _email,
          keyboardType: TextInputType.visiblePassword,
          textInputAction: TextInputAction.next,
          autocorrect: false,
          onSubmitted: (_) => FocusScope.of(context).nextFocus(),
          decoration: _fieldDecoration(
            hint: emailHint,
            icon: Icons.mail_outline_rounded,
          ),
        ),
        const SizedBox(height: SavingorSpacing.sm),
        TextField(
          controller: _password,
          obscureText: true,
          keyboardType: TextInputType.visiblePassword,
          textInputAction: TextInputAction.done,
          onSubmitted: (_) {
            if (!_isLoading) {
              _submitAuth();
            }
          },
          decoration: _fieldDecoration(
            hint: passwordHint,
            icon: Icons.lock_outline_rounded,
          ),
        ),
      ];
    }

    return <Widget>[
      TextField(
        controller: _fullName,
        keyboardType: TextInputType.visiblePassword,
        textInputAction: TextInputAction.next,
        textCapitalization: TextCapitalization.words,
        onSubmitted: (_) => FocusScope.of(context).nextFocus(),
        decoration: _fieldDecoration(
          hint: 'Full name',
          icon: Icons.person_outline_rounded,
        ),
      ),
      const SizedBox(height: SavingorSpacing.sm),
      TextField(
        controller: _email,
        keyboardType: TextInputType.visiblePassword,
        textInputAction: TextInputAction.next,
        autocorrect: false,
        onSubmitted: (_) => FocusScope.of(context).nextFocus(),
        decoration: _fieldDecoration(
          hint: emailHint,
          icon: Icons.mail_outline_rounded,
        ),
      ),
      const SizedBox(height: SavingorSpacing.sm),
      TextField(
        controller: _password,
        obscureText: true,
        keyboardType: TextInputType.visiblePassword,
        textInputAction: TextInputAction.next,
        onSubmitted: (_) => FocusScope.of(context).nextFocus(),
        decoration: _fieldDecoration(
          hint: passwordHint,
          icon: Icons.lock_outline_rounded,
        ),
      ),
      const SizedBox(height: SavingorSpacing.sm),
      TextField(
        controller: _confirmPassword,
        obscureText: true,
        keyboardType: TextInputType.visiblePassword,
        textInputAction: TextInputAction.done,
        onSubmitted: (_) {
          if (!_isLoading) {
            _submitAuth();
          }
        },
        decoration: _fieldDecoration(
          hint: 'Confirm password',
          icon: Icons.lock_outline_rounded,
        ),
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    final double keyboardBottomInset = MediaQuery.viewInsetsOf(context).bottom;
    return Scaffold(
      // Cream Savingor background must not show through after the Android
      // keyboard dismisses — that inset glitch leaves a white strip. Transparent
      // scaffold + non-resizing body keeps the Stack + full-bleed image stable.
      backgroundColor: Colors.transparent,
      resizeToAvoidBottomInset: false,
      body: SizedBox.expand(
        child: Stack(
          fit: StackFit.expand,
          children: <Widget>[
            Positioned.fill(
              // `cover` fills the whole screen so there is no white block at the
              // bottom. Top-aligned so the artwork's Savingor logo / wordmark
              // band stays anchored up top and any cropping happens at the
              // bottom (which the auth card sits over anyway).
              child: Image.asset(
                _backgroundAsset,
                fit: BoxFit.cover,
                alignment: Alignment.topCenter,
                filterQuality: FilterQuality.high,
              ),
            ),
            SafeArea(
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: _maxFormWidth),
                  child: LayoutBuilder(
                    builder: (BuildContext _, BoxConstraints constraints) {
                      // Press the card right up under the artwork's Savingor
                      // logo / wordmark band. SafeArea already absorbs the
                      // status bar; this extra gap is now ≈2–10 px so the card
                      // visually connects to the top branding without ever
                      // overlapping system UI on smaller devices.
                      final double topPad =
                          (constraints.maxHeight * 0.01).clamp(2.0, 10.0);
                      return SingleChildScrollView(
                        // Extra bottom padding when the keyboard is open so the
                        // form can scroll above it without resizing the scaffold.
                        padding: EdgeInsets.fromLTRB(
                          20,
                          topPad,
                          20,
                          20 + keyboardBottomInset,
                        ),
                        child: _buildAuthCard(context),
                      );
                    },
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Frosted glass card containing the full sign-in surface: title + form +
  /// social providers + create-account row. Backdrop blur softens whatever
  /// part of the artwork sits behind the card so the inputs stay readable.
  Widget _buildAuthCard(BuildContext context) {
    final String title =
        _isCreateMode ? 'Create your Savingor account' : 'Welcome back';
    final String subtitle = _isCreateMode
        ? 'Save purchases, track spending, and find better deals.'
        : 'Log in to continue saving smarter.';

    final BorderRadius radius = BorderRadius.circular(28);
    return DecoratedBox(
      decoration: BoxDecoration(
        borderRadius: radius,
        boxShadow: SavingorShadows.medium,
      ),
      child: ClipRRect(
        borderRadius: radius,
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 14, sigmaY: 14),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.72),
              borderRadius: radius,
              border: Border.all(
                color: Colors.white.withOpacity(0.55),
                width: 1,
              ),
            ),
            padding: const EdgeInsets.fromLTRB(20, 12, 20, 8),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Text(
                  title,
                  textAlign: TextAlign.center,
                  style: SavingorTextStyles.onboardingTitle.copyWith(
                    fontSize: 22,
                    letterSpacing: 0.1,
                    height: 1.16,
                  ),
                ),
                const SizedBox(height: SavingorSpacing.xs),
                Text(
                  subtitle,
                  textAlign: TextAlign.center,
                  style: SavingorTextStyles.onboardingSubtitle.copyWith(
                    fontSize: 13.5,
                  ),
                ),
                const SizedBox(height: SavingorSpacing.sm),
                ..._buildAuthFields(context),
                if (_errorMessage != null) ...<Widget>[
                  const SizedBox(height: SavingorSpacing.sm),
                  Text(
                    _errorMessage!,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: SavingorColors.darkGreen.withOpacity(0.85),
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                      height: 1.35,
                    ),
                  ),
                ],
                const SizedBox(height: SavingorSpacing.sm),
                FilledButton(
                  onPressed: _isLoading ? null : _submitAuth,
                  child: _isLoading
                      ? const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            SizedBox(
                              width: 18,
                              height: 18,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Colors.white,
                              ),
                            ),
                            SizedBox(width: 10),
                            Text('Please wait...'),
                          ],
                        )
                      : Text(
                          _isCreateMode
                              ? StartupFlowStrings.tr(
                                  context,
                                  'auth_create_account',
                                )
                              : StartupFlowStrings.tr(
                                  context,
                                  'auth_login',
                                ),
                        ),
                ),
                const SizedBox(height: SavingorSpacing.sm),
                const _OrDivider(),
                const SizedBox(height: SavingorSpacing.sm),
                _OutlinedAuthButton(
                  icon: const _GoogleGlyph(size: 20),
                  label: StartupFlowStrings.tr(context, 'auth_google'),
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text(
                          'Google sign-in will be available soon.',
                        ),
                      ),
                    );
                  },
                ),
                const SizedBox(height: SavingorSpacing.sm),
                _OutlinedAuthButton(
                  icon: const Icon(Icons.apple_rounded, size: 22),
                  label: StartupFlowStrings.tr(context, 'auth_apple'),
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text(
                          'Apple sign-in will be available soon.',
                        ),
                      ),
                    );
                  },
                ),
                const SizedBox(height: SavingorSpacing.sm),
                _CreateAccountRow(
                  prompt: _isCreateMode
                      ? 'Already have an account?'
                      : StartupFlowStrings.tr(
                          context,
                          'auth_no_account',
                        ),
                  actionLabel: _isCreateMode
                      ? StartupFlowStrings.tr(context, 'auth_login')
                      : StartupFlowStrings.tr(
                          context,
                          'auth_create_account',
                        ),
                  onTap: _toggleAuthMode,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// "or" divider sitting between the primary email login and the social
/// providers. Reads its label from the existing startup-flow string map so
/// the auth screen rebuilds in the chosen language on every locale change.
class _OrDivider extends StatelessWidget {
  const _OrDivider();

  @override
  Widget build(BuildContext context) {
    final Color line = SavingorColors.border.withOpacity(0.85);
    return Row(
      children: <Widget>[
        Expanded(child: Divider(thickness: 1, color: line)),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Text(
            StartupFlowStrings.tr(context, 'auth_or'),
            style: const TextStyle(
              color: SavingorColors.textSecondary,
              fontWeight: FontWeight.w600,
              fontSize: 12.5,
              letterSpacing: 0.8,
            ),
          ),
        ),
        Expanded(child: Divider(thickness: 1, color: line)),
      ],
    );
  }
}

/// Soft outlined social-provider button used for Google and Apple, sized to
/// match the primary [FilledButton] so the action stack feels cohesive.
class _OutlinedAuthButton extends StatelessWidget {
  const _OutlinedAuthButton({
    required this.icon,
    required this.label,
    required this.onPressed,
  });

  /// Leading glyph for the button. Widget (not IconData) so we can mix
  /// Material icons (e.g. Apple) with brand-accurate SVG marks (Google G).
  final Widget icon;
  final String label;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return OutlinedButton.icon(
      onPressed: onPressed,
      icon: icon,
      label: Text(label),
      style: OutlinedButton.styleFrom(
        foregroundColor: SavingorColors.textPrimary,
        backgroundColor: Colors.white.withOpacity(0.6),
        minimumSize: const Size.fromHeight(52),
        side: BorderSide(
          color: SavingorColors.border.withOpacity(0.75),
          width: 1,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(SavingorRadius.xl),
        ),
        textStyle: const TextStyle(
          fontWeight: FontWeight.w600,
          fontSize: 15,
          letterSpacing: 0.1,
        ),
      ),
    );
  }
}

/// Brand-accurate Google "G" rendered from an inline SVG via [SvgPicture.string],
/// so no new asset/file is needed. Uses the official four-colour Google mark
/// instead of Material's boxed `Icons.g_mobiledata_rounded`, which looks like
/// a placeholder. Kept private to the auth screen because this is the only
/// surface that needs it.
class _GoogleGlyph extends StatelessWidget {
  const _GoogleGlyph({this.size = 20});

  final double size;

  static const String _googleGSvg =
      '<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 48 48">'
      '<path fill="#FFC107" d="M43.611,20.083H42V20H24v8h11.303c-1.649,4.657-6.08,8-11.303,8'
      'c-6.627,0-12-5.373-12-12c0-6.627,5.373-12,12-12c3.059,0,5.842,1.154,7.961,3.039'
      'l5.657-5.657C34.046,6.053,29.268,4,24,4C12.955,4,4,12.955,4,24c0,11.045,8.955,20,20,20'
      'c11.045,0,20-8.955,20-20C44,22.659,43.862,21.35,43.611,20.083z"/>'
      '<path fill="#FF3D00" d="M6.306,14.691l6.571,4.819C14.655,15.108,18.961,12,24,12'
      'c3.059,0,5.842,1.154,7.961,3.039l5.657-5.657C34.046,6.053,29.268,4,24,4'
      'C16.318,4,9.656,8.337,6.306,14.691z"/>'
      '<path fill="#4CAF50" d="M24,44c5.166,0,9.86-1.977,13.409-5.192l-6.19-5.238'
      'C29.211,35.091,26.715,36,24,36c-5.202,0-9.619-3.317-11.283-7.946l-6.522,5.025'
      'C9.505,39.556,16.227,44,24,44z"/>'
      '<path fill="#1976D2" d="M43.611,20.083H42V20H24v8h11.303c-0.792,2.237-2.231,4.166-4.087,5.571'
      'c0.001-0.001,0.002-0.001,0.003-0.002l6.19,5.238C36.971,39.205,44,34,44,24'
      'C44,22.659,43.862,21.35,43.611,20.083z"/>'
      '</svg>';

  @override
  Widget build(BuildContext context) {
    return SizedBox.square(
      dimension: size,
      child: SvgPicture.string(
        _googleGSvg,
        width: size,
        height: size,
        fit: BoxFit.contain,
      ),
    );
  }
}

/// Login ↔ create-account toggle row inside the card.
class _CreateAccountRow extends StatelessWidget {
  const _CreateAccountRow({
    required this.prompt,
    required this.actionLabel,
    required this.onTap,
  });

  final String prompt;
  final String actionLabel;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Text(
            prompt,
            style: const TextStyle(
              color: SavingorColors.textSecondary,
              fontSize: 13.5,
              fontWeight: FontWeight.w500,
              letterSpacing: 0.1,
            ),
          ),
          TextButton(
            onPressed: onTap,
            style: TextButton.styleFrom(
              foregroundColor: SavingorColors.darkGreen,
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              minimumSize: Size.zero,
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              visualDensity: VisualDensity.compact,
            ),
            child: Text(
              actionLabel,
              style: const TextStyle(
                fontWeight: FontWeight.w700,
                fontSize: 13.5,
                letterSpacing: 0.1,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
