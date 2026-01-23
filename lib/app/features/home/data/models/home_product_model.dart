import '../../../../shared/utils/json_parser.dart';
import '../../domain/entities/home_product.dart';

class HomeProductModel {
  const HomeProductModel({
    required this.id,
    required this.title,
    required this.price,
    required this.image,
  });

  factory HomeProductModel.fromJson(Map<String, dynamic> json) {
    return HomeProductModel(
      id: JsonParser.parseString(json['id']),
      title: JsonParser.parseString(json['title']),
      price: JsonParser.parseDouble(json['price']),
      image: JsonParser.parseString(json['image']),
    );
  }

  HomeProduct toEntity() => HomeProduct(
    id: int.parse(id),
    title: title,
    price: price,
    image: image,
  );

  final String id;
  final String title;
  final double price;
  final String image;
}
