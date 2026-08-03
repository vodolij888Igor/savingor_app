import 'package:savingor_app/platform_prep/navigation/route_contribution.dart';
import 'package:savingor_app/savingor/modules/groceries/groceries_module.dart';
import 'package:savingor_app/savingor/routing/production_route_contract.dart';

/// Production Groceries route contracts for parity checks.
///
/// Paths match the Groceries routes defined in `createAppRouter` /
/// `app_router.dart`. Names are the platform-stable identifiers from
/// [groceriesModule] (production GoRoutes currently omit `name:`). Derived from
/// [groceriesModule.routeContributions] so route strings are not duplicated.
final List<ProductionRouteContract> groceriesProductionRouteContracts =
    List<ProductionRouteContract>.unmodifiable(
  groceriesModule.routeContributions.map(
    (RouteContribution contribution) => ProductionRouteContract(
      name: contribution.name,
      path: contribution.path,
    ),
  ),
);
