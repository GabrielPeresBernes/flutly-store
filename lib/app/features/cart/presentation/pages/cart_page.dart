import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/cart/cart_cubit.dart';
import '../widgets/page_states/cart_empty_widget.dart';
import '../widgets/page_states/cart_failure_widget.dart';
import '../widgets/page_states/cart_loaded_widget.dart';
import '../widgets/page_states/cart_loading_widget.dart';

class CartPage extends StatelessWidget {
  const CartPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CartCubit, CartState>(
      buildWhen: (previous, current) =>
          current is! CartUpdating && current is! CartUpdateFailure,
      builder: (context, state) {
        return switch (state) {
          CartLoading() || CartInitial() => const CartLoadingWidget(),

          CartFailure() => const CartFailureWidget(),

          CartEmpty() => const CartEmptyWidget(),

          CartLoaded(:final cart) ||
          CartUpdated(:final cart) => CartLoadedWidget(cart: cart),

          // Fallback for CartClearFailure, CartUpdating and CartUpdateFailure
          _ => const SizedBox.shrink(),
        };
      },
    );
  }
}
