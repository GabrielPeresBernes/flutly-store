import 'dart:convert';

import '../../../../core/local_storage/local_storage.dart';
import '../../../../shared/utils/json_parser.dart';
import '../../domain/entities/cart.dart';
import 'cart_product_model.dart';

class CartModel with JsonSerializableMixin {
  const CartModel({
    required this.totalPrice,
    required this.totalItems,
    required this.products,
  });

  factory CartModel.fromJson(Map<String, dynamic> json) {
    final productsJson = json['products'] != null
        ? jsonDecode(json['products'] as String) as Map<String, dynamic>
        : <String, dynamic>{};

    return CartModel(
      totalPrice: JsonParser.parseDouble(json['totalPrice']),
      totalItems: JsonParser.parseInt(json['totalItems']),
      products: productsJson.map(
        (key, value) => MapEntry(
          JsonParser.parseInt(key),
          CartProductModel.fromJson(value as Map<String, dynamic>),
        ),
      ),
    );
  }

  factory CartModel.fromEntity(Cart cart) {
    return CartModel(
      totalPrice: cart.totalPrice,
      totalItems: cart.totalItems,
      products: cart.products.map(
        (key, value) => MapEntry(
          key,
          CartProductModel.fromEntity(value),
        ),
      ),
    );
  }

  final double totalPrice;
  final int totalItems;
  final Map<int, CartProductModel> products;

  CartModel copyWith({
    double? totalPrice,
    int? totalItems,
    Map<int, CartProductModel>? products,
  }) {
    return CartModel(
      totalPrice: totalPrice ?? this.totalPrice,
      totalItems: totalItems ?? this.totalItems,
      products: products ?? this.products,
    );
  }

  @override
  Map<String, dynamic> toJson() => {
    'totalPrice': totalPrice,
    'totalItems': totalItems,
    'products': jsonEncode(
      products.map(
        (key, value) => MapEntry(key.toString(), value.toJson()),
      ),
    ),
  };

  Cart toEntity() => Cart(
    totalPrice: totalPrice,
    totalItems: totalItems,
    products: products.map(
      (key, value) => MapEntry(key, value.toEntity()),
    ),
  );

  CartModel mergeCart(CartModel other) {
    final mergedProducts = Map<int, CartProductModel>.from(products);
    var mergedTotalPrice = totalPrice;
    var mergedTotalItems = totalItems;

    other.products.forEach((key, product) {
      if (!mergedProducts.containsKey(key)) {
        mergedProducts[key] = product;
        mergedTotalItems += product.quantity;
        mergedTotalPrice += product.price * product.quantity;
      }
    });

    return CartModel(
      totalPrice: mergedTotalPrice,
      totalItems: mergedTotalItems,
      products: mergedProducts,
    );
  }
}
