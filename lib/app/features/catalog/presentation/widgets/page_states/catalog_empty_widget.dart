import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../../../../shared/extensions/text_theme_extension.dart';
import '../../../../../shared/widgets/app_icon_widget.dart';

class CatalogEmptyWidget extends StatelessWidget {
  const CatalogEmptyWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const SizedBox(height: 40),
        const AppIconWidget.svgAsset('compass', size: 24),
        const SizedBox(height: 20),
        Text(
          'catalog.empty.title'.tr(),
          style: context.labelLarge,
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 20),
        Text(
          'catalog.empty.description'.tr(),
          style: context.bodyMedium,
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}
