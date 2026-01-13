import '../../../../shared/utils/json_parser.dart';
import '../../domain/entities/products_page.dart';
import 'product_model.dart';

class ProductsPageModel {
  ProductsPageModel({
    required this.products,
    required this.total,
    required this.skip,
    required this.limit,
  });

  factory ProductsPageModel.fromJson(Map<String, dynamic> json) {
    return ProductsPageModel(
      products: JsonParser.parseList(
        json['products'],
        (item) => ProductModel.fromJson(JsonParser.parseMap(item)),
      ),
      total: JsonParser.parseInt(json['total']),
      skip: JsonParser.parseInt(json['skip']),
      limit: JsonParser.parseInt(json['limit']),
    );
  }

  ProductsPageModel copyWith({
    List<ProductModel>? products,
    int? total,
    int? skip,
    int? limit,
  }) {
    return ProductsPageModel(
      products: products ?? this.products,
      total: total ?? this.total,
      skip: skip ?? this.skip,
      limit: limit ?? this.limit,
    );
  }

  ProductsPage toEntity() {
    return ProductsPage(
      products: products
          .map((productModel) => productModel.toEntity())
          .toList(),
      total: total,
      skip: skip,
      limit: limit,
    );
  }

  final List<ProductModel> products;
  final int total;
  final int skip;
  final int limit;
}
