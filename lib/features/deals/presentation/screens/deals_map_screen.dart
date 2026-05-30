import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:savingor_app/core/theme/savingor_design_system.dart';

/// First-tab Savingor home dashboard (demo data). Routed as [DealsMapScreen].
class DealsMapScreen extends StatelessWidget {
  const DealsMapScreen({super.key});

  static const Color _pageWhite = Color(0xFFFFFEFE);
  static const Color _nearBlack = Color(0xFF111827);
  static const Color _airyBorder = Color(0xFFF3F4F3);
  static const double _goalAmount = 100;
  static const double _goalProgress = 47;

  BoxDecoration _airyCardDecoration({double radius = 18}) {
    return BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(radius),
      border: Border.all(color: _airyBorder.withOpacity(0.6), width: 0.5),
      boxShadow: <BoxShadow>[
        BoxShadow(
          color: Colors.black.withOpacity(0.04),
          blurRadius: 12,
          offset: const Offset(0, 2),
        ),
      ],
    );
  }

  Widget _heroSparkle({double size = 4}) {
    return Icon(
      Icons.circle,
      size: size,
      color: SavingorColors.primaryStroke.withOpacity(0.28),
    );
  }

  Widget _metricCard({
    required IconData icon,
    required String title,
    required String value,
    required String suffix,
    required Color iconColor,
    double iconSize = 33,
  }) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 13),
        decoration: _airyCardDecoration(radius: 14),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Icon(icon, size: iconSize, color: iconColor),
            const SizedBox(height: 10),
            Text(
              title,
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 9,
                fontWeight: FontWeight.w500,
                color: SavingorColors.textSecondary.withOpacity(0.78),
                height: 1.1,
              ),
            ),
            const SizedBox(height: 5),
            Text(
              value,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w800,
                color: _nearBlack,
                height: 1.05,
                letterSpacing: -0.3,
              ),
            ),
            const SizedBox(height: 3),
            Text(
              suffix,
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 9,
                fontWeight: FontWeight.w500,
                color: SavingorColors.textSecondary.withOpacity(0.72),
                height: 1.1,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _snack(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  void _onStartSaving(BuildContext context) {
    context.push('/start-saving');
  }

  @override
  Widget build(BuildContext context) {
    final double progress = (_goalProgress / _goalAmount).clamp(0, 1);
    final double bottomInset = MediaQuery.paddingOf(context).bottom;

    return Scaffold(
      backgroundColor: _pageWhite,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.fromLTRB(20, 0, 20, 32 + bottomInset + 72),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              _buildHeader(context),
              const SizedBox(height: 44),
              _buildSavingsHero(progress),
              const SizedBox(height: SavingorSpacing.xl),
              _buildStartSavingButton(context),
              const SizedBox(height: SavingorSpacing.xl),
              _buildMetricsRow(),
              const SizedBox(height: SavingorSpacing.xl),
              _buildMonthlyGoal(progress),
              const SizedBox(height: SavingorSpacing.xl),
              _buildAiCallout(context),
              const SizedBox(height: SavingorSpacing.xl),
              _buildTopDeals(context),
              const SizedBox(height: SavingorSpacing.xl),
              _buildRecentActivity(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        const SizedBox(height: 14),
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(SavingorRadius.pill),
                border: Border.all(color: _airyBorder.withOpacity(0.5), width: 0.5),
              ),
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Text(
                    '🇨🇦',
                    style: TextStyle(fontSize: 14, height: 1.1),
                  ),
                  SizedBox(width: 6),
                  Text(
                    'Canada • CAD',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      color: SavingorColors.darkGreen,
                      height: 1.1,
                    ),
                  ),
                ],
              ),
            ),
            const Spacer(),
            IconButton(
              onPressed: () => _snack(context, 'Notifications coming soon.'),
              icon: const Icon(Icons.notifications_none_rounded),
              color: SavingorColors.darkGreen,
              style: IconButton.styleFrom(
                backgroundColor: Colors.white,
                padding: const EdgeInsets.all(8),
                side: BorderSide(color: _airyBorder.withOpacity(0.5), width: 0.5),
              ),
            ),
            const SizedBox(width: 4),
            _buildStreakBadge(context),
          ],
        ),
        const SizedBox(height: 6),
        const Text(
          'Welcome back, Igor! 👋',
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.w800,
            color: SavingorColors.darkGreen,
            height: 1.1,
            letterSpacing: -0.4,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          'Ready to save smarter today?',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: SavingorColors.textSecondary.withOpacity(0.95),
            height: 1.35,
          ),
        ),
      ],
    );
  }

  Widget _buildStreakBadge(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () => _snack(context, 'Streak details coming soon.'),
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.fromLTRB(10, 7, 4, 7),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: _airyBorder.withOpacity(0.5), width: 0.5),
            boxShadow: <BoxShadow>[
              BoxShadow(
                color: Colors.black.withOpacity(0.04),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    '🔥 12',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w800,
                      color: _nearBlack,
                      height: 1.1,
                    ),
                  ),
                  Text(
                    'Day streak',
                    style: TextStyle(
                      fontSize: 9,
                      fontWeight: FontWeight.w500,
                      color: SavingorColors.textSecondary,
                      height: 1.1,
                    ),
                  ),
                ],
              ),
              Icon(
                Icons.chevron_right_rounded,
                size: 16,
                color: SavingorColors.textSecondary.withOpacity(0.65),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSavingsHero(double ringProgress) {
    const double ringSize = 220;

    return Column(
      children: <Widget>[
        Center(
          child: SizedBox(
            width: ringSize,
            height: ringSize,
            child: Stack(
              clipBehavior: Clip.none,
              alignment: Alignment.center,
              children: <Widget>[
                SizedBox(
                  width: ringSize,
                  height: ringSize,
                  child: CircularProgressIndicator(
                    value: ringProgress,
                    strokeWidth: 10,
                    strokeCap: StrokeCap.round,
                    backgroundColor: const Color(0xFFF3F5F4),
                    valueColor: const AlwaysStoppedAnimation<Color>(
                      SavingorColors.primaryGreen,
                    ),
                  ),
                ),
                Container(
                  width: ringSize - 40,
                  height: ringSize - 40,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white,
                  ),
                  alignment: Alignment.center,
                  child: const Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Text(
                        '\$47.80',
                        style: TextStyle(
                          fontSize: 42,
                          fontWeight: FontWeight.w800,
                          color: _nearBlack,
                          height: 1,
                          letterSpacing: -1.5,
                        ),
                      ),
                      SizedBox(height: 4),
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
                        'Nice work!',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                          color: SavingorColors.primaryStroke,
                        ),
                      ),
                    ],
                  ),
                ),
                Positioned(top: 6, right: 2, child: _heroSparkle(size: 5)),
                Positioned(top: 36, left: -2, child: _heroSparkle(size: 3.5)),
                Positioned(bottom: 22, right: -4, child: _heroSparkle(size: 4)),
              ],
            ),
          ),
        ),
        const SizedBox(height: SavingorSpacing.md),
        const Text(
          '+ \$8.40 vs last month',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w700,
            color: SavingorColors.primaryStroke,
          ),
        ),
      ],
    );
  }

  Widget _buildStartSavingButton(BuildContext context) {
    return Material(
      borderRadius: BorderRadius.circular(28),
      elevation: 0,
      child: InkWell(
        onTap: () => _onStartSaving(context),
        borderRadius: BorderRadius.circular(28),
        child: Ink(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(28),
            gradient: const LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: <Color>[
                Color(0xFF9AD88F),
                Color(0xFF7BC96F),
                SavingorColors.primaryGreen,
              ],
              stops: <double>[0.0, 0.45, 1.0],
            ),
            boxShadow: <BoxShadow>[
              BoxShadow(
                color: SavingorColors.primaryStroke.withOpacity(0.28),
                blurRadius: 16,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: const Padding(
            padding: EdgeInsets.symmetric(horizontal: 24, vertical: 23),
            child: Center(
              child: Row(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Text(
                    '✨ START SAVING',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w800,
                      color: SavingorColors.darkGreen,
                      height: 1.0,
                      letterSpacing: 0.4,
                    ),
                  ),
                  SizedBox(width: 16),
                  Icon(
                    Icons.arrow_forward_rounded,
                    size: 20,
                    color: SavingorColors.darkGreen,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildMetricsRow() {
    return SizedBox(
      height: 126,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          _metricCard(
            icon: Icons.trending_up,
            iconSize: 38,
            title: 'This month',
            value: '\$47.80',
            suffix: 'saved',
            iconColor: const Color(0xFFEF4444),
          ),
          const SizedBox(width: 7),
          _metricCard(
            icon: Icons.receipt_long_outlined,
            iconSize: 33,
            title: 'Receipts',
            value: '12',
            suffix: 'scanned',
            iconColor: const Color(0xFF5B8FA8),
          ),
          const SizedBox(width: 7),
          _metricCard(
            icon: Icons.checklist_rounded,
            iconSize: 33,
            title: 'Shopping list',
            value: '28',
            suffix: 'items',
            iconColor: const Color(0xFFC4895A),
          ),
          const SizedBox(width: 7),
          _metricCard(
            icon: Icons.local_offer_outlined,
            iconSize: 33,
            title: 'Active deals',
            value: '14',
            suffix: 'today',
            iconColor: const Color(0xFF8B6BA8),
          ),
        ],
      ),
    );
  }

  Widget _buildMonthlyGoal(double progress) {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 20),
      decoration: _airyCardDecoration(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          const Text(
            'Monthly goal',
            style: TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.w700,
              color: SavingorColors.darkGreen,
            ),
          ),
          const SizedBox(height: SavingorSpacing.md),
          Row(
            children: <Widget>[
              const Text(
                '\$47 / \$100',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w800,
                  color: _nearBlack,
                ),
              ),
              const Spacer(),
              Text(
                '${(_goalProgress).round()}%',
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                  color: SavingorColors.primaryStroke,
                ),
              ),
            ],
          ),
          const SizedBox(height: SavingorSpacing.md),
          ClipRRect(
            borderRadius: BorderRadius.circular(999),
            child: LinearProgressIndicator(
              value: progress,
              minHeight: 8,
              backgroundColor: const Color(0xFFF0F2F1),
              valueColor: const AlwaysStoppedAnimation<Color>(
                SavingorColors.primaryGreen,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAiCallout(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(24, 24, 24, 22),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: <Color>[
            SavingorColors.lightGreen.withOpacity(0.72),
            const Color(0xFFEAF6E8),
            Colors.white.withOpacity(0.85),
          ],
          stops: const <double>[0.0, 0.55, 1.0],
        ),
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: _airyBorder.withOpacity(0.45), width: 0.5),
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: SavingorColors.primaryStroke.withOpacity(0.08),
            blurRadius: 20,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          const Text(
            '✨ AI Savings Assistant',
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w700,
              color: SavingorColors.darkGreen,
              height: 1.2,
              letterSpacing: -0.1,
            ),
          ),
          const SizedBox(height: 18),
          const Text(
            '+\$12.40',
            style: TextStyle(
              fontSize: 40,
              fontWeight: FontWeight.w800,
              color: _nearBlack,
              height: 1.0,
              letterSpacing: -1.2,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            'Potential savings this week',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: SavingorColors.textSecondary.withOpacity(0.92),
              height: 1.25,
            ),
          ),
          const SizedBox(height: 14),
          Text(
            'Switch 3 products to better deals.',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: SavingorColors.darkGreen.withOpacity(0.82),
              height: 1.35,
            ),
          ),
          const SizedBox(height: 18),
          Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: () => _snack(
                context,
                'AI insights will be available after adding receipts.',
              ),
              borderRadius: BorderRadius.circular(8),
              child: const Padding(
                padding: EdgeInsets.symmetric(vertical: 2),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      'View insight',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: SavingorColors.primaryStroke,
                        height: 1.2,
                      ),
                    ),
                    SizedBox(width: 4),
                    Icon(
                      Icons.arrow_forward_rounded,
                      size: 16,
                      color: SavingorColors.primaryStroke,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTopDeals(BuildContext context) {
    const List<_DealPreview> deals = <_DealPreview>[
      _DealPreview(
        emoji: '🍌',
        title: 'Bananas 1 lb',
        store: 'Walmart',
        price: '\$0.68',
        save: 'Save \$0.31',
      ),
      _DealPreview(
        emoji: '🍗',
        title: 'Chicken Breast',
        store: 'Costco',
        price: '\$3.79',
        save: 'Save \$2.20',
      ),
      _DealPreview(
        emoji: '🥛',
        title: 'Milk 2L',
        store: 'No Frills',
        price: '\$1.89',
        save: 'Save \$0.90',
      ),
      _DealPreview(
        emoji: '🍞',
        title: 'Whole Wheat Bread',
        store: 'Metro',
        price: '\$2.49',
        save: 'Save \$0.80',
      ),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Row(
          children: <Widget>[
            const Expanded(
              child: Text(
                'Top deals for you',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                  color: SavingorColors.darkGreen,
                ),
              ),
            ),
            TextButton(
              onPressed: () => _snack(context, 'All deals coming soon.'),
              style: TextButton.styleFrom(
                foregroundColor: SavingorColors.primaryStroke,
                padding: EdgeInsets.zero,
                minimumSize: Size.zero,
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
              child: const Text(
                'See all',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: SavingorSpacing.sm),
        SizedBox(
          height: 210,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: deals.length,
            separatorBuilder: (_, __) => const SizedBox(width: SavingorSpacing.sm),
            itemBuilder: (BuildContext context, int index) {
              return _DealTile(deal: deals[index]);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildRecentActivity() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 18),
      decoration: _airyCardDecoration(radius: 18),
      child: Row(
        children: <Widget>[
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: SavingorColors.lightGreen.withOpacity(0.55),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(
              Icons.receipt_long_rounded,
              color: SavingorColors.primaryStroke.withOpacity(0.9),
              size: 22,
            ),
          ),
          const SizedBox(width: SavingorSpacing.md),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  'Receipt added',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: SavingorColors.darkGreen,
                    height: 1.2,
                  ),
                ),
                SizedBox(height: 5),
                Text(
                  'Walmart • May 27, 2026',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                    color: SavingorColors.textSecondary,
                    height: 1.3,
                  ),
                ),
              ],
            ),
          ),
          const Text(
            '\$82.40',
            style: TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.w800,
              color: _nearBlack,
              letterSpacing: -0.2,
            ),
          ),
        ],
      ),
    );
  }
}

