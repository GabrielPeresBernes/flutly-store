import 'package:flutly_store/app/features/catalog/data/models/product_model.dart';
import 'package:flutly_store/app/features/product/data/data_sources/product_remote_data_source.dart';
import 'package:flutly_store/app/features/product/data/models/product_extended_model.dart';
import 'package:flutly_store/app/features/product/data/repositories/product_repository_impl.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';

class MockProductRemoteDataSource extends Mock
    implements ProductRemoteDataSource {}

void main() {
  late ProductRemoteDataSource remoteDataSource;
  late ProductRepositoryImpl repository;

  setUp(() {
    remoteDataSource = MockProductRemoteDataSource();
    repository = ProductRepositoryImpl(remoteDataSource);
  });

  test('getProductById maps model to entity and forwards id', () async {
    const model = ProductExtendedModel(
      id: 7,
      title: 'Phone',
      thumbnail: 'thumb.png',
      price: 199.0,
      description: 'A phone',
      category: 'mobile-accessories',
      brand: 'Brand',
      images: ['img.png'],
      discountPercentage: 12.0,
      rating: 4.6,
    );

    when(() => remoteDataSource.getProductById(7)).thenReturn(
      TaskEither.right(model),
    );

    final result = await repository.getProductById(7).run();

    expect(result.isRight(), isTrue);
    result.match(
      (_) => fail('Expected product'),
      (value) {
        expect(value.id, 7);
        expect(value.title, 'Phone');
        expect(value.brand, 'Brand');
        expect(value.images.length, 1);
        expect(value.discountPercentage, 12.0);
      },
    );
    verify(() => remoteDataSource.getProductById(7)).called(1);
  });

  test('getRecommendations maps models to entities and forwards id', () async {
    final models = [
      const ProductModel(
        id: 1,
        title: 'Case',
        thumbnail: 'case.png',
        price: 10.0,
        rating: 4.1,
        category: 'mobile-accessories',
      ),
      const ProductModel(
        id: 2,
        title: 'Charger',
        thumbnail: 'charger.png',
        price: 15.0,
        rating: 4.3,
        category: 'mobile-accessories',
      ),
    ];

    when(() => remoteDataSource.getRecommendations(1)).thenReturn(
      TaskEither.right(models),
    );

    final result = await repository.getRecommendations(1).run();

    expect(result.isRight(), isTrue);
    result.match(
      (_) => fail('Expected recommendations'),
      (value) {
        expect(value.length, 2);
        expect(value.first.id, 1);
        expect(value.first.title, 'Case');
        expect(value.last.rating, 4.3);
      },
    );
    verify(() => remoteDataSource.getRecommendations(1)).called(1);
  });
}
