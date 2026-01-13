import 'package:fpdart/fpdart.dart';

import '../../../../shared/types/response_type.dart';
import '../entities/credentials.dart';

abstract interface class AuthRepository {
  TaskResponse<void> signIn({
    required String email,
    required String password,
  });

  TaskResponse<void> signUp({
    required String name,
    required String email,
    required String password,
  });

  TaskResponse<void> signWithGoogle();

  TaskResponse<void> signWithApple();

  TaskResponse<void> signOut();

  TaskResponse<Option<Credentials>> getCredentials();

  Future<bool> isAuthenticated();

  TaskResponse<void> updateUser({
    String? name,
    String? currentPassword,
    String? newPassword,
  });
}
