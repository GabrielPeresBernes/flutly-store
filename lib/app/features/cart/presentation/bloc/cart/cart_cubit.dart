import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fpdart/fpdart.dart';

import '../../../../../shared/errors/app_exception.dart';
import '../../../constants/cart_constants.dart';
import '../../../domain/cache/cart_cache.dart';
import '../../../domain/entities/cart.dart';
import '../../../domain/entities/cart_product.dart';
import '../../../domain/repositories/cart_repository.dart';

part 'cart_state.dart';

class CartCubit extends Cubit<CartState> {
  CartCubit(this._cartRepository) : super(const CartInitial());

  final CartRepository _cartRepository;

  CartCache _cartCache = CartCache();

  Cart get cart => _cartCache.cart;

  Future<void> refreshCart({bool hasSessionChanged = false}) async {
    if (state is CartUpdating) {
      return;
    }

    emit(const CartLoading());

    final response = await _cartRepository.getCart().run();

    response.fold(
      (exception) => emit(CartFailure(exception: exception)),
      (cart) {
        final newCart = CartCache.fromCart(cart.getOrElse(Cart.empty));

        if (newCart.cart.totalItems > 0) {
          emit(
            CartLoaded(
              cart: newCart.cart,
              hasUpdated: hasSessionChanged && _cartCache.cart != newCart.cart,
            ),
          );
        } else {
          emit(const CartEmpty());
        }

        _cartCache = newCart;
      },
    );
  }

  Future<void> addProduct({
    required int id,
    required String thumbnail,
    required String name,
    required double price,
    required int uiID,
  }) => _addProduct(
    id: id,
    thumbnail: thumbnail,
    name: name,
    price: price,
    uiID: uiID,
  );

  Future<void> incrementProduct(
    CartProduct product,
  ) => _addProduct(
    id: product.id,
    thumbnail: product.thumbnail,
    name: product.name,
    price: product.price,
  );

  Future<void> decrementProduct(CartProduct product) async {
    if (state is CartUpdating) {
      return;
    }

    emit(CartUpdating(productId: product.id));

    final updatedCart = _cartCache.removeProduct(product.id);

    final response = await _cartRepository.saveCart(updatedCart).run();

    response.fold(
      (exception) => emit(
        CartUpdateFailure(
          exception: exception,
          cart: _cartCache.cart,
          productId: product.id,
        ),
      ),
      (_) {
        _cartCache = CartCache.fromCart(updatedCart);
        emit(
          CartUpdated(
            cart: _cartCache.cart,
            product: _cartCache.cart.products[product.id]!,
            operation: CartOperation.decrement,
          ),
        );
      },
    );
  }

  Future<void> removeProduct(CartProduct product) async {
    if (state is CartUpdating) {
      return;
    }

    emit(CartUpdating(productId: product.id));

    final updatedCart = _cartCache.deleteProduct(product.id);

    final response = await _cartRepository.saveCart(updatedCart).run();

    response.fold(
      (exception) => emit(
        CartUpdateFailure(
          exception: exception,
          cart: _cartCache.cart,
          productId: product.id,
        ),
      ),
      (_) async {
        _cartCache = CartCache.fromCart(updatedCart);

        emit(
          CartUpdated(
            cart: _cartCache.cart,
            product: product,
            operation: CartOperation.remove,
          ),
        );

        if (_cartCache.cart.totalItems == 0) {
          // Wait for the cart item removal animation to complete
          await Future<void>.delayed(
            CartConstants.cartItemAnimationDuration,
          );

          emit(const CartEmpty());
        }
      },
    );
  }

  Future<void> clearCart() async {
    final response = await _cartRepository.clearCart().run();

    response.fold(
      (exception) {
        emit(
          CartClearFailure(exception: exception, cart: _cartCache.cart),
        );
      },
      (_) {
        _cartCache = CartCache();
        emit(const CartEmpty());
      },
    );
  }

  Future<void> _addProduct({
    required int id,
    required String thumbnail,
    required String name,
    required double price,
    int uiID = 0,
  }) async {
    if (state is CartUpdating) {
      return;
    }

    emit(CartUpdating(productId: id));

    final updatedCart = _cartCache.addProduct(
      id: id,
      thumbnail: thumbnail,
      name: name,
      price: price,
    );

    final response = await _cartRepository.saveCart(updatedCart).run();

    response.fold(
      (exception) => emit(
        CartUpdateFailure(
          exception: exception,
          cart: _cartCache.cart,
          productId: id,
          uiID: uiID,
        ),
      ),
      (_) {
        _cartCache = CartCache.fromCart(updatedCart);

        final currentProduct = _cartCache.cart.products[id]!;

        emit(
          CartUpdated(
            cart: updatedCart,
            operation: currentProduct.quantity == 1
                ? CartOperation.add
                : CartOperation.increment,
            product: currentProduct,
            uiID: uiID,
          ),
        );
      },
    );
  }
}
