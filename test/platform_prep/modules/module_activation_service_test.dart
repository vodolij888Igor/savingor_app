import 'package:flutter_test/flutter_test.dart';
import 'package:savingor_app/platform_prep/feature_flags/feature_flag_context.dart';
import 'package:savingor_app/platform_prep/feature_flags/feature_flag_key.dart';
import 'package:savingor_app/platform_prep/feature_flags/feature_flag_service.dart';
import 'package:savingor_app/platform_prep/feature_flags/local_feature_flag_service.dart';
import 'package:savingor_app/platform_prep/modules/modules.dart';
import 'package:savingor_app/platform_prep/navigation/app_module.dart';
import 'package:savingor_app/platform_prep/navigation/module_id.dart';
import 'package:savingor_app/platform_prep/navigation/module_registry.dart';
import 'package:savingor_app/platform_prep/navigation/route_contribution.dart';
import 'package:savingor_app/platform_prep/navigation/shell_tab_contribution.dart';
import 'package:savingor_app/savingor/modules/module_loader.dart';

void main() {
  final FeatureFlagKey enabledFlag = FeatureFlagKey('module.a.enabled');
  final FeatureFlagKey disabledFlag = FeatureFlagKey('module.b.enabled');

  late AppModule moduleA;
  late AppModule moduleB;
  late AppModule moduleC;
  late ModuleLoader loader;

  setUp(() {
    moduleA = _FakeModule(id: 'a');
    moduleB = _FakeModule(id: 'b');
    moduleC = _FakeModule(id: 'c');
    loader = ModuleLoader(
      ModuleRegistry(<AppModule>[moduleA, moduleB, moduleC]),
    );
  });

  group('ModuleActivationService', () {
    test('always-enabled rule activates a module', () {
      final ModuleActivationService service = ModuleActivationService(
        loader: loader,
        featureFlags: LocalFeatureFlagService(),
        rules: <ModuleActivationRule>[
          ModuleActivationRule(moduleId: ModuleId('a')),
        ],
      );

      final ActiveModuleSet active = service.evaluate();
      expect(active.count, equals(1));
      expect(active.findById(ModuleId('a')), same(moduleA));
    });

    test('enabled feature flag activates a module', () {
      final ModuleActivationService service = ModuleActivationService(
        loader: loader,
        featureFlags: LocalFeatureFlagService(
          defaults: <FeatureFlagKey, bool>{enabledFlag: true},
        ),
        rules: <ModuleActivationRule>[
          ModuleActivationRule(
            moduleId: ModuleId('a'),
            requiredFlag: enabledFlag,
          ),
        ],
      );

      final ActiveModuleSet active = service.evaluate();
      expect(active.contains(ModuleId('a')), isTrue);
      expect(active.findById(ModuleId('a')), same(moduleA));
    });

    test('disabled feature flag does not activate a module', () {
      final ModuleActivationService service = ModuleActivationService(
        loader: loader,
        featureFlags: LocalFeatureFlagService(
          defaults: <FeatureFlagKey, bool>{disabledFlag: false},
        ),
        rules: <ModuleActivationRule>[
          ModuleActivationRule(
            moduleId: ModuleId('b'),
            requiredFlag: disabledFlag,
          ),
        ],
      );

      final ActiveModuleSet active = service.evaluate();
      expect(active.count, equals(0));
      expect(active.contains(ModuleId('b')), isFalse);
    });

    test('registered module without a rule stays inactive', () {
      final ModuleActivationService service = ModuleActivationService(
        loader: loader,
        featureFlags: LocalFeatureFlagService(),
        rules: <ModuleActivationRule>[
          ModuleActivationRule(moduleId: ModuleId('a')),
        ],
      );

      final ActiveModuleSet active = service.evaluate();
      expect(active.contains(ModuleId('a')), isTrue);
      expect(active.contains(ModuleId('b')), isFalse);
      expect(active.contains(ModuleId('c')), isFalse);
    });

    test('unknown module in a rule throws StateError', () {
      expect(
        () => ModuleActivationService(
          loader: loader,
          featureFlags: LocalFeatureFlagService(),
          rules: <ModuleActivationRule>[
            ModuleActivationRule(moduleId: ModuleId('unknown')),
          ],
        ),
        throwsA(
          isA<StateError>().having(
            (StateError e) => e.message,
            'message',
            contains('unknown'),
          ),
        ),
      );
    });

    test('duplicate rules for one module throw StateError', () {
      expect(
        () => ModuleActivationService(
          loader: loader,
          featureFlags: LocalFeatureFlagService(),
          rules: <ModuleActivationRule>[
            ModuleActivationRule(moduleId: ModuleId('a')),
            ModuleActivationRule(
              moduleId: ModuleId('a'),
              requiredFlag: enabledFlag,
            ),
          ],
        ),
        throwsA(
          isA<StateError>().having(
            (StateError e) => e.message,
            'message',
            contains('Duplicate activation rule'),
          ),
        ),
      );
    });

    test('active modules preserve registry order', () {
      final ModuleActivationService service = ModuleActivationService(
        loader: loader,
        featureFlags: LocalFeatureFlagService(
          defaults: <FeatureFlagKey, bool>{
            enabledFlag: true,
            disabledFlag: true,
          },
        ),
        rules: <ModuleActivationRule>[
          ModuleActivationRule(
            moduleId: ModuleId('c'),
            requiredFlag: disabledFlag,
          ),
          ModuleActivationRule(moduleId: ModuleId('a')),
          ModuleActivationRule(
            moduleId: ModuleId('b'),
            requiredFlag: enabledFlag,
          ),
        ],
      );

      final ActiveModuleSet active = service.evaluate();
      expect(
        active.modules.map((AppModule m) => m.id.value).toList(),
        <String>['a', 'b', 'c'],
      );
    });

    test('contains and findById work', () {
      final ModuleActivationService service = ModuleActivationService(
        loader: loader,
        featureFlags: LocalFeatureFlagService(),
        rules: <ModuleActivationRule>[
          ModuleActivationRule(moduleId: ModuleId('b')),
        ],
      );

      final ActiveModuleSet active = service.evaluate();
      expect(active.contains(ModuleId('b')), isTrue);
      expect(active.findById(ModuleId('b')), same(moduleB));
      expect(active.contains(ModuleId('a')), isFalse);
      expect(active.findById(ModuleId('a')), isNull);
    });

    test('returned module collection is unmodifiable', () {
      final ModuleActivationService service = ModuleActivationService(
        loader: loader,
        featureFlags: LocalFeatureFlagService(),
        rules: <ModuleActivationRule>[
          ModuleActivationRule(moduleId: ModuleId('a')),
        ],
      );

      final ActiveModuleSet active = service.evaluate();
      expect(
        () => active.modules.add(moduleB),
        throwsUnsupportedError,
      );
    });

    test('FeatureFlagContext is passed to FeatureFlagService', () {
      final _RecordingFeatureFlagService flags = _RecordingFeatureFlagService();
      final ModuleActivationService service = ModuleActivationService(
        loader: loader,
        featureFlags: flags,
        rules: <ModuleActivationRule>[
          ModuleActivationRule(
            moduleId: ModuleId('a'),
            requiredFlag: enabledFlag,
          ),
        ],
      );

      const FeatureFlagContext context = FeatureFlagContext(
        userId: 'user-1',
        locale: 'en',
        platform: 'android',
      );
      service.evaluate(context: context);

      expect(flags.lastKey, equals(enabledFlag));
      expect(flags.lastContext, same(context));
    });
  });
}

class _RecordingFeatureFlagService extends FeatureFlagService {
  FeatureFlagKey? lastKey;
  FeatureFlagContext? lastContext;

  @override
  bool isEnabled(
    FeatureFlagKey key, {
    FeatureFlagContext context = const FeatureFlagContext(),
  }) {
    lastKey = key;
    lastContext = context;
    return true;
  }
}

class _FakeModule implements AppModule {
  _FakeModule({required String id})
      : id = ModuleId(id),
        routeContributions = List<RouteContribution>.unmodifiable(
          <RouteContribution>[
            RouteContribution(name: '$id-route', path: '/$id'),
          ],
        ),
        shellTabs = const <ShellTabContribution>[];

  @override
  final ModuleId id;

  @override
  final List<RouteContribution> routeContributions;

  @override
  final List<ShellTabContribution> shellTabs;
}
