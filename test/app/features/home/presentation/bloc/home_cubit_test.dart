import 'package:bloc_test/bloc_test.dart';
import 'package:flutly_store/app/features/home/domain/entities/home_product.dart';
import 'package:flutly_store/app/features/home/domain/entities/home_product_list.dart';
import 'package:flutly_store/app/features/home/domain/repositories/home_repository.dart';
import 'package:flutly_store/app/features/home/presentation/bloc/home_cubit.dart';
import 'package:flutly_store/app/shared/errors/app_exception.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';

class MockHomeRepository extends Mock implements HomeRepository {}

void main() {
  late HomeRepository repository;

  final productLists = [
    const HomeProductList(
      title: 'Highlights',
      products: [
        HomeProduct(
          id: 1,
          title: 'Phone',
          image: 'image.png',
          price: 100.0,
        ),
      ],
      type: HomeProductListType.highlight,
    ),
  ];

  setUp(() {
    repository = MockHomeRepository();
  });

  blocTest<HomeCubit, HomeState>(
    'getProducts emits loaded on success',
    build: () {
      when(() => repository.getProducts()).thenReturn(
        TaskEither.right(productLists),
      );
      return HomeCubit(repository);
    },
    act: (cubit) => cubit.getProducts(),
    expect: () => [
      isA<HomeLoading>(),
      isA<HomeLoaded>()
          .having((state) => state.productLists.length, 'length', 1)
          .having((state) => state.productLists.first.title, 'title', 'Highlights'),
    ],
  );

  blocTest<HomeCubit, HomeState>(
    'getProducts emits failure on error',
    build: () {
      when(() => repository.getProducts()).thenReturn(
        TaskEither.left(AppException(message: 'fetch failed')),
      );
      return HomeCubit(repository);
    },
    act: (cubit) => cubit.getProducts(),
    expect: () => [
      isA<HomeLoading>(),
      isA<HomeFailure>(),
    ],
  );
}
