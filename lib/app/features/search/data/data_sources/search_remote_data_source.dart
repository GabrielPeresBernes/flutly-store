import '../../../../shared/types/response_type.dart';
import '../../../catalog/data/models/products_page_model.dart';

abstract interface class SearchRemoteDataSource {
  TaskResponse<ProductsPageModel> getPopularProducts();
}
