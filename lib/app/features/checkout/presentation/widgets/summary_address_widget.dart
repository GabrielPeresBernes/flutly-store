import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../../../shared/extensions/text_theme_extension.dart';
import '../../domain/entities/address.dart';
import 'summary_item_widget.dart';

class SummaryAddressWidget extends StatelessWidget {
  const SummaryAddressWidget({
    super.key,
    required this.address,
  });

  final Address address;

  @override
  Widget build(BuildContext context) {
    return SummaryItemWidget(
      title: 'checkout.sections.address'.tr(),
      child: Text(
        address.fullAddress,
        style: context.bodyMedium,
      ),
    );
  }
}
