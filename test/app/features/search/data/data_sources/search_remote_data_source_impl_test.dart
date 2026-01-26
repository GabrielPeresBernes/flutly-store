import 'package:flutly_store/app/core/http/http.dart';
import 'package:flutly_store/app/features/catalog/data/models/product_model.dart';
import 'package:flutly_store/app/features/catalog/data/models/products_page_model.dart';
import 'package:flutly_store/app/features/search/data/data_sources/remote/search_remote_data_source_impl.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../../utils/test_utils.dart';

class MockCoreHttp extends Mock implements CoreHttp {}

void main() {
  late CoreHttp httpClient;
  late SearchRemoteDataSourceImpl dataSource;

  setUpAll(() async {
    await TestUtils.setUpLocalization();
  });

  setUp(() {
    httpClient = MockCoreHttp();
    dataSource = SearchRemoteDataSourceImpl(httpClient);
  });

  test('getPopularProducts forwards query and decodes page', () async {
    const response = ProductsPageModel(
      products: [
        ProductModel(
          id: 1,
          title: 'Case',
          thumbnail: 'case.png',
          price: 10.0,
          rating: 4.5,
          category: 'mobile-accessories',
        ),
      ],
      total: 1,
      skip: 0,
      limit: 3,
    );

    when(
      () => httpClient.get<ProductsPageModel>(
        any(),
        queryParameters: any(named: 'queryParameters'),
        decoder: ProductsPageModel.fromJson,
      ),
    ).thenAnswer((_) async => response);

    final result = await dataSource.getPopularProducts().run();

    expect(result.isRight(), isTrue);
    result.match(
      (_) => fail('Expected products'),
      (value) {
        expect(value.products.length, 1);
        expect(value.limit, 3);
      },
    );

    final captured = verify(
      () => httpClient.get<ProductsPageModel>(
        captureAny(),
        queryParameters: captureAny(named: 'queryParameters'),
        decoder: ProductsPageModel.fromJson,
      ),
    ).captured;
    final path = captured[0] as String;
    final query = captured[1] as Map<String, dynamic>;

    expect(path.endsWith('/category/mobile-accessories'), isTrue);
    expect(query['skip'], 0);
    expect(query['limit'], 3);
    expect(query['sortBy'], 'rating');
    expect(query['order'], 'desc');
  });

  test('getPopularProducts returns error when request fails', () async {
    when(
      () => httpClient.get<ProductsPageModel>(
        any(),
        queryParameters: any(named: 'queryParameters'),
        decoder: ProductsPageModel.fromJson,
      ),
    ).thenThrow(Exception('failed'));

    final result = await dataSource.getPopularProducts().run();

    expect(result.isLeft(), isTrue);
    result.match(
      (error) => expect(error.message, 'search.errors.popular_products_failed'),
      (_) => fail('Expected error'),
    );
  });
}
