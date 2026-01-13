import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../shared/bloc/app_cubit.dart';
import '../../../../../shared/extensions/layout_extension.dart';
import '../../../../../shared/extensions/show_app_bottom_sheet_extension.dart';
import '../../../../../shared/theme/tokens/color_tokens.dart';
import '../../../../../shared/widgets/buttons/app_elevated_button_widget.dart';
import '../../../../../shared/widgets/navigation_bars/app_top_navigation_bar.dart';
import '../../../../checkout/presentation/widgets/bottom_sheets/checkout_bottom_sheet_widget.dart';
import '../../../domain/entities/cart.dart';
import '../../../domain/entities/cart_product.dart';
import '../../bloc/cart_cubit.dart';
import '../cart_bottom_sheet_unauthenticated_widget.dart';
import '../cart_items_list_widget.dart';
import '../cart_summary_loaded_widget.dart';

class CartLoadedWidget extends StatelessWidget {
  CartLoadedWidget({super.key, required this.cart})
    : products = cart.products.values.toList();

  final Cart cart;
  final List<CartProduct> products;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      appBar: AppTopNavigationBar(title: 'cart.title'.tr(), showLeading: false),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: Container(
        padding: EdgeInsets.fromLTRB(24, 12, 24, context.bottomBarOffset),
        decoration: const BoxDecoration(
          color: AppColors.white,
          border: Border(
            top: BorderSide(color: AppColors.gray400),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            BlocBuilder<CartCubit, CartState>(
              builder: (context, state) {
                return CartSummaryWidget(cart: cart);
              },
            ),
            AppElevatedButtonWidget(
              label: 'cart.actions.checkout'.tr(),
              onPressed: () {
                if (context.read<CartCubit>().state is CartUpdating) {
                  return;
                }

                if (!context.read<AppCubit>().isUserAuthenticated) {
                  context.showAppBottomSheet(
                    child: const CartBottomSheetUnauthenticatedWidget(),
                  );
                  return;
                }

                context.showAppBottomSheet(
                  isDismissible: false,
                  child: const CheckoutBottomSheetWidget(),
                );
              },
            ),
          ],
        ),
      ),
      body: CartItemsListWidget(products: products),
    );
  }
}
