import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../shared/errors/app_exception.dart';
import '../../../product/domain/entities/product.dart';
import '../../../search/domain/repositories/search_repository.dart';

part 'cart_popular_products_state.dart';

class CartPopularProductsCubit extends Cubit<CartPopularProductsState> {
  CartPopularProductsCubit(this._searchRepository)
    : super(const CartPopularProductsInitial());

  final SearchRepository _searchRepository;

  Future<void> getProducts() async {
    emit(const CartPopularProductsLoading());

    final response = await _searchRepository.getPopularProducts().run();

    response.fold(
      (exception) => emit(CartPopularProductsFailure(exception: exception)),
      (products) => emit(CartPopularProductsLoaded(products: products)),
    );
  }
}
