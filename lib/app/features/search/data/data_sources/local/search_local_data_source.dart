import 'package:fpdart/fpdart.dart';

import '../../../../../shared/types/response_type.dart';
import '../../models/search_terms_history_model.dart';

abstract interface class SearchLocalDataSource {
  TaskResponse<SearchTermsHistoryModel> saveSearchTerm(String term);

  TaskResponse<SearchTermsHistoryModel> removeSearchTerm(String term);

  TaskResponse<Option<SearchTermsHistoryModel>> getSearchTerms();
}
