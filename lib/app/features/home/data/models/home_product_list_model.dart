import '../../../../shared/utils/json_parser.dart';
import '../../domain/entities/home_product_list.dart';
import 'home_product_model.dart';

class HomeProductListModel {
  HomeProductListModel({
    required this.title,
    required this.products,
    required this.variant,
  });

  factory HomeProductListModel.fromJson(Map<String, dynamic> json) {
    final products = JsonParser.parseList<HomeProductModel>(
      json['items'] as List<dynamic>?,
      (item) => HomeProductModel.fromJson(
        JsonParser.parseMap(JsonParser.parseMap(item)['product']),
      ),
    );

    return HomeProductListModel(
      title: JsonParser.parseString(json['heading']),
      variant: JsonParser.parseString(json['variant']),
      products: products,
    );
  }

  HomeProductList toEntity() => HomeProductList(
    title: title,
    products: products.map((productModel) => productModel.toEntity()).toList(),
    type: HomeProductListType.fromString(variant),
  );

  final String title;
  final List<HomeProductModel> products;
  final String variant;
}
