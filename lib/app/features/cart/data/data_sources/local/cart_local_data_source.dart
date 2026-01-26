import 'package:fpdart/fpdart.dart';

import '../../../../../shared/types/response_type.dart';
import '../../models/cart_model.dart';

/// Local data source interface for managing the shopping cart.
abstract interface class CartLocalDataSource {
  /// Retrieves the cart.
  TaskResponse<Option<CartModel>> getCart();

  /// Saves the given [cart].
  TaskResponse<void> saveCart(CartModel cart);

  /// Clears the cart.
  TaskResponse<void> clearCart();
}
