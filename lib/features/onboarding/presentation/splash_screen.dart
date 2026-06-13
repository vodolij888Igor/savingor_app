import 'dart:math' show min;

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:savingor_app/core/app_state.dart';
import 'package:savingor_app/core/i18n/startup_flow_strings.dart';
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

List<_OnboardingPageData> _onboardingPagesForLocale(String? langCode) {
  final code = StartupFlowStrings.normalizeLanguageCode(langCode);
  String t(String key) => StartupFlowStrings.forLang(code, key);
  return [
    _OnboardingPageData(
      imagePath: 'assets/images/splash.png',
      title: 'Savingor',
      subtitle: t('hero_subtitle'),
      buttonLabel: t('btn_get_started'),
      isBrandPage: true,
    ),
    _OnboardingPageData(
      imagePath: 'assets/images/onboarding_1.png',
      title: t('slide1_title'),
      subtitle: t('slide1_subtitle'),
      buttonLabel: t('btn_next'),
    ),
    _OnboardingPageData(
      imagePath: 'assets/images/onboarding_2.png',
      title: t('slide2_title'),
      subtitle: t('slide2_subtitle'),
      buttonLabel: t('btn_next'),
    ),
    _OnboardingPageData(
      imagePath: 'assets/images/onboarding_3.png',
      title: t('slide3_title'),
      subtitle: t('slide3_subtitle'),
      buttonLabel: t('btn_get_started'),
    ),
  ];
}

class _SplashScreenState extends State<SplashScreen> {
  final PageController _controller = PageController();
  int _page = 0;

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

  void _onPrimaryAction(List<_OnboardingPageData> pages) {
    if (_page < pages.length - 1) {
      _controller.nextPage(
        duration: const Duration(milliseconds: 260),
        curve: Curves.easeOut,
      );
      return;
    }
    AppStateProvider.of(context).setOnboardingFlowCompleted();
    context.go('/auth');
  }

  @override
  Widget build(BuildContext context) {
    final pages =
        _onboardingPagesForLocale(AppStateProvider.of(context).language);
    final current = pages[_page];
    final firstPage = _page == 0;

    final onboardingFooter = Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (firstPage) const SizedBox(height: 16),
        _OnboardingDots(activeIndex: _page, count: pages.length),
        SizedBox(height: firstPage ? 24 : 16),
        // CTA: [SavingorTheme.lightTheme] filled button (approved soft green + dark label).
        FilledButton(
          onPressed: () => _onPrimaryAction(pages),
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
              itemCount: pages.length,
              onPageChanged: (value) => setState(() => _page = value),
              itemBuilder: (context, index) {
                final page = pages[index];
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

  /// Slide 1 headline stack — uses the shared [SavingorTextStyles] so it stays
  /// visually aligned with the language screen and the rest of the onboarding.
  Widget _approvedSecondSlideCopy(
    BuildContext context, {
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
                style: SavingorTextStyles.onboardingTitle.copyWith(
                  shadows: titleShadows,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                data.subtitle,
                textAlign: TextAlign.center,
                style: SavingorTextStyles.onboardingSubtitle.copyWith(
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
  Widget _fourthSlideCopy(BuildContext context) {
    final maxCopyW = min(
      MediaQuery.sizeOf(context).width - 48,
      352.0,
    );
    final maxSubtitleW = min(
      MediaQuery.sizeOf(context).width - 52,
      326.0,
    );
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
                style: SavingorTextStyles.onboardingTitle.copyWith(
                  shadows: titleShadows,
                ),
              ),
              const SizedBox(height: 13),
              ConstrainedBox(
                constraints: BoxConstraints(maxWidth: maxSubtitleW),
                child: Text(
                  data.subtitle,
                  textAlign: TextAlign.center,
                  style: SavingorTextStyles.onboardingSubtitle.copyWith(
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

  /// Slide 2 — receipt copy framed by a soft glass veil; typography unified
  /// via [SavingorTextStyles] to match the language screen + other slides.
  Widget _thirdSlideCopy(BuildContext context) {
    final screenW = MediaQuery.sizeOf(context).width;
    final maxTitleW = min(screenW - 44, 332.0);
    final maxSubtitleW = min(screenW - 48, 310.0);

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
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    ConstrainedBox(
                      constraints: BoxConstraints(maxWidth: maxTitleW),
                      child: Text(
                        data.title,
                        textAlign: TextAlign.center,
                        style: SavingorTextStyles.onboardingTitle.copyWith(
                          shadows: titleShadows,
                        ),
                      ),
                    ),
                    const SizedBox(height: 14),
                    ConstrainedBox(
                      constraints: BoxConstraints(maxWidth: maxSubtitleW),
                      child: Text(
                        data.subtitle,
                        textAlign: TextAlign.center,
                        style: SavingorTextStyles.onboardingSubtitle.copyWith(
                          shadows: _thirdSubtitleShadows,
                        ),
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
    // Slide 0: Brand block — logo + wordmark imagery untouched; subtitle uses
    // the shared [SavingorTextStyles] so it matches the rest of the flow.
    if (data.isBrandPage) {
      return Transform.translate(
        offset: const Offset(13, 24),
        child: _BrandHeadline(
          data: data,
          shadows: titleShadows,
          logoAssetPath: logoAssetPath,
        ),
      );
    }

    if (pageIndex == 1) {
      return _approvedSecondSlideCopy(context, topPadding: 70);
    }

    if (pageIndex == 2) {
      return _thirdSlideCopy(context);
    }

    if (pageIndex == 3) {
      return _fourthSlideCopy(context);
    }

    return const SizedBox.shrink();
  }
}

/// Slide 0 hero composition — logo + wordmark imagery is frozen; the brand
/// subtitle uses the shared [SavingorTextStyles.onboardingSubtitle] so the
/// startup/onboarding flow reads as one consistent system.
class _BrandHeadline extends StatelessWidget {
  const _BrandHeadline({
    required this.data,
    required this.shadows,
    required this.logoAssetPath,
  });

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
                  style: SavingorTextStyles.onboardingSubtitle.copyWith(
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
            color: active ? SavingorColors.onboardingDotActive : _inactive,
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
                      color:
                          SavingorColors.onboardingDotActive.withOpacity(0.45),
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
