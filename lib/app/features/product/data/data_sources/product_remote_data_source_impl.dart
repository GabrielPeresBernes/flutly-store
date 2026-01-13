import 'package:easy_localization/easy_localization.dart';

import '../../../../core/http/http.dart';
import '../../../../shared/types/response_type.dart';
import '../../../../shared/utils/env.dart';
import '../../../../shared/utils/json_parser.dart';
import '../../../../shared/utils/task_utils.dart';
import '../../../catalog/data/models/product_model.dart';
import '../models/product_extended_model.dart';
import 'product_remote_data_source.dart';

class ProductRemoteDataSourceImpl implements ProductRemoteDataSource {
  ProductRemoteDataSourceImpl(this._httpClient);

  final CoreHttp _httpClient;

  @override
  TaskResponse<ProductExtendedModel> getProductById(final int id) => task(
    () => _httpClient.get<ProductExtendedModel>(
      '${Env.apiBaseUrl}/$id',
      decoder: ProductExtendedModel.fromJson,
    ),
    (_) => tr('product.errors.fetch_failed'),
  );

  @override
  TaskResponse<List<ProductModel>> getRecommendations(int forProductId) => task(
    () {
      final products = _httpClient.get<List<ProductModel>>(
        '${Env.apiBaseUrl}/category/mobile-accessories',
        queryParameters: {'limit': 4},
        decoder: (value) => JsonParser.parseList<ProductModel>(
          value['products'],
          (item) => ProductModel.fromJson(JsonParser.parseMap(item)),
        ),
      );

      // Exclude the current product from recommendations
      return products.then(
        (list) => list.where((product) => product.id != forProductId).toList(),
      );
    },
    (_) => tr('product.errors.recommendations_failed'),
  );
}
