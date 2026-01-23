import 'package:bloc_test/bloc_test.dart';
import 'package:flutly_store/app/features/product/domain/entities/product_extended.dart';
import 'package:flutly_store/app/features/product/domain/repositories/product_repository.dart';
import 'package:flutly_store/app/features/product/presentation/bloc/product/product_cubit.dart';
import 'package:flutly_store/app/shared/errors/app_exception.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../../../utils/test_utils.dart';

class MockProductRepository extends Mock implements ProductRepository {}

void main() {
  late ProductRepository repository;

  final product = ProductExtended(
    id: 1,
    title: 'Phone',
    thumbnail: 'thumb.png',
    price: 199.0,
    rating: 4.5,
    description: 'A phone',
    brand: 'Brand',
    images: const ['img.png'],
    discountPercentage: 10.0,
  );

  setUpAll(() async {
    await TestUtils.setUpLocalization();
  });

  setUp(() {
    repository = MockProductRepository();
  });

  blocTest<ProductCubit, ProductState>(
    'getProductById emits failure when id is null',
    build: () => ProductCubit(repository),
    act: (cubit) => cubit.getProductById(null),
    expect: () => [
      isA<ProductFailure>().having(
        (state) => state.exception.message,
        'message',
        isNotEmpty,
      ),
    ],
    verify: (_) => verifyNever(() => repository.getProductById(any())),
  );

  blocTest<ProductCubit, ProductState>(
    'getProductById emits loading then loaded on success',
    build: () {
      when(() => repository.getProductById(1)).thenReturn(
        TaskEither.right(product),
      );
      return ProductCubit(repository);
    },
    act: (cubit) => cubit.getProductById(1),
    wait: const Duration(milliseconds: 350),
    expect: () => [
      isA<ProductLoading>(),
      isA<ProductLoaded>().having(
        (state) => state.product.id,
        'id',
        1,
      ),
    ],
  );

  blocTest<ProductCubit, ProductState>(
    'getProductById emits loading then failure on error',
    build: () {
      when(() => repository.getProductById(1)).thenReturn(
        TaskEither.left(AppException(message: 'failed')),
      );
      return ProductCubit(repository);
    },
    act: (cubit) => cubit.getProductById(1),
    wait: const Duration(milliseconds: 350),
    expect: () => [
      isA<ProductLoading>(),
      isA<ProductFailure>(),
    ],
  );
}
