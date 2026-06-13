import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:savingor_app/core/theme/savingor_design_system.dart';
import 'package:savingor_app/features/subscription/data/debug_subscription_override_store.dart';
import 'package:savingor_app/features/subscription/domain/debug_subscription_override.dart';
import 'package:savingor_app/l10n/app_localizations.dart';

/// Debug-only controls for previewing Free / Pro access without changing real
/// subscription records.
class DebugSubscriptionTestingSection extends StatelessWidget {
  const DebugSubscriptionTestingSection({super.key});

  static const double _cardRadius = 22;

  @override
  Widget build(BuildContext context) {
    if (!kDebugMode) {
      return const SizedBox.shrink();
    }

    final DebugSubscriptionOverrideStore store =
        DebugSubscriptionOverrideProvider.of(context);
    final AppLocalizations l10n = AppLocalizations.of(context);
    final SavingorThemeExtension theme = context.savingor;

    return ListenableBuilder(
      listenable: store,
      builder: (BuildContext context, Widget? _) {
        final DebugSubscriptionOverride selected = store.override;

        return Container(
          width: double.infinity,
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 20),
          decoration: theme.isDark
              ? SavingorSurfaces.premiumCard(context, radius: _cardRadius)
              : BoxDecoration(
                  color: const Color(0xFFFFF8E8),
                  borderRadius: BorderRadius.circular(_cardRadius),
                  border: Border.all(
                    color: const Color(0xFFE7D4B5),
                  ),
                ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Row(
                children: <Widget>[
                  Icon(
                    Icons.developer_mode_rounded,
                    size: 20,
                    color:
                        theme.isDark ? theme.warning : const Color(0xFFB45309),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      l10n.debugSubscriptionTestingTitle,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w800,
                        color: theme.isDark
                            ? theme.textPrimary
                            : const Color(0xFF1A2E24),
                        height: 1.25,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                l10n.debugSubscriptionTestingDescription,
                style: TextStyle(
                  fontSize: 13.5,
                  fontWeight: FontWeight.w500,
                  color: theme.textSecondary,
                  height: 1.45,
                ),
              ),
              const SizedBox(height: SavingorSpacing.lg),
              _DebugOverrideOptionTile(
                label: l10n.debugSubscriptionUseReal,
                selected: selected == DebugSubscriptionOverride.none,
                onTap: () => store.setOverride(DebugSubscriptionOverride.none),
              ),
              const SizedBox(height: SavingorSpacing.sm),
              _DebugOverrideOptionTile(
                label: l10n.debugSubscriptionTestAsFree,
                selected: selected == DebugSubscriptionOverride.free,
                onTap: () => store.setOverride(DebugSubscriptionOverride.free),
              ),
              const SizedBox(height: SavingorSpacing.sm),
              _DebugOverrideOptionTile(
                label: l10n.debugSubscriptionTestAsPro,
                selected: selected == DebugSubscriptionOverride.pro,
                onTap: () => store.setOverride(DebugSubscriptionOverride.pro),
              ),
            ],
          ),
        );
      },
    );
  }
}

class DebugSubscriptionOverrideNotice extends StatelessWidget {
  const DebugSubscriptionOverrideNotice({super.key});

  @override
  Widget build(BuildContext context) {
    if (!kDebugMode) {
      return const SizedBox.shrink();
    }

    final DebugSubscriptionOverrideStore? store =
        DebugSubscriptionOverrideProvider.maybeOf(context);
    if (store == null || !store.isOverrideActive) {
      return const SizedBox.shrink();
    }

    final AppLocalizations l10n = AppLocalizations.of(context);
    final SavingorThemeExtension theme = context.savingor;
    final String message = store.override == DebugSubscriptionOverride.free
        ? l10n.debugSubscriptionOverrideFree
        : l10n.debugSubscriptionOverridePro;

    return ListenableBuilder(
      listenable: store,
      builder: (BuildContext context, Widget? _) {
        if (!store.isOverrideActive) {
          return const SizedBox.shrink();
        }

        return Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          decoration: BoxDecoration(
            color:
                theme.isDark ? theme.warningSurface : const Color(0xFFFFF8E8),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: theme.isDark
                  ? theme.warning.withOpacity(0.35)
                  : const Color(0xFFE7D4B5),
            ),
          ),
          child: Row(
            children: <Widget>[
              Icon(
                Icons.bug_report_outlined,
                size: 18,
                color: theme.isDark ? theme.warning : const Color(0xFFB45309),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  message,
                  style: TextStyle(
                    fontSize: 13,
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
        );
      },
    );
  }
}

class _DebugOverrideOptionTile extends StatelessWidget {
  const _DebugOverrideOptionTile({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final SavingorThemeExtension theme = context.savingor;

    final Color tileColor = selected
        ? (theme.isDark
            ? theme.selectedHighlight
            : SavingorColors.lightGreen.withOpacity(0.65))
        : (theme.isDark ? theme.surfaceElevated : const Color(0xFFFCFDFC));

    final Color borderColor = selected
        ? (theme.isDark
            ? theme.accentGreen.withOpacity(0.45)
            : SavingorColors.primaryStroke.withOpacity(0.45))
        : theme.border.withOpacity(theme.isDark ? 0.9 : 0.85);

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Ink(
          decoration: BoxDecoration(
            color: tileColor,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: borderColor),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
            child: Row(
              children: <Widget>[
                Expanded(
                  child: Text(
                    label,
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      color: theme.isDark
                          ? theme.textPrimary
                          : const Color(0xFF1A2E24),
                      height: 1.25,
                    ),
                  ),
                ),
                if (selected)
                  Icon(
                    Icons.check_circle_rounded,
                    size: 22,
                    color: theme.isDark
                        ? theme.accentGreen
                        : SavingorColors.primaryStroke,
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
