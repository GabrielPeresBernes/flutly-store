import 'dart:convert';
import 'dart:math';

import 'package:crypto/crypto.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart' hide AuthProvider;
import 'package:google_sign_in/google_sign_in.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

import '../../../../shared/errors/app_exception.dart';
import '../../../../shared/types/response_type.dart';
import '../../../../shared/utils/task_utils.dart';
import '../../domain/entities/credentials.dart';
import '../../utils/auth_errors_utils.dart';
import '../models/credentials_model.dart';
import 'auth_remote_data_source.dart';

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  AuthRemoteDataSourceImpl(this._firebaseAuth, this._googleSignIn);

  final FirebaseAuth _firebaseAuth;
  final GoogleSignIn _googleSignIn;

  @override
  TaskResponse<CredentialsModel> signIn({
    required String email,
    required String password,
  }) => task(
    () async {
      await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      final user = _firebaseAuth.currentUser;

      if (user == null) {
        throw AppException(message: tr('auth.errors.invalid_credentials'));
      }

      return CredentialsModel(
        userId: user.uid,
        name: user.displayName ?? tr('auth.defaults.user_name'),
        email: user.email ?? email,
        provider: AuthProvider.email.name,
      );
    },
    (error) {
      if (error is FirebaseAuthException) {
        return AuthErrorsUtils().getErrorMessage(error);
      }

      return tr('auth.errors.sign_in_failed');
    },
  );

  @override
  TaskResponse<CredentialsModel> signUp({
    required String name,
    required String email,
    required String password,
  }) => task(
    () async {
      await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      await _firebaseAuth.currentUser?.updateDisplayName(name);

      final user = _firebaseAuth.currentUser;

      if (user == null) {
        throw AppException(
          message: tr('auth.errors.sign_up_failed_invalid_user'),
        );
      }

      return CredentialsModel(
        userId: user.uid,
        name: name,
        email: user.email ?? email,
        provider: AuthProvider.email.name,
      );
    },
    (error) {
      if (error is FirebaseAuthException) {
        return AuthErrorsUtils().getErrorMessage(error);
      }

      return tr('auth.errors.sign_up_failed');
    },
  );

  @override
  TaskResponse<void> signOut() => task(
    () async => _firebaseAuth.signOut(),
    (error) {
      if (error is FirebaseAuthException) {
        return AuthErrorsUtils().getErrorMessage(error);
      }

      return tr('auth.errors.sign_out_failed');
    },
  );

  @override
  TaskResponse<CredentialsModel> updateUser({
    required AuthProvider provider,
    String? name,
    String? currentPassword,
    String? newPassword,
  }) => task(
    () async {
      final user = _firebaseAuth.currentUser;

      if (user == null || user.email == null) {
        throw AppException(
          message: tr('auth.errors.update_failed_no_auth_user'),
        );
      }

      if (provider == AuthProvider.email &&
          currentPassword != null &&
          newPassword != null &&
          currentPassword.isNotEmpty) {
        final credential = EmailAuthProvider.credential(
          email: user.email!,
          password: currentPassword,
        );

        await user.reauthenticateWithCredential(credential);

        await user.updatePassword(newPassword);
      }

      if (name != null && name.isNotEmpty) {
        await user.updateDisplayName(name);
      }

      return CredentialsModel(
        userId: _firebaseAuth.currentUser!.uid,
        name:
            _firebaseAuth.currentUser!.displayName ??
            tr('auth.defaults.user_name'),
        email: _firebaseAuth.currentUser!.email ?? '',
        provider: provider.name,
      );
    },
    (error) {
      if (error is FirebaseAuthException) {
        return AuthErrorsUtils().getErrorMessage(error);
      }

      return tr('auth.errors.update_failed');
    },
  );

  @override
  TaskResponse<CredentialsModel> signWithGoogle() => task(
    () async {
      final googleUser = await _googleSignIn.authenticate();

      final credential = GoogleAuthProvider.credential(
        idToken: googleUser.authentication.idToken,
      );

      await _firebaseAuth.signInWithCredential(credential);

      await _firebaseAuth.currentUser?.updateDisplayName(
        googleUser.displayName,
      );

      final user = _firebaseAuth.currentUser;

      if (user == null || user.displayName == null || user.email == null) {
        throw AppException(
          message: tr('auth.errors.sign_with_google_failed_invalid_user'),
        );
      }

      return CredentialsModel(
        userId: user.uid,
        name: user.displayName!,
        email: user.email!,
        provider: AuthProvider.google.name,
      );
    },
    (error) {
      if (error is FirebaseAuthException) {
        return AuthErrorsUtils().getErrorMessage(error);
      }

      return error.toString();
    },
  );

  @override
  TaskResponse<CredentialsModel> signWithApple() => task(
    () async {
      final rawNonce = _generateNonce();
      final nonce = _sha256ofString(rawNonce);

      final appleCredential = await SignInWithApple.getAppleIDCredential(
        scopes: [
          AppleIDAuthorizationScopes.email,
          AppleIDAuthorizationScopes.fullName,
        ],
        nonce: nonce,
      );

      final idToken = appleCredential.identityToken;

      if (idToken == null) {
        throw AppException(message: tr('auth.errors.sign_with_apple_failed'));
      }

      final credential = AppleAuthProvider.credentialWithIDToken(
        idToken,
        rawNonce,
        AppleFullPersonName(
          givenName: appleCredential.givenName,
          familyName: appleCredential.familyName,
        ),
      );

      await _firebaseAuth.signInWithCredential(credential);

      await _firebaseAuth.currentUser?.updateDisplayName(
        appleCredential.givenName ?? tr('auth.defaults.user_name'),
      );

      final user = _firebaseAuth.currentUser;

      if (user == null || user.displayName == null || user.email == null) {
        throw AppException(
          message: tr('auth.errors.sign_with_apple_failed_invalid_user'),
        );
      }

      return CredentialsModel(
        userId: user.uid,
        name: user.displayName!,
        email: user.email!,
        provider: AuthProvider.apple.name,
      );
    },
    (error) {
      if (error is FirebaseAuthException) {
        return AuthErrorsUtils().getErrorMessage(error);
      }

      return error.toString();
    },
  );
}

String _generateNonce([int length = 32]) {
  const charset =
      '0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._';
  final random = Random.secure();
  return List.generate(
    length,
    (_) => charset[random.nextInt(charset.length)],
  ).join();
}

String _sha256ofString(String input) {
  final bytes = utf8.encode(input);
  final digest = sha256.convert(bytes);
  return digest.toString();
}
