import 'package:flutly_store/app/core/injector/lib/providers/get_it_provider.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';

class _TestService {
  _TestService(this.value);

  final int value;
}

void main() {
  late GetItProvider provider;

  setUp(() async {
    await GetIt.instance.reset();
    provider = GetItProvider();
  });

  tearDown(() async {
    await GetIt.instance.reset();
  });

  test('registerSingleton returns same instance', () {
    final instance = _TestService(1);
    provider.registerSingleton<_TestService>(instance);

    final resolved = provider.get<_TestService>();

    expect(identical(resolved, instance), isTrue);
  });

  test('registerLazySingleton returns same instance for multiple gets', () {
    provider.registerLazySingleton<_TestService>(() => _TestService(2));

    final first = provider.get<_TestService>();
    final second = provider.get<_TestService>();

    expect(identical(first, second), isTrue);
    expect(first.value, 2);
  });

  test('registerFactory returns new instance for each get', () {
    provider.registerFactory<_TestService>(() => _TestService(3));

    final first = provider.get<_TestService>();
    final second = provider.get<_TestService>();

    expect(identical(first, second), isFalse);
    expect(first.value, 3);
    expect(second.value, 3);
  });
}
