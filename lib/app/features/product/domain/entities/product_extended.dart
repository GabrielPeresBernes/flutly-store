import 'product.dart';

class ProductExtended extends Product {
  ProductExtended({
    required super.id,
    required super.title,
    required super.thumbnail,
    required super.price,
    required super.rating,
    required this.description,
    required this.brand,
    required this.images,
    required this.discountPercentage,
  });

  final String description;
  final String brand;
  final List<String> images;
  final double discountPercentage;
}
