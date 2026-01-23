import 'package:flutly_store/app/core/injector/lib/core_injector.dart';
import 'package:flutly_store/app/core/injector/lib/providers/injector_provider.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockInjectorProvider extends Mock implements InjectorProvider {}

class _TestService {
  _TestService(this.value);

  final int value;
}

void main() {
  late MockInjectorProvider provider;

  setUp(() {
    provider = MockInjectorProvider();
    CoreInjector.configureForTests(provider);
  });

  test('instance returns same singleton', () {
    final first = CoreInjector.instance;
    final second = CoreInjector.instance;

    expect(identical(first, second), isTrue);
  });

  test('get delegates to provider', () {
    final service = _TestService(1);
    when(() => provider.get<_TestService>()).thenReturn(service);

    final result = CoreInjector.instance.get<_TestService>();

    expect(result, service);
    verify(() => provider.get<_TestService>()).called(1);
  });

  test('register methods delegate to provider', () {
    final service = _TestService(2);

    CoreInjector.instance.registerSingleton<_TestService>(service);
    CoreInjector.instance.registerLazySingleton<_TestService>(
      () => _TestService(3),
    );
    CoreInjector.instance.registerFactory<_TestService>(() => _TestService(4));

    verify(() => provider.registerSingleton<_TestService>(service)).called(1);
    verify(
      () => provider.registerLazySingleton<_TestService>(any()),
    ).called(1);
    verify(() => provider.registerFactory<_TestService>(any())).called(1);
  });
}
