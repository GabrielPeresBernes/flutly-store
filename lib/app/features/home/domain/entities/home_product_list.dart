import 'home_product.dart';

enum HomeProductListType {
  highlight('highlight'),
  normal('normal');

  const HomeProductListType(this.type);

  factory HomeProductListType.fromString(String type) {
    return HomeProductListType.values.firstWhere(
      (e) => e.type == type,
      orElse: () => HomeProductListType.normal,
    );
  }

  final String type;
}

class HomeProductList {
  HomeProductList({
    required this.title,
    required this.products,
    required this.type,
  });

  final String title;
  final List<HomeProduct> products;
  final HomeProductListType type;
}
