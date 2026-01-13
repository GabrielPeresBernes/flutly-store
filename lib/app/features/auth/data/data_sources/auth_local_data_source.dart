import 'package:fpdart/fpdart.dart';

import '../../../../shared/types/response_type.dart';
import '../models/credentials_model.dart';

abstract interface class AuthLocalDataSource {
  TaskResponse<void> saveCredentials(CredentialsModel credentials);

  TaskResponse<Option<CredentialsModel>> getCredentials();

  TaskResponse<void> clearCredentials();

  Future<bool> isAuthenticated();
}
