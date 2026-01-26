part of 'search_suggestions_cubit.dart';

sealed class SearchSuggestionsState {
  const SearchSuggestionsState();
}

final class SearchSuggestionsInitial extends SearchSuggestionsState {
  const SearchSuggestionsInitial();
}

final class SearchSuggestionsLoading extends SearchSuggestionsState {
  const SearchSuggestionsLoading();
}

final class SearchSuggestionsReset extends SearchSuggestionsState {
  const SearchSuggestionsReset();
}

final class SearchSuggestionsLoaded extends SearchSuggestionsState {
  const SearchSuggestionsLoaded(this.suggestions);

  final List<String> suggestions;
}

final class SearchSuggestionsFailure extends SearchSuggestionsState {
  const SearchSuggestionsFailure({required this.exception});

  final AppException exception;
}
