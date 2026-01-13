import '../../../../shared/types/response_type.dart';
import '../../domain/entities/product.dart';
import '../../domain/entities/product_extended.dart';
import '../../domain/repositories/product_repository.dart';
import '../data_sources/product_remote_data_source.dart';

class ProductRepositoryImpl implements ProductRepository {
  ProductRepositoryImpl(this._remoteDataSource);

  final ProductRemoteDataSource _remoteDataSource;

  @override
  TaskResponse<ProductExtended> getProductById(final int id) {
    return _remoteDataSource
        .getProductById(id)
        .map((model) => model.toEntity());
  }

  @override
  TaskResponse<List<Product>> getRecommendations(int forProductId) {
    return _remoteDataSource
        .getRecommendations(forProductId)
        .map(
          (models) => models.map((model) => model.toEntity()).toList(),
        );
  }
}
