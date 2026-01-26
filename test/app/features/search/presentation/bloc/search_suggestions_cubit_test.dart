import 'package:bloc_test/bloc_test.dart';
import 'package:flutly_store/app/features/search/presentation/bloc/suggestions/search_suggestions_cubit.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../../../utils/test_utils.dart';

void main() {
  setUpAll(() async {
    await TestUtils.setUpLocalization();
  });

  blocTest<SearchSuggestionsCubit, SearchSuggestionsState>(
    'getSuggestions emits reset when query is empty',
    build: SearchSuggestionsCubit.new,
    act: (cubit) => cubit.getSuggestions(''),
    expect: () => [
      isA<SearchSuggestionsReset>(),
    ],
  );

  blocTest<SearchSuggestionsCubit, SearchSuggestionsState>(
    'getSuggestions emits loaded with filtered suggestions',
    build: SearchSuggestionsCubit.new,
    act: (cubit) => cubit.getSuggestions('ca'),
    wait: const Duration(milliseconds: 250),
    expect: () => [
      isA<SearchSuggestionsLoading>(),
      isA<SearchSuggestionsLoaded>().having(
        (state) => state.suggestions,
        'suggestions',
        isNotEmpty,
      ),
    ],
  );

  blocTest<SearchSuggestionsCubit, SearchSuggestionsState>(
    'getSuggestions emits empty when no suggestions match',
    build: SearchSuggestionsCubit.new,
    act: (cubit) => cubit.getSuggestions('xyz'),
    wait: const Duration(milliseconds: 250),
    expect: () => [
      isA<SearchSuggestionsLoading>(),
      isA<SearchSuggestionsLoaded>().having(
        (state) => state.suggestions,
        'suggestions',
        isEmpty,
      ),
    ],
  );
}
