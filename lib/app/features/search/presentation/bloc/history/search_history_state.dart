part of 'search_history_cubit.dart';

sealed class SearchHistoryState {
  const SearchHistoryState();
}

final class SearchHistoryInitial extends SearchHistoryState {
  const SearchHistoryInitial();
}

final class SearchHistoryLoading extends SearchHistoryState {
  const SearchHistoryLoading();
}

final class SearchHistoryUpdateLoading extends SearchHistoryState {
  const SearchHistoryUpdateLoading();
}

final class SearchHistoryLoaded extends SearchHistoryState {
  const SearchHistoryLoaded(this.terms);

  final List<String> terms;
}

final class SearchHistoryRemoved extends SearchHistoryState {
  const SearchHistoryRemoved(this.terms, this.removedTerm);

  final List<String> terms;
  final String removedTerm;
}

final class SearchHistoryFailure extends SearchHistoryState {
  const SearchHistoryFailure({required this.exception});

  final AppException exception;
}

final class SearchHistoryUpdateFailure extends SearchHistoryState {
  const SearchHistoryUpdateFailure({required this.exception});

  final AppException exception;
}
