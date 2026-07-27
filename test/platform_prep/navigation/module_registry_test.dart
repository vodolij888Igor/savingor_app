import 'package:flutter_test/flutter_test.dart';
import 'package:savingor_app/platform_prep/navigation/navigation.dart';

void main() {
  group('ModuleId', () {
    test('rejects empty value', () {
      expect(() => ModuleId(''), throwsArgumentError);
    });

    test('rejects whitespace-only value', () {
      expect(() => ModuleId('   '), throwsArgumentError);
    });

    test('equality and hashCode use value', () {
      final ModuleId a = ModuleId('core');
      final ModuleId b = ModuleId('core');
      final ModuleId c = ModuleId('other');

      expect(a, equals(b));
      expect(a.hashCode, equals(b.hashCode));
      expect(a, isNot(equals(c)));
      expect(a.toString(), equals('ModuleId(core)'));
    });
  });

  group('ModuleRegistry', () {
    test('preserves insertion order', () {
      final ModuleRegistry registry = ModuleRegistry(<AppModule>[
        _FakeModule(id: 'first'),
        _FakeModule(id: 'second'),
        _FakeModule(id: 'third'),
      ]);

      expect(
        registry.modules.map((AppModule m) => m.id.value).toList(),
        <String>['first', 'second', 'third'],
      );
    });

    test('lookup by ModuleId works and returns null when missing', () {
      final AppModule module = _FakeModule(id: 'alpha');
      final ModuleRegistry registry = ModuleRegistry(<AppModule>[module]);

      expect(registry.findById(ModuleId('alpha')), same(module));
      expect(registry.findById(ModuleId('missing')), isNull);
    });

    test('rejects duplicate module IDs', () {
      expect(
        () => ModuleRegistry(<AppModule>[
          _FakeModule(id: 'dup'),
          _FakeModule(id: 'dup'),
        ]),
        throwsA(
          isA<StateError>().having(
            (StateError e) => e.message,
            'message',
            contains('Duplicate module ID'),
          ),
        ),
      );
    });

    test('rejects duplicate route names', () {
      expect(
        () => ModuleRegistry(<AppModule>[
          _FakeModule(
            id: 'a',
            routes: <RouteContribution>[
              RouteContribution(name: 'home', path: '/a'),
            ],
          ),
          _FakeModule(
            id: 'b',
            routes: <RouteContribution>[
              RouteContribution(name: 'home', path: '/b'),
            ],
          ),
        ]),
        throwsA(
          isA<StateError>().having(
            (StateError e) => e.message,
            'message',
            contains('Duplicate route name'),
          ),
        ),
      );
    });

    test('rejects duplicate route paths', () {
      expect(
        () => ModuleRegistry(<AppModule>[
          _FakeModule(
            id: 'a',
            routes: <RouteContribution>[
              RouteContribution(name: 'a', path: '/shared'),
            ],
          ),
          _FakeModule(
            id: 'b',
            routes: <RouteContribution>[
              RouteContribution(name: 'b', path: '/shared'),
            ],
          ),
        ]),
        throwsA(
          isA<StateError>().having(
            (StateError e) => e.message,
            'message',
            contains('Duplicate route path'),
          ),
        ),
      );
    });

    test('rejects duplicate shell tab stable keys', () {
      expect(
        () => ModuleRegistry(<AppModule>[
          _FakeModule(
            id: 'a',
            tabs: <ShellTabContribution>[
              ShellTabContribution(
                key: 'home',
                routePath: '/a',
                sortOrder: 0,
              ),
            ],
          ),
          _FakeModule(
            id: 'b',
            tabs: <ShellTabContribution>[
              ShellTabContribution(
                key: 'home',
                routePath: '/b',
                sortOrder: 1,
              ),
            ],
          ),
        ]),
        throwsA(
          isA<StateError>().having(
            (StateError e) => e.message,
            'message',
            contains('Duplicate shell tab key'),
          ),
        ),
      );
    });

    test('exposes an unmodifiable modules list', () {
      final ModuleRegistry registry = ModuleRegistry(<AppModule>[
        _FakeModule(id: 'only'),
      ]);

      expect(
        () => registry.modules.add(_FakeModule(id: 'extra')),
        throwsUnsupportedError,
      );
    });
  });
}

class _FakeModule implements AppModule {
  _FakeModule({
    required String id,
    List<RouteContribution>? routes,
    List<ShellTabContribution>? tabs,
  })  : id = ModuleId(id),
        routeContributions = List<RouteContribution>.unmodifiable(
          routes ??
              <RouteContribution>[
                RouteContribution(name: '$id-route', path: '/$id'),
              ],
        ),
        shellTabs = List<ShellTabContribution>.unmodifiable(
          tabs ?? const <ShellTabContribution>[],
        );

  @override
  final ModuleId id;

  @override
  final List<RouteContribution> routeContributions;

  @override
  final List<ShellTabContribution> shellTabs;
}
