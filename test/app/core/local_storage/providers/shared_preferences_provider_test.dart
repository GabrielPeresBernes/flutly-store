import 'dart:convert';

import 'package:flutly_store/app/core/local_storage/lib/mixins/json_serializable_mixin.dart';
import 'package:flutly_store/app/core/local_storage/lib/providers/shared_preferences_provider.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MockSharedPreferencesWithCache extends Mock
    implements SharedPreferencesWithCache {}

class _TestData with JsonSerializableMixin {
  _TestData(this.value);

  final int value;

  @override
  Map<String, dynamic> toJson() => <String, dynamic>{'value': value};
}

void main() {
  late SharedPreferencesWithCache sharedPreferences;
  late SharedPreferencesProvider provider;

  setUp(() {
    sharedPreferences = MockSharedPreferencesWithCache();
    provider = SharedPreferencesProvider(sharedPreferences);
  });

  test('get returns null when key is missing', () async {
    when(() => sharedPreferences.getString('missing')).thenReturn(null);

    final result = await provider.get<_TestData>(
      'missing',
      (json) => _TestData(json['value'] as int),
    );

    expect(result, isNull);
  });

  test('get decodes JSON and notifies when requested', () async {
    final notifier = provider.getNotifier<_TestData>('item');

    when(
      () => sharedPreferences.getString('item'),
    ).thenReturn(jsonEncode(<String, dynamic>{'value': 7}));

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
      () => sharedPreferences.setString('item', any()),
    ).thenAnswer((_) async => true);

    await provider.set('item', data);

    verify(
      () => sharedPreferences.setString(
        'item',
        jsonEncode(<String, dynamic>{'value': 3}),
      ),
    ).called(1);

    expect(notifier.value, data);
  });

  test('remove notifies when requested', () async {
    final notifier = provider.getNotifier<_TestData>('item');

    notifier.value = _TestData(1);

    when(() => sharedPreferences.remove('item')).thenAnswer((_) async => true);

    await provider.remove('item', shouldNotifyListeners: true);

    expect(notifier.value, isNull);
  });

  test('getNotifier returns same instance for the same key', () {
    final first = provider.getNotifier<_TestData>('item');
    final second = provider.getNotifier<_TestData>('item');

    expect(identical(first, second), isTrue);
  });
}
