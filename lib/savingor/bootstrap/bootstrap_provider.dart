import 'package:flutter/widgets.dart';

import 'package:savingor_app/platform_prep/bootstrap/bootstrap.dart';
import 'package:savingor_app/platform_prep/navigation/module_id.dart';
import 'package:savingor_app/savingor/modules/module_loader.dart';

/// Shared Savingor platform bootstrap instance.
///
/// Created once at library load; not wired to routing or feature evaluation.
final PlatformBootstrap platformBootstrap = PlatformBootstrap.savingor();

/// Debug-only invariants for the registered module set.
///
/// Stripped from release builds (Dart `assert`); does not change UI or routing.
void assertRegisteredModulesReady(ModuleLoader loader) {
  assert(
    loader.moduleCount > 0,
    'Platform module registry must not be empty',
  );
  assert(
    loader.contains(ModuleId('groceries')),
    'Groceries module must be registered',
  );
}

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
