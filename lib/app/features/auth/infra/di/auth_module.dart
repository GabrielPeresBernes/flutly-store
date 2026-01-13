// ignore_for_file: cascade_invocations

import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../../../../core/injector/injector.dart';
import '../../../../core/local_storage/local_storage.dart';
import '../../data/data_sources/auth_local_data_source.dart';
import '../../data/data_sources/auth_local_data_source_impl.dart';
import '../../data/data_sources/auth_remote_data_source.dart';
import '../../data/data_sources/auth_remote_data_source_impl.dart';
import '../../data/repositories/auth_repository_impl.dart';
import '../../domain/repositories/auth_repository.dart';
import '../../presentation/bloc/auth_cubit.dart';

class AuthModule extends InjectorModule {
  const AuthModule();

  @override
  Future<void> register(CoreInjector injector) async {
    injector.registerLazySingleton<AuthRemoteDataSource>(
      () => AuthRemoteDataSourceImpl(
        injector.get<FirebaseAuth>(),
        injector.get<GoogleSignIn>(),
      ),
    );

    injector.registerLazySingleton<AuthLocalDataSource>(
      () => AuthLocalDataSourceImpl(injector.get<CoreLocalStorage>()),
    );

    injector.registerLazySingleton<AuthRepository>(
      () => AuthRepositoryImpl(
        injector.get<AuthRemoteDataSource>(),
        injector.get<AuthLocalDataSource>(),
      ),
    );

    injector.registerFactory<AuthCubit>(
      () => AuthCubit(injector.get<AuthRepository>()),
    );
  }
}
