part of 'cart_popular_products_cubit.dart';

sealed class CartPopularProductsState {
  const CartPopularProductsState();
}

final class CartPopularProductsInitial extends CartPopularProductsState {
  const CartPopularProductsInitial();
}

final class CartPopularProductsLoading extends CartPopularProductsState {
  const CartPopularProductsLoading();
}

final class CartPopularProductsLoaded extends CartPopularProductsState {
  const CartPopularProductsLoaded({required this.products});

  final List<Product> products;
}

final class CartPopularProductsFailure extends CartPopularProductsState {
  const CartPopularProductsFailure({required this.exception});

  final AppException exception;
}
