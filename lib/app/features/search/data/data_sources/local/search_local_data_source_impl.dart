import 'package:easy_localization/easy_localization.dart';
import 'package:fpdart/fpdart.dart';

import '../../../../../core/local_storage/local_storage.dart';
import '../../../../../shared/types/response_type.dart';
import '../../../../../shared/utils/task_utils.dart';
import '../../../constants/search_constants.dart';
import '../../models/search_terms_history_model.dart';
import 'search_local_data_source.dart';

class SearchLocalDataSourceImpl implements SearchLocalDataSource {
  const SearchLocalDataSourceImpl(this._localStorage);

  final CoreLocalStorage _localStorage;

  static const int _maxLength = 4;

  @override
  TaskResponse<SearchTermsHistoryModel> saveSearchTerm(String term) => task(
    () async {
      final terms = List<String>.from((await _getSavedTerms())?.terms ?? []);

      _saveNewTerm(term, terms);

      final searchTermsHistory = SearchTermsHistoryModel(terms: terms);

      await _localStorage.storage.set(
        SearchConstants.searchHistoryKey,
        searchTermsHistory,
      );

      return searchTermsHistory;
    },
    (_) => tr('search.errors.save_term_failed'),
  );

  @override
  TaskResponse<SearchTermsHistoryModel> removeSearchTerm(String term) => task(
    () async {
      final terms = List<String>.from((await _getSavedTerms())?.terms ?? [])
        ..remove(term);

      final searchTermsHistory = SearchTermsHistoryModel(terms: terms);

      await _localStorage.storage.set(
        SearchConstants.searchHistoryKey,
        searchTermsHistory,
      );

      return searchTermsHistory;
    },
    (_) => tr('search.errors.remove_term_failed'),
  );

  @override
  TaskResponse<Option<SearchTermsHistoryModel>> getSearchTerms() => task(
    () async {
      final searchTermsHistory = await _getSavedTerms();
      return Option.fromNullable(searchTermsHistory);
    },
    (_) => tr('search.errors.get_terms_failed'),
  );

  void _saveNewTerm(String newTerm, List<String> terms) {
    newTerm = newTerm.trim();

    if (newTerm.isEmpty) {
      return;
    }

    terms
      ..remove(newTerm)
      ..insert(0, newTerm);

    if (terms.length > _maxLength) {
      terms.removeLast();
    }
  }

  Future<SearchTermsHistoryModel?> _getSavedTerms() async =>
      _localStorage.storage.get(
        SearchConstants.searchHistoryKey,
        SearchTermsHistoryModel.fromJson,
      );
}
