import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../shared/errors/app_exception.dart';
import '../../../domain/entities/product.dart';
import '../../../domain/repositories/product_repository.dart';

part 'product_recommendation_state.dart';

class ProductRecommendationCubit extends Cubit<ProductRecommendationState> {
  ProductRecommendationCubit(this._productRepository)
    : super(const ProductRecommendationInitial());

  final ProductRepository _productRepository;

  Future<void> getRecommendations({int? forProductId}) async {
    emit(const ProductRecommendationLoading());

    if (forProductId == null) {
      emit(const ProductRecommendationLoaded(products: []));
      return;
    }

    final response = await _productRepository
        .getRecommendations(forProductId)
        .run();

    response.fold(
      (exception) => emit(ProductRecommendationFailure(exception: exception)),
      (products) => emit(ProductRecommendationLoaded(products: products)),
    );
  }
}
