import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../shared/extensions/show_app_bottom_sheet_extension.dart';
import '../../../../shared/extensions/text_theme_extension.dart';
import '../../../../shared/theme/tokens/color_tokens.dart';
import '../../../../shared/widgets/app_icon_widget.dart';
import '../bloc/catalog_filters_cubit.dart';
import 'filters_bottom_sheet_widget.dart';

class FiltersButtonWidget extends StatelessWidget {
  const FiltersButtonWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<CatalogFiltersCubit>();

    return BlocBuilder<CatalogFiltersCubit, CatalogFiltersState>(
      builder: (context, state) {
        final appliedFiltersCount = cubit.appliedFiltersCount;
        return SizedBox(
          height: 40,
          child: OutlinedButton(
            onPressed: () => context.showAppBottomSheet(
              child: FiltersBottomSheetWidget(cubit: cubit),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              spacing: 8,
              children: [
                if (appliedFiltersCount > 0)
                  Container(
                    padding: const EdgeInsets.all(6),
                    decoration: const BoxDecoration(
                      color: AppColors.primary,
                      shape: BoxShape.circle,
                    ),
                    child: Text(
                      appliedFiltersCount.toString(),
                      style: context.labelSmall.copyWith(
                        color: AppColors.white,
                      ),
                    ),
                  )
                else
                  const AppIconWidget.svgAsset('sliders', size: 20),
                Text('catalog.filters.title'.tr(), style: context.bodyMedium),
              ],
            ),
          ),
        );
      },
    );
  }
}
