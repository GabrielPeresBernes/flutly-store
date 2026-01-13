/// Defines the interface for an injector provider.
abstract interface class InjectorProvider {
  T get<T extends Object>();

  void registerSingleton<T extends Object>(T instance);

  void registerLazySingleton<T extends Object>(T Function() func);

  void registerFactory<T extends Object>(T Function() func);
}
