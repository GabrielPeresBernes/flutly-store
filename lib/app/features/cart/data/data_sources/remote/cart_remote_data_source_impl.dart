import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:fpdart/fpdart.dart';

import '../../../../../shared/types/response_type.dart';
import '../../../../../shared/utils/task_utils.dart';
import '../../models/cart_model.dart';
import 'cart_remote_data_source.dart';

class CartRemoteDataSourceImpl implements CartRemoteDataSource {
  const CartRemoteDataSourceImpl(this._firebaseFirestore);

  final FirebaseFirestore _firebaseFirestore;

  @override
  TaskResponse<void> clearCart(String userId) => task(
    () {
      final ref = _firebaseFirestore.collection('carts').doc(userId);
      return ref.delete();
    },
    (_) => tr('cart.errors.remote_clear_failed'),
  );

  @override
  TaskResponse<Option<CartModel>> getCart(String userId) => task(
    () async {
      final ref = _firebaseFirestore.collection('carts').doc(userId);

      final doc = await ref.get();

      if (!doc.exists || doc.data()?['cart'] == null) {
        return const None();
      }

      final jsonMap = jsonDecode(doc.data()!['cart'] as String);

      final cart = CartModel.fromJson(jsonMap as Map<String, dynamic>);

      return Some(cart);
    },
    (_) => tr('cart.errors.remote_get_failed'),
  );

  @override
  TaskResponse<void> saveCart(String userId, CartModel cart) => task(
    () async {
      final ref = _firebaseFirestore.collection('carts').doc(userId);

      final cartJson = jsonEncode(cart.toJson());

      await ref.set({'cart': cartJson});
    },
    (_) => tr('cart.errors.remote_save_failed'),
  );
}
