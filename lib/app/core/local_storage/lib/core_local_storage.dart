import 'providers/local_storage_provider.dart';

/// Core Local Storage for managing storage providers.
class CoreLocalStorage {
  const CoreLocalStorage({
    required this.provider,
    this.encryptedProvider,
  });

  final LocalStorageProvider provider;
  final LocalStorageProvider? encryptedProvider;

  /// Retrieves the standard storage provider.
  LocalStorageProvider get storage => provider;

  /// Retrieves the secure storage provider.
  LocalStorageProvider get secureStorage {
    if (encryptedProvider == null) {
      throw Exception('Encrypted provider is not initialized.');
    }
    return encryptedProvider!;
  }
}
