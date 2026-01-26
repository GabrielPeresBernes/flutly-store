// ignore_for_file: cascade_invocations

import '../../../../core/http/http.dart';
import '../../../../core/injector/injector.dart';
import '../../data/data_sources/catalog_remote_data_source.dart';
import '../../data/data_sources/catalog_remote_data_source_impl.dart';
import '../../data/repositories/catalog_repository_impl.dart';
import '../../domain/repositories/catalog_repository.dart';
import '../../presentation/bloc/catalog/catalog_bloc.dart';
import '../../presentation/bloc/filters/catalog_filters_cubit.dart';

final class CatalogModule extends InjectorModule {
  const CatalogModule();

  @override
  Future<void> register(CoreInjector injector) async {
    injector.registerLazySingleton<CatalogRemoteDataSource>(
      () => CatalogRemoteDataSourceImpl(injector.get<CoreHttp>()),
    );

    injector.registerLazySingleton<CatalogRepository>(
      () => CatalogRepositoryImpl(injector.get<CatalogRemoteDataSource>()),
    );

    injector.registerFactory<CatalogBloc>(
      () => CatalogBloc(injector.get<CatalogRepository>()),
    );

    injector.registerFactory<CatalogFiltersCubit>(CatalogFiltersCubit.new);
  }
}
