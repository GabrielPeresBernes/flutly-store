import 'package:bloc_test/bloc_test.dart';
import 'package:flutly_store/app/features/cart/constants/cart_constants.dart';
import 'package:flutly_store/app/features/cart/domain/entities/cart.dart';
import 'package:flutly_store/app/features/cart/domain/entities/cart_product.dart';
import 'package:flutly_store/app/features/cart/domain/repositories/cart_repository.dart';
import 'package:flutly_store/app/features/cart/presentation/bloc/cart/cart_cubit.dart';
import 'package:flutly_store/app/shared/errors/app_exception.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';

class MockCartRepository extends Mock implements CartRepository {}

void main() {
  late CartRepository repository;

  const productId = 1;
  const uiId = 99;
  const product = CartProduct(
    id: productId,
    quantity: 1,
    thumbnail: 'thumb.png',
    name: 'Item',
    price: 10.0,
  );
  const cart = Cart(
    totalPrice: 10.0,
    totalItems: 1,
    products: {productId: product},
  );

  setUpAll(() {
    registerFallbackValue(Cart.empty());
  });

  setUp(() {
    repository = MockCartRepository();
  });

  blocTest<CartCubit, CartState>(
    'refreshCart emits loaded with update flag when session changed',
    build: () {
      when(() => repository.getCart()).thenReturn(
        TaskEither.right(const Option.of(cart)),
      );
      return CartCubit(repository);
    },
    act: (cubit) => cubit.refreshCart(hasSessionChanged: true),
    expect: () => [
      isA<CartLoading>(),
      isA<CartLoaded>()
          .having((state) => state.cart.totalItems, 'totalItems', 1)
          .having((state) => state.hasUpdated, 'hasUpdated', true),
    ],
  );

  blocTest<CartCubit, CartState>(
    'refreshCart emits empty when no cart is found',
    build: () {
      when(() => repository.getCart()).thenReturn(
        TaskEither.right(none()),
      );
      return CartCubit(repository);
    },
    act: (cubit) => cubit.refreshCart(),
    expect: () => [
      isA<CartLoading>(),
      isA<CartEmpty>(),
    ],
  );

  blocTest<CartCubit, CartState>(
    'refreshCart emits failure on repository error',
    build: () {
      when(() => repository.getCart()).thenReturn(
        TaskEither.left(AppException(message: 'get failed')),
      );
      return CartCubit(repository);
    },
    act: (cubit) => cubit.refreshCart(),
    expect: () => [
      isA<CartLoading>(),
      isA<CartFailure>(),
    ],
  );

  blocTest<CartCubit, CartState>(
    'addProduct emits updated with add operation',
    build: () {
      when(() => repository.saveCart(any())).thenReturn(
        TaskEither.right(null),
      );
      return CartCubit(repository);
    },
    act: (cubit) => cubit.addProduct(
      id: productId,
      thumbnail: product.thumbnail,
      name: product.name,
      price: product.price,
      uiID: uiId,
    ),
    expect: () => [
      isA<CartUpdating>(),
      isA<CartUpdated>()
          .having((state) => state.operation, 'operation', CartOperation.add)
          .having((state) => state.product.quantity, 'quantity', 1)
          .having((state) => state.uiID, 'uiID', uiId),
    ],
  );

  blocTest<CartCubit, CartState>(
    'incrementProduct emits updated with increment operation',
    build: () {
      when(() => repository.saveCart(any())).thenReturn(
        TaskEither.right(null),
      );
      return CartCubit(repository);
    },
    act: (cubit) async {
      await cubit.addProduct(
        id: productId,
        thumbnail: product.thumbnail,
        name: product.name,
        price: product.price,
        uiID: uiId,
      );
      await cubit.incrementProduct(cubit.cart.products[productId]!);
    },
    skip: 2,
    expect: () => [
      isA<CartUpdating>(),
      isA<CartUpdated>()
          .having(
            (state) => state.operation,
            'operation',
            CartOperation.increment,
          )
          .having((state) => state.product.quantity, 'quantity', 2),
    ],
  );

  blocTest<CartCubit, CartState>(
    'decrementProduct emits updated with decrement operation',
    build: () {
      when(() => repository.saveCart(any())).thenReturn(
        TaskEither.right(null),
      );
      return CartCubit(repository);
    },
    act: (cubit) async {
      await cubit.addProduct(
        id: productId,
        thumbnail: product.thumbnail,
        name: product.name,
        price: product.price,
        uiID: uiId,
      );
      await cubit.addProduct(
        id: productId,
        thumbnail: product.thumbnail,
        name: product.name,
        price: product.price,
        uiID: uiId,
      );
      await cubit.decrementProduct(cubit.cart.products[productId]!);
    },
    skip: 4,
    expect: () => [
      isA<CartUpdating>(),
      isA<CartUpdated>()
          .having(
            (state) => state.operation,
            'operation',
            CartOperation.decrement,
          )
          .having((state) => state.product.quantity, 'quantity', 1),
    ],
  );

  blocTest<CartCubit, CartState>(
    'removeProduct emits updated then empty when cart becomes empty',
    build: () {
      when(() => repository.saveCart(any())).thenReturn(
        TaskEither.right(null),
      );
      return CartCubit(repository);
    },
    act: (cubit) async {
      await cubit.addProduct(
        id: productId,
        thumbnail: product.thumbnail,
        name: product.name,
        price: product.price,
        uiID: uiId,
      );
      await cubit.removeProduct(cubit.cart.products[productId]!);
    },
    skip: 2,
    wait: CartConstants.cartItemAnimationDuration,
    expect: () => [
      isA<CartUpdating>(),
      isA<CartUpdated>().having(
        (state) => state.operation,
        'operation',
        CartOperation.remove,
      ),
      isA<CartEmpty>(),
    ],
  );

  blocTest<CartCubit, CartState>(
    'clearCart emits empty on success',
    build: () {
      when(() => repository.clearCart()).thenReturn(
        TaskEither.right(null),
      );
      return CartCubit(repository);
    },
    act: (cubit) => cubit.clearCart(),
    expect: () => [
      isA<CartEmpty>(),
    ],
  );

  blocTest<CartCubit, CartState>(
    'clearCart emits failure on error',
    build: () {
      when(() => repository.clearCart()).thenReturn(
        TaskEither.left(AppException(message: 'clear failed')),
      );
      return CartCubit(repository);
    },
    act: (cubit) => cubit.clearCart(),
    expect: () => [
      isA<CartClearFailure>(),
    ],
  );
}
