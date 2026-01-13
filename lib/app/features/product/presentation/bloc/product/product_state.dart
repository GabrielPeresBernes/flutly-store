part of 'product_cubit.dart';

sealed class ProductState {
  const ProductState();
}

final class ProductInitial extends ProductState {
  const ProductInitial();
}

final class ProductLoading extends ProductState {
  const ProductLoading();
}

final class ProductLoaded extends ProductState {
  const ProductLoaded({required this.product});

  final ProductExtended product;
}

final class ProductFailure extends ProductState {
  const ProductFailure({required this.exception});

  final AppException exception;
}
