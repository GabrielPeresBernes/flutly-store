import 'package:flutly_store/app/core/local_storage/local_storage.dart';
import 'package:flutly_store/app/features/cart/constants/cart_constants.dart';
import 'package:flutly_store/app/features/cart/data/data_sources/local/cart_local_data_source_impl.dart';
import 'package:flutly_store/app/features/cart/data/models/cart_model.dart';
import 'package:flutly_store/app/features/cart/data/models/cart_product_model.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockCoreLocalStorage extends Mock implements CoreLocalStorage {}

class MockLocalStorageProvider extends Mock implements LocalStorageProvider {}

void main() {
  late CoreLocalStorage localStorage;
  late LocalStorageProvider storage;
  late CartLocalDataSourceImpl dataSource;

  const cart = CartModel(
    totalPrice: 120.0,
    totalItems: 2,
    products: {
      1: CartProductModel(
        id: 1,
        quantity: 2,
        thumbnail: 'thumb.png',
        name: 'Item',
        price: 60.0,
      ),
    },
  );

  setUp(() {
    localStorage = MockCoreLocalStorage();
    storage = MockLocalStorageProvider();
    dataSource = CartLocalDataSourceImpl(localStorage);

    when(() => localStorage.storage).thenReturn(storage);
  });

  test('saveCart stores cart in local storage', () async {
    when(
      () => storage.set(
        CartConstants.cartStorageKey,
        cart,
      ),
    ).thenAnswer((_) async {});

    final result = await dataSource.saveCart(cart).run();

    expect(result.isRight(), isTrue);
    verify(
      () => storage.set(CartConstants.cartStorageKey, cart),
    ).called(1);
  });

  test('getCart returns Some when data exists', () async {
    when(
      () => storage.get<CartModel>(
        CartConstants.cartStorageKey,
        CartModel.fromJson,
      ),
    ).thenAnswer((_) async => cart);

    final result = await dataSource.getCart().run();

    expect(result.isRight(), isTrue);
    result.match(
      (_) => fail('Expected cart'),
      (value) {
        expect(value.isSome(), isTrue);
        expect(value.toNullable(), cart);
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

    final result = await dataSource.getCart().run();

    expect(result.isRight(), isTrue);
    result.match(
      (_) => fail('Expected none'),
      (value) => expect(value.isNone(), isTrue),
    );
  });

  test('clearCart removes cart entry', () async {
    when(
      () => storage.remove(CartConstants.cartStorageKey),
    ).thenAnswer((_) async {});

    final result = await dataSource.clearCart().run();

    expect(result.isRight(), isTrue);
    verify(() => storage.remove(CartConstants.cartStorageKey)).called(1);
  });
}
