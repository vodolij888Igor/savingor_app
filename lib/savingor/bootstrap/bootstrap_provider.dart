import 'package:flutter/widgets.dart';

import 'package:savingor_app/platform_prep/bootstrap/bootstrap.dart';

/// Shared Savingor platform bootstrap instance.
///
/// Created once at library load; not wired to routing or feature evaluation.
final PlatformBootstrap platformBootstrap = PlatformBootstrap.savingor();

/// Exposes [platformBootstrap] from the application composition layer.
class PlatformBootstrapProvider extends InheritedWidget {
  const PlatformBootstrapProvider({super.key, required super.child});

  static PlatformBootstrap of(BuildContext context) {
    final PlatformBootstrapProvider? provider =
        context.dependOnInheritedWidgetOfExactType<PlatformBootstrapProvider>();

    if (provider == null) {
      throw FlutterError('PlatformBootstrapProvider not found');
    }

    return platformBootstrap;
  }

  @override
  bool updateShouldNotify(covariant InheritedWidget oldWidget) => false;
}
