import '../../../../../shared/types/response_type.dart';
import '../../../domain/entities/credentials.dart';
import '../../models/credentials_model.dart';

abstract interface class AuthRemoteDataSource {
  TaskResponse<CredentialsModel> signIn({
    required String email,
    required String password,
  });

  TaskResponse<CredentialsModel> signUp({
    required String name,
    required String email,
    required String password,
  });

  TaskResponse<CredentialsModel> signWithGoogle();

  TaskResponse<CredentialsModel> signWithApple();

  TaskResponse<void> signOut();

  TaskResponse<CredentialsModel> updateUser({
    required AuthProvider provider,
    String? name,
    String? currentPassword,
    String? newPassword,
  });
}
