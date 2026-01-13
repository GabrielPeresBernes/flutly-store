import '../core_injector.dart';

/// Base class for defining injector modules.
class InjectorModule {
  const InjectorModule();

  /// Registers dependencies into the provided [injector].
  Future<void> register(CoreInjector injector) async {}
}
