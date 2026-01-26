import 'package:easy_localization/easy_localization.dart';
import 'package:fpdart/fpdart.dart';

import '../../../../../core/local_storage/local_storage.dart';
import '../../../../../shared/types/response_type.dart';
import '../../../../../shared/utils/task_utils.dart';
import '../../../constants/auth_constants.dart';
import '../../models/credentials_model.dart';
import 'auth_local_data_source.dart';

class AuthLocalDataSourceImpl implements AuthLocalDataSource {
  const AuthLocalDataSourceImpl(this._localStorage);

  final CoreLocalStorage _localStorage;

  @override
  TaskResponse<void> saveCredentials(CredentialsModel credentials) => task(
    () async {
      return _localStorage.secureStorage.set(
        AuthConstants.userKey,
        credentials,
      );
    },
    (_) => tr('auth.errors.save_credentials_failed'),
  );

  @override
  TaskResponse<Option<CredentialsModel>> getCredentials() => task(
    () async {
      final data = await _localStorage.secureStorage.get<CredentialsModel>(
        AuthConstants.userKey,
        CredentialsModel.fromJson,
      );

      return Option.fromNullable(data);
    },
    (_) => tr('auth.errors.get_credentials_failed'),
  );

  @override
  TaskResponse<void> clearCredentials() => task(
    () async => _localStorage.secureStorage.remove(AuthConstants.userKey),
    (_) => tr('auth.errors.clear_credentials_failed'),
  );

  @override
  Future<bool> isAuthenticated() async {
    final credentials = await _localStorage.secureStorage.get<CredentialsModel>(
      AuthConstants.userKey,
      CredentialsModel.fromJson,
    );
    return credentials != null;
  }
}
