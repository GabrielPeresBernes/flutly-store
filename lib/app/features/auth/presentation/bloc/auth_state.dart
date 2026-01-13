part of 'auth_cubit.dart';

enum AuthOperation {
  signIn,
  signUp,
}

sealed class AuthState {
  const AuthState();
}

final class AuthInitial extends AuthState {
  const AuthInitial();
}

final class AuthLoading extends AuthState {
  const AuthLoading();
}

final class AuthSigned extends AuthState {
  const AuthSigned(this.operation);

  final AuthOperation operation;
}

final class AuthFailure extends AuthState {
  const AuthFailure(this.exception);

  final AppException exception;
}
