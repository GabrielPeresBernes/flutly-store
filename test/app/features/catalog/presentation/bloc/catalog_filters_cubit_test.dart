import 'package:bloc_test/bloc_test.dart';
import 'package:flutly_store/app/features/catalog/presentation/bloc/catalog_filters_cubit.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  blocTest<CatalogFiltersCubit, CatalogFiltersState>(
    'applyFilters emits filters with parsed values and sort mapping',
    build: CatalogFiltersCubit.new,
    act: (cubit) => cubit.applyFilters(
      minPrice: '10',
      maxPrice: '50',
      selectedSortOption: SortOption.priceLowToHigh,
    ),
    expect: () => [
      isA<CatalogFiltersApplied>()
          .having((state) => state.filters?.minPrice, 'minPrice', 10.0)
          .having((state) => state.filters?.maxPrice, 'maxPrice', 50.0)
          .having((state) => state.filters?.sortBy, 'sortBy', 'price')
          .having((state) => state.filters?.order, 'order', 'asc'),
    ],
    verify: (cubit) {
      expect(cubit.appliedFiltersCount, 3);
    },
  );

  blocTest<CatalogFiltersCubit, CatalogFiltersState>(
    'clearFilters resets state and counters',
    build: CatalogFiltersCubit.new,
    act: (cubit) async {
      await cubit.applyFilters(
        minPrice: '10',
        selectedSortOption: SortOption.popularity,
      );
      await cubit.clearFilters();
    },
    expect: () => [
      isA<CatalogFiltersApplied>(),
      isA<CatalogFiltersEmpty>(),
    ],
    verify: (cubit) {
      expect(cubit.appliedFiltersCount, 0);
    },
  );
}
