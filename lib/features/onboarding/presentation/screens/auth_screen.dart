import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:savingor_app/core/theme/savingor_design_system.dart';

class AuthScreen extends StatelessWidget {
  const AuthScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final email = TextEditingController();
    final password = TextEditingController();

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
                    constraints: BoxConstraints(minHeight: constraints.maxHeight),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Text(
                              'Welcome back!',
                              style: Theme.of(context).textTheme.headlineSmall,
                            ),
                            const SizedBox(height: SavingorSpacing.sm),
                            Text(
                              'Continue your savings journey.',
                              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                                    color: SavingorColors.textSecondary,
                                  ),
                            ),
                            const SizedBox(height: SavingorSpacing.xxl),
                            TextField(
                              controller: email,
                              keyboardType: TextInputType.emailAddress,
                              decoration: const InputDecoration(
                                hintText: 'Email',
                                prefixIcon: Icon(Icons.mail_outline_rounded),
                              ),
                            ),
                            const SizedBox(height: SavingorSpacing.lg),
                            TextField(
                              controller: password,
                              obscureText: true,
                              decoration: const InputDecoration(
                                hintText: 'Password',
                                prefixIcon: Icon(Icons.lock_outline_rounded),
                              ),
                            ),
                            const SizedBox(height: SavingorSpacing.lg),
                            FilledButton(
                              onPressed: () => context.go('/deals'),
                              child: const Text('Log in'),
                            ),
                            const SizedBox(height: SavingorSpacing.md),
                            OutlinedButton.icon(
                              onPressed: () {},
                              icon: const Icon(Icons.g_mobiledata_rounded, size: 26),
                              label: const Text('Continue with Google'),
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
                              label: const Text('Continue with Apple'),
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
                            child: const Text('Continue as Guest'),
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
