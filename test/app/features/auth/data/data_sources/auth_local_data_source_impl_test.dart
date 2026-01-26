import 'package:flutly_store/app/core/local_storage/local_storage.dart';
import 'package:flutly_store/app/features/auth/constants/auth_constants.dart';
import 'package:flutly_store/app/features/auth/data/data_sources/local/auth_local_data_source_impl.dart';
import 'package:flutly_store/app/features/auth/data/models/credentials_model.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockCoreLocalStorage extends Mock implements CoreLocalStorage {}

class MockLocalStorageProvider extends Mock implements LocalStorageProvider {}

void main() {
  late CoreLocalStorage localStorage;
  late LocalStorageProvider secureStorage;
  late AuthLocalDataSourceImpl dataSource;

  const credentials = CredentialsModel(
    userId: '1',
    name: 'User',
    email: 'user@test.com',
    provider: 'email',
  );

  setUp(() {
    localStorage = MockCoreLocalStorage();
    secureStorage = MockLocalStorageProvider();
    dataSource = AuthLocalDataSourceImpl(localStorage);

    when(() => localStorage.secureStorage).thenReturn(secureStorage);
  });

  test('saveCredentials stores credentials in secure storage', () async {
    when(
      () => secureStorage.set(
        AuthConstants.userKey,
        credentials,
      ),
    ).thenAnswer((_) async {});

    final result = await dataSource.saveCredentials(credentials).run();

    expect(result.isRight(), isTrue);
    verify(
      () => secureStorage.set(AuthConstants.userKey, credentials),
    ).called(1);
  });

  test('getCredentials returns Some when data exists', () async {
    when(
      () => secureStorage.get<CredentialsModel>(
        AuthConstants.userKey,
        CredentialsModel.fromJson,
      ),
    ).thenAnswer((_) async => credentials);

    final result = await dataSource.getCredentials().run();

    expect(result.isRight(), isTrue);
    result.match(
      (_) => fail('Expected credentials'),
      (value) {
        expect(value.isSome(), isTrue);
        expect(value.toNullable(), credentials);
      },
    );
  });

  test('getCredentials returns None when data is missing', () async {
    when(
      () => secureStorage.get<CredentialsModel>(
        AuthConstants.userKey,
        CredentialsModel.fromJson,
      ),
    ).thenAnswer((_) async => null);

    final result = await dataSource.getCredentials().run();

    expect(result.isRight(), isTrue);
    result.match(
      (_) => fail('Expected none'),
      (value) => expect(value.isNone(), isTrue),
    );
  });

  test('clearCredentials removes secure storage entry', () async {
    when(
      () => secureStorage.remove(AuthConstants.userKey),
    ).thenAnswer((_) async {});

    final result = await dataSource.clearCredentials().run();

    expect(result.isRight(), isTrue);
    verify(() => secureStorage.remove(AuthConstants.userKey)).called(1);
  });

  test('isAuthenticated returns true when credentials exist', () async {
    when(
      () => secureStorage.get<CredentialsModel>(
        AuthConstants.userKey,
        CredentialsModel.fromJson,
      ),
    ).thenAnswer((_) async => credentials);

    final result = await dataSource.isAuthenticated();

    expect(result, isTrue);
  });

  test('isAuthenticated returns false when credentials are missing', () async {
    when(
      () => secureStorage.get<CredentialsModel>(
        AuthConstants.userKey,
        CredentialsModel.fromJson,
      ),
    ).thenAnswer((_) async => null);

    final result = await dataSource.isAuthenticated();

    expect(result, isFalse);
  });
}
