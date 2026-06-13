import 'package:flutter/widgets.dart';

import 'package:savingor_app/l10n/app_localizations.dart';

/// Localized display labels for known normalized Savingor product identifiers.
abstract final class ProductDisplayL10n {
  static String normalizeProductId(String raw) =>
      raw.trim().toLowerCase();

  /// Returns a localized label for known normalized IDs (`bread`, `milk`).
  ///
  /// [forSentence] lowercases the localized label for mid-sentence use
  /// (e.g. recommendation copy). Unknown values are returned unchanged.
  static String localizedProductName(
    BuildContext context,
    String productId, {
    bool forSentence = false,
  }) {
    final String id = normalizeProductId(productId);
    if (id.isEmpty) {
      return productId;
    }

    final AppLocalizations l10n = AppLocalizations.of(context);
    final String? localized = switch (id) {
      'bread' => l10n.productBread,
      'milk' => l10n.productMilk,
      'chicken' => l10n.productChicken,
      'eggs' => l10n.productEggs,
      _ => null,
    };

    if (localized == null) {
      return productId;
    }

    return forSentence ? localized.toLowerCase() : localized;
  }
}
