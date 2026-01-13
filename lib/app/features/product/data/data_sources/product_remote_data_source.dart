import '../../../../shared/types/response_type.dart';
import '../../../catalog/data/models/product_model.dart';
import '../models/product_extended_model.dart';

abstract interface class ProductRemoteDataSource {
  TaskResponse<ProductExtendedModel> getProductById(final int id);

  TaskResponse<List<ProductModel>> getRecommendations(int forProductId);
}
