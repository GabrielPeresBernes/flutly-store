import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthErrorsUtils {
  String getErrorMessage(FirebaseAuthException exception) {
    switch (exception.code) {
      case 'invalid-email':
        return tr('auth.errors.invalid_email');
      case 'user-disabled':
        return tr('auth.errors.user_disabled');
      case 'user-not-found':
        return tr('auth.errors.user_not_found');
      case 'wrong-password':
        return tr('auth.errors.wrong_password');
      case 'email-already-in-use':
        return tr('auth.errors.email_already_in_use');
      case 'operation-not-allowed':
        return tr('auth.errors.operation_not_allowed');
      case 'weak-password':
        return tr('auth.errors.weak_password');
      case 'invalid-credential':
        return tr('auth.errors.invalid_credential');
      default:
        return tr(
          'auth.errors.undefined',
          namedArgs: {'message': exception.message ?? ''},
        );
    }
  }
}
