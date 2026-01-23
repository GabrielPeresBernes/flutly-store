import 'package:flutly_store/app/core/http/http.dart';
import 'package:flutly_store/app/features/catalog/data/data_sources/catalog_remote_data_source_impl.dart';
import 'package:flutly_store/app/features/catalog/data/models/product_model.dart';
import 'package:flutly_store/app/features/catalog/data/models/products_page_model.dart';
import 'package:flutly_store/app/features/catalog/domain/entities/product_filters.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockCoreHttp extends Mock implements CoreHttp {}

void main() {
  late CoreHttp httpClient;
  late CatalogRemoteDataSourceImpl dataSource;

  setUp(() {
    httpClient = MockCoreHttp();
    dataSource = CatalogRemoteDataSourceImpl(httpClient);
  });

  test('getProducts applies price filters and uses category endpoint', () async {
    final response = ProductsPageModel(
      products: [
        ProductModel(
          id: 1,
          title: 'Cheap',
          thumbnail: 'cheap.png',
          price: 40.0,
          rating: 4.5,
          category: 'mobile-accessories',
        ),
        ProductModel(
          id: 2,
          title: 'Mid',
          thumbnail: 'mid.png',
          price: 100.0,
          rating: 4.0,
          category: 'mobile-accessories',
        ),
      ],
      total: 2,
      skip: 0,
      limit: 10,
    );

    when(
      () => httpClient.get<ProductsPageModel>(
        any(),
        decoder: ProductsPageModel.fromJson,
        queryParameters: any(named: 'queryParameters'),
      ),
    ).thenAnswer((_) async => response);

    final filters = ProductFilters(
      sortBy: 'price',
      order: 'asc',
      minPrice: 50.0,
      maxPrice: 120.0,
    );

    final result = await dataSource.getProducts(10, 0, null, filters).run();

    expect(result.isRight(), isTrue);
    result.match(
      (_) => fail('Expected products'),
      (value) {
        expect(value.products.length, 1);
        expect(value.total, 1);
        expect(value.products.first.id, 2);
      },
    );

    final captured = verify(
      () => httpClient.get<ProductsPageModel>(
        captureAny(),
        decoder: ProductsPageModel.fromJson,
        queryParameters: captureAny(named: 'queryParameters'),
      ),
    ).captured;
    final path = captured[0] as String;
    final query = captured[1] as Map<String, dynamic>;

    expect(path.endsWith('/category/mobile-accessories'), isTrue);
    expect(query['limit'], 10);
    expect(query['skip'], 0);
    expect(query['sortBy'], 'price');
    expect(query['order'], 'asc');
    expect(query.containsKey('q'), isFalse);
  });

  test('getProducts filters by category when searching', () async {
    final response = ProductsPageModel(
      products: [
        ProductModel(
          id: 1,
          title: 'Accessory',
          thumbnail: 'a.png',
          price: 20.0,
          rating: 4.2,
          category: 'mobile-accessories',
        ),
        ProductModel(
          id: 2,
          title: 'Laptop',
          thumbnail: 'l.png',
          price: 999.0,
          rating: 4.8,
          category: 'laptops',
        ),
      ],
      total: 2,
      skip: 40,
      limit: 20,
    );

    when(
      () => httpClient.get<ProductsPageModel>(
        any(),
        decoder: ProductsPageModel.fromJson,
        queryParameters: any(named: 'queryParameters'),
      ),
    ).thenAnswer((_) async => response);

    final result =
        await dataSource.getProducts(20, 40, 'phone', null).run();

    expect(result.isRight(), isTrue);
    result.match(
      (_) => fail('Expected products'),
      (value) {
        expect(value.products.length, 1);
        expect(value.total, 1);
        expect(value.products.first.category, 'mobile-accessories');
      },
    );

    final captured = verify(
      () => httpClient.get<ProductsPageModel>(
        captureAny(),
        decoder: ProductsPageModel.fromJson,
        queryParameters: captureAny(named: 'queryParameters'),
      ),
    ).captured;
    final path = captured[0] as String;
    final query = captured[1] as Map<String, dynamic>;

    expect(path.endsWith('/search'), isTrue);
    expect(query['limit'], 20);
    expect(query['skip'], 40);
    expect(query['q'], 'phone');
  });
}
