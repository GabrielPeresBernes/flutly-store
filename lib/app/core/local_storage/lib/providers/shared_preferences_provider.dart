import 'dart:convert';

import 'package:flutter/widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../mixins/json_serializable_mixin.dart';
import 'local_storage_provider.dart';

/// SharedPreferences implementation of the LocalStorageProvider interface.
class SharedPreferencesProvider implements LocalStorageProvider {
  SharedPreferencesProvider(this._sharedPreferences);

  final SharedPreferencesWithCache _sharedPreferences;

  final Map<String, ValueNotifier<dynamic>> _notifiers = {};

  @override
  Future<void> clearAll() async {
    await _sharedPreferences.clear();
  }

  @override
  Future<T?> get<T>(
    String key,
    T Function(Map<String, dynamic>) decoder, {
    bool shouldNotifyListeners = false,
  }) async {
    final jsonString = _sharedPreferences.getString(key);

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
    await _sharedPreferences.remove(key);

    if (shouldNotifyListeners) {
      _notifyListeners(key, null);
    }
  }

  @override
  Future<void> set(
    String key,
    JsonSerializableMixin data,
  ) async {
    final jsonString = jsonEncode(data.toJson());

    await _sharedPreferences.setString(key, jsonString);

    _notifyListeners(key, data);
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
