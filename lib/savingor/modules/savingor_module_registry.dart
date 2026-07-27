import 'package:savingor_app/platform_prep/navigation/app_module.dart';
import 'package:savingor_app/platform_prep/navigation/module_registry.dart';
import 'package:savingor_app/savingor/modules/groceries/groceries_module.dart';

/// Savingor product composition root for platform [AppModule] registrations.
///
/// Contains exactly [groceriesModule] today. Metadata only — not wired to the
/// router, UI, or feature-flag evaluation yet.
final ModuleRegistry savingorModuleRegistry = ModuleRegistry(
  <AppModule>[
    groceriesModule,
  ],
);
