import 'package:fpdart/fpdart.dart';

import '../../../../../shared/types/response_type.dart';
import '../../models/cart_model.dart';

/// Remote data source interface for managing the shopping cart.
abstract interface class CartRemoteDataSource {
  /// Retrieves the cart for the given [userId].
  TaskResponse<Option<CartModel>> getCart(String userId);

  /// Saves the given [cart] for the given [userId].
  TaskResponse<void> saveCart(String userId, CartModel cart);

  /// Clears the cart for the given [userId].
  TaskResponse<void> clearCart(String userId);
}
