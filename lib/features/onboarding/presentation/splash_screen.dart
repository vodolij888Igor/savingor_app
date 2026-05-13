import 'dart:math' show min;

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:savingor_app/core/theme/savingor_design_system.dart';

// -----------------------------------------------------------------------------
// ONBOARDING VISUAL LOCK — APPROVED PORTFOLIO UI (slides 0 & 1)
//
// PageView index 0 (hero brand) and index 1 (“Smart savings…”) are frozen layouts:
// spacing, crops, typography scales, and imagery framing are signed-off.
//
// Do NOT redesign these slides unless there is explicit written instruction to do so.
// Future onboarding polish should target indices 2–3 only, unless an exception is
// granted for slide 0 or 1.
//
// Shared greens / CTA / dots use [SavingorColors] + theme-filled buttons where noted.
// -----------------------------------------------------------------------------

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final PageController _controller = PageController();
  int _page = 0;

  static const List<_OnboardingPageData> _pages = [
    _OnboardingPageData(
      imagePath: 'assets/images/splash.png',
      title: 'Savingor',
      subtitle: 'Money Saved, Money Earned.',
      buttonLabel: 'Get Started',
      isBrandPage: true,
    ),
    _OnboardingPageData(
      imagePath: 'assets/images/onboarding_1.png',
      title: 'Smart savings every day',
      subtitle: 'Find the best deals, track prices and save on every shop.',
      buttonLabel: 'Next',
    ),
    _OnboardingPageData(
      imagePath: 'assets/images/onboarding_2.png',
      title: 'Scan receipts, save smarter',
      subtitle:
          'See where your money goes and discover better ways to save.',
      buttonLabel: 'Next',
    ),
    _OnboardingPageData(
      imagePath: 'assets/images/onboarding_3.png',
      title: 'Plan your shopping smarter',
      subtitle:
          'Savingor helps you plan your shopping list and see where each item is better to buy.',
      buttonLabel: 'Get Started',
    ),
  ];

  static const String _brandLogoAsset = 'assets/images/logo_Savingor.png';

  static List<Shadow> get _copyShadows => [
        Shadow(
          color: Colors.white.withOpacity(0.92),
          blurRadius: 14,
          offset: const Offset(0, 1),
        ),
        Shadow(
          color: Colors.black.withOpacity(0.12),
          blurRadius: 10,
          offset: const Offset(0, 2),
        ),
      ];

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onPrimaryAction() {
    if (_page < _pages.length - 1) {
      _controller.nextPage(
        duration: const Duration(milliseconds: 260),
        curve: Curves.easeOut,
      );
      return;
    }
    context.go('/language');
  }

  @override
  Widget build(BuildContext context) {
    final current = _pages[_page];
    final firstPage = _page == 0;

    final onboardingFooter = Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (firstPage) const SizedBox(height: 16),
        _OnboardingDots(activeIndex: _page, count: _pages.length),
        SizedBox(height: firstPage ? 24 : 16),
        // CTA: [SavingorTheme.lightTheme] filled button (approved soft green + dark label).
        FilledButton(
          onPressed: _onPrimaryAction,
          child: Text(current.buttonLabel),
        ),
      ],
    );

    return Scaffold(
      backgroundColor: SavingorColors.background,
      body: Stack(
        fit: StackFit.expand,
        children: [
          Positioned.fill(
            child: PageView.builder(
              controller: _controller,
              itemCount: _pages.length,
              onPageChanged: (value) => setState(() => _page = value),
              itemBuilder: (context, index) {
                final page = _pages[index];
                // Slide 3 (index 2): receipt illustration — contain on matte (APPROVED; unchanged).
                if (index == 2) {
                  return ColoredBox(
                    color: SavingorColors.background,
                    child: LayoutBuilder(
                      builder: (context, constraints) {
                        return Center(
                          child: Image.asset(
                            page.imagePath,
                            fit: BoxFit.contain,
                            width: constraints.maxWidth,
                            height: constraints.maxHeight,
                            alignment: Alignment.center,
                          ),
                        );
                      },
                    ),
                  );
                }
                // Fourth onboarding (index 3): same contain treatment; illustration nudged down only here.
                if (index == 3) {
                  return ColoredBox(
                    color: SavingorColors.background,
                    child: LayoutBuilder(
                      builder: (context, constraints) {
                        return Center(
                          child: Transform.translate(
                            offset: const Offset(0, 28),
                            child: Image.asset(
                              page.imagePath,
                              fit: BoxFit.contain,
                              width: constraints.maxWidth,
                              height: constraints.maxHeight,
                              alignment: Alignment.center,
                            ),
                          ),
                        );
                      },
                    ),
                  );
                }
                final image = Image.asset(
                  page.imagePath,
                  fit: BoxFit.cover,
                  width: double.infinity,
                  height: double.infinity,
                );
                if (index != 0) return image;
                // APPROVED (slide 0): Background framing — do not change offset/crop without sign-off.
                return ClipRect(
                  child: Transform.translate(
                    offset: const Offset(0, -64),
                    child: image,
                  ),
                );
              },
            ),
          ),
          Positioned.fill(
            child: _SubtleVignetteOverlay(strongBottomWash: firstPage),
          ),
          SafeArea(
            child: Padding(
              // Slide 0 uses larger top inset (72) — APPROVED; do not tweak without sign-off.
              padding: EdgeInsets.fromLTRB(
                22,
                firstPage ? 72 : 12,
                22,
                firstPage ? 26 : (_page == 3 ? 12 : 16),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _OnboardingCopy(
                    data: current,
                    titleShadows: _copyShadows,
                    logoAssetPath: _brandLogoAsset,
                    pageIndex: _page,
                  ),
                  const Spacer(),
                  if (_page == 3)
                    Transform.translate(
                      offset: const Offset(0, -22),
                      child: onboardingFooter,
                    )
                  else
                    onboardingFooter,
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Top and bottom-only fades; optional stronger bottom wash on hero page.
class _SubtleVignetteOverlay extends StatelessWidget {
  const _SubtleVignetteOverlay({required this.strongBottomWash});

  final bool strongBottomWash;

  @override
  Widget build(BuildContext context) {
    final bottomHeight = strongBottomWash ? 340.0 : 280.0;
    final bottomPeak = strongBottomWash ? 0.6 : 0.52;

    return IgnorePointer(
      child: Stack(
        fit: StackFit.expand,
        children: [
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            height: 160,
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.white.withOpacity(0.18),
                    Colors.white.withOpacity(0.0),
                  ],
                ),
              ),
            ),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            height: bottomHeight,
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                  colors: [
                    Colors.white.withOpacity(bottomPeak),
                    Colors.white.withOpacity(0.14),
                    Colors.white.withOpacity(0.0),
                  ],
                  stops: const [0.0, 0.42, 1.0],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _OnboardingCopy extends StatelessWidget {
  const _OnboardingCopy({
    required this.data,
    required this.titleShadows,
    required this.logoAssetPath,
    required this.pageIndex,
  });

  final _OnboardingPageData data;
  final List<Shadow> titleShadows;
  final String logoAssetPath;
  /// Current [PageView] index — used to tailor non-brand slides without affecting the hero.
  final int pageIndex;

  static const List<Shadow> _thirdSubtitleShadows = [
    Shadow(
      color: Color(0x0A000000),
      blurRadius: 8,
      offset: Offset(0, 1),
    ),
  ];

  /// Slide 2 (approved) headline stack — frozen; do not alter metrics without sign-off.
  Widget _approvedSecondSlideCopy(
    BuildContext context,
    TextTheme theme, {
    required double topPadding,
  }) {
    final maxCopyW = min(
      MediaQuery.sizeOf(context).width - 48,
      340.0,
    );
    return Padding(
      padding: EdgeInsets.only(top: topPadding),
      child: Align(
        alignment: Alignment.topCenter,
        child: ConstrainedBox(
          constraints: BoxConstraints(maxWidth: maxCopyW),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                data.title,
                textAlign: TextAlign.center,
                style: theme.headlineMedium?.copyWith(
                      color: SavingorColors.darkGreen,
                      fontWeight: FontWeight.w800,
                      fontSize: 32,
                      height: 1.16,
                      letterSpacing: -0.55,
                      shadows: titleShadows,
                    ) ??
                    TextStyle(
                      color: SavingorColors.darkGreen,
                      fontWeight: FontWeight.w800,
                      fontSize: 32,
                      height: 1.16,
                      letterSpacing: -0.55,
                      shadows: titleShadows,
                    ),
              ),
              const SizedBox(height: 12),
              Text(
                data.subtitle,
                textAlign: TextAlign.center,
                style: theme.bodyLarge?.copyWith(
                      color: SavingorColors.onboardingSubtitleDeep,
                      fontSize: 17,
                      height: 1.56,
                      fontWeight: FontWeight.w500,
                      letterSpacing: 0.08,
                      shadows: titleShadows,
                    ) ??
                    TextStyle(
                      color: SavingorColors.onboardingSubtitleDeep,
                      fontSize: 17,
                      height: 1.56,
                      fontWeight: FontWeight.w500,
                      letterSpacing: 0.08,
                      shadows: titleShadows,
                    ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Fourth onboarding slide (index 3): smart shopping list — copy over clean top of `onboarding_3`.
  Widget _fourthSlideCopy(BuildContext context, TextTheme theme) {
    final maxCopyW = min(
      MediaQuery.sizeOf(context).width - 48,
      352.0,
    );
    final maxSubtitleW = min(
      MediaQuery.sizeOf(context).width - 52,
      326.0,
    );
    const titleSize = 33.0;
    const titleLineHeight = 1.14;
    return Padding(
      padding: const EdgeInsets.only(top: 54),
      child: Align(
        alignment: Alignment.topCenter,
        child: ConstrainedBox(
          constraints: BoxConstraints(maxWidth: maxCopyW),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                data.title,
                textAlign: TextAlign.center,
                style: theme.headlineMedium?.copyWith(
                      color: SavingorColors.darkGreen,
                      fontWeight: FontWeight.w800,
                      fontSize: titleSize,
                      height: titleLineHeight,
                      letterSpacing: -0.55,
                      shadows: titleShadows,
                    ) ??
                    TextStyle(
                      color: SavingorColors.darkGreen,
                      fontWeight: FontWeight.w800,
                      fontSize: titleSize,
                      height: titleLineHeight,
                      letterSpacing: -0.55,
                      shadows: titleShadows,
                    ),
              ),
              const SizedBox(height: 13),
              ConstrainedBox(
                constraints: BoxConstraints(maxWidth: maxSubtitleW),
                child: Text(
                  data.subtitle,
                  textAlign: TextAlign.center,
                  style: theme.bodyLarge?.copyWith(
                        color: SavingorColors.onboardingSubtitleDeep,
                        fontSize: 18,
                        height: 1.52,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 0.04,
                        shadows: titleShadows,
                      ) ??
                      TextStyle(
                        color: SavingorColors.onboardingSubtitleDeep,
                        fontSize: 18,
                        height: 1.52,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 0.04,
                        shadows: titleShadows,
                      ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Slide 3 — receipt copy; typography tuned for `onboarding_2` art (not slide 1/2 approved block).
  Widget _thirdSlideCopy(BuildContext context, TextTheme theme) {
    final screenW = MediaQuery.sizeOf(context).width;
    final maxTitleW = min(screenW - 44, 332.0);
    final maxSubtitleW = min(screenW - 48, 310.0);

    const titleSize = 35.0;
    const titleLineHeight = 1.11;
    const titleLetterSpacing = -0.38;
    const titleStrut = StrutStyle(
      fontSize: titleSize,
      height: titleLineHeight,
      fontWeight: FontWeight.w800,
      leadingDistribution: TextLeadingDistribution.even,
      forceStrutHeight: true,
    );
    const titleBehavior = TextHeightBehavior(
      applyHeightToFirstAscent: false,
      applyHeightToLastDescent: false,
      leadingDistribution: TextLeadingDistribution.even,
    );

    final titleStyle = theme.headlineMedium?.copyWith(
          color: SavingorColors.darkGreen,
          fontWeight: FontWeight.w800,
          fontSize: titleSize,
          height: titleLineHeight,
          letterSpacing: titleLetterSpacing,
          shadows: titleShadows,
        ) ??
        TextStyle(
          color: SavingorColors.darkGreen,
          fontWeight: FontWeight.w800,
          fontSize: titleSize,
          height: titleLineHeight,
          letterSpacing: titleLetterSpacing,
          shadows: titleShadows,
        );

    final subtitleStyle = theme.bodyLarge?.copyWith(
          color: SavingorColors.onboardingSubtitleDeep,
          fontSize: 18.5,
          height: 1.45,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.05,
          shadows: _thirdSubtitleShadows,
        ) ??
        const TextStyle(
          color: SavingorColors.onboardingSubtitleDeep,
          fontSize: 18.5,
          height: 1.45,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.05,
          shadows: _thirdSubtitleShadows,
        );

    return Padding(
      padding: const EdgeInsets.only(top: 68),
      child: Align(
        alignment: Alignment.topCenter,
        child: ConstrainedBox(
          constraints: BoxConstraints(maxWidth: maxSubtitleW + 24),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(40),
            child: ColoredBox(
              color: Colors.white.withOpacity(0.055),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    ConstrainedBox(
                      constraints: BoxConstraints(maxWidth: maxTitleW),
                      child: Text(
                        data.title,
                        textAlign: TextAlign.center,
                        textHeightBehavior: titleBehavior,
                        strutStyle: titleStrut,
                        style: titleStyle,
                      ),
                    ),
                    const SizedBox(height: 16),
                    ConstrainedBox(
                      constraints: BoxConstraints(maxWidth: maxSubtitleW),
                      child: Text(
                        data.subtitle,
                        textAlign: TextAlign.center,
                        textHeightBehavior: titleBehavior,
                        style: subtitleStyle,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).textTheme;

    // APPROVED (slide 0): Brand block — logo, name image, subtitle; frozen layout.
    if (data.isBrandPage) {
      return Transform.translate(
        offset: const Offset(13, 24),
        child: _BrandHeadline(
          theme: theme,
          data: data,
          shadows: titleShadows,
          logoAssetPath: logoAssetPath,
        ),
      );
    }

    // APPROVED (slide 1): Headline + subtitle block — frozen typography & position.
    if (pageIndex == 1) {
      return _approvedSecondSlideCopy(context, theme, topPadding: 70);
    }

    if (pageIndex == 2) {
      return _thirdSlideCopy(context, theme);
    }

    if (pageIndex == 3) {
      return _fourthSlideCopy(context, theme);
    }

    return const SizedBox.shrink();
  }
}

/// Slide 0 hero composition — APPROVED (logo, wordmark, veil, subtitle metrics).
class _BrandHeadline extends StatelessWidget {
  const _BrandHeadline({
    required this.theme,
    required this.data,
    required this.shadows,
    required this.logoAssetPath,
  });

  final TextTheme theme;
  final _OnboardingPageData data;
  final List<Shadow> shadows;
  final String logoAssetPath;

  /// Target ~68–72 logical px wide; smaller than name width so the wordmark leads.
  static const double _logoWidth = 70;
  static const double _subtitleMaxWidth = 300;
  static const String _brandNameAsset = 'assets/images/name_Savingor.png';

  @override
  Widget build(BuildContext context) {
    final screenW = MediaQuery.sizeOf(context).width;
    final nameW = min(screenW * 0.72, 300.0);

    return Stack(
      clipBehavior: Clip.none,
      alignment: Alignment.topCenter,
      children: [
        Positioned(
          left: -56,
          right: -56,
          top: -28,
          bottom: -24,
          child: IgnorePointer(
            child: DecoratedBox(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(140),
                gradient: RadialGradient(
                  center: const Alignment(0, -0.12),
                  radius: 1.05,
                  colors: [
                    const Color(0xFFFFF8F0).withOpacity(0.34),
                    const Color(0xFFFFFDF9).withOpacity(0.14),
                    Colors.white.withOpacity(0.0),
                  ],
                  stops: const [0.0, 0.42, 1.0],
                ),
              ),
            ),
          ),
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Center(
              child: Image.asset(
                logoAssetPath,
                width: _logoWidth,
                fit: BoxFit.contain,
                alignment: Alignment.center,
                filterQuality: FilterQuality.high,
              ),
            ),
            const SizedBox(height: 3),
            SizedBox(
              width: double.infinity,
              child: Center(
                child: Image.asset(
                  _brandNameAsset,
                  width: nameW,
                  fit: BoxFit.contain,
                  alignment: Alignment.center,
                  filterQuality: FilterQuality.high,
                  isAntiAlias: true,
                ),
              ),
            ),
            const SizedBox(height: 7),
            Align(
              alignment: Alignment.center,
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: _subtitleMaxWidth),
                child: Text(
                  data.subtitle,
                  textAlign: TextAlign.center,
                  style: theme.bodyLarge?.copyWith(
                        color: SavingorColors.onboardingSubtitleDeep,
                        fontSize: 16,
                        height: 1.4,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 0.2,
                        shadows: shadows,
                      ) ??
                      TextStyle(
                        color: SavingorColors.onboardingSubtitleDeep,
                        fontSize: 16,
                        height: 1.4,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 0.2,
                        shadows: shadows,
                      ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _OnboardingPageData {
  const _OnboardingPageData({
    required this.imagePath,
    required this.title,
    required this.subtitle,
    required this.buttonLabel,
    this.isBrandPage = false,
  });

  final String imagePath;
  final String title;
  final String subtitle;
  final String buttonLabel;
  final bool isBrandPage;
}

/// Page indicators — APPROVED styling shared across all onboarding slides.
class _OnboardingDots extends StatelessWidget {
  const _OnboardingDots({required this.activeIndex, required this.count});

  final int activeIndex;
  final int count;

  static const Color _inactive = Color(0xFFC5CCC8);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(count, (i) {
        final active = i == activeIndex;
        return AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          margin: const EdgeInsets.symmetric(horizontal: 4),
          width: active ? 26 : 8,
          height: 8,
          decoration: BoxDecoration(
            color: active
                ? SavingorColors.onboardingDotActive
                : _inactive,
            borderRadius: BorderRadius.circular(999),
            border: Border.all(
              color: active
                  ? Colors.white.withOpacity(0.65)
                  : Colors.white.withOpacity(0.35),
              width: active ? 1 : 0,
            ),
            boxShadow: active
                ? [
                    BoxShadow(
                      color: SavingorColors.onboardingDotActive
                          .withOpacity(0.45),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ]
                : null,
          ),
        );
      }),
    );
  }
}
