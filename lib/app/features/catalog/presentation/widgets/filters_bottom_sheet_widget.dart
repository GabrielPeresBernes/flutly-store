import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../../../shared/extensions/text_theme_extension.dart';
import '../../../../shared/widgets/app_bottom_sheet_widget.dart';
import '../../../../shared/widgets/buttons/app_elevated_button_widget.dart';
import '../../../../shared/widgets/buttons/app_outlined_button_widget.dart';
import '../../../../shared/widgets/inputs/app_text_field_widget.dart';
import '../bloc/catalog_filters_cubit.dart';

class FiltersBottomSheetWidget extends StatefulWidget {
  const FiltersBottomSheetWidget({
    super.key,
    required this.cubit,
  });

  final CatalogFiltersCubit cubit;

  @override
  State<FiltersBottomSheetWidget> createState() =>
      _FiltersBottomSheetWidgetState();
}

class _FiltersBottomSheetWidgetState extends State<FiltersBottomSheetWidget> {
  SortOption _selectedSortOption = SortOption.unsorted;
  TextEditingController? _minPriceController;
  TextEditingController? _maxPriceController;

  @override
  void initState() {
    super.initState();
    _selectedSortOption = widget.cubit.selectedSortOption;
    _minPriceController = TextEditingController(text: widget.cubit.minPrice);
    _maxPriceController = TextEditingController(text: widget.cubit.maxPrice);
  }

  @override
  void dispose() {
    _minPriceController?.dispose();
    _maxPriceController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AppBottomSheetWidget(
      title: 'catalog.filters.title'.tr(),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('catalog.filters.sort_by'.tr(), style: context.bodyLarge),
          const SizedBox(height: 10),
          Wrap(
            spacing: 12,
            runSpacing: 12,
            children: SortOption.values.map((sortOption) {
              if (sortOption == SortOption.unsorted) {
                return const SizedBox.shrink();
              }

              final isSelected = sortOption == _selectedSortOption;

              return ChoiceChip(
                label: Text(sortOption.label),
                selected: isSelected,
                onSelected: (selected) => setState(
                  () => _selectedSortOption = selected
                      ? sortOption
                      : SortOption.unsorted,
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 35),
          Text('catalog.filters.price_range'.tr(), style: context.bodyLarge),
          const SizedBox(height: 10),
          SizedBox(
            height: 45,
            child: Row(
              children: [
                Expanded(
                  child: AppTextFieldWidget(
                    controller: _minPriceController,
                    hintText: 'catalog.filters.min_price'.tr(),
                    keyboardType: TextInputType.number,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: AppTextFieldWidget(
                    controller: _maxPriceController,
                    hintText: 'catalog.filters.max_price'.tr(),
                    keyboardType: TextInputType.number,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 35),
          Row(
            children: [
              Expanded(
                child: AppElevatedButtonWidget(
                  label: 'catalog.filters.apply'.tr(),
                  onPressed: () {
                    widget.cubit.applyFilters(
                      minPrice: _minPriceController?.text,
                      maxPrice: _maxPriceController?.text,
                      selectedSortOption: _selectedSortOption,
                    );
                    Navigator.pop(context);
                  },
                ),
              ),
              const SizedBox(width: 12),
              SizedBox(
                height: 50,
                child: AppOutlinedButtonWidget(
                  label: 'catalog.filters.clear'.tr(),
                  onPressed: () {
                    widget.cubit.clearFilters();
                    Navigator.pop(context);
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
