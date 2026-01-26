import 'package:bloc_test/bloc_test.dart';
import 'package:flutly_store/app/features/search/domain/repositories/search_repository.dart';
import 'package:flutly_store/app/features/search/presentation/bloc/history/search_history_cubit.dart';
import 'package:flutly_store/app/shared/errors/app_exception.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';

class MockSearchRepository extends Mock implements SearchRepository {}

void main() {
  late SearchRepository repository;

  setUp(() {
    repository = MockSearchRepository();
  });

  blocTest<SearchHistoryCubit, SearchHistoryState>(
    'getSearchHistory emits loaded on success',
    build: () {
      when(() => repository.getSearchHistory()).thenReturn(
        TaskEither.right(['case', 'charger']),
      );
      return SearchHistoryCubit(repository);
    },
    act: (cubit) => cubit.getSearchHistory(),
    expect: () => [
      isA<SearchHistoryLoading>(),
      isA<SearchHistoryLoaded>().having(
        (state) => state.terms.length,
        'length',
        2,
      ),
    ],
  );

  blocTest<SearchHistoryCubit, SearchHistoryState>(
    'getSearchHistory emits failure on error',
    build: () {
      when(() => repository.getSearchHistory()).thenReturn(
        TaskEither.left(AppException(message: 'failed')),
      );
      return SearchHistoryCubit(repository);
    },
    act: (cubit) => cubit.getSearchHistory(),
    expect: () => [
      isA<SearchHistoryLoading>(),
      isA<SearchHistoryFailure>(),
    ],
  );

  blocTest<SearchHistoryCubit, SearchHistoryState>(
    'saveSearchTerm emits loaded on success',
    build: () {
      when(() => repository.saveSearchTerm('case')).thenReturn(
        TaskEither.right(['case']),
      );
      return SearchHistoryCubit(repository);
    },
    act: (cubit) => cubit.saveSearchTerm('case'),
    expect: () => [
      isA<SearchHistoryUpdateLoading>(),
      isA<SearchHistoryLoaded>().having(
        (state) => state.terms.first,
        'term',
        'case',
      ),
    ],
  );

  blocTest<SearchHistoryCubit, SearchHistoryState>(
    'saveSearchTerm emits failure on error',
    build: () {
      when(() => repository.saveSearchTerm('case')).thenReturn(
        TaskEither.left(AppException(message: 'failed')),
      );
      return SearchHistoryCubit(repository);
    },
    act: (cubit) => cubit.saveSearchTerm('case'),
    expect: () => [
      isA<SearchHistoryUpdateLoading>(),
      isA<SearchHistoryUpdateFailure>(),
    ],
  );

  blocTest<SearchHistoryCubit, SearchHistoryState>(
    'removeSearchTerm emits removed on success',
    build: () {
      when(() => repository.removeSearchTerm('case')).thenReturn(
        TaskEither.right(['charger']),
      );
      return SearchHistoryCubit(repository);
    },
    act: (cubit) => cubit.removeSearchTerm('case'),
    expect: () => [
      isA<SearchHistoryUpdateLoading>(),
      isA<SearchHistoryRemoved>().having(
        (state) => state.removedTerm,
        'removedTerm',
        'case',
      ),
    ],
  );

  blocTest<SearchHistoryCubit, SearchHistoryState>(
    'removeSearchTerm emits failure on error',
    build: () {
      when(() => repository.removeSearchTerm('case')).thenReturn(
        TaskEither.left(AppException(message: 'failed')),
      );
      return SearchHistoryCubit(repository);
    },
    act: (cubit) => cubit.removeSearchTerm('case'),
    expect: () => [
      isA<SearchHistoryUpdateLoading>(),
      isA<SearchHistoryUpdateFailure>(),
    ],
  );
}
