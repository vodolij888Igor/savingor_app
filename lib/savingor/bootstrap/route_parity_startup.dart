import 'package:flutter/foundation.dart';

import 'package:savingor_app/platform_prep/navigation/active_route_catalog.dart';
import 'package:savingor_app/savingor/routing/groceries_production_route_contracts.dart';
import 'package:savingor_app/savingor/routing/groceries_route_bindings.dart';
import 'package:savingor_app/savingor/routing/platform_route_binding_registry.dart';
import 'package:savingor_app/savingor/routing/platform_route_parity_validator.dart';
import 'package:savingor_app/savingor/routing/production_route_contract.dart';
import 'package:savingor_app/savingor/routing/route_parity_result.dart';

/// Call count for [verifySavingorProductionRouteParity] (tests only).
@visibleForTesting
int debugRouteParityVerificationCallCount = 0;

/// Resets [debugRouteParityVerificationCallCount] (tests only).
@visibleForTesting
void debugResetRouteParityVerificationCallCount() {
  debugRouteParityVerificationCallCount = 0;
}

/// Runs Groceries production route parity once for bootstrap startup.
///
/// Skipped entirely when [isReleaseMode] is true (defaults to [kReleaseMode]).
/// On failure: [AssertionError] in debug; [StateError] in profile.
void verifySavingorProductionRouteParity({
  required ActiveRouteCatalog activeRouteCatalog,
  PlatformRouteBindingRegistry? bindings,
  Iterable<ProductionRouteContract>? productionRoutes,
  bool? isReleaseMode,
}) {
  if (isReleaseMode ?? kReleaseMode) {
    return;
  }

  debugRouteParityVerificationCallCount++;

  final RouteParityResult result = PlatformRouteParityValidator(
    catalog: activeRouteCatalog,
    bindings: bindings ?? groceriesRouteBindings,
  ).validate(
    productionRoutes: productionRoutes ?? groceriesProductionRouteContracts,
  );

  if (!result.isValid) {
    final String message =
        'Production route parity validation failed:\n${result.errors.join('\n')}';
    assert(false, message);
    throw StateError(message);
  }
}
