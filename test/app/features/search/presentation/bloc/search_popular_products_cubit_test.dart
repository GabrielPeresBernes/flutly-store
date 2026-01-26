import 'package:bloc_test/bloc_test.dart';
import 'package:flutly_store/app/features/product/domain/entities/product.dart';
import 'package:flutly_store/app/features/search/domain/repositories/search_repository.dart';
import 'package:flutly_store/app/features/search/presentation/bloc/popular_products/search_popular_products_cubit.dart';
import 'package:flutly_store/app/shared/errors/app_exception.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';

class MockSearchRepository extends Mock implements SearchRepository {}

void main() {
  late SearchRepository repository;

  final products = [
    const Product(
      id: 1,
      title: 'Case',
      thumbnail: 'case.png',
      price: 10.0,
      rating: 4.5,
    ),
  ];

  setUp(() {
    repository = MockSearchRepository();
  });

  blocTest<SearchPopularProductsCubit, SearchPopularProductsState>(
    'getPopularProducts emits loaded on success',
    build: () {
      when(() => repository.getPopularProducts()).thenReturn(
        TaskEither.right(products),
      );
      return SearchPopularProductsCubit(repository);
    },
    act: (cubit) => cubit.getPopularProducts(),
    expect: () => [
      isA<SearchPopularProductsLoading>(),
      isA<SearchPopularProductsLoaded>().having(
        (state) => state.products.length,
        'length',
        1,
      ),
    ],
  );

  blocTest<SearchPopularProductsCubit, SearchPopularProductsState>(
    'getPopularProducts emits failure on error',
    build: () {
      when(() => repository.getPopularProducts()).thenReturn(
        TaskEither.left(AppException(message: 'failed')),
      );
      return SearchPopularProductsCubit(repository);
    },
    act: (cubit) => cubit.getPopularProducts(),
    expect: () => [
      isA<SearchPopularProductsLoading>(),
      isA<SearchPopularProductsFailure>(),
    ],
  );
}
