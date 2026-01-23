import '../../../../shared/types/response_type.dart';
import '../../../product/domain/entities/product.dart';
import '../../domain/repositories/search_repository.dart';
import '../data_sources/search_local_data_source.dart';
import '../data_sources/search_remote_data_source.dart';

class SearchRepositoryImpl implements SearchRepository {
  const SearchRepositoryImpl(
    this._remoteDataSource,
    this._localDataSource,
  );

  final SearchRemoteDataSource _remoteDataSource;
  final SearchLocalDataSource _localDataSource;

  @override
  TaskResponse<List<Product>> getPopularProducts() {
    return _remoteDataSource.getPopularProducts().map(
      (productsPageModel) => productsPageModel.products
          .map((product) => product.toEntity())
          .toList(),
    );
  }

  @override
  TaskResponse<List<String>> getSearchHistory() {
    return _localDataSource.getSearchTerms().map(
      (searchTermsHistoryModel) => searchTermsHistoryModel.match(
        () => [],
        (searchTermsHistory) => searchTermsHistory.terms,
      ),
    );
  }

  @override
  TaskResponse<List<String>> saveSearchTerm(String term) {
    return _localDataSource
        .saveSearchTerm(term)
        .map((searchTermsHistoryModel) => searchTermsHistoryModel.terms);
  }

  @override
  TaskResponse<List<String>> removeSearchTerm(String term) {
    return _localDataSource
        .removeSearchTerm(term)
        .map((searchTermsHistoryModel) => searchTermsHistoryModel.terms);
  }
}
