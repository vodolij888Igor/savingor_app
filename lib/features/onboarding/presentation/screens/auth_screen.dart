import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class AuthScreen extends StatelessWidget {
  const AuthScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Welcome')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 16),
            const Text('Welcome', style: TextStyle(fontSize: 20)),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () => context.go('/app/deals'),
              child: const Text('Continue as Guest'),
            ),
            const SizedBox(height: 12),
            TextButton(
              onPressed: () => context.go('/app/deals'),
              child: const Text('Sign in later'),
            ),
          ],
        ),
      ),
    );
  }
}
