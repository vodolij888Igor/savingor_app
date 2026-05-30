import 'package:flutter/material.dart';
import 'package:savingor_app/core/theme/savingor_design_system.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  static const Color _pageBackground = Color(0xFFF3FAF1);

  Widget _cardShell({
    required Widget child,
    bool highlighted = false,
    EdgeInsetsGeometry padding = const EdgeInsets.all(20),
  }) {
    return Container(
      width: double.infinity,
      padding: padding,
      decoration: BoxDecoration(
        color: highlighted ? const Color(0xFFF4FBF2) : Colors.white,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(
          color: SavingorColors.primaryStroke.withOpacity(highlighted ? 0.26 : 0.12),
        ),
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: SavingorColors.darkGreen.withOpacity(0.06),
            blurRadius: highlighted ? 16 : 12,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: child,
    );
  }

  Widget _metricCard({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return _cardShell(
      padding: const EdgeInsets.fromLTRB(14, 14, 14, 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Icon(icon, size: 18, color: SavingorColors.darkGreen.withOpacity(0.8)),
          const SizedBox(height: 10),
          Text(
            label,
            style: const TextStyle(
              fontSize: 12,
              color: SavingorColors.textSecondary,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w800,
              color: SavingorColors.darkGreen,
              height: 1.2,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    const double goalAmount = 100;
    const double progressAmount = 0;
    final double progress = (progressAmount / goalAmount).clamp(0, 1);
    final double bottomInset = MediaQuery.paddingOf(context).bottom;

    return Scaffold(
      backgroundColor: _pageBackground,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.fromLTRB(20, 14, 20, 20 + bottomInset + 68),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              _cardShell(
                highlighted: true,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.9),
                        borderRadius: BorderRadius.circular(SavingorRadius.pill),
                        border: Border.all(
                          color: SavingorColors.primaryStroke.withOpacity(0.24),
                        ),
                      ),
                      child: const Text(
                        'Canada • CAD',
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                          color: SavingorColors.darkGreen,
                          letterSpacing: 0.2,
                        ),
                      ),
                    ),
                    const SizedBox(height: SavingorSpacing.md),
                    const Text(
                      'Welcome back',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.w800,
                        color: SavingorColors.darkGreen,
                        height: 1.1,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      'Here\u2019s your savings overview.',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                        color: SavingorColors.darkGreen.withOpacity(0.72),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: SavingorSpacing.lg),
              _cardShell(
                highlighted: true,
                child: const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      'Estimated savings',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: SavingorColors.textSecondary,
                      ),
                    ),
                    SizedBox(height: 6),
                    Text(
                      '\$0',
                      style: TextStyle(
                        fontSize: 38,
                        fontWeight: FontWeight.w800,
                        color: SavingorColors.darkGreen,
                        height: 1.05,
                      ),
                    ),
                    SizedBox(height: SavingorSpacing.sm),
                    Text(
                      'Start adding receipts to track your savings.',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: SavingorColors.textSecondary,
                        height: 1.4,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: SavingorSpacing.md),
              Row(
                children: <Widget>[
                  Expanded(
                    child: _metricCard(
                      icon: Icons.shopping_bag_outlined,
                      label: 'This month',
                      value: '\$0',
                    ),
                  ),
                  const SizedBox(width: SavingorSpacing.sm),
                  Expanded(
                    child: _metricCard(
                      icon: Icons.receipt_long_outlined,
                      label: 'Receipts',
                      value: '0',
                    ),
                  ),
                  const SizedBox(width: SavingorSpacing.sm),
                  Expanded(
                    child: _metricCard(
                      icon: Icons.checklist_rounded,
                      label: 'List items',
                      value: '0',
                    ),
                  ),
                ],
              ),
              const SizedBox(height: SavingorSpacing.md),
              _cardShell(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    const Text(
                      'Monthly savings goal',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: SavingorColors.darkGreen,
                      ),
                    ),
                    const SizedBox(height: 6),
                    const Text(
                      'Goal: \$100',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: SavingorColors.textSecondary,
                      ),
                    ),
                    const SizedBox(height: SavingorSpacing.md),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(999),
                      child: LinearProgressIndicator(
                        value: progress,
                        minHeight: 10,
                        backgroundColor: SavingorColors.lightGreen.withOpacity(0.4),
                        valueColor: const AlwaysStoppedAnimation<Color>(
                          SavingorColors.primaryStroke,
                        ),
                      ),
                    ),
                    const SizedBox(height: SavingorSpacing.sm),
                    const Text(
                      '\$0 / \$100',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: SavingorColors.darkGreen,
                      ),
                    ),
                    const SizedBox(height: 6),
                    const Text(
                      'Add receipts to start tracking your progress.',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                        color: SavingorColors.textSecondary,
                        height: 1.35,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: SavingorSpacing.md),
              _cardShell(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    const Text(
                      'AI Savings Assistant',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: SavingorColors.darkGreen,
                      ),
                    ),
                    const SizedBox(height: SavingorSpacing.sm),
                    const Text(
                      'Add receipts and shopping lists to get personalized savings insights.',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: SavingorColors.textSecondary,
                        height: 1.4,
                      ),
                    ),
                    const SizedBox(height: SavingorSpacing.md),
                    TextButton(
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text(
                              'AI insights will be available after adding receipts.',
                            ),
                          ),
                        );
                      },
                      style: TextButton.styleFrom(
                        foregroundColor: SavingorColors.darkGreen,
                        textStyle: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      child: const Text('View insights'),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: SavingorSpacing.md),
              _cardShell(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    const Text(
                      'Recent activity',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: SavingorColors.darkGreen,
                      ),
                    ),
                    const SizedBox(height: SavingorSpacing.md),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Container(
                          width: 34,
                          height: 34,
                          decoration: BoxDecoration(
                            color: SavingorColors.lightGreen,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Icon(
                            Icons.hourglass_empty_rounded,
                            size: 18,
                            color: SavingorColors.darkGreen.withOpacity(0.84),
                          ),
                        ),
                        const SizedBox(width: SavingorSpacing.md),
                        const Expanded(
                          child: Text(
                            'No activity yet. Add your first receipt or shopping list item.',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: SavingorColors.textSecondary,
                              height: 1.4,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
