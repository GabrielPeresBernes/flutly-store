import 'package:easy_localization/easy_localization.dart';
import 'package:fpdart/fpdart.dart';

import '../../../../core/local_storage/local_storage.dart';
import '../../../../shared/types/response_type.dart';
import '../../../../shared/utils/task_utils.dart';
import '../../constants/cart_constants.dart';
import '../models/cart_model.dart';
import 'cart_local_data_source.dart';

class CartLocalDataSourceImpl implements CartLocalDataSource {
  CartLocalDataSourceImpl(this._localStorage);

  final CoreLocalStorage _localStorage;

  @override
  TaskResponse<Option<CartModel>> getCart() => task(
    () async {
      final cart = await _localStorage.storage.get<CartModel>(
        CartConstants.cartStorageKey,
        CartModel.fromJson,
      );

      return Option.fromNullable(cart);
    },
    (_) => tr('cart.errors.local_get_failed'),
  );

  @override
  TaskResponse<void> saveCart(CartModel cart) => task(
    () async {
      await _localStorage.storage.set(
        CartConstants.cartStorageKey,
        cart,
      );
    },
    (_) => tr('cart.errors.local_save_failed'),
  );

  @override
  TaskResponse<void> clearCart() => task(
    () async {
      await _localStorage.storage.remove(CartConstants.cartStorageKey);
    },
    (_) => tr('cart.errors.local_clear_failed'),
  );
}
