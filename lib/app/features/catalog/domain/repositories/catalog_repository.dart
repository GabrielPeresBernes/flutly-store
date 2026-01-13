import '../../../../shared/types/response_type.dart';
import '../entities/product_filters.dart';
import '../entities/products_page.dart';

abstract interface class CatalogRepository {
  TaskResponse<ProductsPage> getProducts(
    final int limit,
    final int skip,
    final String? searchTerm,
    final ProductFilters? filters,
  );
}
