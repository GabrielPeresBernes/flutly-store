import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../domain/entities/product_filters.dart';

part 'catalog_filters_state.dart';

enum SortOption {
  popularity('catalog.filters.sort.popularity'),
  priceHighToLow('catalog.filters.sort.price_high_to_low'),
  priceLowToHigh('catalog.filters.sort.price_low_to_high'),
  unsorted('catalog.filters.sort.unsorted');

  const SortOption(this.labelKey);

  final String labelKey;

  String get label => labelKey.tr();

  @override
  String toString() => label;
}

class CatalogFiltersCubit extends Cubit<CatalogFiltersState> {
  CatalogFiltersCubit() : super(const CatalogFiltersInitial());

  SortOption selectedSortOption = SortOption.unsorted;
  String minPrice = '';
  String maxPrice = '';

  Future<void> applyFilters({
    String? minPrice,
    String? maxPrice,
    SortOption? selectedSortOption,
  }) async {
    this.minPrice = minPrice ?? this.minPrice;
    this.maxPrice = maxPrice ?? this.maxPrice;
    this.selectedSortOption = selectedSortOption ?? this.selectedSortOption;

    String? sortBy;
    String? order;

    switch (this.selectedSortOption) {
      case SortOption.popularity:
        sortBy = 'rating';
        order = 'desc';
        break;
      case SortOption.priceHighToLow:
        sortBy = 'price';
        order = 'desc';
        break;
      case SortOption.priceLowToHigh:
        sortBy = 'price';
        order = 'asc';
        break;
      case SortOption.unsorted:
        break;
    }

    emit(
      CatalogFiltersApplied(
        filters: ProductFilters(
          minPrice: double.tryParse(this.minPrice),
          maxPrice: double.tryParse(this.maxPrice),
          sortBy: sortBy,
          order: order,
        ),
      ),
    );
  }

  Future<void> clearFilters() async {
    selectedSortOption = SortOption.unsorted;
    minPrice = '';
    maxPrice = '';
    emit(const CatalogFiltersEmpty());
  }

  int get appliedFiltersCount {
    var count = 0;

    if (state.filters?.minPrice != null) {
      count++;
    }

    if (state.filters?.maxPrice != null) {
      count++;
    }

    if (selectedSortOption != SortOption.unsorted) {
      count++;
    }

    return count;
  }
}
