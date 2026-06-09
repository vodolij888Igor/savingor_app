import 'package:flutter/material.dart';

import 'package:savingor_app/core/theme/savingor_design_system.dart';

/// Maps product names to bundled thumbnail assets for dashboard cards.
abstract final class ProductVisualAssets {
  static const String bread = 'assets/products/bread.png';
  static const String milk = 'assets/products/milk.png';

  static String? thumbnailAssetForProduct(String productName) {
    final String lower = productName.trim().toLowerCase();
    if (lower.isEmpty) {
      return null;
    }

    if (_matchesAny(lower, _breadKeywords)) {
      return bread;
    }
    if (_matchesAny(lower, _milkKeywords)) {
      return milk;
    }

    return null;
  }

  static bool _matchesAny(String value, List<String> keywords) {
    for (final String keyword in keywords) {
      if (value.contains(keyword)) {
        return true;
      }
    }
    return false;
  }

  static const List<String> _breadKeywords = <String>[
    'bread',
    'bagel',
    'toast',
    'bun',
    'roll',
    'croissant',
  ];

  static const List<String> _milkKeywords = <String>[
    'milk',
  ];
}

/// Product thumbnail with asset lookup and icon fallback for dashboard cards.
class ProductThumbnailAvatar extends StatelessWidget {
  const ProductThumbnailAvatar({
    super.key,
    required this.productName,
    this.size = 58,
  });

  final String productName;
  final double size;

  @override
  Widget build(BuildContext context) {
    final String? assetPath =
        ProductVisualAssets.thumbnailAssetForProduct(productName);
    final IconData fallbackIcon =
        _ProductFallbackIcons.forProduct(productName);

    if (assetPath != null) {
      return SizedBox(
        width: size,
        height: size,
        child: Image.asset(
          assetPath,
          fit: BoxFit.contain,
          errorBuilder: (
            BuildContext context,
            Object error,
            StackTrace? stackTrace,
          ) {
            return _FallbackIcon(
              icon: fallbackIcon,
              size: size,
            );
          },
        ),
      );
    }

    return _FallbackIcon(
      icon: fallbackIcon,
      size: size,
    );
  }
}

class _FallbackIcon extends StatelessWidget {
  const _FallbackIcon({
    required this.icon,
    required this.size,
  });

  final IconData icon;
  final double size;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: Center(
        child: Icon(
          icon,
          size: size * 0.48,
          color: SavingorColors.primaryStroke,
        ),
      ),
    );
  }
}

abstract final class _ProductFallbackIcons {
  static IconData forProduct(String productName) {
    final String lower = productName.toLowerCase();

    if (lower.contains('milk') ||
        lower.contains('juice') ||
        lower.contains('water') ||
        lower.contains('soda') ||
        lower.contains('drink')) {
      return Icons.local_drink_rounded;
    }
    if (ProductVisualAssets._matchesAny(lower, ProductVisualAssets._breadKeywords)) {
      return Icons.bakery_dining_rounded;
    }
    if (lower.contains('egg')) {
      return Icons.egg_alt_rounded;
    }
    if (lower.contains('chicken') ||
        lower.contains('beef') ||
        lower.contains('pork') ||
        lower.contains('meat') ||
        lower.contains('fish') ||
        lower.contains('salmon') ||
        lower.contains('turkey') ||
        lower.contains('steak')) {
      return Icons.restaurant_rounded;
    }
    if (lower.contains('banana') ||
        lower.contains('apple') ||
        lower.contains('fruit') ||
        lower.contains('berry') ||
        lower.contains('vegetable') ||
        lower.contains('lettuce') ||
        lower.contains('tomato')) {
      return Icons.eco_rounded;
    }
    if (lower.contains('cheese') ||
        lower.contains('yogurt') ||
        lower.contains('butter')) {
      return Icons.breakfast_dining_rounded;
    }

    return Icons.shopping_basket_outlined;
  }
}
