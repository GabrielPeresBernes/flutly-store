import '../../../../shared/utils/json_parser.dart';
import '../../../product/domain/entities/product.dart';

class ProductModel {
  ProductModel({
    required this.id,
    required this.title,
    required this.thumbnail,
    required this.price,
    required this.rating,
    required this.category,
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      id: JsonParser.parseInt(json['id']),
      title: JsonParser.parseString(json['title']),
      thumbnail: JsonParser.parseString(json['thumbnail']),
      price: JsonParser.parseDouble(json['price']),
      rating: JsonParser.parseDouble(json['rating']),
      category: JsonParser.parseString(json['category']),
    );
  }

  Product toEntity() {
    return Product(
      id: id,
      title: title,
      thumbnail: thumbnail,
      price: price,
      rating: rating,
    );
  }

  final int id;
  final String title;
  final String thumbnail;
  final double price;
  final double rating;
  final String category;
}
