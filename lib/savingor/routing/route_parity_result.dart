/// Immutable outcome of a platform-vs-production route parity check.
class RouteParityResult {
  /// Creates a result from [errors].
  ///
  /// [errors] is copied into an unmodifiable list.
  RouteParityResult({required Iterable<String> errors})
      : errors = List<String>.unmodifiable(List<String>.from(errors));

  /// Human-readable parity failures in deterministic report order.
  final List<String> errors;

  /// Whether parity succeeded (`errors` is empty).
  bool get isValid => errors.isEmpty;
}
