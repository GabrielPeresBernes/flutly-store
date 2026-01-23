import 'package:bloc_test/bloc_test.dart';
import 'package:flutly_store/app/features/auth/domain/entities/credentials.dart';
import 'package:flutly_store/app/features/auth/domain/repositories/auth_repository.dart';
import 'package:flutly_store/app/features/auth/presentation/bloc/auth_cubit.dart';
import 'package:flutly_store/app/shared/errors/app_exception.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';

class MockAuthRepository extends Mock implements AuthRepository {}

void main() {
  late AuthRepository repository;

  setUp(() {
    repository = MockAuthRepository();
  });

  test('initial state is AuthInitial', () {
    final cubit = AuthCubit(repository);
    expect(cubit.state, const AuthInitial());
    cubit.close();
  });

  blocTest<AuthCubit, AuthState>(
    'signInWithProvider ignores email when form is invalid',
    build: () {
      when(
        () => repository.signIn(
          email: any(named: 'email'),
          password: any(named: 'password'),
        ),
      ).thenReturn(TaskEither.right(null));
      return AuthCubit(repository);
    },
    act: (cubit) => cubit.signInWithProvider(AuthProvider.email),
    expect: () => <AuthState>[],
    verify: (_) {
      verifyNever(
        () => repository.signIn(
          email: any(named: 'email'),
          password: any(named: 'password'),
        ),
      );
    },
  );

  blocTest<AuthCubit, AuthState>(
    'signInWithProvider email emits loading then signed',
    build: () {
      when(
        () => repository.signIn(
          email: 'user@test.com',
          password: '123',
        ),
      ).thenReturn(TaskEither.right(null));
      return AuthCubit(repository);
    },
    act: (cubit) {
      cubit.signInForm.control('email').value = 'user@test.com';
      cubit.signInForm.control('password').value = '123';
      return cubit.signInWithProvider(AuthProvider.email);
    },
    expect: () => <Object>[
      isA<AuthLoading>(),
      isA<AuthSigned>().having(
        (state) => state.operation,
        'operation',
        AuthOperation.signIn,
      ),
    ],
  );

  blocTest<AuthCubit, AuthState>(
    'signInWithProvider google emits loading then failure on error',
    build: () {
      when(() => repository.signWithGoogle()).thenReturn(
        TaskEither.left(AppException(message: 'failed')),
      );
      return AuthCubit(repository);
    },
    act: (cubit) => cubit.signInWithProvider(AuthProvider.google),
    expect: () => <Object>[
      isA<AuthLoading>(),
      isA<AuthFailure>().having(
        (state) => state.exception.message,
        'message',
        'failed',
      ),
    ],
  );

  blocTest<AuthCubit, AuthState>(
    'signInWithProvider apple emits loading then signed',
    build: () {
      when(() => repository.signWithApple()).thenReturn(TaskEither.right(null));
      return AuthCubit(repository);
    },
    act: (cubit) => cubit.signInWithProvider(AuthProvider.apple),
    expect: () => <Object>[
      isA<AuthLoading>(),
      isA<AuthSigned>().having(
        (state) => state.operation,
        'operation',
        AuthOperation.signIn,
      ),
    ],
  );

  blocTest<AuthCubit, AuthState>(
    'signUpWithEmail ignores when form is invalid',
    build: () {
      when(
        () => repository.signUp(
          name: any(named: 'name'),
          email: any(named: 'email'),
          password: any(named: 'password'),
        ),
      ).thenReturn(TaskEither.right(null));
      return AuthCubit(repository);
    },
    act: (cubit) => cubit.signUpWithEmail(),
    expect: () => <AuthState>[],
    verify: (_) {
      verifyNever(
        () => repository.signUp(
          name: any(named: 'name'),
          email: any(named: 'email'),
          password: any(named: 'password'),
        ),
      );
    },
  );

  blocTest<AuthCubit, AuthState>(
    'signUpWithEmail emits loading then signed on success',
    build: () {
      when(
        () => repository.signUp(
          name: 'User',
          email: 'user@test.com',
          password: '123456',
        ),
      ).thenReturn(TaskEither.right(null));
      return AuthCubit(repository);
    },
    act: (cubit) {
      cubit.signUpForm.control('name').value = 'User';
      cubit.signUpForm.control('email').value = 'user@test.com';
      cubit.signUpForm.control('password').value = '123456';
      cubit.signUpForm.control('confirmPassword').value = '123456';
      return cubit.signUpWithEmail();
    },
    expect: () => <Object>[
      isA<AuthLoading>(),
      isA<AuthSigned>().having(
        (state) => state.operation,
        'operation',
        AuthOperation.signUp,
      ),
    ],
  );

  blocTest<AuthCubit, AuthState>(
    'signUpWithEmail emits loading then failure on error',
    build: () {
      when(
        () => repository.signUp(
          name: 'User',
          email: 'user@test.com',
          password: '123456',
        ),
      ).thenReturn(TaskEither.left(AppException(message: 'failed')));
      return AuthCubit(repository);
    },
    act: (cubit) {
      cubit.signUpForm.control('name').value = 'User';
      cubit.signUpForm.control('email').value = 'user@test.com';
      cubit.signUpForm.control('password').value = '123456';
      cubit.signUpForm.control('confirmPassword').value = '123456';
      return cubit.signUpWithEmail();
    },
    expect: () => <Object>[
      isA<AuthLoading>(),
      isA<AuthFailure>().having(
        (state) => state.exception.message,
        'message',
        'failed',
      ),
    ],
  );
}
