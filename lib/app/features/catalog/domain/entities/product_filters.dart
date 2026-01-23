class ProductFilters {
  const ProductFilters({
    this.sortBy,
    this.order,
    this.minPrice,
    this.maxPrice,
  });

  final String? sortBy;
  final String? order;
  final double? minPrice;
  final double? maxPrice;
}
