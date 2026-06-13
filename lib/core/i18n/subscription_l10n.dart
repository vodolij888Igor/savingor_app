import 'package:flutter/widgets.dart';

import 'package:savingor_app/features/subscription/data/subscription_service.dart';
import 'package:savingor_app/l10n/app_localizations.dart';

/// Display-time localization for subscription UI labels and errors.
abstract final class SubscriptionL10n {
  static String planLabel(BuildContext context, SubscriptionPlan plan) {
    final AppLocalizations l10n = AppLocalizations.of(context);
    return plan == SubscriptionPlan.pro ? l10n.pro : l10n.free;
  }

  static String statusLabel(BuildContext context, SubscriptionState status) {
    return statusLabelFromL10n(AppLocalizations.of(context), status);
  }

  static String statusLabelFromL10n(
    AppLocalizations l10n,
    SubscriptionState status,
  ) {
    return switch (status) {
      SubscriptionState.active => l10n.active,
      SubscriptionState.activeDemo => l10n.activeDemo,
      SubscriptionState.cancelled => l10n.cancelled,
      SubscriptionState.inactive => l10n.inactive,
      SubscriptionState.unknown => l10n.unknown,
    };
  }

  static String providerLabel(
      BuildContext context, SubscriptionProvider provider) {
    final AppLocalizations l10n = AppLocalizations.of(context);
    return switch (provider) {
      SubscriptionProvider.revenuecat => l10n.revenueCatLabel,
      SubscriptionProvider.demo => l10n.demoMode,
      SubscriptionProvider.none => l10n.providerNone,
    };
  }

  static String formatPricePerMonth(
    BuildContext context,
    SubscriptionStatus subscription,
  ) {
    final double amount =
        subscription.price ?? SubscriptionService.proMonthlyPrice;
    final String price = '\$${amount.toStringAsFixed(2)}';
    return AppLocalizations.of(context).pricePerMonth(price);
  }

  static String localizeException(
    BuildContext context,
    SubscriptionException error,
  ) {
    final AppLocalizations l10n = AppLocalizations.of(context);
    return switch (error.message) {
      'Payment provider is not configured in this local build.' =>
        l10n.paymentProviderNotConfiguredSnack,
      'The Pro subscription is not available right now. Please try again later.' =>
        l10n.productUnavailable,
      'Purchase completed but Pro is not active yet. Try Restore purchases.' =>
        l10n.purchaseNotActiveYet,
      'Purchase cancelled.' => l10n.purchaseCancelled,
      'Network error. Check your connection and try again.' =>
        l10n.networkErrorTryAgain,
      'Could not complete the purchase. Please try again.' =>
        l10n.purchaseFailed,
      'Could not restore purchases. Please try again.' =>
        l10n.couldNotRestorePurchases,
      'You need to be signed in to manage your subscription.' =>
        l10n.signInToManageSubscription,
      'Could not update your subscription. Please try again.' =>
        l10n.couldNotUpdateSubscription,
      _ => error.message,
    };
  }
}
