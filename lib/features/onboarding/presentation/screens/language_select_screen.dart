import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:savingor_app/core/app_state.dart';

class LanguageSelectScreen extends StatelessWidget {
  const LanguageSelectScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final appState = AppStateProvider.of(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Select language')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 8),
            const Text('Choose your language', style: TextStyle(fontSize: 18)),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () {
                appState.setLanguage('uk');
                context.go('/auth');
              },
              child: const Text('Ukrainian'),
            ),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: () {
                appState.setLanguage('en');
                context.go('/auth');
              },
              child: const Text('English'),
            ),
          ],
        ),
      ),
    );
  }
}
