import 'package:flutly_store/app/features/auth/data/data_sources/local/auth_local_data_source.dart';
import 'package:flutly_store/app/features/auth/data/models/credentials_model.dart';
import 'package:flutly_store/app/features/cart/data/data_sources/local/cart_local_data_source.dart';
import 'package:flutly_store/app/features/cart/data/data_sources/remote/cart_remote_data_source.dart';
import 'package:flutly_store/app/features/cart/data/models/cart_model.dart';
import 'package:flutly_store/app/features/cart/data/models/cart_product_model.dart';
import 'package:flutly_store/app/features/cart/data/repositories/cart_repository_impl.dart';
import 'package:flutly_store/app/features/cart/domain/entities/cart.dart';
import 'package:flutly_store/app/features/cart/domain/entities/cart_product.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';

class MockAuthLocalDataSource extends Mock implements AuthLocalDataSource {}

class MockCartRemoteDataSource extends Mock implements CartRemoteDataSource {}

class MockCartLocalDataSource extends Mock implements CartLocalDataSource {}

void main() {
  late AuthLocalDataSource authLocalDataSource;
  late CartRemoteDataSource remoteDataSource;
  late CartLocalDataSource localDataSource;
  late CartRepositoryImpl repository;

  const userId = 'user-1';
  const credentials = CredentialsModel(
    userId: userId,
    name: 'User',
    email: 'user@test.com',
    provider: 'email',
  );

  const cartEntity = Cart(
    totalPrice: 120.0,
    totalItems: 2,
    products: {
      1: CartProduct(
        id: 1,
        quantity: 2,
        thumbnail: 'thumb.png',
        name: 'Item',
        price: 60.0,
      ),
    },
  );

  const cartModel = CartModel(
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

  setUpAll(() {
    registerFallbackValue(
      const CartModel(totalPrice: 0.0, totalItems: 0, products: {}),
    );
  });

  setUp(() {
    authLocalDataSource = MockAuthLocalDataSource();
    remoteDataSource = MockCartRemoteDataSource();
    localDataSource = MockCartLocalDataSource();
    repository = CartRepositoryImpl(
      authLocalDataSource,
      remoteDataSource,
      localDataSource,
    );
  });

  test('saveCart uses local storage when user is guest', () async {
    when(() => authLocalDataSource.getCredentials()).thenReturn(
      TaskEither.right(none()),
    );
    when(() => localDataSource.saveCart(any())).thenReturn(
      TaskEither.right(null),
    );

    final result = await repository.saveCart(cartEntity).run();

    expect(result.isRight(), isTrue);
    verify(() => localDataSource.saveCart(any())).called(1);
    verifyNever(() => remoteDataSource.saveCart(any(), any()));
  });

  test('saveCart syncs remote and local when user is authenticated', () async {
    when(() => authLocalDataSource.getCredentials()).thenReturn(
      TaskEither.right(const Option.of(credentials)),
    );
    when(() => remoteDataSource.saveCart(userId, any())).thenReturn(
      TaskEither.right(null),
    );
    when(() => localDataSource.saveCart(any())).thenReturn(
      TaskEither.right(null),
    );

    final result = await repository.saveCart(cartEntity).run();

    expect(result.isRight(), isTrue);
    verify(() => remoteDataSource.saveCart(userId, any())).called(1);
    verify(() => localDataSource.saveCart(any())).called(1);
  });

  test('getCart maps local cart when user is guest', () async {
    when(() => authLocalDataSource.getCredentials()).thenReturn(
      TaskEither.right(none()),
    );
    when(() => localDataSource.getCart()).thenReturn(
      TaskEither.right(const Option.of(cartModel)),
    );

    final result = await repository.getCart().run();

    expect(result.isRight(), isTrue);
    result.match(
      (_) => fail('Expected cart'),
      (value) {
        final entity = value.toNullable();
        expect(entity, isNotNull);
        expect(entity!.totalItems, cartEntity.totalItems);
        expect(entity.totalPrice, cartEntity.totalPrice);
      },
    );
  });

  test('getCart syncs local to remote when remote is empty', () async {
    when(() => authLocalDataSource.getCredentials()).thenReturn(
      TaskEither.right(const Option.of(credentials)),
    );
    when(() => localDataSource.getCart()).thenReturn(
      TaskEither.right(const Option.of(cartModel)),
    );
    when(() => remoteDataSource.getCart(userId)).thenReturn(
      TaskEither.right(none()),
    );
    when(() => remoteDataSource.saveCart(userId, any())).thenReturn(
      TaskEither.right(null),
    );

    final result = await repository.getCart().run();

    expect(result.isRight(), isTrue);
    verify(() => remoteDataSource.saveCart(userId, any())).called(1);
    verifyNever(() => localDataSource.saveCart(any()));
  });

  test('getCart syncs remote to local when local is empty', () async {
    when(() => authLocalDataSource.getCredentials()).thenReturn(
      TaskEither.right(const Option.of(credentials)),
    );
    when(() => localDataSource.getCart()).thenReturn(
      TaskEither.right(none()),
    );
    when(() => remoteDataSource.getCart(userId)).thenReturn(
      TaskEither.right(const Option.of(cartModel)),
    );
    when(() => localDataSource.saveCart(any())).thenReturn(
      TaskEither.right(null),
    );

    final result = await repository.getCart().run();

    expect(result.isRight(), isTrue);
    verify(() => localDataSource.saveCart(any())).called(1);
    verifyNever(() => remoteDataSource.saveCart(any(), any()));
  });

  test('getCart merges carts when both local and remote exist', () async {
    const remoteCart = cartModel;
    const localCart = CartModel(
      totalPrice: 40.0,
      totalItems: 2,
      products: {
        2: CartProductModel(
          id: 2,
          quantity: 2,
          thumbnail: 'thumb-2.png',
          name: 'Item 2',
          price: 20.0,
        ),
      },
    );

    when(() => authLocalDataSource.getCredentials()).thenReturn(
      TaskEither.right(const Option.of(credentials)),
    );
    when(() => localDataSource.getCart()).thenReturn(
      TaskEither.right(const Option.of(localCart)),
    );
    when(() => remoteDataSource.getCart(userId)).thenReturn(
      TaskEither.right(const Option.of(remoteCart)),
    );
    when(() => remoteDataSource.saveCart(userId, any())).thenReturn(
      TaskEither.right(null),
    );
    when(() => localDataSource.saveCart(any())).thenReturn(
      TaskEither.right(null),
    );

    final result = await repository.getCart().run();

    expect(result.isRight(), isTrue);
    final captured =
        verify(
              () => remoteDataSource.saveCart(userId, captureAny()),
            ).captured.single
            as CartModel;
    expect(captured.totalItems, 4);
    expect(captured.totalPrice, 160.0);
    expect(captured.products.length, 2);
    verify(() => localDataSource.saveCart(any())).called(1);
  });

  test('clearCart uses local storage when user is guest', () async {
    when(() => authLocalDataSource.getCredentials()).thenReturn(
      TaskEither.right(none()),
    );
    when(() => localDataSource.clearCart()).thenReturn(
      TaskEither.right(null),
    );

    final result = await repository.clearCart().run();

    expect(result.isRight(), isTrue);
    verify(() => localDataSource.clearCart()).called(1);
    verifyNever(() => remoteDataSource.clearCart(any()));
  });

  test('clearCart syncs remote and local when user is authenticated', () async {
    when(() => authLocalDataSource.getCredentials()).thenReturn(
      TaskEither.right(const Option.of(credentials)),
    );
    when(() => remoteDataSource.clearCart(userId)).thenReturn(
      TaskEither.right(null),
    );
    when(() => localDataSource.clearCart()).thenReturn(
      TaskEither.right(null),
    );

    final result = await repository.clearCart().run();

    expect(result.isRight(), isTrue);
    verify(() => remoteDataSource.clearCart(userId)).called(1);
    verify(() => localDataSource.clearCart()).called(1);
  });
}
