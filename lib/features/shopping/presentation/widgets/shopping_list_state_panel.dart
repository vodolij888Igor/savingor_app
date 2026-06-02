import 'package:flutter/material.dart';

import 'package:savingor_app/core/widgets/app_screen_states.dart';

/// Shopping-list-specific wrappers around shared app screen states.
class ShoppingListStatePanel {
  ShoppingListStatePanel._();

  static Widget loading() => const AppLoadingState();

  static Widget error({
    required String message,
    required VoidCallback onRetry,
  }) {
    return AppErrorState(message: message, onRetry: onRetry);
  }

  static Widget empty({
    required IconData icon,
    required String title,
    required String message,
    String? actionLabel,
    VoidCallback? onAction,
    bool prominentAction = false,
  }) {
    return AppEmptyState(
      icon: icon,
      title: title,
      message: message,
      actionLabel: actionLabel,
      onAction: onAction,
      prominentAction: prominentAction,
    );
  }
}

/// Premium card decoration shared across shopping list UI.
BoxDecoration shoppingListCardDecoration({double radius = 18}) {
  return BoxDecoration(
    color: Colors.white,
    borderRadius: BorderRadius.circular(radius),
    border: Border.all(
      color: const Color(0xFFF3F4F3).withOpacity(0.6),
      width: 0.5,
    ),
    boxShadow: <BoxShadow>[
      BoxShadow(
        color: Colors.black.withOpacity(0.04),
        blurRadius: 12,
        offset: const Offset(0, 2),
      ),
    ],
  );
}
