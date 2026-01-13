import 'package:get_it/get_it.dart';

import 'injector_provider.dart';

/// GetIt implementation of the InjectorProvider interface.
class GetItProvider implements InjectorProvider {
  GetItProvider();

  final _getIt = GetIt.instance;

  @override
  T get<T extends Object>() => _getIt.get<T>();

  @override
  void registerSingleton<T extends Object>(T instance) {
    _getIt.registerSingleton<T>(instance);
  }

  @override
  void registerLazySingleton<T extends Object>(T Function() func) {
    _getIt.registerLazySingleton<T>(func);
  }

  @override
  void registerFactory<T extends Object>(T Function() func) {
    _getIt.registerFactory<T>(func);
  }
}
