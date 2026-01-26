import 'package:flutly_store/app/core/local_storage/local_storage.dart';
import 'package:flutly_store/app/features/search/constants/search_constants.dart';
import 'package:flutly_store/app/features/search/data/data_sources/local/search_local_data_source_impl.dart';
import 'package:flutly_store/app/features/search/data/models/search_terms_history_model.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../../utils/test_utils.dart';

class MockCoreLocalStorage extends Mock implements CoreLocalStorage {}

class MockLocalStorageProvider extends Mock implements LocalStorageProvider {}

void main() {
  late CoreLocalStorage localStorage;
  late LocalStorageProvider storage;
  late SearchLocalDataSourceImpl dataSource;

  setUpAll(() async {
    await TestUtils.setUpLocalization();
    registerFallbackValue(const SearchTermsHistoryModel(terms: []));
  });

  setUp(() {
    localStorage = MockCoreLocalStorage();
    storage = MockLocalStorageProvider();
    dataSource = SearchLocalDataSourceImpl(localStorage);

    when(() => localStorage.storage).thenReturn(storage);
  });

  test('saveSearchTerm inserts term and caps length', () async {
    const existing = SearchTermsHistoryModel(
      terms: ['case', 'charger', 'cable', 'adapter'],
    );

    when(
      () => storage.get<SearchTermsHistoryModel>(
        SearchConstants.searchHistoryKey,
        SearchTermsHistoryModel.fromJson,
      ),
    ).thenAnswer((_) async => existing);
    when(
      () => storage.set(
        SearchConstants.searchHistoryKey,
        any(),
      ),
    ).thenAnswer((_) async {});

    final result = await dataSource.saveSearchTerm('  phone ').run();

    expect(result.isRight(), isTrue);

    final captured =
        verify(
              () => storage.set(
                SearchConstants.searchHistoryKey,
                captureAny(),
              ),
            ).captured.single
            as SearchTermsHistoryModel;

    expect(captured.terms, ['phone', 'case', 'charger', 'cable']);
  });

  test('removeSearchTerm removes term and persists', () async {
    const existing = SearchTermsHistoryModel(
      terms: ['case', 'charger', 'cable'],
    );

    when(
      () => storage.get<SearchTermsHistoryModel>(
        SearchConstants.searchHistoryKey,
        SearchTermsHistoryModel.fromJson,
      ),
    ).thenAnswer((_) async => existing);
    when(
      () => storage.set(
        SearchConstants.searchHistoryKey,
        any(),
      ),
    ).thenAnswer((_) async {});

    final result = await dataSource.removeSearchTerm('charger').run();

    expect(result.isRight(), isTrue);

    final captured =
        verify(
              () => storage.set(
                SearchConstants.searchHistoryKey,
                captureAny(),
              ),
            ).captured.single
            as SearchTermsHistoryModel;
    expect(captured.terms, ['case', 'cable']);
  });

  test('getSearchTerms returns Some when data exists', () async {
    const existing = SearchTermsHistoryModel(terms: ['case']);

    when(
      () => storage.get<SearchTermsHistoryModel>(
        SearchConstants.searchHistoryKey,
        SearchTermsHistoryModel.fromJson,
      ),
    ).thenAnswer((_) async => existing);

    final result = await dataSource.getSearchTerms().run();

    expect(result.isRight(), isTrue);
    result.match(
      (_) => fail('Expected terms'),
      (value) {
        expect(value.isSome(), isTrue);
        expect(value.toNullable()!.terms, ['case']);
      },
    );
  });

  test('getSearchTerms returns None when data is missing', () async {
    when(
      () => storage.get<SearchTermsHistoryModel>(
        SearchConstants.searchHistoryKey,
        SearchTermsHistoryModel.fromJson,
      ),
    ).thenAnswer((_) async => null);

    final result = await dataSource.getSearchTerms().run();

    expect(result.isRight(), isTrue);
    result.match(
      (_) => fail('Expected none'),
      (value) => expect(value, isA<None>()),
    );
  });
}
