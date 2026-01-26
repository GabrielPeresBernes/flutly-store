import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../shared/extensions/layout_extension.dart';
import '../../constants/cart_constants.dart';
import '../../domain/entities/cart_product.dart';
import '../bloc/cart/cart_cubit.dart';
import 'cart_item_widget.dart';

class CartItemsListWidget extends StatefulWidget {
  const CartItemsListWidget({super.key, required this.products});

  final List<CartProduct> products;

  @override
  State<CartItemsListWidget> createState() => _CartItemsListWidgetState();
}

class _CartItemsListWidgetState extends State<CartItemsListWidget> {
  final _listKey = GlobalKey<AnimatedListState>();

  Widget _buildRemovedItem(
    CartProduct product,
    BuildContext context,
    Animation<double> animation,
  ) => SizeTransition(
    sizeFactor: animation,
    child: FadeTransition(
      opacity: animation,
      child: CartItemWidget(product: product),
    ),
  );

  void _removeItem({required CartProduct product}) {
    final index = widget.products.indexWhere((p) => p.id == product.id);

    if (index == -1) {
      return;
    }

    _listKey.currentState?.removeItem(
      index,
      (context, animation) => _buildRemovedItem(product, context, animation),
      // ignore: avoid_redundant_argument_values
      duration: CartConstants.cartItemAnimationDuration,
    );
  }

  void _insertItem({required CartProduct product}) =>
      _listKey.currentState?.insertItem(
        widget.products.length - 1,
        duration: Duration.zero,
      );

  @override
  Widget build(BuildContext context) {
    return BlocListener<CartCubit, CartState>(
      listener: (context, state) {
        if (state is CartUpdated && state.operation == CartOperation.remove) {
          _removeItem(product: state.product);
        }

        if (state is CartUpdated && state.operation == CartOperation.add) {
          _insertItem(product: state.product);
        }
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: AnimatedList(
          key: _listKey,
          padding: EdgeInsets.only(
            top: 30,
            bottom: context.bottomBarOffset + 105,
          ),
          initialItemCount: widget.products.length,
          itemBuilder: (context, index, animation) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 35),
              child: CartItemWidget(product: widget.products[index]),
            );
          },
        ),
      ),
    );
  }
}
