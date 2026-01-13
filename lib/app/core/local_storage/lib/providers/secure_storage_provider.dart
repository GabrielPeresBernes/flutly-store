import 'dart:convert';

import 'package:flutter/widgets.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../mixins/json_serializable_mixin.dart';
import 'local_storage_provider.dart';

/// FlutterSecureStorage implementation of the LocalStorageProvider interface.
class SecureStorageProvider implements LocalStorageProvider {
  SecureStorageProvider(this._secureStorage);

  final FlutterSecureStorage _secureStorage;

  final Map<String, ValueNotifier<dynamic>> _notifiers = {};

  @override
  Future<void> set(
    String key,
    JsonSerializableMixin data,
  ) async {
    final jsonString = jsonEncode(data.toJson());

    await _secureStorage.write(
      key: key,
      value: jsonString,
    );

    _notifyListeners(key, data);
  }

  @override
  Future<T?> get<T>(
    String key,
    T Function(Map<String, dynamic>) decoder, {
    bool shouldNotifyListeners = false,
  }) async {
    final jsonString = await _secureStorage.read(key: key);

    if (jsonString == null) {
      return null;
    }

    final jsonMap = Map<String, dynamic>.from(jsonDecode(jsonString) as Map);

    final data = decoder(jsonMap);

    if (shouldNotifyListeners) {
      _notifyListeners(key, data);
    }

    return data;
  }

  @override
  Future<void> remove(
    String key, {
    bool shouldNotifyListeners = false,
  }) async {
    await _secureStorage.delete(key: key);

    if (shouldNotifyListeners) {
      _notifyListeners(key, null);
    }
  }

  @override
  Future<void> clearAll() async {
    await _secureStorage.deleteAll();
  }

  @override
  ValueNotifier<T?> getNotifier<T>(String key) {
    if (!_notifiers.containsKey(key)) {
      _notifiers[key] = ValueNotifier<T?>(null);
    }

    return _notifiers[key]! as ValueNotifier<T?>;
  }

  void _notifyListeners(String key, dynamic value) {
    if (_notifiers.containsKey(key)) {
      (_notifiers[key]!).value = value;
    }
  }
}
