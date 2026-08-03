import 'package:flutter/widgets.dart';

/// Product-specific binding from platform route metadata to a Flutter builder.
///
/// This is the Flutter boundary — keep Flutter types out of `platform_prep`.
class PlatformRouteBinding {
  /// Creates a binding for [routeName] and [routePath].
  ///
  /// Throws [ArgumentError] if [routeName] or [routePath] is empty or
  /// whitespace-only.
  PlatformRouteBinding({
    required String routeName,
    required String routePath,
    required this.builder,
  })  : routeName = _validateNonEmpty(routeName, 'routeName'),
        routePath = _validateNonEmpty(routePath, 'routePath');

  /// Stable route name matching [RouteContribution.name].
  final String routeName;

  /// Route path matching [RouteContribution.path].
  final String routePath;

  /// Flutter widget builder for this route.
  final WidgetBuilder builder;

  static String _validateNonEmpty(String value, String label) {
    if (value.trim().isEmpty) {
      throw ArgumentError.value(
        value,
        label,
        'PlatformRouteBinding.$label must be a non-empty string',
      );
    }
    return value;
  }
}
