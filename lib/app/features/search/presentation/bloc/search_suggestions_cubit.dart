import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../shared/errors/app_exception.dart';

part 'search_suggestions_state.dart';

class SearchSuggestionsCubit extends Cubit<SearchSuggestionsState> {
  SearchSuggestionsCubit() : super(const SearchSuggestionsInitial());

  static const List<String> _suggestionKeys = [
    'search.suggestions.amazon',
    'search.suggestions.apple',
    'search.suggestions.beats',
    'search.suggestions.monopod',
    'search.suggestions.iphone',
    'search.suggestions.pedestal',
    'search.suggestions.selfie_stick',
    'search.suggestions.case',
    'search.suggestions.watch',
    'search.suggestions.airpods',
  ];

  List<String> get allTerms => _suggestionKeys.map((key) => key.tr()).toList();

  List<String> filteredTerms = [];

  Future<void> getSuggestions(String query) async {
    if (query.isEmpty) {
      emit(const SearchSuggestionsReset());
      return;
    }

    emit(const SearchSuggestionsLoading());

    try {
      await Future<void>.delayed(const Duration(milliseconds: 200));

      if (query.isEmpty) {
        filteredTerms = [];
      } else {
        filteredTerms = allTerms
            .where(
              (term) => term.toLowerCase().contains(query.toLowerCase()),
            )
            .toList();
      }

      emit(SearchSuggestionsLoaded(filteredTerms));
    } catch (exception) {
      emit(
        SearchSuggestionsFailure(
          exception: AppException(
            message: tr('search.errors.suggestions_failed'),
            details: Exception(exception.toString()),
          ),
        ),
      );
    }
  }
}
