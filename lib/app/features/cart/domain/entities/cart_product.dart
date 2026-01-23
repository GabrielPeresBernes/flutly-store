class CartProduct {
  const CartProduct({
    required this.id,
    required this.quantity,
    required this.thumbnail,
    required this.name,
    required this.price,
  });

  CartProduct copyWith({
    int? id,
    int? quantity,
    String? thumbnail,
    String? name,
    double? price,
  }) => CartProduct(
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
}
