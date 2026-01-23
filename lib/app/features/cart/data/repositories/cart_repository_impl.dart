import 'package:fpdart/fpdart.dart';

import '../../../../shared/extensions/task_either_extension.dart';
import '../../../../shared/types/response_type.dart';
import '../../../auth/data/data_sources/auth_local_data_source.dart';
import '../../domain/entities/cart.dart';
import '../../domain/repositories/cart_repository.dart';
import '../data_sources/cart_local_data_source.dart';
import '../data_sources/cart_remote_data_source.dart';
import '../models/cart_model.dart';

class CartRepositoryImpl implements CartRepository {
  const CartRepositoryImpl(
    this._authLocalDataSource,
    this._cartRemoteDataSource,
    this._cartLocalDataSource,
  );

  final AuthLocalDataSource _authLocalDataSource;
  final CartRemoteDataSource _cartRemoteDataSource;
  final CartLocalDataSource _cartLocalDataSource;

  @override
  TaskResponse<void> saveCart(Cart cart) {
    final model = CartModel.fromEntity(cart);

    return _withCredentials<void>(
      onGuest: () => _cartLocalDataSource.saveCart(model),
      onUser: (userId) => _cartRemoteDataSource
          .saveCart(userId, model)
          .chainFirst(
            (_) => _cartLocalDataSource.saveCart(model).ignoreErrorWithNull(),
          ),
    );
  }

  @override
  TaskResponse<Option<Cart>> getCart() => _withCredentials(
    onGuest: () {
      return _cartLocalDataSource.getCart().map(
        (cartOption) => cartOption.map((model) => model.toEntity()),
      );
    },
    onUser: (userId) => _cartLocalDataSource
        .getCart()
        .ignoreErrorWithNone()
        .flatMap((localCart) => _getRemoteCart(userId, localCart))
        .map((cartOption) => cartOption.map((model) => model.toEntity())),
  );

  @override
  TaskResponse<void> clearCart() => _withCredentials<void>(
    onGuest: _cartLocalDataSource.clearCart,
    onUser: (userId) => _cartRemoteDataSource
        .clearCart(userId)
        .chainFirst(
          (_) => _cartLocalDataSource.clearCart().ignoreErrorWithNull(),
        ),
  );

  TaskResponse<Option<CartModel>> _getRemoteCart(
    String userId,
    Option<CartModel> localCartOption,
  ) => _cartRemoteDataSource
      .getCart(userId)
      .flatMap(
        (remoteCartOption) => remoteCartOption.match(
          // No remote cart, sync local to remote
          () => _syncLocalToRemote(userId, localCartOption),
          // Remote cart exists, sync remote with local
          (remoteCart) =>
              _syncRemoteWithLocal(userId, localCartOption, remoteCart),
        ),
      );

  TaskResponse<Option<CartModel>> _syncLocalToRemote(
    String userId,
    Option<CartModel> localCartOption,
  ) => localCartOption.match(
    // No local cart, nothing to sync
    () => TaskResponse.right(none()),

    // Local cart exists, save to remote
    (localCart) => _cartRemoteDataSource
        .saveCart(userId, localCart)
        .map((_) => some(localCart)),
  );

  TaskResponse<Option<CartModel>> _syncRemoteWithLocal(
    String userId,
    Option<CartModel> localCartOption,
    CartModel remoteCart,
  ) => localCartOption.match(
    // No local cart, nothing to sync
    // Save remote cart to local storage, ignore local storage errors
    () => _cartLocalDataSource
        .saveCart(remoteCart)
        .ignoreErrorWithNull()
        .map((_) => some(remoteCart)),

    // Local cart exists, merge and save to remote
    (localCart) {
      final mergedCart = remoteCart.mergeCart(localCart);
      return _cartRemoteDataSource
          .saveCart(userId, mergedCart)
          .chainFirst(
            (_) =>
                _cartLocalDataSource.saveCart(mergedCart).ignoreErrorWithNull(),
          )
          .map((_) => some(mergedCart));
    },
  );

  TaskResponse<T> _withCredentials<T>({
    required TaskResponse<T> Function() onGuest,
    required TaskResponse<T> Function(String userId) onUser,
  }) => _authLocalDataSource.getCredentials().flatMap(
    (opt) => opt.match(onGuest, (credentials) => onUser(credentials.userId)),
  );
}
