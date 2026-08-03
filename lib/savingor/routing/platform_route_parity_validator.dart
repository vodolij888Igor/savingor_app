import 'package:savingor_app/platform_prep/navigation/active_route_catalog.dart';
import 'package:savingor_app/platform_prep/navigation/route_contribution.dart';
import 'package:savingor_app/savingor/routing/platform_route_binding.dart';
import 'package:savingor_app/savingor/routing/platform_route_binding_registry.dart';
import 'package:savingor_app/savingor/routing/production_route_contract.dart';
import 'package:savingor_app/savingor/routing/route_parity_result.dart';

/// Validates active platform routes and bindings against production contracts.
///
/// Collects every parity failure without mutating inputs. Ordinary mismatches
/// are reported via [RouteParityResult]; they do not throw.
class PlatformRouteParityValidator {
  /// Creates a validator for [catalog] and [bindings].
  PlatformRouteParityValidator({
    required ActiveRouteCatalog catalog,
    required PlatformRouteBindingRegistry bindings,
  })  : _catalog = catalog,
        _bindings = bindings;

  final ActiveRouteCatalog _catalog;
  final PlatformRouteBindingRegistry _bindings;

  /// Compares active routes and bindings to [productionRoutes].
  ///
  /// Errors are ordered: production duplicates first (input order), then active
  /// catalog order, then extra bindings in registry order.
  RouteParityResult validate({
    required Iterable<ProductionRouteContract> productionRoutes,
  }) {
    final List<String> errors = <String>[];
    final List<ProductionRouteContract> production =
        List<ProductionRouteContract>.from(productionRoutes);

    final Map<String, ProductionRouteContract> productionByName =
        <String, ProductionRouteContract>{};
    final Map<String, ProductionRouteContract> productionByPath =
        <String, ProductionRouteContract>{};
    final Set<String> seenNames = <String>{};
    final Set<String> seenPaths = <String>{};

    for (final ProductionRouteContract contract in production) {
      if (!seenNames.add(contract.name)) {
        errors.add('Duplicate production route name: "${contract.name}"');
      } else {
        productionByName[contract.name] = contract;
      }

      if (!seenPaths.add(contract.path)) {
        errors.add('Duplicate production route path: "${contract.path}"');
      } else {
        productionByPath[contract.path] = contract;
      }
    }

    final Set<String> activeNames = <String>{};

    for (final RouteContribution active in _catalog.routes) {
      activeNames.add(active.name);

      final ProductionRouteContract? byName = productionByName[active.name];
      final ProductionRouteContract? byPath = productionByPath[active.path];

      if (byName == null && byPath == null) {
        errors.add(
          'Active platform route missing from production contracts: '
          '"${active.name}" at "${active.path}"',
        );
      } else if (byName == null && byPath != null) {
        errors.add(
          'Route-name mismatch for path "${active.path}": '
          'platform "${active.name}", production "${byPath.name}"',
        );
      } else if (byName != null && byName.path != active.path) {
        errors.add(
          'Route-path mismatch for name "${active.name}": '
          'platform "${active.path}", production "${byName.path}"',
        );
      }

      final PlatformRouteBinding? bindingByName =
          _bindings.findByName(active.name);
      if (bindingByName == null) {
        errors.add(
          'Active platform route absent from bindings: '
          '"${active.name}" at "${active.path}"',
        );
      } else if (bindingByName.routePath != active.path) {
        errors.add(
          'Route-path mismatch for name "${active.name}": '
          'platform "${active.path}", binding "${bindingByName.routePath}"',
        );
      }
    }

    for (final PlatformRouteBinding binding in _bindings.bindings) {
      if (!activeNames.contains(binding.routeName)) {
        errors.add(
          'Extra platform binding not represented by an active route: '
          '"${binding.routeName}" at "${binding.routePath}"',
        );
      }
    }

    return RouteParityResult(errors: errors);
  }
}
