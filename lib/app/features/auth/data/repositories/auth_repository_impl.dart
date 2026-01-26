import 'package:easy_localization/easy_localization.dart';
import 'package:fpdart/fpdart.dart';

import '../../../../shared/errors/app_exception.dart';
import '../../../../shared/types/response_type.dart';
import '../../domain/entities/credentials.dart';
import '../../domain/repositories/auth_repository.dart';
import '../data_sources/local/auth_local_data_source.dart';
import '../data_sources/remote/auth_remote_data_source.dart';

class AuthRepositoryImpl implements AuthRepository {
  const AuthRepositoryImpl(this._remoteDataSource, this._localDataSource);

  final AuthRemoteDataSource _remoteDataSource;
  final AuthLocalDataSource _localDataSource;

  @override
  TaskResponse<void> signWithGoogle() {
    return _remoteDataSource.signWithGoogle().flatMap(
      _localDataSource.saveCredentials,
    );
  }

  @override
  TaskResponse<void> signWithApple() {
    return _remoteDataSource.signWithApple().flatMap(
      _localDataSource.saveCredentials,
    );
  }

  @override
  TaskResponse<void> signIn({
    required String email,
    required String password,
  }) {
    return _remoteDataSource
        .signIn(email: email, password: password)
        .flatMap(_localDataSource.saveCredentials);
  }

  @override
  TaskResponse<void> signUp({
    required String name,
    required String email,
    required String password,
  }) {
    return _remoteDataSource
        .signUp(name: name, email: email, password: password)
        .flatMap(_localDataSource.saveCredentials);
  }

  @override
  TaskResponse<void> signOut() {
    return _remoteDataSource
        .signOut()
        .orElse((_) => TaskEither<AppException, void>.right(null))
        .flatMap((_) => _localDataSource.clearCredentials());
  }

  @override
  TaskResponse<Option<Credentials>> getCredentials() {
    return _localDataSource.getCredentials().map(
      (opt) => opt.map(
        (credentialsModel) => credentialsModel.toEntity(),
      ),
    );
  }

  @override
  Future<bool> isAuthenticated() => _localDataSource.isAuthenticated();

  @override
  TaskResponse<void> updateUser({
    String? name,
    String? currentPassword,
    String? newPassword,
  }) {
    return _localDataSource.getCredentials().flatMap(
      (opt) => opt.match(
        () => TaskEither<AppException, void>.left(
          AppException(message: tr('auth.errors.must_be_logged_in')),
        ),
        (credentials) => _remoteDataSource
            .updateUser(
              name: name,
              currentPassword: currentPassword,
              newPassword: newPassword,
              provider: AuthProvider.fromString(credentials.provider),
            )
            .flatMap(_localDataSource.saveCredentials),
      ),
    );
  }
}
