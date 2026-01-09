import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  Widget _buildAction(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: ElevatedButton(
        onPressed: onTap,
        style: ElevatedButton.styleFrom(
          minimumSize: const Size.fromHeight(56),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
        child: Row(
          children: [
            Icon(icon, size: 32),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(title,
                      style: const TextStyle(
                          fontSize: 16, fontWeight: FontWeight.w600)),
                  const SizedBox(height: 2),
                  Text(subtitle,
                      style:
                          const TextStyle(fontSize: 13, color: Colors.white70)),
                ],
              ),
            ),
            const Icon(Icons.chevron_right),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFFF7FCFB), Color(0xFFEFFAF8)],
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            child: Column(
              children: [
                const SizedBox(height: 8),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text('SavingGo',
                        style: theme.textTheme.headlineMedium
                            ?.copyWith(fontWeight: FontWeight.w700)),
                    const SizedBox(height: 6),
                    Text('Local Deals & Smart Savings',
                        style: theme.textTheme.titleMedium),
                  ],
                ),
                const SizedBox(height: 28),
                Expanded(
                  child: Center(
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 640),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          _buildAction(
                            context,
                            icon: Icons.map,
                            title: 'Deals Map',
                            subtitle: 'Shows nearby deals',
                            onTap: () => context.go('/deals'),
                          ),
                          _buildAction(
                            context,
                            icon: Icons.receipt_long,
                            title: 'Receipt Scanner',
                            subtitle: 'Scan receipt',
                            onTap: () => context.go('/scanner'),
                          ),
                          _buildAction(
                            context,
                            icon: Icons.list,
                            title: 'Shopping List',
                            subtitle: 'Smart list',
                            onTap: () => context.go('/shopping'),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 6),
                Text('MVP v0.1', style: theme.textTheme.bodySmall),
                const SizedBox(height: 6),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
