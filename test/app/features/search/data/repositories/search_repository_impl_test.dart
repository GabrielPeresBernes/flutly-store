import 'package:flutly_store/app/features/catalog/data/models/product_model.dart';
import 'package:flutly_store/app/features/catalog/data/models/products_page_model.dart';
import 'package:flutly_store/app/features/search/data/data_sources/search_local_data_source.dart';
import 'package:flutly_store/app/features/search/data/data_sources/search_remote_data_source.dart';
import 'package:flutly_store/app/features/search/data/models/search_terms_history_model.dart';
import 'package:flutly_store/app/features/search/data/repositories/search_repository_impl.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';

class MockSearchRemoteDataSource extends Mock
    implements SearchRemoteDataSource {}

class MockSearchLocalDataSource extends Mock implements SearchLocalDataSource {}

void main() {
  late SearchRemoteDataSource remoteDataSource;
  late SearchLocalDataSource localDataSource;
  late SearchRepositoryImpl repository;

  setUp(() {
    remoteDataSource = MockSearchRemoteDataSource();
    localDataSource = MockSearchLocalDataSource();
    repository = SearchRepositoryImpl(remoteDataSource, localDataSource);
  });

  test('getPopularProducts maps models to entities', () async {
    final response = ProductsPageModel(
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

    when(() => remoteDataSource.getPopularProducts()).thenReturn(
      TaskEither.right(response),
    );

    final result = await repository.getPopularProducts().run();

    expect(result.isRight(), isTrue);
    result.match(
      (_) => fail('Expected products'),
      (value) {
        expect(value.length, 1);
        expect(value.first.id, 1);
        expect(value.first.title, 'Case');
      },
    );
  });

  test('getSearchHistory returns empty list when missing', () async {
    when(() => localDataSource.getSearchTerms()).thenReturn(
      TaskEither.right(none()),
    );

    final result = await repository.getSearchHistory().run();

    expect(result.isRight(), isTrue);
    result.match(
      (_) => fail('Expected terms'),
      (value) => expect(value, isEmpty),
    );
  });

  test('saveSearchTerm maps history to terms', () async {
    final history = SearchTermsHistoryModel(terms: ['case', 'charger']);

    when(() => localDataSource.saveSearchTerm('case')).thenReturn(
      TaskEither.right(history),
    );

    final result = await repository.saveSearchTerm('case').run();

    expect(result.isRight(), isTrue);
    result.match(
      (_) => fail('Expected terms'),
      (value) => expect(value, history.terms),
    );
  });

  test('removeSearchTerm maps history to terms', () async {
    final history = SearchTermsHistoryModel(terms: ['case']);

    when(() => localDataSource.removeSearchTerm('charger')).thenReturn(
      TaskEither.right(history),
    );

    final result = await repository.removeSearchTerm('charger').run();

    expect(result.isRight(), isTrue);
    result.match(
      (_) => fail('Expected terms'),
      (value) => expect(value, history.terms),
    );
  });
}
