import 'dart:convert';

import 'package:flutly_store/app/core/local_storage/lib/mixins/json_serializable_mixin.dart';
import 'package:flutly_store/app/core/local_storage/lib/providers/secure_storage_provider.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockFlutterSecureStorage extends Mock implements FlutterSecureStorage {}

class _TestData with JsonSerializableMixin {
  _TestData(this.value);

  final int value;

  @override
  Map<String, dynamic> toJson() => <String, dynamic>{'value': value};
}

void main() {
  late FlutterSecureStorage secureStorage;
  late SecureStorageProvider provider;

  setUp(() {
    secureStorage = MockFlutterSecureStorage();
    provider = SecureStorageProvider(secureStorage);
  });

  test('get returns null when key is missing', () async {
    when(
      () => secureStorage.read(key: 'missing'),
    ).thenAnswer((_) async => null);

    final result = await provider.get<_TestData>(
      'missing',
      (json) => _TestData(json['value'] as int),
    );

    expect(result, isNull);
  });

  test('get decodes JSON and notifies when requested', () async {
    final notifier = provider.getNotifier<_TestData>('item');

    when(() => secureStorage.read(key: 'item')).thenAnswer(
      (_) async => jsonEncode(<String, dynamic>{'value': 7}),
    );

    final result = await provider.get<_TestData>(
      'item',
      (json) => _TestData(json['value'] as int),
      shouldNotifyListeners: true,
    );

    expect(result?.value, 7);
    expect(notifier.value?.value, 7);
  });

  test('set stores JSON and notifies existing notifier', () async {
    final data = _TestData(3);

    final notifier = provider.getNotifier<_TestData>('item');

    when(
      () => secureStorage.write(
        key: 'item',
        value: any(named: 'value'),
      ),
    ).thenAnswer((_) async {});

    await provider.set('item', data);

    verify(
      () => secureStorage.write(
        key: 'item',
        value: jsonEncode(<String, dynamic>{'value': 3}),
      ),
    ).called(1);

    expect(notifier.value, data);
  });

  test('remove notifies when requested', () async {
    final notifier = provider.getNotifier<_TestData>('item');

    notifier.value = _TestData(1);

    when(() => secureStorage.delete(key: 'item')).thenAnswer((_) async {});

    await provider.remove('item', shouldNotifyListeners: true);

    expect(notifier.value, isNull);
  });

  test('clearAll delegates to secure storage', () async {
    when(() => secureStorage.deleteAll()).thenAnswer((_) async {});

    await provider.clearAll();

    verify(() => secureStorage.deleteAll()).called(1);
  });

  test('getNotifier returns same instance for the same key', () {
    final first = provider.getNotifier<_TestData>('item');
    final second = provider.getNotifier<_TestData>('item');

    expect(identical(first, second), isTrue);
  });
}
