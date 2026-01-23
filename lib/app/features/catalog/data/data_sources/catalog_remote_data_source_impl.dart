import 'package:easy_localization/easy_localization.dart';

import '../../../../core/http/http.dart';
import '../../../../shared/types/response_type.dart';
import '../../../../shared/utils/env.dart';
import '../../../../shared/utils/task_utils.dart';
import '../../domain/entities/product_filters.dart';
import '../models/products_page_model.dart';
import 'catalog_remote_data_source.dart';

class CatalogRemoteDataSourceImpl implements CatalogRemoteDataSource {
  const CatalogRemoteDataSourceImpl(this._httpClient);

  final CoreHttp _httpClient;

  @override
  TaskResponse<ProductsPageModel> getProducts(
    final int limit,
    final int skip,
    final String? searchTerm,
    final ProductFilters? filters,
  ) => task(() async {
    var url = Env.apiBaseUrl;

    final hasSearchTerm = searchTerm != null && searchTerm.isNotEmpty;

    if (hasSearchTerm) {
      url += '/search';
    } else {
      url += '/category/mobile-accessories';
    }

    var response = await _httpClient.get<ProductsPageModel>(
      url,
      decoder: ProductsPageModel.fromJson,
      queryParameters: {
        'limit': limit,
        'skip': skip,
        if (hasSearchTerm) 'q': searchTerm,
        if (filters?.sortBy != null) 'sortBy': filters!.sortBy,
        if (filters?.order != null) 'order': filters!.order,
      },
    );

    // When searching, the API does not support category filtering.
    // Therefore, we need to filter the results manually.
    if (hasSearchTerm) {
      final filteredProducts = response.products
          .where(
            (product) => product.category == 'mobile-accessories',
          )
          .toList();

      response = response.copyWith(
        products: filteredProducts,
        total: filteredProducts.length,
      );
    }

    // The API does not support price range filtering,
    // so we need to filter the results manually.
    if (filters?.minPrice != null || filters?.maxPrice != null) {
      final filteredProducts = response.products.where((product) {
        final meetsMinPrice = filters?.minPrice != null
            ? product.price >= filters!.minPrice!
            : true;
        final meetsMaxPrice = filters?.maxPrice != null
            ? product.price <= filters!.maxPrice!
            : true;
        return meetsMinPrice && meetsMaxPrice;
      }).toList();

      response = response.copyWith(
        products: filteredProducts,
        total: filteredProducts.length,
      );
    }

    return response;
  }, (_) => tr('catalog.errors.fetch_failed'));
}
