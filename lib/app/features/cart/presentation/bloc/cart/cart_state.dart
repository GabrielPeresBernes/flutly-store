part of 'cart_cubit.dart';

enum CartOperation { add, increment, decrement, remove }

sealed class CartState {
  const CartState();
}

final class CartInitial extends CartState {
  const CartInitial();
}

final class CartLoading extends CartState {
  const CartLoading();
}

final class CartLoaded extends CartState {
  const CartLoaded({required this.cart, this.hasUpdated = false});

  final Cart cart;
  final bool hasUpdated;
}

final class CartFailure extends CartState {
  const CartFailure({required this.exception});

  final AppException exception;
}

final class CartEmpty extends CartState {
  const CartEmpty();
}

final class CartUpdating extends CartState {
  const CartUpdating({required this.productId});

  final int productId;
}

final class CartUpdated extends CartState {
  const CartUpdated({
    required this.cart,
    required this.product,
    required this.operation,
    this.uiID = 0,
  });

  final Cart cart;
  final CartProduct product;
  final CartOperation operation;
  final int uiID;
}

final class CartUpdateFailure extends CartState {
  const CartUpdateFailure({
    required this.exception,
    required this.cart,
    required this.productId,
    this.uiID = 0,
  });

  final AppException exception;
  final Cart cart;
  final int productId;
  final int uiID;
}

final class CartClearFailure extends CartState {
  const CartClearFailure({
    required this.exception,
    required this.cart,
  });

  final AppException exception;
  final Cart cart;
}
