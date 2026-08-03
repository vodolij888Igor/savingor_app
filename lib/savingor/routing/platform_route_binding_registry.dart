import 'package:savingor_app/savingor/routing/platform_route_binding.dart';

/// Ordered registry of [PlatformRouteBinding] instances.
///
/// Validates unique route names and paths at construction.
class PlatformRouteBindingRegistry {
  /// Creates a registry from [bindings].
  ///
  /// Preserves declaration order. Throws [StateError] on duplicate names or
  /// paths.
  PlatformRouteBindingRegistry(Iterable<PlatformRouteBinding> bindings)
      : _bindings = List<PlatformRouteBinding>.unmodifiable(
          _copyAndValidate(bindings),
        );

  final List<PlatformRouteBinding> _bindings;

  /// Bindings in declaration order (unmodifiable).
  List<PlatformRouteBinding> get bindings => _bindings;

  /// Whether a binding uses [name].
  bool containsName(String name) => findByName(name) != null;

  /// Whether a binding uses [path].
  bool containsPath(String path) => findByPath(path) != null;

  /// Returns the binding with [name], or `null` if none exists.
  PlatformRouteBinding? findByName(String name) {
    for (final PlatformRouteBinding binding in _bindings) {
      if (binding.routeName == name) {
        return binding;
      }
    }
    return null;
  }

  /// Returns the binding with [path], or `null` if none exists.
  PlatformRouteBinding? findByPath(String path) {
    for (final PlatformRouteBinding binding in _bindings) {
      if (binding.routePath == path) {
        return binding;
      }
    }
    return null;
  }

  static List<PlatformRouteBinding> _copyAndValidate(
    Iterable<PlatformRouteBinding> bindings,
  ) {
    final List<PlatformRouteBinding> copied = List<PlatformRouteBinding>.from(
      bindings,
    );
    final Set<String> names = <String>{};
    final Set<String> paths = <String>{};

    for (final PlatformRouteBinding binding in copied) {
      if (!names.add(binding.routeName)) {
        throw StateError(
          'Duplicate route binding name: "${binding.routeName}"',
        );
      }
      if (!paths.add(binding.routePath)) {
        throw StateError(
          'Duplicate route binding path: "${binding.routePath}"',
        );
      }
    }

    return copied;
  }
}
