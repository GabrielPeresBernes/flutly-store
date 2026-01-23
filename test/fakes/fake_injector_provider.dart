import 'package:flutly_store/app/core/injector/lib/providers/injector_provider.dart';

class FakeInjectorProvider implements InjectorProvider {
  final Map<Type, Object> _singletons = {};
  final Map<Type, Object Function()> _factories = {};

  @override
  T get<T extends Object>() {
    if (_singletons.containsKey(T)) {
      return _singletons[T]! as T;
    }
    final factory = _factories[T];
    if (factory != null) {
      return factory() as T;
    }
    throw StateError('No provider registered for $T');
  }

  @override
  void registerFactory<T extends Object>(T Function() func) =>
      _factories[T] = func;

  @override
  void registerLazySingleton<T extends Object>(T Function() func) =>
      _singletons[T] = func();

  @override
  void registerSingleton<T extends Object>(T instance) =>
      _singletons[T] = instance;
}
