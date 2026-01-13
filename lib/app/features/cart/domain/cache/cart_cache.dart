import '../entities/cart.dart';
import '../entities/cart_product.dart';

class CartCache {
  CartCache();

  CartCache.fromCart(Cart cart) : _cart = cart;

  Cart _cart = Cart.empty();

  Cart get cart => _cart;

  Cart addProduct({
    required int id,
    required String thumbnail,
    required String name,
    required double price,
  }) {
    final product = _cart.products[id];

    _cart.products[id] = CartProduct(
      id: id,
      quantity: product != null ? product.quantity + 1 : 1,
      thumbnail: thumbnail,
      name: name,
      price: price,
    );

    _cart = _cart.copyWith(
      products: _cart.products,
      totalItems: _cart.totalItems + 1,
      totalPrice: _cart.totalPrice + price,
    );

    return _cart;
  }

  Cart removeProduct(int productId) {
    final product = _cart.products[productId];

    if (product != null && product.quantity > 1) {
      _cart.products[productId] = product.copyWith(
        quantity: product.quantity - 1,
      );

      _cart = _cart.copyWith(
        products: _cart.products,
        totalItems: _cart.totalItems - 1,
        totalPrice: _cart.totalPrice - product.price,
      );
    }

    return _cart;
  }

  Cart deleteProduct(int productId) {
    final product = _cart.products[productId];

    if (product != null) {
      _cart.products.remove(productId);

      _cart = _cart.copyWith(
        products: _cart.products,
        totalItems: _cart.totalItems - product.quantity,
        totalPrice: _cart.totalPrice - (product.price * product.quantity),
      );
    }

    return _cart;
  }

  void setCart(Cart cart) {
    _cart = _cart.copyWith(
      totalItems: cart.totalItems,
      totalPrice: cart.totalPrice,
      products: cart.products,
    );
  }

  void clearCart() {
    _cart = _cart.copyWith(totalItems: 0, totalPrice: 0.0, products: {});
  }
}
