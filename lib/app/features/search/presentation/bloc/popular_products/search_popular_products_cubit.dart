import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../shared/errors/app_exception.dart';
import '../../../../product/domain/entities/product.dart';
import '../../../domain/repositories/search_repository.dart';

part 'search_popular_products_state.dart';

class SearchPopularProductsCubit extends Cubit<SearchPopularProductsState> {
  SearchPopularProductsCubit(this._searchRepository)
    : super(const SearchPopularProductsInitial());

  final SearchRepository _searchRepository;

  Future<void> getPopularProducts() async {
    emit(const SearchPopularProductsLoading());

    final result = await _searchRepository.getPopularProducts().run();

    result.fold(
      (exception) => emit(SearchPopularProductsFailure(exception: exception)),
      (products) => emit(SearchPopularProductsLoaded(products)),
    );
  }
}
