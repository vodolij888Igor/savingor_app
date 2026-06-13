import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:savingor_app/core/theme/savingor_design_system.dart';
import 'package:savingor_app/core/widgets/savingor_interactive.dart';
import 'package:savingor_app/features/subscription/domain/savingor_feature.dart';
import 'package:savingor_app/features/subscription/presentation/widgets/pro_feature_presentation.dart';
import 'package:savingor_app/l10n/app_localizations.dart';

/// Reusable Pro locked-state preview for premium savings-intelligence features.
class ProFeatureLockedPreview extends StatelessWidget {
  const ProFeatureLockedPreview({
    super.key,
    required this.feature,
    required this.bottomInset,
    this.onOpenPlans,
  });

  final SavingorFeature feature;
  final double bottomInset;
  final VoidCallback? onOpenPlans;

  @override
  Widget build(BuildContext context) {
    final AppLocalizations l10n = AppLocalizations.of(context);
    final SavingorThemeExtension theme = context.savingor;
    final ProFeaturePresentation presentation =
        ProFeaturePresentation.forFeature(feature, l10n);

    Future<void> openPlans() async {
      if (onOpenPlans != null) {
        onOpenPlans!();
        return;
      }
      await context.push('/subscription');
    }

    return SingleChildScrollView(
      padding: EdgeInsets.fromLTRB(20, 8, 20, 24 + bottomInset),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(22),
        child: Container(
          padding: const EdgeInsets.fromLTRB(22, 22, 22, 24),
          decoration: theme.isDark
              ? BoxDecoration(
                  color: theme.surfaceStrong,
                  border: Border.all(color: theme.border, width: 0.75),
                  boxShadow: theme.cardShadow,
                )
              : const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: <Color>[
                      Color(0xFFF6FBF8),
                      Color(0xFFF0F9F4),
                      Color(0xFFFBF9F4),
                      Color(0xFFFAFAF7),
                    ],
                    stops: <double>[0.0, 0.42, 0.72, 1.0],
                  ),
                  border: Border.fromBorderSide(
                    BorderSide(
                      color: Color(0x244F9D47),
                      width: 0.75,
                    ),
                  ),
                  boxShadow: <BoxShadow>[
                    BoxShadow(
                      color: Color(0x0A4F9D47),
                      blurRadius: 16,
                      offset: Offset(0, 4),
                    ),
                    BoxShadow(
                      color: Color(0x06000000),
                      blurRadius: 8,
                      offset: Offset(0, 2),
                    ),
                  ],
                ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Row(
                children: <Widget>[
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: theme.isDark
                          ? theme.selectedHighlight
                          : SavingorColors.lightGreen,
                      borderRadius: BorderRadius.circular(SavingorRadius.pill),
                      border: Border.all(
                        color: theme.isDark
                            ? theme.accentGreen.withOpacity(0.35)
                            : SavingorColors.primaryStroke.withOpacity(0.22),
                      ),
                    ),
                    child: Text(
                      l10n.pro,
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w800,
                        color: theme.isDark
                            ? theme.brandTitle
                            : SavingorColors.darkGreen,
                        letterSpacing: 0.2,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: SavingorSpacing.lg),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Container(
                    width: 58,
                    height: 58,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: theme.surfacePrimary,
                      border: Border.all(
                        color: SavingorColors.primaryStroke.withOpacity(0.2),
                      ),
                      boxShadow: theme.isDark
                          ? null
                          : const <BoxShadow>[
                              BoxShadow(
                                color: Color(0x0F4F9D47),
                                blurRadius: 10,
                                offset: Offset(0, 3),
                              ),
                            ],
                    ),
                    child: Icon(
                      presentation.icon,
                      color: theme.brandTitle,
                      size: 28,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          presentation.title,
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w800,
                            color: theme.isDark
                                ? theme.textPrimary
                                : SavingorColors.darkGreen,
                            height: 1.2,
                            letterSpacing: -0.15,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          presentation.description,
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: theme.textSecondary,
                            height: 1.45,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: SavingorSpacing.xl),
              ...presentation.benefits.map(
                (String benefit) => Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Container(
                        width: 22,
                        height: 22,
                        decoration: BoxDecoration(
                          color: theme.isDark
                              ? theme.accentGreen.withOpacity(0.22)
                              : SavingorColors.primaryStroke.withOpacity(0.14),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.check_rounded,
                          size: 14,
                          color: theme.isDark
                              ? theme.brandTitle
                              : SavingorColors.primaryStroke,
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          benefit,
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: theme.isDark
                                ? theme.textPrimary
                                : const Color(0xFF1A2E24),
                            height: 1.35,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: SavingorSpacing.md),
              SavingorInteractiveFilledButton(
                onPressed: openPlans,
                width: double.infinity,
                borderRadius: BorderRadius.circular(18),
                child: Text(l10n.unlockWithSavingorPro),
              ),
              const SizedBox(height: SavingorSpacing.sm),
              Center(
                child: SavingorInteractiveTextButton(
                  onPressed: openPlans,
                  foregroundColor: theme.brandTitle,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 8,
                  ),
                  child: Text(
                    l10n.viewProBenefits,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
