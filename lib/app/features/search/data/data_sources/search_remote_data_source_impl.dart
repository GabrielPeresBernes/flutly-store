import 'package:easy_localization/easy_localization.dart';

import '../../../../core/http/http.dart';
import '../../../../shared/types/response_type.dart';
import '../../../../shared/utils/env.dart';
import '../../../../shared/utils/task_utils.dart';
import '../../../catalog/data/models/products_page_model.dart';
import 'search_remote_data_source.dart';

class SearchRemoteDataSourceImpl implements SearchRemoteDataSource {
  const SearchRemoteDataSourceImpl(this._httpClient);

  final CoreHttp _httpClient;

  @override
  TaskResponse<ProductsPageModel> getPopularProducts() => task(
    () async => _httpClient.get<ProductsPageModel>(
      '${Env.apiBaseUrl}/category/mobile-accessories',
      queryParameters: {
        'skip': 0,
        'limit': 3,
        'sortBy': 'rating',
        'order': 'desc',
      },
      decoder: ProductsPageModel.fromJson,
    ),
    (_) => tr('search.errors.popular_products_failed'),
  );
}
