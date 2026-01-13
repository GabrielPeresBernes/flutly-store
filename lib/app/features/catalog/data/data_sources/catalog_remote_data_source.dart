import '../../../../shared/types/response_type.dart';
import '../../domain/entities/product_filters.dart';
import '../models/products_page_model.dart';

abstract interface class CatalogRemoteDataSource {
  TaskResponse<ProductsPageModel> getProducts(
    final int limit,
    final int skip,
    final String? searchTerm,
    final ProductFilters? filters,
  );
}
