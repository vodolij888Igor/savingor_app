import 'package:flutter/widgets.dart';

import 'package:savingor_app/core/app_state.dart';
import 'package:savingor_app/core/i18n/product_display_l10n.dart';
import 'package:savingor_app/features/analytics/domain/models/savings_recommendation.dart';
import 'package:savingor_app/l10n/app_localizations.dart';

/// Localized display strings for savings recommendation cards.
abstract final class SavingsRecommendationL10n {
  static String productLabel(
    BuildContext context,
    SavingsRecommendation recommendation, {
    required bool forSentence,
  }) {
    final String raw = recommendation.normalizedProductName ??
        recommendation.productDisplayName ??
        '';
    return ProductDisplayL10n.localizedProductName(
      context,
      raw,
      forSentence: forSentence,
    );
  }

  static String title(
    BuildContext context,
    SavingsRecommendation recommendation,
  ) {
    final AppLocalizations l10n = AppLocalizations.of(context);

    switch (recommendation.type) {
      case SavingsRecommendationType.storeSwitch:
        if (recommendation.storeName != null &&
            (recommendation.normalizedProductName != null ||
                recommendation.productDisplayName != null)) {
          return l10n.buyProductAtStoreNextTime(
            productLabel(context, recommendation, forSentence: true),
            recommendation.storeName!,
          );
        }
      case SavingsRecommendationType.bestKnownStore:
        if (recommendation.storeName != null) {
          return l10n.storeHasSeveralBestPrices(recommendation.storeName!);
        }
      case SavingsRecommendationType.watchPrice:
        if (recommendation.normalizedProductName != null ||
            recommendation.productDisplayName != null) {
          return l10n.watchProductPrices(
            productLabel(context, recommendation, forSentence: false),
          );
        }
    }

    return recommendation.title;
  }

  static String reason(
    BuildContext context,
    SavingsRecommendation recommendation,
    AppState appState,
  ) {
    final AppLocalizations l10n = AppLocalizations.of(context);
    final String Function(double) formatMoney = appState.formatMoney;

    switch (recommendation.type) {
      case SavingsRecommendationType.storeSwitch:
        if (recommendation.latestPaidPrice != null &&
            recommendation.bestKnownPrice != null &&
            recommendation.latestStoreName != null &&
            recommendation.storeName != null) {
          return l10n.recentlyPaidLatestBestKnown(
            formatMoney(recommendation.latestPaidPrice!),
            recommendation.latestStoreName!,
            formatMoney(recommendation.bestKnownPrice!),
            recommendation.storeName!,
          );
        }
      case SavingsRecommendationType.bestKnownStore:
        if (recommendation.trackedProductCount != null &&
            recommendation.storeName != null) {
          return l10n.trackedProductsLowestAtStore(
            recommendation.trackedProductCount!,
            recommendation.storeName!,
          );
        }
      case SavingsRecommendationType.watchPrice:
        if (recommendation.priceRangeLow != null &&
            recommendation.priceRangeHigh != null) {
          return l10n.knownPricesRangeFromTo(
            formatMoney(recommendation.priceRangeLow!),
            formatMoney(recommendation.priceRangeHigh!),
          );
        }
    }

    return recommendation.reason;
  }

  static String impactText(
    BuildContext context,
    SavingsRecommendation recommendation,
    AppState appState,
  ) {
    final AppLocalizations l10n = AppLocalizations.of(context);

    switch (recommendation.type) {
      case SavingsRecommendationType.storeSwitch:
        if (recommendation.potentialSavingPerItem != null) {
          return l10n.potentialSavingPerItem(
            appState.formatMoney(recommendation.potentialSavingPerItem!),
          );
        }
      case SavingsRecommendationType.bestKnownStore:
        return l10n.useStoreWhenMatchesRoute;
      case SavingsRecommendationType.watchPrice:
        if (recommendation.priceDifferenceAmount != null) {
          return l10n.priceDifferenceAmount(
            appState.formatMoney(recommendation.priceDifferenceAmount!),
          );
        }
    }

    return recommendation.impactText;
  }

  static String? dataBasisText(
    BuildContext context,
    SavingsRecommendation recommendation,
  ) {
    final int? count = recommendation.priceRecordCount;
    if (count == null || count <= 0) {
      return recommendation.dataBasisText;
    }

    return AppLocalizations.of(context).basedOnPriceRecords(count);
  }
}
