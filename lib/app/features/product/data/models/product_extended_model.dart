import '../../../../shared/utils/json_parser.dart';
import '../../domain/entities/product_extended.dart';

class ProductExtendedModel {
  const ProductExtendedModel({
    required this.id,
    required this.title,
    required this.thumbnail,
    required this.price,
    required this.description,
    required this.category,
    required this.brand,
    required this.images,
    required this.discountPercentage,
    required this.rating,
  });

  factory ProductExtendedModel.fromJson(Map<String, dynamic> json) {
    return ProductExtendedModel(
      id: JsonParser.parseInt(json['id']),
      title: JsonParser.parseString(json['title']),
      thumbnail: JsonParser.parseString(json['thumbnail']),
      price: JsonParser.parseDouble(json['price']),
      rating: JsonParser.parseDouble(json['rating']),
      description: JsonParser.parseString(json['description']),
      category: JsonParser.parseString(json['category']),
      brand: JsonParser.parseString(json['brand']),
      images: JsonParser.parseList<String>(
        json['images'],
        JsonParser.parseString,
      ),
      discountPercentage: JsonParser.parseDouble(json['discountPercentage']),
    );
  }

  ProductExtended toEntity() {
    return ProductExtended(
      id: id,
      title: title,
      thumbnail: thumbnail,
      price: price,
      rating: rating,
      description: description,
      brand: brand,
      images: images,
      discountPercentage: discountPercentage,
    );
  }

  final int id;
  final String title;
  final String thumbnail;
  final double price;
  final double rating;
  final String description;
  final String category;
  final String brand;
  final List<String> images;
  final double discountPercentage;
}
