// ignore_for_file: cascade_invocations

import '../../../../core/http/http.dart';
import '../../../../core/injector/injector.dart';
import '../../data/data_sources/home_remote_data_source.dart';
import '../../data/data_sources/home_remote_data_source_impl.dart';
import '../../data/repositories/home_repository_impl.dart';
import '../../domain/repositories/home_repository.dart';
import '../../presentation/bloc/home_cubit.dart';

class HomeModule extends InjectorModule {
  const HomeModule();

  @override
  Future<void> register(CoreInjector injector) async {
    injector.registerLazySingleton<HomeRemoteDataSource>(
      () => HomeRemoteDataSourceImpl(injector.get<CoreHttp>()),
    );

    injector.registerLazySingleton<HomeRepository>(
      () => HomeRepositoryImpl(injector.get<HomeRemoteDataSource>()),
    );

    injector.registerFactory<HomeCubit>(
      () => HomeCubit(injector.get<HomeRepository>()),
    );
  }
}
