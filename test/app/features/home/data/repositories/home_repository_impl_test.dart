import 'package:flutly_store/app/features/home/data/data_sources/home_remote_data_source.dart';
import 'package:flutly_store/app/features/home/data/models/home_product_list_model.dart';
import 'package:flutly_store/app/features/home/data/models/home_product_model.dart';
import 'package:flutly_store/app/features/home/data/repositories/home_repository_impl.dart';
import 'package:flutly_store/app/features/home/domain/entities/home_product_list.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';

class MockHomeRemoteDataSource extends Mock implements HomeRemoteDataSource {}

void main() {
  late HomeRemoteDataSource remoteDataSource;
  late HomeRepositoryImpl repository;

  setUp(() {
    remoteDataSource = MockHomeRemoteDataSource();
    repository = HomeRepositoryImpl(remoteDataSource);
  });

  test('getProducts maps models to entities', () async {
    final model = HomeProductListModel(
      title: 'Highlights',
      variant: HomeProductListType.highlight.type,
      products: [
        const HomeProductModel(
          id: '1',
          title: 'Phone',
          price: 100.0,
          image: 'image.png',
        ),
      ],
    );

    when(() => remoteDataSource.getProducts()).thenReturn(
      TaskEither.right([model]),
    );

    final result = await repository.getProducts().run();

    expect(result.isRight(), isTrue);
    result.match(
      (_) => fail('Expected products'),
      (value) {
        expect(value.length, 1);
        expect(value.first.title, 'Highlights');
        expect(value.first.type, HomeProductListType.highlight);
        expect(value.first.products.first.id, 1);
        expect(value.first.products.first.title, 'Phone');
        expect(value.first.products.first.price, 100.0);
      },
    );

    verify(() => remoteDataSource.getProducts()).called(1);
  });
}
