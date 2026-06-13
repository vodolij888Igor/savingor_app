import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:savingor_app/core/app_settings_options.dart';
import 'package:savingor_app/core/app_state.dart';
import 'package:savingor_app/core/i18n/app_settings_l10n.dart';
import 'package:savingor_app/core/theme/savingor_design_system.dart';
import 'package:savingor_app/features/profile/presentation/widgets/app_settings_pickers.dart';
import 'package:savingor_app/l10n/app_localizations.dart';

/// Dedicated App settings screen, pushed from Profile ("Manage settings").
class AppSettingsScreen extends StatelessWidget {
  const AppSettingsScreen({super.key});

  static const Color _pageBackground = SavingorColors.pageWhite;
  static const Color _titleCharcoal = Color(0xFF1F2937);
  static const double _cardRadius = 22;

  void _goBack(BuildContext context) {
    final NavigatorState navigator = Navigator.of(context);
    if (navigator.canPop()) {
      navigator.pop();
    } else {
      context.go('/profile');
    }
  }

  @override
  Widget build(BuildContext context) {
    final AppState appState = AppStateProvider.of(context);
    final AppLocalizations l10n = AppLocalizations.of(context);
    final double bottomInset = MediaQuery.paddingOf(context).bottom;

    return Scaffold(
      backgroundColor: _pageBackground,
      appBar: AppBar(
        title: Text(
          l10n.appSettings,
          style: SavingorAppTextStyles.screenTitle,
        ),
        centerTitle: false,
        elevation: 0,
        scrolledUnderElevation: 0,
        backgroundColor: _pageBackground,
        surfaceTintColor: Colors.transparent,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_new_rounded,
            color: SavingorColors.darkGreen,
            size: 20,
          ),
          onPressed: () => _goBack(context),
        ),
      ),
      body: SafeArea(
        top: false,
        child: SingleChildScrollView(
          padding: EdgeInsets.fromLTRB(20, 4, 20, 28 + bottomInset + 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              _buildHeroCard(l10n),
              const SizedBox(height: SavingorSpacing.xl),
              _SectionHeading(title: l10n.preferences),
              const SizedBox(height: SavingorSpacing.md),
              _buildPreferencesCard(context, appState, l10n),
              const SizedBox(height: SavingorSpacing.xl),
              _buildNotificationsCard(l10n),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeroCard(AppLocalizations l10n) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(22, 22, 22, 24),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(_cardRadius),
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: <Color>[
            Color(0xFFF2FAF4),
            Color(0xFFFAFAF5),
            Color(0xFFF7FCF8),
          ],
        ),
        border: Border.all(
          color: SavingorColors.primaryStroke.withOpacity(0.14),
          width: 0.75,
        ),
        boxShadow: const <BoxShadow>[
          BoxShadow(
            color: Color(0x0F4F9D47),
            blurRadius: 22,
            offset: Offset(0, 8),
          ),
          BoxShadow(
            color: Color(0x06000000),
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            width: 52,
            height: 52,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: SavingorColors.primaryStroke.withOpacity(0.2),
              ),
              boxShadow: <BoxShadow>[
                BoxShadow(
                  color: SavingorColors.primaryStroke.withOpacity(0.12),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: const Icon(
              Icons.tune_rounded,
              color: SavingorColors.primaryStroke,
              size: 26,
            ),
          ),
          const SizedBox(width: SavingorSpacing.lg),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  l10n.personalizeSavingor,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w800,
                    color: _titleCharcoal,
                    height: 1.2,
                    letterSpacing: -0.2,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  l10n.personalizeSavingorSubtitle,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: SavingorColors.textSecondary.withOpacity(0.95),
                    height: 1.45,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPreferencesCard(
    BuildContext context,
    AppState appState,
    AppLocalizations l10n,
  ) {
    return Container(
      width: double.infinity,
      decoration: SavingorSurfaces.premiumCard(radius: _cardRadius),
      child: Column(
        children: <Widget>[
          _PreferenceRow(
            icon: Icons.language_rounded,
            title: l10n.language,
            value: AppSettingsOptions.languageNativeName(appState.language),
            helper: l10n.appLanguage,
            onTap: () => context.push('/profile/settings/language'),
          ),
          _preferenceDivider(),
          _PreferenceRow(
            icon: Icons.light_mode_rounded,
            title: l10n.appearance,
            value: AppSettingsL10n.appearanceLabel(context, appState.appearance),
            helper: l10n.appearanceHelper,
            onTap: () => showAppearancePicker(context),
          ),
          _preferenceDivider(),
          _PreferenceRow(
            icon: Icons.map_outlined,
            title: l10n.region,
            value: AppSettingsL10n.regionLabel(context, appState.region),
            helper: l10n.regionHelper,
            onTap: () => showRegionPicker(context),
          ),
          _preferenceDivider(),
          _PreferenceRow(
            icon: Icons.attach_money_rounded,
            title: l10n.currency,
            value: appState.currency,
            helper: l10n.currencyHelper,
            onTap: () => showCurrencyPicker(context),
            isLast: true,
          ),
        ],
      ),
    );
  }

  Widget _preferenceDivider() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Divider(
        height: 1,
        thickness: 1,
        color: SavingorColors.border.withOpacity(0.55),
      ),
    );
  }

  Widget _buildNotificationsCard(AppLocalizations l10n) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 20),
      decoration: BoxDecoration(
        color: const Color(0xFFFCFDFC),
        borderRadius: BorderRadius.circular(_cardRadius),
        border: Border.all(
          color: SavingorColors.border.withOpacity(0.75),
        ),
        boxShadow: const <BoxShadow>[
          BoxShadow(
            color: Color(0x08000000),
            blurRadius: 10,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            width: 44,
            height: 44,
            decoration: SavingorSurfaces.accentIconBlock(
              accent: SavingorColors.textSecondary,
              radius: 14,
            ),
            child: Icon(
              Icons.notifications_none_rounded,
              size: 22,
              color: SavingorColors.textSecondary.withOpacity(0.85),
            ),
          ),
          const SizedBox(width: SavingorSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Expanded(
                      child: Text(
                        l10n.smartSavingsAlerts,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w800,
                          color: Color(0xFF1A2E24),
                          height: 1.25,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: SavingorColors.lightGreen,
                        borderRadius:
                            BorderRadius.circular(SavingorRadius.pill),
                        border: Border.all(
                          color: SavingorColors.primaryStroke.withOpacity(0.22),
                        ),
                      ),
                      child: Text(
                        l10n.comingSoon,
                        style: const TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                          color: SavingorColors.darkGreen,
                          letterSpacing: 0.15,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  l10n.smartSavingsAlertsDescription,
                  style: TextStyle(
                    fontSize: 13.5,
                    fontWeight: FontWeight.w500,
                    color: SavingorColors.textSecondary.withOpacity(0.95),
                    height: 1.45,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _SectionHeading extends StatelessWidget {
  const _SectionHeading({required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 13,
        fontWeight: FontWeight.w700,
        color: SavingorColors.textSecondary,
        letterSpacing: 0.35,
      ),
    );
  }
}

class _PreferenceRow extends StatelessWidget {
  const _PreferenceRow({
    required this.icon,
    required this.title,
    required this.value,
    required this.helper,
    required this.onTap,
    this.isLast = false,
  });

  final IconData icon;
  final String title;
  final String value;
  final String helper;
  final VoidCallback onTap;
  final bool isLast;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(18),
        child: Padding(
          padding: EdgeInsets.fromLTRB(20, 18, 16, isLast ? 18 : 18),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Container(
                width: 44,
                height: 44,
                decoration: SavingorSurfaces.accentIconBlock(
                  accent: SavingorAccentColors.savings,
                  radius: 14,
                ),
                child: Icon(icon, size: 22, color: SavingorAccentColors.savings),
              ),
              const SizedBox(width: SavingorSpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF1A2E24),
                        height: 1.2,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      helper,
                      style: TextStyle(
                        fontSize: 12.5,
                        fontWeight: FontWeight.w500,
                        color: SavingorColors.textSecondary.withOpacity(0.92),
                        height: 1.35,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      value,
                      style: const TextStyle(
                        fontSize: 14.5,
                        fontWeight: FontWeight.w700,
                        color: SavingorColors.primaryStroke,
                        height: 1.25,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 4),
              Icon(
                Icons.chevron_right_rounded,
                size: 22,
                color: SavingorColors.textSecondary.withOpacity(0.65),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
