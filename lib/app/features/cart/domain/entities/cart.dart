import 'package:equatable/equatable.dart';

import 'cart_product.dart';

class Cart extends Equatable {
  const Cart({
    required this.totalPrice,
    required this.totalItems,
    required this.products,
  });

  Cart.empty() : totalPrice = 0.0, totalItems = 0, products = {};

  Cart copyWith({
    double? totalPrice,
    int? totalItems,
    Map<int, CartProduct>? products,
  }) => Cart(
    totalPrice: totalPrice ?? this.totalPrice,
    totalItems: totalItems ?? this.totalItems,
    products: products ?? this.products,
  );

  final double totalPrice;
  final int totalItems;
  final Map<int, CartProduct> products;

  @override
  List<Object?> get props => [totalPrice, totalItems];
}
