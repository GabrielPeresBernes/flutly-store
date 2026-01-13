import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../shared/extensions/text_theme_extension.dart';
import '../../../../../shared/widgets/app_list_tile_widget.dart';
import '../../../domain/entities/address.dart';
import '../../bloc/checkout/checkout_cubit.dart';

class AddressLoadedWidget extends StatelessWidget {
  const AddressLoadedWidget({
    super.key,
    required this.addresses,
  });

  final List<Address> addresses;

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<CheckoutCubit>();

    return BlocBuilder<CheckoutCubit, CheckoutState>(
      buildWhen: (previous, current) => current is CheckoutAddressSelected,
      builder: (context, state) {
        var selectedAddress = addresses.first;

        if (state is CheckoutAddressSelected) {
          selectedAddress = state.address;
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ListView.separated(
              shrinkWrap: true,
              padding: EdgeInsets.zero,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: addresses.length,
              separatorBuilder: (_, __) => const SizedBox(height: 10),
              itemBuilder: (_, index) {
                final address = addresses[index];
                final isSelected = address == selectedAddress;

                return AppListTileWidget(
                  isSelected: isSelected,
                  actionIcon: 'edit',
                  onTap: () => cubit.selectAddress(address),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(address.title, style: context.labelSmall),
                      const SizedBox(height: 4),
                      Text(
                        address.fullAddress,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: context.bodyMedium,
                      ),
                    ],
                  ),
                );
              },
            ),
            const SizedBox(height: 5),
            TextButton(
              onPressed: () {},
              child: Text('checkout.actions.new_address'.tr()),
            ),
          ],
        );
      },
    );
  }
}
