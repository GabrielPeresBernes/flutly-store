part of 'search_popular_products_cubit.dart';

sealed class SearchPopularProductsState {
  const SearchPopularProductsState();
}

final class SearchPopularProductsInitial extends SearchPopularProductsState {
  const SearchPopularProductsInitial();
}

final class SearchPopularProductsLoading extends SearchPopularProductsState {
  const SearchPopularProductsLoading();
}

final class SearchPopularProductsLoaded extends SearchPopularProductsState {
  const SearchPopularProductsLoaded(this.products);

  final List<Product> products;
}

final class SearchPopularProductsFailure extends SearchPopularProductsState {
  const SearchPopularProductsFailure({required this.exception});

  final AppException exception;
}
