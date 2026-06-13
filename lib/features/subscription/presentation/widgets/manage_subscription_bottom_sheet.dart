import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:savingor_app/core/i18n/subscription_l10n.dart';
import 'package:savingor_app/core/theme/savingor_design_system.dart';
import 'package:savingor_app/features/subscription/data/subscription_service.dart';
import 'package:savingor_app/l10n/app_localizations.dart';

/// Bottom sheet for viewing and managing the real subscription state.
abstract final class ManageSubscriptionBottomSheet {
  static Future<void> show(
    BuildContext context, {
    required SubscriptionService subscriptionService,
    required SubscriptionStatus realSubscription,
    required VoidCallback onSubscriptionChanged,
  }) async {
    final AppLocalizations l10n = AppLocalizations.of(context);
    final bool isPro = realSubscription.isPro;

    await showModalBottomSheet<void>(
      context: context,
      backgroundColor: context.savingor.isDark
          ? context.savingor.surfaceStrong
          : context.savingor.surfacePrimary,
      isScrollControlled: true,
      useSafeArea: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(26)),
      ),
      builder: (BuildContext sheetContext) {
        final double bottomSafe = MediaQuery.paddingOf(sheetContext).bottom;
        return SafeArea(
          top: false,
          child: SingleChildScrollView(
            padding: EdgeInsets.fromLTRB(24, 18, 24, 28 + bottomSafe),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Center(
                  child: Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: context.savingor.border,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  l10n.manageSubscription,
                  style: TextStyle(
                    fontSize: 19,
                    fontWeight: FontWeight.w800,
                    color: context.savingor.brandTitle,
                  ),
                ),
                const SizedBox(height: 16),
                if (isPro) ...<Widget>[
                  _detailRow(
                    context,
                    l10n.subscriptionPlanLabel,
                    SubscriptionL10n.planLabel(context, realSubscription.plan),
                  ),
                  _detailRow(
                    context,
                    l10n.status,
                    SubscriptionL10n.statusLabelFromL10n(
                      l10n,
                      realSubscription.status,
                    ),
                  ),
                  _detailRow(
                    context,
                    l10n.price,
                    SubscriptionL10n.formatPricePerMonth(
                      context,
                      realSubscription,
                    ),
                  ),
                  _detailRow(
                    context,
                    l10n.provider,
                    SubscriptionL10n.providerLabel(
                      context,
                      realSubscription.provider,
                    ),
                  ),
                  const SizedBox(height: 18),
                  if (realSubscription.isRevenueCat) ...<Widget>[
                    Text(
                      l10n.subscriptionManagedByStore,
                      style: _mutedStyle(context),
                    ),
                    const SizedBox(height: 14),
                    SizedBox(
                      width: double.infinity,
                      child: OutlinedButton(
                        onPressed: () async {
                          Navigator.of(sheetContext).pop();
                          await _openStoreManagement(
                            context,
                            subscriptionService,
                            l10n,
                          );
                        },
                        style: OutlinedButton.styleFrom(
                          foregroundColor: context.savingor.brandHeading,
                          side: BorderSide(
                            color:
                                SavingorColors.primaryStroke.withOpacity(0.45),
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          textStyle: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        child: Text(l10n.manageInAppStoreGooglePlay),
                      ),
                    ),
                  ] else
                    SizedBox(
                      width: double.infinity,
                      child: OutlinedButton(
                        onPressed: () async {
                          Navigator.of(sheetContext).pop();
                          await _cancelProDemo(
                            context,
                            subscriptionService,
                            l10n,
                            onSubscriptionChanged,
                          );
                        },
                        style: OutlinedButton.styleFrom(
                          foregroundColor: const Color(0xFFB45309),
                          side: const BorderSide(color: Color(0xFFE7D4B5)),
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          textStyle: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        child: Text(l10n.cancelProDemo),
                      ),
                    ),
                ] else ...<Widget>[
                  _detailRow(context, l10n.subscriptionPlanLabel, l10n.free),
                  _detailRow(context, l10n.status, l10n.inactive),
                  const SizedBox(height: 4),
                  Text(
                    l10n.noActiveSubscription,
                    style: _mutedStyle(context),
                  ),
                ],
              ],
            ),
          ),
        );
      },
    );
  }

  static Widget _detailRow(
    BuildContext context,
    String label,
    String value,
  ) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          SizedBox(
            width: 110,
            child: Text(
              label,
              style: TextStyle(
                fontSize: 13.5,
                fontWeight: FontWeight.w600,
                color: context.savingor.textSecondary,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: TextStyle(
                fontSize: 13.5,
                fontWeight: FontWeight.w700,
                color: context.savingor.textPrimary,
              ),
            ),
          ),
        ],
      ),
    );
  }

  static TextStyle _mutedStyle(BuildContext context) {
    return TextStyle(
      fontSize: 13.5,
      fontWeight: FontWeight.w500,
      color: context.savingor.textSecondary,
      height: 1.4,
    );
  }

  static Future<void> _openStoreManagement(
    BuildContext context,
    SubscriptionService subscriptionService,
    AppLocalizations l10n,
  ) async {
    final String? url = await subscriptionService.getManagementUrl();
    if (!context.mounted) return;

    if (url == null) {
      await showDialog<void>(
        context: context,
        builder: (BuildContext dialogContext) {
          return AlertDialog(
            backgroundColor: context.savingor.surfacePrimary,
            surfaceTintColor: Colors.transparent,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(22),
            ),
            title: Text(
              l10n.managementNotAvailable,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w800,
                color: context.savingor.brandTitle,
              ),
            ),
            content: Text(
              l10n.managementUrlUnavailableMessage,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: context.savingor.textSecondary,
                height: 1.45,
              ),
            ),
            actions: <Widget>[
              TextButton(
                onPressed: () => Navigator.of(dialogContext).pop(),
                child: Text(l10n.ok),
              ),
            ],
          );
        },
      );
      return;
    }

    final bool launched = await launchUrl(
      Uri.parse(url),
      mode: LaunchMode.externalApplication,
    );
    if (!launched && context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.couldNotOpenSubscriptionManagement)),
      );
    }
  }

  static Future<void> _cancelProDemo(
    BuildContext context,
    SubscriptionService subscriptionService,
    AppLocalizations l10n,
    VoidCallback onSubscriptionChanged,
  ) async {
    try {
      await subscriptionService.cancelProDemoFallback();
      if (!context.mounted) return;
      onSubscriptionChanged();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.proDemoCancelled)),
      );
    } on SubscriptionException catch (e) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(SubscriptionL10n.localizeException(context, e))),
      );
    } catch (_) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.couldNotCancelProDemo)),
      );
    }
  }
}
