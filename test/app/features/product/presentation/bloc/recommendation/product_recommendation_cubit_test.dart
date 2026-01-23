import 'package:bloc_test/bloc_test.dart';
import 'package:flutly_store/app/features/product/domain/entities/product.dart';
import 'package:flutly_store/app/features/product/domain/repositories/product_repository.dart';
import 'package:flutly_store/app/features/product/presentation/bloc/recommendation/product_recommendation_cubit.dart';
import 'package:flutly_store/app/shared/errors/app_exception.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';

class MockProductRepository extends Mock implements ProductRepository {}

void main() {
  late ProductRepository repository;

  final products = [
    Product(
      id: 1,
      title: 'Case',
      thumbnail: 'case.png',
      price: 10.0,
      rating: 4.1,
    ),
    Product(
      id: 2,
      title: 'Charger',
      thumbnail: 'charger.png',
      price: 15.0,
      rating: 4.3,
    ),
  ];

  setUp(() {
    repository = MockProductRepository();
  });

  blocTest<ProductRecommendationCubit, ProductRecommendationState>(
    'getRecommendations emits empty when id is null',
    build: () => ProductRecommendationCubit(repository),
    act: (cubit) => cubit.getRecommendations(),
    expect: () => [
      isA<ProductRecommendationLoading>(),
      isA<ProductRecommendationLoaded>()
          .having((state) => state.products, 'products', isEmpty),
    ],
    verify: (_) => verifyNever(() => repository.getRecommendations(any())),
  );

  blocTest<ProductRecommendationCubit, ProductRecommendationState>(
    'getRecommendations emits loaded on success',
    build: () {
      when(() => repository.getRecommendations(1)).thenReturn(
        TaskEither.right(products),
      );
      return ProductRecommendationCubit(repository);
    },
    act: (cubit) => cubit.getRecommendations(forProductId: 1),
    expect: () => [
      isA<ProductRecommendationLoading>(),
      isA<ProductRecommendationLoaded>()
          .having((state) => state.products.length, 'length', 2),
    ],
  );

  blocTest<ProductRecommendationCubit, ProductRecommendationState>(
    'getRecommendations emits failure on error',
    build: () {
      when(() => repository.getRecommendations(1)).thenReturn(
        TaskEither.left(AppException(message: 'failed')),
      );
      return ProductRecommendationCubit(repository);
    },
    act: (cubit) => cubit.getRecommendations(forProductId: 1),
    expect: () => [
      isA<ProductRecommendationLoading>(),
      isA<ProductRecommendationFailure>(),
    ],
  );
}
