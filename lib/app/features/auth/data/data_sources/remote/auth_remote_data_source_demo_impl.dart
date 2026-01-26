import 'package:easy_localization/easy_localization.dart';

import '../../../../../core/local_storage/local_storage.dart';
import '../../../../../shared/types/response_type.dart';
import '../../../../../shared/utils/task_utils.dart';
import '../../../constants/auth_constants.dart';
import '../../../domain/entities/credentials.dart';
import '../../models/credentials_model.dart';
import 'auth_remote_data_source.dart';

/// A fake implementation of [AuthRemoteDataSource] for demonstration purposes.
/// This class is used when Firebase is not enabled in the application.
class AuthRemoteDataSourceDemoImpl implements AuthRemoteDataSource {
  AuthRemoteDataSourceDemoImpl(this._localStorage);

  final CoreLocalStorage _localStorage;

  final userId = 'demo_user_id';
  String userName = 'Demo User';
  String userEmail = 'demo@example.com';

  @override
  TaskResponse<CredentialsModel> signIn({
    required String email,
    required String password,
  }) {
    userEmail = email;

    return TaskResponse.right(
      CredentialsModel(
        userId: userId,
        name: userName,
        email: userEmail,
        provider: AuthProvider.email.name,
      ),
    );
  }

  @override
  TaskResponse<void> signOut() =>
      task(() async {}, (_) => tr('auth.errors.sign_out_failed'));

  @override
  TaskResponse<CredentialsModel> signUp({
    required String name,
    required String email,
    required String password,
  }) {
    userName = name;
    userEmail = email;

    return TaskResponse.right(
      CredentialsModel(
        userId: userId,
        name: userName,
        email: userEmail,
        provider: AuthProvider.email.name,
      ),
    );
  }

  @override
  TaskResponse<CredentialsModel> signWithApple() => TaskResponse.right(
    CredentialsModel(
      userId: userId,
      name: userName,
      email: 'apple@example.com',
      provider: AuthProvider.apple.name,
    ),
  );

  @override
  TaskResponse<CredentialsModel> signWithGoogle() => TaskResponse.right(
    CredentialsModel(
      userId: userId,
      name: userName,
      email: 'google@example.com',
      provider: AuthProvider.google.name,
    ),
  );

  @override
  TaskResponse<CredentialsModel> updateUser({
    required AuthProvider provider,
    String? name,
    String? currentPassword,
    String? newPassword,
  }) => task(
    () async {
      if (name != null) {
        userName = name;
      }

      final data = await _localStorage.secureStorage.get<CredentialsModel>(
        AuthConstants.userKey,
        CredentialsModel.fromJson,
      );

      if (data != null && data.email.isNotEmpty) {
        userEmail = data.email;
      }

      return CredentialsModel(
        userId: userId,
        name: userName,
        email: userEmail,
        provider: provider.name,
      );
    },
    (_) => tr('auth.errors.update_failed'),
  );
}
