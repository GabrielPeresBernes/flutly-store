// ignore_for_file: cascade_invocations

import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../../core/injector/injector.dart';
import '../../../auth/data/data_sources/auth_local_data_source.dart';
import '../../../auth/domain/repositories/auth_repository.dart';
import '../../data/data_sources/profile_remote_data_source.dart';
import '../../data/data_sources/profile_remote_data_source_impl.dart';
import '../../data/repositories/profile_repository_impl.dart';
import '../../domain/repositories/profile_repository.dart';
import '../../presentation/bloc/profile_cubit.dart';

class ProfileModule extends InjectorModule {
  const ProfileModule();

  @override
  Future<void> register(CoreInjector injector) async {
    injector.registerLazySingleton<ProfileRemoteDataSource>(
      () => ProfileRemoteDataSourceImpl(
        injector.get<FirebaseFirestore>(),
      ),
    );

    injector.registerLazySingleton<ProfileRepository>(
      () => ProfileRepositoryImpl(
        injector.get<ProfileRemoteDataSource>(),
        injector.get<AuthLocalDataSource>(),
      ),
    );

    injector.registerFactory<ProfileCubit>(
      () => ProfileCubit(
        injector.get<AuthRepository>(),
        injector.get<ProfileRepository>(),
      ),
    );
  }
}
