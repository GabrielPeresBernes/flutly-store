import '../../../../shared/types/response_type.dart';
import '../../../product/domain/entities/product.dart';

abstract interface class SearchRepository {
  TaskResponse<List<Product>> getPopularProducts();

  TaskResponse<List<String>> getSearchHistory();

  TaskResponse<List<String>> saveSearchTerm(String term);

  TaskResponse<List<String>> removeSearchTerm(String term);
}
