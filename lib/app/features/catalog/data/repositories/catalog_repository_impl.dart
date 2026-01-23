import '../../../../shared/types/response_type.dart';
import '../../domain/entities/product_filters.dart';
import '../../domain/entities/products_page.dart';
import '../../domain/repositories/catalog_repository.dart';
import '../data_sources/catalog_remote_data_source.dart';

class CatalogRepositoryImpl implements CatalogRepository {
  const CatalogRepositoryImpl(this._remoteDataSource);

  final CatalogRemoteDataSource _remoteDataSource;

  @override
  TaskResponse<ProductsPage> getProducts(
    final int limit,
    final int skip,
    final String? searchTerm,
    final ProductFilters? filters,
  ) {
    return _remoteDataSource
        .getProducts(limit, skip, searchTerm, filters)
        .map((productsPageModel) => productsPageModel.toEntity());
  }
}
