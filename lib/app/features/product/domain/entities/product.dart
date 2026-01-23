class Product {
  const Product({
    required this.id,
    required this.title,
    required this.thumbnail,
    required this.price,
    this.rating,
  });

  final int id;
  final String title;
  final String thumbnail;
  final double price;
  final double? rating;
}
