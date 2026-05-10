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

/// Copy colors for slides 3–4 only (indices 2–3); slides 0–1 use approved tokens above.
abstract final class _OnboardingCopyColors {
  static const Color title = Color(0xFF052E16);
  static const Color subtitle = Color(0xFF14532D);
}

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
      title: 'Scan receipts, get cashback',
      subtitle:
          'Upload your receipt and unlock exclusive offers and cash rewards.',
      buttonLabel: 'Next',
    ),
    _OnboardingPageData(
      imagePath: 'assets/images/onboarding_3.png',
      title: 'All your lists in one place',
      subtitle: 'Organize shopping, plan meals and never forget anything.',
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
                final image = Image.asset(
                  _pages[index].imagePath,
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
                firstPage ? 26 : 16,
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
                  if (firstPage) const SizedBox(height: 16),
                  _OnboardingDots(activeIndex: _page, count: _pages.length),
                  SizedBox(height: firstPage ? 24 : 16),
                  // CTA: [SavingorTheme.lightTheme] filled button (approved soft green + dark label).
                  FilledButton(
                    onPressed: _onPrimaryAction,
                    child: Text(current.buttonLabel),
                  ),
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
      final maxCopyW = min(
        MediaQuery.sizeOf(context).width - 48,
        340.0,
      );
      return Padding(
        padding: const EdgeInsets.only(top: 70),
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

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          data.title,
          textAlign: TextAlign.center,
          style: theme.titleLarge?.copyWith(
                color: _OnboardingCopyColors.title,
                fontWeight: FontWeight.w700,
                height: 1.22,
                letterSpacing: -0.35,
                fontSize: 24,
                shadows: titleShadows,
              ) ??
              TextStyle(
                color: _OnboardingCopyColors.title,
                fontWeight: FontWeight.w700,
                height: 1.22,
                letterSpacing: -0.35,
                fontSize: 24,
                shadows: titleShadows,
              ),
        ),
        const SizedBox(height: 10),
        Text(
          data.subtitle,
          textAlign: TextAlign.center,
          style: theme.bodyMedium?.copyWith(
                color: _OnboardingCopyColors.subtitle,
                height: 1.45,
                fontSize: 15,
                fontWeight: FontWeight.w500,
                shadows: titleShadows,
              ) ??
              TextStyle(
                color: _OnboardingCopyColors.subtitle,
                height: 1.45,
                fontSize: 15,
                fontWeight: FontWeight.w500,
                shadows: titleShadows,
              ),
        ),
      ],
    );
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
