/// Application Platform — reusable multi-product core.
///
/// Prefer [PlatformFacade] / [PlatformBootstrap.facade] (structure) or
/// [PlatformBootstrap.platformQuery] (read-only queries) as the stable entry.
/// Product wiring (Savingor modules, live GoRouter) lives outside this library.
///
/// See `ARCHITECTURE.md` in this directory.
library;

export 'package:savingor_app/platform_prep/activation/activation.dart';
export 'package:savingor_app/platform_prep/application/application.dart';
export 'package:savingor_app/platform_prep/bootstrap/bootstrap.dart';
export 'package:savingor_app/platform_prep/discovery/discovery.dart';
export 'package:savingor_app/platform_prep/environment/environment.dart';
export 'package:savingor_app/platform_prep/feature_flags/feature_flags.dart';
export 'package:savingor_app/platform_prep/kernel/kernel.dart';
export 'package:savingor_app/platform_prep/lifecycle/lifecycle.dart';
export 'package:savingor_app/platform_prep/modules/modules.dart';
export 'package:savingor_app/platform_prep/navigation/navigation.dart';
export 'package:savingor_app/platform_prep/platform/platform.dart';
export 'package:savingor_app/platform_prep/query/query.dart';
export 'package:savingor_app/platform_prep/registry/registry.dart';
export 'package:savingor_app/platform_prep/runtime/runtime.dart';
