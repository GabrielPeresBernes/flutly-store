import 'package:fpdart/fpdart.dart';

import '../../../../shared/types/response_type.dart';
import '../entities/cart.dart';

/// Repository interface for managing the shopping cart.
abstract interface class CartRepository {
  /// Saves the given [cart].
  /// If the user is authenticated, saves it remotely;
  /// otherwise, saves it locally.
  TaskResponse<void> saveCart(Cart cart);

  /// Retrieves the cart.
  /// If the user is authenticated, retrieves it remotely;
  /// otherwise, retrieves it locally.
  TaskResponse<Option<Cart>> getCart();

  /// Clears the cart.
  /// If the user is authenticated, clears it remotely;
  /// otherwise, clears it locally.
  TaskResponse<void> clearCart();
}
