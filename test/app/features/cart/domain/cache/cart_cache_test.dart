import 'package:flutly_store/app/features/cart/domain/cache/cart_cache.dart';
import 'package:flutly_store/app/features/cart/domain/entities/cart.dart';
import 'package:flutly_store/app/features/cart/domain/entities/cart_product.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('starts with empty cart', () {
    final cache = CartCache();

    expect(cache.cart.totalItems, 0);
    expect(cache.cart.totalPrice, 0.0);
    expect(cache.cart.products, isEmpty);
  });

  test('addProduct adds new item and updates totals', () {
    final cache = CartCache();

    final cart = cache.addProduct(
      id: 1,
      thumbnail: 'thumb.png',
      name: 'Item',
      price: 10.0,
    );

    expect(cart.totalItems, 1);
    expect(cart.totalPrice, 10.0);
    expect(cart.products[1]?.quantity, 1);
  });

  test('addProduct increments quantity when item exists', () {
    final cache = CartCache();

    cache.addProduct(
      id: 1,
      thumbnail: 'thumb.png',
      name: 'Item',
      price: 10.0,
    );
    final cart = cache.addProduct(
      id: 1,
      thumbnail: 'thumb.png',
      name: 'Item',
      price: 10.0,
    );

    expect(cart.totalItems, 2);
    expect(cart.totalPrice, 20.0);
    expect(cart.products[1]?.quantity, 2);
  });

  test('removeProduct decrements quantity when greater than one', () {
    final cache = CartCache();

    cache.addProduct(
      id: 1,
      thumbnail: 'thumb.png',
      name: 'Item',
      price: 10.0,
    );
    cache.addProduct(
      id: 1,
      thumbnail: 'thumb.png',
      name: 'Item',
      price: 10.0,
    );

    final cart = cache.removeProduct(1);

    expect(cart.totalItems, 1);
    expect(cart.totalPrice, 10.0);
    expect(cart.products[1]?.quantity, 1);
  });

  test('removeProduct does nothing when quantity is one', () {
    final cache = CartCache();

    cache.addProduct(
      id: 1,
      thumbnail: 'thumb.png',
      name: 'Item',
      price: 10.0,
    );

    final cart = cache.removeProduct(1);

    expect(cart.totalItems, 1);
    expect(cart.totalPrice, 10.0);
    expect(cart.products[1]?.quantity, 1);
  });

  test('deleteProduct removes item and updates totals', () {
    final cache = CartCache();

    cache.addProduct(
      id: 1,
      thumbnail: 'thumb.png',
      name: 'Item',
      price: 10.0,
    );
    cache.addProduct(
      id: 1,
      thumbnail: 'thumb.png',
      name: 'Item',
      price: 10.0,
    );

    final cart = cache.deleteProduct(1);

    expect(cart.totalItems, 0);
    expect(cart.totalPrice, 0.0);
    expect(cart.products, isEmpty);
  });

  test('setCart replaces cached values', () {
    final cache = CartCache();
    const cart = Cart(
      totalPrice: 25.0,
      totalItems: 2,
      products: {
        1: CartProduct(
          id: 1,
          quantity: 2,
          thumbnail: 'thumb.png',
          name: 'Item',
          price: 12.5,
        ),
      },
    );

    cache.setCart(cart);

    expect(cache.cart.totalItems, 2);
    expect(cache.cart.totalPrice, 25.0);
    expect(cache.cart.products[1]?.quantity, 2);
  });

  test('clearCart resets totals and products', () {
    final cache = CartCache();
    cache.addProduct(
      id: 1,
      thumbnail: 'thumb.png',
      name: 'Item',
      price: 10.0,
    );

    cache.clearCart();

    expect(cache.cart.totalItems, 0);
    expect(cache.cart.totalPrice, 0.0);
    expect(cache.cart.products, isEmpty);
  });
}
