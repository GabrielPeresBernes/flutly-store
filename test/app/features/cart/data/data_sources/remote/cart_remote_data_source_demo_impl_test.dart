import 'package:flutly_store/app/core/local_storage/local_storage.dart';
import 'package:flutly_store/app/features/cart/constants/cart_constants.dart';
import 'package:flutly_store/app/features/cart/data/data_sources/remote/cart_remote_data_source_demo_impl.dart';
import 'package:flutly_store/app/features/cart/data/models/cart_model.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../../../utils/test_utils.dart';

class MockCoreLocalStorage extends Mock implements CoreLocalStorage {}

class MockLocalStorageProvider extends Mock implements LocalStorageProvider {}

void main() {
  late CoreLocalStorage localStorage;
  late LocalStorageProvider storage;
  late CartRemoteDataSourceDemoImpl dataSource;

  setUpAll(() async {
    await TestUtils.setUpLocalization();
  });

  setUp(() {
    localStorage = MockCoreLocalStorage();
    storage = MockLocalStorageProvider();
    dataSource = CartRemoteDataSourceDemoImpl(localStorage);

    when(() => localStorage.storage).thenReturn(storage);
  });

  test('clearCart returns success', () async {
    final result = await dataSource.clearCart('user').run();

    expect(result.isRight(), isTrue);
  });

  test('saveCart returns success', () async {
    const cart = CartModel(totalPrice: 0, totalItems: 0, products: {});

    final result = await dataSource.saveCart('user', cart).run();

    expect(result.isRight(), isTrue);
  });

  test('getCart returns Some when data exists', () async {
    const cart = CartModel(totalPrice: 10, totalItems: 1, products: {});

    when(
      () => storage.get<CartModel>(
        CartConstants.cartStorageKey,
        CartModel.fromJson,
      ),
    ).thenAnswer((_) async => cart);

    final result = await dataSource.getCart('user').run();

    result.match(
      (_) => fail('Expected cart'),
      (value) {
        expect(value.isSome(), isTrue);
        expect(value.toNullable()!.totalItems, 1);
      },
    );
  });

  test('getCart returns None when data is missing', () async {
    when(
      () => storage.get<CartModel>(
        CartConstants.cartStorageKey,
        CartModel.fromJson,
      ),
    ).thenAnswer((_) async => null);

    final result = await dataSource.getCart('user').run();

    result.match(
      (_) => fail('Expected none'),
      (value) => expect(value, isA<None>()),
    );
  });
}
