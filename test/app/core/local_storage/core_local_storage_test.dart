import 'package:flutly_store/app/core/local_storage/lib/core_local_storage.dart';
import 'package:flutly_store/app/core/local_storage/lib/providers/local_storage_provider.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockLocalStorageProvider extends Mock implements LocalStorageProvider {}

void main() {
  test('storage returns the provided provider', () {
    final provider = MockLocalStorageProvider();
    final core = CoreLocalStorage(provider: provider);

    expect(core.storage, provider);
  });

  test('secureStorage throws when encrypted provider is missing', () {
    final provider = MockLocalStorageProvider();
    final core = CoreLocalStorage(provider: provider);

    expect(
      () => core.secureStorage,
      throwsA(isA<Exception>()),
    );
  });

  test('secureStorage returns the encrypted provider', () {
    final provider = MockLocalStorageProvider();
    final encryptedProvider = MockLocalStorageProvider();
    final core = CoreLocalStorage(
      provider: provider,
      encryptedProvider: encryptedProvider,
    );

    expect(core.secureStorage, encryptedProvider);
  });
}
