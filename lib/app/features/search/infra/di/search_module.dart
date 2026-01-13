// ignore_for_file: cascade_invocations

import '../../../../core/http/http.dart';
import '../../../../core/injector/injector.dart';
import '../../../../core/local_storage/local_storage.dart';
import '../../data/data_sources/search_local_data_source.dart';
import '../../data/data_sources/search_local_data_source_impl.dart';
import '../../data/data_sources/search_remote_data_source.dart';
import '../../data/data_sources/search_remote_data_source_impl.dart';
import '../../data/repositories/search_repository_impl.dart';
import '../../domain/repositories/search_repository.dart';
import '../../presentation/bloc/search_history_cubit.dart';
import '../../presentation/bloc/search_popular_products_cubit.dart';
import '../../presentation/bloc/search_suggestions_cubit.dart';

class SearchModule extends InjectorModule {
  const SearchModule();

  @override
  Future<void> register(CoreInjector injector) async {
    injector.registerLazySingleton<SearchLocalDataSource>(
      () => SearchLocalDataSourceImpl(injector.get<CoreLocalStorage>()),
    );

    injector.registerLazySingleton<SearchRemoteDataSource>(
      () => SearchRemoteDataSourceImpl(injector.get<CoreHttp>()),
    );

    injector.registerLazySingleton<SearchRepository>(
      () => SearchRepositoryImpl(
        injector.get<SearchRemoteDataSource>(),
        injector.get<SearchLocalDataSource>(),
      ),
    );

    injector.registerFactory<SearchPopularProductsCubit>(
      () => SearchPopularProductsCubit(injector.get<SearchRepository>()),
    );

    injector.registerFactory<SearchHistoryCubit>(
      () => SearchHistoryCubit(injector.get<SearchRepository>()),
    );

    injector.registerFactory<SearchSuggestionsCubit>(
      SearchSuggestionsCubit.new,
    );
  }
}
