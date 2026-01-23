import 'package:flutly_store/app/features/catalog/data/data_sources/catalog_remote_data_source.dart';
import 'package:flutly_store/app/features/catalog/data/models/product_model.dart';
import 'package:flutly_store/app/features/catalog/data/models/products_page_model.dart';
import 'package:flutly_store/app/features/catalog/data/repositories/catalog_repository_impl.dart';
import 'package:flutly_store/app/features/catalog/domain/entities/product_filters.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';

class MockCatalogRemoteDataSource extends Mock
    implements CatalogRemoteDataSource {}

void main() {
  late CatalogRemoteDataSource remoteDataSource;
  late CatalogRepositoryImpl repository;

  setUp(() {
    remoteDataSource = MockCatalogRemoteDataSource();
    repository = CatalogRepositoryImpl(remoteDataSource);
  });

  test('getProducts maps model to entity and forwards params', () async {
    final model = ProductsPageModel(
      products: [
        ProductModel(
          id: 1,
          title: 'Phone Case',
          thumbnail: 'case.png',
          price: 12.5,
          rating: 4.6,
          category: 'mobile-accessories',
        ),
      ],
      total: 1,
      skip: 20,
      limit: 10,
    );

    const limit = 10;
    const skip = 20;
    const searchTerm = 'case';
    final filters = ProductFilters(sortBy: 'price', order: 'asc');

    when(
      () => remoteDataSource.getProducts(
        limit,
        skip,
        searchTerm,
        filters,
      ),
    ).thenReturn(TaskEither.right(model));

    final result =
        await repository.getProducts(limit, skip, searchTerm, filters).run();

    expect(result.isRight(), isTrue);
    result.match(
      (_) => fail('Expected products'),
      (value) {
        expect(value.products.length, 1);
        expect(value.total, 1);
        expect(value.skip, 20);
        expect(value.limit, 10);
        expect(value.products.first.id, 1);
        expect(value.products.first.title, 'Phone Case');
        expect(value.products.first.thumbnail, 'case.png');
        expect(value.products.first.price, 12.5);
        expect(value.products.first.rating, 4.6);
      },
    );

    verify(
      () => remoteDataSource.getProducts(
        limit,
        skip,
        searchTerm,
        filters,
      ),
    ).called(1);
  });
}
