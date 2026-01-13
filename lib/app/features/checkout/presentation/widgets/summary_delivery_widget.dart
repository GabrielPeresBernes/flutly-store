import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../../../shared/extensions/text_theme_extension.dart';
import '../../domain/entities/shipping.dart';
import 'summary_item_widget.dart';

class SummaryDeliveryWidget extends StatelessWidget {
  const SummaryDeliveryWidget({
    super.key,
    required this.shipping,
  });

  final Shipping shipping;

  @override
  Widget build(BuildContext context) {
    return SummaryItemWidget(
      title: 'checkout.sections.delivery'.tr(),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(shipping.name, style: context.bodyMedium),
          Text(shipping.duration, style: context.bodyMedium),
        ],
      ),
    );
  }
}
