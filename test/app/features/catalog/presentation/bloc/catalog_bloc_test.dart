import 'package:bloc_test/bloc_test.dart';
import 'package:flutly_store/app/features/catalog/domain/entities/product_filters.dart';
import 'package:flutly_store/app/features/catalog/domain/entities/products_page.dart';
import 'package:flutly_store/app/features/catalog/domain/repositories/catalog_repository.dart';
import 'package:flutly_store/app/features/catalog/presentation/bloc/catalog_bloc.dart';
import 'package:flutly_store/app/features/product/domain/entities/product.dart';
import 'package:flutly_store/app/shared/errors/app_exception.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:mocktail/mocktail.dart';

class MockCatalogRepository extends Mock implements CatalogRepository {}

void main() {
  late CatalogRepository repository;

  final products = [
    const Product(
      id: 1,
      title: 'Phone Case',
      thumbnail: 'case.png',
      price: 12.5,
      rating: 4.6,
    ),
  ];

  setUp(() {
    repository = MockCatalogRepository();
  });

  blocTest<CatalogBloc, PagingState<int, Product>>(
    'emits loading then page when reset is true',
    build: () {
      when(
        () => repository.getProducts(any(), any(), any(), any()),
      ).thenReturn(
        TaskEither.right(
          ProductsPage(products: products, total: 1, skip: 0, limit: 6),
        ),
      );
      return CatalogBloc(repository);
    },
    act: (bloc) => bloc.add(
      const CatalogGetProducts(
        searchTerm: 'case',
        filters: ProductFilters(sortBy: 'price', order: 'asc'),
        reset: true,
      ),
    ),
    wait: throttleDuration,
    expect: () => [
      isA<PagingState<int, Product>>().having(
        (state) => state.isLoading,
        'isLoading',
        true,
      ),
      isA<PagingState<int, Product>>()
          .having((state) => state.pages?.length, 'pages', 1)
          .having((state) => state.keys?.length, 'keys', 1)
          .having((state) => state.hasNextPage, 'hasNextPage', true)
          .having((state) => state.isLoading, 'isLoading', false),
    ],
    verify: (_) {
      final captured = verify(
        () => repository.getProducts(6, 0, 'case', captureAny()),
      ).captured;
      final filters = captured.single as ProductFilters?;
      expect(filters?.sortBy, 'price');
      expect(filters?.order, 'asc');
    },
  );

  blocTest<CatalogBloc, PagingState<int, Product>>(
    'emits error when repository fails',
    build: () {
      when(
        () => repository.getProducts(any(), any(), any(), any()),
      ).thenReturn(
        TaskEither.left(AppException(message: 'fetch failed')),
      );
      return CatalogBloc(repository);
    },
    act: (bloc) => bloc.add(const CatalogGetProducts()),
    wait: throttleDuration,
    expect: () => [
      isA<PagingState<int, Product>>().having(
        (state) => state.isLoading,
        'isLoading',
        true,
      ),
      isA<PagingState<int, Product>>()
          .having((state) => state.error, 'error', isA<AppException>())
          .having((state) => state.isLoading, 'isLoading', false),
    ],
  );

  blocTest<CatalogBloc, PagingState<int, Product>>(
    'appends pages and uses next skip for pagination',
    build: () {
      when(
        () => repository.getProducts(any(), any(), any(), any()),
      ).thenAnswer((invocation) {
        final skip = invocation.positionalArguments[1] as int;
        if (skip == 0) {
          return TaskEither.right(
            ProductsPage(products: products, total: 1, skip: 0, limit: 6),
          );
        }
        return TaskEither.right(
          const ProductsPage(products: [], total: 0, skip: 6, limit: 6),
        );
      });
      return CatalogBloc(repository);
    },
    act: (bloc) async {
      bloc.add(const CatalogGetProducts());
      await Future<void>.delayed(
        Duration(milliseconds: throttleDuration.inMilliseconds * 2),
      );
      bloc.add(const CatalogGetProducts());
    },
    wait: Duration(milliseconds: throttleDuration.inMilliseconds * 2),
    expect: () => [
      isA<PagingStateBase<int, Product>>().having(
        (state) => state.isLoading,
        'isLoading',
        true,
      ),
      isA<PagingStateBase<int, Product>>()
          .having((state) => state.pages?.length, 'pages', 1)
          .having((state) => state.hasNextPage, 'hasNextPage', true)
          .having((state) => state.isLoading, 'isLoading', false),
      isA<PagingStateBase<int, Product>>().having(
        (state) => state.isLoading,
        'isLoading',
        true,
      ),
      isA<PagingStateBase<int, Product>>()
          .having((state) => state.pages?.length, 'pages', 2)
          .having((state) => state.hasNextPage, 'hasNextPage', false)
          .having((state) => state.isLoading, 'isLoading', false),
    ],
    verify: (_) {
      verify(() => repository.getProducts(6, 0, null, null)).called(1);
      verify(() => repository.getProducts(6, 6, null, null)).called(1);
    },
  );
}
