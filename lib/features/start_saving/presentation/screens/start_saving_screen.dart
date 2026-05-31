import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:savingor_app/core/theme/savingor_design_system.dart';
import 'package:savingor_app/features/start_saving/presentation/widgets/start_saving_action_card.dart';

class StartSavingScreen extends StatelessWidget {
  const StartSavingScreen({super.key});

  static const Color _pageWhite = Color(0xFFFFFEFE);
  static const String _scanReceiptRoute = '/expenses';
  static const String _shoppingListRoute = '/start-saving/shopping-list';
  static const String _addGroceryExpenseRoute = '/expenses/create';

  void _snack(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  bool _routeExists(GoRouter router, String path) {
    bool search(RouteBase route, String parentPath) {
      if (route is GoRoute) {
        final String fullPath = route.path.startsWith('/')
            ? route.path
            : '$parentPath/${route.path}'.replaceAll('//', '/');
        if (fullPath == path) return true;
        for (final RouteBase child in route.routes) {
          if (search(child, fullPath)) return true;
        }
      } else if (route is ShellRoute) {
        for (final RouteBase child in route.routes) {
          if (search(child, parentPath)) return true;
        }
      }
      return false;
    }

    for (final RouteBase route in router.configuration.routes) {
      if (search(route, '')) return true;
    }
    return false;
  }

  void _pushIfRouteExists(
    BuildContext context, {
    required String path,
    required String missingMessage,
  }) {
    final GoRouter router = GoRouter.of(context);
    if (_routeExists(router, path)) {
      context.push(path);
    } else {
      _snack(context, missingMessage);
    }
  }

  void _returnToDashboard(BuildContext context) {
    context.go('/deals');
  }

  void _showAiInsightSheet(BuildContext context) {
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: Colors.white,
      isScrollControlled: true,
      isDismissible: true,
      enableDrag: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(22)),
      ),
      builder: (BuildContext sheetContext) {
        final double bottomInset = MediaQuery.paddingOf(sheetContext).bottom;
        return Padding(
          padding: EdgeInsets.fromLTRB(24, 12, 24, 24 + bottomInset),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: SavingorColors.border.withOpacity(0.9),
                    borderRadius: BorderRadius.circular(999),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              const Row(
                children: <Widget>[
                  Icon(
                    Icons.auto_awesome_rounded,
                    size: 22,
                    color: SavingorColors.primaryStroke,
                  ),
                  SizedBox(width: 8),
                  Text(
                    'AI Savings Assistant',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: SavingorColors.darkGreen,
                      height: 1.2,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              const Text(
                'You could save \$12.40 this week by switching 3 products to better deals.',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                  color: SavingorColors.textPrimary,
                  height: 1.45,
                ),
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: FilledButton(
                  onPressed: () => Navigator.of(sheetContext).pop(),
                  style: SavingorButtonStyles.primaryFilled(),
                  child: const Text('Got it'),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final double bottomInset = MediaQuery.paddingOf(context).bottom;

    return Scaffold(
      backgroundColor: _pageWhite,
      appBar: AppBar(
        toolbarHeight: 48,
        elevation: 0,
        scrolledUnderElevation: 0,
        backgroundColor: _pageWhite,
        surfaceTintColor: Colors.transparent,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_new_rounded,
            color: SavingorColors.darkGreen,
            size: 20,
          ),
          onPressed: () => _returnToDashboard(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.fromLTRB(20, 0, 20, 24 + bottomInset),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            const Text(
              'Start saving',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.w800,
                color: SavingorColors.darkGreen,
                height: 1.1,
                letterSpacing: -0.4,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Choose how you want to save today.',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: SavingorColors.textSecondary.withOpacity(0.95),
                height: 1.35,
              ),
            ),
            const SizedBox(height: SavingorSpacing.xl),
            StartSavingActionCard(
              icon: Icons.receipt_long_outlined,
              title: 'Scan receipt',
              subtitle: 'Upload or scan a receipt to track spending.',
              iconColor: const Color(0xFF5B8FA8),
              onTap: () => _pushIfRouteExists(
                context,
                path: _scanReceiptRoute,
                missingMessage: 'Expenses screen is unavailable.',
              ),
            ),
            const SizedBox(height: 12),
            StartSavingActionCard(
              icon: Icons.add_shopping_cart_outlined,
              title: 'Add grocery expense',
              subtitle: 'Manually add a purchase or grocery expense.',
              iconColor: const Color(0xFFC4895A),
              onTap: () => _pushIfRouteExists(
                context,
                path: _addGroceryExpenseRoute,
                missingMessage: 'Add expense screen is unavailable.',
              ),
            ),
            const SizedBox(height: 12),
            StartSavingActionCard(
              icon: Icons.checklist_rounded,
              title: 'Create shopping list',
              subtitle: 'Plan what to buy and compare better deals.',
              iconColor: const Color(0xFF6B9E78),
              onTap: () => _pushIfRouteExists(
                context,
                path: _shoppingListRoute,
                missingMessage: 'Shopping list screen is coming next.',
              ),
            ),
            const SizedBox(height: 12),
            StartSavingActionCard(
              icon: Icons.local_offer_outlined,
              title: 'View local deals',
              subtitle: 'Discover current deals near you.',
              iconColor: const Color(0xFF8B6BA8),
              onTap: () => _returnToDashboard(context),
            ),
            const SizedBox(height: 12),
            StartSavingActionCard(
              icon: Icons.auto_awesome_rounded,
              title: 'Ask AI Savings Assistant',
              subtitle:
                  'Get smart suggestions based on receipts and shopping habits.',
              iconColor: SavingorColors.primaryStroke,
              onTap: () => _showAiInsightSheet(context),
            ),
          ],
        ),
      ),
    );
  }
}
