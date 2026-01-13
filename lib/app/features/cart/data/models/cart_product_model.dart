import '../../../../core/local_storage/local_storage.dart';
import '../../../../shared/utils/json_parser.dart';
import '../../domain/entities/cart_product.dart';

class CartProductModel with JsonSerializableMixin {
  CartProductModel({
    required this.id,
    required this.quantity,
    required this.thumbnail,
    required this.name,
    required this.price,
  });

  factory CartProductModel.fromJson(Map<String, dynamic> json) =>
      CartProductModel(
        id: JsonParser.parseInt(json['id']),
        quantity: JsonParser.parseInt(json['quantity']),
        thumbnail: JsonParser.parseString(json['thumbnail']),
        name: JsonParser.parseString(json['name']),
        price: JsonParser.parseDouble(json['price']),
      );

  factory CartProductModel.fromEntity(CartProduct entity) => CartProductModel(
    id: entity.id,
    quantity: entity.quantity,
    thumbnail: entity.thumbnail,
    name: entity.name,
    price: entity.price,
  );

  CartProductModel copyWith({
    int? id,
    int? quantity,
    String? thumbnail,
    String? name,
    double? price,
  }) => CartProductModel(
    id: id ?? this.id,
    quantity: quantity ?? this.quantity,
    thumbnail: thumbnail ?? this.thumbnail,
    name: name ?? this.name,
    price: price ?? this.price,
  );

  final int id;
  final int quantity;
  final String thumbnail;
  final String name;
  final double price;

  @override
  Map<String, dynamic> toJson() => {
    'id': id,
    'quantity': quantity,
    'thumbnail': thumbnail,
    'name': name,
    'price': price,
  };

  CartProduct toEntity() => CartProduct(
    id: id,
    quantity: quantity,
    thumbnail: thumbnail,
    name: name,
    price: price,
  );
}
