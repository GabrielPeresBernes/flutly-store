// ignore_for_file: cascade_invocations

import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../../core/injector/injector.dart';
import '../../../../core/local_storage/local_storage.dart';
import '../../../auth/data/data_sources/auth_local_data_source.dart';
import '../../../search/domain/repositories/search_repository.dart';
import '../../data/data_sources/cart_local_data_source.dart';
import '../../data/data_sources/cart_local_data_source_impl.dart';
import '../../data/data_sources/cart_remote_data_source.dart';
import '../../data/data_sources/cart_remote_data_source_impl.dart';
import '../../data/repositories/cart_repository_impl.dart';
import '../../domain/repositories/cart_repository.dart';
import '../../presentation/bloc/cart_cubit.dart';
import '../../presentation/bloc/cart_popular_products_cubit.dart';

class CartModule extends InjectorModule {
  const CartModule();

  @override
  Future<void> register(CoreInjector injector) async {
    injector.registerLazySingleton<CartLocalDataSource>(
      () => CartLocalDataSourceImpl(injector.get<CoreLocalStorage>()),
    );

    injector.registerLazySingleton<CartRemoteDataSource>(
      () => CartRemoteDataSourceImpl(injector.get<FirebaseFirestore>()),
    );

    injector.registerLazySingleton<CartRepository>(
      () => CartRepositoryImpl(
        injector.get<AuthLocalDataSource>(),
        injector.get<CartRemoteDataSource>(),
        injector.get<CartLocalDataSource>(),
      ),
    );

    injector.registerFactory<CartCubit>(
      () => CartCubit(injector.get<CartRepository>()),
    );

    injector.registerFactory<CartPopularProductsCubit>(
      () => CartPopularProductsCubit(injector.get<SearchRepository>()),
    );
  }
}
