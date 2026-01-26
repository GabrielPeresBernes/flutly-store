import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../shared/errors/app_exception.dart';
import '../../../domain/repositories/search_repository.dart';

part 'search_history_state.dart';

class SearchHistoryCubit extends Cubit<SearchHistoryState> {
  SearchHistoryCubit(this._searchRepository)
    : super(const SearchHistoryInitial());

  final SearchRepository _searchRepository;

  Future<void> getSearchHistory() async {
    emit(const SearchHistoryLoading());

    final result = await _searchRepository.getSearchHistory().run();

    result.fold(
      (exception) => emit(SearchHistoryFailure(exception: exception)),
      (terms) => emit(SearchHistoryLoaded(terms)),
    );
  }

  Future<void> saveSearchTerm(String term) async {
    emit(const SearchHistoryUpdateLoading());

    final result = await _searchRepository.saveSearchTerm(term).run();

    result.fold(
      (exception) => emit(SearchHistoryUpdateFailure(exception: exception)),
      (terms) => emit(SearchHistoryLoaded(terms)),
    );
  }

  Future<void> removeSearchTerm(String term) async {
    emit(const SearchHistoryUpdateLoading());

    final result = await _searchRepository.removeSearchTerm(term).run();

    result.fold(
      (exception) => emit(SearchHistoryUpdateFailure(exception: exception)),
      (terms) => emit(SearchHistoryRemoved(terms, term)),
    );
  }
}
