import 'package:flutter/material.dart';

import 'package:savingor_app/core/theme/savingor_design_system.dart';

/// Centered loading indicator for Firestore-backed screens.
class AppLoadingState extends StatelessWidget {
  const AppLoadingState({super.key, this.message = 'Loading…'});

  final String message;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(28),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            const CircularProgressIndicator(
              color: SavingorColors.primaryStroke,
            ),
            const SizedBox(height: 16),
            Text(
              message,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: SavingorColors.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Premium empty state with optional primary action.
class AppEmptyState extends StatelessWidget {
  const AppEmptyState({
    super.key,
    required this.icon,
    required this.title,
    required this.message,
    this.actionLabel,
    this.onAction,
    this.prominentAction = false,
  });

  final IconData icon;
  final String title;
  final String message;
  final String? actionLabel;
  final VoidCallback? onAction;
  final bool prominentAction;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(28),
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 320),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Icon(icon, size: 56, color: SavingorColors.textSecondary),
              const SizedBox(height: 16),
              Text(
                title,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: SavingorColors.darkGreen,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                message,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: SavingorColors.textSecondary,
                  height: 1.45,
                ),
              ),
              if (actionLabel != null && onAction != null) ...<Widget>[
                const SizedBox(height: 20),
                SizedBox(
                  width: prominentAction ? double.infinity : null,
                  child: FilledButton(
                    onPressed: onAction,
                    style: prominentAction
                        ? SavingorButtonStyles.primaryFilled().copyWith(
                            minimumSize: const WidgetStatePropertyAll<Size>(
                              Size.fromHeight(56),
                            ),
                          )
                        : SavingorButtonStyles.primaryFilled(),
                    child: Text(actionLabel!),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

/// Error state with retry action for failed Firestore streams.
class AppErrorState extends StatelessWidget {
  const AppErrorState({
    super.key,
    this.title = 'Something went wrong',
    required this.message,
    required this.onRetry,
    this.actionLabel = 'Retry',
  });

  final String title;
  final String message;
  final VoidCallback onRetry;
  final String actionLabel;

  @override
  Widget build(BuildContext context) {
    return AppEmptyState(
      icon: Icons.cloud_off_outlined,
      title: title,
      message: message,
      actionLabel: actionLabel,
      onAction: onRetry,
    );
  }
}

/// Shown when Firestore features require an authenticated user.
class AppSignInRequiredState extends StatelessWidget {
  const AppSignInRequiredState({
    super.key,
    this.title = 'Sign in required',
    required this.message,
    required this.onSignIn,
    this.actionLabel = 'Sign in',
  });

  final String title;
  final String message;
  final VoidCallback onSignIn;
  final String actionLabel;

  @override
  Widget build(BuildContext context) {
    return AppEmptyState(
      icon: Icons.lock_outline_rounded,
      title: title,
      message: message,
      actionLabel: actionLabel,
      onAction: onSignIn,
      prominentAction: true,
    );
  }
}
