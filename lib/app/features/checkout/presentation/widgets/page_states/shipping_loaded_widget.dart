import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../shared/extensions/text_theme_extension.dart';
import '../../../../../shared/theme/tokens/color_tokens.dart';
import '../../../../../shared/widgets/app_list_tile_widget.dart';
import '../../../domain/entities/shipping.dart';
import '../../bloc/checkout/checkout_cubit.dart';

class ShippingLoadedWidget extends StatelessWidget {
  const ShippingLoadedWidget({
    super.key,
    required this.shippings,
  });

  final List<Shipping> shippings;

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<CheckoutCubit>();

    return BlocBuilder<CheckoutCubit, CheckoutState>(
      buildWhen: (previous, current) => current is CheckoutShippingSelected,
      builder: (context, state) {
        var selectedShipping = shippings.first;

        if (state is CheckoutShippingSelected) {
          selectedShipping = state.shipping;
        }

        return ListView.separated(
          shrinkWrap: true,
          padding: EdgeInsets.zero,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: shippings.length,
          separatorBuilder: (_, __) => const SizedBox(height: 10),
          itemBuilder: (_, index) {
            final shipping = shippings[index];
            final isSelected = shipping == selectedShipping;

            return AppListTileWidget(
              isSelected: isSelected,
              onTap: () => cubit.selectShipping(shipping),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(shipping.name, style: context.labelSmall),
                      const SizedBox(height: 4),
                      Text(
                        shipping.duration,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: context.bodyMedium,
                      ),
                    ],
                  ),
                  const Spacer(),
                  if (shipping.cost == 0)
                    Text(
                      'checkout.summary.free'.tr(),
                      style: context.labelMedium.copyWith(
                        color: AppColors.secondary,
                      ),
                    )
                  else
                    Text(
                      shipping.cost.toString(),
                      style: context.labelMedium,
                    ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}
