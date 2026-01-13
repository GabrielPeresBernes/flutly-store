import '../../../../shared/types/response_type.dart';
import '../entities/product.dart';
import '../entities/product_extended.dart';

abstract interface class ProductRepository {
  TaskResponse<ProductExtended> getProductById(final int id);

  TaskResponse<List<Product>> getRecommendations(int forProductId);
}
