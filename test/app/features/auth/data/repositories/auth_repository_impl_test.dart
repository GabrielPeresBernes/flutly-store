import 'package:flutly_store/app/features/auth/data/data_sources/auth_local_data_source.dart';
import 'package:flutly_store/app/features/auth/data/data_sources/auth_remote_data_source.dart';
import 'package:flutly_store/app/features/auth/data/models/credentials_model.dart';
import 'package:flutly_store/app/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:flutly_store/app/features/auth/domain/entities/credentials.dart';
import 'package:flutly_store/app/shared/errors/app_exception.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';

class MockAuthRemoteDataSource extends Mock implements AuthRemoteDataSource {}

class MockAuthLocalDataSource extends Mock implements AuthLocalDataSource {}

void main() {
  late AuthRemoteDataSource remoteDataSource;
  late AuthLocalDataSource localDataSource;
  late AuthRepositoryImpl repository;

  final credentials = CredentialsModel(
    userId: '1',
    name: 'User',
    email: 'user@test.com',
    provider: AuthProvider.email.name,
  );

  final updatedCredentials = CredentialsModel(
    userId: '1',
    name: 'Updated',
    email: 'user@test.com',
    provider: AuthProvider.google.name,
  );

  setUp(() {
    remoteDataSource = MockAuthRemoteDataSource();
    localDataSource = MockAuthLocalDataSource();
    repository = AuthRepositoryImpl(remoteDataSource, localDataSource);
  });

  test('signIn persists credentials on success', () async {
    when(
      () => remoteDataSource.signIn(
        email: 'user@test.com',
        password: '123',
      ),
    ).thenReturn(TaskEither.right(credentials));
    when(
      () => localDataSource.saveCredentials(credentials),
    ).thenReturn(TaskEither.right(null));

    final result = await repository
        .signIn(email: 'user@test.com', password: '123')
        .run();

    expect(result.isRight(), isTrue);
    verify(
      () => remoteDataSource.signIn(
        email: 'user@test.com',
        password: '123',
      ),
    ).called(1);
    verify(() => localDataSource.saveCredentials(credentials)).called(1);
  });

  test('signUp persists credentials on success', () async {
    when(
      () => remoteDataSource.signUp(
        name: 'User',
        email: 'user@test.com',
        password: '123',
      ),
    ).thenReturn(TaskEither.right(credentials));
    when(
      () => localDataSource.saveCredentials(credentials),
    ).thenReturn(TaskEither.right(null));

    final result = await repository
        .signUp(name: 'User', email: 'user@test.com', password: '123')
        .run();

    expect(result.isRight(), isTrue);
    verify(
      () => remoteDataSource.signUp(
        name: 'User',
        email: 'user@test.com',
        password: '123',
      ),
    ).called(1);
    verify(() => localDataSource.saveCredentials(credentials)).called(1);
  });

  test('signWithGoogle persists credentials on success', () async {
    when(
      () => remoteDataSource.signWithGoogle(),
    ).thenReturn(TaskEither.right(credentials));
    when(
      () => localDataSource.saveCredentials(credentials),
    ).thenReturn(TaskEither.right(null));

    final result = await repository.signWithGoogle().run();

    expect(result.isRight(), isTrue);
    verify(() => remoteDataSource.signWithGoogle()).called(1);
    verify(() => localDataSource.saveCredentials(credentials)).called(1);
  });

  test('signWithApple persists credentials on success', () async {
    when(
      () => remoteDataSource.signWithApple(),
    ).thenReturn(TaskEither.right(credentials));
    when(
      () => localDataSource.saveCredentials(credentials),
    ).thenReturn(TaskEither.right(null));

    final result = await repository.signWithApple().run();

    expect(result.isRight(), isTrue);
    verify(() => remoteDataSource.signWithApple()).called(1);
    verify(() => localDataSource.saveCredentials(credentials)).called(1);
  });

  test('signOut clears credentials even when remote fails', () async {
    when(() => remoteDataSource.signOut()).thenReturn(
      TaskEither.left(AppException(message: 'sign out failed')),
    );
    when(
      () => localDataSource.clearCredentials(),
    ).thenReturn(TaskEither.right(null));

    final result = await repository.signOut().run();

    expect(result.isRight(), isTrue);
    verify(() => remoteDataSource.signOut()).called(1);
    verify(() => localDataSource.clearCredentials()).called(1);
  });

  test('getCredentials maps model to entity', () async {
    when(() => localDataSource.getCredentials()).thenReturn(
      TaskEither.right(Option.of(credentials)),
    );

    final result = await repository.getCredentials().run();

    expect(result.isRight(), isTrue);
    result.match(
      (_) => fail('Expected credentials'),
      (value) {
        expect(value.isSome(), isTrue);
        final entity = value.toNullable();
        expect(entity?.userId, credentials.userId);
        expect(entity?.name, credentials.name);
        expect(entity?.email, credentials.email);
        expect(entity?.provider, AuthProvider.email);
      },
    );
  });

  test('isAuthenticated delegates to local data source', () async {
    when(() => localDataSource.isAuthenticated()).thenAnswer((_) async => true);

    final result = await repository.isAuthenticated();

    expect(result, isTrue);
    verify(() => localDataSource.isAuthenticated()).called(1);
  });

  test('updateUser uses provider from local credentials', () async {
    final storedCredentials = CredentialsModel(
      userId: '1',
      name: 'User',
      email: 'user@test.com',
      provider: AuthProvider.google.name,
    );

    when(() => localDataSource.getCredentials()).thenReturn(
      TaskEither.right(Option.of(storedCredentials)),
    );
    when(
      () => remoteDataSource.updateUser(
        provider: AuthProvider.google,
        name: 'Updated',
        currentPassword: 'old',
        newPassword: 'new',
      ),
    ).thenReturn(TaskEither.right(updatedCredentials));
    when(
      () => localDataSource.saveCredentials(updatedCredentials),
    ).thenReturn(TaskEither.right(null));

    final result = await repository
        .updateUser(
          name: 'Updated',
          currentPassword: 'old',
          newPassword: 'new',
        )
        .run();

    expect(result.isRight(), isTrue);
    verify(
      () => remoteDataSource.updateUser(
        provider: AuthProvider.google,
        name: 'Updated',
        currentPassword: 'old',
        newPassword: 'new',
      ),
    ).called(1);
    verify(() => localDataSource.saveCredentials(updatedCredentials)).called(1);
  });
}
