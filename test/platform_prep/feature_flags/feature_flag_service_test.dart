import 'package:flutter_test/flutter_test.dart';
import 'package:savingor_app/platform_prep/feature_flags/feature_flags.dart';

void main() {
  group('FeatureFlagKey', () {
    test('rejects empty value', () {
      expect(() => FeatureFlagKey(''), throwsArgumentError);
    });

    test('rejects whitespace-only value', () {
      expect(() => FeatureFlagKey('   '), throwsArgumentError);
    });

    test('equality and hashCode use value', () {
      final FeatureFlagKey a = FeatureFlagKey('module.example');
      final FeatureFlagKey b = FeatureFlagKey('module.example');
      final FeatureFlagKey c = FeatureFlagKey('module.other');

      expect(a, equals(b));
      expect(a.hashCode, equals(b.hashCode));
      expect(a, isNot(equals(c)));
      expect(a.toString(), equals('FeatureFlagKey(module.example)'));
    });
  });

  group('FeatureFlagContext', () {
    test('attributes are unmodifiable', () {
      const FeatureFlagContext context = FeatureFlagContext(
        attributes: <String, Object?>{'tier': 'free'},
      );

      expect(
        () => context.attributes['tier'] = 'pro',
        throwsUnsupportedError,
      );
      expect(
        () => context.attributes['extra'] = true,
        throwsUnsupportedError,
      );
    });
  });

  group('LocalFeatureFlagService', () {
    test('returns configured true and false values', () {
      final FeatureFlagKey enabled = FeatureFlagKey('flag.on');
      final FeatureFlagKey disabled = FeatureFlagKey('flag.off');
      final LocalFeatureFlagService service = LocalFeatureFlagService(
        defaults: <FeatureFlagKey, bool>{
          enabled: true,
          disabled: false,
        },
      );

      expect(service.isEnabled(enabled), isTrue);
      expect(service.isEnabled(disabled), isFalse);
    });

    test('unknown flags return false', () {
      final LocalFeatureFlagService service = LocalFeatureFlagService(
        defaults: <FeatureFlagKey, bool>{
          FeatureFlagKey('known'): true,
        },
      );

      expect(service.isEnabled(FeatureFlagKey('unknown')), isFalse);
    });

    test('constructor input cannot mutate internal defaults afterward', () {
      final FeatureFlagKey key = FeatureFlagKey('mutable.input');
      final Map<FeatureFlagKey, bool> input = <FeatureFlagKey, bool>{
        key: true,
      };
      final LocalFeatureFlagService service = LocalFeatureFlagService(
        defaults: input,
      );

      input[key] = false;
      input[FeatureFlagKey('added.later')] = true;

      expect(service.isEnabled(key), isTrue);
      expect(service.isEnabled(FeatureFlagKey('added.later')), isFalse);
      expect(
        () => service.defaults[key] = false,
        throwsUnsupportedError,
      );
    });

    test('evaluateAll returns correct results', () {
      final FeatureFlagKey a = FeatureFlagKey('a');
      final FeatureFlagKey b = FeatureFlagKey('b');
      final FeatureFlagKey c = FeatureFlagKey('c');
      final LocalFeatureFlagService service = LocalFeatureFlagService(
        defaults: <FeatureFlagKey, bool>{
          a: true,
          b: false,
        },
      );

      final Map<FeatureFlagKey, bool> results = service.evaluateAll(
        <FeatureFlagKey>[a, b, c],
      );

      expect(results[a], isTrue);
      expect(results[b], isFalse);
      expect(results[c], isFalse);
    });

    test('evaluateAll result is unmodifiable', () {
      final FeatureFlagKey key = FeatureFlagKey('only');
      final LocalFeatureFlagService service = LocalFeatureFlagService(
        defaults: <FeatureFlagKey, bool>{key: true},
      );

      final Map<FeatureFlagKey, bool> results = service.evaluateAll(
        <FeatureFlagKey>[key],
      );

      expect(
        () => results[key] = false,
        throwsUnsupportedError,
      );
      expect(
        () => results[FeatureFlagKey('extra')] = true,
        throwsUnsupportedError,
      );
    });
  });
}
