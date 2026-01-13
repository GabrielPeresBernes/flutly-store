import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../shared/bloc/app_cubit.dart';
import '../../../../shared/constants/bottom_navigator_tabs.dart';
import '../../../../shared/widgets/app_bottom_sheet_widget.dart';
import '../../../../shared/widgets/buttons/app_elevated_button_widget.dart';
import '../../../../shared/widgets/buttons/app_outlined_button_widget.dart';
import '../../../../shared/widgets/products/small_product_card_widget.dart';
import '../../domain/entities/product_extended.dart';

class ProductAddedBottomSheetWidget extends StatelessWidget {
  const ProductAddedBottomSheetWidget({
    super.key,
    required this.product,
  });

  final ProductExtended product;

  @override
  Widget build(BuildContext context) {
    return AppBottomSheetWidget(
      title: 'product.messages.added'.tr(),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          SmallProductCardWidget(
            title: product.title,
            price: product.price,
            image: product.images.first,
          ),
          const SizedBox(height: 35),
          AppElevatedButtonWidget(
            label: 'product.actions.continue_shopping'.tr(),
            onPressed: () => Navigator.of(context).pop(),
          ),
          const SizedBox(height: 10),
          SizedBox(
            height: 50,
            width: double.infinity,
            child: AppOutlinedButtonWidget(
              label: 'product.actions.view_cart'.tr(),
              onPressed: () {
                Navigator.of(context).pop();
                context.read<AppCubit>().navigateToTab(
                  BottomNavigatorTab.cart,
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
