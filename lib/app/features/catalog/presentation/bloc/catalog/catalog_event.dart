part of 'catalog_bloc.dart';

sealed class CatalogEvent {
  const CatalogEvent();
}

final class CatalogGetProducts extends CatalogEvent {
  const CatalogGetProducts({
    this.searchTerm,
    this.filters,
    this.reset = false,
  });

  final String? searchTerm;
  final ProductFilters? filters;
  final bool reset;
}
