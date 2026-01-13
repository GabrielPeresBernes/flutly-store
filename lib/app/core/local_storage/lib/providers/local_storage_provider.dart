import 'package:flutter/widgets.dart';

import '../mixins/json_serializable_mixin.dart';

/// Interface for local storage providers.
abstract interface class LocalStorageProvider {
  /// Sets the value for the given [key] to the provided [data].
  Future<void> set(
    String key,
    JsonSerializableMixin data,
  );

  /// Retrieves the value for the given [key]
  /// and decodes it using the provided [decoder].
  Future<T?> get<T>(
    String key,
    T Function(Map<String, dynamic>) decoder, {
    bool shouldNotifyListeners = false,
  });

  /// Retrieves a [ValueNotifier] for the given [key].
  ValueNotifier<T?> getNotifier<T>(String key);

  /// Removes the value associated with the given [key].
  Future<void> remove(
    String key, {
    bool shouldNotifyListeners = false,
  });

  /// Clears all stored values.
  Future<void> clearAll();
}
