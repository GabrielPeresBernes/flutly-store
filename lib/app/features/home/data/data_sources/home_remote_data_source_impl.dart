import 'package:easy_localization/easy_localization.dart';

import '../../../../core/http/http.dart';
import '../../../../shared/types/response_type.dart';
import '../../../../shared/utils/env.dart';
import '../../../../shared/utils/json_parser.dart';
import '../../../../shared/utils/task_utils.dart';
import '../models/home_product_list_model.dart';
import 'home_remote_data_source.dart';

class HomeRemoteDataSourceImpl implements HomeRemoteDataSource {
  HomeRemoteDataSourceImpl(this._http);

  final CoreHttp _http;

  final String _query = '''
    *[_type == "home"][0]{
      sections[]{
        heading,
        variant,
        items[]{
          product->{
            id,
            title,
            price,
            image,
          }
        }
      }
    }
  ''';

  @override
  TaskResponse<List<HomeProductListModel>> getProducts() => task(
    () => _http.get<List<HomeProductListModel>>(
      Env.crmBaseUrl,
      queryParameters: {'query': _query},
      decoder: (data) {
        final productLists = data['result']['sections'] as List<dynamic>?;

        return JsonParser.parseList<HomeProductListModel>(
          productLists,
          (productList) => HomeProductListModel.fromJson(
            JsonParser.parseMap(productList),
          ),
        );
      },
    ),
    (_) => tr('home.errors.fetch_products_failed'),
  );
}
