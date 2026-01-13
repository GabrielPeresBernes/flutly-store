part of 'product_recommendation_cubit.dart';

sealed class ProductRecommendationState {
  const ProductRecommendationState();
}

final class ProductRecommendationInitial extends ProductRecommendationState {
  const ProductRecommendationInitial();
}

final class ProductRecommendationLoading extends ProductRecommendationState {
  const ProductRecommendationLoading();
}

final class ProductRecommendationLoaded extends ProductRecommendationState {
  const ProductRecommendationLoaded({required this.products});

  final List<Product> products;
}

final class ProductRecommendationFailure extends ProductRecommendationState {
  const ProductRecommendationFailure({required this.exception});

  final AppException exception;
}
