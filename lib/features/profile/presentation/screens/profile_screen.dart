import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:savingor_app/core/app_state.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final appState = AppStateProvider.of(context);
    final lang = appState.language ?? 'not set';

    return Scaffold(
      appBar: AppBar(title: const Text('Profile')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Language: $lang'),
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
}
