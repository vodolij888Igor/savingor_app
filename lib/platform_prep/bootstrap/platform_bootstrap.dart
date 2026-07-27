import 'package:savingor_app/platform_prep/feature_flags/feature_flag_service.dart';
import 'package:savingor_app/platform_prep/feature_flags/local_feature_flag_service.dart';
import 'package:savingor_app/platform_prep/navigation/module_registry.dart';
import 'package:savingor_app/savingor/modules/module_loader.dart';
import 'package:savingor_app/savingor/modules/savingor_module_registry.dart';

/// Immutable composition root for platform module and feature-flag services.
///
/// Metadata and service wiring only — not connected to app runtime yet.
final class PlatformBootstrap {
  /// Creates a bootstrap from pre-built platform services.
  const PlatformBootstrap({
    required ModuleRegistry moduleRegistry,
    required ModuleLoader moduleLoader,
    required FeatureFlagService featureFlags,
  })  : _moduleRegistry = moduleRegistry,
        _moduleLoader = moduleLoader,
        _featureFlags = featureFlags;

  final ModuleRegistry _moduleRegistry;
  final ModuleLoader _moduleLoader;
  final FeatureFlagService _featureFlags;

  /// Registered modules with uniqueness validation.
  ModuleRegistry get moduleRegistry => _moduleRegistry;

  /// Read-only view over [moduleRegistry].
  ModuleLoader get moduleLoader => _moduleLoader;

  /// Feature flag evaluation service (not invoked by this bootstrap).
  FeatureFlagService get featureFlags => _featureFlags;

  /// Savingor product bootstrap with default registry, loader, and empty flags.
  factory PlatformBootstrap.savingor() {
    final ModuleRegistry registry = savingorModuleRegistry;
    final ModuleLoader loader = ModuleLoader(registry);
    final FeatureFlagService flags = LocalFeatureFlagService();

    return PlatformBootstrap(
      moduleRegistry: registry,
      moduleLoader: loader,
      featureFlags: flags,
    );
  }
}
