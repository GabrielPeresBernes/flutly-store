part of 'catalog_filters_cubit.dart';

sealed class CatalogFiltersState {
  const CatalogFiltersState({
    this.filters,
    this.sort,
  });

  final ProductFilters? filters;
  final SortOption? sort;
}

final class CatalogFiltersInitial extends CatalogFiltersState {
  const CatalogFiltersInitial() : super(filters: null);
}

final class CatalogFiltersApplied extends CatalogFiltersState {
  const CatalogFiltersApplied({required super.filters});
}
