import 'package:easy_localization/easy_localization.dart';
import 'package:fpdart/fpdart.dart';

import '../../../../../core/local_storage/local_storage.dart';
import '../../../../../shared/types/response_type.dart';
import '../../../../../shared/utils/task_utils.dart';
import '../../../cart.dart';

class CartRemoteDataSourceDemoImpl implements CartRemoteDataSource {
  const CartRemoteDataSourceDemoImpl(this._localStorage);

  final CoreLocalStorage _localStorage;

  @override
  TaskResponse<void> clearCart(String userId) => TaskResponse.right(null);

  @override
  TaskResponse<Option<CartModel>> getCart(String userId) => task(
    () async {
      final cart = await _localStorage.storage.get<CartModel>(
        CartConstants.cartStorageKey,
        CartModel.fromJson,
      );

      return Option.fromNullable(cart);
    },
    (_) => tr('cart.errors.remote_get_failed'),
  );

  @override
  TaskResponse<void> saveCart(String userId, CartModel cart) =>
      TaskResponse.right(null);
}
