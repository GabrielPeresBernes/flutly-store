import 'package:flutly_store/app/core/http/http.dart';
import 'package:flutly_store/app/features/catalog/data/models/product_model.dart';
import 'package:flutly_store/app/features/product/data/data_sources/product_remote_data_source_impl.dart';
import 'package:flutly_store/app/features/product/data/models/product_extended_model.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockCoreHttp extends Mock implements CoreHttp {}

void main() {
  late CoreHttp httpClient;
  late ProductRemoteDataSourceImpl dataSource;

  setUp(() {
    httpClient = MockCoreHttp();
    dataSource = ProductRemoteDataSourceImpl(httpClient);
  });

  test('getProductById returns decoded product and forwards id', () async {
    const product = ProductExtendedModel(
      id: 42,
      title: 'Phone',
      thumbnail: 'thumb.png',
      price: 199.0,
      description: 'A phone',
      category: 'mobile-accessories',
      brand: 'Brand',
      images: ['img.png'],
      discountPercentage: 5.0,
      rating: 4.2,
    );

    when(
      () => httpClient.get<ProductExtendedModel>(
        any(),
        decoder: ProductExtendedModel.fromJson,
      ),
    ).thenAnswer((_) async => product);

    final result = await dataSource.getProductById(42).run();

    expect(result.isRight(), isTrue);
    result.match(
      (_) => fail('Expected product'),
      (value) => expect(value.id, 42),
    );

    final captured = verify(
      () => httpClient.get<ProductExtendedModel>(
        captureAny(),
        decoder: ProductExtendedModel.fromJson,
      ),
    ).captured;
    final path = captured.first as String;

    expect(path.endsWith('/42'), isTrue);
  });

  test(
    'getRecommendations filters current product and forwards query',
    () async {
      final products = [
        const ProductModel(
          id: 1,
          title: 'Case',
          thumbnail: 'c.png',
          price: 10.0,
          rating: 4.0,
          category: 'mobile-accessories',
        ),
        const ProductModel(
          id: 2,
          title: 'Charger',
          thumbnail: 'ch.png',
          price: 15.0,
          rating: 4.1,
          category: 'mobile-accessories',
        ),
        const ProductModel(
          id: 3,
          title: 'Cable',
          thumbnail: 'ca.png',
          price: 8.0,
          rating: 4.4,
          category: 'mobile-accessories',
        ),
      ];

      when(
        () => httpClient.get<List<ProductModel>>(
          any(),
          queryParameters: any(named: 'queryParameters'),
          decoder: any(named: 'decoder'),
        ),
      ).thenAnswer((_) async => products);

      final result = await dataSource.getRecommendations(2).run();

      expect(result.isRight(), isTrue);
      result.match(
        (_) => fail('Expected recommendations'),
        (value) {
          expect(value.length, 2);
          expect(value.any((product) => product.id == 2), isFalse);
        },
      );

      final captured = verify(
        () => httpClient.get<List<ProductModel>>(
          captureAny(),
          queryParameters: captureAny(named: 'queryParameters'),
          decoder: any(named: 'decoder'),
        ),
      ).captured;
      final path = captured[0] as String;
      final query = captured[1] as Map<String, dynamic>;

      expect(path.endsWith('/category/mobile-accessories'), isTrue);
      expect(query['limit'], 4);
    },
  );
}
