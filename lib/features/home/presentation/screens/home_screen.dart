import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:savingor_app/core/i18n/app_strings.dart';
import 'package:savingor_app/core/theme/savingor_design_system.dart';

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
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 13,
                      color: SavingorColors.darkGreen.withOpacity(0.75),
                    ),
                  ),
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
    final t = AppStrings.of(context);

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              SavingorColors.background,
              SavingorColors.mint,
            ],
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
                    Text(t.appName,
                        style: theme.textTheme.headlineMedium
                            ?.copyWith(fontWeight: FontWeight.w700)),
                    const SizedBox(height: 6),
                    Text(t.appSubtitle, style: theme.textTheme.titleMedium),
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
                            title: t.dealsMap,
                            subtitle: t.dealsMapSubtitle,
                            onTap: () => context.go('/deals'),
                          ),
                          _buildAction(
                            context,
                            icon: Icons.receipt_long,
                            title: t.receiptScanner,
                            subtitle: t.receiptScannerSubtitle,
                            onTap: () => context.go('/scanner'),
                          ),
                          _buildAction(
                            context,
                            icon: Icons.list,
                            title: t.shoppingList,
                            subtitle: t.shoppingListSubtitle,
                            onTap: () => context.go('/shopping'),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 6),
                Text(t.mvp, style: theme.textTheme.bodySmall),
                const SizedBox(height: 6),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
