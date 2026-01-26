import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../shared/widgets/buttons/app_outlined_button_widget.dart';
import '../../../../../shared/widgets/navigation_bars/app_top_navigation_bar.dart';
import '../../bloc/cart/cart_cubit.dart';

class CartFailureWidget extends StatelessWidget {
  const CartFailureWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      appBar: AppTopNavigationBar(title: 'cart.title'.tr(), showLeading: false),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('cart.errors.loading'.tr()),
            const SizedBox(height: 20),
            AppOutlinedButtonWidget(
              label: 'cart.actions.retry'.tr(),
              onPressed: () => context.read<CartCubit>().refreshCart(),
            ),
          ],
        ),
      ),
    );
  }
}
