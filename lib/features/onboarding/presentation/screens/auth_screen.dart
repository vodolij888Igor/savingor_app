import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:savingor_app/core/i18n/startup_flow_strings.dart';
import 'package:savingor_app/core/theme/savingor_design_system.dart';

// TODO(auth-routing): When a real session exists, gate [GoRouter.redirect] so a valid
// session opens the shell directly and only unauthenticated users see this screen.
// Keep guest / social flows explicit; do not treat placeholder login as authenticated.

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final TextEditingController _email = TextEditingController();
  final TextEditingController _password = TextEditingController();

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: SavingorColors.background,
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 420),
            child: LayoutBuilder(
              builder: (context, constraints) {
                return SingleChildScrollView(
                  padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
                  child: ConstrainedBox(
                    constraints:
                        BoxConstraints(minHeight: constraints.maxHeight),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Text(
                              StartupFlowStrings.tr(
                                  context, 'auth_welcome'),
                              style: Theme.of(context).textTheme.headlineSmall,
                            ),
                            const SizedBox(height: SavingorSpacing.sm),
                            Text(
                              StartupFlowStrings.tr(
                                  context, 'auth_subtitle'),
                              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                                    color: SavingorColors.textSecondary,
                                  ),
                            ),
                            const SizedBox(height: SavingorSpacing.xxl),
                            TextField(
                              controller: _email,
                              keyboardType: TextInputType.emailAddress,
                              decoration: InputDecoration(
                                hintText: StartupFlowStrings.tr(
                                  context,
                                  'auth_email',
                                ),
                                prefixIcon: const Icon(
                                    Icons.mail_outline_rounded),
                              ),
                            ),
                            const SizedBox(height: SavingorSpacing.lg),
                            TextField(
                              controller: _password,
                              obscureText: true,
                              decoration: InputDecoration(
                                hintText: StartupFlowStrings.tr(
                                  context,
                                  'auth_password',
                                ),
                                prefixIcon:
                                    const Icon(Icons.lock_outline_rounded),
                              ),
                            ),
                            const SizedBox(height: SavingorSpacing.lg),
                            FilledButton(
                              onPressed: () => context.go('/deals'),
                              child: Text(
                                StartupFlowStrings.tr(context, 'auth_login'),
                              ),
                            ),
                            const SizedBox(height: SavingorSpacing.md),
                            OutlinedButton.icon(
                              onPressed: () {},
                              icon: const Icon(Icons.g_mobiledata_rounded,
                                  size: 26),
                              label: Text(
                                StartupFlowStrings.tr(context, 'auth_google'),
                              ),
                              style: OutlinedButton.styleFrom(
                                minimumSize: const Size.fromHeight(54),
                                shape: RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius.circular(SavingorRadius.xl),
                                ),
                              ),
                            ),
                            const SizedBox(height: SavingorSpacing.sm),
                            OutlinedButton.icon(
                              onPressed: () {},
                              icon: const Icon(Icons.apple_rounded),
                              label: Text(
                                StartupFlowStrings.tr(context, 'auth_apple'),
                              ),
                              style: OutlinedButton.styleFrom(
                                minimumSize: const Size.fromHeight(54),
                                shape: RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius.circular(SavingorRadius.xl),
                                ),
                              ),
                            ),
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 24),
                          child: TextButton(
                            onPressed: () => context.go('/deals'),
                            child: Text(
                              StartupFlowStrings.tr(context, 'auth_guest'),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
