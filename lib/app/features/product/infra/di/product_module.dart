// ignore_for_file: cascade_invocations

import '../../../../core/http/http.dart';
import '../../../../core/injector/injector.dart';
import '../../data/data_sources/product_remote_data_source.dart';
import '../../data/data_sources/product_remote_data_source_impl.dart';
import '../../data/repositories/product_repository_impl.dart';
import '../../domain/repositories/product_repository.dart';
import '../../presentation/bloc/product/product_cubit.dart';
import '../../presentation/bloc/recommendation/product_recommendation_cubit.dart';

class ProductModule extends InjectorModule {
  const ProductModule();

  @override
  Future<void> register(CoreInjector injector) async {
    injector.registerFactory<ProductRemoteDataSource>(
      () => ProductRemoteDataSourceImpl(injector.get<CoreHttp>()),
    );

    injector.registerFactory<ProductRepository>(
      () => ProductRepositoryImpl(injector.get<ProductRemoteDataSource>()),
    );

    injector.registerFactory<ProductCubit>(
      () => ProductCubit(injector.get<ProductRepository>()),
    );

    injector.registerFactory<ProductRecommendationCubit>(
      () => ProductRecommendationCubit(injector.get<ProductRepository>()),
    );
  }
}