class _DealPreview {
  const _DealPreview({
    required this.emoji,
    required this.title,
    required this.store,
    required this.price,
    required this.save,
  });

  final String emoji;
  final String title;
  final String store;
  final String price;
  final String save;
}

class _DealTile extends StatelessWidget {
  const _DealTile({required this.deal});

  static const double _tileHeight = 210;

  final _DealPreview deal;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 160,
      height: _tileHeight,
      child: Container(
        padding: const EdgeInsets.fromLTRB(12, 12, 12, 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color: DealsMapScreen._airyBorder.withOpacity(0.6),
            width: 0.5,
          ),
          boxShadow: <BoxShadow>[
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 12,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Center(
              child: Text(
                deal.emoji,
                style: const TextStyle(fontSize: 44, height: 1.05),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              deal.title,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w700,
                color: DealsMapScreen._nearBlack,
                height: 1.2,
              ),
            ),
            const SizedBox(height: 3),
            Text(
              deal.store,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w500,
                color: SavingorColors.textSecondary,
              ),
            ),
            const Spacer(),
            Text(
              deal.price,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w800,
                color: DealsMapScreen._nearBlack,
              ),
            ),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              decoration: BoxDecoration(
                color: SavingorColors.primaryGreen.withOpacity(0.75),
                borderRadius: BorderRadius.circular(SavingorRadius.pill),
              ),
              child: Text(
                deal.save,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w800,
                  color: DealsMapScreen._nearBlack,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
