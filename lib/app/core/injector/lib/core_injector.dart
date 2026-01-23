import 'providers/get_it_provider.dart';
import 'providers/injector_provider.dart';

/// Core Injector for dependency injection.
class CoreInjector {
  const CoreInjector._(this._provider);

  static CoreInjector? _instance;

  final InjectorProvider _provider;

  /// Singleton instance of CoreInjector.
  static CoreInjector get instance {
    _instance ??= CoreInjector._(GetItProvider());
    return _instance!;
  }

  /// Configures the injector for testing with a custom [provider].
  static void configureForTests(InjectorProvider provider) {
    _instance = CoreInjector._(provider);
  }

  /// Retrieves an instance of type [T] from the injector.
  T get<T extends Object>() => _provider.get<T>();

  /// Registers a singleton instance of type [T] in the injector.
  void registerSingleton<T extends Object>(T instance) =>
      _provider.registerSingleton<T>(instance);

  /// Registers a lazy singleton of type [T] in the injector.
  void registerLazySingleton<T extends Object>(T Function() func) =>
      _provider.registerLazySingleton<T>(func);

  /// Registers a factory of type [T] in the injector.
  void registerFactory<T extends Object>(T Function() func) =>
      _provider.registerFactory<T>(func);
}
