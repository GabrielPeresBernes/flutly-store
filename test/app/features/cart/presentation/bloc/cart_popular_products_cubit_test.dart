import 'package:bloc_test/bloc_test.dart';
import 'package:flutly_store/app/features/cart/presentation/bloc/cart_popular_products_cubit.dart';
import 'package:flutly_store/app/features/product/domain/entities/product.dart';
import 'package:flutly_store/app/features/search/domain/repositories/search_repository.dart';
import 'package:flutly_store/app/shared/errors/app_exception.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';

class MockSearchRepository extends Mock implements SearchRepository {}

void main() {
  late SearchRepository repository;

  final products = [
    Product(
      id: 1,
      title: 'Item',
      thumbnail: 'thumb.png',
      price: 10.0,
    ),
  ];

  setUp(() {
    repository = MockSearchRepository();
  });

  blocTest<CartPopularProductsCubit, CartPopularProductsState>(
    'getProducts emits loaded on success',
    build: () {
      when(() => repository.getPopularProducts()).thenReturn(
        TaskEither.right(products),
      );
      return CartPopularProductsCubit(repository);
    },
    act: (cubit) => cubit.getProducts(),
    expect: () => [
      isA<CartPopularProductsLoading>(),
      isA<CartPopularProductsLoaded>()
          .having((state) => state.products.length, 'length', 1)
          .having((state) => state.products.first.id, 'id', 1),
    ],
  );

  blocTest<CartPopularProductsCubit, CartPopularProductsState>(
    'getProducts emits failure on error',
    build: () {
      when(() => repository.getPopularProducts()).thenReturn(
        TaskEither.left(AppException(message: 'fetch failed')),
      );
      return CartPopularProductsCubit(repository);
    },
    act: (cubit) => cubit.getProducts(),
    expect: () => [
      isA<CartPopularProductsLoading>(),
      isA<CartPopularProductsFailure>(),
    ],
  );
}
