import 'package:flutly_store/app/core/local_storage/local_storage.dart';
import 'package:flutly_store/app/features/auth/constants/auth_constants.dart';
import 'package:flutly_store/app/features/auth/data/data_sources/remote/auth_remote_data_source_demo_impl.dart';
import 'package:flutly_store/app/features/auth/data/models/credentials_model.dart';
import 'package:flutly_store/app/features/auth/domain/entities/credentials.dart';
import 'package:flutly_store/app/shared/types/response_type.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../../../utils/test_utils.dart';

class MockCoreLocalStorage extends Mock implements CoreLocalStorage {}

class MockLocalStorageProvider extends Mock implements LocalStorageProvider {}

void main() {
  late CoreLocalStorage localStorage;
  late LocalStorageProvider secureStorage;
  late AuthRemoteDataSourceDemoImpl dataSource;

  setUpAll(() async {
    await TestUtils.setUpLocalization();
  });

  setUp(() {
    localStorage = MockCoreLocalStorage();
    secureStorage = MockLocalStorageProvider();
    dataSource = AuthRemoteDataSourceDemoImpl(localStorage);

    when(() => localStorage.secureStorage).thenReturn(secureStorage);
  });

  test('signIn returns credentials with provided email', () async {
    final result = await dataSource
        .signIn(email: 'user@example.com', password: 'pass')
        .run();

    result.match(
      (_) => fail('Expected credentials'),
      (value) {
        expect(value.userId, 'demo_user_id');
        expect(value.name, 'Demo User');
        expect(value.email, 'user@example.com');
        expect(value.provider, AuthProvider.email.name);
      },
    );
  });

  test('signUp returns credentials with provided name and email', () async {
    final result = await dataSource
        .signUp(name: 'Ada', email: 'ada@example.com', password: 'pass')
        .run();

    result.match(
      (_) => fail('Expected credentials'),
      (value) {
        expect(value.userId, 'demo_user_id');
        expect(value.name, 'Ada');
        expect(value.email, 'ada@example.com');
        expect(value.provider, AuthProvider.email.name);
      },
    );
  });

  test(
    'signWithApple and signWithGoogle return provider credentials',
    () async {
      final cases = [
        (
          provider: AuthProvider.apple,
          email: 'apple@example.com',
          call: dataSource.signWithApple,
        ),
        (
          provider: AuthProvider.google,
          email: 'google@example.com',
          call: dataSource.signWithGoogle,
        ),
      ];

      for (final entry in cases) {
        final result = await entry.call().run();

        result.match(
          (_) => fail('Expected credentials'),
          (value) {
            expect(value.userId, 'demo_user_id');
            expect(value.name, 'Demo User');
            expect(value.email, entry.email);
            expect(value.provider, entry.provider.name);
          },
        );
      }
    },
  );

  test('signOut returns success', () async {
    final result = await dataSource.signOut().run();

    expect(result.isRight(), isTrue);
  });

  test(
    'updateUser updates name and prefers stored email when present',
    () async {
      const stored = CredentialsModel(
        userId: 'any',
        name: 'any',
        email: 'stored@example.com',
        provider: 'email',
      );

      when(
        () => secureStorage.get<CredentialsModel>(
          AuthConstants.userKey,
          CredentialsModel.fromJson,
        ),
      ).thenAnswer((_) async => stored);

      final result = await dataSource
          .updateUser(provider: AuthProvider.google, name: 'New Name')
          .run();

      result.match(
        (_) => fail('Expected credentials'),
        (value) {
          expect(value.name, 'New Name');
          expect(value.email, 'stored@example.com');
          expect(value.provider, AuthProvider.google.name);
        },
      );

      verify(
        () => secureStorage.get<CredentialsModel>(
          AuthConstants.userKey,
          CredentialsModel.fromJson,
        ),
      ).called(1);
    },
  );

  test('updateUser keeps current email when stored email is empty', () async {
    const stored = CredentialsModel(
      userId: 'any',
      name: 'any',
      email: '',
      provider: 'email',
    );

    when(
      () => secureStorage.get<CredentialsModel>(
        AuthConstants.userKey,
        CredentialsModel.fromJson,
      ),
    ).thenAnswer((_) async => stored);

    await dataSource
        .signIn(email: 'current@example.com', password: 'pass')
        .run();

    final result = await dataSource
        .updateUser(provider: AuthProvider.email)
        .run();

    result.match(
      (_) => fail('Expected credentials'),
      (value) {
        expect(value.name, 'Demo User');
        expect(value.email, 'current@example.com');
        expect(value.provider, AuthProvider.email.name);
      },
    );
  });
}
